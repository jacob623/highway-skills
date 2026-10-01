# Feature 116 Research

## Decision: Keep the authoritative source and generated distribution model

- **Decision**: Update `.highway/skills/highway-profile/SKILL.md`, then regenerate the four distributed Profile copies and the catalog artifacts.
- **Rationale**: The source skill is the maintained contract; generated copies and catalog entries are shipped outputs and must remain byte-consistent with it.
- **Alternatives considered**: Editing adapters directly was rejected because it violates generated artifact integrity and can leave the distribution inconsistent.

## Decision: Treat the first-time introduction as transient interaction state

- **Decision**: Emit the exact introduction only when Profile setup begins without a retained Profile, before the existing Repository Name question. Do not add a retained field or schema change.
- **Rationale**: The introduction describes the current interaction, not organizational evidence. Configure and resume already have a retained Profile and therefore do not need it repeated.
- **Alternatives considered**: Persisting an introduction-seen flag was rejected because it would change the retained record contract without adding Profile value.

## Decision: Represent enrichment as one recommendation per domain

- **Decision**: Preserve the existing internal grounding categories, but express supported Vision, Competitive Path, and Guiding Principles evidence as one cohesive paragraph recommendation per domain. Keep category names transient and hidden.
- **Rationale**: The requested user experience changes recommendation shape, not retained data shape or domain ownership. A single paragraph provides one review boundary while accepted evidence remains the domain narrative.
- **Alternatives considered**: Adding category fields to the retained Profile was rejected because categories are authoring inputs and the feature explicitly preserves schema 3.0.0.

## Decision: Preserve shared interaction ownership

- **Decision**: Profile defines domain-specific grounding and fallback content; the Highway Experience Standard remains authoritative for acceptance, alternatives, clarification handling, question order, and presentation.
- **Rationale**: Shared interaction rules must not be duplicated in a skill-specific contract where they could drift.
- **Alternatives considered**: Restating the generic acceptance model in Profile was rejected because it creates competing interaction contracts.

## Decision: Verify with focused Bash contracts and the full suite

- **Decision**: Amend focused Profile behavior and structural assertions, regenerate outputs, compare distributed copies, and run `.highway/tools/tests/run-all.sh`.
- **Rationale**: The change is a behavioral Markdown contract change with generated artifacts; executable checks are required for both behavior and distribution integrity.
- **Alternatives considered**: Markdown inspection alone was rejected because it cannot detect stale generated copies or regression in existing repository contracts.

## Open design questions

None remain that materially affect implementation or validation. Runtime performance, concurrency, and deployment concerns are outside this repository-local declarative contract and can be handled during implementation planning if encountered.
