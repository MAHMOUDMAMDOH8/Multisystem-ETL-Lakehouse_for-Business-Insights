## Building a Unified Data Warehouse
Objective

Create a modern data warehouse that unifies information from Magento (e-commerce), Odoo (ERP/inventory), and Freshdesk (customer support) to enable centralized reporting and analytics across sales, inventory, and customer service.

Specifications

Data Sources:

Magento_db: Online sales and order data

Odoo: Inventory, ERP, and product master data

Freshdesk: Customer support tickets and resolution metrics

Architecture & Integration:

Extraction: Use tools like Airbyte or Fivetran to pull data from all three systems into a staging area.

Orchestration: Manage extraction and load workflows with Airflow.

Storage: Land raw data in S3 or GCS (Raw → Staging → Warehouse).

Warehouse: Store unified data in Snowflake or BigQuery for analytics.

Modeling: Use dbt to transform staged data into clean, analytics-ready models.

Data Modeling:

Implement schema with:

Dimensions: Customer, Product, Time, Channel

Facts: Sales Orders, Inventory, Support Tickets

Link records across systems using customer email and product SKU.

Transformations:

Standardize currencies, timestamps, and product IDs.

Clean and deduplicate customer and product data.

Compute metrics such as average ticket resolution time per customer.


Data Quality & Validation:

Validate that every paid order in Magento has a matching posted invoice in Odoo.

Verify ticket counts between Freshdesk and the warehouse.

Implement Great Expectations or dbt tests for continuous validation.

BI: Analysis & Reporting
Objective

Deliver unified dashboards and metrics for business teams to analyze:

Revenue performance by category and channel

Out-of-stock products still active in Magento

Average ticket resolution time by top customers