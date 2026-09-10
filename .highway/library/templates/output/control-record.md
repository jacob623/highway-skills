---
name: control-record
description: "Complete output skeleton for a retained Control record."
metadata:
  version: 1.0.0
---

## File Frontmatter

```yaml
---
id: CTLXXXXXX
title: "<user-provided title>"
status: active
nfrs: []
---
```

## Body

```markdown
<user-provided statement>

<user-provided rationale>
```

The placeholders represent user-owned values. The template governs the presence and ordering of
the record structure, not the meaning or quality of those values.

The `nfrs` field is an identifier-only relationship list. Direct Control creation starts empty;
accepted Control-derived NFRs may append immutable `NFRXXXXXX` identifiers without changing this
record format.
