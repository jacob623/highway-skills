---
name: objective-catalog
description: "Complete output skeleton for the Business Objective baseline catalog."
metadata:
  version: 2.0.0
---

## Catalog Structure

```markdown
# Business Objectives Catalog

Version: 1.0.0

## Objective Index

| Objective ID | Title | Status |
|--------------|-------|--------|
| <OBJ plus 8 hex digits> | <accepted objective title> | <active or removed> |
```

The catalog owns the baseline version and the objective index. It has no `Next ID` field.

Each Objective ID appears once. Rows are ordered by Objective ID. The id is `OBJ` plus the eight hex digits derived from the title.

`active` has a record at `library/objectives/<id>.md`. `removed` has no record file. A removed row stays in the index, keeps the title that last held that id, and leaves the id taken.

An empty baseline contains `Version: 1.0.0` and the index header, with no data rows. Do not write a placeholder id as a row.