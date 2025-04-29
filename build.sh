#!/bin/sh
set -e

# --- Default values ---
doc_type="" # cv or letter, inferred if empty
output_file=""
output_dir="."
input_file=""
# output_format="pdf" # Reverted: Removed output_format
typst_input_args=""
use_override_pipeline=false

# --- Helper Functions ---
usage() {
  # Reverted: Removed --output-format from usage
  echo "Usage: $0 <input_markdown_file | -> [--type <cv|letter>] [--output <output_pdf_file | ->] [--output-dir <directory>] [--set KEY=VALUE]..."
  echo ""
  echo "  <input_markdown_file | -> : Path to input Markdown file, or '-' for stdin."
  echo "  --type <cv|letter>      : Explicitly set document type (default: inferred from input filename, fallback 'cv')."
  echo "  --output <output_pdf_file | ->: Output PDF file path, or '-' for stdout (default: based on input filename)."
  echo "  --output-dir <directory>  : Directory for output file (default: '.'). Created if it doesn't exist."
  # echo "  --output-format <pdf|typst>: Format for the output file (default: 'pdf')."
  echo "  --set KEY=VALUE         : Override metadata. KEY is converted to lowercase for Typst."
  echo ""
  echo "Overrides can also be provided via environment variables prefixed with TYPSTCV_"
  echo "(e.g., TYPSTCV_EMAIL=me@private.com)."
  exit 1
}

# --- Argument Parsing ---
while [ $# -gt 0 ]; do
  case "$1" in
    -) # Handle stdin explicitly
      if [ -n "$input_file" ]; then echo "Error: Only one input file allowed ('-' or filename)." >&2; usage; fi
      input_file="-"
      shift
      ;;
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
    # Reverted: Removed --output-format parsing
    # --output-format)
    #   if [ -z "$2" ]; then echo "Error: --output-format requires an argument." >&2; usage; fi
    #   if [ "$2" != "pdf" ] && [ "$2" != "typst" ]; then echo "Error: --output-format must be 'pdf' or 'typst'." >&2; usage; fi
    #   output_format="$2"
    #   shift 2
    #   ;;
    --set)
      if [ -z "$2" ]; then echo "Error: --set requires an argument (KEY=VALUE)." >&2; usage; fi
      key=$(echo "$2" | cut -d= -f1 | tr '[:upper:]' '[:lower:]')
      value=$(echo "$2" | cut -d= -f2-)
      if [ -z "$key" ] || [ -z "$value" ]; then echo "Error: Invalid --set format. Use KEY=VALUE." >&2; usage; fi
      # shellcheck disable=SC2089
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

# Force override pipeline for CVs to handle potential photo paths correctly via input_dir_abs
if [ "$doc_type" = "cv" ]; then
  echo "Info: Forcing override pipeline for CV to handle potential relative image paths." >&2
  use_override_pipeline=true
fi

# --- Determine Output Path ---
# Reverted: Simplified output path logic
output_arg="" # Will be '-o path' or '-' for stdout

if [ "$output_file" = "-" ]; then
  echo "Info: Outputting PDF to stdout." >&2
  output_arg="-"
  # PDF to stdout requires the typst compile step, even if no other overrides exist
  use_override_pipeline=true
elif [ -n "$output_file" ]; then
  # User specified exact output file path relative to output_dir
  output_path="${output_dir}/${output_file}"
  output_arg="-o $output_path"
else
  # Default output filename based on input (only if input is not stdin)
  if [ "$input_file" != "-" ]; then
    base_name=$(basename "$input_file" .md)
    output_path="${output_dir}/${base_name}.pdf" # Always .pdf now
    output_arg="-o $output_path"
  # If input is stdin, output MUST be stdout ('-')
  elif [ "$input_file" = "-" ] && [ "$output_file" != "-" ]; then
     # This case is only reached if input is '-' and output was NOT specified as '-' OR was empty
     echo "Error: Output must be explicitly specified as stdout ('--output -') when reading from stdin ('-')." >&2
     usage
  fi
  # If input is stdin and output is stdout, output_arg remains "-"
  # If input is file and output is file, output_arg is "-o path"
fi

# Create output directory if needed and not outputting to stdout
if [ "$output_arg" != "-" ]; then
  mkdir -p "$(dirname "$output_path")"
  echo "Info: Output PDF path: $output_path" >&2
fi

# Reverted: Removed adjustment logic based on output_format


