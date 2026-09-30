# NFR Record Contract

## Frontmatter

```yaml
---
id: NFRXXXXXX
title: "<accepted title>"
status: active
controls: []
---
```

Frontmatter remains limited to `id`, `title`, `status`, and identifier-only `controls`.

## Body

```markdown
<accepted NFR statement>

<accepted evidence-grounded rationale>
```

Accepted Statement and Rationale may originate from direct user-authored content, materially
interpreted content accepted by the user, or an explicitly selected Highway recommendation. The
record does not imply that every retained value was literally typed by the user.

Direct NFR creation starts with `controls: []`. Accepted Control-derived NFRs may contain immutable
originating `CTLXXXXXX` identifiers. No persisted classification field is added.

## Version

The retained placeholder contract changes the template metadata from `1.0.0` to `2.0.0`.
