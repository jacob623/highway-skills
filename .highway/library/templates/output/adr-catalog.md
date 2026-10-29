---
name: adr-catalog
description: "Complete output skeleton for the repository ADR catalog."
metadata:
  version: 3.0.0
---

## Catalog Structure

```markdown
# ADRs Catalog

Version: 1.0.0

## ADR Index

| ADR ID | Discovery ID | Request ID | ADR Title | ADR Path | Status |
|--------|--------------|------------|-----------|----------|--------|
| <ADR plus 8 hex digits> | <DISC plus 8 hex digits> | <REQ plus 8 hex digits> | <accepted decision title> | adrs/<ADR id>.md | <accepted, superseded, or removed> |
```

The catalog owns the baseline version and the ADR index. It has no `Next ID` field. The index columns are ADR ID, Discovery ID, Request ID, ADR Title, ADR Path, and Status.

Each ADR ID appears once. Rows are ordered by ADR ID. The ADR ID is `ADR` plus the eight hex digits derived from the title. Discovery ID is the Discovery this decision records. Each Discovery ID appears on at most one row.

`accepted` has a record at `adrs/<id>.md`. `superseded` has a record at `adrs/<id>.md` whose `superseded_by` names the replacing ADR, and its id stays taken. `removed` has no record file. A removed row stays in the index, keeps the title that last held that id, and leaves the id taken.

An empty baseline contains `Version: 1.0.0` and the index header, with no data rows. Do not write a placeholder id as a row.
