output "rds_endpoint" {
  description = "RDS Database Endpoint"
  value       = aws_db_instance.this.address
}

output "db_instance_id" {
  description = "RDS Database Instance ID"
  value       = aws_db_instance.this.id
}
