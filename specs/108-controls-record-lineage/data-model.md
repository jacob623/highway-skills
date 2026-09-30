# Data Model: Controls Record Lineage Cleanup

## Control record

The retained artifact remains `library/governance/controls/CTLXXXXXX.md`.

| Area | Contract |
|---|---|
| Frontmatter | Unchanged: `id`, `title`, `status`, and identifier-only `nfrs`. No grounding field. |
| Accepted Control content | Title, Statement, and Rationale are accepted organizational Control content. |
| Recommendation Grounding | Optional body section containing only lineage for sources that materially influenced an accepted Highway recommendation. |

The body section is:

```markdown
## Recommendation Grounding

<recommendation grounding sources that influenced the accepted Control, when applicable>
```

It is omitted when no Highway recommendation materially influenced the accepted Control. Grounding
may identify accepted Profile evidence, accepted Objective identifiers, existing Highway artifact
identifiers, and declared external expertise or framework references. It does not establish policy,
framework applicability, certification, or compliance.

## Controls collection result

The owner result remains exactly:

```text
Action Status
Collection Result
Next Action
Blocking Reason
```

`Created Control IDs` is not part of the result.

## NFR boundary

Controls invokes candidate generation once after a successfully created new Control. NFRs owns
subsequent candidate state, review, persistence, and readiness.
