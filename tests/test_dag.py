import os

def test_metadata_file_exists():
    metadata_path = "/tmp/data/metadata.json"
    assert os.path.exists(metadata_path), "metadata.json not found."

def test_metadata_contents_valid():
    import json
    with open("/tmp/data/metadata.json") as f:
        meta = json.load(f)

    assert meta["parquet_path"].endswith(".parquet")
    assert meta["geometry_column"] == "geometry"
    assert meta["num_rows"] > 0
    assert "EPSG" in meta["crs"] or meta["crs"].startswith("PROJCRS")
