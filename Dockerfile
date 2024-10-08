FROM alpine:3.20 AS Builder

ARG TYPST_VERSION=v0.11.1

RUN wget -qO typst.tar.xz https://github.com/typst/typst/releases/download/${TYPST_VERSION}/typst-x86_64-unknown-linux-musl.tar.xz \
    && tar xf typst.tar.xz

FROM debian:12.7-slim

COPY --from=Builder typst-x86_64-unknown-linux-musl/typst /usr/bin/typst
