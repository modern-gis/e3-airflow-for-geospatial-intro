FROM python:3.11-slim

# Install system packages
USER root
RUN apt-get update && apt-get install -y \
    build-essential \
    libgdal-dev \
    gdal-bin \
    python3-dev \
    curl \
    git \
    && apt-get clean

# Env vars for GDAL-based installs
ENV CPLUS_INCLUDE_PATH=/usr/include/gdal
ENV C_INCLUDE_PATH=/usr/include/gdal
ENV AIRFLOW_HOME=/workspace/airflow

# Create a non-root airflow user
RUN useradd -m airflow
USER airflow
WORKDIR /home/airflow

# Install Python packages
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

WORKDIR /workspace