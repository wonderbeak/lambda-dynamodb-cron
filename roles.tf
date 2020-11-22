resource "aws_iam_role" "timestamp_function" {
  name               = "timestamp_lambda_function_role"
  description        = "Timestamp Lambda Function Role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "timestamp_policy" {
  name        = "timestamp_policy"
  description = "PutItem in DynamoDB Policy for Lambda"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "dynamodb:PutItem",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "timestamp_attach" {
  role       = aws_iam_role.timestamp_function.name
  policy_arn = aws_iam_policy.timestamp_policy.arn
}