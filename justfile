# Justfile for common development tasks

# Variables
bats_executable := "tests/bats/bin/bats"
unit_tests_file := "tests/unit/build_sh.bats"
filter_tests_file := "tests/filter/filters.bats" # Updated path
e2e_tests_script := "tests/test_e2e.sh"

# Default task
default:
    @just --list

# Run all linters/formatters
lint:
    pre-commit run --all-files

# Run unit tests
test-unit:
    {{bats_executable}} {{unit_tests_file}}

# Run filter tests (Pandoc Lua filters)
test-filter:
    {{bats_executable}} {{filter_tests_file}} # Use bats now

# Run E2E smoke tests (PDF generation)
test-e2e:
    sh {{e2e_tests_script}}

# Run Docker usage tests (requires image built, e.g., via `just build-docker`)
test-docker:
    {{bats_executable}} tests/docker.bats

# Run all tests (including Docker tests)
test: test-unit test-filter test-e2e test-docker
    @echo "All tests passed!"

# Clean temporary files (if any - currently handled by tests)
clean:
    @echo "No specific clean actions defined."

# Build example files (useful for quick checks)
build-examples:
    ./build.sh --output-dir examples tests/fixtures/example-cv.md
    ./build.sh --output-dir examples tests/fixtures/example-letter.md --type letter
    @echo "Example PDFs built in ./examples/"

# Build the default Docker image (Alpine-based)
build-docker tag='latest':
    docker build --pull -t typst-cv:{{tag}} -f Dockerfile .

# Build the Fedora-based Docker image
build-docker-fedora tag='latest-fedora':
    docker build --pull -t typst-cv:{{tag}} -f Dockerfile.fedora .
