# Project Brief: Typst CV/Letter Generator

## Core Goal

To provide a flexible and user-friendly system for rendering Curriculum Vitae (CV) and Cover Letters written in Markdown format into professional-looking PDFs using Typst.

## Key Features (Original)

-   **Input Format:** Markdown with YAML frontmatter for metadata.
-   **Custom Attributes:** Uses Markdown attributes for specific layout features (e.g., `photo`, `date`, `location`).
-   **Rendering Pipeline:**
    1.  Markdown + YAML -> Pandoc -> Typst format.
    2.  Pandoc uses custom Lua filter (`linkify.lua`) for hyperlink enrichment.
    3.  Pandoc uses custom Lua filter (`typst-cv.lua`) to translate attributes/classes to Typst functions.
    4.  Pandoc uses specific templates (`typst-cv.typ`, `typst-letter.typ`).
    5.  Typst renders the generated `.typ` file to PDF, using common styles from `style.typ` (defined as local package `@local/pandoc-cv`).
-   **Workflow Management:** `justfile` orchestrates the multi-step rendering process (identified as problematic).
-   **Distribution:** `Dockerfile` packages all dependencies (Pandoc, Typst, Just, fonts) for setup and execution. Includes a GitHub Action entrypoint (`entrypoint.sh`).

## Problem Statement (User Identified & Analyzed)

-   The primary interface via `justfile` commands is complex, rigid, and not user-friendly.
-   Hardcoded filenames (`kadykov`) and reliance on strict naming conventions (`filename-type-lang.md`) in `justfile` prevent general use.
-   Repetitive recipes in `justfile` for public/private and languages.
-   The distinction between public/private builds via `.env` and `--private` flag is inflexible.
-   Docker entrypoint (`Dockerfile`) is tied to the inflexible `justfile`.

## Objective of Current Task (Refined)

1.  **Refactor Interface:** Replace the `justfile` with a flexible shell script (`build.sh`).
2.  **Improve Usability:** Design `build.sh` with a clear command-line interface accepting input files, output paths, and options.
3.  **Flexible Overrides:** Implement a system for overriding YAML metadata using environment variables (prefixed `TYPSTCV_*`) and command-line arguments (`--set KEY=VALUE`), replacing the rigid `--private` flag.
4.  **Add Features:** Support reading from stdin and writing PDF to stdout.
5.  **Docker Integration:** Update `Dockerfile` entrypoint to use `build.sh`, making the container directly usable with the new interface. Update the GitHub Action script (`entrypoint.sh`) to use `build.sh`.
6.  **Documentation:** Update `README.md` with new usage instructions. Establish and maintain the Memory Bank.
