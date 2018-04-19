# Create a security group, currently for ECS/ALB

module "ecs_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  name        = "ecs-sg-http"
  description = "Allow all ports from ALB SG, allow HTTPS out from ECS for Docker Pull"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "All Ports from ALB SG"

      cidr_blocks = "10.0.0.0/16"

      # source_security_group_id = "${module.alb_sg.this_security_group_id}"
    },
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "Allow HTTPS out from ECS, required for Docker Pull"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}


module "alb_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  name        = "alb-sg"
  description = "Security group with HTTPS ports open for everybody"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress_with_cidr_blocks = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "Allow HTTPS"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "All Ports from ALB SG to ECS SG"

      cidr_blocks = "10.0.0.0/16"

      #source_security_group_id = "${module.ecs_sg.this_security_group_id}"
    },
  ]
}
