#!/bin/sh
set -e

# E2E smoke test script for build.sh (generating PDF)

# --- Configuration ---
FIXTURES_DIR="./tests/fixtures"
BUILD_SCRIPT="./build.sh"
TEST_OUTPUT_DIR=$(mktemp -d)

echo "--- Running E2E Smoke Tests (PDF Output) ---"

cleanup() {
  echo "Cleaning up temporary directory: $TEST_OUTPUT_DIR"
  rm -rf "$TEST_OUTPUT_DIR"
}
trap cleanup EXIT # Ensure cleanup happens on script exit

# --- Test example-cv.md PDF Generation ---
echo "Testing example-cv.md -> PDF..."
CV_FIXTURE="${FIXTURES_DIR}/example-cv.md"
CV_EXPECTED_FILENAME="example-cv.pdf"
CV_EXPECTED_PDF="${TEST_OUTPUT_DIR}/${CV_EXPECTED_FILENAME}"

# Run build.sh to generate PDF output, specifying output dir and filename
"$BUILD_SCRIPT" --output-dir "$TEST_OUTPUT_DIR" --output "$CV_EXPECTED_FILENAME" "$CV_FIXTURE"
exit_code=$?

if [ $exit_code -ne 0 ]; then
  echo "Error: build.sh failed for example-cv.md PDF generation" >&2
  exit 1
fi

# Check if PDF exists and has size > 0
if [ ! -f "$CV_EXPECTED_PDF" ]; then
    echo "Error: Expected PDF file not found: $CV_EXPECTED_PDF" >&2
    exit 1
fi
if [ ! -s "$CV_EXPECTED_PDF" ]; then
    echo "Error: Generated PDF file is empty: $CV_EXPECTED_PDF" >&2
    exit 1
fi
echo "example-cv.md PDF generated successfully."

# --- Test example-letter.md PDF Generation ---
echo "Testing example-letter.md -> PDF..."
LETTER_FIXTURE="${FIXTURES_DIR}/example-letter.md"
LETTER_EXPECTED_FILENAME="example-letter.pdf"
LETTER_EXPECTED_PDF="${TEST_OUTPUT_DIR}/${LETTER_EXPECTED_FILENAME}"

# Run build.sh to generate PDF output, specifying output dir and filename
"$BUILD_SCRIPT" --output-dir "$TEST_OUTPUT_DIR" --output "$LETTER_EXPECTED_FILENAME" "$LETTER_FIXTURE" --type letter
exit_code=$?

if [ $exit_code -ne 0 ]; then
  echo "Error: build.sh failed for example-letter.md PDF generation" >&2
  exit 1
fi

# Check if PDF exists and has size > 0
if [ ! -f "$LETTER_EXPECTED_PDF" ]; then
    echo "Error: Expected PDF file not found: $LETTER_EXPECTED_PDF" >&2
    exit 1
fi
if [ ! -s "$LETTER_EXPECTED_PDF" ]; then
    echo "Error: Generated PDF file is empty: $LETTER_EXPECTED_PDF" >&2
    exit 1
fi
echo "example-letter.md PDF generated successfully."


echo "--- E2E Smoke Tests Passed ---"
exit 0
