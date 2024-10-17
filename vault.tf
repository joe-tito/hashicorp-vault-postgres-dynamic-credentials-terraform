// Mount the database engine
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

// Create role used to create dynamic db users
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
