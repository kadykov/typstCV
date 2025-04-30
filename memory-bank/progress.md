# Progress: Typst CV/Letter Generator (As of 2025-04-30)

## What Works (Current State)

-   **Core Pipeline:** Markdown-to-PDF conversion using `build.sh`, Pandoc, Lua filters, and Typst functions correctly.
-   **Interface:** Flexible `build.sh` CLI handles input/output options, type inference, stdin/stdout (for PDF), and metadata overrides (`--set`, `TYPSTCV_*`).
-   **Features:** Automatic linkification (`linkify.lua`), CV side content (`{photo}`, `{location}`, `{date}` via `typst-cv.lua`), hidden headings (`.hidden`), and full-width ordered lists are functional.
-   **Examples:** Generic, depersonalized example files (`example-cv.md`, `example-letter.md`) and placeholder image exist in `tests/fixtures/`.
-   **Testing:**
    -   Unit tests (`bats`) for `build.sh` logic exist and pass.
    -   Filter tests (`bats`) comparing Pandoc output against snapshots exist and pass.
    -   E2E smoke tests (`sh`) verifying PDF generation for examples exist and pass.
    -   Docker usage tests (`bats`) verify production container interaction.
    -   `justfile` provides convenient local test execution commands (`just test`, `just test-unit`, etc.) using system-installed `bats`.
-   **Docker:**
    -   Primary production image (`Dockerfile`) is Alpine-based, self-contained, uses multi-stage builds, includes pinned Typst v0.12.0 and necessary packages/fonts. Build context is cleaned via `.dockerignore`.
    -   Devcontainer (`.devcontainer/Dockerfile.ubuntu`) is Ubuntu-based with dev tools, Docker-in-Docker, and system-installed Bats for testing.
-   **CI:** GitHub Actions workflow lints code, builds the production Docker image, builds the devcontainer image, runs internal tests (unit, filter, e2e) in the devcontainer image, runs Docker usage tests against the production image, builds example PDFs using the production container, pushes images, and handles releases. Submodule handling removed.
-   **Photo Handling:** Refactored to use `{photo="path" photowidth="..."}` attributes for better usability.
-   **Test Dependencies:** Bats, Bats-Support, Bats-Assert are installed via system package manager (`apt`) in the devcontainer and CI test environments, replacing Git submodules. Test files updated to use `bats_load_library`.

## What's Left to Build (Potential Future Work)

-   **Phase 2: User Experience & Flexibility:**
    -   Allow custom Pandoc Typst templates (beyond built-in `cv`/`letter`).
    -   Enhance style customization (more parameters in `style.typ` or allow custom style files).
-   **Phase 3: Technical Challenges & Refinements:**
    -   Improve/Fix stdin/stdout support for Typst format output (overrides currently ignored).
    -   Refactor `typst-cv.lua` and `style.typ` (as previously noted).
    -   Explore dynamic font installation (e.g., `fontist`).
-   **Optimize Dockerfiles:** Look for ways to share layers/stages between `Dockerfile` and `.devcontainer/Dockerfile.ubuntu`.
-   **(Potentially)** Remove `Dockerfile.fedora`.
-   **Phase 4: Rebranding & Marketing:** (As previously noted)

## Current Status

-   **Phase 1 Complete:** Testing framework established, examples depersonalized.
-   **Docker/CI Refactoring Complete:** Production Docker image switched to Alpine, CI updated to use it.
-   **Devcontainer Switched:** Development environment moved to Ubuntu with Docker-in-Docker.
-   **Test Dependencies Switched:** Successfully migrated from Git submodules to system packages (`apt`) for Bats testing framework.
-   **CI Workflow Fixed:** Resolved SSH key errors during production build by adding `.dockerignore`. Removed submodule handling steps. Updated test files and `justfile` to work with system Bats.
-   **Submodule Cleanup:** Removed submodule configuration (`.gitmodules`) and directories (`tests/bats`, `tests/test_helper/*`).
-   **Ready for Next Phase:** Project is stable, CI should pass.

## Known Issues

-   **Minor Layout Quirk:** README mentions side content (`{date}`, `{location}`) might cause minor spacing variations depending on Typst layout. (Low priority Typst/styling detail).
-   **Overrides Ignored for Typst Stdout:** `--set`/`TYPSTCV_*` overrides are currently ignored if outputting Typst format *to stdout* due to limitations in the pipeline. (This was not tested/fixed in this session).
