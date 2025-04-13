variable "eip_allocation_id" {
  description = "Elastic IP Allocation ID for NAT Gateway"
  type        = string
}

variable "public_subnet_id" {
  description = "Public Subnet ID where NAT Gateway will be created"
  type        = string
}

variable "nat_gateway_name" {
  description = "Name tag for NAT Gateway"
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply"
  type        = map(string)
}
