# Control Record Recommendation Grounding Contract

The retained Control record keeps existing YAML frontmatter:

```yaml
id: CTLXXXXXX
title: "<user-provided title>"
status: active
nfrs: []
```

The body contains accepted Control content first:

```markdown
<accepted statement>

<accepted rationale>
```

When a Highway recommendation materially influenced the accepted Control, the body may then
contain:

```markdown
## Recommendation Grounding

<recommendation grounding sources that influenced the accepted Control, when applicable>
```

Recommendation Grounding is optional lineage. It is omitted for directly authored Controls without
material recommendation influence. It may identify accepted Profile evidence, accepted Objective
identifiers, existing Highway artifact identifiers, and declared external expertise or framework
references. It never becomes organizational policy or proves applicability, certification, or
compliance.
