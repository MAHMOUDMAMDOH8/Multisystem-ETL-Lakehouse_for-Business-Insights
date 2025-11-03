import logging

logger = logging.getLogger(__name__)

def create_fact_inventory_snapshot(spark):
    logger.info("Creating fact_inventory_snapshot table...")

    # Create temp views for silver layer tables
    spark.sql("CREATE OR REPLACE TEMP VIEW inventory_stock AS SELECT * FROM local.inventory_stock")
    spark.sql("CREATE OR REPLACE TEMP VIEW odoo_products AS SELECT * FROM local.odoo_products")
    spark.sql("CREATE OR REPLACE TEMP VIEW warehouse AS SELECT * FROM local.warehouse")
    
    # Create temp views for dimensions
    spark.sql("CREATE OR REPLACE TEMP VIEW dim_products AS SELECT * FROM my_catalog.gold.dim_products")
    spark.sql("CREATE OR REPLACE TEMP VIEW dim_date AS SELECT * FROM my_catalog.gold.dim_date")
    spark.sql("CREATE OR REPLACE TEMP VIEW dim_time AS SELECT * FROM my_catalog.gold.dim_time")

    # Get the latest snapshot per product per warehouse
    # Assuming we take snapshots daily, we'll use the latest updated_at as the snapshot date
    spark.sql("""
        CREATE OR REPLACE TEMP VIEW daily_inventory_snapshots AS
        SELECT
            is.product_id,
            is.warehouse_id,
            DATE(is.updated_at) AS snapshot_date,
            is.quantity AS closing_stock,
            is.reserved_quantity,
            is.available_quantity,
            w.warehouse_name AS warehouse_location,
            is.updated_at,
            HOUR(is.updated_at) * 60 + MINUTE(is.updated_at) AS snapshot_minute_of_day
        FROM inventory_stock is
        LEFT JOIN warehouse w
            ON is.warehouse_id = w.warehouse_id
    """)

    # Calculate opening stock (previous day's closing stock) and quantity sold
    spark.sql("""
        CREATE OR REPLACE TEMP VIEW inventory_with_changes AS
        SELECT
            dis.product_id,
            dis.warehouse_id,
            dis.snapshot_date,
            dis.warehouse_location,
            dis.closing_stock,
            dis.reserved_quantity,
            dis.available_quantity,
            dis.snapshot_minute_of_day,
            LAG(dis.closing_stock, 1, 0) OVER (
                PARTITION BY dis.product_id, dis.warehouse_id 
                ORDER BY dis.snapshot_date
            ) AS opening_stock,
            GREATEST(
                0,
                dis.closing_stock - LAG(dis.closing_stock, 1, dis.closing_stock) OVER (
                    PARTITION BY dis.product_id, dis.warehouse_id 
                    ORDER BY dis.snapshot_date
                )
            ) AS quantity_sold
        FROM daily_inventory_snapshots dis
    """)

    # Create fact table joining with dimensions
    spark.sql("""
        CREATE OR REPLACE TABLE my_catalog.gold.fact_inventory_snapshot
        USING iceberg AS
        SELECT
            md5(CONCAT(CAST(iwc.product_id AS STRING), CAST(iwc.warehouse_id AS STRING), CAST(iwc.snapshot_date AS STRING))) AS inventory_key,
            COALESCE(dp.product_key, md5(CONCAT('unknown_', CAST(iwc.product_id AS STRING)))) AS product_key,
            COALESCE(dd.date_key, md5(CAST(iwc.snapshot_date AS STRING))) AS snapshot_date_key,
            COALESCE(dt.time_key, iwc.snapshot_minute_of_day) AS time_key,
            iwc.warehouse_location,
            COALESCE(iwc.opening_stock, 0) AS opening_stock,
            COALESCE(iwc.closing_stock, 0) AS closing_stock,
            COALESCE(iwc.quantity_sold, 0) AS quantity_sold,
            COALESCE(iwc.reserved_quantity, 0) AS reserved_quantity,
            COALESCE(iwc.available_quantity, 0) AS available_quantity,
            'odoo' AS source_system
        FROM inventory_with_changes iwc
        LEFT JOIN odoo_products op
            ON iwc.product_id = op.product_id
        LEFT JOIN dim_products dp
            ON op.product_code = dp.product_id
        LEFT JOIN dim_date dd
            ON iwc.snapshot_date = dd.date_value
        LEFT JOIN dim_time dt
            ON iwc.snapshot_minute_of_day = dt.time_key
    """)

    logger.info("✅ fact_inventory_snapshot table created successfully.")


def main(spark):
    create_fact_inventory_snapshot(spark)
