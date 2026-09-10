# Feature 035 Data Model

## Profile Readiness

| Field | Description | Validation |
|---|---|---|
| `profile_status` | Profile owner's readiness result | `Complete`, `Missing`, `Blocked`, or `Not Evaluated` |
| `organization_name` | User-supplied organization identity | Present, non-empty, and not whitespace-only for `Complete` |
| `profile_evidence` | Owner-provided reason and source of readiness | Must identify the field or section when incomplete or blocked |
| `profile_bytes_before` | Existing Profile content hash | Used for decline, malformed, and no-write assertions |
| `profile_bytes_after` | Resulting Profile content hash | Must equal before-hash when no confirmed mutation occurs |

## Numbered Workflow

| Field | Description | Validation |
|---|---|---|
| `step_number` | Sequential Setup workflow identifier | Integers 1 through 10, each appearing once |
| `step_text` | Action and failure behavior for the step | Non-empty and includes an error route |
| `step_reference` | A reference such as `Step 4` | Resolves to exactly one declared step |
| `workflow_result` | Structural validation outcome | `PASS` only when numbering and references are valid |

## NFR Candidate Result

| State | Meaning | Setup result |
|---|---|---|
| `Unavailable` | Candidate generation did not return a result | `NFRs: Blocked`; stop without fabrication |
| `Malformed` | Candidate result cannot be validated | `NFRs: Blocked`; stop without fabrication |
| `ZeroCandidates` | Generation succeeded with exactly zero candidates | `NFRs: Not Applicable`; terminal completion |
| `CandidatesAvailable` | One or more candidates exist without accepted artifacts | `NFRs: Missing` or `In Progress` according to proposal state |
| `AcceptedArtifacts` | Accepted valid NFR artifacts exist | `NFRs: Complete`; terminal completion |

## State Invariants

- Setup never evaluates NFR candidate state before Profile, Objectives, and Controls are complete.
- `ZeroCandidates` is terminal only when candidate generation succeeded and no accepted NFR artifacts exist.
- `Unavailable` and `Malformed` never collapse into `ZeroCandidates`.
- A missing, empty, or whitespace-only organization name prevents `profile_status: Complete`.
- A declined Profile proposal preserves the original Profile bytes.
- Every Setup `Step N` reference resolves to one declared step.
