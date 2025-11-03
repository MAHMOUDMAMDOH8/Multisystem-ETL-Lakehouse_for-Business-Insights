import logging

logger = logging.getLogger(__name__)

def create_dim_customer(spark):
    logger.info("Creating dim_customer table")
    spark.sql("CREATE OR REPLACE TEMP VIEW magento_customers AS SELECT * FROM local.magento_customers")
    spark.sql("CREATE OR REPLACE TEMP VIEW freshdesk_customers AS SELECT * FROM local.freshdesk_customers")



    spark.sql("""
        CREATE OR REPLACE TABLE my_catalog.gold.dim_customer
        USING iceberg AS
        WITH unified AS (
            SELECT
                COALESCE(m.customer_id, f.customer_id) AS customer_id,
                COALESCE(m.email, f.email) AS email,
                COALESCE(NULLIF(m.first_name, ''), f.first_name) AS first_name,
                COALESCE(NULLIF(m.last_name, ''), f.last_name) AS last_name,
                COALESCE(m.country, f.country) AS country,
                COALESCE(m.city, f.city) AS city,
                m.state AS state,
                COALESCE(m.phone, f.phone) AS phone,
                COALESCE(m.created_at, f.created_at) AS registration_date,
                CASE 
                    WHEN m.is_active IS TRUE OR f.is_active IS TRUE THEN TRUE 
                    ELSE FALSE 
                END AS is_active,
                CASE 
                    WHEN m.customer_id IS NOT NULL AND f.customer_id IS NOT NULL THEN 'magento+freshdesk'
                    WHEN m.customer_id IS NOT NULL THEN 'magento'
                    ELSE 'freshdesk'
                END AS source_system
            FROM magento_customers m
            FULL OUTER JOIN freshdesk_customers f
                ON LOWER(TRIM(m.email)) = LOWER(TRIM(f.email))
        ),
        ranked AS (
            SELECT 
                *,
                ROW_NUMBER() OVER (
                    PARTITION BY customer_id 
                    ORDER BY registration_date DESC NULLS LAST
                ) AS rn
            FROM unified
        )
        SELECT
            md5(COALESCE(email, customer_id)) AS customer_key,
            customer_id,
            email,
            first_name,
            last_name,
            country,
            city,
            state,
            phone,
            registration_date,
            is_active,
            source_system
        FROM ranked
        WHERE rn = 1
    """)

    logger.info("Dim_customer table created successfully")


def main(spark):
    create_dim_customer(spark)