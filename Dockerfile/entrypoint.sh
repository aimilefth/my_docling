#!/usr/bin/env bash

# Use environment variables (defaults provided if not set)
DIRECTORY="${DIRECTORY:-False}"
IMAGELESS="${IMAGELESS:-False}"

# Define fixed directories
DOCUMENTS_DIR="/app/documents"
OUTPUT_DIR="/app/outputs"

# Get the input argument (if provided)
INPUT="$1"

if [ "$DIRECTORY" = "True" ]; then
    # In directory mode, the INPUT (if provided) is treated as a subdirectory (relative to DOCUMENTS_DIR).
    # If not provided, process the entire DOCUMENTS_DIR.
    if [ -z "$INPUT" ]; then
        SEARCH_DIR="$DOCUMENTS_DIR"
    else
        SEARCH_DIR="$DOCUMENTS_DIR/$INPUT"
    fi

    if [ ! -d "$SEARCH_DIR" ]; then
        echo "Error: Directory $SEARCH_DIR does not exist."
        exit 1
    fi

    echo "Directory mode enabled. Recursively processing PDFs in $SEARCH_DIR..."

    # Recursively find all PDFs
    find "$SEARCH_DIR" -type f -iname "*.pdf" | while read -r pdf_file; do
        # Compute the file's path relative to DOCUMENTS_DIR
        REL_PATH="${pdf_file#$DOCUMENTS_DIR/}"
        # Define the corresponding output directory
        OUTPUT_FILE_DIR="$OUTPUT_DIR/$(dirname "$REL_PATH")"
        mkdir -p "$OUTPUT_FILE_DIR"
        echo "Converting $pdf_file -> $OUTPUT_FILE_DIR"
        docling --to md --output "$OUTPUT_FILE_DIR" "$pdf_file"
        if [ "$IMAGELESS" = "True" ]; then
            BASENAME=$(basename "$pdf_file" .pdf)
            MD_FILE="$OUTPUT_FILE_DIR/${BASENAME}.md"
            if [ -f "$MD_FILE" ]; then
                echo "Removing embedded images from $MD_FILE..."
                /app/remove_images_md.sh "$MD_FILE"
            else
                echo "Markdown file $MD_FILE not found"
            fi
        fi
    done

else
    # Single file mode: INPUT must be provided and is interpreted as a filename in DOCUMENTS_DIR.
    if [ -z "$INPUT" ]; then
        echo "Usage: docker run ... <PDF_FILENAME>"
        exit 1
    fi

    DOC_PATH="$DOCUMENTS_DIR/$INPUT"
    if [ ! -f "$DOC_PATH" ]; then
        echo "Error: File $DOC_PATH does not exist."
        exit 1
    fi

    echo "Single file mode. Converting $DOC_PATH..."
    docling --to md --output "$OUTPUT_DIR" "$DOC_PATH"
    if [ "$IMAGELESS" = "True" ]; then
        BASENAME=$(basename "$INPUT" .pdf)
        MD_FILE="$OUTPUT_DIR/${BASENAME}.md"
        if [ -f "$MD_FILE" ]; then
            echo "Removing embedded images from $MD_FILE..."
            /app/remove_images_md.sh "$MD_FILE"
        else
            echo "Markdown file $MD_FILE not found"
        fi
    fi
fi

echo "Conversion completed."
