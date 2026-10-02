# Research: Profile Contribution-First Synchronization

## Decision 1: Consume the shared precedence rather than restating X2.13

- **Decision**: Profile guidance names the shared contribution precedence and applies it to Profile domains; it does not create a new Profile-local interaction rule.
- **Rationale**: The Experience Standard owns generic interaction behavior. Profile should define only its evidence sources, complete-domain conditions, domain-specific Working Ideas, and canonical fallback questions.
- **Alternatives considered**: Copying X2.13 into Profile was rejected because it would create competing normative authorities and increase future synchronization drift.

## Decision 2: Use three explicit Profile outcomes

- **Decision**: Evaluate each unresolved domain as: complete candidate -> Converged Proposal; incomplete but useful grounding -> Working Idea; neither responsible nor sufficient user-independent grounding -> focused canonical question.
- **Rationale**: This preserves the distinction between not being able to complete a domain and not being able to contribute anything useful.
- **Alternatives considered**: Retaining the phrase "grounding is insufficient" was rejected because it collapses incomplete proposal grounding into question fallback.

## Decision 3: Compound accepted context across domains

- **Decision**: Vision uses accepted Identity and other accepted Profile context; Competitive Path uses accepted Vision and accumulated Profile context; Guiding Principles uses accepted Identity, Vision, Competitive Path, and their relationships.
- **Rationale**: Profile already owns these evidence relationships and its prior collaborative-development work established contextual re-evaluation as the local domain behavior.
- **Alternatives considered**: Requiring each domain to begin from its own canonical question was rejected because it discards accepted context and reproduces the observed failure mode.

## Decision 4: Preserve the existing acceptance and persistence boundary

- **Decision**: Working Ideas remain transient; only a complete Converged Proposal crosses the existing acceptance boundary and can mutate the Profile.
- **Rationale**: The Profile schema and readiness model have no state for Working Ideas, and the Constitution requires accepted owner mutation before dependent results.
- **Alternatives considered**: Adding a provisional Profile state or persisting reasoning context was rejected because it changes schema and ownership scope without being required by the feature.

## Decision 5: Validate through existing Profile contracts and the full suite

- **Decision**: Update only directly affected Profile contract assertions if their exact text expectations are stale, then run the focused Profile matrix, UX alignment contract, schema checks, and `bash .highway/tools/tests/run-all.sh`.
- **Rationale**: The repository already has executable coverage for Profile structure, shared interaction alignment, ownership boundaries, and full-tree integrity.
- **Alternatives considered**: Adding a new persistence model or a separate integration harness was rejected because the change is document guidance and has no new external interface or stored data.
