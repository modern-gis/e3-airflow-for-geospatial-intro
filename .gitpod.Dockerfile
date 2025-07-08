FROM python:3.11-slim

USER root

# 1) Install system-level deps and GDAL
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      build-essential \
      git \
      curl \
      unzip \
      gdal-bin \
      libgdal-dev \
      libsqlite3-dev \
      ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# 3) Copy & install your Python requirements
COPY requirements.txt /tmp/requirements.txt
RUN pip install --upgrade pip \
 && pip install numpy==1.26.4 \
 && pip install --no-cache-dir -r /tmp/requirements.txt

# 4) Airflow env vars
ENV AIRFLOW_VERSION=3.0.1 \
    AIRFLOW_HOME=/workspace/airflow \
    AIRFLOW__CORE__LOAD_EXAMPLES=False \
    AIRFLOW__DATABASE__SQL_ALCHEMY_CONN=sqlite:////workspace/airflow/airflow.db \
    PIP_NO_CACHE_DIR=1

# 7) Prepare Airflow dirs
RUN mkdir -p /workspace/airflow/{dags,logs,plugins}

WORKDIR /workspace
EXPOSE 8080
CMD ["bash"]