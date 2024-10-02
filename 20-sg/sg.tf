module "mysql_sg" {
  source       = "../../terraform-aws-sg"
  environment  = var.environment
  project_name = var.project_name
  sg_name      = "mysql"
  vpc_id       = local.vpc_id
  common_tags  = var.common_tags
  sg_tags      = var.mysql_sg_tags
}

module "backend_sg" {
  source       = "../../terraform-aws-sg"
  environment  = var.environment
  project_name = var.project_name
  sg_name      = "backend"
  vpc_id       = local.vpc_id
  common_tags  = var.common_tags
}

module "frontend_sg" {
  source       = "../../terraform-aws-sg"
  environment  = var.environment
  project_name = var.project_name
  sg_name      = "frontend"
  vpc_id       = local.vpc_id
  common_tags  = var.common_tags
}

module "ansible_sg" {
  source       = "../../terraform-aws-sg"
  environment  = var.environment
  project_name = var.project_name
  sg_name      = "ansible"
  vpc_id       = local.vpc_id
  common_tags  = var.common_tags
}

#MYSQL Allowing connection on 3306 port from the instances attached to Backend SG 
resource "aws_security_group_rule" "mysql_backend" {
  type                     = "ingress"
  to_port                  = 3306
  from_port                = 3306
  protocol                 = "tcp"
  source_security_group_id = module.backend_sg.id
  security_group_id        = module.mysql_sg.id
}

#backend Allowing connection on 8080 port from the instances attached to frontend SG 
resource "aws_security_group_rule" "backend_frontend" {
  type                     = "ingress"
  to_port                  = 8080
  from_port                = 8080
  protocol                 = "tcp"
  source_security_group_id = module.frontend_sg.id
  security_group_id        = module.backend_sg.id
}

#frontend Allowing connection on 80 port from the instances attached to   frontnedSG 
resource "aws_security_group_rule" "frontend_public" {
  type              = "ingress"
  to_port           = 80
  from_port         = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.frontend_sg.id
}

module "bastion_sg" {
  source       = "../../terraform-aws-sg"
  environment  = var.environment
  project_name = var.project_name
  sg_name      = "bastion"
  vpc_id       = local.vpc_id
  common_tags  = var.common_tags
}

resource "aws_security_group_rule" "frontend_bastion" {
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.id
  security_group_id = module.frontend_sg.id
}

resource "aws_security_group_rule" "backend_bastion" {
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.id
  security_group_id = module.backend_sg.id
}

resource "aws_security_group_rule" "mysql_bastion" {
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion_sg.id
  security_group_id = module.mysql_sg.id
}

resource "aws_security_group_rule" "mysql_ansible" {
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  source_security_group_id = module.ansible_sg.id
  security_group_id = module.mysql_sg.id
}

resource "aws_security_group_rule" "frontend_ansible" {
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  source_security_group_id = module.ansible_sg.id
  security_group_id = module.frontend_sg.id
}

resource "aws_security_group_rule" "backend_ansible" {
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  source_security_group_id = module.ansible_sg.id
  security_group_id = module.backend_sg.id
}

resource "aws_security_group_rule" "ansible_public" {
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.ansible_sg.id
}

resource "aws_security_group_rule" "bastion_public" {
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.bastion_sg.id
}