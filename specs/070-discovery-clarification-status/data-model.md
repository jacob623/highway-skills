# Data Model: Discovery Clarification Status Rules

## Clarification Status Projection

| Field | Meaning | Discovery rule |
|---|---|---|
| `not-started` | Clarification has not begun | Provide no Clarification evidence; continue normally |
| `in-progress` | Clarification has active work | Permit open-finding uncertainty and response evidence as advisory |
| `complete` | Clarification has resolved findings/responses | Permit accepted-response evidence; introduce no open-finding uncertainty |
| `blocked` | Clarification cannot complete normally | Permit advisory risk evidence; never block Discovery or ADR handoff |

## Clarification Finding

| Field | Meaning | Projection |
|---|---|---|
| Finding identity | Stable finding reference | Preserve source identity in advisory traceability |
| Finding state | Open or resolved lifecycle state | Controls uncertainty versus accepted-response projection |
| Summary | Business or technical ambiguity description | Open summaries may inform Assumptions, Unknowns, Risks, and rationale |
| Accepted response | Response owned by a resolved finding | May contribute to Research Findings |

## Request Evidence

The user-owned Request evidence is the authoritative baseline. Clarification responses may supplement,
explain, or clarify it but cannot overwrite, replace, or mutate it. Conflicts may produce advisory risk
evidence while preserving Request bytes.

## Clarification Validity

A catalog-linked artifact is consumable only when it is readable, structurally valid, internally
path/identity matched, uses a supported status, and has internally consistent finding counts and
states. Any failure makes the artifact unavailable as a whole. Discovery preserves all source bytes,
continues normally, and may record deterministic advisory risk evidence.

## Discovery Determinism Set

Identical values for Request, Clarification, Profile, Objective, Control, NFR, Reference Architecture,
and Reference Implementation inputs must yield identical Clarification resolution, evidence projection,
confidence rationale, candidate evaluation, recommendation totals, recommendation selection, and ADR
ownership.

## Relationships

- One completed Request derives at most one expected `CLAR-<REQ-ID>` identity.
- The Clarification Catalog maps that identity to zero or one authoritative artifact path.
- One Clarification artifact contains zero or more findings and responses.
- Discovery consumes the artifact read-only and projects advisory meaning into existing Discovery sections.
- Discovery remains the owner of candidate evaluation, recommendation, and ADR handoff.
