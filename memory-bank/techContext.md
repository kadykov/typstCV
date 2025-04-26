# Technical Context: Typst CV/Letter Generator

## Core Technologies

-   **Pandoc:** Universal document converter. Used for Markdown parsing, YAML metadata extraction, Lua filter execution, and applying Typst templates. Version specified in `Dockerfile`.
-   **Typst:** Modern typesetting system. Used for final PDF rendering. Version specified in `Dockerfile`.
-   **Lua:** Scripting language used for Pandoc filters (`linkify.lua`, `typst-cv.lua`). Filters are executed by Pandoc.
-   **Markdown:** Input format (CommonMark with Pandoc extensions like YAML frontmatter, attributes, classes).
-   **YAML:** Used within Markdown frontmatter for metadata (`author`, `title`, `links`, etc.).
-   **Shell Script (Bash/sh):** Proposed for `build.sh` to replace `justfile`. Needs to be POSIX-compliant for broader compatibility (especially within minimal Docker containers like Alpine, though the current base is Fedora).
-   **Docker:** Containerization platform used for packaging and distribution. `Dockerfile` defines the image build process.
-   **Just:** Task runner used for local development tasks (linting, testing, building examples). Invoked via `just <task>`.
-   **Bats (Bash Automated Testing System):** Used for unit testing `build.sh`. Installed via Git submodule in `tests/bats`. Includes `bats-support` and `bats-assert` helpers.

## Key Files & Locations (within Docker image)

-   **Pandoc Filters (`*.lua`):** Copied to `$PANDOC_DATA_DIR/filters/` (e.g., `/usr/share/pandoc-3.1.11.1/filters/`).
-   **Pandoc Templates (`typst-*.typ`):** Copied to `$PANDOC_DATA_DIR/data/templates/` (e.g., `/usr/share/pandoc-3.1.11.1/data/templates/`).
-   **Typst Style Package (`style.typ`, `typst.toml`):** Copied to `$TYPST_PACKAGE_PATH/local/pandoc-cv/0.1.0/` (e.g., `/usr/local/share/typst/packages/local/pandoc-cv/0.1.0/`).
-   **Typst Executable:** `/usr/bin/typst`.
-   **Fonts:** Installed via `dnf` into system font directories (e.g., `/usr/share/fonts/`). `TYPST_FONT_PATHS` environment variable points Typst to these.
-   **Build Script (`build.sh` - Proposed):** To be copied likely to `/usr/local/bin/`.
-   **Working Directory:** `/data` (users mount their project here).

## Dependencies & Versions

-   Specific versions of Fedora, Alpine (for builder stage), Pandoc, Just, Typst, and fonts are pinned in the `Dockerfile`. This ensures reproducibility.
-   External Typst packages (`@preview/fontawesome`) are also versioned.

## Build/Execution/Testing Environment

-   Builds and final execution are designed to run within the provided Docker container (`kadykov/typst-cv`), which includes all necessary dependencies (Pandoc, Typst, Lua filters, Typst packages, fonts).
-   Local development and testing utilize the devcontainer environment, which includes `bats-core`, `just`, `pre-commit`, and other development tools.
-   The `build.sh` script relies on standard POSIX shell commands and the installed tools (Pandoc, Typst).
-   Tests (`bats`, `sh`) are run from the project root.
-   CI (GitHub Actions) runs linters and then executes the test suite inside the built Docker container.
-   Environment variables (`TYPSTCV_*`, `PANDOC_DATA_DIR`, `TYPST_PACKAGE_PATH`, `TYPST_FONT_PATHS`) play a role in configuration, especially within Docker/CI.

## Constraints

-   The system relies on specific versions of tools being available.
-   Correct placement of filters, templates, and packages within the Docker image (or host system if run outside Docker) is crucial.
-   Font availability is essential for correct rendering.
