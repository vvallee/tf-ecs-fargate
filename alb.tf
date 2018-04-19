module "alb" {
  source                = "terraform-aws-modules/alb/aws"
  load_balancer_name    = "test-alb-${random_string.suffix.result}"
  security_groups       = ["${module.alb_sg.this_security_group_id}"]
  log_bucket_name       = "${aws_s3_bucket.log_bucket.id}"
  log_location_prefix   = "${var.log_location_prefix}"
  subnets               = "${module.vpc.public_subnets}"
  tags                  = "${local.tags}"
  vpc_id                = "${module.vpc.vpc_id}"
  https_listeners       = "${local.https_listeners}"
  https_listeners_count = "${local.https_listeners_count}"
  target_groups         = "${local.target_groups}"
  target_groups_count   = "${local.target_groups_count}"
}
