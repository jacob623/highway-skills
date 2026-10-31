# Contract: Coding Standards

## Folder

`library/coding-standards/` at the repository root holds `coding-standards.md` and one file per standard. Highway ships the catalog with one row and `terraform.md`. The distribution manifest includes `library/coding-standards`.

## Catalog

`coding-standards.md` opens with one sentence saying the organization maintains the folder and each standard covers one technology. It then has one table:

| Standard Title | Technology | File Patterns | Summary | Standard Path |
|---|---|---|---|---|
| Terraform Coding Standard | Terraform | `*.tf`, `*.tfvars` | One sentence. | `library/coding-standards/terraform.md` |

Adding a standard adds one row and changes no other row.

## Standard

Each standard has `# <Technology> Coding Standard`, `## Scope`, `## Rules`, and `## Tests`. The first line under `## Tests` is `Tests: required` or `Tests: not required`.

## Codify reads, never writes

`highway-codify` reads the catalog and each standard a task names. It does not create, edit, or remove a standard or a catalog row.

## Missing pieces

| Condition | Result |
|---|---|
| No catalog | Every task says `No coding standard applies.` The close says no catalog was found |
| A row's file is absent | Its files say `No coding standard applies.` The close names the path |
| Two rows for one technology | The first row applies. The close names the duplicate |
