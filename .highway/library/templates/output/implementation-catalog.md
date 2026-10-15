---
name: implementation-catalog
description: "Complete output skeleton for the Reference Implementation allocation catalog."
metadata:
  version: 1.0.0
---

## Catalog Structure

```markdown
# Reference Implementations Catalog

Version: 1.0.0

Next ID: RIXXXXXX

## Implementation Index

| Implementation ID | Architecture ID | Implementation Title | Implementation Path |
|-------------------|------------------|----------------------|---------------------|
| RIXXXXXX | ARCHXXXXXX | <deterministic implementation title> | implementations/RIXXXXXX.md |
```

The catalog owns the next unused permanent implementation identifier, one direct index entry per
successful implementation, and architecture uniqueness. Entries are unique and ordered by
implementation identifier. An accepted architecture may appear at most once. A successful
publication consumes the exact pre-write `Next ID`, adds one entry, and advances `Next ID` exactly
once.
