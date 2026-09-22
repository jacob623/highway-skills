# Data Model: Clarification Contract Hardening

## Contract Version

| Field | Meaning | Validation |
|---|---|---|
| `skill_version` | Version declared by the canonical `highway-clarify` contract | Must be `2.0.0` |
| `record_version` | Version declared by the retained clarification-record template | Must equal `skill_version` and be `2.0.0` |

## Finding Identity

| Field | Meaning | Validation |
|---|---|---|
| `category` | Finding classification | Required and non-empty |
| `fingerprint` | Stable finding identity | Its category segment must equal `category`; mismatch produces no write |
| `artifact_type` | Owning artifact family | Must be one of `REQ`, `DISC`, `ADR`, or `RA` |

## Artifact-Specific Source Set

| Artifact type | Eligible sources |
|---|---|
| `REQ` | Request, Profile, Objectives, Controls, NFRs |
| `DISC` | Discovery Findings, Assumptions, Risks, Unknowns, Objectives, Controls, NFRs |
| `ADR` | Discovery handoff, ADR context, selected candidate option |
| `RA` | Architecture contents, Controls, NFRs, Objectives |

Source-set selection occurs before precedence evaluation. Sources outside the selected set are ignored.

## Recommendation Precedence

The global order, evaluated only after filtering, is:

1. Source artifact
2. Clarification responses
3. Profile
4. Objectives
5. Controls
6. NFRs
7. Discovery
8. Reference Architectures
9. Reference Implementations

The first available precedence level supplies the recommendation when it contains one value. Multiple conflicting values at that highest level produce `Unknown / Escalate for Decision`.

## Recommendation State

| State | Condition | Required behavior |
|---|---|---|
| `Unknown` | No authoritative evidence exists in the selected source set | Explain the evidence gap; do not escalate as a conflict |
| `Unknown / Escalate for Decision` | Authoritative evidence exists at the highest applicable precedence but values conflict | Retain conflicting values and sources; route to the artifact-type owner; require explicit selection |

## Evidence Source

Every evidence-backed recommendation or alternative contains:

- `Source Type`
- `Source Identifier`
- `Reason Used`

Evidence references are deterministic, privacy-filtered, and retained with the finding.

## Escalation Owner

| Artifact type | Advisory escalation owner |
|---|---|
| `REQ` | Request owner |
| `DISC` | Discovery consumer or responsible architect |
| `ADR` | ADR decision authority |
| `RA` | Reference Architecture owner |

The owner identifies who decides; it does not grant Clarification authority to decide or mutate source artifacts.

## Option and Response Lifecycle

| Event | Selected Option | Response | Finding state |
|---|---|---|---|
| Initial open finding | `None` | `None` | `open` |
| User selects A/B/C/D | Selected value | Unchanged | `open` |
| User supplies candidate response | Selected value or `None` | Candidate response | `open` |
| User explicitly accepts response | Selected value or `None` | Accepted response | `open -> resolved` |
| Update resolved finding | Retained value | Retained response | `resolved` |

No selection creates a response. No selection or generated option resolves a finding. Resolved findings do not reopen.

## Consumer Contract

Consumers may read Question, Why It Matters, Response, Selected Option, and Status. Recommended Option and Alternative Options remain advisory and cannot be treated as authoritative decisions.

## Invariants

- `record_version == skill_version == 2.0.0`.
- `category` equals the fingerprint category segment.
- `total_findings = open_findings + resolved_findings` remains unchanged.
- Guidance generation and selection preserve source bytes.
- Invalid identity, traceability, selection, conflict, ownership, or version inputs produce no partial write.
- Guided resolution never approves governance, selects architecture, changes Discovery recommendations, changes ADR decisions, or resolves a finding automatically.
