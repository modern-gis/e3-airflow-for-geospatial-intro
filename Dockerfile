# ✅ Base image — using the official Airflow image with Python 3.11
FROM apache/airflow:3.0.1-python3.11

# ✅ Switch to root so we can install system packages
USER root

# 🧠 TODO 1:
# Airflow doesn't come with geospatial libraries by default.
# Add the commands to install GDAL and related system packages below:
RUN apt-get update && apt-get install -y \
    # ← Add: gdal-bin, libgdal-dev, python3-dev, build-essential
    && apt-get clean

# 🧠 TODO 2:
# Set environment variables so that geospatial libraries (like pyproj) can find GDAL headers.
# These are required for libraries like Fiona, Rasterio, and pyproj to install properly.
ENV CPLUS_INCLUDE_PATH=/usr/include/gdal
ENV C_INCLUDE_PATH=/usr/include/gdal

# ✅ Copy Python requirements into image
COPY requirements.txt .

# 🧠 TODO 3:
# Add a pip install line to install all packages in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# ✅ Switch back to airflow user
USER airflow
