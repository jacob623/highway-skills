---
name: discovery-catalog
description: "Complete output skeleton for the Discovery allocation catalog."
metadata:
  version: 1.0.0
---

## Catalog Structure

```markdown
# Discoveries Catalog

Version: 1.0.0

Next ID: DISCXXXXXX

## Discovery Index

| Discovery ID | Request ID | Discovery Title |
|--------------|------------|-----------------|
| DISCXXXXXX | REQXXXXXX | <deterministic discovery title> |
```

The catalog has no other top-level sections. `Next ID` is authoritative for allocation; entries
are unique and ordered by Discovery identifier.
