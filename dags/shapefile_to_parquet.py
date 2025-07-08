from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime
import geopandas as gpd
import requests, zipfile, io
import os
import json

DATA_DIR = "/tmp/data"
SHAPEFILE_URL = "https://www2.census.gov/geo/tiger/GENZ2022/shp/cb_2022_us_state_20m.zip"

def download_shapefile():
    os.makedirs(DATA_DIR, exist_ok=True)
    r = requests.get(SHAPEFILE_URL)
    z = zipfile.ZipFile(io.BytesIO(r.content))
    z.extractall(DATA_DIR)

def convert_to_geoparquet():
    shp_files = [f for f in os.listdir(DATA_DIR) if f.endswith(".shp")]
    if not shp_files:
        raise ValueError("No shapefile found.")
    gdf = gpd.read_file(os.path.join(DATA_DIR, shp_files[0]))
    output_path = os.path.join(DATA_DIR, "us_states.parquet")
    gdf.to_parquet(output_path)

    # Write a metadata summary
    metadata = {
        "parquet_path": output_path,
        "geometry_column": gdf.geometry.name,
        "crs": str(gdf.crs),
        "num_rows": len(gdf),
    }
    with open(os.path.join(DATA_DIR, "metadata.json"), "w") as f:
        json.dump(metadata, f, indent=2)

with DAG(
    dag_id="shapefile_to_geoparquet",
    start_date=datetime(2024, 1, 1),
    schedule_interval="@once",
    catchup=False,
    tags=["geospatial", "starter"],
) as dag:

    t1 = PythonOperator(
        task_id="download_shapefile",
        python_callable=download_shapefile,
    )

    t2 = PythonOperator(
        task_id="convert_to_geoparquet",
        python_callable=convert_to_geoparquet,
    )

    t1 >> t2
