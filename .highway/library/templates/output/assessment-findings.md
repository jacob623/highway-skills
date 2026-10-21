---
name: assessment-findings
description: "Complete output skeleton for retained advisory findings."
metadata:
  version: 2.0.0
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
| ID | Category | Domain | Finding | Status | Disposition |
|---|---|---|---|---|---|
| <F plus 8 hex digits> | <Coverage, Consistency, Dependency, Opportunity, Reuse, or Risk> | <portfolio, architectures, or implementations> | <observation> | <Open, Accepted, or Dismissed> | <None or the person's disposition> |
```

The table contains one row per retained finding. It has no fingerprint column.

`ID` is `F` plus the eight hex digits derived from the observation. The same observation reuses that id. Rows are ordered by ID.

`Open` is written before the finding is shown. `Accepted` means the person saved the finding. `Dismissed` means the person discarded it. `Disposition` is `None` when the person has not stated one.

`revision` is a non-negative integer. It increments once after each successful write. A stale revision rejects the write and leaves the file unchanged.

An empty baseline contains the frontmatter, with `revision: 0`, and the table header, with no data rows. Do not write a placeholder id as a row.