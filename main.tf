terraform {
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "0.97.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "4.4.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.72.1"
    }
  }
}

provider "vault" {
  address   = var.vault_address
  namespace = "admin"
  token     = var.vault_token
}

provider "aws" {
  region = var.aws_region
}
