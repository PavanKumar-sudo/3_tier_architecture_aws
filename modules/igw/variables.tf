variable "vpc_id" {
  description = "VPC ID to attach the Internet Gateway"
  type        = string
}

variable "igw_name" {
  description = "Name of the Internet Gateway"
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply"
  type        = map(string)
}