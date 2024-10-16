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
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

provider "vault" {
  address = var.vault_address
  token   = var.vault_token
}

provider "aws" {
  region = "us-east-1"
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

## AWS

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "all_inbound" {
  vpc_id      = data.aws_vpc.default.id
  name        = "uddin"
  description = "Allow all inbound for Postgres"
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "default" {
  allocated_storage = 10
  db_name           = "postgres"
  engine            = "postgres"
  engine_version    = "16.4"
  instance_class    = "db.t3.micro"
  username          = "root"
  password          = "password"
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
