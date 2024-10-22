// Zip up lambda source code
data "archive_file" "zip_lambda" {
  type        = "zip"
  source_dir  = "${path.module}/lambda"
  output_path = "${path.module}/lambda/lambda.zip"
}

// Create a nodejs lambda function
resource "aws_lambda_function" "lambda_function" {
  filename      = "${path.module}/lambda/lambda.zip"
  function_name = "vault-lambda-function"
  role          = module.lambda_execution_role.iam_role_arn
  handler       = "index.handler"

  source_code_hash = data.archive_file.zip_lambda.output_base64sha256

  runtime = "nodejs18.x"

  environment {
    variables = {
      VAULT_URL   = hcp_vault_cluster.demo_cluster.vault_public_endpoint_url
      VAULT_TOKEN = var.vault_token # // Using token for demo purposes. Use more secure auth (i.e., IAM) in practice
    }
  }

  depends_on = [hcp_vault_cluster.demo_cluster]
}

// Create a public URL for the lambda funciton
resource "aws_lambda_function_url" "lambda_function_url" {
  function_name      = aws_lambda_function.lambda_function.arn
  authorization_type = "NONE"
}

// Create IAM role with permissions for lambda
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
