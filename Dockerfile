ARG FEDORA_VERSION=41
ARG ALPINE_VERSION=3.20
ARG TYPST_FONTAWESOME_VERSION=0.5.0

FROM alpine:${ALPINE_VERSION} AS builder

ARG TYPST_VERSION=v0.12.0

RUN wget -qO typst.tar.xz https://github.com/typst/typst/releases/download/${TYPST_VERSION}/typst-x86_64-unknown-linux-musl.tar.xz \
    && tar xf typst.tar.xz

ARG TYPST_FONTAWESOME_VERSION
RUN wget -qO typst-fontawesome.tar.gz https://packages.typst.org/preview/fontawesome-${TYPST_FONTAWESOME_VERSION}.tar.gz \
    && mkdir /fontawesome \
    && tar xf typst-fontawesome.tar.gz -C /fontawesome

FROM fedora:${FEDORA_VERSION}

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
        poppler-utils \ # Added for pdftotext used in E2E tests
    && dnf clean all

ENV PANDOC_DATA_DIR=/usr/share/pandoc-${PANDOC_VERSION}/

COPY typst-cv.typ typst-letter.typ ${PANDOC_DATA_DIR}/data/templates/
COPY *.lua ${PANDOC_DATA_DIR}/filters/

COPY --from=builder typst-x86_64-unknown-linux-musl/typst /usr/bin/typst

ARG PANDOC_CV_VERSION=0.1.0
ENV TYPST_PACKAGE_PATH=/usr/local/share/typst/packages/
COPY style.typ typst.toml ${TYPST_PACKAGE_PATH}/local/pandoc-cv/${PANDOC_CV_VERSION}/

ARG TYPST_FONTAWESOME_VERSION
COPY --from=builder /fontawesome/*.typ /fontawesome/typst.toml ${TYPST_PACKAGE_PATH}/preview/fontawesome/${TYPST_FONTAWESOME_VERSION}/

ENV TYPST_FONT_PATHS=/usr/share/fonts/

COPY build.sh /usr/local/bin/build.sh
RUN chmod +x /usr/local/bin/build.sh

WORKDIR /data

ENTRYPOINT [ "build.sh" ]
