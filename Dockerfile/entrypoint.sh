#!/usr/bin/env bash

# Usage example:
#   docker run --rm \
#     -v $(pwd)/documents:/app/documents \
#     -v $(pwd)/outputs:/app/outputs \
#     aimilefth/docling myfile.pdf

PDF_FILE="$1"

if [ -z "$PDF_FILE" ]; then
  echo "Usage: docker run --rm -v \$(pwd)/documents:/app/documents -v \$(pwd)/outputs:/app/outputs aimilefth/docling <PDF_FILENAME>"
  exit 1
fi

DOC_PATH="/app/documents/$PDF_FILE"
OUT_PATH="/app/outputs"

echo "Converting '$DOC_PATH' to Markdown using Docling..."

# Use Docling's CLI with the correct options:
# --to md        -> Output as Markdown
# --output ...   -> Specify the output directory
docling --to md --output "$OUT_PATH" "$DOC_PATH"

echo "Conversion completed. Check $OUT_PATH for the resulting Markdown file(s)."
