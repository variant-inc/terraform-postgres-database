resource "random_password" "role_password" {
  length  = 16
  special = false
}

resource "postgresql_role" "my_role" {
  provider = postgresql.this

  depends_on = [
    postgresql_database.my_db
  ]

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
  for_each = var.create_database ? toset(var.extensions) : toset([])

  depends_on = [
    postgresql_database.my_db
  ]

  name     = each.key
  database = var.database_name
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

#tfsec:ignore:aws-ssm-secret-use-customer-key
resource "aws_secretsmanager_secret" "database_credentials" {
  #checkov:skip=CKV_AWS_149:Skip using KMS CMR
  description             = "${var.database_name} postgres database secret key."
  name                    = "postgres-secret-${replace(var.database_name, "_", "-")}"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_rotation" "database_credentials" {
  rotation_lambda_arn = "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:${var.cluster_name}-rds-key-rotation"
  secret_id           = aws_secretsmanager_secret.database_credentials.id

  rotate_immediately = false
  rotation_rules {
    automatically_after_days = 60
  }
  depends_on = [
    aws_secretsmanager_secret_version.database_credentials
  ]
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
    "email"    = var.email
  })
  lifecycle {
    ignore_changes = [secret_string]
  }
}

resource "aws_ssm_parameter" "permissions" {
  #checkov:skip=CKV_AWS_337:Skip using KMS CMR
  name        = "postgres-${var.database_name}-${var.role_name}"
  description = "Postgres permissons for ${var.database_name} database and ${var.role_name} role"
  type        = "SecureString"
  value = jsonencode({
    privileges = var.create_database ? ["ALL"] : ["SELECT"],
    email      = var.email
  })

}
