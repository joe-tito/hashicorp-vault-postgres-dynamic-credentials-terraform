module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~>5.3"

  function_name = "vault-lambda-function"
  handler       = "index.handler"
  source_path   = "./handler"
  runtime       = "nodejs18.x"
  memory_size   = "128"
  create_role   = false
  lambda_role   = module.lambda_execution_role.iam_role_arn

  environment_variables = {
    VAULT_ADDR                = "https://demo-cluster-public-vault-0493af48.3f7d4994.z1.hashicorp.cloud:8200"
    VAULT_AUTH_PROVIDER       = "aws"
    VAULT_AUTH_ROLE           = module.lambda_execution_role.iam_role_name #Use the same name as the Lambda role name
    VAULT_STS_ENDPOINT_REGION = var.aws_region
    VAULT_SECRET_PATH         = "database/creds/demo-role"
    VAULT_PROXY_SERVER_HOST   = "http://127.0.0.1:8200"
    VAULT_API_VERSION         = "v1"
    VAULT_NAMESPACE           = "admin"
  }

  layers = ["arn:aws:lambda:${var.aws_region}:634166935893:layer:vault-lambda-extension:16"]
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
