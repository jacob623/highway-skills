# Feature 035 Profile Readiness Contract

`highway-profile` is authoritative for the Profile artifact, organization identity, Profile completeness, confirmation, and no-write failure behavior.

## Required Organization Identity

- Setup/configure asks: `What is the name of the organization, business unit, team, or project group this repository represents?`
- The answer is user supplied and is recorded verbatim after validation.
- Empty and whitespace-only answers are invalid.
- The value is stored at `organization.name`.
- Profile cannot report `Complete` when `organization.name` is absent, empty, or whitespace-only.
- Profile does not infer organization identity from repository paths, environment variables, Git metadata, or other fields.

## Outcome Contract

| Input state | Profile owner result | Write behavior |
|---|---|---|
| Profile absent; identity supplied and confirmed | `Complete` | Write the confirmed complete Profile |
| Profile absent; identity missing, empty, or declined | `Missing` or `Blocked` | Do not write |
| Existing Profile with valid non-empty identity | `Complete` | Read-only for readiness |
| Existing Profile with absent or empty identity | `Missing` | Do not report Complete; setup requires identity |
| Existing Profile malformed | `Blocked` | Preserve original bytes |
| Proposed Profile declined | `Incomplete`/`Declined` | Preserve original bytes |

Setup consumes the owner result and does not redefine the field-level validity rule.
