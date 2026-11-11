---
name: control-catalog
description: "Complete output skeleton for the repository Control baseline catalog."
metadata:
  version: 2.0.0
---

## Catalog Structure

```markdown
# Controls Catalog

Version: 1.0.0

## Control Index

| Control ID | Title | Status |
|------------|-------|--------|
| <CTL plus 8 hex digits> | <accepted control title> | <active or removed> |
```

The catalog owns the baseline version and the Control index. It has no `Next ID` field.

Each Control ID appears once. Rows are ordered by Control ID. The id is `CTL` plus the eight hex digits derived from the title.

`active` has a record at `library/governance/controls/<id>.md`. `removed` has no record file. A removed row stays in the index, keeps the title that last held that id, and leaves the id taken.

An empty baseline contains `Version: 1.0.0` and the index header, with no data rows. Do not write a placeholder id as a row.