## Lambda function that inserts a Timestamp every minute in DynamoDB
Small Lambda function written in JS that triggered every 1 minute by AWS EventBridge to insert current timestamp in DynamoDB. 

### Used versions
- Terraform v0.13.5
- AWS v3.16.0
- null v3.0.0 (for shell rm command)

### Provisioned resources
- Lambda function in NodeJs v12
- DynamoDB table "timestamps" with "timestamp" primary key
- Appropriate assume role and policy for Lambda function to putItem in DynamoDB
- EventBridge event rule
- Zip source files (and local file removal)

### Usage example
During provisioning it will ask for access_key and secret_key
- git clone https://github.com/wonderbeak/lambda-dynamodb-cron.git
- terraform init
- terraform validate
- terraform plan
- terraform apply
- terraform destroy