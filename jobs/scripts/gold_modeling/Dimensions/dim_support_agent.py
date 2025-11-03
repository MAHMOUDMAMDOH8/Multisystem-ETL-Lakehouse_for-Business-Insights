import logging

logger = logging.getLogger(__name__)

def create_dim_support_agent(spark):
    logger.info("Creating dim_support_agent table")
    spark.sql("CREATE OR REPLACE TEMP VIEW freshdesk_agents AS SELECT * FROM local.agents")

    # Drop table if it exists to avoid metadata read issues with CREATE OR REPLACE
    spark.sql("DROP TABLE IF EXISTS my_catalog.gold.dim_support_agent")

    spark.sql("""
    CREATE TABLE my_catalog.gold.dim_support_agent
    USING iceberg AS
    SELECT
        agent_id,
        email,
        first_name,
        last_name,
        department,
        is_active,
        created_at
    FROM freshdesk_agents
    """)

    logger.info("Dim_support_agent table created successfully")

def main(spark):
    create_dim_support_agent(spark)
