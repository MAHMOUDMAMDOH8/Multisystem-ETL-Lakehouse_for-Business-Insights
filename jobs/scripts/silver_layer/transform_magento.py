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

spark = get_spark_session(app_name="Magento_Silver_Transform",s3_endpoint="https://repulsive-spooky-cemetery-9rw4pvr4w66f4g6-4566.app.github.dev",
s3_bucket="s3a://multusystem/silver_layer")

def transform_categories():
    categories_path = get_latest_table_paths(bucket="multusystem", table="magento/categories",
    endpoint_url="https://repulsive-spooky-cemetery-9rw4pvr4w66f4g6-4566.app.github.dev"
    )
    categories_df = spark.read.parquet(categories_path)
    logger.info(f"Categories data loaded successfully from {categories_path},rows: {categories_df.count()}")

    categories_df = (
        categories_df.dropDuplicates(["category_id"])
          .filter(F.col("category_name").isNotNull())
          .withColumn("category_name", F.trim(F.col("category_name")))
          .withColumn("created_at", F.to_timestamp("created_at"))
    )

    write_to_iceberg(categories_df, "categories")
    logger.info(f"Categories data written to iceberg successfully with {categories_df.count()} rows ")

def transform_subcategories():
    subcategories_path = get_latest_table_paths(bucket="multusystem", table="magento/subcategories",
    endpoint_url="https://repulsive-spooky-cemetery-9rw4pvr4w66f4g6-4566.app.github.dev"
    )
    subcategories_df = spark.read.parquet(subcategories_path)
    logger.info(f"Subcategories data loaded successfully from {subcategories_path},rows: {subcategories_df.count()}")
    
    subcategories_df = (
        subcategories_df.dropDuplicates(["subcategory_id"])
          .filter(F.col("subcategory_name").isNotNull())
          .withColumn("subcategory_name", F.trim(F.col("subcategory_name")))
          .withColumn("created_at", F.to_timestamp("created_at"))
    )

    write_to_iceberg(subcategories_df, "subcategories")
    logger.info(f"Subcategories data written to iceberg successfully with {subcategories_df.count()} rows")

def transform_customers():
    customers_path = get_latest_table_paths(bucket="multusystem", table="magento/customers",
    endpoint_url="https://repulsive-spooky-cemetery-9rw4pvr4w66f4g6-4566.app.github.dev"
    )
    customers_df = spark.read.parquet(customers_path)
    logger.info(f"Customers data loaded successfully from {customers_path},rows: {customers_df.count()}")
    
    # transform customers data
    customers_df = (
        customers_df.dropDuplicates(["customer_id", "email"])
          .filter(F.col("email").contains("@"))
          .withColumn("first_name", F.initcap(F.col("first_name")))
          .withColumn("last_name", F.initcap(F.col("last_name")))
          .withColumn("phone", F.regexp_replace("phone", "[^0-9]", ""))
          .withColumn("created_at", F.to_timestamp("created_at"))
    )

    # write to iceberg
    write_to_iceberg(customers_df, "magento_customers")
    logger.info(f"Customers data written to iceberg successfully with {customers_df.count()} rows")

def transform_products():
    products_path = get_latest_table_paths(bucket="multusystem", table="magento/products",
    endpoint_url="https://repulsive-spooky-cemetery-9rw4pvr4w66f4g6-4566.app.github.dev"
    )
    products_df = spark.read.parquet(products_path)
    logger.info(f"Products data loaded successfully from {products_path},rows: {products_df.count()}")
    
    # transform products data
    products_df =  (
        products_df.dropDuplicates(["sku"])
          .filter(F.col("price") > 0)
          .withColumn("name", F.initcap(F.col("name")))
          .withColumn("brand", F.upper(F.col("brand")))
          .withColumn("created_at", F.to_timestamp("created_at"))
    )

    write_to_iceberg(products_df, "magento_products")
    logger.info(f"Products data written to iceberg successfully with {products_df.count()} rows")

def transform_orders():
    orders_path = get_latest_table_paths(bucket="multusystem", table="magento/orders",
    endpoint_url="https://repulsive-spooky-cemetery-9rw4pvr4w66f4g6-4566.app.github.dev"
    )
    orders_df = spark.read.parquet(orders_path)
    logger.info(f"Orders data loaded successfully from {orders_path},rows: {orders_df.count()}")

    orders_df =  (
        orders_df.dropDuplicates(["order_number"])
          .withColumn("order_date", F.to_timestamp("order_date"))
          .withColumn("total_amount", F.round(F.col("total_amount"), 2))
          .withColumn("tax_amount", F.coalesce(F.col("tax_amount"), F.lit(0)))
          .withColumn("shipping_amount", F.coalesce(F.col("shipping_amount"), F.lit(0)))
          .withColumn("discount_amount", F.coalesce(F.col("discount_amount"), F.lit(0)))
          .filter(F.col("total_amount") > 0)
    )


    write_to_iceberg(orders_df, "magento_orders")
    logger.info(f"Orders data written to iceberg successfully with {orders_df.count()} rows")


def transform_order_items():
    order_items_path = get_latest_table_paths(bucket="multusystem", table="magento/order_items",
    endpoint_url="https://repulsive-spooky-cemetery-9rw4pvr4w66f4g6-4566.app.github.dev"
    )
    order_items_df = spark.read.parquet(order_items_path)
    logger.info(f"Order items data loaded successfully from {order_items_path},rows: {order_items_df.count()}")
    
    order_items_df =  (
        order_items_df.dropDuplicates(["item_id"])
          .filter(F.col("quantity") > 0)
          .withColumn("total_price", F.col("unit_price") * F.col("quantity"))
    )

    write_to_iceberg(order_items_df, "magento_order_items")
    logger.info(f"Order items data written to iceberg successfully with {order_items_df.count()} rows")

def transform_payments():
    payments_path = get_latest_table_paths(bucket="multusystem", table="magento/payments",
    endpoint_url="https://repulsive-spooky-cemetery-9rw4pvr4w66f4g6-4566.app.github.dev"
    )
    payments_df = spark.read.parquet(payments_path)
    logger.info(f"Payments data loaded successfully from {payments_path},rows: {payments_df.count()}")
    
    payments_df = (
        payments_df.dropDuplicates(["payment_id", "transaction_id"])
          .filter(F.col("amount") > 0)
          .withColumn("payment_date", F.to_timestamp("payment_date"))
          .withColumn("payment_status", F.lower(F.col("payment_status")))
    )

    write_to_iceberg(payments_df, "payments")
    logger.info(f"Payments data written to iceberg successfully with {payments_df.count()} rows")





if __name__ == "__main__":
    transform_categories()
    transform_subcategories()
    transform_customers()
    transform_products()
    transform_orders()
    transform_order_items()
    transform_payments()
    logger.info("All transformations completed successfully")