@REM aws dynamodb delete-table ^
@REM     --table-name himesha-terraform-lock-table ^
@REM     --region us-east-1


aws dynamodb create-table ^
    --table-name himesha-terraform-lock-table ^
    --attribute-definitions AttributeName=LockID,AttributeType=S ^
    --key-schema AttributeName=LockID,KeyType=HASH ^
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 ^
    --region us-east-1


@REM aws s3api delete-bucket --bucket himesha-terraform-state-bucket --region us-east-1
aws s3api create-bucket --bucket himesha-terraform-state-bucket --region us-east-1