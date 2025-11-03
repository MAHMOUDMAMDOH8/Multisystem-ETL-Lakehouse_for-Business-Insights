from datetime import datetime
from airflow import DAG
from airflow.operators.bash import BashOperator

with DAG(
    dag_id="modeling",
    start_date=datetime(2025, 10, 1),
    schedule=None,
    catchup=False,
    tags=["spark", "gold_modeling", "iceberg"],
) as dag:

    gold_modeling_fact_cmd = (
        "spark-submit "
        "--master spark://spark-master:7077 "
        "--packages org.apache.iceberg:iceberg-spark-runtime-3.4_2.12:1.5.0,org.apache.hadoop:hadoop-aws:3.3.4,com.amazonaws:aws-java-sdk-bundle:1.12.262 "
        "--conf spark.hadoop.fs.s3a.endpoint=****** "
        "--conf spark.hadoop.fs.s3a.access.key=test "
        "--conf spark.hadoop.fs.s3a.secret.key=test "
        "--conf spark.hadoop.fs.s3a.path.style.access=true "
        "--conf spark.hadoop.fs.s3a.impl=org.apache.hadoop.fs.s3a.S3AFileSystem "
        "--conf spark.hadoop.fs.s3a.connection.ssl.enabled=true "
        "/opt/spark/work-dir/scripts/gold_modeling/Fact/Fact.py"
    )
    gold_modeling_dimensions_cmd = (
        "spark-submit "
        "--master spark://spark-master:7077 "
        "--packages org.apache.iceberg:iceberg-spark-runtime-3.4_2.12:1.5.0,org.apache.hadoop:hadoop-aws:3.3.4,com.amazonaws:aws-java-sdk-bundle:1.12.262 "
        "--conf spark.hadoop.fs.s3a.endpoint=******"
        "--conf spark.hadoop.fs.s3a.access.key=test "
        "--conf spark.hadoop.fs.s3a.secret.key=test "
        "--conf spark.hadoop.fs.s3a.path.style.access=true "
        "--conf spark.hadoop.fs.s3a.impl=org.apache.hadoop.fs.s3a.S3AFileSystem "
        "--conf spark.hadoop.fs.s3a.connection.ssl.enabled=true "
        "/opt/spark/work-dir/scripts/gold_modeling/Dimensions/Dimensions.py"
    )



    gold_modeling_dimensions = BashOperator(
        task_id="gold_modeling_dimensions",
        bash_command=gold_modeling_dimensions_cmd,
    )
    gold_modeling_fact = BashOperator(
        task_id="gold_modeling_fact",
        bash_command=gold_modeling_fact_cmd,
    )


    gold_modeling_dimensions >> gold_modeling_fact 
