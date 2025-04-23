#!/bin/sh
set -e

# --- Default values ---
doc_type="" # cv or letter, inferred if empty
output_file=""
output_dir="."
input_file=""
typst_input_args=""
use_override_pipeline=false

# --- Helper Functions ---
usage() {
  echo "Usage: $0 <input_markdown_file | -> [--type <cv|letter>] [--output <output_pdf_file | ->] [--output-dir <directory>] [--set KEY=VALUE]..."
  echo ""
  echo "  <input_markdown_file | -> : Path to input Markdown file, or '-' for stdin."
  echo "  --type <cv|letter>      : Explicitly set document type (default: inferred from input filename, fallback 'cv')."
  echo "  --output <output_file | ->: Output PDF file path, or '-' for stdout (default: based on input filename)."
  echo "  --output-dir <directory>  : Directory for output file (default: '.'). Created if it doesn't exist."
  echo "  --set KEY=VALUE         : Override metadata. KEY is converted to lowercase for Typst."
  echo ""
  echo "Overrides can also be provided via environment variables prefixed with TYPSTCV_"
  echo "(e.g., TYPSTCV_EMAIL=me@private.com)."
  exit 1
}

# --- Argument Parsing ---
while [ $# -gt 0 ]; do
  case "$1" in
    --type)
      if [ -z "$2" ]; then echo "Error: --type requires an argument." >&2; usage; fi
      if [ "$2" != "cv" ] && [ "$2" != "letter" ]; then echo "Error: --type must be 'cv' or 'letter'." >&2; usage; fi
      doc_type="$2"
      shift 2
      ;;
    --output)
      if [ -z "$2" ]; then echo "Error: --output requires an argument." >&2; usage; fi
      output_file="$2"
      shift 2
      ;;
    --output-dir)
      if [ -z "$2" ]; then echo "Error: --output-dir requires an argument." >&2; usage; fi
      output_dir="$2"
      shift 2
      ;;
    --set)
      if [ -z "$2" ]; then echo "Error: --set requires an argument (KEY=VALUE)." >&2; usage; fi
      key=$(echo "$2" | cut -d= -f1 | tr '[:upper:]' '[:lower:]')
      value=$(echo "$2" | cut -d= -f2-)
      if [ -z "$key" ] || [ -z "$value" ]; then echo "Error: Invalid --set format. Use KEY=VALUE." >&2; usage; fi
      typst_input_args="$typst_input_args --input $key=\"$value\""
      use_override_pipeline=true
      shift 2
      ;;
    --) # End of options
      shift
      break
      ;;
    -*) # Unknown option
      echo "Error: Unknown option $1" >&2
      usage
      ;;
    *) # Input file
      if [ -n "$input_file" ]; then echo "Error: Only one input file allowed." >&2; usage; fi
      input_file="$1"
      shift
      ;;
  esac
done

# --- Input Validation ---
if [ -z "$input_file" ]; then
  echo "Error: Input file or '-' (for stdin) is required." >&2
  usage
fi

input_arg="$input_file"
if [ "$input_file" != "-" ] && [ ! -f "$input_file" ]; then
  echo "Error: Input file not found: $input_file" >&2
  exit 1
fi

# --- Detect Environment Variable Overrides ---
for var in $(env | grep '^TYPSTCV_'); do
  key=$(echo "$var" | cut -d= -f1 | sed 's/^TYPSTCV_//' | tr '[:upper:]' '[:lower:]')
  value=$(echo "$var" | cut -d= -f2-)
   if [ -n "$key" ] && [ -n "$value" ]; then
      typst_input_args="$typst_input_args --input $key=\"$value\""
      use_override_pipeline=true
   fi
done

# --- Determine Document Type ---
if [ -z "$doc_type" ]; then
  if echo "$input_file" | grep -q -i "cv"; then
    doc_type="cv"
  elif echo "$input_file" | grep -q -i "letter"; then
    doc_type="letter"
  else
    echo "Warning: Could not infer document type from filename '$input_file'. Defaulting to 'cv'." >&2
    doc_type="cv"
  fi
fi
template_file="typst-${doc_type}.typ"
echo "Info: Using document type: $doc_type (template: $template_file)" >&2

# --- Determine Output Path ---
output_arg=""
if [ "$output_file" = "-" ]; then
  echo "Info: Outputting to stdout." >&2
  output_arg="-"
  use_override_pipeline=true # Stdout requires the typst compile step
elif [ -n "$output_file" ]; then
  # User specified exact output file
  output_path="${output_dir}/${output_file}"
  output_arg="-o $output_path"
else
  # Default output filename based on input
  if [ "$input_file" = "-" ]; then
    echo "Error: Output file must be specified when reading from stdin (unless outputting to stdout with '--output -')." >&2
    usage
  fi
  base_name=$(basename "$input_file" .md)
  output_path="${output_dir}/${base_name}.pdf"
  output_arg="-o $output_path"
fi

# Create output directory if needed and not outputting to stdout
if [ "$output_arg" != "-" ]; then
  mkdir -p "$(dirname "$output_path")"
  echo "Info: Output path: $output_path" >&2
fi


# --- Build Commands ---
# Check if PANDOC_DATA_DIR is set, provide default if not (useful if run outside Docker)
PANDOC_DATA_DIR="${PANDOC_DATA_DIR:-/usr/share/pandoc}"
pandoc_base="pandoc --data-dir=\"$PANDOC_DATA_DIR\" --wrap=preserve --pdf-engine=typst --lua-filter=linkify.lua --lua-filter=typst-cv.lua"

# --- Execute Pipeline ---
echo "Info: Starting build..." >&2
if [ "$use_override_pipeline" = true ]; then
  echo "Info: Using override pipeline (Pandoc -> Typst)." >&2
  # Need eval to handle spaces in arguments correctly, especially $typst_input_args and paths
  eval "$pandoc_base --to=typst --template=\"$template_file\" \"$input_arg\" | typst compile $typst_input_args - $output_arg"
else
  echo "Info: Using direct pipeline (Pandoc -> PDF)." >&2
  # Need eval for paths
  eval "$pandoc_base --template=\"$template_file\" \"$input_arg\" $output_arg"
fi

echo "Info: Build finished successfully." >&2
exit 0
