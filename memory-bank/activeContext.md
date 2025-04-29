# Active Context: Fixing CI Test Execution (2025-04-29)

## Current Focus

Correcting the GitHub Actions CI workflow (`.github/workflows/ci.yml`) to properly execute all test suites.

## Problem Identified

-   Local tests (`just test`) were passing in the devcontainer.
-   CI tests were failing with `Error: Only one input file allowed.` during the unit/filter/E2E test execution step.
-   **Root Cause:** The CI workflow was attempting to run the unit, filter, and E2E tests (which require Bats and other dev tools) *inside* the minimal production Docker image (`kadykov/typst-cv:testing`). This image lacks the necessary testing tools, and the volume mounting/working directory setup was incorrect for the test scripts' expectations.

## Recent Actions (This Session)

-   **Analyzed CI Failure:** Diagnosed the incorrect execution context for internal tests in the CI workflow.
-   **Planned CI Fix:** Determined the need to run internal tests (unit, filter, E2E) in an environment similar to the devcontainer, separate from the Docker usage tests (`tests/docker.bats`).
-   **Updated `justfile`:**
    -   Added a new recipe `test-internal: test-unit test-filter test-e2e` specifically for running tests that don't involve direct Docker interaction testing.
    -   Modified the main `test` recipe to `test: test-internal test-docker`.
-   **Updated `.github/workflows/ci.yml`:**
    -   Added a step to build the devcontainer image (`typst-cv-devcontainer:latest`) from `.devcontainer/Dockerfile.ubuntu`.
    -   Replaced the failing internal test execution step to use the `typst-cv-devcontainer:latest` image, mount the full workspace (`${PWD}:/workspaces/typstCV`), set the working directory (`/workspaces/typstCV`), and run `just test-internal`.
    -   Kept the "Run Docker usage tests (on runner host against production image)" step unchanged, as it correctly tests the production image's external interface.

## Decisions & Notes

-   Internal tests (unit, filter, E2E) require the development environment context (tools like Bats).
-   Docker usage tests (`tests/docker.bats`) specifically test the *production* image interface from the outside and should run on the host runner.
-   Separating the execution context for these two types of tests in CI is crucial.
-   Using the devcontainer Dockerfile (`.devcontainer/Dockerfile.ubuntu`) provides the necessary environment for internal tests in CI.

## Immediate Next Steps

-   **User Action:** Commit and push the changes to `justfile` and `.github/workflows/ci.yml` to trigger the CI workflow and verify the fix.
-   **Update `progress.md`:** Reflect the CI fix and current project status.
-   Consider if any updates are needed for `techContext.md` or `.clinerules`.
-   Complete the task once CI verification is successful.
