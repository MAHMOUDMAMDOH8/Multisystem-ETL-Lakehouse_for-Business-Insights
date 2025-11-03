import boto3
import re
from pyspark.sql import SparkSession
from pyspark.conf import SparkConf

def get_latest_table_paths(bucket, table, endpoint_url="http://localhost:4566"):
    s3 = boto3.client(
        "s3",
        endpoint_url=endpoint_url,
        aws_access_key_id="test",
        aws_secret_access_key="test",
        region_name="us-east-1"
    )

    response = s3.list_objects_v2(Bucket=bucket, Prefix=f"{table}/")
    contents = response.get("Contents", [])
    parquet_files = [f["Key"] for f in contents if f["Key"].endswith(".parquet")]

    if not parquet_files:
        print(f"[WARN] No parquet files found for table: {table}")
        return ""


    pattern = re.compile(r"(\d{4}_\d{2}_\d{2}_\d+)_\d+\.parquet$")
    timestamps = {
        re.search(pattern, key).group(1): key
        for key in parquet_files if re.search(pattern, key)
    }

    if not timestamps:
        print(f"[WARN] No valid timestamps found for table: {table}")
        return ""

    latest_ts = max(timestamps.keys())
    latest_key = timestamps[latest_ts]

    s3_path = f"s3a://{bucket}/{latest_key}"
    print(f"[INFO] Latest file for {table}: {s3_path}")

    return s3_path

def get_spark_session(app_name="ETL-Iceberg", s3_endpoint="http://localhost:4566",
                      s3_bucket="s3a://multusystem/silver_layer", access_key="test", secret_key="test"):

    spark_jars_packages = [
        "org.apache.iceberg:iceberg-spark-runtime-3.4_2.12:1.5.0",
        "org.apache.hadoop:hadoop-aws:3.3.4",
        "com.amazonaws:aws-java-sdk-bundle:1.12.262"
    ]

    conf = (
        SparkConf()
        .setAppName(app_name)
        .set("spark.jars.packages", ",".join(spark_jars_packages))
        .set("spark.hadoop.fs.s3a.endpoint", s3_endpoint)
        .set("spark.hadoop.fs.s3a.access.key", access_key)
        .set("spark.hadoop.fs.s3a.secret.key", secret_key)
        .set("spark.hadoop.fs.s3a.path.style.access", "true")
        .set("spark.hadoop.fs.s3a.impl", "org.apache.hadoop.fs.s3a.S3AFileSystem")
        .set("spark.hadoop.fs.s3a.connection.ssl.enabled", "true")
        .set("spark.sql.catalog.local", "org.apache.iceberg.spark.SparkCatalog")
        .set("spark.sql.catalog.local.type", "hadoop")
        .set("spark.sql.catalog.local.warehouse", s3_bucket)
    )

    spark = SparkSession.builder.config(conf=conf).getOrCreate()
    spark.sparkContext.setLogLevel("WARN")
    return spark

def write_to_iceberg(df, table_name):
    spark = df.sparkSession
    full_table = f"local.{table_name}"

    if not spark.catalog.tableExists(full_table):
        print(f"Table {full_table} does not exist. Creating it...")
        df.writeTo(full_table).create()
    else:
        print(f"Appending to existing Iceberg table: {full_table}")
        df.writeTo(full_table).append()
