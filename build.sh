#!/usr/bin/env bash

##############################################################################
# Downloads and setup
##############################################################################
if [[ ! -f percona-server-8.0_builder.sh ]]; then
    wget https://raw.githubusercontent.com/percona/percona-server/8.0/build-ps/percona-server-8.0_builder.sh
fi
mkdir -p /psp/build
bash ./percona-server-8.0_builder.sh --builddir=/psp/build --install_deps=1

if [[ ! -f boost.tar.gz ]]; then
    wget https://boostorg.jfrog.io/artifactory/main/release/1.77.0/source/boost_1_77_0.tar.gz -O boost.tar.gz
fi
if [[ ! -d boost ]] || [[ ! "$(ls -A boost)" ]]; then
    mkdir -p boost
    tar -xvzf boost.tar.gz -C boost --strip-components=1
fi
if [[ ! -f openssl.tar.gz ]]; then
    wget https://www.openssl.org/source/openssl-1.1.1t.tar.gz -O openssl.tar.gz
fi
if [[ ! -d openssl ]] || [[ ! "$(ls -A openssl)" ]]; then
    mkdir -p openssl
    tar -xvzf openssl.tar.gz -C openssl --strip-components=1
fi
if [[ ! -f percona-server.tar.gz ]]; then
    wget https://downloads.percona.com/downloads/Percona-Server-8.0/Percona-Server-8.0.31-23/source/tarball/percona-server-8.0.31-23.tar.gz -O percona-server.tar.gz
fi
if [[ ! -d percona-server ]] || [[ ! "$(ls -A percona-server)" ]]; then
    mkdir -p percona-server
    tar -xvzf percona-server.tar.gz -C percona-server --strip-components=1
fi

##############################################################################
# Compile OpenSSL
##############################################################################
if [[ ! -f libssl.so ]]; then
    cd /psp/openssl || exit 1
    ./config
    make -j"$(nproc)"
    make install -j"$(nproc)"
fi

##############################################################################
# Compile Percona Server
##############################################################################
if [[ ! -d /psp/build ]]; then
    mkdir -p /psp/build
fi
cd /psp/build || exit 1

##############################################################################
# https://smalldatum.blogspot.com/2023/02/adventures-in-compiling-mysql.html
##############################################################################
if [[ ! -f /psp/build/runtime_output_directory/mysqld ]]; then
    CMAKE_BUILD_PARALLEL_LEVEL="$(nproc)" cmake /psp/percona-server -DCMAKE_BUILD_TYPE=Release -DWITH_SSL=/psp/openssl -DWITH_ZLIB=bundled -DMYSQL_MAINTAINER_MODE=0 -DENABLED_LOCAL_INFILE=1 -DCMAKE_INSTALL_PREFIX=/usr -DWITH_BOOST=/psp/boost -DWITH_NUMA=ON -DWITH_ROUTER=OFF -DWITH_MYSQLX=OFF -DWITH_UNIT_TESTS=OFF -DWITH_AUTHENTICATION_LDAP=OFF
    time make -j"$(nproc)"
fi
