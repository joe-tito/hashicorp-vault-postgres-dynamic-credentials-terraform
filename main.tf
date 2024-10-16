terraform {
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.97.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "4.4.0"
    }
  }
}

provider "vault" {
  address = var.vault_address
  token   = var.vault_token
}

### HCP

resource "hcp_hvn" "demo_hvn" {
  hvn_id         = "demo-hvn"
  cloud_provider = "aws"
  region         = "us-east-1"
}

resource "hcp_vault_cluster" "learn_hcp_vault" {
  hvn_id          = hcp_hvn.demo_hvn.hvn_id
  cluster_id      = "demo-cluster"
  tier            = "dev"
  public_endpoint = true
}

## Vault

resource "vault_mount" "database" {
  path = "database"
  type = "database"
}

resource "vault_database_secret_backend_connection" "postgres" {
  backend       = vault_mount.database.path
  name          = "demo-postgresql-database"
  plugin_name   = "postgresql-database-plugin"
  allowed_roles = ["demo-role"]

  postgresql {
    connection_url = var.postgress_connection_url
  }
}

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
