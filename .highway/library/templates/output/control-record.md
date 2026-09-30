---
name: control-record
description: "Complete output skeleton for a retained Control record."
metadata:
  version: 2.0.0
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

## Recommendation Grounding

<recommendation grounding sources that influenced the accepted Control, when applicable>
```

Title, Statement, and Rationale represent accepted Control content. Recommendation Grounding records
lineage for sources that influenced a Highway recommendation and is not itself organizational policy.
The `## Recommendation Grounding` section is optional and belongs in the record body; omit it when no
Highway recommendation materially influenced the accepted Control. It MUST NOT be added to
frontmatter.

Recommendation Grounding may identify accepted Profile evidence, accepted Objective identifiers,
existing Highway artifact identifiers, and declared external expertise or framework references that
influenced the recommendation. Retain only sources that actually influenced it, using stable Highway
artifact identifiers when available and enough external source or reference information to identify
declared expertise. External grounding does not by itself establish framework applicability,
certification, compliance, or organizational policy. The template governs the presence and ordering
of the record structure, not the meaning or quality of those values.

The `nfrs` field is an identifier-only relationship list. Direct Control creation starts empty;
accepted Control-derived NFRs may append immutable `NFRXXXXXX` identifiers without changing this
record format.
