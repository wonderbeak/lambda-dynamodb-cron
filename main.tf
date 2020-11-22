data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "src"
  output_path = "lambda.zip"
}

resource "aws_lambda_function" "timestamp_function" {
  filename         = "lambda.zip"
  function_name    = "insert_lambda_function"
  role             = aws_iam_role.timestamp_function.arn
  handler          = "index.handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = "nodejs12.x"
  depends_on       = [data.archive_file.lambda_zip]
}

resource "aws_dynamodb_table" "timestamps" {
  name           = "timestamps"
  hash_key       = "timestamp"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5

  attribute {
    name = "timestamp"
    type = "N"
  }
}

resource "aws_cloudwatch_event_rule" "one_minute" {
  name                = "timestamp-one-minute"
  description         = "Put Timestamp in DynamoDB every 1 minute"
  schedule_expression = "rate(1 minute)"
}

resource "aws_cloudwatch_event_target" "trigger_target" {
  rule      = aws_cloudwatch_event_rule.one_minute.name
  target_id = "lambda"
  arn       = aws_lambda_function.timestamp_function.arn
}

resource "aws_lambda_permission" "attach_trigger" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.timestamp_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.one_minute.arn
}

// not a good practice
resource "null_resource" "local" {
  depends_on = [aws_lambda_function.timestamp_function]

  provisioner "local-exec" {
    command = "rm lambda.zip"
  }
}
