# Data Model: Highway Assessment

## Assessment Finding

A user-reviewable advisory observation derived from relationships across accepted repository knowledge.

| Field | Required | Rules |
|---|---|---|
| ID | Yes | Sequential zero-padded display ID in the form `F001`; allocated only for a new fingerprint and never renumbered. |
| Category | Yes | One of `Coverage`, `Consistency`, `Dependency`, `Opportunity`, `Reuse`, or `Risk`. |
| Domain | Yes | One of `Architectures`, `Implementations`, or `Portfolio`. |
| Finding | Yes | A concise observation grounded in accepted repository knowledge. |
| Fingerprint | Yes | Deterministic equivalence key from normalized Category, Domain, and Finding text. |
| Status | Yes | One of `Open`, `Accepted`, `Dismissed`, `Resolved`, or `Superseded`. New findings start `Open`. |
| Disposition | Yes | Review explanation or reference; `None` when no disposition exists. |

## Findings Record

The retained record is `.highway/library/knowledge/assessment-findings.md`.

Frontmatter:

```yaml
---
name: assessment-findings
description: "Retained advisory findings produced by highway-assessment."
metadata:
  version: 1.0.0
revision: 0
---
```

The body contains a Markdown table with columns:

```text
ID | Category | Domain | Finding | Fingerprint | Status | Disposition
```

`revision` is a non-negative integer. Successful mutations increment it exactly once. A mutation
against a stale revision is rejected and writes nothing.

## Fingerprint

Normalize each of Category, Domain, and Finding Text in order:

1. Normalize line endings to LF.
2. Trim leading and trailing whitespace.
3. Convert values to lowercase.
4. Collapse consecutive whitespace to one space.
5. Compose a deterministic fingerprint from the normalized values in the declared field order.

Equivalent normalized inputs reuse the existing finding. Distinct normalized inputs receive a new
sequential display ID.

## State Transitions

```text
new -> Open
Open -> Accepted | Dismissed | Resolved | Superseded
```

`Request More Information` leaves the status unchanged. Resolved, dismissed, and superseded findings
remain retained for context and duplicate detection. Unsupported transitions are rejected.

## Relationships

- A finding belongs to exactly one assessment domain.
- A finding may be grounded in multiple accepted repository artifacts; those source references remain
  in the finding text or disposition without creating a separate relationship artifact.
- A downstream workflow may consume findings as context but does not gain authority to mutate the
  finding or owning artifacts through that context.
