variable "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group"
  type        = string
}

variable "scale_out_adjustment" {
  description = "Number of instances to add during scale-out"
  default     = 1
}

variable "scale_in_adjustment" {
  description = "Number of instances to remove during scale-in"
  default     = -1
}

variable "cpu_scale_out_threshold" {
  description = "CPU % to trigger scale-out"
  default     = 70
}

variable "cpu_scale_in_threshold" {
  description = "CPU % to trigger scale-in"
  default     = 30
}

variable "autoscaling_cooldown" {
  description = "Cooldown time between scaling actions"
  default     = 300
}
