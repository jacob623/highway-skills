---
name: request-catalog
description: "Complete output skeleton for the repository request allocation catalog."
metadata:
  version: 1.0.0
---

## Catalog Structure

```markdown
# Requests Catalog

Version: 1.0.0

Next ID: REQXXXXXX

| ID | Title | Status |
|----|-------|--------|
| REQXXXXXX | <deterministic request title> | Proposed |
```

The placeholders represent user-owned request entries. The template governs the catalog version,
next identifier, and index columns; allocation state remains authoritative in the catalog file.
