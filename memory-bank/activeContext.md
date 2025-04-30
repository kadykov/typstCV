# Active Context: Switched Test Dependencies from Submodules to System Packages (2025-04-30)

## Current Focus

Resolving CI failures related to test execution and dependency management.

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

## Recent Actions (This Session)

-   Diagnosed the SSH key failure during `docker build`.
-   Discussed options (HTTPS URLs, SSH keys, system packages).
-   Decided to switch to system packages for Bats and exclude test/git files from production build context.
-   Created `.dockerignore`.
-   Removed submodule update step from `.github/workflows/ci.yml`.
-   Updated `load` commands in `.bats` files to `bats_load_library`.
-   Updated `justfile` to use system `bats`.
-   Verified the fix for loading helpers with the user.

## Decisions & Notes

-   Using system packages for test dependencies simplifies the CI build process and avoids SSH key issues during production image builds.
-   `.dockerignore` is crucial for keeping production build contexts clean and secure.
-   `bats_load_library` is the correct way to load system-installed Bats helpers.

## Immediate Next Steps

-   Update `progress.md`.
-   **User Action:** Commit the changes (`.dockerignore`, `.github/workflows/ci.yml`, `justfile`, `tests/**/*.bats`).
-   **User Action:** Trigger the CI workflow and verify all tests pass.
-   **User Action (Optional):** Clean up Git submodule configuration (`.gitmodules`, `git rm --cached ...`, `rm -rf ...`).
-   Complete the task.
