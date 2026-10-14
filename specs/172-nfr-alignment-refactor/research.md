# Research: NFR Alignment Refactor

## Decision 1: Reuse the existing Objectives and Controls owner framework

**Decision**: Model NFR behavior with the same sequence used by the aligned owners: recommendation development, coverage evaluation, recommendation presentation, additional suggestions, recommendation boundaries, development lifecycle, queue and acceptance boundaries, interpretation confidence, contribution guidance, portfolio assessment, and continuation.

**Rationale**: The feature explicitly targets predictable owner behavior across Profile, Objectives, Controls, and NFRs. Existing owner contracts already define the vocabulary, acceptance boundary, user-authored path, and post-capture continuation pattern.

**Alternatives considered**: Preserve the current discovery-centric NFR flow; rejected because it would leave NFRs structurally inconsistent with Objectives and Controls and would keep questions ahead of grounded recommendations.

## Decision 2: Make recommendation exploration a transient pre-queue phase

**Decision**: Recommendations are provisional, selection creates ordered queue membership, and explicit exhaustion or user start intent ends exploration before queue processing begins.

**Rationale**: Separating exploration from processing prevents accidental capture and gives the person control over when the recommendation landscape is sufficient. It also makes the requested recommendation-exhaustion behavior testable without creating a new persisted state.

**Alternatives considered**: Begin proposal development immediately after the first selection; rejected because it prevents additional recommendation exploration and collapses selection with development.

## Decision 3: Treat accepted Controls as recommendation context, not NFR ownership

**Decision**: Accepted Controls may ground NFR recommendations, while NFR selection, proposal development, acceptance, capture, persistence, readiness, and relationship ownership remain with the NFR owner.

**Rationale**: This preserves the important Control-to-NFR relationship mapping while maintaining independent owner boundaries and avoiding the removed Control-derived candidate lifecycle.

**Alternatives considered**: Generate or persist NFR candidates automatically from Controls; rejected because Feature 171 removed that ownership model and the current feature explicitly preserves independent NFR ownership.

## Decision 4: Use internal coverage areas only for recommendation diversity

**Decision**: Use Reliability, Availability, Performance, Scalability, Security, Compliance, Maintainability, and Operability as internal guidance; do not expose, persist, or classify recommendations by these areas.

**Rationale**: Coverage evaluation can identify meaningful recommendation gaps without creating user-facing categories or additional lifecycle stages. This mirrors Control Coverage Areas while remaining NFR-specific.

**Alternatives considered**: Ask the person to choose a coverage area or persist an area on each NFR; rejected because coverage is recommendation logic, not user-owned NFR data.

## Decision 5: No external interface contract is needed

**Decision**: Document the skill's user-visible command and output contract in `contracts/nfr-interaction.md`; do not introduce an API, service, protocol, or runtime dependency.

**Rationale**: The project is an internal repository governance skill suite. Its external surface is the skill interaction and emitted NFR artifacts, which can be described as a contract without adding an implementation interface.

**Alternatives considered**: Define a network or library API contract; rejected because no such integration exists in the feature scope.

## Decision 6: Validate through existing focused and full-suite checks

**Decision**: Update only assertions whose expected NFR behavior changes, regenerate all derived artifacts, run focused NFR/relationship/readiness/output checks, and finish with `.highway/tools/tests/run-all.sh` plus `git diff --check`.

**Rationale**: Existing tests are the repository's established contract evidence. Reusing them limits scope and proves both source behavior and generated correspondence.

**Alternatives considered**: Add a parallel test harness; rejected because it would duplicate existing validation and add unnecessary maintenance surface.
