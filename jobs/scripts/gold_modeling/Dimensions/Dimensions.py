import os
import sys
import logging
from pyspark.sql import SparkSession
from pyspark.sql.functions import lit, col


logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

scripts_dir = '/opt/spark/work-dir/scripts'
if scripts_dir not in sys.path:
    sys.path.append(scripts_dir)

from gold_modeling.s3_utils import get_spark_session
from gold_modeling.Dimensions.dim_customer import main as Customer_dim
from gold_modeling.Dimensions.dim_products import main as Products_dim
from gold_modeling.Dimensions.dim_channel import main as Channel_dim
from gold_modeling.Dimensions.dim_support_agent import main as Support_agent_dim
from gold_modeling.Dimensions.Dim_date import main as Date_dim



spark = get_spark_session(app_name="Gold_Modeling_Dimensions")

if __name__ == "__main__":
    Customer_dim(spark)
    Products_dim(spark)
    Channel_dim(spark)
    Support_agent_dim(spark)
    Date_dim(spark)
    logger.info("Gold_Modeling_Dimensions job completed successfully")
    spark.stop()