variable "vpc_id" {
  description = "VPC ID for Web Security Group"
  type        = string
}

variable "web_sg_name" {
  description = "Name for Web Security Group"
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to Web SG"
  type        = map(string)
}
