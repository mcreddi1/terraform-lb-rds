variable "environment" {
  default = "dev"
}

variable "project_name" {
    default = "expense"
}

variable "common_tags" {
  default = {
    Project = "expense"
    Terraform = "True"
    Environment = "Dev"
  }
}

variable "mysql_sg_tags" {
  default = {
    component = "mysql"
  }
}
