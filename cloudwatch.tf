resource "aws_cloudwatch_log_group" "childplay_alexa_lambda_cloudwatch_log_group" {
  name              = format("/aws/lambda/childplay_alexa-lambda-%s", var.account_id)
  retention_in_days = var.cloudwatch_logs_retention_period
}
