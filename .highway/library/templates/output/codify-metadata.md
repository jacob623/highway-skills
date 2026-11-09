---
name: codify-metadata
description: "Complete output skeleton for the identity and feature index of one product folder."
metadata:
  version: 2.0.0
---

## File Frontmatter

```yaml
---
id: CDYXXXXXX
---
```

## Body

```markdown
# <product title>

## Features

| ID | Folder | Title | Summary |
|----|--------|-------|---------|
| <three-digit feature number> | <number>-<action> | <automation title> | <one sentence> |
```

The file is `code/<folder>/.highway/metadata.md`. It is written when the product is first accepted, and each later accepted feature adds one Features row. `id` is the product's `CDY` id from `code/code.md`.

Features lists one row per accepted feature, in acceptance order. ID is the three-digit feature number, `001` for the first feature. Folder is the feature folder name under `.highway/features/`. Title is the title of that feature's `codify.md`. Summary is that record's Summary sentence. Title and Summary are copied when the feature is accepted.

A row is appended and never removed or changed, so an ID is never reused. The next feature number is the next integer after the last ID. Features has no status column. Progress stays in `codify-tasks.md`.

The product `.highway` holds `metadata.md` and `features/` only. It does not make the product folder a Highway project.
