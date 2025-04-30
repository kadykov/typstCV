# Active Context: Resolved CI Test Failures & Standardized E2E Tests (2025-04-30)

## Current Focus

Completing the task related to switching from submodules to system packages for testing and resolving subsequent CI issues.

## Problem Identified & Resolved

1.  **Initial Problem:** CI tests failed (`bats: not found`) because `actions/checkout@v4` wasn't initializing submodules.
2.  **Intermediate Fix:** Added explicit `git submodule update --init --recursive` to CI.
3.  **New Problem:** The `docker build` step for the *production* image failed with `git@github.com: Permission denied (publickey)`. This occurred because the build context included submodule definitions using SSH URLs, but the build environment lacked SSH keys.
4.  **Root Cause:** The production Docker image build context included `.git` and `tests/` directories. The testing environment (devcontainer) relied on submodules.
5.  **Solution Implemented:**
    *   Switched test dependencies (Bats, Bats-Support, Bats-Assert) from Git submodules to system packages (`apt install`) within the devcontainer (`.devcontainer/Dockerfile.ubuntu`) and for host-run tests (`tests/docker.bats` via CI step).
    *   Created `.dockerignore` to exclude `.git`, `tests/`, and other non-essential files from the production Docker build context, preventing the SSH key error.
    *   Updated Bats test files (`tests/unit/build_sh.bats`, `tests/filter/filters.bats`) to load helpers using `bats_load_library` instead of relative submodule paths.
    *   Updated `justfile` to use the system `bats` executable instead of the submodule path.
    *   Removed the explicit `git submodule update` step from the CI workflow (`.github/workflows/ci.yml`).
6.  **New Problem (CI):** Tests run inside the devcontainer image (`just test-internal`) failed with `chmod: changing permissions of '/workspaces/typstCV/build.sh': Operation not permitted`.
7.  **Root Cause (CI):** The test script (`tests/unit/build_sh.bats`) attempted to `chmod +x` the `build.sh` script on the host filesystem via the Docker volume mount, which failed due to permissions. Additionally, the symlinks for the local Typst package (`style.typ`, `typst.toml`), created by `postCreateCommand` in the devcontainer, were missing when running the image directly in CI. The host Bats tests (`tests/docker.bats`) were also missing helper packages (`bats-assert`, `bats-support`).
8.  **Solution Implemented (CI):**
    *   Removed the `chmod +x` command from `tests/unit/build_sh.bats`.
    *   Added `RUN` commands to `.devcontainer/Dockerfile.ubuntu` to create the necessary package symlinks during the image build.
    *   Updated `.github/workflows/ci.yml` to install `bats-assert` and `bats-support` on the host runner for the `docker.bats` tests.
9.  **New Problem (CI - Post Fixes):** Tests run inside the devcontainer image (`just test-internal`) failed again, this time with `error: failed to write PDF file (Permission denied (os error 13))`.
10. **Root Cause (CI - Post Fixes):** The test `build.sh: succeeds with valid input file` in `tests/unit/build_sh.bats` was attempting to write the output PDF (`dummy.pdf`) directly into the mounted workspace directory (`/workspaces/typstCV`), which the `vscode` user inside the container didn't have permission to do.
11. **Solution Implemented (CI - Post Fixes):**
    *   Modified the `build.sh: succeeds with valid input file` test in `tests/unit/build_sh.bats` to explicitly write its output PDF to a dedicated subdirectory within the Bats temporary directory (`$BATS_TMPDIR/test_output/`) instead of the current working directory. Added setup/teardown for this directory.
