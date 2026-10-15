# Research: Explicit ADR Option Selection

## Decision: Keep the change within the existing declarative skill contract

**Decision**: Update the canonical `highway-adr` skill, shared ADR record contract, focused ADR tests, and generated adapters/catalogs. Do not add a runtime service, parser, datastore, or new workflow owner.

**Rationale**: The repository treats `SKILL.md` and shared templates as authoritative behavior contracts. Existing tests already validate source preservation, identifiers, deterministic output, no-partial-write behavior, and generated correspondence.

**Alternatives considered**:

- Add executable ADR orchestration: rejected because the repository's current ADR behavior is represented by declarative contracts and existing test fixtures.
- Add a separate option-selection skill: rejected because ADR already owns decision selection and the feature explicitly changes that ownership boundary in place.

## Decision: Require explicit option input before allocation

**Decision**: Accept exactly one `DISC######` and one `OPT######` for creation. If the Discovery is valid but the option is omitted, render the decision prompt and stop before allocation or writes.

**Rationale**: This directly implements the user-owned decision boundary and makes the missing option path useful without turning recommendation logic into decision logic.

**Alternatives considered**:

- Select the only available option automatically: rejected because explicit selection is required even for a single-option Discovery.
- Preserve automatic tie-breaks as a fallback: rejected because recommendation and scoring are Discovery-owned advisory behavior, not ADR decision behavior.

## Decision: Preserve recommendation evidence without using it for selection

**Decision**: Keep Discovery recommendation, rationale, scores, and comparison matrix in the ADR input and prompt context. ADR records the explicit selected option even when it differs from the recommendation.

**Rationale**: Decision owners need the evidence to decide, while the record must distinguish advisory recommendation from user-owned decision.

**Alternatives considered**:

- Remove recommendation output from ADR context: rejected because it reduces decision quality and conflicts with existing Discovery ownership.
- Recompute or reinterpret scores in ADR: rejected because Discovery owns candidate generation, scoring, comparison, and recommendation.

## Decision: Validate option membership before any mutation

**Decision**: Reject malformed, unknown, duplicate, ambiguous, or cross-Discovery option input before identifier allocation, ADR publication, or catalog changes.

**Rationale**: Existing ADR contracts require source immutability and no partial output. Membership validation is the smallest check that prevents a decision from referencing an unavailable option.

**Alternatives considered**:

- Resolve an option globally and attach it to the supplied Discovery: rejected because option identity is scoped to its Discovery.
- Allocate then validate: rejected because allocation itself is a mutation forbidden on failure.

## Decision: Use contract tests and generator validation as the discriminating checks

**Decision**: Extend `highway-adr.test.sh` and relevant shared-template checks for exact invocation, prompt, selection ownership, option membership, no-write behavior, and removal of automatic selection language. Run canonical validators, regenerate catalogs/adapters, and run the full suite.

**Rationale**: These checks exercise the repository's established ownership and correspondence boundaries without introducing an alternate test harness.

**Alternatives considered**:

- Rely on documentation review alone: rejected because invocation and no-write regressions need repeatable assertions.
