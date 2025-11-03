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

spark = get_spark_session(app_name="Odoo_Silver_Transform",s3_endpoint="*****",
    s3_bucket="s3a://multusystem/silver_layer")


def transform_products():
    products_path = get_latest_table_paths(bucket="multusystem", table="odoo/products",
        endpoint_url="*****")

    products_df = spark.read.parquet(products_path)
    logger.info(f"Products data loaded successfully from {products_path},rows: {products_df.count()}")

    products_df = (
        products_df
        .dropDuplicates(["product_code"])
        .withColumn("product_name", F.initcap(F.col("product_name")))
        .fillna({
            "category": "Uncategorized",
            "list_price": 0.0,
            "standard_price": 0.0,
            "product_type": "Stockable",
            "is_active": True
        })
        .withColumn("category", F.initcap(F.col("category")))
    )

    write_to_iceberg(products_df, "odoo_products")
    logger.info(f"Products data written to iceberg successfully with {products_df.count()} rows")


def transform_suppliers():
    suppliers_path = get_latest_table_paths(bucket="multusystem", table="odoo/suppliers",
        endpoint_url="*****")

    suppliers_df = spark.read.parquet(suppliers_path)
    logger.info(f"Suppliers data loaded successfully from {suppliers_path},rows: {suppliers_df.count()}")

    suppliers_df = (
        suppliers_df
        .dropDuplicates(["supplier_code"])
        .withColumn("supplier_name", F.initcap(F.col("supplier_name")))
        .withColumn("email", F.lower(F.col("email")))
        .fillna({
            "city": "Unknown",
            "country": "Unknown",
            "is_active": True
        })
    )

    write_to_iceberg(suppliers_df, "suppliers")
    logger.info(f"Suppliers data written to iceberg successfully with {suppliers_df.count()} rows")

def transform_warehouse():
    warehouse_path = get_latest_table_paths(bucket="multusystem", table="odoo/warehouse",
        endpoint_url="*****")

    warehouse_df = spark.read.parquet(warehouse_path)
    logger.info(f"Warehouse data loaded successfully from {warehouse_path},rows: {warehouse_df.count()}")

    warehouse_df = (
        warehouse_df
        .dropDuplicates(["warehouse_code"])
        .withColumn("warehouse_name", F.initcap(F.col("warehouse_name")))
        .fillna({
            "location": "Unknown",
            "is_active": True
        })
    )

    write_to_iceberg(warehouse_df, "warehouse")
    logger.info(f"Warehouse data written to iceberg successfully with {warehouse_df.count()} rows")

def transform_inventory_stock():
    inventory_stock_path = get_latest_table_paths(bucket="multusystem", table="odoo/inventory_stock",
        endpoint_url="*****")
    

    inventory_df = spark.read.parquet(inventory_stock_path)
    logger.info(f"Inventory stock data loaded successfully from {inventory_stock_path},rows: {inventory_df.count()}")

    inventory_df =  (
        inventory_df
        .withColumn("quantity", F.coalesce(F.col("quantity"), F.lit(0)))
        .withColumn("reserved_quantity", F.coalesce(F.col("reserved_quantity"), F.lit(0)))
        .withColumn("available_quantity", F.col("quantity") - F.col("reserved_quantity"))
        .withColumn("updated_at", F.current_timestamp())
    )

    write_to_iceberg(inventory_df, "inventory_stock")
    logger.info(f"Inventory stock data written to iceberg successfully with {inventory_df.count()} rows")


def transform_sales_orders():
    sales_orders_path = get_latest_table_paths(bucket="multusystem", table="odoo/sales_orders",
        endpoint_url="*****")
    
    sales_orders_df = spark.read.parquet(sales_orders_path)
    logger.info(f"Sales orders data loaded successfully from {sales_orders_path},rows: {sales_orders_df.count()}")

    sales_orders_df = (
        sales_orders_df
        .dropDuplicates(["order_reference"])
        .withColumn("customer_name", F.initcap(F.col("customer_name")))
        .withColumn("customer_email", F.lower(F.col("customer_email")))
        .fillna({
            "status": "Draft",
            "total_amount": 0.0,
            "notes": ""
        })
        .withColumn("status", F.when(F.col("status").isNull(), "Draft").otherwise(F.col("status")))
    )

    write_to_iceberg(sales_orders_df, "odoo_sales_orders")
    logger.info(f"Sales orders data written to iceberg successfully with {sales_orders_df.count()} rows")


def transform_sales_order_items():
    sales_order_items_path = get_latest_table_paths(bucket="multusystem", table="odoo/sales_order_items",
        endpoint_url="*****")
    
    sales_order_items_df = spark.read.parquet(sales_order_items_path)
    logger.info(f"Sales order items data loaded successfully from {sales_order_items_path},rows: {sales_order_items_df.count()}")

    sales_order_items_df = (
        sales_order_items_df
        .dropDuplicates(["item_id"])
        .withColumn("product_name", F.initcap(F.col("product_name")))
        .withColumn(
            "total_price",
            F.when(F.col("total_price").isNull(), F.col("quantity") * F.col("unit_price"))
            .otherwise(F.col("total_price"))
        )
        .fillna({"notes": ""})
    )

    write_to_iceberg(sales_order_items_df, "odoo_sales_order_items")
    logger.info(f"Sales order items data written to iceberg successfully with {sales_order_items_df.count()} rows")


if __name__ == "__main__":
    transform_products()
    transform_suppliers()
    transform_warehouse()
    transform_inventory_stock()
    transform_sales_orders()
    transform_sales_order_items()
    logger.info("All transformations completed successfully")