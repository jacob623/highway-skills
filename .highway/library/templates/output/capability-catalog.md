---
name: capability-catalog
description: "Complete output skeleton for the Capability Catalog written with a Reference Implementation."
metadata:
  version: 2.1.0
---

## Catalog Structure

```markdown
# Capability Catalog

Version: 1.0.0

## Capability Index

| ID | Parent | Title | Realized By |
|----|--------|-------|-------------|
| <CAP plus 8 hex digits> | <RI plus 8 hex digits> | <business capability title> | <provider or mechanism> |
```

The catalog is written with its owning Reference Implementation. It has no `Next ID` field. The columns are ID, Parent, Title, and Realized By.

Parent is the implementation id. Title is one capability: one noun phrase of five words or fewer. A hyphenated word counts as one word. Modifiers can precede the noun. A Title does not contain `and`, `or`, `&`, `/`, `+`, or a comma. A title that joins two things is two capabilities, one per part. Each part keeps its own words and repeats a shared noun when there is one. Realized By lists the providers or mechanisms, in alphabetical order. The id is CAP plus eight hex digits derived from the title. The same Parent and title reuse that id. A removed row is not used; rows for one Parent are replaced on each write, and other Parents stay unchanged.

No `CAP` record file is written. An empty baseline contains `Version: 1.0.0` and the index header, with no data rows.
