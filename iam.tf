resource "aws_iam_role" "childplay_alexa_lambda_role" {
  name               = format("childplay_alexa-lambda-role-%s", var.account_id)
  assume_role_policy = data.aws_iam_policy_document.childplay_alexa_lambda_assume_role_policy.json

  tags = merge({ Name = format("childplay_alexa-lambda-%s", var.account_id) }, local.common_tags)

}

data "aws_iam_policy_document" "childplay_alexa_lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "childplay_alexa_lambda_iam_policy" {
  name   = format("childplay_alexa-lambda-policy-%s", var.account_id)
  role   = aws_iam_role.childplay_alexa_lambda_role.id
  policy = data.aws_iam_policy_document.childplay_alexa_lambda_policy_doc.json
}

data "aws_iam_policy_document" "childplay_alexa_lambda_policy_doc" {
  statement {
    sid    = "AllowInvokingLambdas"
    effect = "Allow"

    resources = [
      aws_lambda_function.childplay_alexa_lambda.arn
    ]

    actions = [
      "lambda:InvokeFunction"
    ]
  }

  statement {
    sid    = "AllowCreatingLogGroups"
    effect = "Allow"

    resources = [
      "arn:aws:logs:*:*:*"
    ]

    actions = [
      "logs:CreateLogGroup"
    ]
  }


  statement {
    sid    = "AllowWritingLogs"
    effect = "Allow"

    resources = [
      "arn:aws:logs:*:*:log-group:/aws/lambda/*:*"
    ]

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }
}
