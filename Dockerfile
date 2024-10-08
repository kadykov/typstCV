# FROM mcr.microsoft.com/devcontainers/base:bookworm
FROM debian:12.7-slim

WORKDIR /tmp

ARG WGET_VERSION=1.21.3-1+b2
ARG XZ_UTILS_VERSION=5.4.1-0.2
ARG CA_CERTIFICATES_VERSION=20230311
ARG TYPST_VERSION=v0.11.1

RUN apt-get -q update \
    && apt-get install -qy --no-install-recommends \
        wget=${WGET_VERSION} \
        xz-utils=${XZ_UTILS_VERSION} \
        ca-certificates=${CA_CERTIFICATES_VERSION} \
    && wget -qO typst.tar.xz https://github.com/typst/typst/releases/download/${TYPST_VERSION}/typst-x86_64-unknown-linux-musl.tar.xz \
    && tar xf typst.tar.xz --strip-components=1 -C /usr/local/bin typst-x86_64-unknown-linux-musl/typst \
    && rm -rf typst.tar.xz \
    && apt-get purge -y --auto-remove \
        wget \
        xz-utils \
        ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* /var/tmp/*

WORKDIR /data
