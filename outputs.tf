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
