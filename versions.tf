terraform {
  required_version = ">=1.0.0"
  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = ">=1.14.0"

      configuration_aliases = [postgresql.this]
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, <6.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.1"
    }
  }
}
