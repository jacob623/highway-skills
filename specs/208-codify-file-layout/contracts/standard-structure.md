# Contract: Standard Structure

The standard proposal in `highway-codify-config` gains one field, placed after **File Patterns:**:

```markdown
**File and Folder Structure:**
1. `terraform/modules/<module>/main.tf`
2. `terraform/modules/<module>/variables.tf`
3. `terraform/modules/<module>/tests/<module>.tftest.hcl`

**Tests:** required. Each module has a plan test that checks the values the automation depends on. Test path: `terraform/modules/<module>/tests/<module>.tftest.hcl`
```

`accept` writes nothing and says what is needed when:

- the structure is empty: `A file and folder structure is needed.`
- a path begins with `/` or `code/`: `Paths are relative to the automation folder.`
- tests are required and the test path is not in the structure: `The test path must be part of the file and folder structure.`

The standard file stores the structure under `## File and Folder Structure`, and the test path under `## Tests`.
