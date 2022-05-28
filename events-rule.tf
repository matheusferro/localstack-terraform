#https://registry.terraform.io/modules/terraform-aws-modules/eventbridge/aws/latest
# module "eventbridge" {
#   source = "terraform-aws-modules/eventbridge/aws"

#   create_bus = false

#   rules = {
#     crons = {
#       description         = "Call lambda every 50 seconds"
#       schedule_expression = "cron(*/50 * * * * *)"
#     }
#   }

#   targets = {
#     crons = [
#       {
#         name            = "my lambda"
#         arn             = aws_lambda_function.hello_lambda.arn
#         input = jsonencode({"job": "event-cron"})
#       }
#     ]
#   }
# }

resource "aws_cloudwatch_event_rule" "cloudwatch_lambda_rule" {
    name = "cloudwatch-lambda-rule"
    description = "Call lambda every minute"
    schedule_expression = "rate(1 minute)"
}

resource "aws_cloudwatch_event_target" "call_lambda" {
    rule = aws_cloudwatch_event_rule.cloudwatch_lambda_rule.name
    arn = aws_lambda_function.hello_lambda.arn
    input = jsonencode({"job": "cloudwatch-rules"})
}

resource "aws_lambda_permission" "cloudwatch_invoke" {
 statement_id  = "AllowExecutionFromCloudWatch"
 action        = "lambda:InvokeFunction"
 function_name = aws_lambda_function.hello_lambda.function_name
 principal     = "events.amazonaws.com"
 source_arn    = aws_cloudwatch_event_rule.cloudwatch_lambda_rule.arn
}