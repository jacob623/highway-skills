---
name: clarification-record
description: "Authoritative output structure for a deterministic retained clarification artifact."
metadata:
  version: 2.0.0
id: CLAR-REQ000001
artifact_id: REQ000001
artifact_type: REQ
source_path: requests/REQ000001.md
status: in-progress
open_findings: 1
resolved_findings: 1
total_findings: 2
blocking_reason: None

## File Frontmatter

```yaml
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
Recommended Rationale: <deterministic rationale with source traceability>
Evidence Sources:
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
Escalation Owner: Request owner

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
Recommended Rationale: <retained deterministic rationale>
Evidence Sources:
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
Escalation Owner: Request owner

Selecting an option does not create a response. Only an explicitly accepted Response may transition
an open finding to resolved. Conflict guidance uses `Unknown / Escalate for Decision`, retains
conflicting values and evidence sources, and requires explicit selection.

Escalation Owner: Request owner; Discovery consumer or responsible architect; ADR decision authority;
or Reference Architecture owner, according to artifact type.

## Resolution History

  Response: None
  Revision: 1
  Actor: None
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

The placeholders represent user-owned or generated values. The template governs required
frontmatter and body structure; it does not authorize source-artifact mutation.
