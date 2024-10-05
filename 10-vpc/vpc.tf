module "vpc" {
  #source = "../terraform-aws-vpc"
  source                = "git::https://github.com/mcreddi1/terraform-aws-vpc.git"
  common_tags           = var.common_tags
  project_name          = var.project_name
  environment           = var.environment
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  database_subnet_cidrs = var.database_subnet_cidrs
  is_peering_required   = var.is_peering_required
}