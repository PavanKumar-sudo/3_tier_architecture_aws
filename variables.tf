variable "aws_region" {
  description = "AWS Region for resources"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "vpc_name" {
  description = "Name tag for the VPC"
  type        = string
}

variable "public_subnet_cidr_1" {
  description = "CIDR block for public subnet 1"
  type        = string
}

variable "public_subnet_cidr_2" {
  description = "CIDR block for public subnet 2"
  type        = string
}

variable "private_subnet_cidr_1" {
  description = "CIDR block for private subnet 1"
  type        = string
}

variable "private_subnet_cidr_2" {
  description = "CIDR block for private subnet 2"
  type        = string
}

variable "availability_zone_1" {
  description = "First availability zone"
  type        = string
}

variable "availability_zone_2" {
  description = "Second availability zone"
  type        = string
}

variable "public_subnet_1_name" {
  description = "Name tag for public subnet 1"
  type        = string
}

variable "public_subnet_2_name" {
  description = "Name tag for public subnet 2"
  type        = string
}

variable "private_subnet_1_name" {
  description = "Name tag for private subnet 1"
  type        = string
}

variable "private_subnet_2_name" {
  description = "Name tag for private subnet 2"
  type        = string
}

variable "igw_name" {
  description = "Name tag for Internet Gateway"
  type        = string
}

variable "eip_name" {
  description = "Name tag for Elastic IP"
  type        = string
}

variable "nat_gateway_name" {
  description = "Name tag for NAT Gateway"
  type        = string
}

variable "public_route_table_name" {
  description = "Name for Public Route Table"
  type        = string
}

variable "private_route_table_name" {
  description = "Name for Private Route Table"
  type        = string
}

variable "web_sg_name" {
  description = "Name for Web Security Group"
  type        = string
}

variable "app_sg_name" {
  description = "Name for App Security Group"
  type        = string
}

variable "app_port" {
  description = "Application port for App Security Group"
  type        = number
}

variable "db_sg_name" {
  description = "Name for DB Security Group"
  type        = string
}

variable "db_port" {
  description = "Database port for DB Security Group"
  type        = number
}


variable "web_ami_id" {
  description = "AMI ID for Web EC2 instances"
  type        = string
}

variable "web_instance_type" {
  description = "Instance type for Web EC2 instances"
  type        = string
}

variable "web_instance_name_prefix" {
  description = "Prefix for Web Server EC2 instance names"
  type        = string
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
}

variable "app_ami_id" {
  description = "AMI ID for App EC2 instances"
  type        = string
}

variable "app_instance_type" {
  description = "Instance type for App EC2 instances"
  type        = string
}

variable "app_instance_name_prefix" {
  description = "Prefix for App Server EC2 instance names"
  type        = string
}

variable "db_subnet_group_name" {
  description = "Name for the RDS DB Subnet Group"
  type        = string
}

variable "db_identifier" {
  description = "Unique identifier for the RDS DB instance"
  type        = string
}

variable "db_engine" {
  description = "Database engine type (e.g., mysql, postgres)"
  type        = string
}

variable "db_engine_version" {
  description = "Version of the database engine (e.g., 8.0 for MySQL)"
  type        = string
}

variable "db_instance_class" {
  description = "Instance type for the RDS DB (e.g., db.t2.micro)"
  type        = string
}

variable "db_allocated_storage" {
  description = "Storage size allocated to the RDS DB (in GB)"
  type        = number
}

variable "db_name" {
  description = "Name of the initial database to create inside RDS"
  type        = string
}

variable "db_username" {
  description = "Master username for the RDS DB instance"
  type        = string
}

variable "db_password" {
  description = "Master password for the RDS DB instance"
  type        = string
  sensitive   = true
}

# Add these new variables
variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
}

variable "target_group_name" {
  description = "Name of the Target Group for the ALB"
  type        = string
}

variable "web_min_size" {
  description = "Minimum number of Web instances in ASG"
  type        = number
}

variable "web_max_size" {
  description = "Maximum number of Web instances in ASG"
  type        = number
}

variable "web_desired_capacity" {
  description = "Desired number of Web instances in ASG"
  type        = number
}

variable "web_health_check_grace_period" {
  description = "Grace period (seconds) for Web Tier Auto Scaling Group to start health checking"
  type        = number
  default     = 300
}

variable "table_name" {
  description = "Name of the RDS table"
  type        = string
}

variable "scale_out_adjustment" {
  description = "Instances to add when scaling out"
  default     = 1
}

variable "scale_in_adjustment" {
  description = "Instances to remove when scaling in"
  default     = -1
}

variable "cpu_scale_out_threshold" {
  description = "CPU % above which scaling out happens"
  default     = 70
}

variable "cpu_scale_in_threshold" {
  description = "CPU % below which scaling in happens"
  default     = 30
}

variable "autoscaling_cooldown" {
  description = "Cooldown time between scaling actions (seconds)"
  default     = 300
}



variable "repositry_file" {
  description = "GitHub URL for Backend Code"
  type        = string
}
