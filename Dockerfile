# syntax=docker/dockerfile:1
FROM python:3.10-slim

# Prevents Python from writing .pyc files and buffering stdout/stderr
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Set workdir
WORKDIR /app

# Install system deps if needed (uncomment if you need libgl etc.)
# RUN apt-get update && apt-get install -y --no-install-recommends \
#     libglib2.0-0 libsm6 libxext6 libxrender1 \
#  && rm -rf /var/lib/apt/lists/*

# Copy only requirements first for better caching
COPY ["Flask Deployed App/requirements.txt", "/app/requirements.txt"]
RUN pip install --no-cache-dir -r /app/requirements.txt

# Copy app source
COPY ["Flask Deployed App/", "/app/"]

# Expose port expected by Fly.io config (internal_port=5000)
EXPOSE 5000

# Default command: bind to PORT if provided (fallback 5000)
# If you prefer Flask dev server, replace with: python app.py
ENV PORT=5000
CMD ["bash", "-lc", "gunicorn -w 2 -b 0.0.0.0:${PORT} app:app"]
