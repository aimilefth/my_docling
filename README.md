# Docling Docker Container

This Docker image runs [Docling](https://pypi.org/project/docling/) to convert PDF files into Markdown files using a containerized environment.

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) must be installed.

## How to Build

Clone the repository and navigate to the folder containing the `Dockerfile`. Then build the Docker image locally:

```bash
docker build -t aimilefth/docling --push .
```

## How to Use

Make sure you have a PDF file in the ./documents folder of your project.

 Run the container, mounting your local documents and outputs folders:

```bash
docker run --rm \
  -v $(pwd)/documents:/app/documents \
  -v $(pwd)/outputs:/app/outputs \
  aimilefth/docling myfile.pdf
```

Replace myfile.pdf with the name of the PDF you wish to convert.

The Docker container will create a Markdown file in the ./outputs directory.

## Example

Assuming myfile.pdf is placed in your local documents folder:

```bash
docker run --rm \
  -v $(pwd)/documents:/app/documents \
  -v $(pwd)/outputs:/app/outputs \
  aimilefth/docling myfile.pdf
```

After it finishes, look in the outputs/ folder to see the .md file.


## Putting It All Together

1.  **Build** the Docker image from within the project folder (same location as `Dockerfile`):
    ```bash
    docker build -t aimilefth/docling .
    ```

2.  **Push** the Docker image to Docker Hub (requires you to be logged in):
    ```bash
    docker push aimilefth/docling
    ```

3.  **Run** the container (pulling from Docker Hub if you haven’t built locally):
    ```bash
    docker run --rm \
      -v $(pwd)/documents:/app/documents \
      -v $(pwd)/outputs:/app/outputs \
      aimilefth/docling myfile.pdf
    ```

That’s it! Your `.md` output will be located in the `outputs/` folder.
