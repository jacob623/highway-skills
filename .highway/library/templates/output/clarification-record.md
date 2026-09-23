---
name: clarification-record
description: "Authoritative output structure for a deterministic retained clarification artifact."
metadata:
  version: 2.0.0
---

## File Frontmatter

```yaml
---
id: CLAR-REQ000001
artifact_id: REQ000001
artifact_type: REQ
source_path: requests/REQ000001.md
status: in-progress
revision: 1
open_findings: 1
resolved_findings: 1
total_findings: 2
blocking_reason: None
---
```

## Body

```markdown
# Clarification: REQ000001

## Findings

### CLAR-REQ000001-001

Category: missing_input
Severity: high
finding_id: CLAR-REQ000001-001
fingerprint: missing_input|requirements|REQ000001:field
State: open
evidence_ref: <source location or evidence identity after privacy filtering>
Evidence: <source location or evidence identity after privacy filtering>
Summary: <finding summary>
Question: <one deterministic resolution question>
Why It Matters: <one deterministic consequence explanation>
Recommended Option: <advisory recommended option or Unknown>
Recommendation Basis: authoritative
Recommended Rationale: <deterministic rationale with source traceability>
Evidence Sources:
- Source:
  - Source Type: <source type>
  - Source Identifier: <source identifier>
  - Reason Used: <reason this source was used>
- Source:
  - Source Type: <source type>
  - Source Identifier: <source identifier>
  - Reason Used: <reason this source was used>
Alternative Option B: <advisory alternative option>
Alternative Rationale B: <deterministic rationale>
Alternative Option C: <advisory alternative option>
Alternative Rationale C: <deterministic rationale>
Custom Option: <user-supplied answer path>
Selected Option: None
Response: None
Escalation Owner: <owner>

### CLAR-REQ000001-002

Category: ambiguity
Severity: medium
finding_id: CLAR-REQ000001-002
fingerprint: ambiguity|requirements|REQ000001:resolved-field
State: resolved
evidence_ref: <source location or evidence identity after privacy filtering>
Evidence: <source location or evidence identity after privacy filtering>
Summary: <finding summary>
Question: <retained deterministic resolution question>
Why It Matters: <retained deterministic consequence explanation>
Recommended Option: <retained advisory recommended option>
Recommendation Basis: authoritative
Recommended Rationale: <retained deterministic rationale>
Evidence Sources:
- Source:
  - Source Type: <source type>
  - Source Identifier: <source identifier>
  - Reason Used: <reason this source was used>
Alternative Option B: <retained advisory alternative option>
Alternative Rationale B: <retained deterministic rationale>
Alternative Option C: <retained advisory alternative option>
Alternative Rationale C: <retained deterministic rationale>
Custom Option: <retained user-supplied answer path>
Selected Option: None
Response: <accepted response>
Escalation Owner: <owner>

## Resolution History

- Finding: CLAR-REQ000001-001
  Response: None
  Revision: 1
  Actor: None
- Finding: CLAR-REQ000001-002
  Response: <accepted response>
  Revision: 1
  Actor: None

## Source

Artifact ID: REQ000001
Artifact Type: REQ
Source Path: requests/REQ000001.md

## Status

Status: in-progress
Open Findings: 1
Resolved Findings: 1
Total Findings: 2
Blocking Reason: None
```

Sensitive values in findings, responses, resolution history, metadata, and copied evidence
must be replaced before retention with `<secret-redacted>` or `<pii-redacted>`. Findings are
ordered by category priority, source artifact order, source field name, and finding identifier.
Every finding has exactly one Question and one Why It Matters explanation. Open findings have
exactly three generated options in A Recommended, B Alternative, C Alternative, D Custom order;
each generated option has deterministic rationale and source traceability. Selected Option is
informational and accepts only A, B, C, D, or None. Selecting an option does not resolve a
finding; only an explicitly accepted response may perform `open -> resolved`.
Finding fingerprints preserve identifiers across reordering; retired identifiers are recorded and
never reused. Finding states are exactly `open` and `resolved`; new findings begin open, and only
an accepted response may transition an open finding to resolved. Resolved findings retain
identifiers, fingerprints, history, and evidence references and never transition back to open. The
count invariant is `total_findings = open_findings + resolved_findings`; violations are malformed
and derive `blocked` before other status evaluation. The status precedence is `blocked`, `complete`,
`in-progress`, then `not-started`.

## Clarification Contract

Resolution History entries are list items with Finding, Response, Revision, and Actor. Each Finding
references exactly one finding identifier in this record and no identifier may repeat in the history.

Evidence Sources are separate list items with Source Type, Source Identifier, and Reason Used. When no evidence sources exist, Evidence Sources: None.

Recommendation State is stored in Recommended Option. Recommendation Basis maps as follows:

- `authoritative`: an evidence-backed recommendation.
- `evidence-gap`: `Unknown` when no authoritative evidence exists.
- `conflict`: `Escalate for Decision` when authoritative evidence conflicts.

Examples of the distinct non-authoritative states are `Recommended Option: Unknown` with
`Recommendation Basis: evidence-gap` and `Recommended Option: Escalate for Decision` with
`Recommendation Basis: conflict`. These states are never combined.

For escalation, REQ findings route to the Request owner, DISC findings to the Discovery consumer or responsible architect, ADR findings to the ADR decision authority, and RA findings to the Reference Architecture owner. Escalation remains advisory.

Conflict guidance uses `Unknown / Escalate for Decision`, retains conflicting values and evidence sources, and requires explicit selection.

## Option Selection Lifecycle

1. The user selects A, B, C, or D.
2. Selected Option is recorded. Selecting an option does not create a response or change Response.
3. The user provides or accepts a Response.
4. Only an explicitly accepted Response may transition `open -> resolved`.

Selected Option is informational and Response remains authoritative. Explanatory contract text appears outside the Findings, Resolution History, Source, and Status sections. The template does not authorize
source-artifact mutation, governance approval, architecture selection, or automatic resolution.
Explanatory contract text appears outside Findings, Resolution History, Source, and Status.

The placeholders represent user-owned or generated values. The template governs required
frontmatter and body structure; it does not authorize source-artifact mutation.
