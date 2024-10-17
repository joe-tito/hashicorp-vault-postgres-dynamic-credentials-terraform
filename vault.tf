# resource "vault_mount" "database" {
#   path = "database"
#   type = "database"
# }

# resource "vault_database_secret_backend_connection" "postgres" {
#   backend       = vault_mount.database.path
#   name          = "demo-postgresql-database"
#   plugin_name   = "postgresql-database-plugin"
#   allowed_roles = ["demo-role"]

#   postgresql {
#     connection_url = "postgresql://${aws_db_instance.default.username}:${aws_db_instance.default.password}@${aws_db_instance.default.endpoint}/${aws_db_instance.default.db_name}"
#   }
# }

# resource "vault_database_secret_backend_role" "role" {
#   backend = vault_mount.database.path
#   name    = "demo-role"
#   db_name = vault_database_secret_backend_connection.postgres.name
#   creation_statements = [
#     "CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';",
#     "GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";"
#   ]
#   default_ttl = 30
#   max_ttl     = 60

#   depends_on = [aws_db_instance.default]
# }
