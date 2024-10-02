module "app_alb" {
  source                     = "terraform-aws-modules/alb/aws"
  internal                   = true
  security_groups            = [data.aws_ssm_parameter.app_alb_sg.value]
  name                       = "${local.resource_name}-app-alb"
  vpc_id                     = local.vpc_id
  create_security_group      = false
  subnets                    = local.private_subnet_ids
  enable_deletion_protection = false
  tags = {
    Environment = "Dev"
    Project     = "Expense"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = module.app_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hello, i am from application load balancer</h1>"
      status_code  = "200"
    }
  }
}

module "records" {
  source = "terraform-aws-modules/route53/aws//modules/records"

  zone_name = var.zone_name
  records = [

    {
      name = "*.app-${var.environment}" # *.app-dev.devops81s.shop
      type = "A"
      alias = {
        name    = module.app_alb.dns_name
        zone_id = module.app_alb.zone_id
        allow_overwrite = true
      }
    },
  ]
}
