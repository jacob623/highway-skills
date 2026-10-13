# Research: Objective Archetypes

## Decision: Keep Objective Archetypes as source-skill guidance

**Rationale**: The feature changes how the existing Objective owner generates recommendations. The source `highway-objectives` skill is the authoritative shipped contract, while generated adapters are identity copies. Keeping archetypes in the skill avoids a new runtime dependency, persisted baseline, schema, or ownership boundary.

**Alternatives considered**: Persisting archetype records or adding a separate recommendation service was rejected because the feature explicitly limits archetypes to recommendation-generation guidance and forbids new durable artifacts or integrations.

## Decision: Use Profile-first generation with conditional coverage supplementation

**Rationale**: Accepted Profile evidence remains the strongest organizational grounding. Archetype-derived recommendations are added only when a meaningful uncovered area may benefit the organization, so the feature improves coverage without manufacturing recommendations or displacing Profile-derived outcomes.

**Alternatives considered**: Always presenting one recommendation from every family was rejected because it would create artificial volume and imply unsupported organizational needs.

## Decision: Keep archetype origin invisible in the recommendation set

**Rationale**: Users should receive understandable Objective outcomes, not internal recommendation categories or coverage mechanics. A unified set preserves the existing presentation, choice wording, user-authored alternative, Working Idea status, and acceptance boundary.

**Alternatives considered**: Labeling recommendations by family or source was rejected because the feature explicitly prohibits exposing archetype names, families, and internal coverage evaluation.

## Decision: Validate with a static contract test plus existing suite

**Rationale**: The repository's current Objective behavior is documented in Markdown and validated through Bash contract tests. A focused test can verify section placement, required families, Profile-first ordering, prohibited user-facing exposure, preserved lifecycle boundaries, and adapter equality. The full suite provides regression coverage for the rest of the shipped tree.

**Alternatives considered**: Runtime integration tests or a new executable recommendation engine were rejected because no runtime implementation or external interface is introduced by this feature.

## Decision: No external contract artifact

**Rationale**: The project exposes no API, command schema, or service interface for Objective recommendation generation. The user-facing contract is the skill guidance itself, covered by the source contract test and generated adapter correspondence.

**Alternatives considered**: A `contracts/` document was considered but would duplicate the owning skill contract without defining an external interface.
