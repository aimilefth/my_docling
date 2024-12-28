# Start from Python 3.12
FROM python:3.12

# Install docling (130 s)
# RUN pip install --no-cache-dir docling

# Install uv package manager (via pip) and install docling (65s)
RUN pip install uv
RUN uv pip install docling --system --no-cache

# Create a working directory
WORKDIR /app

# We create an entrypoint that runs a small shell script
# so we can pass the PDF filename to docling easily.
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# By default, "docling convert" outputs multiple formats, but 
# we set it to markdown output for convenience.
ENTRYPOINT ["/entrypoint.sh"]
