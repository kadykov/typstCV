# === BUILDER STAGE: Install fonts with fontist ===
FROM ruby:3.4-slim AS fonts-builder
RUN apt-get update && apt-get install -y --no-install-recommends \
    git build-essential \
    && rm -rf /var/lib/apt/lists/*
RUN gem install fontist --no-document --version "~> 1.21.1"
COPY fontist-manifest.yml .
RUN fontist update --quiet \
    && fontist manifest-install --quiet fontist-manifest.yml \
    && fontist cache clear --quiet \
    && chmod -R 644 /root/.fontist/fonts

# === BUILDER STAGE: Install Typst and packages ===
FROM alpine:3.21 AS typst-builder
# Install dependencies needed for download (wget), extraction (tar with xz support), and git (for packages)
RUN apk add --no-cache wget tar xz git
# Install Typst v0.13.1 manually
ARG TYPST_VERSION=v0.13.1
ARG TARGET=x86_64-unknown-linux-musl
RUN wget -qO typst.tar.xz https://github.com/typst/typst/releases/download/${TYPST_VERSION}/typst-${TARGET}.tar.xz \
    && tar xf typst.tar.xz \
    && mv typst-${TARGET}/typst /usr/local/bin/typst \
    && chmod +x /usr/local/bin/typst \
    && rm -rf typst.tar.xz typst-${TARGET} \
    && typst --version
# Download and extract typst-fontawesome v0.5.0 manually
ARG TYPST_FONTAWESOME_VERSION=0.5.0
ENV TYPST_PACKAGE_PATH=/root/.local/share/typst/packages
RUN mkdir -p $TYPST_PACKAGE_PATH/preview/fontawesome/${TYPST_FONTAWESOME_VERSION}/ \
    && wget -qO typst-fontawesome.tar.gz https://packages.typst.org/preview/fontawesome-${TYPST_FONTAWESOME_VERSION}.tar.gz \
    && tar xf typst-fontawesome.tar.gz -C $TYPST_PACKAGE_PATH/preview/fontawesome/${TYPST_FONTAWESOME_VERSION}/ \
    && rm typst-fontawesome.tar.gz

# === BUILDER STAGE: Install Font Awesome from GitHub Release ===
FROM alpine:3.21 AS fa-builder
ARG FA_VERSION=6.7.2
RUN apk add --no-cache wget unzip
RUN mkdir -p /fa-fonts \
    && wget -qO /tmp/fontawesome.zip https://github.com/FortAwesome/Font-Awesome/releases/download/${FA_VERSION}/fontawesome-free-${FA_VERSION}-desktop.zip \
    && unzip -q /tmp/fontawesome.zip -d /tmp/fontawesome-extract 'fontawesome-free-*-desktop/otfs/*' \
    && mv /tmp/fontawesome-extract/fontawesome-free-*-desktop/otfs/*.otf /fa-fonts/ \
    && rm -rf /tmp/fontawesome.zip /tmp/fontawesome-extract

# === FINAL STAGE: Alpine Production Image ===
FROM alpine:3.21

# Install runtime dependencies: bash, pandoc, fontconfig, font-awesome
# Git, wget, tar are NOT needed here anymore as they are copied/handled in builder stages
# Font Awesome is copied from fa-builder, not installed via apk
RUN apk add --no-cache \
    bash \
    pandoc \
    fontconfig \
    && rm -rf /var/cache/apk/*

# --- Copy Assets from Builders ---
# Copy Typst binary
COPY --from=typst-builder /usr/local/bin/typst /usr/local/bin/typst
# Copy Typst packages (fontawesome)
COPY --from=typst-builder /root/.local/share/typst/packages /usr/share/typst/packages
# Copy fonts from fontist builder
COPY --from=fonts-builder /root/.fontist/fonts/ /usr/share/fonts/fontist/
# Copy fonts from Font Awesome builder
COPY --from=fa-builder /fa-fonts/ /usr/share/fonts/fontawesome6/

# --- Configure Environment ---
# Define paths
ENV PANDOC_DATA_DIR=/usr/share/pandoc
ENV TYPST_PACKAGE_PATH=/usr/share/typst/packages
# Reset font paths to only include font directories
ENV TYPST_FONT_PATHS=/usr/share/fonts

# Create necessary directories (including the local package structure)
RUN mkdir -p $PANDOC_DATA_DIR/filters \
             $PANDOC_DATA_DIR/templates \
             $TYPST_PACKAGE_PATH/local/pandoc-cv/0.1.0 \
             /data

# Update font cache AFTER copying fonts and setting path
RUN fc-cache -fv

# --- Copy Project Files ---
COPY build.sh /usr/local/bin/build.sh
COPY linkify.lua $PANDOC_DATA_DIR/filters/linkify.lua
COPY typst-cv.lua $PANDOC_DATA_DIR/filters/typst-cv.lua
COPY typst-cv.typ $PANDOC_DATA_DIR/templates/typst-cv.typ
COPY typst-letter.typ $PANDOC_DATA_DIR/templates/typst-letter.typ
# Copy style.typ and typst.toml to the local package directory
COPY style.typ $TYPST_PACKAGE_PATH/local/pandoc-cv/0.1.0/style.typ
COPY typst.toml $TYPST_PACKAGE_PATH/local/pandoc-cv/0.1.0/typst.toml

# Ensure build.sh is executable
RUN chmod +x /usr/local/bin/build.sh

# --- Final Setup ---
# Set working directory
WORKDIR /data

# Set entrypoint
ENTRYPOINT ["build.sh"]

# Default command (optional, can be overridden)
CMD ["--help"]
