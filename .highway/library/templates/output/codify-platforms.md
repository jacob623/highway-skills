---
name: codify-platforms
description: "Complete output skeleton for the platforms that can start automation."
metadata:
  version: 2.1.0
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

| Platform | Implementation ID | Kind | When to use | When not to use |
|---|---|---|---|---|
| <accepted implementation title> | <RI plus 8 hex digits> | <agent, pipeline, orchestrator, self-service, desired-state, or blank> | <entry; entry> | <entry; entry> |
```

The file is `library/coding-standards/codify-platforms.md`. It lists platforms that can start automation: a pipeline, an orchestrator, a self-service platform, a desired-state or GitOps tool, or an agent that starts the work. It is not a roster of every implementation. A store, a newsletter, a records product, or a backup has no row.

Every row comes from an accepted implementation. There is one row per Implementation ID.

Kind is `agent`, `pipeline`, `orchestrator`, `self-service`, `desired-state`, or blank. A row added by an implementation keeps Kind blank until the person configures it. GitOps is stored as `desired-state`.

When to use and When not to use each hold a list. Entries are separated by `; `. An empty list is a blank cell. A row added by an implementation has both cells blank until the person configures it. A proposal presents each list as an ordered list, one entry per item.

Rows stay in the order they were added. A blank Kind is not chosen as Deployed by or Managed by.

An empty catalog contains the frontmatter, the heading, and the table header, with no data rows. Do not write a placeholder row.
