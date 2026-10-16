# Assessment Findings Persistence Contract

## Path

`.highway/library/knowledge/assessment-findings.md`

## Frontmatter

The file MUST contain `name`, `description`, and `metadata.version` fields accepted by the shared
library validator. It MUST also contain a non-negative integer `revision`.

## Table

The body MUST contain one Markdown table with these columns:

```text
ID | Category | Domain | Finding | Fingerprint | Status | Disposition
```

Required values:

- `ID`: unique sequential `F###` display ID.
- `Category`: `Coverage`, `Consistency`, `Dependency`, `Opportunity`, `Reuse`, or `Risk`.
- `Domain`: `Architectures`, `Implementations`, or `Portfolio`.
- `Finding`: non-empty grounded advisory observation.
- `Fingerprint`: non-empty deterministic normalized equivalence key.
- `Status`: `Open`, `Accepted`, `Dismissed`, `Resolved`, or `Superseded`.
- `Disposition`: non-empty review explanation or `None`.

## Mutation Rules

- New findings start `Open`.
- Equivalent fingerprints reuse their existing row and ID.
- New fingerprints receive the next unused sequential `F###` ID.
- Status and disposition changes preserve unrelated rows.
- A stale revision rejects the complete mutation and writes nothing.
- Successful mutations increment `revision` once.
- Invalid rows, duplicate IDs, duplicate fingerprints, unsupported values, and unsupported transitions
  reject the complete mutation.
