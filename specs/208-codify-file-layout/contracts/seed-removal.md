# Contract: Seed Removal

- The repository has no `library/coding-standards/coding-standards.md` and no `library/coding-standards/terraform.md`.
- `.highway/tools/.distribution-manifest` has no `include library/coding-standards` line. It keeps `exclude library`.
- With no catalog, `highway-codify-config` option 2 says no coding standard is listed yet. The first accepted standard writes its file, then creates the catalog with one row.
- With no catalog, `highway-codify` gives every task `No coding standard applies.` and writes no catalog or standard.
