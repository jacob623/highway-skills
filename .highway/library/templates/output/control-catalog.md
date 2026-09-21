---
name: control-catalog
description: "Complete output skeleton for the repository Control baseline catalog."
metadata:
  version: 1.0.0
---

## Catalog Structure

```markdown
# Controls Catalog

Version: 1.0.0

Next ID: CTLXXXXXX

## Control Index

| Control ID | Title | Status |
|------------|-------|--------|
| CTLXXXXXX | <deterministic control title> | active |
```

The catalog owns the baseline version, next identifier, and Control index. Entries are unique and
ordered by permanent Control identifier; allocation state remains authoritative in the user-owned
catalog.
