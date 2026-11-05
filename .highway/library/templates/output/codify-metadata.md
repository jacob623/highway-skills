---
name: codify-metadata
description: "Complete output skeleton for the identity file of one product folder."
metadata:
  version: 1.0.0
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
```

The file is `code/<folder>/.highway/metadata.md`. It is written once, when the product is first accepted. `id` is the product's `CDY` id from `code/code.md`.

The product `.highway` holds `metadata.md` and `features/` only. It does not make the product folder a Highway project.
