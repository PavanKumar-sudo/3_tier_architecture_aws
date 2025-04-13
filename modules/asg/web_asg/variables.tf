variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type for EC2 instances"
  type        = string
}

variable "key_name" {
  description = "SSH key name for EC2 access"
  type        = string
}

variable "security_group_id" {
  description = "Security group for the instances"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ASG to launch instances into"
  type        = list(string)
}

variable "common_tags" {
  description = "Common tags to apply"
  type        = map(string)
}

variable "instance_name_prefix" {
  description = "Prefix for instances and resources"
  type        = string
}

variable "min_size" {
  description = "Minimum number of instances"
  type        = number
}

variable "max_size" {
  description = "Maximum number of instances"
  type        = number
}

variable "desired_capacity" {
  description = "Desired number of instances"
  type        = number
}

variable "target_group_arns" {
  description = "Target group ARNs to attach instances for ALB health checks"
  type        = list(string)
}

variable "health_check_grace_period" {
  description = "Time in seconds before Auto Scaling Group checks instance health"
  type        = number
  default     = 300
}

 variable "repositry_files" {
  description = "GitHub repo URL for Frontend Code"
  type        = string
 }


variable "app_server_private_ip" {
  description = "Private IP address of App Server for reverse proxy"
  type        = string
}
