output "db_name" {
  value = "aws_db_instance.postgres.name"
}


output "db_hostname" {
  description = "DB instance hostname"
  value       = aws_db_instance.postgres.address
  sensitive   = true
}

output "db_port" {
  description = "DB instance port"
  value       = aws_db_instance.postgres.port
  sensitive   = true
}

output "db_username" {
  description = "DB instance root username"
  value       = aws_db_instance.postgres.username
  sensitive   = true
}

output "db_password" {
  description = "DB instance root password"
  value       = aws_db_instance.postgres.password
  sensitive   = true
}

output "db_endpoint" {
  description = "DB endpoint"
  value       = aws_db_instance.postgres.endpoint
  sensitive   = true
}