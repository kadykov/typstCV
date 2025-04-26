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
    -   `justfile` provides convenient local test execution commands (`just test`, `just test-unit`, etc.).
-   **Docker:** Image builds, includes dependencies, uses `build.sh` as entrypoint.
-   **CI:** GitHub Actions workflow lints code (`pre-commit`), builds Docker image, runs all test suites inside the container, builds example PDFs, and handles releases (uploads example PDFs, uses changelog).

## What's Left to Build (Potential Future Work)

-   **Phase 2: User Experience & Flexibility:**
    -   Allow custom Pandoc Typst templates (beyond built-in `cv`/`letter`).
    -   Enhance style customization (more parameters in `style.typ` or allow custom style files).
-   **Phase 3: Technical Challenges & Refinements:**
    -   Improve/Fix stdin/stdout support for Typst format output (overrides currently ignored).
    -   Refactor `typst-cv.lua` and `style.typ`:
        -   Fix swapped `event-date`/`company-location` function usage.
        -   Rename functions (e.g., `date()`, `location()`).
        -   Add generic `{side="..."}` attribute support.
        -   Support multiple attributes per heading.
        -   Add support for divs like `#aside`.
    -   Explore dynamic font installation (e.g., `fontist`).
    -   Separate Docker images for development (Debian/Fedora) and production (Alpine).
-   **Phase 4: Rebranding & Marketing:**
    -   Rebrand project (name, repository, Docker Hub).
    -   Create GitHub Action for publishing documentation (e.g., to GitHub Pages).

## Current Status

-   **Phase 1 Complete:** Testing framework established, examples depersonalized, CI updated, `justfile` added. Core functionality is tested.
-   **Ready for Next Phase:** Project is in a stable state, ready for planning and implementation of new features or refactoring based on user priorities.

## Known Issues

-   **Minor Layout Quirk:** README mentions side content (`{date}`, `{location}`) might cause minor spacing variations depending on Typst layout. (Low priority Typst/styling detail).
-   **Overrides Ignored for Typst Stdout:** `--set`/`TYPSTCV_*` overrides are currently ignored if outputting Typst format *to stdout* due to limitations in the pipeline.
