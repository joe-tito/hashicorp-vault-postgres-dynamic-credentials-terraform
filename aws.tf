# module "vpc" {
#   source  = "terraform-aws-modules/vpc/aws"
#   version = "5.13.0"

#   name = "demo-vpc"
#   cidr = "10.0.0.0/16"

#   azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
#   private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
#   public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

#   enable_nat_gateway = true
#   enable_vpn_gateway = true

#   tags = {
#     Terraform   = "true"
#     Environment = "dev"
#   }
# }

# resource "aws_security_group" "all_inbound" {
#   vpc_id      = module.vpc.default_vpc_id
#   name        = "all_inbound"
#   description = "Allow all inbound for Postgres"
#   ingress {
#     from_port   = 5432
#     to_port     = 5432
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# resource "aws_db_instance" "default" {
#   allocated_storage = 10
#   db_name           = "postgres"
#   engine            = "postgres"
#   engine_version    = "16.4"
#   instance_class    = "db.t3.micro"
#   username          = var.postgres_user
#   password          = var.postgres_password
# }
