# Feature 036 Data Model

## Profile Fixture State

| Field | Meaning | Validation |
|---|---|---|
| `profile_input` | Temporary Profile bytes or absent state | Must be isolated from the canonical artifact |
| `organization_name` | Supplied identity input | Missing, empty, whitespace-only, or non-empty |
| `confirmation` | Whether the proposed Profile is accepted | Confirmed or declined |
| `expected_status` | Owner readiness result | Complete, Missing, Declined, or Blocked |
| `before_hash` / `after_hash` | Artifact preservation evidence | Equal on no-write paths |
| `result_bytes` | Generated Profile output | Deterministic for identical confirmed inputs |

## Workflow Variant

| Field | Meaning | Validation |
|---|---|---|
| `canonical_bytes` | Original Setup skill bytes | Hash remains unchanged after all variants |
| `variant_bytes` | Temporary modified workflow | Contains exactly one targeted defect |
| `declared_steps` | Extracted numbered step set | Canonical is 1 through 10, unique and contiguous |
| `references` | Extracted `Step N` references | Every reference resolves in canonical input |
| `validation_result` | Structural result | PASS for canonical, FAIL for each malformed variant |

## Candidate Result

| Field | Meaning | Validation |
|---|---|---|
| `generation` | Whether candidate generation returned a usable result | Succeeded, unavailable, or malformed |
| `candidate_count` | Number of generated candidates | Zero or positive integer when succeeded |
| `proposal_state` | Acceptance progress for available candidates | Not Started, Pending, or Accepted |
| `accepted_artifacts` | Existing accepted NFR evidence | Zero or more valid artifacts |
| `expected_nfr_status` | NFR outcome derived from input | Not Applicable, Missing, In Progress, Complete, or Blocked |
| `expected_setup_status` | Setup outcome derived from input | Complete or In Progress |

## Invariants

- Negative tests never write to the canonical Profile, Setup skill, or distribution target.
- A successful zero count with candidate entries is malformed, not zero candidates.
- Unavailable and malformed generation never become Not Applicable.
- Accepted artifacts are distinct from pending proposals.
- Identical input records produce identical outcomes and artifact effects.
