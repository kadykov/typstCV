# Progress: Typst CV/Letter Generator (As of 2025-04-30)

## What Works (Current State)

-   **Core Pipeline:** Markdown-to-PDF conversion using `build.sh`, Pandoc, Lua filters, and Typst functions correctly.
-   **Interface:** Flexible `build.sh` CLI handles input/output options, type inference, stdin/stdout (for PDF), and metadata overrides (`--set`, `TYPSTCV_*`).
-   **Features:** Automatic linkification (`linkify.lua`), CV side content (`{photo}`, `{location}`, `{date}` via `typst-cv.lua`), hidden headings (`.hidden`), and full-width ordered lists are functional.
-   **Examples:** Generic, depersonalized example files (`example-cv.md`, `example-letter.md`) and placeholder image exist in `tests/fixtures/`.
-   **Testing:**
    -   Unit tests (`bats`) for `build.sh` logic exist and pass (`tests/unit/build_sh.bats`).
    -   Filter tests (`bats`) comparing Pandoc output against snapshots exist and pass (`tests/filter/filters.bats`).
    -   E2E smoke tests converted to Bats (`tests/test_e2e.bats`), verifying PDF generation and basic content. Uses `cd $BATS_TMPDIR` workaround for Pandoc temp file permissions.
    -   Docker usage tests (`bats`) verify production container interaction (`tests/docker.bats`). CI host runner correctly installs helpers. CI execution fixed by passing the correct image tag via `DOCKER_IMAGE_TAG` environment variable.
    -   `justfile` provides convenient local test execution commands (`just test`, `just test-unit`, `just test-filter`, `just test-e2e`) using system-installed `bats`.
-   **Docker:**
    -   Primary production image (`Dockerfile`) is Alpine-based, self-contained, uses multi-stage builds, includes pinned Typst v0.12.0 and necessary packages/fonts. Build context is cleaned via `.dockerignore`. Files (`*.lua`, `*.typ`) copied to standard Pandoc/Typst locations.
    -   Devcontainer (`.devcontainer/Dockerfile.ubuntu`) is Ubuntu-based with dev tools, Docker-in-Docker, system-installed Bats. Includes built-in symlinks for Pandoc templates/filters (`*.typ`, `*.lua`) into standard system locations, aligning it with the production environment. **CI now builds and caches this image to GHCR.**
-   **CI:** GitHub Actions workflow:
    -   Lints code (`pre-commit`).
    -   Builds production Docker image (`Dockerfile`) and loads it locally for testing (`${{ env.IMAGE_TAG_TESTING }}`).
    -   **Builds and caches devcontainer image to GHCR (`${{ env.DEV_IMAGE_NAME }}:latest`) on every run.**
    -   Runs internal tests (unit, filter, e2e) **inside the pulled GHCR devcontainer image**. All known permission/path issues resolved.
    -   Runs Docker usage tests against the local production testing image (`${{ env.IMAGE_TAG_TESTING }}`). Fixed missing host Bats helpers and image tag mismatch.
    -   Builds example PDFs using the local production testing image. Fixed entrypoint argument issue.
    -   **Pushes final tagged production image to Docker Hub *only* on `push` events (main/tags).** Added `type=ref,event=pr` tag to metadata to prevent errors.
    -   Handles GitHub Releases.
    -   Submodule handling removed.
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
-   **CI Workflow Fixed & Improved:** Resolved previous CI failures (SSH keys, permissions, paths, test dependencies, entrypoint args, etc.). Implemented **devcontainer caching via GHCR** and **conditional push logic** for production images (only push on `push` events). Added `pr-X` tagging for production image builds during PRs.
-   **Submodule Cleanup:** Removed submodule configuration (`.gitmodules`) and directories (`tests/bats`, `tests/test_helper/*`). Old `tests/test_e2e.sh` deleted by user.
-   **Ready for Verification:** Project is stable. Ready for user to commit changes and trigger CI workflow to verify caching and conditional push logic.

## Known Issues

-   **Minor Layout Quirk:** README mentions side content (`{date}`, `{location}`) might cause minor spacing variations depending on Typst layout. (Low priority Typst/styling detail).
-   **Overrides Ignored for Typst Stdout:** `--set`/`TYPSTCV_*` overrides are currently ignored if outputting Typst format *to stdout* due to limitations in the pipeline. (This was not tested/fixed in this session).
