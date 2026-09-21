# Clarification Artifact Contract

## File Location

The artifact is colocated with its source and uses `<ARTIFACT-ID>-clarification.md`.

Examples:

- `requests/REQ000001-clarification.md`
- `discoveries/DISC000003-clarification.md`
- `adrs/ADR000004-clarification.md`
- `reference-architectures/RA000005-clarification.md`

A centralized clarification directory is not valid.

## Frontmatter

```yaml
---
name: clarification-record
description: "Complete output skeleton for a retained clarification artifact."
metadata:
  version: 1.0.0
  revision: 1
artifact_id: REQ000001
artifact_type: REQ
source_path: requests/REQ000001.md
status: in-progress
blocking_reason: None
---
```

`revision` is an integer. It increments exactly once after each successful Update commit.
`blocking_reason` is non-empty only when `status` is `blocked`.

## Body

```markdown
# Clarification: REQ000001

## Findings

### CLAR-REQ000001-001

Category: missing_input
Severity: high
State: open
Evidence: Problem / required section
Summary: Required evidence is absent.
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

The template owns section order and required fields. Implementations must validate the complete
structure before writing and must preserve source bytes.
