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
  roles           = ["rds_iam"]
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

# Rotating secret START #
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_secretsmanager_secret" "database_credentials" {
  #Will Default:
  #kms_key_id  = var.kms_key_id

  description = "${var.database_name} database secret key."
  name = "${var.database_name}-postgres-secret"
}

resource "aws_secretsmanager_secret_rotation" "database_credentials" {
  rotation_lambda_arn = "arn:aws:lambda:${data.aws-region.current}:${data.aws_caller_identity.current}:function:rds_key_rotation"
  secret_id           = aws_secretsmanager_secret.database_credentials.id

  rotation_rules {
    automatically_after_days = 30 #var.rotation_interval
  }
}

resource "aws_secretsmanager_secret_version" "database_credentials" {
  secret_id     = aws_secretsmanager_secret.database_credentials.id
  secret_string = jsonencode({
    "password" = random_password.role_password.result # Password will be rotated immediately upon creation

  })

  lifecycle {
    ignore_changes = [
      # Ignore changes to the credential info. After creation, any changes to
      # non-password fields should be made through the console to avoid issues
      # with Terraform resetting the password on the secret but not updating the
      # password on RDS.
      secret_string,
    ]
  }
}

# Rotating Secret END #