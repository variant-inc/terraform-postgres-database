resource "random_password" "role_password" {
  length  = 16
  special = false
}

resource "postgresql_role" "my_role" {
  provider = postgresql.this

  name            = var.role_name
  login           = true
  password        = random_password.role_password.result
  create_database = var.create_database
  #roles           = ["rds_iam"]
}

resource "postgresql_database" "my_db" {
  provider = postgresql.this
  count    = var.create_database ? 1 : 0

  name = var.database_name
}

resource "postgresql_grant" "read_all_tables" {
  provider = postgresql.this

  depends_on = [
    postgresql_database.my_db
  ]

  database    = var.database_name
  object_type = "table"
  privileges  = var.create_database ? ["ALL"] : ["SELECT"]
  role        = postgresql_role.my_role.name
  objects     = []
  schema      = "public"
}

resource "postgresql_extension" "my_extension" {
  provider = postgresql.this
  for_each = var.create_database ? toset([]) : toset(var.extensions)

  depends_on = [
    postgresql_database.my_db
  ]

  name     = each.key
  database = var.database_name
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_secretsmanager_secret" "database_credentials" {
  description = "${var.database_name} postgres database secret key."
  name        = "postgres-secret-${var.database_name}"
}

resource "aws_secretsmanager_secret_rotation" "database_credentials" {
  rotation_lambda_arn = "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:${var.cluster_name}-rds-key-rotation"
  secret_id           = aws_secretsmanager_secret.database_credentials.id

  rotation_rules {
    automatically_after_days = 30
  }
}

resource "aws_secretsmanager_secret_version" "database_credentials" {
  secret_id = aws_secretsmanager_secret.database_credentials.id
  secret_string = jsonencode({
    # Password will be rotated immediately upon creation
    "password" = random_password.role_password.result
    "dbname"   = var.database_name
    "username" = var.role_name
    "host"     = var.host
    "engine"   = "postgres"
  })

}