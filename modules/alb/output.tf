output "alb_dns_name" {
  description = "The DNS name of the Load Balancer"
  value       = aws_lb.this.dns_name
}

output "alb_arn" {
  description = "The ARN of the Load Balancer"
  value       = aws_lb.this.arn
}

output "target_group_arn" {
  description = "Target Group ARN for ALB"
  value       = aws_lb_target_group.this.arn
}
