# Active Context: CI Workflow Improvements (2025-05-01)

## Current Focus

Finalizing CI workflow improvements related to Docker image tagging, push logic, and caching.

## Problem Identified & Resolved (Previous)

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
18. **New Problem (CI - Example Build):** The "Build Example PDFs for Release Artifacts" step failed with `Error: Only one input file allowed.`
19. **Root Cause (CI - Example Build):** The `docker run` commands in the CI workflow incorrectly included `build.sh` as part of the command being passed to the container. Since the container has `ENTRYPOINT ["build.sh"]`, the script name was passed as the first argument to the entrypoint script itself, leading to the argument parsing error.
20. **Solution Implemented (CI - Example Build):**
    *   Modified `.github/workflows/ci.yml` to remove the redundant `build.sh` from the `docker run` commands in the "Build Example PDFs" step, ensuring only the intended arguments are passed to the entrypoint.
21. **New Problem (CI - Devcontainer Tests):** The "Run internal tests" step failed with `docker: manifest unknown` for `ghcr.io/.../devcontainer:latest` during PR builds.
22. **Root Cause (CI - Devcontainer Tests):** The `devmeta` step in `.github/workflows/ci.yml` only added the `:latest` tag for the devcontainer image on the default branch (`main`), not on PRs. The subsequent test step explicitly tried to pull `:latest`, which didn't exist for PR builds.
23. **Solution Implemented (CI - Devcontainer Tests):** Modified the `devmeta` step in `.github/workflows/ci.yml` to remove the `enable={{is_default_branch}}` condition, ensuring the `:latest` tag is always generated and pushed for the devcontainer image, making it available for the test step during PR builds.
24. **New Problem (CI - Devcontainer Tests - Persistent):** Despite fix #23, the "Run internal tests" step *still* failed with `docker: manifest unknown` for `:latest` locally and in CI, even though logs showed `:latest` was tagged. The `:latest` tag on GHCR was not updating consistently.
25. **Root Cause (CI - Devcontainer Tests - Persistent):** Using the same `:latest` tag for both the image tag (`tags:`) and the cache reference (`cache-from`/`cache-to:`) in `docker/build-push-action` likely interfered with the proper updating of the `:latest` image manifest.
26. **Solution Implemented (CI - Devcontainer Tests - Persistent):** Modified the `Build and Cache Devcontainer Image` step in `.github/workflows/ci.yml` to use a dedicated cache tag (`:buildcache`) for `cache-from` and `cache-to`, separating cache management from the primary `:latest` image tag.

## Recent Actions (This Session)

-   Diagnosed CI issues: missing tags on PR builds (`ERROR: tag is needed...`), incorrect push logic for production image on PRs, lack of devcontainer caching.
-   Planned CI fixes: Add `type=ref,event=pr` tag for production image metadata, make production image push conditional on `github.event_name == 'push'`, implement devcontainer caching using GHCR.
-   Modified `.github/workflows/ci.yml`:
    *   Added unconditional login step for GHCR.
    *   Added `type=ref,event=pr` to production image metadata (`id: meta`).
    *   Added metadata step for devcontainer image (`id: devmeta`).
    *   Replaced manual devcontainer build with `docker/build-push-action` using GHCR for caching (`id: build_devcontainer`).
    *   Made the final production image push step (`Build and push`) conditional: `if: success() && (github.event_name == 'push')`.
    *   Corrected step order for `devmeta`.
    *   Added `type=ref,event=pr` to devcontainer image metadata (`id: devmeta`).
    *   Corrected GHCR image name definition: removed `DEV_IMAGE_NAME` from top-level `env`, added a `run` step within the `docker` job to set `DEV_IMAGE_NAME` dynamically using `echo ... | tr '[:upper:]' '[:lower:]'` and `$GITHUB_ENV`.
    *   Resolved `shellcheck` warning by double-quoting `$GITHUB_ENV`.
    *   Added `permissions: packages: write` to the `docker` job to allow pushing to GHCR.
    *   Removed redundant `source` job.
    *   Removed redundant `docker pull ${{ env.DEV_IMAGE_NAME }}:latest` step.
    *   Modified `Build and Cache Devcontainer Image` step to use `:buildcache` for `cache-from`/`cache-to` instead of `:latest`.
-   Updated this `activeContext.md`.

## Decisions & Notes

