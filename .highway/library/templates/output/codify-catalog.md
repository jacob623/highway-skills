---
name: codify-catalog
description: "Complete output skeleton for the repository automation catalog."
metadata:
  version: 1.0.0
---

## Catalog Structure

```markdown
# Automations Catalog

Version: 1.0.0

## Automation Index

| Automation ID | Implementation ID | Automation Title | Automation Path | Status |
|---------------|-------------------|------------------|-----------------|--------|
| <CDY plus 8 hex digits> | <RI plus 8 hex digits> | <automation title> | code/<CDY id>/codify.md | <accepted or removed> |
```

The catalog is `code/code.md`. It owns the baseline version and the automation index. It has no `Next ID` field. The index columns are Automation ID, Implementation ID, Automation Title, Automation Path, and Status.

Each Automation ID appears once. Rows are ordered by Automation ID. The Automation ID is `CDY` plus the eight hex digits derived from the title. Implementation ID is the accepted implementation this automation serves. More than one row may name the same Implementation ID.

`accepted` has a folder at `code/<id>/`. `removed` has no folder. A removed row keeps its id and has no folder. A removed row stays in the index, keeps the title that last held that id, and leaves the id taken.

An empty baseline contains `Version: 1.0.0` and the index header, with no data rows. Do not write a placeholder id as a row.
