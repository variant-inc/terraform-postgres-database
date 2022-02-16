# Postgres Terraform Module

Terraform module which creates Database & User.

## Usage

```terraform
  source = "github.com/variant-inc/terraform-postgres-database?ref=master"
```

## Examples

Refer [examples](examples)

## Contributing

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=3.66.0 |
| <a name="requirement_postgresql"></a> [postgresql](#requirement\_postgresql) | >=1.14.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_postgresql.this"></a> [postgresql.this](#provider\_postgresql.this) | >=1.14.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [postgresql_database.my_db](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/database) | resource |
| [postgresql_extension.my_extension](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/extension) | resource |
| [postgresql_grant.read_all_tables](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/grant) | resource |
| [postgresql_role.my_role](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/role) | resource |
| [random_password.role_password](https://registry.terraform.io/providers/hashicorp/random/3.1.0/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_database"></a> [create\_database](#input\_create\_database) | Creates Database. If `false`, this creates a read only user | `bool` | `true` | no |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | Name of the database | `string` | n/a | yes |
| <a name="input_extensions"></a> [extensions](#input\_extensions) | Array of extensions | `list(string)` | `[]` | no |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | Name of the role | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_database"></a> [database](#output\_database) | Name of the Database |
| <a name="output_database_id"></a> [database\_id](#output\_database\_id) | Database Id |
| <a name="output_password"></a> [password](#output\_password) | Password of the User |
| <a name="output_user"></a> [user](#output\_user) | Name of the User |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
