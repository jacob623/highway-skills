---
name: Organizational Profile
description: "Complete output skeleton for retained organizational Profile evidence."
metadata:
  version: 3.1.0
---

## File Frontmatter

```yaml
---
schema_version: 3.0.0
domains:
  identity: <not_discussed, discussed, or bounded>
  vision: <not_discussed, discussed, or bounded>
  competitive_path: <not_discussed, discussed, or bounded>
  guiding_principles: <not_discussed, discussed, or bounded>
---
```

## Body

```markdown
# Organizational Profile

## Who We Are
<accepted Identity evidence when the identity state permits narrative>

## Where We're Going
<accepted Vision evidence when the vision state permits narrative>

## How We Plan to Get There
<accepted Competitive Path evidence when the competitive_path state permits narrative>

## What Guides Our Decisions
<accepted Guiding Principles evidence when the guiding_principles state permits narrative>

## Context

### Repository Name
<accepted Repository Name>

### Organization Name
<accepted Organization Name>

### Organization URL
<accepted Organization URL>

### Organizational Context
<other accepted durable organizational context permitted by the Profile owner contract>
```

The domain headings above define the permitted retained narrative sections and their ordering. Render a domain heading only when its domain state permits narrative.

`discussed` renders accepted narrative. `bounded` means the person explicitly bounded the domain, and accepted narrative renders only when accepted evidence exists. `not_discussed` renders no narrative section. A bounded narrative is not required for symmetry. Do not emit an empty domain heading or placeholder.

All four domain keys remain in the retained domains mapping whether or not their narrative sections render. For example, `identity: not_discussed`, `vision: not_discussed`, `competitive_path: not_discussed`, and `guiding_principles: not_discussed` still appear in frontmatter even when the body contains no matching narrative section. `# Organizational Profile` is always present. Do not reorder rendered domain headings by acquisition order, conversational order, update order, which domain changed most recently, or narrative size.

## Context is optional and follows all rendered Profile-domain narratives. Omit ## Context when no Context child has accepted content.

Within ## Context, render only accepted children. Absent Context children are omitted. Context headings are not domain keys and do not create readiness dimensions.

Organizational Context contains only accepted durable organizational context permitted by the Profile owner contract; it does not broaden Profile ownership beyond that contract.

Template metadata describes profile-record.md and is not retained Profile content.

The retained artifact contains only its retained frontmatter, # Organizational Profile, permitted accepted domain narratives, and permitted accepted optional Context.
