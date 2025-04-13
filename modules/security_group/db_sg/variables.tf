variable "vpc_id" {
  description = "VPC ID for DB Security Group"
  type        = string
}

variable "db_sg_name" {
  description = "Name for DB Security Group"
  type        = string
}

variable "app_sg_id" {
  description = "App Security Group ID allowed to access DB"
  type        = string
}

variable "db_port" {
  description = "Database Port (example 3306 for MySQL)"
  type        = number
}

variable "common_tags" {
  description = "Common tags to apply to DB SG"
  type        = map(string)
}
