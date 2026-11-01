---
name: codify-platforms
description: "Complete output skeleton for the platforms that can start automation."
metadata:
  version: 1.0.0
---

## File Frontmatter

```yaml
---
name: codify-platforms
description: "Platforms that can start automation for this organization."
---
```

## Body

```markdown
# Codify Platforms

| Platform | Implementation ID | Source |
|---|---|---|
| <implementation title, or the name the person added> | <RI plus 8 hex digits, or None> | <implementation or own> |
```

The file lists platforms that can start automation: a pipeline, an orchestrator, a self-service platform, a desired-state or GitOps tool, or an agent that starts the work. It is not a roster of every implementation. A store, a newsletter, a records product, or a backup has no row.

`Source` is `implementation` when the row came from an accepted implementation, and `own` when the person added it. An `own` row has Implementation ID `None`. There is one row per Implementation ID. An `own` row is unique by Platform, compared without regard to case.

Rows stay in the order they were added. The first row is the default Provider when the person names none and the implementation being automated has no row.

An empty catalog contains the frontmatter, the heading, and the table header, with no data rows. Do not write a placeholder row.
