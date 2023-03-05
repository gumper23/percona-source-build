FROM ubuntu:20.04

RUN set -x && \
    DEBIAN_FRONTEND='noninteractive' TZ='Etc/UTC' \
    apt-get update && \
    apt-get install -y wget debsums vim silversearcher-ag && \
    rm -Rf /var/lib/apt/lists/*
