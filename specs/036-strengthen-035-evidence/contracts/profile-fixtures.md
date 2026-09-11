# Profile Fixture Contract

The Profile behavior test accepts an isolated fixture state and returns an observed readiness status, write decision, byte-preservation result, and resulting Profile bytes when a confirmed write is valid.

## Required Inputs

- Profile absent or temporary Profile content.
- `organization.name` state: missing, empty, whitespace-only, or non-empty.
- Confirmation: confirmed or declined.
- Expected malformed section when the input is invalid.

## Required Outcomes

| Input | Required result |
|---|---|
| Absent or empty identity | Not Complete; no write |
| Whitespace-only identity | Not Complete; no write |
| Non-empty confirmed identity | Complete; deterministic output containing supplied value |
| Declined proposal | Declined/incomplete; original bytes preserved |
| Malformed Profile | Blocked; malformed section identified; original bytes preserved |

The fixture runner must compare before and after hashes and must execute identical valid input at least three times for determinism.
