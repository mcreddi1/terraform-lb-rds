module "bastion" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = local.resource_name
  ami  = data.aws_ami.chinna.id

  instance_type          = "t2.micro"
  vpc_security_group_ids = [local.bastion_sg_id]
  subnet_id              = local.public_subnet_ids

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
