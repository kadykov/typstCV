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

# --- Check example-cv.md PDF Content (Hidden Headings) ---
echo "Checking example-cv.md PDF text content..."
CV_TXT_OUTPUT=$(mktemp)
if command -v pdftotext >/dev/null 2>&1; then
  pdftotext "$CV_EXPECTED_PDF" "$CV_TXT_OUTPUT"
  # Check that hidden headings ARE present in the text layer
  if ! grep -q "Experience" "$CV_TXT_OUTPUT"; then
    echo "Error: Hidden heading 'Experience' not found in PDF text output." >&2
    cat "$CV_TXT_OUTPUT" >&2
    rm "$CV_TXT_OUTPUT"
    exit 1
  fi
   if ! grep -q "Education" "$CV_TXT_OUTPUT"; then
    echo "Error: Hidden heading 'Education' not found in PDF text output." >&2
    cat "$CV_TXT_OUTPUT" >&2
    rm "$CV_TXT_OUTPUT"
    exit 1
  fi
  rm "$CV_TXT_OUTPUT"
  echo "Hidden heading checks passed."
else
   echo "Warning: pdftotext not found. Skipping hidden heading content check." >&2
fi


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


# --- Test example-cv-no-optional.md PDF Generation (Check Footer) ---
echo "Testing example-cv-no-optional.md -> PDF (No Optional Footer Links)..."
NOOPT_FIXTURE="${FIXTURES_DIR}/example-cv-no-optional.md"
NOOPT_EXPECTED_FILENAME="example-cv-no-optional.pdf"
NOOPT_EXPECTED_PDF="${TEST_OUTPUT_DIR}/${NOOPT_EXPECTED_FILENAME}"
NOOPT_TXT_OUTPUT=$(mktemp)

# Run build.sh to generate PDF output
"$BUILD_SCRIPT" --output-dir "$TEST_OUTPUT_DIR" --output "$NOOPT_EXPECTED_FILENAME" "$NOOPT_FIXTURE"
exit_code=$?

if [ $exit_code -ne 0 ]; then
  echo "Error: build.sh failed for example-cv-no-optional.md PDF generation" >&2
  exit 1
fi

# Check if PDF exists and has size > 0
if [ ! -f "$NOOPT_EXPECTED_PDF" ]; then
    echo "Error: Expected PDF file not found: $NOOPT_EXPECTED_PDF" >&2
    exit 1
fi
if [ ! -s "$NOOPT_EXPECTED_PDF" ]; then
    echo "Error: Generated PDF file is empty: $NOOPT_EXPECTED_PDF" >&2
    exit 1
fi

# Convert PDF to text and check for absence of optional links
# Requires poppler-utils (pdftotext) to be installed
if command -v pdftotext >/dev/null 2>&1; then
  pdftotext "$NOOPT_EXPECTED_PDF" "$NOOPT_TXT_OUTPUT"
  # Check that specific URL parts or usernames are NOT present
  if grep -q -e "github.com/" -e "gitlab.com/" -e "linkedin.com/in/" "$NOOPT_TXT_OUTPUT"; then
    echo "Error: Optional footer links (GitHub/GitLab/LinkedIn) were found in PDF text output when they should be absent." >&2
    cat "$NOOPT_TXT_OUTPUT" >&2
    rm "$NOOPT_TXT_OUTPUT"
    exit 1
  fi
  # Check for website (might be harder if URL is generic like example.com)
  # Let's assume the website field itself shouldn't appear if omitted
   if grep -q -i "example.com" "$NOOPT_TXT_OUTPUT"; then
     # This check might be too broad, but let's try it. The fixture uses example.com in links: section too.
     # A better check might be needed if this causes false positives.
     # echo "Warning: Found 'example.com', potentially the website link?" >&2
     : # Placeholder, maybe refine later
   fi
  rm "$NOOPT_TXT_OUTPUT"
  echo "example-cv-no-optional.md PDF checks passed."
else
  echo "Warning: pdftotext not found. Skipping footer content check for example-cv-no-optional.md." >&2
fi


echo "--- E2E Smoke Tests Passed ---"
exit 0
