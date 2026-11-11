---
name: nfr-record
description: "Complete output skeleton for a retained Non-Functional Requirement record."
metadata:
  version: 2.0.0
---

## File Frontmatter

```yaml
---
id: NFRXXXXXX
title: "<user-provided title>"
status: active
controls: []
---
```

## Body

```markdown
<accepted NFR statement>

<accepted evidence-grounded rationale>
```

Statement and Rationale represent accepted NFR content. They may originate from direct user-authored
content, materially interpreted content accepted by the user, or an explicitly selected Highway recommendation.
The retained values need not have been literally typed by the user. The template
governs the presence and ordering of the record structure, not the meaning or quality of those values.

The `controls` field is an identifier-only relationship list. Direct NFR creation starts empty;
an NFR accepted through the Control-derived workflow may contain immutable `CTLXXXXXX` identifiers
without changing this record format.
