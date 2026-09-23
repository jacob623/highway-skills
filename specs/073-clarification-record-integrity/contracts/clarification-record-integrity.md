# Clarification Record Integrity Contract

## Scope

This contract governs the retained shared clarification-record template and representative
records for `REQ`, `DISC`, `ADR`, and `RA` artifacts. It refines representation and traceability
while preserving the version 2.0.0 guided-resolution contract.

## Frontmatter Contract

The File Frontmatter example is one complete delimited block. It contains exactly one instance of:
`id`, `artifact_id`, `artifact_type`, `source_path`, `status`, `revision`, `open_findings`,
`resolved_findings`, `total_findings`, and `blocking_reason`.

## Finding and History Contract

Each finding has a stable normalized identifier and aligned fingerprint. Each Resolution History
entry is a separate list item with Finding, Response, Revision, and Actor. Finding references are
unique within Resolution History and must resolve to exactly one finding in the same record.

## Evidence Contract

Each Evidence Sources entry is a separate list item with Source Type, Source Identifier, and
Reason Used. When no evidence exists, Evidence Sources contains `None`.

## Recommendation Contract

Recommendation State is stored in Recommended Option. Recommendation Basis and state map as follows:

| Basis | State |
|---|---|
| `authoritative` | Evidence-backed recommendation |
| `evidence-gap` | `Unknown` |
| `conflict` | `Escalate for Decision` |

`Unknown` and `Escalate for Decision` are distinct states. Guidance remains advisory and does not
transfer decision authority to Clarification.

## Option Selection Lifecycle

1. The user selects A, B, C, or D.
2. Clarification records Selected Option.
3. The user provides or accepts a Response.
4. Only an accepted Response performs `open -> resolved`.

Selected Option is informational. Response remains authoritative. Selecting an option does not
create or change Response and does not resolve a finding. Resolved findings do not reopen.

## Section Boundary Contract

Explanatory contract text appears outside Findings, Resolution History, Source, and Status
sections. Retained finding instances contain data fields only, including the placeholder
`Escalation Owner: <owner>` where applicable.

## Failure and Immutability Contract

Malformed history identity, frontmatter, evidence, recommendation basis/state, or lifecycle input
fails validation without a partial write. Existing privacy filtering, source immutability,
revision handling, ownership boundaries, and generated-artifact synchronization remain in force.
