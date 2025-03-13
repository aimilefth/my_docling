# Docling Docker Container

This repository provides a Docker container for converting PDF files to Markdown using [Docling](https://pypi.org/project/docling/). The container supports both single file conversion and recursive directory conversion with an option to remove embedded images from the output Markdown files.

## Features

- **Single File Conversion:** Convert a single PDF file located in the mounted documents folder.
- **Recursive Directory Conversion:** Set the `DIRECTORY` environment variable to process PDFs recursively from a given directory, preserving folder structure.
- **Image Removal:** Optionally remove embedded images (e.g., `![Image](...)`) from the generated Markdown files by setting `IMAGELESS` to `True`.
- **Host-side Script:** A `docker_run.sh` script is provided to simplify passing arguments and environment variables.

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) must be installed.

## Building the Docker Image

Run the following command in the project root (where the Dockerfile is located):

```bash
docker build -t aimilefth/docling:latest --push .
```


## Using the Container

You can run the container in two ways: directly using `docker run` or by using the provided host-side script `docker_run.sh`.

### Using Docker Run Directly

#### Single File Conversion
```
docker run --rm \
  -v $(pwd)/documents:/app/documents \
  -v $(pwd)/outputs:/app/outputs \
  aimilefth/docling myfile.pdf
```

#### Single File Conversion with Image Removal
```
docker run --rm \
  -e IMAGELESS=True \
  -v $(pwd)/documents:/app/documents \
  -v $(pwd)/outputs:/app/outputs \
  aimilefth/docling myfile.pdf
```

#### Recursive Directory Conversion
```
docker run --rm \
  -e DIRECTORY=True \
  -v $(pwd)/documents:/app/documents \
  -v $(pwd)/outputs:/app/outputs \
  aimilefth/docling my_subdir
```

#### Recursive Conversion with Image Removal
```
docker run --rm \
  -e DIRECTORY=True \
  -e IMAGELESS=True \
  -v $(pwd)/documents:/app/documents \
  -v $(pwd)/outputs:/app/outputs \
  aimilefth/docling my_subdir
```

### Using the Host Script: docker_run.sh

The `docker_run.sh` script simplifies usage by accepting flags:

- **`-p` / `--path`**: Relative path (file or directory) inside the documents folder (required).
- **`-d` / `--directory`**: Process recursively if present.
- **`-i` / `--imageless`**: Remove embedded images after conversion if present.
- **`--docs`**: Optional path to the documents folder (default: `$(pwd)/documents`).
- **`--outputs`**: Optional path to the outputs folder (default: `$(pwd)/outputs`).

For example, to convert a single file (with default options):
```
bash docker_run.sh --path myfile.pdf
```

To process a directory recursively:
```
bash docker_run.sh --path my_subdir --directory
```

To process a directory recursively with image removal:
```
bash docker_run.sh --path my_subdir --directory --imageless
```

Or, using custom documents and outputs paths:
```
bash docker_run.sh --path my_subdir --directory --imageless --docs /path/to/my/docs --outputs /path/to/my/outputs
```


## Project Structure

- **Dockerfile**: Defines the container image.
- **entrypoint.sh**: The container entrypoint that handles both single file and recursive directory conversion based on environment variables.
- **remove_images_md.sh**: Script used to remove embedded images from generated Markdown files.
- **docker_run.sh**: Host-side script that simplifies running the container with the proper arguments and volume mounts.
- **documents/**: Directory containing source PDF files.
- **outputs/**: Directory where converted Markdown files are saved.

## Summary

This project enables flexible PDF to Markdown conversion using Docker and Docling. Adjust the environment variables and script arguments as needed for single file or recursive directory processing and optional image removal.
