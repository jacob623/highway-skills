# Data Model: Control-Derived NFR Generation

## Control

- **Identity**: Immutable `CTLXXXXXX` identifier allocated by the existing Control catalog.
- **Owned fields**: Existing title, status, statement, rationale, and `nfrs` relationship list.
- **New behavior**: A successfully added Control may produce reviewable NFR candidates; accepted
  candidates append allocated NFR identifiers to `nfrs`.
- **Invariant**: Existing Control content and relationships are preserved unless the current
  accepted operation intentionally adds a new NFR ID.

## NFR Candidate

- **Identity**: Temporary proposal identity derived from its originating Control and stable rule
  order; it is not an allocated NFR identifier.
- **Fields**: Originating Control ID, originating Control title, candidate title, statement, rationale,
  and stable ordering position.
- **State**: Proposed, accepted, modified, replaced, rejected, or cancelled.
- **Invariant**: A candidate is never a persisted NFR record before review completion.

## NFR

- **Identity**: Immutable `NFRXXXXXX` identifier allocated from the existing NFR catalog `next_id`.
- **Owned fields**: Existing title, status, statement, rationale, and `controls` relationship list.
- **New behavior**: An NFR accepted through Control derivation stores the originating Control ID in
  `controls`; direct NFR authoring continues to use `controls: []`.
- **Invariant**: Every derived NFR has at least one originating Control ID.

## Review Decision

- **Scope**: One candidate at a time.
- **Actions**: Accept, Modify, Replace, Reject, or cancel the review.
- **Invariant**: Modify and Replace persist only the author-approved wording; Reject and cancellation
  persist no NFR-side artifact or relationship.

## Control-to-NFR Relationship

- **Representation**: Existing identifier-only fields: `Control.nfrs` and `NFR.controls`.
- **Cardinality**: One Control may reference many NFRs; each derived NFR references at least one
  originating Control.
- **Uniqueness**: Existing relationship IDs are preserved and duplicate IDs are not appended.
- **Forbidden**: Names, titles, mutable text, alternate relationship stores, and automatic repair.

## Candidate Generation Contract

- **Inputs**: Normalized Control title and statement only.
- **Rule order**: Fixed and repository-defined.
- **Outputs**: Stable candidate title, statement, rationale, originating Control details, and order.
- **Forbidden inputs**: Timestamp, randomness, environment value, current catalog ordering, and
  unrelated existing baseline content.
- **No-match result**: A valid Control with no matching rule remains valid and produces no NFR.

## Baseline and Catalog Preconditions

- Control catalog and record must be valid before candidate generation.
- NFR catalog must be present and internally consistent before accepted candidates are written.
- `next_id` must be safe to allocate and must not reuse a historical identifier.
- Accepted writes must preserve unrelated user-owned records and catalogs.
