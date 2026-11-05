---
name: codify-catalog
description: "Complete output skeleton for the repository product catalog."
metadata:
  version: 3.0.0
---

## Catalog Structure

```markdown
# Products Catalog

Version: 1.0.0

## Product Index

| ID | Folder | Title | Summary | Implementations | Features | Status |
|----|--------|-------|---------|-----------------|----------|--------|
| <CDY plus 8 hex digits> | code/<folder> | <product title> | <who it is for and what it returns> | <RI id; RI id> | <001-action \| one sentence; 002-action \| one sentence> | <accepted or removed> |
```

The catalog is `code/code.md`. It owns the baseline version and the product index. It has no `Next ID` field. The index columns are ID, Folder, Title, Summary, Implementations, Features, and Status.

Each ID appears once, and each row is one product. Rows are in acceptance order. A new row is appended as the last row. A new feature updates its product's row and adds no row. A row whose status changes keeps its position. The ID is `CDY` plus the eight hex digits derived from the product title. It is not the folder name.

Folder is `code/` plus the product title in lowercase words separated by hyphens, or the folder the person named. Each Folder appears once, including removed rows.

Summary is one sentence that says who the product is for and what it returns. Implementations lists the accepted implementation ids the product serves, separated by `; `. More than one row may name the same Implementation ID.

Features lists entries separated by `; `, in acceptance order. Each entry is `<number>-<action> | one sentence`. An entry is kept only when that feature starts the product, adds an implementation, records an integration, changes the summary, or is open. A finished feature that did none of those leaves the cell. Its directory remains.

`accepted` has a folder at its Folder path. `removed` has no folder. A removed row keeps its id and has no folder. A removed row stays in the index, keeps its Folder and recorded feature titles taken, and is not joined.

An empty baseline contains `Version: 1.0.0` and the index header, with no data rows. Do not write a placeholder id as a row.
