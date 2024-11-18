ARG FEDORA_VERSION=41
ARG ALPINE_VERSION=3.20

FROM alpine:${ALPINE_VERSION} AS builder

ARG TYPST_VERSION=v0.12.0

RUN wget -qO typst.tar.xz https://github.com/typst/typst/releases/download/${TYPST_VERSION}/typst-x86_64-unknown-linux-musl.tar.xz \
    && tar xf typst.tar.xz

FROM fedora:${FEDORA_VERSION}

COPY --from=builder typst-x86_64-unknown-linux-musl/typst /usr/bin/typst

# ARG PANDOC_VERSION=3.1.3-29.fc40.x86_64
ARG PANDOC_VERSION=3.1.11.1-32.fc41.x86_64
RUN dnf update -yq \
    && dnf install -yq \
        just \
        pandoc-${PANDOC_VERSION} \
        mozilla-fira-sans-fonts \
        ibm-plex-serif-fonts \
        fontawesome-6-brands-fonts \
        fontawesome-6-free-fonts \
    && dnf clean all

ENV TYPST_FONT_PATHS=/usr/share/fonts/

WORKDIR /data

# ARG PANDOC_VERSION_CORE=3.1.3
ARG PANDOC_VERSION_CORE=3.1.11.1
# COPY *.lua /usr/share/pandoc-${PANDOC_VERSION_CORE}/data/
# COPY typst-cv.typ typst-letter.typ /usr/share/pandoc-${PANDOC_VERSION_CORE}/data/templates/
ARG PANDOC_DIR=/usr/share/pandoc-${PANDOC_VERSION_CORE}
COPY typst-cv.typ typst-letter.typ ${PANDOC_DIR}/data/templates/
COPY *.lua /usr/local/share/pandoc/filters/
COPY *.lua ${PANDOC_DIR}/filters/

ARG PANDOC_CV_VERSION=0.1.0
ENV TYPST_PACKAGE_PATH=/usr/local/share/typst/packages/
COPY style.typ typst.toml ${TYPST_PACKAGE_PATH}/local/pandoc-cv/${PANDOC_CV_VERSION}/

COPY justfile .

ENTRYPOINT [ "just", "build" ]
