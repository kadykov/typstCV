FROM alpine:3.20 AS Builder

ARG TYPST_VERSION=v0.11.1

RUN wget -qO typst.tar.xz https://github.com/typst/typst/releases/download/${TYPST_VERSION}/typst-x86_64-unknown-linux-musl.tar.xz \
    && tar xf typst.tar.xz

FROM debian:12.7-slim

COPY --from=Builder typst-x86_64-unknown-linux-musl/typst /usr/bin/typst

ARG FONTS_IBM_PLEX_VERSION=6.1.1-1

RUN sed -i 's/main/main contrib/' /etc/apt/sources.list.d/debian.sources \
    && apt-get -q update \
    && apt-get install -qy --no-install-recommends \
        fonts-ibm-plex=${FONTS_IBM_PLEX_VERSION} \
    && apt-get purge -y --auto-remove software-properties-common \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/log/*
