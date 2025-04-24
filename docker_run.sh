#!/bin/bash
set -e

# Default values
INPUT_PATH=""
DIRECTORY="False"
IMAGELESS="False"
DOCS_PATH="$(pwd)/documents"
OUTPUTS_PATH="$(pwd)/outputs"


# Function to print usage information
usage() {
  echo "Usage: $0 -p <path> [--directory] [--imageless] [--docs <documents_path>] [--outputs <outputs_path>]"
  echo "  -p, --path         : Relative path (file or directory) inside the documents folder (required)."
  echo "  -d, --directory    : Process recursively if present (optional flag)."
  echo "  -i, --imageless    : Remove embedded images after conversion if present (optional flag)."
  echo "  --docs             : Path to the documents folder (default: $(pwd)/documents)."
  echo "  --outputs          : Path to the outputs folder (default: $(pwd)/outputs)."
  exit 1
}

# If no arguments are provided, print usage and exit.
if [ $# -eq 0 ]; then
  usage
fi

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    -p|--path)
      INPUT_PATH="$2"
      shift 2
      ;;
    -d|--directory)
      DIRECTORY="True"
      shift 1
      ;;
    -i|--imageless)
      IMAGELESS="True"
      shift 1
      ;;
    --docs)
      DOCS_PATH="$2"
      shift 2
      ;;
    --outputs)
      OUTPUTS_PATH="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      usage
      ;;
  esac
done

# Check that the required --path argument was provided
if [ -z "$INPUT_PATH" ]; then
  echo "Error: --path is required."
  usage
fi

# Verify that the target path exists inside the documents directory.
TARGET_PATH="$DOCS_PATH/$INPUT_PATH"
if [ ! -e "$TARGET_PATH" ]; then
  echo "Error: The path '$TARGET_PATH' does not exist."
  exit 1
fi

echo "Using the following parameters:"
echo "  Path:        $INPUT_PATH"
echo "  DIRECTORY:   $DIRECTORY"
echo "  IMAGELESS:   $IMAGELESS"
echo "  Documents:   $DOCS_PATH"
echo "  Outputs:     $OUTPUTS_PATH"

# Run the Docker container with the proper environment variables and volume mounts.
docker run --rm \
  --pull=always \
  -e DIRECTORY="$DIRECTORY" \
  -e IMAGELESS="$IMAGELESS" \
  -v "$DOCS_PATH":/app/documents \
  -v "$OUTPUTS_PATH":/app/outputs \
  aimilefth/docling "$INPUT_PATH"
