# Feature 162 Research: Objectives Lifecycle Canonicalization

## Decision: Keep the existing source-and-adapter distribution model

- **Decision**: Edit `.highway/skills/highway-objectives/SKILL.md` as the source of truth and regenerate the four agent adapters.
- **Rationale**: The repository already treats the source skill as authoritative and validates adapter byte identity. This feature changes guidance text only.
- **Alternatives considered**: Editing adapters independently was rejected because it permits wording drift and violates the repository's generated-artifact contract.

## Decision: Preserve the existing Objective runtime and persistence contract

- **Decision**: Change lifecycle wording, proposal references, queue guidance, and acceptance terminology without changing Objective records, identifiers, catalogs, persistence, or acceptance mechanics.
- **Rationale**: The feature specification explicitly preserves those contracts, and the requested change distinguishes User Acceptance from review terminology rather than adding a new runtime state.
- **Alternatives considered**: Adding a new acceptance field or durable lifecycle state was rejected as out of scope and unnecessary for the requested clarification.

## Decision: Validate with static document contracts and the full repository suite

- **Decision**: Update the focused Objective lifecycle contract test to assert one canonical definition, User Acceptance sequencing, queue references, and the absence of preliminary/double-review interpretations; then run `.highway/tools/tests/run-all.sh`.
- **Rationale**: The behavior is encoded in skill guidance and distributed artifacts. Static checks are the repository's established instrument for this surface, while the full suite protects unrelated contracts.
- **Alternatives considered**: Adding a new runtime harness was rejected because the skill has no executable Objective conversation engine in this repository.

## Resolved Unknowns

- No technology, external service, storage, protocol, or deployment unknowns remain. The feature is a documentation and generated-artifact refinement within the existing Highway skill distribution.
