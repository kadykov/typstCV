ARG FEDORA_VERSION=41
ARG ALPINE_VERSION=3.20

FROM alpine:${ALPINE_VERSION} AS builder

ARG TYPST_VERSION=v0.12.0

RUN wget -qO typst.tar.xz https://github.com/typst/typst/releases/download/${TYPST_VERSION}/typst-x86_64-unknown-linux-musl.tar.xz \
    && tar xf typst.tar.xz

FROM fedora:${FEDORA_VERSION}

COPY --from=builder typst-x86_64-unknown-linux-musl/typst /usr/bin/typst

ARG PANDOC_VERSION=3.1.11.1
ARG JUST_VERSION=1.35.0
ARG FIRA_SANS_VERSION=4.202
ARG IBM_PLEX_VERSION=6.4.0
ARG FONTAWESOME_VERSION=6.6.0
RUN dnf update -yq \
    && dnf install -yq \
        just-${JUST_VERSION} \
        pandoc-${PANDOC_VERSION} \
        mozilla-fira-sans-fonts-${FIRA_SANS_VERSION} \
        ibm-plex-serif-fonts-${IBM_PLEX_VERSION} \
        fontawesome-6-brands-fonts-${FONTAWESOME_VERSION} \
        fontawesome-6-free-fonts-${FONTAWESOME_VERSION} \
    && dnf clean all

ENV TYPST_FONT_PATHS=/usr/share/fonts/

ENV PANDOC_DATA_DIR=/usr/share/pandoc-${PANDOC_VERSION}/

COPY typst-cv.typ typst-letter.typ ${PANDOC_DATA_DIR}/data/templates/
COPY *.lua ${PANDOC_DATA_DIR}/filters/

ARG PANDOC_CV_VERSION=0.1.0
ENV TYPST_PACKAGE_PATH=/usr/local/share/typst/packages/
COPY style.typ typst.toml ${TYPST_PACKAGE_PATH}/local/pandoc-cv/${PANDOC_CV_VERSION}/

WORKDIR /data
COPY justfile kadykov-*.md /data/

ENTRYPOINT [ "just", "build" ]
