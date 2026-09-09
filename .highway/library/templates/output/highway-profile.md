---
name: highway-profile
description: "Complete output skeleton for the retained Highway organizational profile."
metadata:
  version: 1.0.0
---

## File Frontmatter

```yaml
---
metadata:
  version: 1.0.0
  description: "<framework-owned contextual description>"
---
```

## Optional Profile Sections

```yaml
constraints:
  <category>:
    <key>: <user-provided value>
strategic_directions:
  <category>:
    <key>: <user-provided value>
preferences:
  <category>:
    <key>: <user-provided value>
```

Supported future sections preserve the same user-owned structure: `business_context`,
`architecture_principles`, `approved_technologies`, `prohibited_technologies`, `operating_model`,
and `vendor_strategy`. Empty sections are omitted. The skeleton governs structure and ordering,
not the meaning or quality of user-provided values.
