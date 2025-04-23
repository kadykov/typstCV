# Progress: Typst CV/Letter Generator (As of 2025-04-23)

## What Works (Current State)

-   The core Markdown-to-PDF pipeline using Pandoc, Lua filters, and Typst functions correctly for the example files (`kadykov-*.md`).
-   Rendering of both CVs and Letters works.
-   Custom Markdown features (YAML metadata, `links`, attributes like `{photo}`, `{date}`, `{location}`, class `.hidden`) are implemented and functional via Lua filters and Typst styles.
-   Public vs. Private rendering using `.env` and `just build`/`just build-private` works, albeit inflexibly.
-   Docker image builds successfully and contains all necessary dependencies and project files.
-   GitHub Action (`entrypoint.sh`) exists but relies on the current `justfile`.

## What's Left to Build (Current Task)

1.  **`build.sh` Script:** Create the new command-line interface script.
    -   Argument parsing (input, output, type, overrides).
    -   Stdin/stdout support.
    -   Override detection (`TYPSTCV_*` env vars, `--set` args).
    -   Dynamic pipeline selection (Pandoc-direct-PDF vs. Pandoc-Typst | Typst-Compile).
    *   Command construction and execution.
    *   Error handling and user feedback.
2.  **`Dockerfile` Update:** Modify the `ENTRYPOINT` to use `build.sh`. Copy `build.sh` into the image.
3.  **`entrypoint.sh` Update:** Modify the GitHub Action script to use `build.sh` instead of `just build`.
4.  **`README.md` Update:** Rewrite usage instructions for `build.sh` (CLI and Docker).
5.  **`justfile` Removal:** Delete the old `justfile`.

## Current Status

-   **Planning Phase Complete:** Analysis of the existing system is done. A detailed plan for refactoring the interface with `build.sh` has been agreed upon.
-   **Memory Bank Established:** Initial versions of all core Memory Bank files have been created.
-   **Ready for Implementation:** The next step is to draft the `build.sh` script.

## Known Issues (Existing System)

-   **Rigid Interface:** `justfile` requires specific filenames (`kadykov-*`) and structure.
-   **Inflexible Private Data:** `.env` + `build-private` is the only way to include private info.
-   **Docker Entrypoint:** Tied to the inflexible `justfile`.
-   **Minor Layout Quirk:** README mentions side content (`{date}`, `{location}`) starting a new paragraph after the heading, potentially causing extra space. (This is a Typst/styling detail, not directly addressed by the current refactoring task, but noted).
