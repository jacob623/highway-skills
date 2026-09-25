# Feature 091 Research

## Decision: Use existing Markdown skill and shell-test architecture

**Rationale**: The repository distributes instruction skills and governance documents. Existing validation is implemented by shell tests that inspect source documents and run disposable fixtures. No application runtime or external service is needed.

**Alternatives considered**: Introducing a runtime parser or service was rejected because it would create a second implementation authority and violate the repository's document-led distribution model.

## Decision: Make `profile.md` the only complete structural template

**Rationale**: The specification requires one reusable file skeleton at `.highway/library/templates/output/profile.md`, while the retained artifact lives at `.highway/library/knowledge/profile.md`. The skill cites the template instead of duplicating its complete structure.

**Alternatives considered**: Retaining the YAML template or embedding a second full Markdown skeleton in `SKILL.md` was rejected because both create competing authorities.

## Decision: Keep proposal and accepted evidence separate

**Rationale**: Initial Setup and Configure must be transient until acceptance. Readiness evaluates only the persisted artifact, and interrupted first setup must leave no authoritative Profile.

**Alternatives considered**: Persisting drafts or Setup checkpoints was rejected because it would make provisional evidence appear authoritative and conflict with the existing Setup resume model.

## Decision: Preserve owner boundaries

**Rationale**: `highway-profile` owns evidence, domain outcomes, readiness, and the Profile artifact. `highway-setup` consumes the four-line readiness contract and routes in order without recomputing readiness or writing owner artifacts.

**Alternatives considered**: Adding readiness logic to Setup was rejected because it would duplicate ownership and permit divergent completion decisions.

## Decision: Validate with focused fixtures and the existing full suite

**Rationale**: Deterministic fixtures can prove rendering, transitions, byte preservation, legacy YAML isolation, routing, and constitutional contract alignment without network access.

**Alternatives considered**: End-to-end service tests were rejected because no service boundary exists in this repository.
