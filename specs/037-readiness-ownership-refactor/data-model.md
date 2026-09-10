# Feature 037 Data Model

## Readiness Response

| Field | Required value | Validation |
|---|---|---|
| `Status` | One of `Complete`, `Missing`, `In Progress`, `Blocked`, `Not Applicable` | First line; exact spelling and ordering |
| `Summary` | Non-empty human-readable explanation | Second line; describes observed owner state |
| `Next Action` | Owner route or `None` | Third line; no mutation is performed by readiness |
| `Blocking Reason` | Non-empty reason only for `Blocked`; otherwise `None` | Fourth line; exact field order |

A response is invalid if it has a missing, duplicate, unknown, or reordered field, an unknown status, or a blocking reason inconsistent with the status.

## Owner Readiness State

| Owner | Source state | Complete condition | Non-complete conditions |
|---|---|---|---|
| Profile | Profile YAML | `organization.name` exists and is non-empty after trimming | Missing/empty identity is `Missing`; malformed or contradictory profile state is `Blocked` |
| Objectives | Objective records, catalog, next identifier state | At least one valid Objective record and consistent catalog state | No valid records is `Missing`; malformed records/catalog/next identifier is `Blocked` |
| Controls | Control baseline and Control records | At least one valid Control and consistent baseline state | No valid Controls is `Missing`; malformed or inconsistent baseline is `Blocked` |
| NFRs | Candidate generation result and accepted NFR artifacts | Accepted valid NFR artifacts exist | Unavailable/malformed generation is `Blocked`; zero candidates with no accepted artifacts is `Not Applicable`; unaccepted candidates are `In Progress` |

## Setup Route

Setup evaluates owners in this fixed order:

`Profile -> Objectives -> Controls -> NFRs`

It short-circuits on the first status other than `Complete`. For NFR, both `Complete` and `Not Applicable` finish successfully. Any malformed or unknown owner response becomes a deterministic orchestration `Blocked` result without assuming completion.

## Evidence Record

Each verification fixture records:

- owner and input-state label
- exact four-field response
- selected Setup route, when applicable
- before and after artifact hashes
- repeated-run response/hash comparison
- executable, static, generated-artifact, and limitation evidence classification

No readiness entity is persisted; all fields are derived from existing artifacts.
