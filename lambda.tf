data "archive_file" "python_lambda_package" {  
  type = "zip"  
  source_file = "${path.module}/lambda-src/hello-lambda.py" 
  output_path = "hello-lambda.zip"
}

data "aws_iam_policy_document" "lambda_assume_role_policy"{
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]    
    principals {
      type        = "Service"
      identifiers = ["*"]
    }
  }

  statement {
    effect = "Allow"
    actions = [
       "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
    ]
    principals {
      type = "Service"
      identifiers = [ "*" ]
    }
  }
}

resource "aws_iam_role" "lambda_role" {  
  name = "lambda-lambdaRole-waf"  
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

resource "aws_lambda_function" "hello_lambda" {
  function_name = "hello_lambda_func"
  filename      = "hello-lambda.zip"
  source_code_hash = data.archive_file.python_lambda_package.output_base64sha256
  role          = aws_iam_role.lambda_role.arn
  runtime       = "python3.6"
  handler       = "hello-lambda.lambda_handler"
  timeout       = 10
}

resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/lambda/hello_lambda_func"
  retention_in_days = 14
}