data "aws_secretsmanager_secret_version" "database" {
  secret_id = "${var.cluster_name}-rds-creds"
}

locals {
  creds = jsondecode(data.aws_secretsmanager_secret_version.database.secret_string)
}

module "postgres_role" {
  source = "../../"

  providers = {
    postgresql.this = postgresql
  }

  create_database = true
  database_name   = var.database_name
  role_name       = var.role_name
}
