import logging

logger = logging.getLogger(__name__)

def create_dim_time(spark):
    logger.info("Creating dim_time table")
    
    # Generate time dimension for 24 hours with minute granularity
    spark.sql("""
        CREATE OR REPLACE TEMP VIEW time_series AS
        SELECT 
            explode(sequence(0, 1439, 1)) AS minute_of_day
    """)
    
    spark.sql("""
        CREATE OR REPLACE TABLE my_catalog.gold.dim_time
        USING iceberg AS
        SELECT
            minute_of_day AS time_key,
            CAST(minute_of_day AS STRING) AS time_value,
            CAST(FLOOR(minute_of_day / 60) AS STRING) AS hour,
            CAST(MOD(minute_of_day, 60) AS STRING) AS minute,
            CASE 
                WHEN FLOOR(minute_of_day / 60) < 12 THEN 'AM'
                ELSE 'PM'
            END AS am_pm
        FROM time_series
    """)
    
    logger.info("Dim_time table created successfully")

def main(spark):
    create_dim_time(spark)
