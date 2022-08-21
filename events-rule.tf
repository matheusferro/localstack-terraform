resource "aws_cloudwatch_event_rule" "cloudwatch_lambda_rule" {
  name                = "cloudwatch_lambda_rule"
  description         = "Call lambda every minute"
  schedule_expression = "rate(1 minute)"
}

resource "aws_cloudwatch_event_target" "call_lambda" {
  rule  = aws_cloudwatch_event_rule.cloudwatch_lambda_rule.name
  arn   = aws_lambda_function.hello_lambda.arn
  input = jsonencode({ "job" : "cloudwatch-rules" })
}

resource "aws_lambda_permission" "cloudwatch_invoke" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hello_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.cloudwatch_lambda_rule.arn
}
