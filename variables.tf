variable "create_database" {
  type        = bool
  description = "Creates Database. If false, this creates a read only user"
  default     = true
}

variable "database_name" {
  type        = string
  description = "Name of the database"
}

variable "role_name" {
  type        = string
  description = "Name of the role"
}

variable "extensions" {
  type        = list(string)
  description = "Array of extensions"
  default     = []
}
