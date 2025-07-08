FROM python:3.11-slim

# Install system dependencies for Airflow and geospatial stack
USER root
RUN apt-get update && apt-get install -y \
    build-essential \
    libgdal-dev \
    gdal-bin \
    python3-dev \
    curl \
    git \
    && apt-get clean

# Set environment variables for geospatial libraries
ENV CPLUS_INCLUDE_PATH=/usr/include/gdal
ENV C_INCLUDE_PATH=/usr/include/gdal
ENV AIRFLOW_HOME=/workspace/airflow

# Create a non-root user called airflow
RUN useradd -m airflow
USER airflow
WORKDIR /home/airflow

# Install Python packages as non-root
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Set working directory
WORKDIR /workspace
