# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- **Build System:** Introduced `build.sh` as the primary build script with CLI options for input/output, type inference, and metadata overrides (`--set`, `TYPSTCV_*`).
- **Testing Framework:** Added a comprehensive testing suite using Bats (`tests/`), including unit tests for `build.sh`, filter tests, end-to-end PDF generation tests, and Docker usage tests. Added example fixtures (`tests/fixtures/`).
- **Development Environment:** Added a devcontainer configuration (`.devcontainer/`) using Ubuntu, including Docker-in-Docker and pre-configured tools (Pandoc, Typst, Just, Bats, etc.).
- **Local Development Helper:** Added `Justfile` for common tasks like linting, testing, and building examples.
- **Docker Enhancements:** Added `.dockerignore` to optimize build context. Added `fontist-manifest.yml` for font management.
- **CI/CD:**
    - Added Dependabot configuration (`.github/dependabot.yml`) for automated dependency checks.
    - Added Docker image vulnerability scanning using Trivy (`aquasecurity/trivy-action`) in the CI workflow.
- **Memory Bank:** Added `memory-bank/` directory and core documentation files (`projectbrief.md`, `productContext.md`, etc.).

### Changed
- **Build System:** Replaced the old `justfile`-based build logic entirely with `build.sh`.
- **Docker:**
    - Overhauled `Dockerfile`: Switched base image from Fedora to Alpine Linux, implemented multi-stage builds for fonts (using Fontist) and Typst, updated dependencies, changed entrypoint to `build.sh`.
    - Refactored devcontainer (`.devcontainer/devcontainer.json`, `Dockerfile.ubuntu`) for improved setup and consistency with production image (symlinks for Pandoc/Typst resources).
- **CI/CD:**
    - Major refactor of `.github/workflows/ci.yml`: Switched test execution to use devcontainer image, implemented GHCR caching for devcontainer, added conditional push logic for production image, fixed numerous path/permission/tagging issues, integrated security scanning and Dependabot.
    - Updated `.pre-commit-config.yaml` hooks.
- **Documentation:**
    - Significantly updated `README.md` with new usage instructions for `build.sh` and Docker, metadata override details, and feature explanations.
- **Styling & Templates:**
    - Refactored `style.typ` to handle metadata overrides (`sys.inputs`) and conditionally display footer links. Updated font weights.
    - Updated `typst-cv.typ` and `typst-letter.typ` to use the local package import, handle structured dates, and use updated variables.
- **Lua Filters:**
    - Updated `typst-cv.lua` to handle photo path and width attributes (`{photo="..." photowidth="..."}`).
- **Internal:** Replaced `public-email` YAML key with `email`.

### Removed
- Old build system components: `justfile` (original version), `entrypoint.sh`, `action.yml`.
- Old example files: `kadykov-*.md`.
- Git submodules for test dependencies (switched to system packages).
- Fedora-based Docker build logic.
- CodeQL analysis workflow (unsupported languages).
- GitHub Pages deployment job from CI workflow.

### Fixed
- Handling of custom dates in YAML headers (switched to structured map `year: YYYY, month: M, day: D`).
- Numerous CI workflow issues (permissions, paths, tagging, caching, entrypoint args, test execution).
- PDF write permission errors during testing within containers.
- Handling of stdin input and output paths in `build.sh`.
- Dependabot CI failures due to missing secrets.

## [0.3.0] - 2024-11-20

### Added

- The horizontal rule (`---`) will not be visible if it is placed at the very top or very bottom of the page.
- Include necessary files in the Docker image
- Add an option to adjust profile photo dimensions

### Fixed

- Broken custom dates in YAML headers

## [0.2.0] - 2024-11-17

### Changed

- CVs and cover letters are now written in Markdown and converted to Typst using a Pandoc template

### Added

- `linkify` Pandoc Lua filter that automatically converts keywords in the document into hyperlinks

## [0.1.0] - 2024-11-13

### Added

- English and French versions.
- CV and cover letter in Typst
- `just` for rendering
- GitHub actions for rendering and publishing to GitHub Pages
