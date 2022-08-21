data "archive_file" "python_lambda_package" {
  type        = "zip"
  source_dir  = "${path.module}/lambda-src/"
  output_path = "hello-lambda.zip"
}

resource "aws_lambda_function" "hello_lambda" {
  function_name    = "hello_lambda_func"
  filename         = "hello-lambda.zip"
  source_code_hash = data.archive_file.python_lambda_package.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  runtime          = "python3.6"
  handler          = "hello-lambda.lambda_handler"
  timeout          = 10
}

resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/lambda/hello_lambda_func"
  retention_in_days = 14
}


resource "aws_iam_role" "lambda_role" {
  name = "lambdaRoleIAM"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "stsLambdaSid",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
    
  ]
}
EOF
}

resource "aws_iam_policy" "policy_logs" {
  name = "lambdaLogsPolicy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "policy_sfn" {
  name = "lambdaSfnPolicy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "states:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "iam_for_lambda_attach_policy_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.policy_logs.arn
}

resource "aws_iam_role_policy_attachment" "iam_for_lambda_attach_policy_sfn" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.policy_sfn.arn
}
