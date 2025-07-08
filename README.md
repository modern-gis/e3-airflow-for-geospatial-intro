# 🛰️ Mini Project: Shapefile to GeoParquet with Airflow

This is a minimal Airflow project to help you learn how to:

- Build a custom Airflow Docker image
- Write a DAG that downloads a shapefile and converts it to GeoParquet
- Run Airflow using `docker-compose`

## 🚀 Setup Instructions

1. **Build the Airflow image**  
```bash
docker-compose build
```

2. **Initialize the Airflow database**  
```bash
docker-compose run airflow-webserver airflow db init
```

3. **Create an admin user (optional)**  
```bash
docker-compose run airflow-webserver airflow users create \
  --username admin \
  --firstname Admin \
  --lastname User \
  --role Admin \
  --email admin@example.com \
  --password admin
```

4. **Start Airflow**  
```bash
docker-compose up
```

Then visit: http://localhost:8080

Login with: `admin` / `admin` (or whatever credentials you created)

5. **Run the DAG**  
Trigger the `shapefile_to_geoparquet` DAG manually. It will:

- Download a US States shapefile from the US Census
- Unzip it into `/tmp/data`
- Convert it to GeoParquet (`us_states.parquet`)
