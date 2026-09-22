---
name: clarification-record
description: "Authoritative output structure for a deterministic retained clarification artifact."
metadata:
  version: 1.1.0
  revision: 1
id: CLAR-REQ000001
artifact_id: REQ000001
artifact_type: REQ
source_path: requests/REQ000001.md
status: in-progress
open_findings: 1
resolved_findings: 0
total_findings: 1
blocking_reason: None
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
resolved_findings: 0
total_findings: 1
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
fingerprint: ambiguity|requirements|REQ000001:field
State: open
evidence_ref: <source location or evidence identity after privacy filtering>
Evidence: <source location or evidence identity after privacy filtering>
Summary: <finding summary>
Response: None

## Resolution History

- Finding: CLAR-REQ000001-001
  Response: None
  Revision: 1
  Actor: None

## Source

Artifact ID: REQ000001
Artifact Type: REQ
Source Path: requests/REQ000001.md

## Status

Status: in-progress
Open Findings: 1
Resolved Findings: 0
Total Findings: 1
Blocking Reason: None
```

Sensitive values in findings, responses, resolution history, metadata, and copied evidence
must be replaced before retention with `<secret-redacted>` or `<pii-redacted>`. Findings are
ordered by category priority, source artifact order, source field name, and finding identifier.
Finding fingerprints preserve identifiers across reordering; retired identifiers are recorded and
never reused. The status precedence is `blocked`, `complete`, `in-progress`, then `not-started`.

The placeholders represent user-owned or generated values. The template governs required
frontmatter and body structure; it does not authorize source-artifact mutation.
