---
name: clarification-catalog
description: "Complete output skeleton for the Clarification catalog."
metadata:
  version: 1.0.0
---

## Catalog Structure

```markdown
# Clarifications Catalog

Version: 1.0.0

## Clarification Index

| Clarification ID | Artifact ID | Artifact Type | Status | Clarification Path |
|------------------|-------------|---------------|--------|-------------------|
| CLAR-REQ000001 | REQ000001 | REQ | in-progress | requests/REQ000001-clarification.md |
```

The catalog contains one row for each clarification artifact. Rows are unique and ordered by
Artifact Type, then Artifact ID. Supported artifact types are `REQ`, `DISC`, `ADR`, and `RA`.
Supported statuses are `not-started`, `in-progress`, `complete`, and `blocked`.

Clarification Path is informational and resolves directly to the authoritative clarification artifact.
The catalog owns clarification lookup, artifact linkage, inventory, and status. Findings, responses,
revision history, clarification content, and analysis output remain in the clarification artifact.
