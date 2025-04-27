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
