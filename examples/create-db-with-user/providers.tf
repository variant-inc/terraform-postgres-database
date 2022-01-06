provider "postgresql" {
  host            = "${var.cluster_name}.rds.${var.domain}"
  username        = local.creds["username"]
  password        = local.creds["password"]
  connect_timeout = 30
  superuser       = false
}

provider "aws" {}
