# Research: Control-Derived NFR Generation

## Decision: Extend the existing Control workflow

**Decision**: Make `highway-controls` the initiation point for candidate generation immediately after
successful Control creation, while keeping final NFR authoring and acceptance user-owned.

**Rationale**: Controls already allocate the originating immutable identifier and own the add
workflow. Starting from NFRs would reverse the requested authority and make the originating Control
ambiguous.

**Alternatives considered**:

- Generate candidates from `highway-nfrs`: rejected because this phase establishes Controls as the
  authoritative source.
- Add a third relationship service or store: rejected because the existing record fields already
  represent both directions and a second store would create competing ownership.

## Decision: Use a fixed, content-only candidate rule table

**Decision**: Normalize the Control title and statement, evaluate a fixed ordered rule table, and
render stable candidate fields from matched rules. An unmatched valid Control returns zero candidates
without creating an NFR.

**Rationale**: A rule table makes deterministic behavior inspectable and testable. Restricting
inputs to Control content prevents timestamps, random values, environment values, and catalog order
from affecting output.

**Alternatives considered**:

- Free-form model-generated proposals: rejected because output stability and reproducibility cannot
  be guaranteed by the feature contract.
- Derive candidates from existing NFR catalog order: rejected because catalog order is explicitly
  excluded from generation inputs.
- Always create a generic NFR: rejected because a valid Control may remain without a derived NFR when
  no suitable candidate exists.

## Decision: Make review a hard write barrier

**Decision**: Render all candidate details before allocating an NFR ID or writing an NFR, catalog,
or relationship. Process independent review decisions in stable candidate order.

**Rationale**: This preserves complete user ownership and makes rejection/cancellation provably
side-effect free.

**Alternatives considered**:

- Create draft NFR files before review: rejected because the specification requires no NFR artifact
  before confirmation.
- Review only after automatic creation: rejected because it allows unapproved governance content to
  enter the baseline.

## Decision: Reuse existing relationship and allocation contracts

**Decision**: Accepted derived NFRs use `controls: [CTL...]`; the originating Control appends the new
NFR ID to `nfrs`. Allocation uses the existing NFR catalog `next_id`; direct NFR authoring continues
with `controls: []`.

**Rationale**: This activates the reserved fields without changing record formats or introducing a
new relationship mechanism.

**Alternatives considered**:

- Recompute identifiers from present files: rejected because existing governance rules make IDs
  immutable and non-reusable.
- Add a relationship index: rejected by the explicit no-additional-store requirement.
- Populate relationships for manually authored NFRs: rejected because only accepted derived NFRs
  receive Control links in this phase.

## Decision: Fail before partial writes on invalid state

**Decision**: Validate the Control, NFR catalog, allocation state, and relationship preconditions
before committing accepted candidates; focused tests snapshot user-owned files around every failure
path.

**Rationale**: Governance artifacts are user-owned, and partial writes could create an NFR without a
Control link or a Control link without an NFR.

**Alternatives considered**:

- Write each accepted candidate independently and report later failures: rejected because it can
  leave asymmetric relationships.
- Repair broken links during creation: deferred to Phase 4 as reconciliation behavior.
