# Data Model: Reference Implementation Evaluation

## Reference Implementation

An optional repository-owned artifact representing an existing implementation related to one or more Reference Architectures.

| Field | Required | Validation | Meaning |
|---|---|---|---|
| Stable identifier | Yes | Present, valid, and unique within the authoritative catalog | Identity used for deduplication and traceability |
| Required fields | Yes | All catalog-required fields are present | Structural completeness |
| Reference Architecture references | No | Explicit identifiers only | Candidate matching evidence |
| Parseable representation | Yes | Artifact can be read and parsed | Structural validity |

A structurally malformed artifact is unparseable, lacks a valid stable identifier, or lacks required fields. An unresolved Reference Architecture reference is valid but produces no match.

## Reference Implementation Catalog

The authoritative collection of Reference Implementations used for evaluation.

| Field | Required | Validation | Meaning |
|---|---|---|---|
| Implementation entries | Yes when catalog exists | Each entry is independently evaluated | Evaluation input |
| Stable identifier index | Yes | No duplicate identifiers; duplicates make affected catalog data inconsistent | Deterministic identity |
| Readability | Yes | Unreadable catalog produces zero counts | Failure behavior |
| Authority | Yes | Only the authoritative catalog is evaluated | Prevents competing evidence sources |

A missing or unreadable catalog is a valid unavailable state and does not fail Discovery. Internal inconsistency is recorded and affected counts are zero.

## Reference Architecture Match

The existing Discovery relationship between a Candidate Solution Option and a Reference Architecture.

| Field | Required | Meaning |
|---|---|---|
| Reference Architecture identifier | Yes | Stable identity of the matched architecture |
| Match status | Yes | Whether the option has an explicit deterministic match |
| Match reason | Existing contract | Evidence supporting the match |

## Candidate Solution Option

An existing Discovery output option evaluated by the tie-break stage.

| Field | Required | Meaning |
|---|---|---|
| Discovery-scoped `OPT` identifier | Yes | Final fallback ordering key |
| Reference Architecture Matches | Existing contract | Architectures whose implementation counts may be considered |
| Recommendation score | Existing contract | Tie-break input; never changed by implementation evidence |
| Recommendation confidence | Existing contract | Must remain unchanged by implementation evidence |

## Reference Implementation Count

A derived value for an option or matched Reference Architecture:

1. Select implementations with explicit references to the relevant matched Reference Architecture.
2. Exclude malformed artifacts and unavailable artifacts.
3. Deduplicate by stable implementation identifier.
4. Count the remaining implementations.
5. For an option with multiple matched Reference Architectures, use the highest architecture-level count.

## Tie-Break Evaluation State

Tie-breaking is an ephemeral evaluation sequence, not a persisted decision record.

1. Compare Reference Architecture Match.
2. If still tied, compare Reference Implementation Count.
3. If still tied, compare the lowest Discovery-scoped `OPT` identifier.
4. Stop immediately after one option remains.

The result is advisory Recommendation selection evidence. ADR owns the eventual decision and its consequences.
