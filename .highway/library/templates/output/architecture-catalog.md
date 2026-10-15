---
name: architecture-catalog
description: "Complete output skeleton for the Reference Architecture allocation catalog."
metadata:
  version: 1.0.0
---

## Catalog Structure

```markdown
# Reference Architectures Catalog

Version: 1.0.0

Next ID: ARCHXXXXXX

## Architecture Index

| Architecture ID | ADR ID | Architecture Title | Architecture Path |
|-----------------|--------|--------------------|-------------------|
| ARCHXXXXXX | ADRXXXXXX | <deterministic architecture title> | architectures/ARCHXXXXXX.md |
```

The catalog owns the next unused permanent architecture identifier and one direct index entry per
successful architecture. Entries are unique and ordered by architecture identifier. An ADR may
appear at most once. A successful publication consumes the exact pre-write `Next ID`, adds one
entry, and advances `Next ID` exactly once.
