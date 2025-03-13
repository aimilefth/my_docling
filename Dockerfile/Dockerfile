# Start from Python 3.12
FROM python:3.12

# Install uv package manager (via pip) and install docling
RUN pip install uv && \
    uv pip install docling --system --no-cache

# Create a working directory
WORKDIR /app

# Copy the container scripts
COPY entrypoint.sh /entrypoint.sh
COPY remove_images_md.sh /app/remove_images_md.sh

# Make the scripts executable
RUN chmod +x /entrypoint.sh /app/remove_images_md.sh

# Set the default entrypoint to entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
