from pyspark.sql import SparkSession
import logging

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

def create_dim_products(spark):
    logger.info("Creating DIM_PRODUCTS table...")


    spark.sql("CREATE OR REPLACE TEMP VIEW magento_products AS SELECT * FROM local.magento_products")
    spark.sql("CREATE OR REPLACE TEMP VIEW odoo_products AS SELECT * FROM local.odoo_products")
    spark.sql("CREATE OR REPLACE TEMP VIEW categories AS SELECT * FROM local.categories")
    spark.sql("CREATE OR REPLACE TEMP VIEW subcategories AS SELECT * FROM local.subcategories")


    spark.sql("""
    CREATE OR REPLACE TEMP VIEW unified_products AS
    SELECT
        COALESCE(m.product_id, o.product_id) AS product_id,
        COALESCE(m.name, o.product_name, 'Unknown') AS product_name,
        COALESCE(m.sku, o.product_code) AS product_code,
        COALESCE(m.brand, 'Uncategorized') AS brand,
        COALESCE(m.price, o.standard_price, o.list_price, 0) AS current_price,
        COALESCE(m.is_active, o.is_active, true) AS is_active,
        COALESCE(m.created_at, o.created_at, current_timestamp()) AS created_at,
        CASE 
            WHEN m.product_id IS NOT NULL THEN 'magento'
            WHEN o.product_id IS NOT NULL THEN 'odoo'
            ELSE 'unknown'
        END AS source_system,
        COALESCE(o.product_type, 'Stockable') AS product_type,
        COALESCE(m.subcategory_id, null) AS subcategory_id
    FROM magento_products m
    FULL OUTER JOIN odoo_products o
        ON m.product_id = o.product_id OR lower(m.name) = lower(o.product_name)
    """)

    spark.sql("""
    CREATE OR REPLACE TEMP VIEW enriched_products AS
    SELECT DISTINCT
        md5(LOWER(COALESCE(u.product_name, u.product_code))) AS product_key,
        u.product_id,
        u.product_name,
        u.product_code,
        u.brand,
        u.current_price,
        u.product_type,
        u.is_active,
        u.created_at,
        u.source_system,
        COALESCE(c.category_name, 'Uncategorized') AS category_name,
        COALESCE(s.subcategory_name, 'General') AS subcategory_name
    FROM unified_products u
    LEFT JOIN subcategories s
        ON u.subcategory_id = s.subcategory_id
    LEFT JOIN categories c
        ON s.category_id = c.category_id
    WHERE u.is_active = true
    """)

    spark.sql("""
    CREATE OR REPLACE TABLE my_catalog.gold.dim_products
    USING iceberg
    AS SELECT * FROM enriched_products
    """)

    logger.info("DIM_PRODUCTS table created successfully and written to Iceberg")

def main(spark):
    create_dim_products(spark)


