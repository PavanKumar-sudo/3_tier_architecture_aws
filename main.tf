module "vpc" {
  source = "./modules/vpc"

  vpc_cidr_block = var.vpc_cidr_block
  vpc_name       = var.vpc_name
  common_tags    = local.common_tags
}

module "public_subnet" {
  source = "./modules/public_subnet"

  vpc_id               = module.vpc.vpc_id
  public_subnet_cidr_1 = var.public_subnet_cidr_1
  public_subnet_cidr_2 = var.public_subnet_cidr_2
  availability_zone_1  = var.availability_zone_1
  availability_zone_2  = var.availability_zone_2
  public_subnet_1_name = var.public_subnet_1_name
  public_subnet_2_name = var.public_subnet_2_name
  common_tags          = local.common_tags
}

module "private_subnet" {
  source = "./modules/private_subnet"

  vpc_id                = module.vpc.vpc_id
  private_subnet_cidr_1 = var.private_subnet_cidr_1
  private_subnet_cidr_2 = var.private_subnet_cidr_2
  availability_zone_1   = var.availability_zone_1
  availability_zone_2   = var.availability_zone_2
  private_subnet_1_name = var.private_subnet_1_name
  private_subnet_2_name = var.private_subnet_2_name
  common_tags           = local.common_tags
}

module "igw" {
  source = "./modules/igw"

  vpc_id      = module.vpc.vpc_id
  igw_name    = var.igw_name
  common_tags = local.common_tags
}

module "eip" {
  source = "./modules/eip"

  eip_name    = var.eip_name
  common_tags = local.common_tags
}

module "nat_gateway" {
  source = "./modules/nat_gateway"

  eip_allocation_id = module.eip.eip_allocation_id
  public_subnet_id  = module.public_subnet.public_subnet_1_id
  nat_gateway_name  = var.nat_gateway_name
  common_tags       = local.common_tags
}

module "route_table" {
  source = "./modules/route_table"

  vpc_id         = module.vpc.vpc_id
  igw_id         = module.igw.igw_id
  nat_gateway_id = module.nat_gateway.nat_gateway_id

  public_subnet_id_1  = module.public_subnet.public_subnet_1_id
  public_subnet_id_2  = module.public_subnet.public_subnet_2_id
  private_subnet_id_1 = module.private_subnet.private_subnet_1_id
  private_subnet_id_2 = module.private_subnet.private_subnet_2_id

  public_route_table_name  = var.public_route_table_name
  private_route_table_name = var.private_route_table_name
  common_tags              = local.common_tags
}

module "web_sg" {
  source = "./modules/security_group/web_sg"

  vpc_id      = module.vpc.vpc_id
  web_sg_name = var.web_sg_name
  common_tags = local.common_tags
}

module "app_sg" {
  source = "./modules/security_group/app_sg"

  vpc_id      = module.vpc.vpc_id
  app_sg_name = var.app_sg_name
  web_sg_id   = module.web_sg.web_sg_id
  app_port    = var.app_port
  common_tags = local.common_tags

}

module "db_sg" {
  source = "./modules/security_group/db_sg"

  vpc_id      = module.vpc.vpc_id
  db_sg_name  = var.db_sg_name
  app_sg_id   = module.app_sg.app_sg_id
  db_port     = var.db_port
  common_tags = local.common_tags
}

module "app_ec2" {
  source = "./modules/ec2/app_ec2"

  ami_id               = var.app_ami_id
  instance_type        = var.app_instance_type
  key_name             = var.key_name
  subnet_ids           = [module.private_subnet.private_subnet_1_id, module.private_subnet.private_subnet_2_id]
  security_group_id    = module.app_sg.app_sg_id
  instance_name_prefix = var.app_instance_name_prefix

  repositry_files = var.repositry_file
  rds_endpoint         = module.db.rds_endpoint
  db_username          = var.db_username
  db_password          = var.db_password
  db_name              = var.db_name
  table_name           = var.table_name

  common_tags          = local.common_tags
}

module "db" {
  source = "./modules/rds/db"

  subnet_ids           = [module.private_subnet.private_subnet_1_id, module.private_subnet.private_subnet_2_id]
  security_group_id    = module.db_sg.db_sg_id
  db_subnet_group_name = var.db_subnet_group_name
  db_identifier        = var.db_identifier
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  instance_class       = var.db_instance_class
  allocated_storage    = var.db_allocated_storage
  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password
  common_tags          = local.common_tags
}

module "alb" {
  source            = "./modules/alb"
  alb_name          = var.alb_name
  target_group_name = var.target_group_name
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = [module.public_subnet.public_subnet_1_id, module.public_subnet.public_subnet_2_id]
  web_sg_id         = module.web_sg.web_sg_id
  common_tags       = local.common_tags  
}

module "web_asg" {
  source = "./modules/asg/web_asg"

  ami_id               = var.web_ami_id
  instance_type        = var.web_instance_type
  key_name             = var.key_name
  security_group_id    = module.web_sg.web_sg_id
  subnet_ids           = [module.public_subnet.public_subnet_1_id, module.public_subnet.public_subnet_2_id]
  instance_name_prefix = var.web_instance_name_prefix

  min_size             = var.web_min_size
  max_size             = var.web_max_size
  desired_capacity     = var.web_desired_capacity

  target_group_arns    = [module.alb.target_group_arn]
  common_tags          = local.common_tags
  health_check_grace_period = var.web_health_check_grace_period

  repositry_files = var.repositry_file
  app_server_private_ip = module.app_ec2.app_private_ips[0]    # ✅ New line added

}

module "web_asg_scaling" {
  source = "./modules/asg/asg_scaling/web_asg_scaling"

  autoscaling_group_name = module.web_asg.autoscaling_group_name

  # Optional overrides (if values provided via tfvars)
  scale_out_adjustment    = var.scale_out_adjustment
  scale_in_adjustment     = var.scale_in_adjustment
  cpu_scale_out_threshold = var.cpu_scale_out_threshold
  cpu_scale_in_threshold  = var.cpu_scale_in_threshold
  autoscaling_cooldown    = var.autoscaling_cooldown
}


