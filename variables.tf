variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "vault_address" {
  type = string
}

variable "vault_approle_role_id" {
  type = string
}

variable "vault_approle_secret_id" {
  type = string
}

variable "postgres_user" {
  type = string
}

variable "postgres_password" {
  type = string
}
