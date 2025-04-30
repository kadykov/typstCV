#!/usr/bin/env bats

# Load Bats helpers using bats_load_library for system packages
bats_load_library 'bats-support'
bats_load_library 'bats-assert'

setup() {
  # Create a dummy input file for tests that need one
  mkdir -p "$BATS_TMPDIR/fixtures"
  cat > "$BATS_TMPDIR/fixtures/dummy.md" <<EOF
---
title: Dummy Doc
---
# Hello
EOF
  # Determine project root relative to this test file's directory
  PROJECT_ROOT="$(cd "$BATS_TEST_DIRNAME/../.." && pwd)"
  SCRIPT="$PROJECT_ROOT/build.sh"

  # build.sh should have execute permissions set by git
}

teardown() {
  # Clean up temporary files
  rm -rf "$BATS_TMPDIR/fixtures"
}

@test "build.sh: shows usage with no arguments" {
  run "$SCRIPT"
  assert_failure
  # Check for the specific error message first
  assert_output --partial "Error: Input file or '-' (for stdin) is required."
}

# Removed the -h test as the script doesn't support it

@test "build.sh: fails with non-existent input file" {
  run "$SCRIPT" "nonexistentfile.md"
  assert_failure
  assert_output --partial "Input file not found"
}

@test "build.sh: succeeds with valid input file" {
  # This test assumes the basic pandoc/typst pipeline works
  # It mainly checks if the script finds the input and doesn't crash
  # We check for PDF existence/size in E2E tests
  run "$SCRIPT" "$BATS_TMPDIR/fixtures/dummy.md"
  assert_success
  # Check if the default output file exists (relative to where script is run)
  assert [ -f "dummy.pdf" ]
  rm -f dummy.pdf # Clean up output
}

@test "build.sh: creates specified output file with --output" {
  # Use absolute path for output file within BATS_TMPDIR
  local outfile_name="specific_name.pdf"
  local outdir="$BATS_TMPDIR/output"
  local outfile_abs="$outdir/$outfile_name"
  mkdir -p "$outdir"
  # Pass the filename only to --output, use --output-dir for the directory
  run "$SCRIPT" "$BATS_TMPDIR/fixtures/dummy.md" --output "$outfile_name" --output-dir "$outdir"
  assert_success
  assert [ -f "$outfile_abs" ]
  # No default output should be created in CWD
  refute [ -f "dummy.pdf" ]
  rm -rf "$outdir" # Clean up
}

@test "build.sh: succeeds if --output directory does not exist (creates it)" {
  local outfile_name="created_dir_out.pdf"
  local outdir="$BATS_TMPDIR/nonexistent_dir"
  local outfile_abs="$outdir/$outfile_name"
  # Ensure dir doesn't exist initially
  rm -rf "$outdir"
  refute [ -d "$outdir" ]

  run "$SCRIPT" "$BATS_TMPDIR/fixtures/dummy.md" --output "$outfile_name" --output-dir "$outdir"
  # Should succeed because the script creates the output directory
  assert_success
  assert [ -f "$outfile_abs" ]
  rm -rf "$outdir" # Clean up
}

# TODO: Add more tests for --type, --set, TYPSTCV_*, stdin/stdout etc.
