---
name: implementation-catalog
description: "Complete output skeleton for the repository Reference Implementation catalog."
metadata:
  version: 3.0.0
---

## Catalog Structure

```markdown
# Reference Implementations Catalog

Version: 1.0.0

## Implementation Index

| Implementation ID | Architecture ID | Implementation Title | Implementation Path | Status |
|-------------------|-----------------|----------------------|---------------------|--------|
| <RI plus 8 hex digits> | <RA plus 8 hex digits> | <implementation title> | implementations/<RI id>.md | <accepted or removed> |
```

The catalog owns the baseline version and the implementation index. It has no `Next ID` field. The index columns are Implementation ID, Architecture ID, Implementation Title, Implementation Path, and Status.

Each Implementation ID appears once. Rows are ordered by Implementation ID. The Implementation ID is `RI` plus the eight hex digits derived from the title. Architecture ID is the accepted Reference Architecture this implementation realizes. More than one row may name the same Architecture ID. A removed row does not count as a current implementation.

`accepted` has a record at `implementations/<id>.md`. `removed` has no record file. A removed row stays in the index, keeps the title that last held that id, and leaves the id taken.

An empty baseline contains `Version: 1.0.0` and the index header, with no data rows. Do not write a placeholder id as a row.
