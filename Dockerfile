FROM ubuntu:20.04

RUN set -x && \
    apt-get update && \
    DEBIAN_FRONTEND='noninteractive' TZ='Etc/UTC' \
    apt-get install -y build-essential devscripts curl git wget && \
    apt-get install -y bison cmake debhelper fakeroot libaio-dev libmecab-dev \
        libreadline-dev libpam-dev libssl-dev libnuma-dev gcc g++ \
        libwrap0-dev libldap2-dev libcurl4-openssl-dev dh-systemd \
        libsasl2-dev libsasl2-modules libsasl2-modules-ldap \
        pkg-config gawk libjemalloc-dev vim silversearcher-ag && \
    rm -Rf /var/lib/apt/lists/*
