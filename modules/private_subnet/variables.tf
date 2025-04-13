variable "vpc_id" {
  description = "VPC ID for private subnets"
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
  description = "First AZ for private subnet"
  type        = string
}

variable "availability_zone_2" {
  description = "Second AZ for private subnet"
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

variable "common_tags" {
  description = "Common tags to apply"
  type        = map(string)
}
