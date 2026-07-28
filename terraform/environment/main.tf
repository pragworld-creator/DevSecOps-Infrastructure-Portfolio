locals {
  env           = terraform.workspace
  instance_type = local.env == "prod" ? "t3.large" : "t3.micro"
  capacity      = local.env == "prod" ? 4 : 2
}


module "networking" {
  source      = "../modules/networking"
  environment = local.env
  vpc_cidr    = "10.0.0.0/16"

  public_subnet  = { "eu-west-1a" = "10.0.1.0/24", "eu-west-1b" = "10.0.2.0/24" }
  private_subnet = { "eu-west-1a" = "10.0.3.0/24", "eu-west-1b" = "10.0.4.0/24" }

  database_subnet = { "eu-west-1a" = "10.0.5.0/24", "eu-west-1b" = "10.0.6.0/24" }
}

module "security" {
  source      = "../modules/security"
  environment = local.env
  vpc_id      = module.networking.vpc_id
}

module "compute" {
  source                    = "../modules/compute"
  environment               = local.env
  vpc_id                    = module.networking.vpc_id
  public_subnet_ids         = module.networking.public_subnet_ids
  private_subnet_ids        = module.networking.private_subnet_ids
  alb_sg_id                 = module.security.alb_sg_id
  ec2_sg_id                 = module.security.ec2_sg_id
  iam_instance_profile_name = module.security.iam_instance_profile_name
  instance_type             = local.instance_type
  asg_desired_capacity      = local.capacity

  depends_on = [module.networking]
}

module "database" {
  source               = "../modules/database"
  environment          = local.env
  db_subnet_group_name = module.networking.db_subnet_group_name
  rds_sg_ids           = [module.security.rds_sg_id]
  db_password          = var.db_password
}