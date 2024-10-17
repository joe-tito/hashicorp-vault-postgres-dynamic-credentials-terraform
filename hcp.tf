resource "hcp_hvn" "demo_hvn" {
  hvn_id         = "demo-hvn"
  cloud_provider = "aws"
  region         = var.aws_region
}

// Create a Vault cluster in the same region and cloud provider as the HVN
resource "hcp_vault_cluster" "demo_cluster" {
  hvn_id          = hcp_hvn.demo_hvn.hvn_id
  cluster_id      = "demo-cluster"
  tier            = "dev"
  public_endpoint = true
}

data "hcp_vault_cluster" "demo_cluster_data" {
  cluster_id = hcp_vault_cluster.demo_cluster.id
}
