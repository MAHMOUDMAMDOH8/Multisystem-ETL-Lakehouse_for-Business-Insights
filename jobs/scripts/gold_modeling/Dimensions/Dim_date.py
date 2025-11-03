import logging

logger = logging.getLogger(__name__)

def create_dim_date(spark):
    spark.sql("""
        CREATE OR REPLACE TEMP VIEW date_series AS
        SELECT explode(sequence(to_date('2025-01-01'), to_date('2025-12-31'), interval 1 day)) AS date_value
     """)
    spark.sql("""
        CREATE OR REPLACE TABLE my_catalog.gold.dim_date
        USING iceberg AS
        SELECT
            md5(CAST(date_value AS STRING)) AS date_key,
            date_value,
            dayofweek(date_value) as day_of_week,
            month(date_value) as month,
            year(date_value) as year
        FROM date_series
    """)
    logger.info("Dim_date table created successfully")

def main(spark):
    create_dim_date(spark)