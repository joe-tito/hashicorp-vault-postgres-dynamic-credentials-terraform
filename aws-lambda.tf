resource "aws_lambda_function" "lambda_function" {
  filename      = "${path.module}/lambda/lambda.zip"
  function_name = "vault-lambda-function"
  role          = module.lambda_execution_role.iam_role_arn
  handler       = "index.handler"

  source_code_hash = data.archive_file.zip_lambda.output_base64sha256

  runtime = "nodejs18.x"

  layers = ["arn:aws:lambda:${var.aws_region}:634166935893:layer:vault-lambda-extension:14"]

  environment {
    variables = {
      VAULT_ADDR          = "https://demo-cluster-public-vault-0493af48.3f7d4994.z1.hashicorp.cloud:8200"
      VAULT_AUTH_PROVIDER = "aws"
      VAULT_AUTH_ROLE     = module.lambda_execution_role.iam_role_name #Use the same name as the Lambda role name
      VAULT_SECRET_PATH   = "database/creds/demo-role"
      VAULT_SECRET_FILE   = "/tmp/vault_secret.json",
      VAULT_NAMESPACE     = "admin"
      VAULT_TOKEN         = var.vault_token
    }
  }
}

resource "aws_lambda_function_url" "lambda_function_url" {
  function_name      = aws_lambda_function.lambda_function.arn
  authorization_type = "NONE"
}

data "archive_file" "zip_lambda" {
  type        = "zip"
  source_dir  = "${path.module}/lambda"
  output_path = "${path.module}/lambda/lambda.zip"
}

module "lambda_execution_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 4.24"

  create_role           = true
  role_requires_mfa     = false
  role_name             = "vault-lambda-role"
  trusted_role_services = ["lambda.amazonaws.com"]
  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ]
}
