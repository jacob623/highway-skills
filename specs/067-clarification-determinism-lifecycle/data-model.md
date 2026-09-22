# Data Model: Clarification Determinism and Lifecycle Contracts

## Clarification Finding

A finding is an evidence-backed result produced by the Clarify analysis contract.

| Field | Definition | Invariant |
|---|---|---|
| Finding ID | `CLAR-<ARTIFACT-ID>-NNN` | Stable for the lifetime of the finding; never reassigned after retirement |
| Category | Declared finding category, such as ambiguity or contradiction | Category ordering remains governed by the existing Clarify contract |
| Source field or section | The declared source location that produced the finding | Included in the finding fingerprint |
| Evidence reference | Deterministic reference to the source evidence | Included in the finding fingerprint; no semantic similarity |
| Fingerprint | Deterministic combination of category, source field/section, and evidence reference | Equal fingerprints map to the same identifier |
| State | Open or resolved according to the existing clarification record contract | State changes do not change identity |

## Finding Identity Lifecycle

1. Generate the fingerprint from the declared identity inputs.
2. Match it against prior fingerprints in the clarification record.
3. Reuse the prior finding ID when the fingerprint is unchanged.
4. Preserve the ID when display ordering changes.
5. Allocate the next unused sequence only for a new fingerprint.
6. Record removed sequence identifiers as retired.
7. Never allocate a retired sequence identifier again.

Removing `001` leaves `002` unchanged; a later finding receives a sequence greater than every allocated or retired sequence for that clarification.

## Ambiguity Vocabulary

The default vocabulary contains exactly:

- `TBD`
- `TBA`
- `unknown`
- `undecided`
- `unspecified`
- `not defined`
- `not determined`
- `pending`
- `future decision`
- `future work`

Profile extensions append phrases. They cannot remove or redefine defaults. Matching trims leading/trailing whitespace, compares case-insensitively, and requires exact normalized phrase equality. Partial-word, regular-expression, and semantic matching are outside the model.

Each matching term produces one ambiguity finding.

## Contradiction Rule

A contradiction rule is a declared record with these fields:

| Field | Definition | Required |
|---|---|---|
| Rule Identifier | Stable identifier for the declared rule | Yes |
| Artifact Type Scope | Supported artifact type to which the rule applies | Yes |
| Source Field A | First referenced field | Yes |
| Source Field B | Second referenced field | Yes |
| Contradiction Condition | Explicit deterministic condition | Yes |
| Finding Summary Template | Output summary for a matching contradiction | Yes |

A contradiction finding exists only when both source fields exist and the declared condition evaluates true. No general knowledge, architectural recommendation, semantic inference, probability, similarity score, or model judgment participates.

## Clarification Status

Status is selected once using this precedence:

1. `blocked`: the artifact exists but is malformed or violates required structure.
2. `complete`: the record is valid and `open_findings` equals zero.
3. `in-progress`: the record is valid and `open_findings` is greater than zero.
4. `not-started`: the clarification artifact does not exist.

The first matching condition wins. A status cannot be selected from multiple branches.

## Clarification Catalog Row

| Field | Definition | Invariant |
|---|---|---|
| Clarification ID | `CLAR-<ARTIFACT-ID>` catalog identity | Exactly one row per clarification |
| Artifact ID | Source artifact identifier | Supported uppercase `REQ`, `DISC`, `ADR`, or `RA` plus six digits |
| Artifact Type | Source artifact family | One of `REQ`, `DISC`, `ADR`, or `RA` |
| Status | Mirror of the authoritative clarification status | One of `not-started`, `in-progress`, `complete`, or `blocked`; must agree with the artifact |
| Clarification Path | Informational path to the authoritative clarification artifact | Resolves directly to the existing artifact |

Rows are ordered by Artifact Type, then Artifact ID. Clarification ID and artifact mapping are unique.

## Catalog Lifecycle

- **Bootstrap**: when the catalog is absent, construct it in memory from the authoritative shared template, insert the proposed row, and validate it using the existing-catalog rules.
- **Generate/Update**: validate the clarification and proposed catalog before writing either artifact; replace the matching row rather than appending a duplicate.
- **Failure**: preserve all pre-operation bytes when validation or a write fails.
- **Determinism**: identical inputs produce identical findings, IDs, status, paths, row ordering, and catalog bytes.

## Relationships

- One source artifact has at most one authoritative clarification artifact.
- One clarification artifact has exactly one catalog row when it is cataloged.
- A catalog row references its clarification artifact through both stable identity and the informational path.
- The catalog is derived state; clarification content, findings, identity history, and status remain authoritative in the clarification artifact.
