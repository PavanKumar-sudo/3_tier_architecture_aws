output "app_instance_ids" {
  description = "IDs of App EC2 Instances"
  value       = aws_instance.app[*].id
}

output "app_private_ips" {
  description = "Private IPs of App EC2 Instances"
  value       = aws_instance.app[*].private_ip
}




#it will fetch private ip
# output "app_private_ip" {
#   description = "Private IP of the App Server"
#   value       = aws_instance.app[*].private_ip
# }
