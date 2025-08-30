# Use an official Python image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies for Pillow (libjpeg, zlib)
RUN apt-get update && apt-get install -y libjpeg-dev zlib1g-dev

# Copy requirements first for better caching
COPY requirements.txt /app/

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files into the container
COPY . /app/

# Expose the Flask port
EXPOSE 8080

# Set PYTHONPATH to ensure modules can be found
ENV PYTHONPATH=/app

# Use shell to expand $PORT (Render sets $PORT). Fallback to 8080 if not set.
CMD ["sh", "-c", "cd /app && gunicorn app:application -b 0.0.0.0:${PORT:-8080} --workers 2 --timeout 120"]
