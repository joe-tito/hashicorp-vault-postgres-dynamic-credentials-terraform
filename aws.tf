// Build base VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"

  name = "demo-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false
}

// Create security group that only allows postgres traffic from one IP
resource "aws_security_group" "all_inbound" {
  vpc_id      = module.vpc.default_vpc_id
  name        = "all_inbound"
  description = "Allow all inbound for Postgres"
  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"

    cidr_blocks = ["75.68.149.137/32", hcp_hvn.demo_hvn.cidr_block] # Only allow my IP for demo
  }
}

// Create Postgres DB
resource "aws_db_instance" "default" {
  allocated_storage   = 10
  db_name             = "postgres"
  engine              = "postgres"
  engine_version      = "16.4"
  instance_class      = "db.t3.micro"
  username            = var.postgres_user
  password            = var.postgres_password
  publicly_accessible = true # Exposing for demo purposes, probably don't do this in practice
  skip_final_snapshot = true

  vpc_security_group_ids = [
    aws_security_group.all_inbound.id
  ]
}
