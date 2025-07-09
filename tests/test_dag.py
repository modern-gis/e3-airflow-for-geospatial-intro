import os
import json
import pytest
from datetime import date

metadata_path = "metadata.json"

def test_metadata_file_exists():
    assert os.path.exists(metadata_path), (
        f"metadata.json not found at {metadata_path}. "
        "Did you run the DAG locally before committing?"
    )

def test_metadata_contents_valid():
    if not os.path.exists(metadata_path):
        pytest.skip("metadata.json not found, skipping content test")

    with open(metadata_path) as f:
        meta = json.load(f)

    assert meta["parquet_path"].endswith(".parquet")
    assert meta["geometry_column"] == "geometry"
    assert meta["num_rows"] > 0
    assert "EPSG" in meta["crs"] or meta["crs"].startswith("PROJCRS")

def test_print_badge_proof():
    if not os.path.exists(metadata_path):
        pytest.skip("metadata.json not found, skipping badge proof")

    print(f"✅ Badge Proof: mini-shapefile-to-geoparquet_{date.today()}")
