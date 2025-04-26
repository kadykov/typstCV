# Active Context: Testing & Depersonalization Complete (2025-04-26)

## Current Focus

Phase 1, focusing on adding tests, depersonalizing examples, and updating CI, is complete. The project now has a test suite covering unit, filter, and E2E scenarios, uses generic example files, and the CI workflow automatically runs these tests.

## Recent Actions (Completed)

-   **Discussed Next Steps:** Prioritized adding tests and depersonalizing the project.
-   **Test Setup:**
    -   Created `tests/` directory structure.
    -   Installed `bats-core` and helpers via Git submodules (`tests/bats`, `tests/test_helper`).
-   **Depersonalization:**
    -   Created generic example files (`tests/fixtures/example-cv.md`, `tests/fixtures/example-letter.md`) using placeholder data and correct heading/link structure.
    -   Created placeholder image (`tests/fixtures/placeholder-photo.png`).
    -   Removed old personalized files (`kadykov-*.md`, `photo.jpg`).
-   **Testing Implementation:**
    -   Added unit tests for `build.sh` using Bats (`tests/unit/build_sh.bats`), debugging path and execution issues.
    -   Refactored filter tests into Bats (`tests/filter/filters.bats`) using `grep`/`assert_output --partial` for robustness instead of fragile snapshots.
    -   Added E2E smoke tests (`tests/test_e2e.sh`) verifying successful PDF generation. Enhanced E2E tests using `pdftotext` (via `poppler-utils` added to Dockerfile) to check for presence of hidden headings and absence of optional footer links. Debugged various issues related to YAML format, paths, template logic, and test implementation.
-   **Documentation:** Updated `README.md` to clarify heading structure, linkification, metadata override workflow, and point to new example files.
-   **CI Update:** Modified `.github/workflows/ci.yml` to run the new test suites (unit, filter, e2e) inside the Docker container (which now includes `poppler-utils`) and removed the old GitHub Pages deployment job for CVs. Ensured example PDFs are built and uploaded for release artifacts.
-   **Development Tooling:** Added `justfile` for convenient local execution of linters and test suites.
-   **Memory Bank:** Updated `activeContext.md`, `progress.md`, `techContext.md`.

## Decisions & Notes

-   Decided *not* to implement `--output-format typst` in `build.sh` at this time due to difficulties in reliably generating/testing the `.typ` output via the script. Integration testing relies on filter tests and E2E PDF tests.
-   Noted suggestions for future filter (`typst-cv.lua`) refactoring (fixing function names, adding generic side content, multiple attributes, div support) but postponed implementation until after establishing baseline tests.
-   Corrected understanding of YAML date format and relative paths for Typst compilation.
-   **Bug Fix:** Corrected default values (`"default"` -> `none`) and added conditional logic in `style.typ` footer to prevent displaying icons/links for optional fields (github, gitlab, linkedin, website) if they are not provided in YAML or via overrides.
-   **Template Imports:** Confirmed templates use direct `#import "style.typ"` as updated by user.

## Immediate Next Steps

-   Update `progress.md`.
-   Present the completed Phase 1 work (including bug fix) to the user.
