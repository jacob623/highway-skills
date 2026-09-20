# Data Model: Discovery Analysis

## Request Input

The single source artifact selected by an explicit `REQ` identifier.

| Field | Meaning | Validation |
|---|---|---|
| `id` | Permanent Request identifier | `REQ` followed by exactly six digits; invocation input must resolve uniquely |
| `status` | Request lifecycle state | Must expose the repository's completed state |
| `completeness` | Evidence completeness | Must be `Complete` before analysis |
| evidence domains | Business evidence used by extraction | Problem, Actors, Current Process, Desired Change, Success Measure, Business Constraints |
| `title` | Source title | Used for deterministic Discovery title derivation |

The Request is read-only and authoritative for business evidence.

## Discovery Record

A user-owned Markdown artifact at `discoveries/DISCXXXXXX.md`.

| Field | Meaning | Validation |
|---|---|---|
| `id` | Permanent Discovery identifier | `DISC` followed by exactly six digits, allocated only from catalog `Next ID` |
| `request` | Upstream Request reference | Exactly one valid `REQ` identifier |
| `status` | Discovery lifecycle state | `proposed` for Version 1 creation |
| title | Discovery heading | Matches explicit Request title or deterministic fallback |
| Request | Source evidence | Fixed template section; no invented business evidence |
| analysis sections | Findings, assumptions, risks, unknowns, approaches | Produced by the ordered rule set |
| relationship sections | Objective, Control, NFR candidates | Advisory only; identifier, rationale, confidence when present |

## Discovery Catalog

A user-owned Markdown artifact at `discoveries/discoveries.md`.

| Field | Meaning | Validation |
|---|---|---|
| `Version` | Catalog format version | `1.0.0` when bootstrapped; preserved thereafter |
| `Next ID` | Authoritative allocator state | `DISC` followed by exactly six digits |
| Discovery Index | Discoverable entries | Each entry has Discovery ID, Request ID, and Discovery Title exactly once |

The catalog contains no other top-level sections. Allocation never scans filenames.

## Analysis Section

A deterministic collection of generated observations. Each item has source category, source order or stable normalized key, and rendered text. Missing evidence creates an explicit assumption or unknown; it does not create a guessed fact.

## Relationship Candidate

An advisory reference from a Discovery to one existing Objective, Control, or NFR.

| Field | Meaning | Validation |
|---|---|---|
| identifier | Existing baseline identifier | Must resolve in the corresponding baseline |
| rationale | Why the candidate matched | Names the first matching rule and source evidence domain |
| confidence | Match strength | `High`, `Medium`, or `Low` |
| advisory | Ownership marker | Always true; does not create a governance relationship |

Confidence is assigned by precedence: explicit identifier reference = High; exact normalized title/statement match = Medium; at least two normalized non-stopword token matches = Low.

## State Transitions

### Transaction

`unresolved` -> `resolved` -> `analyzed` -> `validated` -> `allocated` -> `written`

Any failure before `written` transitions to `aborted`, preserves existing bytes, and produces no partial output. Catalog allocation conflict may return from `allocated` to `resolved` for at most three total attempts.

### Discovery status

Creation writes `proposed`. Approval, ADR creation, relationship mutation, and later lifecycle transitions are outside Version 1.

## Invariants

- Exactly one explicit completed Request is analyzed per invocation.
- The Request and governance baselines are read-only inputs.
- Discovery and catalog output are built and validated before either is written.
- A successful record is indexed exactly once and advances `Next ID` exactly once.
- Identical inputs and unchanged catalog state produce byte-identical record content.
- All generated collections have deterministic deduplication and ordering.
- Secrets and regulated personal data never appear in the written Discovery record.
- Relationship candidates are advisory observations and never mutate source baselines.
