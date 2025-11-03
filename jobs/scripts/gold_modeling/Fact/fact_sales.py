import logging

logger = logging.getLogger(__name__)

def create_fact_sales(spark):
    logger.info("Creating fact_sales table...")

    
    spark.sql("CREATE OR REPLACE TEMP VIEW magento_orders AS SELECT * FROM local.magento_orders")
    spark.sql("CREATE OR REPLACE TEMP VIEW magento_order_items AS SELECT * FROM local.magento_order_items")
    spark.sql("CREATE OR REPLACE TEMP VIEW odoo_orders AS SELECT * FROM local.odoo_sales_orders")
    spark.sql("CREATE OR REPLACE TEMP VIEW odoo_order_items AS SELECT * FROM local.odoo_sales_order_items")

    spark.sql("CREATE OR REPLACE TEMP VIEW dim_customers AS SELECT * FROM my_catalog.gold.dim_customer")

    spark.sql("""
        CREATE OR REPLACE TEMP VIEW normalized_magento_orders AS
        SELECT
            m.order_id,
            m.order_number,
            m.customer_id,
            mi.product_id,
            m.order_date,
            m.status AS order_status,
            m.total_amount,
            m.shipping_amount,
            m.discount_amount,
            m.payment_method,
            m.shipping_method,
            mi.quantity,
            mi.unit_price,
            mi.total_price,
            'magento' AS source_system,
            NULL AS customer_email -- not available in Magento
        FROM magento_orders m
        LEFT JOIN magento_order_items mi
            ON m.order_id = mi.order_id
    """)

    spark.sql("""
        CREATE OR REPLACE TEMP VIEW normalized_odoo_orders AS
        SELECT
            o.order_id,
            o.order_reference AS order_number,
            c.customer_id,
            oi.product_id,
            o.order_date,
            o.status AS order_status,
            o.total_amount,
            NULL AS shipping_amount,
            NULL AS discount_amount,
            NULL AS payment_method,
            NULL AS shipping_method,
            oi.quantity,
            oi.unit_price,
            oi.total_price,
            'odoo' AS source_system,
            o.customer_email
        FROM odoo_orders o
        LEFT JOIN odoo_order_items oi
            ON o.order_id = oi.order_id
        LEFT JOIN dim_customers c
            ON LOWER(TRIM(o.customer_email)) = LOWER(TRIM(c.email))
    """)

    spark.sql("""
        CREATE OR REPLACE TEMP VIEW unified_sales AS
        SELECT
            COALESCE(m.order_id, o.order_id) AS order_id,
            COALESCE(m.order_number, o.order_number) AS order_number,
            COALESCE(m.customer_id, o.customer_id) AS customer_id,
            COALESCE(m.product_id, o.product_id) AS product_id,
            COALESCE(m.order_date, o.order_date) AS order_date,
            COALESCE(m.order_status, o.order_status) AS order_status,
            COALESCE(m.total_amount, o.total_amount, 0) AS total_amount,
            COALESCE(m.shipping_amount, 0) AS shipping_amount,
            COALESCE(m.discount_amount, 0) AS discount_amount,
            COALESCE(m.payment_method, o.payment_method, 'Unknown') AS payment_method,
            COALESCE(m.shipping_method, o.shipping_method, 'Unknown') AS shipping_method,
            COALESCE(m.quantity, o.quantity, 0) AS quantity,
            COALESCE(m.unit_price, o.unit_price, 0) AS unit_price,
            COALESCE(m.total_price, o.total_price, m.total_amount, o.total_amount, 0) AS total_price,
            COALESCE(m.source_system, o.source_system) AS source_system,
            COALESCE(m.customer_email, o.customer_email) AS customer_email
        FROM normalized_magento_orders m
        FULL OUTER JOIN normalized_odoo_orders o
            ON m.order_number = o.order_number
    """)

    spark.sql("""
        CREATE OR REPLACE TABLE my_catalog.gold.fact_sales
        USING iceberg AS
        SELECT
            md5(CONCAT(order_id, product_id, customer_id)) AS sales_key,
            order_id,
            order_number,
            customer_id,
            product_id,
            order_date,
            order_status,
            quantity,
            unit_price,
            total_price,
            total_amount,
            payment_method,
            shipping_method,
            shipping_amount,
            discount_amount,
            source_system,
            customer_email
        FROM unified_sales
        WHERE quantity > 0
    """)

    logger.info("✅ fact_sales table created successfully.")


def main(spark):
    create_fact_sales(spark)



