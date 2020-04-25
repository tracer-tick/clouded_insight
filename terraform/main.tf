module "networking" {
  source = "./networking/vpc"

  vpc_cidr_block = var.vpc_cidr_block
  vpc_name = var.vpc_name
}

module "application_load_balancer" {
  source = "./availability/application_load_balancer"

  alb_name                  = var.alb_name
  alb_target_group_name     = var.alb_target_group_name
  alb_target_group_port     = var.alb_target_group_port
  alb_target_group_protocol = var.alb_target_group_protocol
  public_subnet_ids         = module.networking.public_subnets.*.id
  security_group_id         = [module.security_group_alb.aws_security_group.id]
  vpc_id                    = module.networking.vpc.id
}

module "cloudwatch_log_groups" {
  source = "./logging/cloudwatch_logs"

  retention_in_days = var.retention_in_days
}
module "security_group_alb" {
  source = "./security/security_group"

  aws_security_group_name = "alb"
  description             = "Inbound: HTTP and HTTPS traffic from from all. Outbound: all to ec2 instances."
  vpc_id                  = module.networking.vpc.id
}

module "security_group_ec2_instances" {
  source = "./security/security_group"

  aws_security_group_name = "ec2_instances"
  description             = "Inbound: HTTP and HTTPS traffic from ${join(", ", var.locked_down_ip_addresses)} from ${module.security_group_alb.aws_security_group.name}. Outbound: any to all."
  vpc_id                  = module.networking.vpc.id
}

module "security_group_rds" {
  source = "./security/security_group"

  aws_security_group_name = "rds"
  description             = "Inbound: TCP/3306 from ${join(", ", var.locked_down_ip_addresses)} and from ${module.security_group_ec2_instances.aws_security_group.name}. Outbound: all."
  vpc_id                  = module.networking.vpc.id
}
module "security_group_rule_1" {
  source = "./security/security_group_rule/sg"

  aws_security_group_rule_description              = "Allows HTTP traffic inbound from ALB."
  aws_security_group_rule_from_port                = 80
  aws_security_group_rule_protocol                 = "tcp"
  aws_security_group_rule_security_group_id        = module.security_group_ec2_instances.aws_security_group.id
  aws_security_group_rule_source_security_group_id = module.security_group_alb.aws_security_group.id
  aws_security_group_rule_to_port                  = 80
  aws_security_group_rule_type                     = "ingress"
}

module "security_group_rule_2" {
  source = "./security/security_group_rule/sg"

  aws_security_group_rule_description              = "Allows HTTPS traffic inbound from ALB."
  aws_security_group_rule_from_port                = 443
  aws_security_group_rule_protocol                 = "tcp"
  aws_security_group_rule_security_group_id        = module.security_group_ec2_instances.aws_security_group.id
  aws_security_group_rule_source_security_group_id = module.security_group_alb.aws_security_group.id
  aws_security_group_rule_to_port                  = 443
  aws_security_group_rule_type                     = "ingress"
}

module "security_group_rule_3" {
  source = "./security/security_group_rule/ip"

  aws_security_group_rule_cidr_blocks       = ["0.0.0.0/0"]
  aws_security_group_rule_description       = "Allows all traffic outbound to any IP address"
  aws_security_group_rule_from_port         = 0
  aws_security_group_rule_protocol          = "-1"
  aws_security_group_rule_security_group_id = module.security_group_ec2_instances.aws_security_group.id
  aws_security_group_rule_to_port           = 0
  aws_security_group_rule_type              = "egress"
}

module "security_group_rule_4" {
  source = "./security/security_group_rule/ip"

  aws_security_group_rule_cidr_blocks       = var.locked_down_ip_addresses
  aws_security_group_rule_description       = "Allows HTTP traffic inbound from ${join(", ", var.locked_down_ip_addresses)}"
  aws_security_group_rule_from_port         = 80
  aws_security_group_rule_protocol          = "tcp"
  aws_security_group_rule_security_group_id = module.security_group_alb.aws_security_group.id
  aws_security_group_rule_to_port           = 80
  aws_security_group_rule_type              = "ingress"
}

module "security_group_rule_5" {
  source = "./security/security_group_rule/ip"

  aws_security_group_rule_cidr_blocks       = var.locked_down_ip_addresses
  aws_security_group_rule_description       = "Allows HTTPS traffic inbound from ${join(", ", var.locked_down_ip_addresses)}"
  aws_security_group_rule_from_port         = 443
  aws_security_group_rule_protocol          = "tcp"
  aws_security_group_rule_security_group_id = module.security_group_alb.aws_security_group.id
  aws_security_group_rule_to_port           = 443
  aws_security_group_rule_type              = "ingress"
}

module "security_group_rule_6" {
  source = "./security/security_group_rule/sg"

