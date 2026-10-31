---
name: adr-catalog
description: "Complete output skeleton for the repository ADR catalog."
metadata:
  version: 4.1.0
---

## Catalog Structure

```markdown
# ADRs Catalog

Version: 1.0.0

## ADR Index

| ADR ID | Discovery ID | Request ID | ADR Title | ADR Path | Architecture ID | Status |
|--------|--------------|------------|-----------|----------|-----------------|--------|
| <ADR plus 8 hex digits> | <DISC plus 8 hex digits> | <REQ plus 8 hex digits> | <accepted decision title> | adrs/<ADR id>.md | <RA plus 8 hex digits, RA11111111, RA22222222, or `None`> | <accepted, superseded, or removed> |
```

The catalog owns the baseline version and the ADR index. It has no `Next ID` field. The index columns are ADR ID, Discovery ID, Request ID, ADR Title, ADR Path, Architecture ID, and Status.

Each ADR ID appears once. Rows are ordered by ADR ID. The ADR ID is `ADR` plus the eight hex digits derived from the title. Discovery ID is the Discovery this decision records. Each Discovery ID appears on at most one row. Architecture ID is the one reference architecture this decision names, or `None` before that architecture exists. A decision that runs beside the current decision of several architectures lists every architecture it names, in id order, separated by a comma and a space. `None` means a new architecture will follow.

`accepted` has a record at `adrs/<id>.md`. `superseded` has a record at `adrs/<id>.md` whose `superseded_by` names the replacing ADR, and its id stays taken. `removed` has no record file. A removed row stays in the index, keeps the title that last held that id, and leaves the id taken.

An empty baseline contains `Version: 1.0.0` and the index header, with no data rows. Do not write a placeholder id as a row.
