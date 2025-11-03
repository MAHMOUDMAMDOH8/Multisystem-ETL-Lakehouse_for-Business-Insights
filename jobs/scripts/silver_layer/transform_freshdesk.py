import os
import sys
import logging
from pyspark.sql import functions as F

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

scripts_dir = '/opt/spark/work-dir/scripts'
if scripts_dir not in sys.path:
    sys.path.append(scripts_dir)

from s3_utils import get_spark_session , write_to_iceberg, get_latest_table_paths

spark = get_spark_session(app_name="Freshdesk_Silver_Transform",
    s3_endpoint="*****",
    s3_bucket="s3a://multusystem/silver_layer")

def transform_customers():
    customers_path = get_latest_table_paths(bucket="multusystem", table="freshdesk/customers",
    endpoint_url="*****")
    customers_df = spark.read.parquet(customers_path)
    logger.info(f"Customers data loaded successfully from {customers_path},rows: {customers_df.count()}")
    

    customers_df = (
        customers_df
        .dropDuplicates(["email"])
        .withColumn("first_name", F.trim(F.col("first_name")))
        .withColumn("last_name", F.trim(F.col("last_name")))
        .withColumn("company", F.trim(F.col("company")))
        .withColumn("email", F.lower(F.col("email")))
        .withColumn("country", F.upper(F.col("country")))
        .fillna({"company": "Unknown", "city": "Unknown", "country": "Unknown", "is_active": True})
    )

    write_to_iceberg(customers_df, "freshdesk_customers")
    logger.info(f"Customers data written to iceberg successfully with {customers_df.count()} rows")

def transform_agents():
    agents_path = get_latest_table_paths(bucket="multusystem", table="freshdesk/agents",
    endpoint_url="*****")

    agents_df = spark.read.parquet(agents_path)
    logger.info(f"Agents data loaded successfully from {agents_path},rows: {agents_df.count()}")
    

    agents_df = (
        agents_df
        .dropDuplicates(["email"])
        .withColumn("email", F.lower(F.col("email")))
        .withColumn("first_name", F.initcap(F.col("first_name")))
        .withColumn("last_name", F.initcap(F.col("last_name")))
        .fillna({"department": "General Support", "is_active": True})
    )

    write_to_iceberg(agents_df, "agents")
    logger.info(f"Agents data written to iceberg successfully with {agents_df.count()} rows")


def transform_tickets():
    tickets_path = get_latest_table_paths(bucket="multusystem", table="freshdesk/tickets",
    endpoint_url="*****")   
    tickets_df = spark.read.parquet(tickets_path)
    logger.info(f"Tickets data loaded successfully from {tickets_path},rows: {tickets_df.count()}")
    
    tickets_df = (
        tickets_df
        .dropDuplicates(["ticket_number"])
        .withColumn(
            "response_time_minutes",
            F.when(
                F.col("first_response_at").isNotNull(),
                F.round((F.unix_timestamp("first_response_at") - F.unix_timestamp("created_at")) / 60)
            ).otherwise(F.col("response_time_minutes"))
        )
        .withColumn(
            "resolution_time_minutes",
            F.when(
                F.col("resolved_at").isNotNull(),
                F.round((F.unix_timestamp("resolved_at") - F.unix_timestamp("created_at")) / 60)
            ).otherwise(F.col("resolution_time_minutes"))
        )
        .fillna({"satisfaction_rating": 3})
    )

    write_to_iceberg(tickets_df, "tickets")
    logger.info(f"Tickets data written to iceberg successfully with {tickets_df.count()} rows")


if __name__ == "__main__":
    transform_customers()
    transform_agents()
    transform_tickets()
    logger.info("All transformations completed successfully")