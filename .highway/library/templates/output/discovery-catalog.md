---
name: discovery-catalog
description: "Complete output skeleton for the repository Discovery catalog."
metadata:
  version: 2.0.0
---

## Catalog Structure

```markdown
# Discoveries Catalog

Version: 1.0.0

## Discovery Index

| Discovery ID | Request ID | Discovery Title | Status |
|--------------|------------|-----------------|--------|
| <DISC plus 8 hex digits> | <REQ plus 8 hex digits> | <discovery title> | <accepted or removed> |
```

The catalog owns the baseline version and the Discovery index. It has no `Next ID` field. The index columns are Discovery ID, Request ID, Discovery Title, and Status.

Each Discovery ID appears once. Rows are ordered by Discovery ID. The Discovery ID is `DISC` plus the eight hex digits derived from the title. Request ID is the completed Request this Discovery analyzes.

`accepted` has a record at `discoveries/<id>.md`. `removed` has no record file. A removed row stays in the index, keeps the title that last held that id, and leaves the id taken.

An empty baseline contains `Version: 1.0.0` and the index header, with no data rows. Do not write a placeholder id as a row.
