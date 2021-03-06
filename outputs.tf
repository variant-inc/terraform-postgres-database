output "database" {
  value       = var.database_name
  description = "Name of the Database"
}

output "user" {
  value       = var.role_name
  description = "Name of the User"
}

output "password" {
  value       = random_password.role_password.result
  sensitive   = true
  description = "Password of the User"
}

output "secret_id" {
  value       = aws_secretsmanager_secret.database_credentials.id
  description = "ID of Secret in SecretsManager"
}