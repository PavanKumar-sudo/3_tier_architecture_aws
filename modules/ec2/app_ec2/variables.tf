variable "ami_id" {
  description = "AMI ID for App Servers"
  type        = string
}

variable "instance_type" {
  description = "EC2 Instance Type for App Servers"
  type        = string
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
}

variable "subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security Group ID to attach to App Servers"
  type        = string
}

variable "instance_name_prefix" {
  description = "Prefix for App Server instance names"
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to App Servers"
  type        = map(string)
}






//new code variables
 variable "repositry_files" {
  description = "GitHub repo URL for Backend Code"
  type        = string
}

variable "rds_endpoint" {
  description = "RDS Endpoint"
  type        = string
}

variable "db_username" {
  description = "Database Username"
  type        = string
}

variable "db_password" {
  description = "Database Password"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Database Name"
  type        = string
}

variable "table_name" {
  description = "Database Table Name"
  type        = string
}
