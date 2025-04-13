variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
}

variable "target_group_name" {
  description = "Name of the Target Group"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of Public Subnet IDs"
  type        = list(string)
}

variable "web_sg_id" {
  description = "Security Group ID for the Web servers"
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to all ALB resources"
  type        = map(string)
}

variable "health_check_path" {
  description = "Health check path"
  default     = "/"
}

variable "health_check_protocol" {
  description = "Health check protocol"
  default     = "HTTP"
}

variable "health_check_interval" {
  description = "Health check interval in seconds"
  default     = 30
}
