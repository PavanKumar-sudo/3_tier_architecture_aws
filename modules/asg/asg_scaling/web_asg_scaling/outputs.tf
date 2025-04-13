output "scale_out_policy_arn" {
  description = "ARN of scale-out policy"
  value       = aws_autoscaling_policy.scale_out.arn
}

output "scale_in_policy_arn" {
  description = "ARN of scale-in policy"
  value       = aws_autoscaling_policy.scale_in.arn
}
