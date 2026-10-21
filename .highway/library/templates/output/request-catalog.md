---
name: request-catalog
description: "Complete output skeleton for the repository request catalog."
metadata:
  version: 2.0.0
---

## Catalog Structure

```markdown
# Requests Catalog

Version: 1.0.0

## Request Index

| ID | Title | Status |
|----|-------|--------|
| <REQ plus 8 hex digits> | <accepted request title> | <accepted or removed> |
```

The catalog owns the baseline version and the request index. It has no `Next ID` field.

Each ID appears once. Rows are ordered by ID. The id is `REQ` plus the eight hex digits derived from the title.

`accepted` has a record at `requests/<id>.md`. `removed` has no record file. A removed row stays in the index, keeps the title that last held that id, and leaves the id taken.

An empty baseline contains `Version: 1.0.0` and the index header, with no data rows. Do not write a placeholder id as a row.