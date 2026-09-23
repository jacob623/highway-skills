---
name: adr-catalog
description: "Complete output skeleton for the ADR allocation catalog."
metadata:
  version: 1.0.0
---

## Catalog Structure

```markdown
# ADRs Catalog

Version: 1.0.0

Next ID: ADRXXXXXX

## ADR Index

| ADR ID | Discovery ID | Request ID | ADR Title | ADR Path |
|--------|--------------|------------|-----------|----------|
| ADRXXXXXX | DISCXXXXXX | REQXXXXXX | <deterministic ADR title> | adrs/ADRXXXXXX.md |
```

The catalog owns the next ADR identifier and one direct index entry per successful ADR. Entries are
unique and ordered by ADR identifier. Discovery identifier uniqueness is checked before allocation.