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
