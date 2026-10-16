---
name: assessment-findings
description: "Complete output skeleton for retained advisory findings."
metadata:
  version: 1.0.0
---

## File Frontmatter

```yaml
---
name: assessment-findings
description: "Retained advisory findings produced by the assessment workflow."
metadata:
  version: 1.0.0
revision: 0
---
```

## Findings Table

```markdown
| ID | Category | Domain | Finding | Fingerprint | Status | Disposition |
|---|---|---|---|---|---|---|
```

The table contains one row per retained finding. `ID` is a sequential zero-padded `F###` display
identifier. `Fingerprint` is the deterministic equivalence key. `Status` is `Open`, `Accepted`,
`Dismissed`, `Resolved`, or `Superseded`; `Disposition` is `None` when no review disposition exists.
The non-negative `revision` increments once after each successful mutation. A stale revision rejects
the complete mutation without writing.
