#!/usr/bin/env bats

# Load Bats helpers
bats_load_library 'bats-support'
bats_load_library 'bats-assert'
# bats_load_library 'bats-file' # Can add later if needed

# --- Variables ---
PROJECT_ROOT=""
SCRIPT=""
FIXTURES_DIR=""
TEST_OUTPUT_DIR=""

# --- Setup & Teardown ---
setup() {
  # Determine project root relative to this test file's directory
  PROJECT_ROOT="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  SCRIPT="$PROJECT_ROOT/build.sh"
  FIXTURES_DIR="$PROJECT_ROOT/tests/fixtures"
  TEST_OUTPUT_DIR="$BATS_TMPDIR/test_output"

  # Create temporary output directory
  mkdir -p "$TEST_OUTPUT_DIR"

  # Ensure build script is executable (should be via git, but double-check)
  # No - this caused issues before. Assume it's executable.
  # chmod +x "$SCRIPT"
}

teardown() {
  # Clean up temporary output directory
  rm -rf "$TEST_OUTPUT_DIR"
}

# --- Test Cases ---

@test "e2e: generates PDF for example-cv.md" {
  local input_fixture="$FIXTURES_DIR/example-cv.md"
  local output_filename="example-cv.pdf"
  local output_file_abs="$TEST_OUTPUT_DIR/$output_filename"

  # Run build.sh from /tmp to avoid pandoc permission issues on mounted volume
  # Pass absolute paths for input/output-dir
  run bash -c "cd \"$BATS_TMPDIR\" && \"$SCRIPT\" --output-dir \"$TEST_OUTPUT_DIR\" --output \"$output_filename\" \"$input_fixture\""
  assert_success "[build.sh] PDF generation failed"

  run test -f "$output_file_abs"
  assert_success "Output PDF file not found: $output_file_abs"
  run test -s "$output_file_abs"
  assert_success "Output PDF file is empty: $output_file_abs"
}

@test "e2e: example-cv.md PDF contains hidden headings" {
  local input_fixture="$FIXTURES_DIR/example-cv.md"
  local output_filename="example-cv-headings.pdf" # Use different name to avoid conflict if run in parallel
  local output_file_abs="$TEST_OUTPUT_DIR/$output_filename"

  # Generate the PDF first (run from /tmp)
  run bash -c "cd \"$BATS_TMPDIR\" && \"$SCRIPT\" --output-dir \"$TEST_OUTPUT_DIR\" --output \"$output_filename\" \"$input_fixture\""
  assert_success "[build.sh] PDF generation for heading check failed"

  run test -f "$output_file_abs"
  assert_success "Output PDF file for heading check not found: $output_file_abs"

  # Check for pdftotext
  run command -v pdftotext
  if [ "$status" -ne 0 ]; then
    skip "pdftotext not found, skipping content check"
  fi

  # Extract text and check content
  run pdftotext "$output_file_abs" -
  assert_success "pdftotext failed"
  assert_output --partial "Experience" "Hidden heading 'Experience' not found"
  assert_output --partial "Education" "Hidden heading 'Education' not found"
}

@test "e2e: generates PDF for example-letter.md" {
  local input_fixture="$FIXTURES_DIR/example-letter.md"
  local output_filename="example-letter.pdf"
  local output_file_abs="$TEST_OUTPUT_DIR/$output_filename"

  # Run build.sh from /tmp, pass --type letter
  run bash -c "cd \"$BATS_TMPDIR\" && \"$SCRIPT\" --output-dir \"$TEST_OUTPUT_DIR\" --output \"$output_filename\" \"$input_fixture\" --type letter"
  assert_success "[build.sh] PDF generation failed for letter"

  run test -f "$output_file_abs"
  assert_success "Output letter PDF file not found: $output_file_abs"
  run test -s "$output_file_abs"
  assert_success "Output letter PDF file is empty: $output_file_abs"
}

@test "e2e: generates PDF for example-cv-no-optional.md" {
  local input_fixture="$FIXTURES_DIR/example-cv-no-optional.md"
  local output_filename="example-cv-no-optional.pdf"
  local output_file_abs="$TEST_OUTPUT_DIR/$output_filename"

  # Run build.sh from /tmp
  run bash -c "cd \"$BATS_TMPDIR\" && \"$SCRIPT\" --output-dir \"$TEST_OUTPUT_DIR\" --output \"$output_filename\" \"$input_fixture\""
  assert_success "[build.sh] PDF generation failed for no-optional CV"

  run test -f "$output_file_abs"
  assert_success "Output no-optional CV PDF file not found: $output_file_abs"
  run test -s "$output_file_abs"
  assert_success "Output no-optional CV PDF file is empty: $output_file_abs"
}

@test "e2e: example-cv-no-optional.md PDF lacks footer links" {
  local input_fixture="$FIXTURES_DIR/example-cv-no-optional.md"
  local output_filename="example-cv-no-optional-links.pdf" # Use different name
  local output_file_abs="$TEST_OUTPUT_DIR/$output_filename"

  # Generate the PDF first (run from /tmp)
  run bash -c "cd \"$BATS_TMPDIR\" && \"$SCRIPT\" --output-dir \"$TEST_OUTPUT_DIR\" --output \"$output_filename\" \"$input_fixture\""
  assert_success "[build.sh] PDF generation for no-optional link check failed"

  run test -f "$output_file_abs"
  assert_success "Output PDF file for no-optional link check not found: $output_file_abs"

  # Check for pdftotext
  run command -v pdftotext
  if [ "$status" -ne 0 ]; then
    skip "pdftotext not found, skipping content check"
  fi

  # Extract text and check content
  run pdftotext "$output_file_abs" -
  assert_success "pdftotext failed"
  # Check that specific URL parts or usernames are NOT present
  refute_output --partial "github.com/" "Found 'github.com/' in no-optional PDF"
  refute_output --partial "gitlab.com/" "Found 'gitlab.com/' in no-optional PDF"
  refute_output --partial "linkedin.com/in/" "Found 'linkedin.com/in/' in no-optional PDF"
}
