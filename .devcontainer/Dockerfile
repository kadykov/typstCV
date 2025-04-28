# === BUILDER STAGE: Install fonts with fontist ===
FROM ruby:slim AS fonts-builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install fontist and required fonts
RUN gem install fontist --no-document

COPY fontist-manifest.yml .

RUN fontist update --quiet \
    && fontist manifest-install --quiet fontist-manifest.yml \
    && fontist cache clear --quiet \
    && chmod -R 644 /root/.fontist/fonts

# === FINAL STAGE: Alpine with copied fonts ===
FROM alpine:3.21

RUN apk add --no-cache \
    bash \
    git \
    pandoc \
    typst \
    shellcheck \
    just \
    poppler-utils \
    python3 \
    uv \
    pre-commit \
    nodejs \
    npm \
    fontconfig \
    font-awesome \
    font-awesome-free \
    font-awesome-brands \
    && rm -rf /var/cache/apk/*

# Copy all fonts from the builder stage at once
COPY --from=fonts-builder /root/.fontist/fonts/ /usr/share/fonts/fontist/

ENV TYPST_FONT_PATHS=/usr/share/fonts

# Update font cache
RUN fc-cache -fv

# --- Setup Local Typst Package Symlink for Development ---
# Define the target package path using the standard ENV var name
ENV TYPST_PACKAGE_PATH=/usr/local/share/typst/packages
ENV DEV_PKG_DIR=$TYPST_PACKAGE_PATH/local/pandoc-cv/0.1.0
# Create the directory structure
RUN mkdir -p $DEV_PKG_DIR
# Create symlinks from the workspace files to the package directory
# This assumes the devcontainer mounts the workspace at /workspaces/typstCV
# Use ln -sf to force link creation/overwrite if it exists
RUN ln -sf /workspaces/typstCV/style.typ $DEV_PKG_DIR/style.typ \
    && ln -sf /workspaces/typstCV/typst.toml $DEV_PKG_DIR/typst.toml
