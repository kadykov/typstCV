#!/usr/bin/env bats

# Load Bats helpers using bats_load_library for system packages
bats_load_library 'bats-support'
bats_load_library 'bats-assert'

# --- Variables ---
# Assumes the image is built with the 'latest' tag locally
DOCKER_IMAGE="typst-cv:latest"
FIXTURES_DIR="tests/fixtures" # Relative path inside the devcontainer
OUTPUT_DIR_TMP=""

# --- Setup & Teardown ---
setup() {
  # Ensure the image exists locally
  docker image inspect "$DOCKER_IMAGE" > /dev/null 2>&1 || {
    echo "!!! Docker image '$DOCKER_IMAGE' not found. Build it first (e.g., 'just build-docker')." >&3
    return 1
  }
  # Create a temporary output directory for this test run
  OUTPUT_DIR_TMP=$(mktemp -d)
}

teardown() {
  # Clean up temporary output directory
  if [ -n "$OUTPUT_DIR_TMP" ]; then
    rm -rf "$OUTPUT_DIR_TMP"
  fi
}

# --- Test Cases ---

@test "docker run (no args): shows usage message" {
  # Run without arguments, expect usage message and non-zero exit code
  run docker run --rm "$DOCKER_IMAGE"
  assert_failure # Script should exit with error if no input given
  assert_output --partial "Usage: /usr/local/bin/build.sh"
}

@test "docker run <file>: generates PDF output" {
  local input_file="$FIXTURES_DIR/example-cv.md"
  local output_file="$OUTPUT_DIR_TMP/example-cv.pdf"

  # Mount fixtures read-only using host path (should work with DinD), mount output dir writable
  run docker run --rm \
    -v "$(pwd)/${FIXTURES_DIR}:/test-fixtures:ro" \
    -v "$OUTPUT_DIR_TMP:/output" \
    "$DOCKER_IMAGE" --output-dir /output /test-fixtures/example-cv.md

  assert_success
  assert [ -f "$output_file" ]
  # Basic check: is it a PDF file?
  run file "$output_file"
  assert_output --partial "PDF document"
}

@test "docker run <file> --type letter: generates letter PDF" {
  local input_file="$FIXTURES_DIR/example-letter.md"
  local output_file="$OUTPUT_DIR_TMP/example-letter.pdf"

  run docker run --rm \
    -v "$(pwd)/${FIXTURES_DIR}:/test-fixtures:ro" \
    -v "$OUTPUT_DIR_TMP:/output" \
    "$DOCKER_IMAGE" --output-dir /output --type letter /test-fixtures/example-letter.md

  assert_success
  assert [ -f "$output_file" ]
  run file "$output_file"
  assert_output --partial "PDF document"
}

@test "docker run stdin > stdout: pipes PDF" {
  local input_file="$FIXTURES_DIR/example-cv-stdin.md" # Use the new minimal fixture
  local output_file="$OUTPUT_DIR_TMP/stdout.pdf"

  # Pipe input file to docker run, redirect output to file
  # Mount fixtures read-only using host path (though not strictly needed for this fixture)
  # Pass '-' to build.sh to indicate reading from stdin
  run bash -c "cat \"./$input_file\" | docker run --rm -i \
    -v \"$(pwd)/${FIXTURES_DIR}:/test-fixtures:ro\" \
    \"$DOCKER_IMAGE\" - --output - > \"$output_file\"" # Note: -i is needed for stdin, '-' tells build.sh to use stdin

  assert_success
  assert [ -f "$output_file" ]
  assert [ -s "$output_file" ] # Check if file is not empty
  run file "$output_file"
  assert_output --partial "PDF document"
}

@test "docker run --set: overrides metadata" {
  local input_file="$FIXTURES_DIR/example-cv.md"
  local output_file="$OUTPUT_DIR_TMP/override.pdf"
  local override_author="Test Override Author" # Changed variable name for clarity

  # Explicitly set the output filename within the container
  # Use --set author=... to match the variable used in YAML/template
  run docker run --rm \
    -v "$(pwd)/${FIXTURES_DIR}:/test-fixtures:ro" \
    -v "$OUTPUT_DIR_TMP:/output" \
    "$DOCKER_IMAGE" --output-dir /output --output override.pdf --set author="$override_author" /test-fixtures/example-cv.md

  assert_success
  # Check the expected file exists on the host via the volume mount
  assert [ -f "$output_file" ]

  # Requires pdftotext (should be available on host if devcontainer is used, or install locally)
  # This check is basic, assumes pdftotext is available
  if command -v pdftotext &> /dev/null; then
    run pdftotext "$output_file" -
    assert_output --partial "$override_author" # Check for the correct override value
  else
    skip "pdftotext not found, skipping content check"
  fi
}
