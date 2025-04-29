# Technical Context: Typst CV/Letter Generator

## Core Technologies

-   **Pandoc:** Universal document converter. Used for Markdown parsing, YAML metadata extraction, Lua filter execution, and applying Typst templates. Version specified in `Dockerfile`.
-   **Typst:** Modern typesetting system. Used for final PDF rendering. Version specified in `Dockerfile`.
-   **Lua:** Scripting language used for Pandoc filters (`linkify.lua`, `typst-cv.lua`). Filters are executed by Pandoc.
-   **Markdown:** Input format (CommonMark with Pandoc extensions like YAML frontmatter, attributes, classes).
-   **YAML:** Used within Markdown frontmatter for metadata (`author`, `title`, `links`, etc.).
-   **Shell Script (Bash):** `build.sh` orchestrates the build process.
-   **Docker:** Containerization platform.
    -   `Dockerfile`: Defines the primary **Alpine-based production image**. Uses multi-stage builds for fonts and Typst installation.
    -   `Dockerfile.fedora`: Previous Fedora-based image (potentially deprecated).
    -   `.devcontainer/Dockerfile`: Defines the **Alpine-based development environment** with dev tools and Docker-in-Docker.
-   **Just:** Task runner for local development (linting, testing, building examples, building Docker images). Invoked via `just <task>`.
-   **Bats (Bash Automated Testing System):** Used for unit tests (`tests/unit/build_sh.bats`), filter tests (`tests/filter/filters.bats`), and Docker usage tests (`tests/docker.bats`). Installed via Git submodule in `tests/bats`. Includes `bats-support` and `bats-assert` helpers.

## Key Files & Locations (within Production Docker image - `Dockerfile`)

-   **Pandoc Filters (`*.lua`):** Copied to `$PANDOC_DATA_DIR/filters/` (e.g., `/usr/share/pandoc/filters/`).
-   **Pandoc Templates (`typst-*.typ`):** Copied to `$PANDOC_DATA_DIR/templates/` (e.g., `/usr/share/pandoc/templates/`).
-   **Typst Style File (`style.typ`):** Copied to `/app/lib/style.typ`. Not treated as a package anymore.
-   **Typst Executable:** `/usr/local/bin/typst` (Manually installed v0.12.0).
-   **Typst Packages (`fontawesome`):** Copied from builder stage to `$TYPST_PACKAGE_PATH` (e.g., `/usr/share/typst/packages`).
-   **Fonts:** Installed via `fontist` (builder stage) and `apk` into system font directories (e.g., `/usr/share/fonts/`). `TYPST_FONT_PATHS` environment variable points Typst to font directories *and* `/app/lib` (for `style.typ` import).
-   **Build Script (`build.sh`):** Copied to `/usr/local/bin/build.sh`.
-   **Working Directory:** `/data` (users mount their project here).

## Dependencies & Versions (Production Image - `Dockerfile`)

-   Base Image: Alpine 3.21.
-   Builder Stages: Ruby 3.2-slim (for fontist), Alpine 3.21 (for Typst).
-   Runtime Dependencies (installed via `apk`): `bash`, `pandoc`, `fontconfig`, `font-awesome`.
-   Manually Installed: Typst v0.12.0 (downloaded binary).
-   Typst Packages: `@preview/fontawesome` (installed via `typst update` in builder stage).
-   Fonts: Installed via `fontist` (using `fontist-manifest.yml`) and `apk`.
-   `git`, `wget`, `tar` are only present in builder stages.

## Build/Execution/Testing Environment

-   **Production Execution:** Designed to run within the built Docker container (based on `Dockerfile`), which includes runtime dependencies. User mounts their source files to `/data`.
-   **Local Development:** Utilizes the **Alpine-based devcontainer** environment (`.devcontainer/Dockerfile`), which includes dev tools (`just`, `pre-commit`, `shellcheck`, etc.) and **Docker-in-Docker**.
-   **Build Script (`build.sh`):** Relies on standard shell commands and tools available in the production container (Pandoc, Typst).
-   **Testing:**
    -   Unit, Filter, E2E tests (`bats`, `sh`) are run *inside* the built production container in CI, mounting only `tests/fixtures`.
    -   Docker usage tests (`tests/docker.bats`) are run *on the CI host* against the built production container.
    -   Local testing uses `just test`.
-   **CI (GitHub Actions):**
    -   Runs linters (`pre-commit`).
    -   Builds the production Docker image (`Dockerfile`).
    -   Runs unit, filter, E2E tests inside the container.
    -   Runs Docker usage tests on the host.
    -   Builds example PDFs using the container.
    -   Pushes tagged images to Docker Hub.
    -   Creates GitHub Releases.
-   **Environment Variables:** `TYPSTCV_*` (for overrides), `PANDOC_DATA_DIR`, `TYPST_PACKAGE_PATH`, `TYPST_FONT_PATHS`, `APP_LIB_DIR` play roles in configuration within the Docker image.

## Constraints

-   Relies on specific versions of tools (Typst, fontist) pinned in `Dockerfile`.
-   Correct placement of filters, templates, and `style.typ` within the Docker image is crucial.
-   Font availability (via fontist and apk) is essential.
-   Network access is required during Docker build to download Typst and update packages.
