# Progress: Typst CV/Letter Generator (As of 2025-04-26)

## What Works (Current State)

-   **Core Pipeline:** Markdown-to-PDF conversion using `build.sh`, Pandoc, Lua filters, and Typst functions correctly.
-   **Interface:** Flexible `build.sh` CLI handles input/output options, type inference, stdin/stdout (for PDF), and metadata overrides (`--set`, `TYPSTCV_*`).
-   **Features:** Automatic linkification (`linkify.lua`), CV side content (`{photo}`, `{location}`, `{date}` via `typst-cv.lua`), hidden headings (`.hidden`), and full-width ordered lists are functional.
-   **Examples:** Generic, depersonalized example files (`example-cv.md`, `example-letter.md`) and placeholder image exist in `tests/fixtures/`.
-   **Testing:**
    -   Unit tests (`bats`) for `build.sh` logic exist and pass.
    -   Filter tests (`sh`) comparing Pandoc output against snapshots exist and pass.
    -   E2E smoke tests (`sh`) verifying PDF generation for examples exist and pass.
    -   `justfile` provides convenient local test execution commands (`just test`, `just test-unit`, etc.) and Docker build commands (`just build-docker`).
-   **Docker:**
    -   Primary production image (`Dockerfile`) is Alpine-based, self-contained, uses multi-stage builds, includes pinned Typst v0.12.0 and necessary packages/fonts.
    -   `style.typ` is placed in `/app/lib` and included via `TYPST_FONT_PATHS`.
    -   Devcontainer (`.devcontainer/Dockerfile`) is Alpine-based with dev tools and Docker-in-Docker.
    -   Fedora-based image (`Dockerfile.fedora`) exists but is likely deprecated.
-   **Testing:**
    -   Unit, Filter, E2E tests (`just test-internal`) run inside a devcontainer-like image in CI.
    -   Docker usage tests (`tests/docker.bats`, run via `just test-docker`) verify production container interaction on the CI host runner.
-   **CI:** GitHub Actions workflow lints code, builds the *production* Docker image (`Dockerfile`), builds the *devcontainer* image (`.devcontainer/Dockerfile.ubuntu`), runs internal tests in the devcontainer image, runs Docker usage tests against the production image, builds example PDFs using the production container, pushes images, and handles releases.
-   **Photo Handling:** Refactored to use `{photo="path" photowidth="..."}` attributes for better usability.

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
-   **Docker Tests Passing:** All test suites pass locally.
-   **CI Workflow Debugging:** CI pipeline updated to use devcontainer image for internal tests, but failed (`bats: not found`). Added diagnostic step to verify submodule checkout via `actions/checkout@v4`. Awaiting results from next CI run.
-   **Ready for Next Phase:** Blocked on resolving CI test failures.

## Known Issues

-   **Minor Layout Quirk:** README mentions side content (`{date}`, `{location}`) might cause minor spacing variations depending on Typst layout. (Low priority Typst/styling detail).
-   **Overrides Ignored for Typst Stdout:** `--set`/`TYPSTCV_*` overrides are currently ignored if outputting Typst format *to stdout* due to limitations in the pipeline. (This was not tested/fixed in this session).
