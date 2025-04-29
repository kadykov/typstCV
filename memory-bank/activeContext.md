# Active Context: Fixing CI Test Execution (2025-04-29)

## Current Focus

Diagnosing and correcting the GitHub Actions CI workflow (`.github/workflows/ci.yml`) to properly execute all test suites.

## Problem Identified

-   Local tests (`just test`) pass in the devcontainer.
-   CI internal tests (`just test-internal` running in devcontainer image) failed with `sh: 1: tests/bats/bin/bats: not found`.
-   **Hypothesis:** The `actions/checkout@v4` step might not be checking out the Git submodules (`tests/bats`, `tests/test_helper`) correctly on the CI runner, despite `submodules: recursive` being set.

## Recent Actions (This Session)

-   **Analyzed Initial CI Failure:** Diagnosed the incorrect execution context (running tests in production image) for internal tests.
-   **Planned & Implemented CI Fix v1:**
    -   Added `test-internal` recipe to `justfile`.
    -   Modified `.github/workflows/ci.yml` to build the devcontainer image and run `just test-internal` within it, mounting the workspace.
-   **Analyzed Second CI Failure (`bats: not found`):** Identified the failure point as the inability to find the Bats executable within the devcontainer test run.
-   **Added Diagnostic Step to CI:** Modified `.github/workflows/ci.yml` to add a "Verify Submodule Checkout" step immediately after `actions/checkout@v4`. This step uses `ls -l` to check if the submodule directories (`tests/bats/bin`, `tests/test_helper`) are populated on the CI runner host *before* the Docker steps run.

## Decisions & Notes

-   The `bats: not found` error points to an issue with the availability of the submodule files within the CI job's execution environment.
-   Verifying the checkout step directly on the runner is the next logical diagnostic step.
-   If submodules *are* checked out correctly on the runner, the issue might be with the Docker volume mount (`-v "${PWD}:/workspaces/typstCV"`) or permissions within the container.
-   If submodules *are not* checked out correctly, the `actions/checkout@v4` step or its configuration needs further investigation.

## Immediate Next Steps

-   **User Action:** Commit and push the latest change to `.github/workflows/ci.yml` (adding the verification step) to trigger the CI workflow.
-   **Analyze CI Output:** Examine the output of the "Verify Submodule Checkout" step in the new CI run.
-   **Update `progress.md`:** Reflect the ongoing CI debugging status.
-   Based on the CI output, determine the next fix (e.g., adjust checkout, adjust Docker mount, add explicit submodule commands).
