# Research: Controls NFR Decoupling

## Decision 1: Remove the candidate-generation lifecycle at its ownership boundaries

- **Decision**: Remove candidate-generation inputs, outputs, state, recovery, readiness, review, blocking, and completion concepts from Controls, NFRs, Setup, and shared ownership surfaces.
- **Rationale**: The target ownership chain requires Controls and NFRs to be independent owners. Keeping any candidate lifecycle reference would preserve the coupling even if the primary Controls section were deleted.
- **Alternatives considered**: Keeping candidate generation as an optional compatibility path was rejected because it would retain cross-owner lifecycle ownership and stale state. Replacing it with a new Control-to-NFR event was rejected because direct NFR recommendation is explicitly deferred.

## Decision 2: Delete the framework-owned candidate-state artifact

- **Decision**: Remove `.highway/catalog/nfr-candidate-state.md` and all generated/catalog references to it.
- **Rationale**: The artifact exists only to persist the obsolete Control-derived candidate lifecycle. Once that lifecycle is removed, retaining the file would imply an active owner contract and create contradictory readiness semantics.
- **Alternatives considered**: Deprecating the file in place was rejected because the feature requires candidate state to be absent, not merely unused. Migrating it into user-owned NFR records was rejected because accepted records must not be silently rewritten.

## Decision 3: Preserve accepted records and relationships

- **Decision**: Remove generation and recovery behavior without deleting or rewriting existing accepted Control/NFR records or independent relationships solely because the lifecycle disappears.
- **Rationale**: The refactor changes ownership and active workflow, not user-authorized governance history. Existing record templates, identifiers, classification, persistence, and relationship semantics remain authoritative unless separately changed by the user.
- **Alternatives considered**: Backfilling or normalizing historical relationships during the refactor was rejected because it would create unrelated mutations and complicate rollback.

## Decision 4: Keep Controls aligned with Objectives through the existing proposal-first model

- **Decision**: Retain Controls' recommendation, development, explicit acceptance, capture, user-authored alternative, and continuation behavior in structural parallel with Objectives.
- **Rationale**: Feature 170 already established the interaction model. Feature 171 should remove coupling without reopening the interaction design or adding a second lifecycle abstraction.
- **Alternatives considered**: Reintroducing discovery-first Controls behavior was rejected because it would regress the established recommendation-first contract. Implementing direct NFR recommendations in this feature was rejected by clarification and remains follow-on work.

## Decision 5: Validate absence separately from preserved behavior

- **Decision**: Add explicit absence checks for candidate terminology and state references, while retaining executable tests for Control persistence, NFR readiness, relationships, Setup routing, and generated correspondence.
- **Rationale**: A static absence scan proves that stale ownership language is gone; it does not prove that preserved owner behavior still works. Both evidence types are required and must remain distinguishable.
- **Alternatives considered**: Relying on the existing full suite alone was rejected because existing tests may encode the obsolete contract. Replacing existing behavior tests with absence scans was rejected because it would lose regression coverage.

## Decision 6: No external contracts artifact

- **Decision**: Do not create `contracts/` for this feature.
- **Rationale**: The feature changes internal Markdown skill ownership contracts and shared repository artifacts; it introduces no new public API, endpoint, serialized interface, or external integration.
- **Alternatives considered**: Creating a duplicate cross-owner contract document was rejected because the authoritative skill files and shared templates already own these contracts.
