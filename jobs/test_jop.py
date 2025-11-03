from pyspark.sql import SparkSession
import boto3
from urllib.parse import urljoin

# Initialize Spark with LocalStack S3 endpoint
spark = (
    SparkSession.builder
    .appName("ReadLatestFromS3")
    .config("spark.hadoop.fs.s3a.endpoint", "https://repulsive-spooky-cemetery-9rw4pvr4w66f4g6-4566.app.github.dev")
    .config("spark.hadoop.fs.s3a.path.style.access", "true")
    .config("spark.hadoop.fs.s3a.access.key", "test")
    .config("spark.hadoop.fs.s3a.secret.key", "test")
    .config("spark.hadoop.fs.s3a.impl", "org.apache.hadoop.fs.s3a.S3AFileSystem")
    .getOrCreate()
)

bucket_name = "multusystem"

# Initialize boto3 client for listing
s3 = boto3.client(
    "s3",
    endpoint_url="https://repulsive-spooky-cemetery-9rw4pvr4w66f4g6-4566.app.github.dev",
    aws_access_key_id="test",
    aws_secret_access_key="test",
    region_name="us-east-1"
)

# List all objects in the bucket
response = s3.list_objects_v2(Bucket=bucket_name)
files = response.get("Contents", [])

# Organize by folder (like freshdesk/tickets/)
from collections import defaultdict
folders = defaultdict(list)

for obj in files:
    key = obj["Key"]
    if key.endswith(".parquet"):
        folder = "/".join(key.split("/")[:-1])  # e.g. freshdesk/tickets
        folders[folder].append(key)

# Get the latest file per folder (based on name)
latest_files = {}
for folder, keys in folders.items():
    latest = sorted(keys)[-1]  # latest lexicographically (date+timestamp)
    latest_files[folder] = f"s3a://{bucket_name}/{latest}"

# Read each latest Parquet into Spark
dataframes = {}
for folder, s3_path in latest_files.items():
    print(f"📦 Reading latest data from {s3_path}")
    df = spark.read.parquet(s3_path)
    dataframes[folder] = df

print(f"\n✅ Loaded {len(dataframes)} latest tables:")
for k in dataframes:
    print("-", k)
