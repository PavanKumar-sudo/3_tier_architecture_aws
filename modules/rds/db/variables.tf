variable "subnet_ids" {
  description = "Private Subnet IDs for DB Subnet Group"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security Group ID for DB"
  type        = string
}

variable "db_subnet_group_name" {
  description = "Name of the DB Subnet Group"
  type        = string
}

variable "db_identifier" {
  description = "Identifier for the DB Instance"
  type        = string
}

variable "engine" {
  description = "Database engine (mysql or postgres)"
  type        = string
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
}

variable "instance_class" {
  description = "Database instance class"
  type        = string
}

variable "allocated_storage" {
  description = "Storage size in GB"
  type        = number
}

variable "db_name" {
  description = "Initial Database Name"
  type        = string
}

variable "username" {
  description = "Master Username"
  type        = string
}

variable "password" {
  description = "Master Password"
  type        = string
  sensitive   = true
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
}
