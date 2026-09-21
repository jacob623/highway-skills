---
name: objective-catalog
description: "Complete output skeleton for the Business Objective baseline catalog."
metadata:
  version: 1.0.0
---

## Catalog Structure

```markdown
# Business Objectives Catalog

Version: 1.0.0

Next ID: OBJXXXXXX

## Objective Index

| Objective ID | Title | Status |
|--------------|-------|--------|
| OBJXXXXXX | <deterministic objective title> | active |
```

The catalog owns the baseline version, next identifier, and objective index. Entries are unique
and ordered by permanent Objective identifier; allocation state remains authoritative in the
user-owned catalog.
