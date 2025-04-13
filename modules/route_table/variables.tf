variable "vpc_id" {
  description = "VPC ID to create route tables"
  type        = string
}

variable "igw_id" {
  description = "Internet Gateway ID for public route"
  type        = string
}

variable "nat_gateway_id" {
  description = "NAT Gateway ID for private route"
  type        = string
}

variable "public_subnet_id_1" {
  description = "Public Subnet 1 ID"
  type        = string
}

variable "public_subnet_id_2" {
  description = "Public Subnet 2 ID"
  type        = string
}

variable "private_subnet_id_1" {
  description = "Private Subnet 1 ID"
  type        = string
}

variable "private_subnet_id_2" {
  description = "Private Subnet 2 ID"
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

variable "common_tags" {
  description = "Common tags for resources"
  type        = map(string)
}
