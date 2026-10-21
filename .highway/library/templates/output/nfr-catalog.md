---
name: nfr-catalog
description: "Complete output skeleton for the repository Non-Functional Requirement catalog."
metadata:
  version: 2.0.0
---

## Catalog Structure

```markdown
# Non-Functional Requirements Catalog

Version: 1.0.0

## NFR Index

| NFR ID | Title | Status |
|--------|-------|--------|
| <NFR plus 8 hex digits> | <accepted NFR title> | <active or removed> |
```

The catalog owns the baseline version and the NFR index. It has no `Next ID` field.

Each NFR ID appears once. Rows are ordered by NFR ID. The id is `NFR` plus the eight hex digits derived from the title.

`active` has a record at `library/governance/nfrs/<id>.md`. `removed` has no record file. A removed row stays in the index, keeps the title that last held that id, and leaves the id taken.

An empty baseline contains `Version: 1.0.0` and the index header, with no data rows. Do not write a placeholder id as a row.