# Research: Profile Simplification Pass

## Decision: Keep the Profile source as the sole behavior owner

- **Decision**: Make the existing Discovery Contribution Opportunity sections the only general development model in the Profile guidance.
- **Rationale**: The four domain opportunities already define accepted evidence, proposed starting point, reaction, refinement, and convergence. Removing competing sections reduces ambiguity without adding behavior or a new owner.
- **Alternatives considered**: Retaining the older sections as advisory appendices was rejected because their separate question, contribution, possibility-list, structure, and expression mechanics would continue to compete with the opportunity model.

## Decision: Fold structure-revealing reasoning into each opportunity

- **Decision**: Add the required structure-revealing sentence to Identity, Vision, Competitive Path, and Guiding Principles Discovery Contribution Opportunities.
- **Rationale**: Relationships, patterns, tensions, tradeoffs, implications, dependencies, and organizing principles remain useful, but the active proposed starting point is the existing place for the person to review and change them.
- **Alternatives considered**: Keeping a standalone Structure-revealing contributions section was rejected because it creates a second contribution mechanism.

## Decision: Preserve Interpretation confidence unchanged

- **Decision**: Keep the current Interpretation confidence guidance without expanding it with retired section details.
- **Rationale**: It already states the proposal-first preference and the fallback for unsupported starting points.
- **Alternatives considered**: Moving all retired guidance into Interpretation confidence was rejected because that would preserve the competing interaction model under a new heading.

## Decision: Update only directly coupled verification contracts

- **Decision**: Remove verification claims tied specifically to retired sections and update the directly corresponding static tests; retain protected lifecycle and ownership assertions.
- **Rationale**: Verification must describe the active model, while acceptance, persistence, readiness, attribution, schema, and convergence guarantees remain protected.
- **Alternatives considered**: Broadly rewriting unrelated Profile tests was rejected because it would increase scope without changing the requested behavior.

## Decision: Regenerate all distributed artifacts

- **Decision**: Regenerate the four Profile adapters, catalog indexes, and adapter manifest from the authoritative source.
- **Rationale**: Generated correspondence is a repository requirement and prevents stale delivery surfaces.
- **Alternatives considered**: Manual adapter edits were rejected because the source-first generator is the authoritative distribution path.
