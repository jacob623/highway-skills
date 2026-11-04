---
name: coding-standards-catalog
description: "Complete output skeleton for the coding standards catalog."
metadata:
  version: 1.0.0
---

## Body

```markdown
# Coding Standards

The organization maintains this folder. Each standard covers one language or platform, and each row below names one standard file in this folder.

| Standard Title | Technology | File Patterns | Summary | When to use | When not to use | Inherits From | Standard Path |
|---|---|---|---|---|---|---|---|
| <language or platform> Coding Standard | <language or platform> | <`*.ext`, `*.ext`> | <one sentence> | <entry; entry> | <entry; entry> | <Standard Title; Standard Title> | `library/coding-standards/<file>.md` |

Adding a standard adds one row and changes no other row.
```

The file is `library/coding-standards/coding-standards.md`. Standard Title names the language, such as Java or YAML, or the platform, such as Kubernetes or Terraform, followed by `Coding Standard`.

When to use, When not to use, and Inherits From each hold a list. Entries are separated by `; `. An empty list is a blank cell. Inherits From names the Standard Titles a standard builds on. A proposal presents each list as an ordered list, one entry per item.

Removing a row leaves its standard file in place. A standard file that no row names is not used.
