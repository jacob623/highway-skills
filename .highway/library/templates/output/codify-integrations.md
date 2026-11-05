---
name: codify-integrations
description: "Complete output skeleton for the accepted integrations between implementations."
metadata:
  version: 1.0.0
---

## Catalog Structure

```markdown
# Integrations Catalog

Version: 1.0.0

## Integration Index

| From | To | Kind | Summary | Status |
|------|----|------|---------|--------|
| <RI plus 8 hex digits> | <RI plus 8 hex digits> | <composition or capability> | <what the connection does> | <accepted or removed> |
```

The catalog is `code/integrations.md`. A row is written when the person accepts a proposal that includes that integration. No second acceptance is asked.

From and To are accepted implementation ids. Kind `composition` means the two implementations form one product, such as a frontend and its backend. Kind `capability` means From uses To as a feature of the product that serves From.

The same From, To, and Kind appears once. A proposal for a pair already accepted writes no second row. Rows are in acceptance order. A row whose status changes keeps its position.

A row records the connection only. It does not mean any feature is built.

An empty baseline contains `Version: 1.0.0` and the index header, with no data rows. Do not write a placeholder row.
