# Active Context: Fixing CI Test Execution (2025-04-29)

## Current Focus

Diagnosing and correcting the GitHub Actions CI workflow (`.github/workflows/ci.yml`) to properly execute all test suites.

## Problem Identified

-   Local tests (`just test`) pass in the devcontainer.
-   CI internal tests (`just test-internal` running in devcontainer image) failed with `sh: 1: tests/bats/bin/bats: not found`.
-   **Root Cause Confirmed:** Diagnostic step showed `actions/checkout@v4` was not checking out submodules on the CI runner.
-   **Secondary Issue:** Linter errors detected duplicate keys in the `release` job after a previous file modification.

## Recent Actions (This Session)

-   **Analyzed Initial CI Failure:** Diagnosed the incorrect execution context (running tests in production image) for internal tests.
-   **Planned & Implemented CI Fix v1:**
    -   Added `test-internal` recipe to `justfile`.
    -   Modified `.github/workflows/ci.yml` to build the devcontainer image and run `just test-internal` within it, mounting the workspace.
-   **Analyzed Second CI Failure (`bats: not found`):** Identified the failure point as the inability to find the Bats executable.
-   **Added Diagnostic Step to CI:** Added a verification step using `ls` which confirmed submodules were not checked out by `actions/checkout@v4`.
-   **Implemented CI Fix v2 (Submodules):**
    -   Removed the diagnostic `ls` step.
    -   Added an explicit `git submodule update --init --recursive` command in `.github/workflows/ci.yml` immediately after the `actions/checkout@v4` step to ensure submodules are initialized and updated.
-   **Fixed Linter Errors:** Corrected duplicate keys (`allowUpdates`, `token`, `artifacts`) in the `release` job within `.github/workflows/ci.yml` by rewriting the affected step.

## Decisions & Notes

-   Explicitly running `git submodule update --init --recursive` is the most reliable way to ensure submodules are available in the CI environment.
-   Rewriting problematic YAML sections can resolve hidden duplication issues sometimes missed by simple text diffs.

## Immediate Next Steps

-   **User Action:** Commit and push the latest changes to `.github/workflows/ci.yml` to trigger the CI workflow.
-   **Analyze CI Output:** Verify that the `git submodule update` step runs successfully and that the subsequent `just test-internal` step passes (specifically, that `bats` is now found).
-   **Update `progress.md`:** Reflect the latest CI fix attempt.
-   Complete the task once CI verification is successful.
