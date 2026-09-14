# ceng-azure-organization-alz-naming

Provider-free Terraform module for consistent Azure Landing Zone resource names and identifiers.

The output keys preserve the custom naming contract from the US SLED ALZ hub-and-spoke example. The deployment pipeline selects a workspace and its matching tfvars file; that file supplies the semantic `environment` value to this module. The module does not inspect Terraform workspace names or filenames.

By default, QA, `non-prod`, production, and `prod` omit the environment infix. Any other environment automatically uses `-${environment}`, so DEV uses `-dev` and a sandbox environment uses `-sandbox`. Use `environment_infixes` to override a specific environment or `environments_without_infix` to customize the omission set.

```hcl
module "alz_naming" {
  source = "git::ssh://git@github.com/vbalbarin/alz-naming-module.git?ref=v1.0.0"

  environment = "dev"
  location    = "westus"
}
```

Use `name_overrides` for an existing resource or Azure-specific exception. Overrides are final names rather than templates.