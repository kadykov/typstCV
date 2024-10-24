FROM alpine:3.20 AS Builder

ARG TYPST_VERSION=v0.12.0

RUN wget -qO typst.tar.xz https://github.com/typst/typst/releases/download/${TYPST_VERSION}/typst-x86_64-unknown-linux-musl.tar.xz \
    && tar xf typst.tar.xz

FROM fedora:40

COPY --from=Builder typst-x86_64-unknown-linux-musl/typst /usr/bin/typst

RUN dnf update -yq \
    && dnf install -yq \
        just \
        mozilla-fira-sans-fonts \
        ibm-plex-serif-fonts \
        fontawesome-6-brands-fonts \
        fontawesome-6-free-fonts \
    && dnf clean all
