#!/bin/bash
set -e

echo "[INFO] Running LocalStack init script..."

# Create bucket if it does not exist
if ! aws --endpoint-url=http://localhost:4566 s3api head-bucket --bucket unified 2>/dev/null; then
  echo "[INFO] Creating bucket unified"
  aws --endpoint-url=http://localhost:4566 s3api create-bucket --bucket unified
else
  echo "[INFO] Bucket unified already exists"
fi

# Bronze
aws --endpoint-url=http://localhost:4566 s3api put-object --bucket unified --key "bronze_layer/batch_job/"

# Silver
aws --endpoint-url=http://localhost:4566 s3api put-object --bucket unified --key "silver_layer/valid_data/"
aws --endpoint-url=http://localhost:4566 s3api put-object --bucket unified --key "silver_layer/reject_data/"

# Gold
aws --endpoint-url=http://localhost:4566 s3api put-object --bucket unified --key "gold_layer/valid_data/"

echo "[INFO] Init script completed ✅"
