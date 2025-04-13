output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_1_id" {
  value = module.public_subnet.public_subnet_1_id
}

output "public_subnet_2_id" {
  value = module.public_subnet.public_subnet_2_id
}

output "private_subnet_1_id" {
  value = module.private_subnet.private_subnet_1_id
}

output "private_subnet_2_id" {
  value = module.private_subnet.private_subnet_2_id
}

output "igw_id" {
  value = module.igw.igw_id
}

output "eip_id" {
  value = module.eip.eip_id
}

output "nat_gateway_id" {
  value = module.nat_gateway.nat_gateway_id
}

output "public_route_table_id" {
  value = module.route_table.public_route_table_id
}

output "private_route_table_id" {
  value = module.route_table.private_route_table_id
}

output "web_sg_id" {
  value = module.web_sg.web_sg_id
}

output "app_sg_id" {
  value = module.app_sg.app_sg_id
}

output "db_sg_id" {
  value = module.db_sg.db_sg_id
}


output "app_instance_ids" {
  value = module.app_ec2.app_instance_ids
}

output "app_private_ips" {
  value = module.app_ec2.app_private_ips
}

output "alb_dns_name" {
  description = "DNS name of the ALB to access from browser"
  value       = module.alb.alb_dns_name
}

output "alb_arn" {
  description = "ARN of the created ALB"
  value       = module.alb.alb_arn
}

output "web_asg_name" {
  description = "Web Auto Scaling Group Name"
  value       = module.web_asg.autoscaling_group_name
}

output "web_launch_template_id" {
  description = "Launch Template ID for Web instances"
  value       = module.web_asg.launch_template_id
}

output "rds_endpoint" {
  description = "RDS database endpoint"
  value       = module.db.rds_endpoint
}

output "db_username" {
  value     = var.db_username
  sensitive = true
}

output "db_password" {
  value     = var.db_password
  sensitive = true
}

output "db_name" {
  value     = var.db_name
}

output "key_name" {
  value = var.key_name
}

output "web_instance_name_prefix" {
  value = var.web_instance_name_prefix
}

# outputs.tf
output "table_name" {
  value = var.table_name
}

output "frontend_url" {
  value = "http://${module.alb.alb_dns_name}"
  description = "Access your frontend app using this URL"
}
