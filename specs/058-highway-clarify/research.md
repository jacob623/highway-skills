# Research: Highway Clarify

## Decision 1: Use Markdown with YAML frontmatter

**Decision**: Store each clarification artifact as Markdown with YAML frontmatter and structured body sections.

**Rationale**: Existing Highway output artifacts use this convention, shared templates own structure, and maintainers can inspect records without a separate serializer. The format supports stable metadata for identifiers, status, revision, source path, and blocking state while keeping findings and history readable.

**Alternatives considered**:

- JSON: machine-friendly but inconsistent with the repository's retained artifact conventions and less readable for maintainers.
- YAML: readable but lacks the existing Markdown body structure used by Highway records.

## Decision 2: Resolve sources through declared deterministic mappings

**Decision**: Resolve REQ, DISC, ADR, and RA identifiers through exact uppercase identifier validation followed by declared path, catalog, or identifier lookup precedence.

**Rationale**: The specification prohibits filesystem ordering, timestamps, recency, and newest-file selection. Existing Highway skills treat catalogs and declared artifact paths as authoritative inputs.

**Alternatives considered**:

- Directory scanning: rejected because filesystem order and duplicate paths make results unstable.
- Case normalization: rejected because the accepted clarification requires uppercase case-sensitive identifiers.

## Decision 3: Use optimistic concurrency with integer revisions

**Decision**: Store an integer revision in clarification metadata. Update reads the revision, stages changes, rechecks the revision immediately before commit, aborts on mismatch, increments by exactly one after success, and permits no automatic merge.

**Rationale**: Revision comparison detects lost-update races without timestamps or external services. Abort-on-conflict preserves bytes and history; a maximum of three retries bounds caller behavior.

**Alternatives considered**:

- Last-write-wins: rejected because it silently loses responses or history.
- Automatic merge: rejected because merging findings, statuses, metadata, and history creates ambiguous outcomes.
- Timestamp comparison: rejected because the feature requires deterministic behavior independent of wall-clock time.

## Decision 4: Keep clarification advisory

**Decision**: Open findings never block downstream source consumption. Status, severity, and open findings remain exposed through consumer contracts.

**Rationale**: Clarification supplements authoritative artifacts and does not become an approval gate or ownership boundary. Downstream workflows decide how to act on advisory state.

**Alternatives considered**:

- Block on every open finding: rejected because it turns supplemental clarification into an implicit lifecycle gate.
- Block only high severity: rejected because the accepted answer explicitly keeps all clarification advisory.

## Decision 5: Preserve repository-wide command access

**Decision**: Any repository user may invoke Generate, Update, Inspect, Read, and Status, subject to existing repository access controls and write-safety rules.

**Rationale**: The feature adds no role-specific authorization model and must remain usable by existing repository workflows.

**Alternatives considered**:

- Governance-owner-only writes: rejected because it adds an ownership gate outside the requested lifecycle.
- Maintainer-only writes: rejected for the same reason.

## Decision 6: Reuse repository validation and generation patterns

**Decision**: Add a focused mixed contract/fixture test with declared artifact classes and seeded probes; run skill/library validators, catalog generation, adapter generation, correspondence checks, and the full suite.

**Rationale**: Existing Highway skills use this evidence pattern to separate static document-contract checks, disposable behavior fixtures, generated outputs, and final suite results. No new runtime dependency is needed.

**Alternatives considered**:

- Introduce an executable runtime service: rejected because Highway skills are Markdown workflows and the repository's current implementation surface is skill text plus shell validation.
- Static text checks only: rejected because source immutability, revision conflicts, no-write failures, and deterministic repeats require fixture-level behavior evidence.
