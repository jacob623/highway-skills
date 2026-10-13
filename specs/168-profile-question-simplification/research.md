# Research: Profile Question-Bias Simplification

**Feature**: 168 | **Date**: 2026-10-13

## Decision: Keep the authoritative Profile source as the only behavioral owner

**Rationale**: The repository already treats `.highway/skills/highway-profile/SKILL.md` as the source document and generates the four agent adapters from it. Editing the source preserves the established ownership and avoids divergent guidance.

**Alternatives considered**:

- Editing each adapter independently: rejected because it creates generated-artifact drift.
- Adding a new shared guidance artifact: rejected because the requested behavior is Profile-owned and no shared library boundary is needed.

## Decision: Model the change as transient interaction guidance, not durable data

**Rationale**: The simplification changes how accepted evidence is expressed during conversation. It does not add Profile fields, persisted proposals, readiness dimensions, lifecycle states, or owner results.

**Alternatives considered**:

- Adding a persisted advisory or proposal record: rejected because the existing Discovery Contribution Opportunity is transient and the feature explicitly preserves current persistence boundaries.
- Adding a new workflow state: rejected because existing convergence and acceptance behavior already provides the required lifecycle.

## Decision: Questions remain an exception for consequential ambiguity and missing user-owned evidence

**Rationale**: The Experience Standard requires questions to resolve result-changing uncertainty. Removing all questions would weaken accuracy and conflict with canonical fallback behavior. The intended change is to remove automatic question closure when a responsible structured starting point can carry the reasoning.

**Alternatives considered**:

- Remove advisory questions entirely: rejected because consequential ambiguity still requires clarification.
- Keep the existing advisory-question default: rejected because it competes with the proposal-first Discovery Contribution Opportunities.

## Decision: Validate with a focused static document contract plus existing repository checks

**Rationale**: The project validates source Markdown and generated correspondence with Bash contracts. A focused contract can verify the absence of the three question-centric examples, the replacement wording, preservation of the counter-example, and adapter equality while the existing suite protects broader Profile behavior.

**Alternatives considered**:

- Runtime conversational evaluation as the only gate: rejected because no runtime harness is defined for this repository and static contracts are the established evidence boundary.
- No new focused contract: rejected because the simplification has several negative requirements that broad tests may not protect directly.

## Resolved Planning Unknowns

- No external service, API, protocol, database, or framework selection is required.
- No performance, availability, security, privacy, or compliance change is introduced.
- The only generated surfaces are the existing Profile adapters, catalog artifacts, and adapter manifest.
