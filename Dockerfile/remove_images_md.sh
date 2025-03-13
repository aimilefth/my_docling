#!/bin/bash

# Check if the input file is provided
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <markdown_file>"
  exit 1
fi

# Input markdown file
input_file="$1"

# Check if the file exists
if [ ! -f "$input_file" ]; then
  echo "Error: File '$input_file' not found."
  exit 1
fi

# Get the base name (without extension) and directory of the input file
base_name="$(basename "$input_file" .md)"
dir_name="$(dirname "$input_file")"

# Output file path
output_file="${dir_name}/${base_name}_imageless.md"

# Use sed to remove lines containing ![Image](...)
sed -E "/!\\[Image\\]\\(.+\\)/d" "$input_file" > "$output_file"

echo "Created imageless markdown file: $output_file"