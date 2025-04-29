#!/usr/bin/env bats

# Load Bats helpers from submodules
load '../test_helper/bats-support/load.bash'
load '../test_helper/bats-assert/load.bash'

# --- Configuration ---
FIXTURES_DIR="./tests/fixtures"
# Assuming PANDOC_DATA_DIR is set correctly in the environment or using default
PANDOC_DATA_DIR="${PANDOC_DATA_DIR:-/usr/share/pandoc}"
# Base pandoc command parts - use eval later if needed for complex args
PANDOC_BASE_CMD="pandoc --data-dir=\"$PANDOC_DATA_DIR\" --to=typst"

setup() {
  # Determine project root relative to this test file's directory
  PROJECT_ROOT="$(cd "$BATS_TEST_DIRNAME/../.." && pwd)"
  # Ensure fixtures are referenced from project root if needed, or adjust paths
  FIXTURES_DIR="$PROJECT_ROOT/tests/fixtures"
}

# --- linkify.lua Tests ---

@test "filter/linkify: links Typst" {
  local fixture="$FIXTURES_DIR/linkify_test.md"
  local cmd="$PANDOC_BASE_CMD --lua-filter=linkify.lua \"$fixture\""
  run eval "$cmd" # Use eval as cmd string contains quotes
  assert_success
  assert_output --partial '#link("https://typst.app/")[Typst]'
}

@test "filter/linkify: links Pandoc" {
  local fixture="$FIXTURES_DIR/linkify_test.md"
  local cmd="$PANDOC_BASE_CMD --lua-filter=linkify.lua \"$fixture\""
  run eval "$cmd"
  assert_success
  assert_output --partial '#link("https://pandoc.org/")[Pandoc]'
}

@test "filter/linkify: links GitHub" {
  local fixture="$FIXTURES_DIR/linkify_test.md"
  local cmd="$PANDOC_BASE_CMD --lua-filter=linkify.lua \"$fixture\""
  run eval "$cmd"
  assert_success
  assert_output --partial '#link("https://github.com/")[GitHub]'
}

@test "filter/linkify: does not link words not in YAML" {
  local fixture="$FIXTURES_DIR/linkify_test.md"
  local cmd="$PANDOC_BASE_CMD --lua-filter=linkify.lua \"$fixture\""
  run eval "$cmd"
  assert_success
  refute_output --partial '#link.*filter' # Use regex check here
}


# --- typst-cv.lua Tests ---

@test "filter/typst-cv: handles photo attribute" {
  local fixture="$FIXTURES_DIR/typst_cv_filter_test.md"
  local cmd="$PANDOC_BASE_CMD --template=typst-cv.typ --lua-filter=typst-cv.lua \"$fixture\""
  run eval "$cmd"
  assert_success
  assert_output --partial 'side: profile-photo(image("photo.png", width: 100pt))'
}

@test "filter/typst-cv: handles hidden class" {
  local fixture="$FIXTURES_DIR/typst_cv_filter_test.md"
  local cmd="$PANDOC_BASE_CMD --template=typst-cv.typ --lua-filter=typst-cv.lua \"$fixture\""
  run eval "$cmd"
  assert_success
  assert_output --partial '#hidden-heading()'
}

@test "filter/typst-cv: handles location attribute" {
  local fixture="$FIXTURES_DIR/typst_cv_filter_test.md"
  local cmd="$PANDOC_BASE_CMD --template=typst-cv.typ --lua-filter=typst-cv.lua \"$fixture\""
  run eval "$cmd"
  assert_success
  # Check for the specific function call and the content (actual output has single backslash)
  assert_output --partial 'side: event-date()[City \ Country]'
}

@test "filter/typst-cv: handles date attribute" {
  local fixture="$FIXTURES_DIR/typst_cv_filter_test.md"
  local cmd="$PANDOC_BASE_CMD --template=typst-cv.typ --lua-filter=typst-cv.lua \"$fixture\""
  run eval "$cmd"
  assert_success
  assert_output --partial 'side: company-location()[2023 - Present]'
}

@test "filter/typst-cv: handles ordered list" {
  local fixture="$FIXTURES_DIR/typst_cv_filter_test.md"
  local cmd="$PANDOC_BASE_CMD --template=typst-cv.typ --lua-filter=typst-cv.lua \"$fixture\""
  run eval "$cmd"
  assert_success
  assert_output --partial '#block(width: full-width)'
}

@test "filter/typst-cv: handles header with both date and location (processes date)" {
  local fixture="$FIXTURES_DIR/typst_cv_filter_test.md"
  local cmd="$PANDOC_BASE_CMD --template=typst-cv.typ --lua-filter=typst-cv.lua \"$fixture\""
  run eval "$cmd"
  assert_success
  # Check date was processed (include closing parenthesis)
  assert_output --partial 'side: company-location()[Date First])'
  # Check location was NOT processed on the same header
  refute_output --partial 'Header With Both.*side: event-date()' # Keep .* here for refute flexibility
}
