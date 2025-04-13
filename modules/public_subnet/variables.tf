variable "vpc_id" {
  description = "VPC ID for public subnets"
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

variable "availability_zone_1" {
  description = "First AZ for public subnet"
  type        = string
}

variable "availability_zone_2" {
  description = "Second AZ for public subnet"
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

variable "common_tags" {
  description = "Common tags to apply"
  type        = map(string)
}
