// Create a HashiCorp Virtual Network to host Vault
resource "hcp_hvn" "demo_hvn" {
  hvn_id         = "demo-hvn"
  cloud_provider = "aws"
  region         = var.aws_region
}

// Create a Vault cluster with a public endpoint
resource "hcp_vault_cluster" "demo_cluster" {
  hvn_id          = hcp_hvn.demo_hvn.hvn_id
  cluster_id      = "demo-cluster"
  tier            = "dev"
  public_endpoint = true # Exposing for demo purposed, don't do this in practice
}
