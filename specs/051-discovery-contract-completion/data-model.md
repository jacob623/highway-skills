# Data Model: Discovery Contract Completion

## Discovery Output Contract

The user-owned output projection produced by a successful Discovery run.

| Field | Required | Validation | Meaning |
|---|---|---|---|
| Discovery identifier | Yes | `DISC` plus six digits and unique catalog allocation | Stable identity of the analysis record |
| Request identifier | Yes | `REQ` plus six digits and exactly one resolved completed Request | Source traceability |
| Record path | Yes | `discoveries/DISCXXXXXX.md` | User-owned Discovery record location |
| Catalog path | Yes | `discoveries/discoveries.md` | User-owned Discovery catalog location |
| Required sections | Yes | Shared record template order | Complete handoff content |
| Completion response | Yes | Names both identifiers and both paths | User-facing success confirmation |

Required record sections are Request Reference, Research Findings, Assumptions, Risks, Unknowns,
Candidate Solution Options, Candidate Solution Comparison Matrix, Recommendation, Objective
Relationships, Control Relationships, NFR Relationships, and Reference Architecture Matches.

## Reference Implementation

An optional implementation artifact with a stable identity and explicit Reference Architecture
references.

| Field | Required | Validation | Meaning |
|---|---|---|---|
| Stable identifier | Yes | Present and valid | Identity used for deduplication |
| Required fields | Yes | Present for the authoritative catalog schema | Structural completeness |
| Reference Architecture references | No | Explicit identifiers or references only | Matching evidence |
| Parseable representation | Yes | Readable and parseable | Structural validity |

Malformed artifacts are excluded when they are unparseable, lack a valid stable identifier, or
lack required fields. An unresolved Reference Architecture reference in an otherwise valid
artifact is a valid non-match.

## Reference Implementation Catalog

The authoritative collection evaluated by Discovery.

| Field | Required | Validation | Meaning |
|---|---|---|---|
| Implementation entries | Yes when catalog exists | Entries are independently evaluated | Evaluation input |
| Stable identifier index | Yes | Duplicate identifiers identify an inconsistency | Deterministic identity |
| Readability | Yes | Unreadable catalog yields zero affected counts | Failure behavior |
| Authority | Yes | Only the authoritative catalog is used | Prevents competing evidence sources |

An absent or unreadable catalog is an available zero-count state. An internally inconsistent
catalog excludes affected implementations, records the reason, and continues.

## Reference Architecture Match

The existing Discovery relationship between an option and a Reference Architecture.

| Field | Required | Meaning |
|---|---|---|
| Reference Architecture identifier | Yes | Stable identity of the matched architecture |
| Match status | Yes | Whether the option has an explicit match |
| Match reason | Yes | Evidence supporting the match |

## Candidate Solution Option

An existing Discovery output option evaluated by the tie-break stage.

| Field | Required | Meaning |
|---|---|---|
| Discovery-scoped `OPT` identifier | Yes | Final fallback ordering key |
| Reference Architecture matches | Yes | Architectures whose counts may be considered |
| Recommendation score | Yes | Tie-break trigger input; never changed by implementation evidence |
| Recommendation confidence | Yes | Preserved when implementation evidence is evaluated |

## Derived Values

### Reference Implementation Count

1. Select implementations with explicit references to a matched Reference Architecture.
2. Exclude unavailable, malformed, and affected inconsistent entries.
3. Deduplicate by stable implementation identifier.
4. Count the remaining matching identifiers.
5. For an option with multiple matched Reference Architectures, use the highest architecture-level count.

### Tie-Break Evaluation State

An ephemeral evaluation sequence:

1. Compare Reference Architecture Match.
2. If still tied, compare Reference Implementation Count.
3. If still tied, compare the lowest Discovery-scoped `OPT` identifier.
4. Stop immediately after one option remains.

The result is advisory evidence. ADR owns selection, rejection, acceptance, rationale, consequences,
decisions, and implementation authorization.
