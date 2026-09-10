# Research: Relationship Reconciliation and Integrity Management

## Decision: Add an independent relationship skill

**Decision**: Create `highway-relationships` as the owner of graph inspection, repair proposals,
confirmation, and relationship-only repair.

**Rationale**: Relationship validation must be independently invocable from Control and NFR
creation. Embedding it in either authoring skill would create circular ownership and make inspection
unavailable when neither artifact is being created.

**Alternatives considered**:

- Add reconciliation to `highway-controls`: rejected because NFR-originated references and
  independent graph inspection would remain outside the owner.
- Add reconciliation to `highway-nfrs`: rejected for the symmetric reason.
- Add a new relationship database: rejected because the existing fields are the declared source of
  truth and a second store would drift.

## Decision: Keep existing relationship fields as the graph store

**Decision**: Read and update only `Control.nfrs` and `NFR.controls`; preserve the record formats and
all non-relationship content.

**Rationale**: Phase 030 activated these fields specifically for identifier-only traceability. A
schema or storage change would broaden scope and create migration risk without adding integrity value.

**Alternatives considered**:

- Add a graph index or sidecar file: rejected by the no-new-store boundary.
- Store titles or paths in relationships: rejected because identifiers are immutable and titles are
  user-editable.

## Decision: Use canonical edge and finding ordering

**Decision**: Normalize records and relationship IDs, then order output by source type, source ID,
target type, target ID, and finding class.

**Rationale**: Filesystem order, YAML order, and catalog order are not reliable semantic inputs.
Canonical ordering makes repeated reports, proposals, and repair outputs comparable and auditable.

**Alternatives considered**:

- Preserve file or frontmatter order: rejected because manual reorderings would change governance
  output without changing meaning.
- Sort by title: rejected because titles are mutable and not relationship identity.

## Decision: Make inspection read-only and repair confirmation-gated

**Decision**: Inspect mode never writes. Repair mode always renders recommendations with current state,
proposed state, reason, and impact before requiring explicit confirmation.

**Rationale**: Governance relationships are user-owned content. Silent repair would erase the user's
ability to review orphan removal or reciprocal additions.

**Alternatives considered**:

- Repair automatically during inspection: rejected because inspection is explicitly read-only.
- Ask for one global confirmation without per-finding selection: rejected because independent repair
  approval is required for mixed findings.

## Decision: Validate and stage before committing repairs

**Decision**: Validate the baseline, selected recommendations, expected snapshots, and both sides of
each relationship before applying any selected change.

**Rationale**: A relationship repair that updates only one side is worse than a visible finding. A
precommit validation boundary supports the zero-partial-write requirement.

**Alternatives considered**:

- Apply recommendations one file at a time: rejected because later failure can leave asymmetric
  state.
- Repair all findings in place: rejected because authors must be able to approve a subset.

## Decision: Keep destructive impact analysis with existing artifact owners

**Decision**: `highway-controls` and `highway-nfrs` remain responsible for removing or replacing their
own records, but must obtain relationship impact analysis before destructive confirmation.

**Rationale**: The relationship skill can report affected edges without taking ownership of record
lifecycle, version increments, or deletion semantics.

**Alternatives considered**:

- Move removal workflows into `highway-relationships`: rejected because it would couple graph
  maintenance to artifact deletion and violate single ownership.
- Repair automatically when an artifact is removed: rejected; removal impact must be shown and the
  user must confirm the destructive action first.
