
resource "aws_sfn_state_machine" "step_function_test" {
  name     = "state-machine-sfn"
  role_arn = aws_iam_role.iam_for_sfn.arn

  definition = <<EOF
  {

    "Comment": "A Hello World example of the Amazon States Language using an AWS Lambda Function",
    "StartAt": "ScheduleTask",
    "States": {
      "ScheduleTask": {
        "Type": "Wait",
        "TimestampPath": "$.sendTimestamp",
        "Next": "Send SQS event"
      },
      "Send SQS event": {
        "Type": "Pass",
        "Comment": "sending sqs event", 
        "Next": "Send SNS event"
      },
      "Send SNS event": {
        "Type": "Pass",
        "Comment": "sending sns event", 
        "End": true
      }
    }
  }
  EOF

  # type = "EXPRESS"

  logging_configuration {
    # log_destination        = "${aws_cloudwatch_log_group.sfn_group.arn}:*"
    log_destination        = "arn:aws:logs:us-east-1:000000000000:log-group:/aws/steps/state-machine-sfn"
    level                  = "ALL"
    include_execution_data = true
  }

  tracing_configuration {
    enabled = true
  }
}
# "FunctionName": "${aws_lambda_function.hello_lambda.function_name}",
resource "aws_cloudwatch_log_group" "sfn_group" {
  name              = "/aws/steps/state-machine-sfn"
  retention_in_days = 14
}

# data "aws_iam_policy_document" "sfn_policy" {
#   statement {
#     effect  = "Allow"
#     actions = ["sts:AssumeRole"]
#     principals {
#       type        = "Service"
#       identifiers = ["states.amazonaws.com"]
#     }
#   }

#   statement {
#     effect = "Allow"
#     actions = ["states:ListStateMachines",
#       "states:ListActivities",
#       "states:CreateStateMachine",
#       "states:CreateAu estar passando uma semana em Hamburg na Alemanha e a parte mais interessante é que tenho duas propostas de empr"states.amazonaws.com"]
#     }
#   }

# statement {
#   effect  = "Allow"
#   actions = ["sns:Publish"]
#   principals {
#     type        = "Service"
#     identifiers = ["*"]
#   }
# }

# statement {
#   effect  = "Allow"
#   actions = ["sqs:*"]
#   principals {
#     type        = "Service"
#     identifiers = ["*"]
#   }
# }u estar passando uma semana em Hamburg na Alemanha e a parte mais interessante é que tenho duas propostas de empr
#   actions = ["lambda:InvokeFunction"]
#   principals {
#     type        = "Service"
#     identifiers = ["*"]
#   }
# }

#   statement {
#     effect = "Allow"
#     actions = [
#       "logs:CreateLogDelivery",
#       "logs:GetLogDelivery",
#       "logs:UpdateLogDelivery",
#       "logs:DeleteLogDelivery",
#       "logs:ListLogDu estar passando uma semana em Hamburg na Alemanha e a parte mais interessante é que tenho duas propostas de empr
#     principals {
#       type        = "Service"
#       identifiers = ["*"]
#     }
#   }
# }

# resource "aws_iam_role" "sfn_role" {
#   name               = "sfn-role"
#   assume_role_policy = data.aws_iam_policy_document.sfn_policy.json
# }


# Create IAM role for AWS Step Function
resource "aws_iam_role" "iam_for_sfn" {
  name = "stepFunctionSampleStepFunctionExecutionIAM"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "stsSfnSid",
      "Effect": "Allow",
      "Principal": {
        "Service": "states.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
    
  ]
}
EOF
}


resource "aws_iam_policy" "policy_publish_sns" {
  name = "stepFunctionSampleSNSInvocationPolicy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
              "sns:Publish",
              "sns:SetSMSAttributes",
              "sns:GetSMSAttributes"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}


resource "aws_iam_policy" "policy_invoke_lambda" {
  name = "stepFunctionSampleLambdaFunctionInvocationPolicy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "lambda:InvokeFunction",
                "lambda:InvokeAsync"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "policy_cw" {
  name = "stepFunctionSampleCWFunctionInvocationPolicy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "logs:CreateLogDelivery",
              "logs:GetLogDelivery",
              "logs:UpdateLogDelivery",
              "logs:DeleteLogDelivery",
              "logs:ListLogDeliveries",
              "logs:PutLogEvents",
              "logs:PutResourcePolicy",
              "logs:DescribeResourcePolicies",
              "logs:DescribeLogGroups"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

// Attach policy to IAM Role for Step Function
resource "aws_iam_role_policy_attachment" "iam_for_sfn_attach_policy_invoke_lambda" {
  role       = aws_iam_role.iam_for_sfn.name
  policy_arn = aws_iam_policy.policy_invoke_lambda.arn
}

resource "aws_iam_role_policy_attachment" "iam_for_sfn_attach_policy_publish_sns" {
  role       = aws_iam_role.iam_for_sfn.name
  policy_arn = aws_iam_policy.policy_publish_sns.arn
}

resource "aws_iam_role_policy_attachment" "iam_for_sfn_attach_policy_publish_cw" {
  role       = aws_iam_role.iam_for_sfn.name
  policy_arn = aws_iam_policy.policy_cw.arn
}

