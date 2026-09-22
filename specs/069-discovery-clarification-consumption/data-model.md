# Feature 069 Data Model

## Clarification Catalog Entry

| Field | Meaning | Constraints |
|---|---|---|
| Clarification ID | Stable consumer identity, `CLAR-<REQ-ID>` | Must equal the derived identifier for the resolved Request |
| Artifact ID | Source Request identity | Must equal the resolved `REQ######` |
| Artifact Type | Source artifact family | Must be `REQ` for this feature |
| Status | Producer-owned lifecycle state | Read-only; supported Clarification status |
| Clarification Path | Direct artifact path | Must resolve to the catalog-referenced artifact; never selected by recency or filesystem order |

Relationship: one resolved Request maps to zero or one authoritative catalog entry for this feature. A duplicate, stale, or path-mismatched mapping is unavailable to Discovery and never triggers a repair.

## Clarification Artifact

Discovery reads the producer-owned artifact without mutation.

| Field | Meaning | Consumer use |
|---|---|---|
| `id` | Stable `CLAR-REQ######` identity | Verify identity and traceability |
| `artifact_id` | Source Request identity | Verify Request linkage |
| `status` | `not-started`, `in-progress`, `complete`, or `blocked` | Explain availability and advisory state |
| `open_findings` | Count of unresolved findings | Project uncertainty and confidence rationale |
| `resolved_findings` | Count of resolved findings | Preserve complete finding context |
| `total_findings` | Count invariant | Validate `total = open + resolved` |
| `blocking_reason` | Producer diagnostic | Report advisory context when present; does not block Discovery |
| Findings | Finding identity, category, severity, state, summary, evidence reference | Project relevant findings into existing Discovery evidence sections |
| Responses | Accepted response text associated with findings | May contribute business evidence to Research Findings |

Validation requires the artifact identity, Request linkage, supported state values, count invariant, required finding structure, and privacy filtering contract to remain consistent with the existing Clarification artifact contract. Invalid or unreadable artifacts are ignored by Discovery.

## Advisory Clarification Evidence

A read-only projection created in Discovery memory from validated clarification fields. It has no persisted schema of its own.

- Response evidence is eligible for `Research Findings` after Request evidence and before Profile or later baselines.
- Open findings are eligible for `Assumptions` and `Unknowns`.
- Findings are eligible for `Risks` and confidence rationale.
- Resolved findings remain available for traceability when relevant but do not become requirements.
- No projected field changes candidate generation, scoring, ranking, ordering, recommendation totals, or recommendation selection.

## State and Failure Rules

- Clarification is optional; absent catalog or absent matching entry yields no projection.
- A referenced artifact that is unreadable or malformed yields no projection and may yield one deterministic advisory risk when relevant.
- Open findings remain advisory and never become a prerequisite for Discovery completion.
- Discovery never changes catalog rows, artifacts, findings, responses, revisions, or status.
- Identical closed inputs produce identical projections and output text.
