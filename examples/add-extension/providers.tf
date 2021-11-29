provider "postgresql" {
  host             = "${var.cluster_name}.rds.${var.domain}"
  username         = local.creds["username"]
  password         = local.creds["password"]
  connect_timeout  = 30
  expected_version = local.db_engine_version
  superuser        = false
}

provider "aws" {}
