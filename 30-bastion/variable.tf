variable "environment" {
  default = "dev"
}

variable "project_name" {
  default = "expense"
}

variable "common_tags" {
  default = {
    Project     = "Terraform"
    Terraform   = "True"
    Environment = "Dev"
  }
}