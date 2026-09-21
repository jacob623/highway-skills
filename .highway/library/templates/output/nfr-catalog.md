---
name: nfr-catalog
description: "Complete output skeleton for the repository Non-Functional Requirement catalog."
metadata:
  version: 1.0.0
---

## Catalog Structure

```markdown
# Non-Functional Requirements Catalog

Version: 1.0.0

Next ID: NFRXXXXXX

## NFR Index

| NFR ID | Title | Status |
|--------|-------|--------|
| NFRXXXXXX | <deterministic NFR title> | active |
```

The catalog owns the baseline version, next identifier, and NFR index. Entries are unique and
ordered by permanent NFR identifier; allocation state remains authoritative in the user-owned
catalog.
