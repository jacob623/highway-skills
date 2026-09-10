# Data Model: Relationship Reconciliation and Integrity Management

## Relationship Graph

- **Storage**: Existing identifier-only `Control.nfrs` and `NFR.controls` fields.
- **Node types**: Control and NFR records identified by immutable `CTLXXXXXX` and `NFRXXXXXX` IDs.
- **Edge**: A source record's relationship list contains the target immutable ID.
- **Validity**: Both nodes exist, have the expected type and identifier format, and contain the
  reciprocal edge.
- **Invariant**: No title, path, statement, rationale, status, or generated sidecar is a relationship.

## Integrity Finding

- **Fields**: Finding class, source artifact type/ID/path, target artifact type/ID when available,
  current state, expected state, reason, and impact.
- **Classes**: Valid, malformed, orphaned, asymmetric, duplicate, or blocked baseline.
- **Ordering**: Canonical source type, source ID, target type, target ID, then class.
- **Invariant**: A finding is derived from the current baseline and does not mutate it.

## Repair Recommendation

- **Fields**: Affected artifact and immutable ID, current relationship state, proposed relationship
  state, reason, impact, and stable recommendation key.
- **Operations**: Add one missing reciprocal ID, remove one orphan ID, or remove an approved duplicate
  relationship value where the contract permits it.
- **Invariant**: Recommendations change relationship fields only and never change artifact content.

## Repair Decision

- **States**: Proposed, approved, rejected, cancelled, or incomplete.
- **Scope**: Decisions may be made independently for each recommendation.
- **Invariant**: Only explicitly approved recommendations enter the staged repair set. Rejection,
  cancellation, or incompleteness results in no write for that recommendation or operation.

## Impact Analysis

- **Inputs**: A requested Control removal, NFR removal, or baseline replacement.
- **Fields**: Operation, artifact being removed, affected identifier, affected title, relationship
  direction, and resulting traceability loss.
- **Invariant**: Every affected identifier/title is listed individually; counts cannot replace the list.

## Integrity Report

- **Sections**: Relationship Summary, Valid Relationships, Broken Relationships, Asymmetric
  Relationships, Orphan References, Required Repairs, and Blocking Conditions.
- **Properties**: Read-only, deterministic, timestamp-free, and stable for identical baselines.
- **Invariant**: Direct NFRs with `controls: []` are valid unlinked records and require no inferred edge.

## Baseline Snapshot

- **Contents**: Validated Control/NFR records, catalogs, relationship fields, and file bytes before
  a proposed repair.
- **Use**: Detect concurrent or unexpected changes before commit and support zero-partial-write
  behavior.
- **Invariant**: A repair cannot commit against a changed or invalid expected baseline.
