# Active Context: Debugging Docker Tests & Switching Devcontainer (2025-04-28)

## Current Focus

Debugging and fixing the Docker usage tests (`tests/docker.bats`) within the new Ubuntu-based Docker-in-Docker (DinD) devcontainer environment.

## Recent Actions (This Session)

-   **Created Production Dockerfile:** Defined `Dockerfile` (Alpine-based) for the self-contained production image, including multi-stage builds, pinned Typst v0.12.0, and necessary dependencies/assets.
-   **Updated CI:** Modified `.github/workflows/ci.yml` to build and test using the new production `Dockerfile`.
-   **Added Docker Tests:** Created `tests/docker.bats` to test container interaction.
-   **Updated `justfile`:** Added `build-docker` and `test-docker` recipes.
-   **Refactored Package Handling:**
    -   Reverted templates (`typst-cv.typ`, `typst-letter.typ`) to use local package import (`@local/pandoc-cv:0.1.0`).
    -   Updated production `Dockerfile` to copy `style.typ` and `typst.toml` into the package structure.
    -   Updated devcontainer `Dockerfile` (`.devcontainer/Dockerfile.ubuntu`) to create symlinks for `style.typ` and `typst.toml` into the package structure.
    -   Added Pandoc comment syntax (`$--`) to template files to avoid linter issues.
-   **Debugged `build.sh`:** Made several adjustments to handle Pandoc `--data-dir`, `--resource-path`, stdin (`-`) argument parsing, and `typst compile` arguments for the override pipeline.
-   **Identified Devcontainer Issue:** Diagnosed Docker test failures as stemming from Docker-out-of-Docker limitations with host path mounts in the Alpine devcontainer.
-   **Planned Devcontainer Switch:**
    -   Created a new Ubuntu-based devcontainer Dockerfile (`.devcontainer/Dockerfile.ubuntu`) with necessary tools.
    -   Updated `.devcontainer/devcontainer.json` to use the new Dockerfile and enable the Docker-in-Docker feature.
    -   Simplified `tests/docker.bats` to use direct host path mounts, anticipating the DinD setup.
-   **Executed Tests:** Ran `just build-docker && just test` multiple times.
-   **Fixed Path Resolution:** Modified `build.sh` and `typst-cv.lua` to correctly handle image paths relative to the input file using Typst's `--root` argument, resolving E2E test failures.
-   **Refactored Photo Attribute:** Changed from `{photo='image(...)'}` to `{photo="path" photowidth="..."}` for better usability, updating `typst-cv.lua` and test fixtures (`*.md`) accordingly.
-   **Fixed Filter Tests:** Made `typst-cv.lua` robust against missing metadata during filter tests.
-   **Fixed Docker Tests:**
    -   Used an image-free fixture (`example-cv-stdin.md`) for the stdin test.
    -   Corrected the `--set` key from `name` to `author` in the override test.
    -   Ensured the override test explicitly requested the correct output filename (`--output override.pdf`).
    -   Investigated and resolved issues preventing the output file creation in the override test.

## Decisions & Notes

-   Devcontainer successfully switched to Ubuntu (DinD), simplifying Docker testing.
-   Photo handling now uses separate `photo` (path) and optional `photowidth` attributes in Markdown for improved user experience.
-   Path resolution for images relies on Typst's `--root` argument, set correctly by `build.sh`.
-   All test suites (unit, filter, E2E, docker) are now passing.

## Immediate Next Steps

-   Update `progress.md` to reflect the successful debugging and passing tests.
-   Consider if any updates are needed for `techContext.md` or `.clinerules`.
-   Complete the task.