# --- Build Commands ---
# Check if PANDOC_DATA_DIR is set, provide default if not (useful if run outside Docker)
# Ensure PANDOC_DATA_DIR is exported so subshells (like in pipes) might see it, though direct arg is better.
export PANDOC_DATA_DIR="${PANDOC_DATA_DIR:-/usr/share/pandoc}"
# Determine resource path (input file's directory or '.' for stdin)
resource_path="."
if [ "$input_file" != "-" ]; then
  # Handle potential edge case where input file is in root (dirname returns '.')
  dir=$(dirname "$input_file")
  if [ "$dir" != "." ]; then
    resource_path="$dir"
  fi
fi
# Add --data-dir to the base command - resource path added per-command
# shellcheck disable=SC2089
pandoc_base="pandoc --data-dir $PANDOC_DATA_DIR --wrap=preserve --pdf-engine=typst --lua-filter=linkify.lua --lua-filter=typst-cv.lua"

# --- Calculate Absolute Input Directory for Typst ---
input_dir_abs=""
if [ "$input_file" != "-" ]; then
  # Get absolute path of the input file
  # Handle relative paths by prepending PWD if needed
  case "$input_file" in
    /*) input_file_abs="$input_file" ;;
    *) input_file_abs="$PWD/$input_file" ;;
  esac
  # Get the directory part
  input_dir_abs=$(dirname "$input_file_abs")
  # Add to typst args if not empty (should always be set if input is a file)
  if [ -n "$input_dir_abs" ]; then
    # shellcheck disable=SC2089
    typst_input_args="$typst_input_args --input input_dir_abs=\"$input_dir_abs\""
    # Note: This variable is ONLY used by the override pipeline's typst compile step.
    # The direct pandoc pipeline cannot use it.
  fi
fi


# --- Execute Pipeline ---
# Reverted: Simplified execution logic back to original override check
echo "Info: Starting build..." >&2
if [ "$use_override_pipeline" = true ]; then
  echo "Info: Using override pipeline (Pandoc -> Typst -> PDF)." >&2
  # Construct the pandoc part of the pipe
  pandoc_cmd_part="$pandoc_base --to=typst --template=$template_file $input_arg"

  # Prepare typst output argument.
  # Typst compile takes the output path directly as the last argument,
  # or '-' for stdout. It does NOT use '-o'.
  typst_output_arg=""
  if [ "$output_arg" = "-" ]; then
    typst_output_arg="-" # Pass '-' for stdout
  elif echo "$output_arg" | grep -q -e '^-o '; then
    # Extract path after '-o ' for the argument
    typst_output_arg=$(echo "$output_arg" | sed 's/^-o //')
  fi

  # Determine the root directory for Typst. Use absolute path if available, else default to /data for stdin.
  typst_root_dir="/data" # Default for stdin
  if [ -n "$input_dir_abs" ]; then
      typst_root_dir="$input_dir_abs"
  fi

  # Execute pandoc part directly and pipe to typst compile
  # Add --root argument. Pass calculated output argument ($typst_output_arg) directly to typst.
  # shellcheck disable=SC2086,SC2090 # We want word splitting for $typst_input_args; quotes are handled there. $typst_output_arg is single path or '-'.
  pandoc_pipe_cmd="$pandoc_cmd_part | typst compile --root \"$typst_root_dir\" $typst_input_args - $typst_output_arg"

  # Execute the combined pipeline command using sh -c for potentially better handling of pipes/quotes.
  sh -c "$pandoc_pipe_cmd"
  # Check exit status of the pipe (specifically the last command, typst compile)
  pipe_status=$?
  if [ $pipe_status -ne 0 ]; then
      echo "Error: Typst compilation failed with status $pipe_status." >&2
      exit $pipe_status
  fi

else
  echo "Info: Using direct pipeline (Pandoc -> PDF)." >&2
  # Construct the full pandoc command parts, adding resource path here
  # shellcheck disable=SC2089
  pandoc_cmd_part1="$pandoc_base --resource-path \"$resource_path\" --template=$template_file"
  pandoc_cmd_part2="$input_arg"
  # $output_arg contains '-o path' or '-' for stdout
  # Execute directly, let shell handle splitting of $output_arg
  # shellcheck disable=SC2086,SC2090 # We want word splitting; quotes in var are for target cmd
  $pandoc_cmd_part1 "$pandoc_cmd_part2" $output_arg
fi


echo "Info: Build finished." >&2
exit 0
