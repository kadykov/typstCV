# Active Context: Interface Refactoring Complete (2025-04-23)

## Current Focus

The refactoring of the project's user interface is complete. The `justfile` has been replaced with `build.sh`, providing a flexible command-line interface with support for overrides and stdin/stdout. Docker integration has been updated accordingly.

## Recent Actions (Completed)

-   Reviewed project structure, `README.md`, `justfile`, Lua filters (`linkify.lua`, `typst-cv.lua`), Typst templates (`typst-cv.typ`, `typst-letter.typ`), style package (`style.typ`, `typst.toml`), `Dockerfile`, and `entrypoint.sh`.
-   Confirmed the rendering pipeline (Markdown -> Pandoc w/ Filters & Template -> Typst -> PDF).
-   Identified the `justfile`'s hardcoded values and rigid structure as the main usability bottleneck.
-   Analyzed the mechanism for handling private data (`.env` + `just build-private` piping to `typst compile --input`) and identified it as inflexible.
-   Examined Docker setup and identified the need to update the `ENTRYPOINT`.

1.  **Modified `style.typ`:** Implemented universal override logic (checking `sys.inputs` first) and renamed `public-email` to `email`.
2.  **Created `build.sh`:** Implemented the new flexible command-line interface with argument parsing, stdin/stdout support, override detection (`TYPSTCV_*`, `--set`), and dynamic pipeline selection.
3.  **Updated `Dockerfile`:** Changed `ENTRYPOINT` to `build.sh` and added steps to copy/chmod the script.
4.  **Updated Documentation:** Modified `README.md` with new usage instructions for `build.sh` (CLI & Docker, including correct Docker Hub tag `kadykov/typst-cv`) and updated example files (`kadykov-*.md`) to use `email`.
5.  **Cleaned Up:** Removed `justfile`, `action.yml`, and `entrypoint.sh`.
6.  **Updated Memory Bank:** Updated `activeContext.md` and `progress.md`.

## Immediate Next Steps

-   Present the completed work to the user.
