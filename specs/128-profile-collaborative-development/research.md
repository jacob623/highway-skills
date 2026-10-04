# Research: Profile Collaborative Development

## Decision 1: Keep the implementation centered on the Profile skill

**Decision**: Make `.highway/skills/highway-profile/SKILL.md` the behavior-owning source for this feature. Treat the Profile record template and shared governance documents as protected dependencies.

**Rationale**: The request makes Profile the first concrete domain implementation while the Constitution, Highway Identity, and Experience Standard already own generic collaborative behavior. Duplicating shared guidance would create competing contracts.

**Alternatives considered**:
- Modify the shared Experience Standard again: rejected because Feature 127 established the shared model.
- Modify `profile-record.md`: rejected because retained structure and schema semantics are explicitly protected.
- Update all domain skills together: rejected because this feature is the Profile rollout; later domain migrations can follow the shared model.

## Decision 2: Model collaboration as transient Working Ideas converging into accepted domain narratives

**Decision**: Use Working Idea and Converged Proposal as interaction concepts only. Persist only accepted organizational narrative after the existing Profile acceptance boundary.

**Rationale**: The Constitution and Experience Standard separate conversational development from retained artifact structure. This preserves the existing schema and prevents readiness from being overloaded with conversational maturity.

**Alternatives considered**:
- Add Working Idea or maturity fields to Profile records: rejected because the request preserves schema `3.0.0` and the three readiness states.
- Treat every recommendation as a Converged Proposal: rejected because it recreates the immediate-acceptance conflict this feature resolves.

## Decision 3: Use contextual re-evaluation instead of a prescribed acknowledgment bridge

**Decision**: After persistence, Profile re-evaluates accepted knowledge with accumulated accepted Profile context and contributes only useful interpretation, sharpening, implications, relationships, tensions, opportunities, concerns, or recommendations.

**Rationale**: This directly applies X2.8 and the shared contextual re-evaluation guidance without manufacturing commentary or requiring a formula between domains.

**Alternatives considered**:
- Preserve `Acknowledge -> Introduce -> Suggest -> Validate`: rejected because it makes acknowledgment a local lifecycle stage and conflicts with the shared model.
- Ban all natural acknowledgment language: rejected because natural conversational language remains allowed; only the prescribed stage is removed.

## Decision 4: Keep enrichment categories as internal reasoning aids

**Decision**: Preserve existing Vision, Competitive Path, and Guiding Principles enrichment categories for completeness evaluation, but do not expose them as fields or require one question per category.

**Rationale**: The retained template owns artifact structure, while the Constitution separates conversational discovery from artifact fields. This allows coherent narratives without forcing schema-shaped conversations.

**Alternatives considered**:
- Ask one question for every category: rejected because it increases user effort and makes the artifact structure dictate conversation order.
- Remove categories: rejected because existing Profile reasoning coverage remains useful.

## Decision 5: Preserve the existing domain validation and mutation boundary

**Decision**: Keep the canonical domain validation wording and the ordering `Converged Proposal -> user acceptance -> Profile mutation -> persisted accepted knowledge -> dependent owner result`.

**Rationale**: The feature changes when and how a candidate is developed, not what constitutes accepted retained Profile knowledge or how owner-controlled completion works.

**Alternatives considered**:
- Introduce a new confirmation step: rejected because X2.18 permits natural acceptance of an explicitly presented complete candidate without redundant confirmation.
- Persist a Working Idea on casual agreement: rejected because that would make readiness and retained knowledge disagree with the acceptance boundary.

## Decision 6: Validate source content, directly affected contracts, and generated correspondence

**Decision**: Update stale Profile-specific assertions where they encode the superseded rhythm, preserve meaningful coverage, run focused Profile/UX checks, verify generated correspondence, and run the full suite.

**Rationale**: Existing tests are executable contracts and some currently assert the old Profile interaction. The repository Constitution also requires generated outputs to remain synchronized when a skill input changes.

**Alternatives considered**:
- Leave stale tests unchanged: rejected because the suite would fail against the intended behavior.
- Remove broad Profile checks: rejected because preserving regression coverage is required.
- Hand-edit generated adapters or catalogs: rejected because generators own those artifacts.

## Decision 7: No external interface contract artifact

**Decision**: Do not create a `contracts/` artifact for APIs or schemas. Document the user-visible Profile interaction and validation contract in the plan, data model, and quickstart instead.

**Rationale**: This feature changes an internal governance skill document and its emitted conversational contract; it does not expose a network API, library interface, or new persisted data format.

**Alternatives considered**:
- Add an API contract: rejected because no API exists.
- Add a new Profile schema contract: rejected because the schema is explicitly unchanged.
