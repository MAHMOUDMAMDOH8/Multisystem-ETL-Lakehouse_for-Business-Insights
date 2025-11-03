from datetime import datetime
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.trigger_dagrun import TriggerDagRunOperator

with DAG(
    dag_id="data_lake_silver_transform",
    start_date=datetime(2025, 10, 1),
    schedule=None,
    catchup=False,
    tags=["spark", "silver_layer", "iceberg"],
) as dag:

    magento_silver_transform_cmd = (
        "spark-submit "
        "--master spark://spark-master:7077 "
        "--packages org.apache.iceberg:iceberg-spark-runtime-3.4_2.12:1.5.0,org.apache.hadoop:hadoop-aws:3.3.4,com.amazonaws:aws-java-sdk-bundle:1.12.262 "
        "--conf spark.hadoop.fs.s3a.endpoint=***** "
        "--conf spark.hadoop.fs.s3a.access.key=test "
        "--conf spark.hadoop.fs.s3a.secret.key=test "
        "--conf spark.hadoop.fs.s3a.path.style.access=true "
        "--conf spark.hadoop.fs.s3a.impl=org.apache.hadoop.fs.s3a.S3AFileSystem "
        "--conf spark.hadoop.fs.s3a.connection.ssl.enabled=true "
        "/opt/spark/work-dir/scripts/silver_layer/transform_magento.py"
    )
    freshdesk_silver_transform_cmd = (
        "spark-submit "
        "--master spark://spark-master:7077 "
        "--packages org.apache.iceberg:iceberg-spark-runtime-3.4_2.12:1.5.0,org.apache.hadoop:hadoop-aws:3.3.4,com.amazonaws:aws-java-sdk-bundle:1.12.262 "
        "--conf spark.hadoop.fs.s3a.endpoint=******** "
        "--conf spark.hadoop.fs.s3a.access.key=test "
        "--conf spark.hadoop.fs.s3a.secret.key=test "
        "--conf spark.hadoop.fs.s3a.path.style.access=true "
        "--conf spark.hadoop.fs.s3a.impl=org.apache.hadoop.fs.s3a.S3AFileSystem "
        "--conf spark.hadoop.fs.s3a.connection.ssl.enabled=true "
        "/opt/spark/work-dir/scripts/silver_layer/transform_freshdesk.py"
    )

    odoo_silver_transform_cmd = (
        "spark-submit "
        "--master spark://spark-master:7077 "
        "--packages org.apache.iceberg:iceberg-spark-runtime-3.4_2.12:1.5.0,org.apache.hadoop:hadoop-aws:3.3.4,com.amazonaws:aws-java-sdk-bundle:1.12.262 "
        "--conf spark.hadoop.fs.s3a.endpoint=***** "
        "--conf spark.hadoop.fs.s3a.access.key=test "
        "--conf spark.hadoop.fs.s3a.secret.key=test "
        "--conf spark.hadoop.fs.s3a.path.style.access=true "
        "--conf spark.hadoop.fs.s3a.impl=org.apache.hadoop.fs.s3a.S3AFileSystem "
        "--conf spark.hadoop.fs.s3a.connection.ssl.enabled=true "
        "/opt/spark/work-dir/scripts/silver_layer/transform_odoo.py"
    )

    transform_magento = BashOperator(
        task_id="transform_magento",
        bash_command=magento_silver_transform_cmd,
    )
    transform_freshdesk = BashOperator(
        task_id="transform_freshdesk",
        bash_command=freshdesk_silver_transform_cmd,
    )

    transform_odoo = BashOperator(
        task_id="transform_odoo",
        bash_command=odoo_silver_transform_cmd,
    )

    tregger_gold_modeling_dimensions = TriggerDagRunOperator(
        task_id="trigger_gold_modeling_dimensions_dag",
        trigger_dag_id="modeling",
        trigger_rule="all_success",
    )

    transform_magento  >> transform_freshdesk >>  transform_odoo >> tregger_gold_modeling_dimensions
    
