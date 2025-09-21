# Based on the original Dockerfile but adapted for Hugging Face Spaces
FROM python:3.10-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=7860

# Set working directory
WORKDIR /app

# Install system dependencies if needed (uncomment if needed)
# RUN apt-get update && apt-get install -y --no-install-recommends \
#     libglib2.0-0 libsm6 libxext6 libxrender1 \
#  && rm -rf /var/lib/apt/lists/*

# Copy requirements first for better caching
COPY ["Flask Deployed App/requirements.txt", "./"]
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY ["Flask Deployed App/", "./"]

# Expose the port the app runs on
EXPOSE 7860

# Command to run the application
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "7860"]
