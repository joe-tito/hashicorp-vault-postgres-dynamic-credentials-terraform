resource "hcp_hvn" "demo_hvn" {
  hvn_id         = "demo-hvn"
  cloud_provider = "aws"
  region         = var.aws_region
}

// Create a network peering between the HVN and the AWS VPC
resource "hcp_aws_network_peering" "demo_peering" {
  hvn_id          = hcp_hvn.demo_hvn.hvn_id
  peering_id      = "hcp-tf-demo-peering"
  peer_vpc_id     = module.vpc.vpc_id
  peer_account_id = module.vpc.vpc_owner_id
  peer_vpc_region = data.aws_arn.main.region
}

resource "aws_vpc_peering_connection_accepter" "main" {
  vpc_peering_connection_id = hcp_aws_network_peering.demo_peering.provider_peering_id
  auto_accept               = true
}

// Create an HVN route that targets your HCP network peering and matches your AWS VPC's CIDR block
resource "hcp_hvn_route" "example" {
  hvn_link         = hcp_hvn.demo_hvn.self_link
  hvn_route_id     = "hcp-tf-example-hvn-route"
  destination_cidr = module.vpc.vpc_cidr_block
  target_link      = hcp_aws_network_peering.demo_peering.self_link
}

// Create a Vault cluster in the same region and cloud provider as the HVN
resource "hcp_vault_cluster" "demo_cluster" {
  hvn_id          = hcp_hvn.demo_hvn.hvn_id
  cluster_id      = "demo-cluster"
  tier            = "dev"
  public_endpoint = true
}
