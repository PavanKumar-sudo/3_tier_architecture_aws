variable "eip_name" {
  description = "Name tag for Elastic IP"
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to EIP"
  type        = map(string)
}
