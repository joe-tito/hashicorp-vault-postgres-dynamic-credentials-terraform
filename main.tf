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

resource "vault_mount" "kvv2" {
  path        = "kvv2"
  type        = "kv"
  options     = { version = "2" }
  description = "KV Version 2 secret engine mount"
}

resource "vault_kv_secret_v2" "example" {
  mount               = vault_mount.kvv2.path
  name                = "secret"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      zip = "zap",
      foo = "bar"
    }
  )
  custom_metadata {
    max_versions = 5
    data = {
      foo = "vault@example.com",
      bar = "12345"
    }
  }
}
