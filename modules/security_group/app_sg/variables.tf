variable "vpc_id" {
  description = "VPC ID for App Security Group"
  type        = string
}

variable "app_sg_name" {
  description = "Name for App Security Group"
  type        = string
}

variable "web_sg_id" {
  description = "Web Security Group ID allowed to access App"
  type        = string
}

variable "app_port" {
  description = "Application port (example 8080)"
  type        = number
}

variable "common_tags" {
  description = "Common tags to apply to App SG"
  type        = map(string)
}
