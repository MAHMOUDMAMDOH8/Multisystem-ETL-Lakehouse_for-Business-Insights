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
from gold_modeling.Fact.fact_sales import main as Fact_sales


spark = get_spark_session(app_name="Gold_Modeling_Fact")

if __name__ == "__main__":
    Fact_sales(spark)
    logger.info("Gold_Modeling_Fact job completed successfully")
    spark.stop()