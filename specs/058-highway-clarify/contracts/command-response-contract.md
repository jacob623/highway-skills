# Command and Response Contract

## Commands

| Command | Writes? | Required input |
|---|---:|---|
| `/highway-clarify <ARTIFACT-ID>` | Yes | Exact uppercase REQ, DISC, ADR, or RA identifier |
| `/highway-clarify update <ARTIFACT-ID>` | Yes | Supported identifier and valid finding response |
| `/highway-clarify inspect <ARTIFACT-ID>` | No | Supported identifier |
| `/highway-clarify read <ARTIFACT-ID>` | No | Supported identifier |
| `/highway-clarify status <ARTIFACT-ID>` | No | Supported identifier |

Any repository user may invoke all commands subject to existing repository access controls.

## Generate Response

```yaml
action: generate
artifact_id: REQ000001
status: created
path: requests/REQ000001-clarification.md
finding_count: 1
open_findings: 1
resolved_findings: 0
```

## Update Response

Success:

```yaml
action: update
artifact_id: REQ000001
status: in-progress
path: requests/REQ000001-clarification.md
revision: 2
updated_findings:
  - CLAR-REQ000001-001
```

Conflict:

```yaml
action: update
artifact_id: REQ000001
status: conflict
expected_revision: 1
actual_revision: 2
message: Clarification artifact changed during update.
path: requests/REQ000001-clarification.md
```

A conflict aborts without partial writes, history entries, or automatic merging. The caller may
reload and retry no more than three times.

## Inspect Response

```yaml
action: inspect
artifact_id: REQ000001
status: in-progress
open_findings: 1
resolved_findings: 0
total_findings: 1
path: requests/REQ000001-clarification.md
blocking_reason: None
```

## Read Response

Returns the complete validated clarification artifact, including frontmatter and all structured
body sections. It performs no writes.

## Status Response

```yaml
action: status
artifact_id: REQ000001
status: in-progress
open_findings: 1
resolved_findings: 0
total_findings: 1
path: requests/REQ000001-clarification.md
blocking_reason: None
```

Open findings are advisory and do not gate downstream source consumption.
