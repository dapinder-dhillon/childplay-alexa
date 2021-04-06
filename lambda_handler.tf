
resource "null_resource" "childplay_alexa_install_python_dependencies" {
  triggers = {
    dir_sha256 = sha256(join("", [for f in fileset(format("%s/scripts/lambda/alexa", path.module), "**") : filesha256(format("%s/scripts/lambda/alexa/%s", path.module, f))]))
  }

  provisioner "local-exec" {
    command = format("bash %s/create_pkg.sh", path.module)
    environment = {
      SOURCE_DIR       = format("%s/scripts/lambda/alexa/", path.module)
      PIPFILE_LOCATION = format("%s/scripts/lambda/Pipfile", path.module)
      LAMBDA_DIST_DIR  = format("%s/lambda_alexa_dist_pkg", path.module)
      FUNCTION_NAME    = "alexa_childplay"
      RUNTIME          = var.runtime
    }
  }
}

resource "random_string" "childplay_alexa_random" {
  length  = 4
  special = false
  keepers = {
    dir_sha256 = sha256(join("", [for f in fileset(format("%s/scripts/lambda/alexa", path.module), "**") : filesha256(format("%s/scripts/lambda/alexa/%s", path.module, f))]))
  }
}

data "archive_file" "childplay_alexa_create_dist_pkg" {
  depends_on  = [null_resource.childplay_alexa_install_python_dependencies]
  source_dir  = format("%s/lambda_alexa_dist_pkg", path.module)
  output_path = format("%s/lambda_function_%s.zip", path.module, random_string.childplay_alexa_random.result)
  type        = "zip"
}

resource "aws_lambda_function" "childplay_alexa_lambda" {
  function_name = format("childplay-alexa-lambda-%s", var.account_id)
  description   = "Creates and rotates IAM user access and secret keys."
  handler       = "alexalambdahandler.lambda_handler"
  runtime       = var.runtime
  timeout       = var.childplay_alexa_lambda_timeout

  role = aws_iam_role.childplay_alexa_lambda_role.arn

  depends_on = [
    null_resource.childplay_alexa_install_python_dependencies,
    aws_cloudwatch_log_group.childplay_alexa_lambda_cloudwatch_log_group
  ]
  filename = data.archive_file.childplay_alexa_create_dist_pkg.output_path

  tags = merge({ Name = format("childplay-alexa-lambda-%s", var.account_id) }, local.common_tags)
}



resource "aws_lambda_permission" "permission_to_rule_to_invoke_lambda_from_alexa" {
  statement_id       = "permission-to-rule-to-invoke-lambda"
  action             = "lambda:InvokeFunction"
  function_name      = aws_lambda_function.childplay_alexa_lambda.function_name
  principal          = "alexa-appkit.amazon.com"
  event_source_token = "amzn1.ask.skill.8be8ff58-f6ca-4348-8031-c6e4047a019f"
}
