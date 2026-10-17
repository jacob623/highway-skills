---
name: capability-catalog
description: "Complete output skeleton for the generated Capability Catalog."
metadata:
  version: 1.0.0
---

## Catalog Structure

```markdown
# Capability Catalog

Version: 1.0.0

Next ID: CAPXXXXXX

## Capability Index

| ID | Parent | Title | Realized By |
|----|--------|-------|-------------|
| CAPXXXXXX | RIXXXXXX | <business capability title> | <provider; provider> |
```

The Capability Catalog is generated from accepted `Realized Capabilities` evidence in Reference
Implementations. A row has exactly one `RI######` Parent and at least one Realized By value. The
catalog-local `CAP######` identifier is stable for the `(Parent RI, normalized Title)` identity and
does not create a capability record file. Rows are ordered by Parent, Title, then CAP identifier;
multiple Realized By values are rendered in deterministic normalized order. Capability Catalog
publication is atomic with its owning Reference Implementation and implementation catalog; stale rows are removed
during regeneration.
