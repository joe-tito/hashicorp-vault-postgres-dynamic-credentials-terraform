variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "vault_address" {
  type = string
}

# variable "vault_token" {
#   type = string
# }

variable "postgres_user" {
  type = string
}

variable "postgres_password" {
  type = string
}
