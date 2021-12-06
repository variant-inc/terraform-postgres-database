output "database" {
  value       = module.postgres_role.database
  description = "Name of the Database"
}

output "user" {
  value       = module.postgres_role.user
  description = "Name of the User"
}

output "password" {
  value       = module.postgres_role.password
  sensitive   = true
  description = "Password of the User"
}
