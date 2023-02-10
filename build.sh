#!/usr/bin/env bash

# Bash strict mode:
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# https://github.com/percona/percona-server/branches
BRANCH='release-8.0.31-23'

function get_percona_source() {
    echo "Initializing Percona Server repository"

    if [[ ! -d percona-server ]]; then
        # Download and update percona server
        # https://docs.percona.com/percona-server/8.0/installation/compile-percona-server.html
        cd /psp &&
        git clone -b "${BRANCH}" --single-branch https://github.com/percona/percona-server.git &&
        pushd percona-server &&
            git submodule init &&
            git submodule update &&
            popd || exit 1
    else
        pushd percona-server &&
            git reset --hard HEAD &&
            git clean -xfd &&
            git checkout "${BRANCH}" &&
            popd || exit 1
    fi

    if [[ ! -d percona-server/debian ]]; then
        cp -ap percona-server/build-ps/debian percona-server/debian || exit 1
    fi

    echo "Finished initalizing Percona Server repository"
}

get_percona_source