12. **New Problem (CI - E2E):** After fixing the unit tests, the E2E tests (`tests/test_e2e.sh`) failed with `pandoc: .: openTempFile: permission denied` and `Could not find data file ... typst-letter.typ`.
13. **Root Cause (CI - E2E):** The E2E test ran `build.sh` from the mounted workspace, but `build.sh` couldn't find templates/filters relative to the CWD, and Pandoc couldn't create temp files in the CWD. Also, the E2E test used a shell script instead of Bats.
14. **Final Solution Implemented:**
    *   Converted `tests/test_e2e.sh` to `tests/test_e2e.bats` for consistency.
    *   Modified `tests/test_e2e.bats` to run `build.sh` from within `$BATS_TMPDIR` to resolve Pandoc's temp file permission issue.
    *   Modified `.devcontainer/Dockerfile.ubuntu` to create symlinks for Pandoc templates (`*.typ`) and filters (`*.lua`) from the workspace into the standard system locations (`/usr/share/pandoc/...`), aligning the devcontainer environment with the production container.
    *   Reverted `build.sh` to use relative template/filter names, relying on Pandoc's `--data-dir` mechanism (which now works in both environments).
    *   Updated `justfile` to run the new `tests/test_e2e.bats`.
    *   User deleted the old `tests/test_e2e.sh`.
15. **New Problem (CI - Docker Tests):** The `test-docker` step failed with `!!! Docker image 'typst-cv:latest' not found`.
16. **Root Cause (CI - Docker Tests):** The test script (`tests/docker.bats`) hardcoded the image tag `typst-cv:latest`, but the CI workflow built and provided the image tagged as `kadykov/typst-cv:testing`.
17. **Solution Implemented (CI - Docker Tests):**
    *   Modified `tests/docker.bats` to read the image tag from an environment variable (`DOCKER_IMAGE_TAG`), defaulting to `typst-cv:latest` if unset.
    *   Modified `.github/workflows/ci.yml` to pass the correct tag (`${{ env.IMAGE_TAG_TESTING }}`) to the `bats` command via the `DOCKER_IMAGE_TAG` environment variable.

## Recent Actions (This Session)

-   Diagnosed the SSH key failure during `docker build` (previous step).
-   Switched test dependencies to system packages and updated related files (previous step).
-   Diagnosed the subsequent CI failures (`chmod` error, missing symlinks, missing host Bats helpers).
-   Planned the fixes for the CI issues.
-   Modified `.devcontainer/Dockerfile.ubuntu` to add Typst package symlink creation (and subsequently removed duplicated commands).
-   Modified `tests/unit/build_sh.bats` to remove `chmod`.
-   Modified `.github/workflows/ci.yml` to install Bats helpers on the host runner.
-   Diagnosed the PDF write permission error (`os error 13`) in CI unit tests.
-   Modified `tests/unit/build_sh.bats` again to write test output to `$BATS_TMPDIR/test_output/` instead of the CWD.
-   Diagnosed E2E test failures (Pandoc temp file permission, missing templates/filters).
-   Converted `tests/test_e2e.sh` to `tests/test_e2e.bats`, incorporating `cd $BATS_TMPDIR` fix and correcting assertion syntax.
-   Updated `justfile` to use `tests/test_e2e.bats`.
-   Modified `build.sh` to use absolute paths for templates/filters (later reverted).
-   Diagnosed Docker test failures caused by absolute paths in `build.sh`.
-   Reverted `build.sh` to use relative paths for templates/filters.
-   Modified `.devcontainer/Dockerfile.ubuntu` to add symlinks for Pandoc templates/filters to system locations.
-   User confirmed tests pass locally after rebuilding devcontainer.
-   User deleted `tests/test_e2e.sh`.
-   Diagnosed and fixed the `test-docker` CI failure by parameterizing the image tag.
-   Updated this `activeContext.md`.

## Decisions & Notes

-   Using system packages for test dependencies simplifies the CI build process.
-   `.dockerignore` is crucial for keeping production build contexts clean.
-   Aligning devcontainer resource locations (via symlinks) with production container locations (via copy) simplifies build scripts and testing.
-   Running tests that write output from within `$BATS_TMPDIR` avoids container volume mount permission issues.
-   Using an environment variable (`DOCKER_IMAGE_TAG`) allows the Docker usage tests (`tests/docker.bats`) to work correctly in both local (defaulting to `typst-cv:latest`) and CI environments (using the specific testing tag).

## Immediate Next Steps

-   Update `progress.md`.
-   **User Action:** Commit the changes (including `tests/docker.bats`, `.github/workflows/ci.yml`, and Memory Bank files).
-   **User Action:** Trigger the CI workflow and verify all tests pass, including the `test-docker` step.
-   Complete the task.
