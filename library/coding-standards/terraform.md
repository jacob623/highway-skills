# Terraform Coding Standard

## Scope

Terraform configuration in files matching `*.tf` and `*.tfvars`.

## Rules

1. Format every file with `terraform fmt` before it is saved.
2. Name resources, variables, and outputs in lowercase with underscores.
3. Give every variable a `type` and a `description`. Give every output a `description`.
4. Pin the Terraform version and every provider and module version.
5. Keep secrets out of code and out of `*.tfvars`. Read them from the platform's secret store.
6. Tag every resource that supports tags with its owner and the automation that created it.
7. Keep one concern per file: `main.tf`, `variables.tf`, `outputs.tf`, and `versions.tf`.

## Tests

Tests: required

Write one test file per configuration folder, named `<folder>.tftest.hcl`, in a `tests` folder beside the configuration. Each test runs `plan` and checks the values this automation depends on.
