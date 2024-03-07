variable "create_database" {
  type        = bool
  description = "Creates Database. If `false`, this creates a read only user"
  default     = true
}

variable "database_name" {
  type        = string
  description = "Name of the database"
}

variable "reference" {
  type        = string
  description = "Reference string for forming environment variable in DX"
  default     = ""
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

variable "cluster_name" {
  type        = string
  description = "Name of the cluster"
}

variable "host" {
  type        = string
  description = "Host of database"
}

variable "email" {
  type        = string
  description = "Email of user"
}
