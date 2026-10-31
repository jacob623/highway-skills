---
name: architecture-catalog
description: "Complete output skeleton for the repository Reference Architecture catalog."
metadata:
  version: 3.0.0
---

## Catalog Structure

```markdown
# Reference Architectures Catalog

Version: 1.0.0

## Architecture Index

| Architecture ID | ADR ID | Architecture Title | Architecture Path | Status |
|-----------------|--------|--------------------|------------------|--------|
| <RA plus 8 hex digits> | <ADR11111111, ADR22222222> | <architecture title> | architectures/<RA id>.md | <accepted or removed> |
```

The catalog owns the baseline version and the architecture index. It has no `Next ID` field. The index columns are Architecture ID, ADR ID, Architecture Title, Architecture Path, and Status.

Each Architecture ID appears once. Rows are ordered by Architecture ID. The Architecture ID is `RA` plus the eight hex digits derived from the title. The ADR ID cell lists every current decision that names this architecture, in id order, separated by a comma and a space. One id is used when only one current decision names it. An ADR id appears on at most one row. A superseded or removed decision is not in that cell.

`accepted` has a record at `architectures/<id>.md`. `removed` has no record file. A removed row stays in the index, keeps the title that last held that id, and leaves the id taken.

An empty baseline contains `Version: 1.0.0` and the index header, with no data rows. Do not write a placeholder id as a row.
