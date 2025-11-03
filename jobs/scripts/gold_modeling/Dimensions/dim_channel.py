import logging

logger = logging.getLogger(__name__)

def create_dim_channel(spark):
    spark.sql("""
    CREATE OR REPLACE TABLE my_catalog.gold.dim_channel (
        channel_key INT,
        channel_name STRING,
        channel_type STRING,
        description STRING,
        is_active BOOLEAN
    ) USING iceberg
    """)

    spark.sql("""
    INSERT INTO my_catalog.gold.dim_channel VALUES
    (1, 'Website', 'Online', 'Magento e-commerce site', true),
    (2, 'POS', 'Offline', 'Odoo point-of-sale system', true),
    (3, 'Support', 'Service', 'Freshdesk support channel', true)
    """)

    logger.info("Dim_channel table created successfully")

def main(spark):
    create_dim_channel(spark)