  aws_security_group_rule_description              = "Allows HTTPS traffic inbound from ALB."
  aws_security_group_rule_from_port                = 0
  aws_security_group_rule_protocol                 = "-1"
  aws_security_group_rule_security_group_id        = module.security_group_alb.aws_security_group.id
  aws_security_group_rule_source_security_group_id = module.security_group_ec2_instances.aws_security_group.id
  aws_security_group_rule_to_port                  = 0
  aws_security_group_rule_type                     = "egress"
}

module "security_group_rule_7" {
  source = "./security/security_group_rule/sg"

  aws_security_group_rule_description              = "Allows TCP/3306 traffic inbound from ${module.security_group_ec2_instances.aws_security_group.name}."
  aws_security_group_rule_from_port                = 3306
  aws_security_group_rule_protocol                 = "tcp"
  aws_security_group_rule_security_group_id        = module.security_group_rds.aws_security_group.id
  aws_security_group_rule_source_security_group_id = module.security_group_ec2_instances.aws_security_group.id
  aws_security_group_rule_to_port                  = 3306
  aws_security_group_rule_type                     = "ingress"
}

module "security_group_rule_8" {
  source = "./security/security_group_rule/ip"

  aws_security_group_rule_cidr_blocks       = var.locked_down_ip_addresses
  aws_security_group_rule_description       = "Allows TCP/3306 traffic inbound from ${join(", ", var.locked_down_ip_addresses)}"
  aws_security_group_rule_from_port         = 3306
  aws_security_group_rule_protocol          = "tcp"
  aws_security_group_rule_security_group_id = module.security_group_rds.aws_security_group.id
  aws_security_group_rule_to_port           = 3306
  aws_security_group_rule_type              = "ingress"
}

module "security_group_rule_9" {
  source = "./security/security_group_rule/ip"

  aws_security_group_rule_cidr_blocks       = ["0.0.0.0/0"]
  aws_security_group_rule_description       = "Allows all traffic outbound to any IP address"
  aws_security_group_rule_from_port         = 0
  aws_security_group_rule_protocol          = "-1"
  aws_security_group_rule_security_group_id = module.security_group_rds.aws_security_group.id
  aws_security_group_rule_to_port           = 0
  aws_security_group_rule_type              = "egress"
}

module "s3_wordpress_code" {
  source = "./storage/s3"

  bucket_name = var.wordpress_code_bucket_name
  region      = var.wordpress_code_bucket_region
}

module "s3_wordpress_images" {
  source = "./storage/s3"

  bucket_name = var.wordpress_images_bucket_name
  region      = var.wordpress_images_bucket_region
}

module "cloudfront" {
  source = "./networking/cloudfront"

  image_bucket_name = module.s3_wordpress_images.s3.bucket_regional_domain_name
  origin_id         = "S3-${module.s3_wordpress_images.s3.bucket}"
  region            = "us-east-2"
}

module "rds" {
  source = "./storage/rds"

  rds_subnet_group_ids  = module.networking.private_subnets.*.id
  rds_engine_type       = "mysql"
  rds_engine_version    = "5.7"
  rds_security_group    = module.security_group_rds.aws_security_group.id
  username              = var.username
  password              = var.password
}

module "bucket_policy_images" {
  source = "./iam/s3_bucket_policy"


  s3_bucket = module.s3_wordpress_images.s3.id
  s3_bucket_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "s3:GetObject"
        ],
      "Resource": [
        "${module.s3_wordpress_images.s3.arn}/*"
        ]
    }
  ]
}
EOF
}

module "auto_scaling_group" {
  source = "./availability/auto_scaling_group"

  alb_target_group_arns                   = [module.application_load_balancer.alb.arn]
  aws_autoscaling_group_desired_capacity  = var.aws_autoscaling_group_desired_capacity
  aws_autoscaling_group_max_size          = var.aws_autoscaling_group_max_size
  aws_autoscaling_group_min_size          = var.aws_autoscaling_group_min_size
  aws_autoscaling_group_name              = var.aws_autoscaling_group_name
  aws_iam_instance_profile_name           = var.aws_iam_instance_profile_name
  aws_iam_policy_1_name                   = var.aws_iam_policy_1_name
  aws_iam_policy_2_name                   = var.aws_iam_policy_2_name
  aws_iam_role_name                       = var.aws_iam_role_name
  aws_launch_configuration_name           = var.aws_launch_configuration_name
  instance_type                           = var.instance_type
  instance_name                           = var.instance_name
  public_subnet_ids                       = module.networking.public_subnets.*.id
  security_group_id                       = module.security_group_ec2_instances.aws_security_group.id
  s3_wp_code_bucket_arn                   = module.s3_wordpress_code.s3.arn
  s3_wp_media_bucket_arn                  = module.s3_wordpress_images.s3.arn
}
//output "vpc" {
//  value = module.networking.vpc
//}
//
//output "subnets" {
//  value = module.networking.public_subnets.*.id
//}

//output "alb-sg" {
//  value = module.security_group_alb.aws_security_group.id
//}

output "public" {
  value = module.networking.public_subnets
}
output "rds" {
  value = module.rds.rds
}