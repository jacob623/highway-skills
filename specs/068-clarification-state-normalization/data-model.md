# Data Model: Clarification State and Fingerprint Normalization

## Normalized Fingerprint Input

| Field | Definition | Invariant |
|---|---|---|
| Category | Finding category before fingerprint composition | Lowercase after normalization |
| Source field or section | Declared source location | Canonical declared name is used |
| Evidence reference | Deterministic source evidence identity | LF line endings, trimmed, lowercased, and whitespace-collapsed |
| Normalization order | LF, trim, lowercase, collapse whitespace, canonicalize source field | Order is fixed and applied before fingerprint generation |

## Finding Fingerprint

A fingerprint is the deterministic combination of normalized category, canonical source field or
section, and normalized evidence reference. Equal normalized inputs produce equal fingerprints.
Inputs that differ after normalization remain distinct. Fingerprint normalization is performed
before identifier matching, sequence allocation, or display ordering.

## Finding Identity Lifecycle

1. Normalize category, source field or section, and evidence reference.
2. Compose the deterministic fingerprint.
3. Match it against prior fingerprints in the clarification record.
4. Reuse the prior identifier when the fingerprint is unchanged.
5. Preserve the identifier when display ordering changes.
6. Allocate the next unused sequence for a new fingerprint.
7. Record removed sequences as retired and never reuse them.

## Clarification Finding State

| State | Meaning | Allowed transition |
|---|---|---|
| `open` | Finding requires an accepted response | `open` -> `resolved` |
| `resolved` | Finding has an accepted response | No further transition |

New findings begin `open`. A resolved finding retains its identifier, fingerprint, history, and
evidence references. No other state is valid, and a resolved finding cannot return to `open`.

## Clarification Record Counts

| Field | Definition | Invariant |
|---|---|---|
| `open_findings` | Number of findings whose state is `open` | Non-negative integer |
| `resolved_findings` | Number of findings whose state is `resolved` | Non-negative integer |
| `total_findings` | Total persisted findings | Equals `open_findings + resolved_findings` |

The count invariant is `total_findings = open_findings + resolved_findings`. A record with negative,
non-integer, or inconsistent counts is malformed and derives status `blocked`.

## Clarification Catalog Consistency

A catalog entry contains Clarification ID, Artifact ID, Artifact Type, Status, and informational
Clarification Path. The relationship is one-to-one:

- Every catalog entry resolves to one existing authoritative clarification artifact.
- Every authoritative clarification artifact has exactly one catalog entry when cataloged.
- Catalog status equals the clarification-artifact status.
- Clarification Path resolves directly to the referenced clarification artifact.
- Duplicate rows, missing rows, stale references, status mismatches, and path mismatches fail validation.

The clarification artifact remains authoritative for findings, states, counts, identity history,
responses, and content. The catalog is derived lookup state.

## Catalog Schema Version

The shared catalog template is version `1.1.0` because Clarification Path is a schema column. The
clarification record template is version `1.2.0` because it documents finding state and count
invariants. The `highway-clarify` skill is version `1.4.0` because its behavioral contract expands.