-   Using system packages for test dependencies simplifies the CI build process.
-   `.dockerignore` is crucial for keeping production build contexts clean.
-   Aligning devcontainer resource locations (via symlinks) with production container locations (via copy) simplifies build scripts and testing.
-   Running tests that write output from within `$BATS_TMPDIR` avoids container volume mount permission issues.
-   Using an environment variable (`DOCKER_IMAGE_TAG`) allows the Docker usage tests (`tests/docker.bats`) to work correctly in both local (defaulting to `typst-cv:latest`) and CI environments (using the specific testing tag).
-   When using `docker run` with an `ENTRYPOINT`, the command specified after the image name is passed as arguments *to* the entrypoint script.
-   **Devcontainer Caching:** Use GHCR (`ghcr.io/${{ github.repository }}/devcontainer`, ensuring lowercase) for caching the devcontainer image. Use a dedicated tag (`:buildcache`) for `cache-from` and `cache-to` refs. Push cache on every run (PRs and pushes). Set the `DEV_IMAGE_NAME` env var dynamically within the job using a `run` step and `$GITHUB_ENV`. Requires `permissions: packages: write` on the job. The image itself should still be tagged with `:latest` (along with other dynamic tags like `pr-X`).
-   **Production Image Push:** Only push the final tagged production image to Docker Hub on `push` events (to `main` or tags), not on `pull_request` events. Add `type=ref,event=pr` tag to metadata to ensure a tag always exists for PR builds, even though it won't be pushed.
-   **Redundant Steps Removed:** The `source` job and the explicit `docker pull` for the devcontainer image were removed as they were unnecessary.

## Recent Actions (This Session Continued)

-   **Attempted CodeQL:** Created `.github/workflows/codeql-analysis.yml` but removed it after discovering Lua is unsupported and Bash support caused errors (`Did not recognize the following languages: bash`).
-   **Added Docker Image Scanning:** Added a `scan-image` job to `.github/workflows/ci.yml` using `aquasecurity/trivy-action` to scan the `${{ env.IMAGE_TAG_TESTING }}` image for HIGH/CRITICAL vulnerabilities after the `docker` job and before the `release` job. Updated `release` job dependency.
-   **Added Dependabot:** Created `.github/dependabot.yml` to configure weekly checks for updates to the base Docker image and GitHub Actions used in workflows.
-   **Fixed Dependabot CI Failure:** Made the initial Docker Hub login step in `ci.yml` conditional (`if: github.actor != 'dependabot[bot]'`) to prevent errors due to missing secrets in the Dependabot context.
-   Updated this `activeContext.md`.
-   **Unified Font Awesome Installation:**
    -   Modified `Dockerfile` to remove `apk add font-awesome*` and add a new multi-stage build (`fa-builder`) to download and extract Font Awesome v6.7.2 OTF fonts from GitHub releases. Copied fonts from this stage to `/usr/share/fonts/fontawesome6/` in the final image.
    -   Modified `.devcontainer/Dockerfile.ubuntu` to use an `ARG FA_VERSION=6.7.2` and reference `${FA_VERSION}` in the existing Font Awesome download/extract commands for consistency.
-   Updated `memory-bank/techContext.md` to reflect the unified Font Awesome installation method.
-   Updated this `activeContext.md`.

## Decisions & Notes

-   Using system packages for test dependencies simplifies the CI build process.
-   `.dockerignore` is crucial for keeping production build contexts clean.
-   Aligning devcontainer resource locations (via symlinks) with production container locations (via copy) simplifies build scripts and testing.
-   Running tests that write output from within `$BATS_TMPDIR` avoids container volume mount permission issues.
-   Using an environment variable (`DOCKER_IMAGE_TAG`) allows the Docker usage tests (`tests/docker.bats`) to work correctly in both local (defaulting to `typst-cv:latest`) and CI environments (using the specific testing tag).
-   When using `docker run` with an `ENTRYPOINT`, the command specified after the image name is passed as arguments *to* the entrypoint script.
-   **Devcontainer Caching:** Use GHCR (`ghcr.io/${{ github.repository }}/devcontainer`, ensuring lowercase) for caching the devcontainer image. Use a dedicated tag (`:buildcache`) for `cache-from` and `cache-to` refs. Push cache on every run (PRs and pushes). Set the `DEV_IMAGE_NAME` env var dynamically within the job using a `run` step and `$GITHUB_ENV`. Requires `permissions: packages: write` on the job. The image itself should still be tagged with `:latest` (along with other dynamic tags like `pr-X`).
-   **Production Image Push:** Only push the final tagged production image to Docker Hub on `push` events (to `main` or tags), not on `pull_request` events. Add `type=ref,event=pr` tag to metadata to ensure a tag always exists for PR builds, even though it won't be pushed.
-   **Redundant Steps Removed:** The `source` job and the explicit `docker pull` for the devcontainer image were removed as they were unnecessary.
-   **Font Awesome Installation:** Unified approach using GitHub releases (v6.7.2) via multi-stage build in production `Dockerfile` and ARG/variable in devcontainer `Dockerfile.ubuntu`. This ensures consistency and avoids relying on potentially outdated system packages.

## Immediate Next Steps

-   Update `progress.md`.
-   **User Action:** Commit the changes (including `Dockerfile`, `.devcontainer/Dockerfile.ubuntu`, and Memory Bank files).
-   **User Action:** Trigger the CI workflow (`ci.yml`) and verify it passes, including the Docker builds.
-   Complete the task.
