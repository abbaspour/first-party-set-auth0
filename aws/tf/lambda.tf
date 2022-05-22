locals {
  lambda_name = "first-party-set"
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket_prefix = "lambda-${local.lambda_name}-"
  //provider = aws.virginia
  tags = {
    Name        = local.lambda_name
  }
}

output "bucket" {
  value = aws_s3_bucket.lambda_bucket.bucket
}

resource "aws_iam_role" "lambda_exec" {
  name = "${local.lambda_name}_lambda_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["lambda.amazonaws.com", "edgelambda.amazonaws.com"]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "fps" {
  function_name = local.lambda_name
  description = "first-party-set cookie lambda edge"

  s3_bucket = aws_s3_bucket.lambda_bucket.bucket
  s3_key = "lambda-${local.lambda_name}-${var.lambda_version}.zip"

  handler = "fps/app.handler"
  runtime = "nodejs14.x" // 16 is not available in edge yet

  role = aws_iam_role.lambda_exec.arn
  timeout = 20

  //provider = aws.virginia
  publish  = true

  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.lambda_log,
  ]
}

## logs
resource "aws_cloudwatch_log_group" "lambda_log" {
  name              = "/aws/lambda/${local.lambda_name}"
  retention_in_days = 3
}

resource "aws_iam_policy" "lambda_logging" {
  name = "${local.lambda_name}_lambda_policy"
  path = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    },
    {
      "Action": [
        "ec2:CreateNetworkInterface",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface"
      ],
      "Resource": "*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}
