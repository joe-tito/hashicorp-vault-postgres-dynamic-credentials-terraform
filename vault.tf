// Mount database engine
resource "vault_mount" "database" {
  path = "database"
  type = "database"

  depends_on = [aws_db_instance.default]
}

// Establish connection between database engine and postgres
resource "vault_database_secret_backend_connection" "postgres" {
  backend       = vault_mount.database.path
  name          = "demo-postgresql-database"
  plugin_name   = "postgresql-database-plugin"
  allowed_roles = ["demo-role"]

  postgresql {
    connection_url = "postgresql://${var.postgres_user}:${var.postgres_password}@${aws_db_instance.default.endpoint}/postgres"
  }
}

// Create role to create dynamic postgres database users. Super short TTL for demo purposes.
resource "vault_database_secret_backend_role" "role" {
  backend = vault_mount.database.path
  name    = "demo-role"
  db_name = vault_database_secret_backend_connection.postgres.name
  creation_statements = [
    "CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';",
    "GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";"
  ]
  default_ttl = 30
  max_ttl     = 60
}





resource "vault_auth_backend" "aws" {
  type        = "aws"
  description = "AWS authentication"
}

resource "vault_aws_auth_backend_client" "backend_client" {
  backend    = vault_auth_backend.aws.path
  sts_region = var.aws_region
  # sts_region   = "ap-southeast-1"
  # sts_endpoint = "https://sts.ap-southeast-1.amazonaws.com"
}

resource "vault_policy" "vault_policy_for_lambda" {
  name   = "vault-lambda"
  policy = data.vault_policy_document.read_lambda_api_keys.hcl
}

data "vault_policy_document" "read_lambda_api_keys" {
  rule {
    path         = "database/*"
    capabilities = ["read"]
  }
}

resource "vault_aws_auth_backend_role" "vault_lambda_role" {
  backend                  = vault_auth_backend.aws.path
  role                     = "vault-lambda-role"
  auth_type                = "iam"
  resolve_aws_unique_ids   = false
  bound_iam_principal_arns = [module.lambda_execution_role.iam_role_arn]
  token_policies           = [vault_policy.vault_policy_for_lambda.name]
}
