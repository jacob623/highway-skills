# Research: Highway Setup NFR Handoff

## Decision 1: Keep the change in Setup and delegate all NFR behavior

- **Decision**: Add the Controls-to-NFR transition and successful conclusion to `highway-setup` only. Continue delegating NFR questions, recommendations, decisions, errors, and owner results unchanged.
- **Rationale**: The feature explicitly preserves NFR ownership and defers NFR collection semantics to a subsequent `highway-nfrs` change. Setup already owns transitions between domain chapters.
- **Alternatives considered**: Changing `highway-nfrs` now was rejected because it would expand scope and merge two independently testable ownership changes. Having Setup inspect candidate state was rejected because it violates the owner boundary.

## Decision 2: Gate the handoff on the first actual NFR-owned interaction

- **Decision**: Emit the transition only when fresh or pre-delegation Controls readiness is `Complete` and the current NFR owner requires a user interaction. Do not emit it for terminal NFR results such as `Not Applicable` that require no interaction.
- **Rationale**: The transition introduces the next interaction, not merely the existence of the NFR domain. This preserves the current NFR readiness contract while allowing the later NFR feature to make zero-candidate work interactive.
- **Alternatives considered**: Emitting on every NFR readiness request was rejected because it would produce a message with no interaction to introduce. Persisting a transition marker was rejected because Setup's New interaction semantics restore authoritative owner state, not transient presentation state.

## Decision 3: Support both Controls completion paths

- **Decision**: Cover both post-collection fresh Controls `Complete` and pre-delegation Controls `Complete` paths. The latter skips Controls discovery and proceeds toward NFR readiness, then uses the same handoff rule if an NFR interaction is required.
- **Rationale**: Existing Setup already has a pre-delegation `Complete` branch, and omitting it would leave established repositories without the new experience.
- **Alternatives considered**: Requiring every Setup run to delegate Controls was rejected because it would regress existing readiness semantics and owner routing.

## Decision 4: Replace the dashboard with a fixed, actionable conclusion

- **Decision**: Replace `Highway Setup Complete` and its owner summary fields with the specified forward-looking conclusion containing `/highway-help`; offer the command without invoking it.
- **Rationale**: The new output is the feature's observable completion contract and gives the user an actionable next step without adding a new owner or persistence boundary.
- **Alternatives considered**: Keeping the dashboard alongside the conclusion was rejected because the specification removes the dashboard. Auto-invoking help was rejected because Setup must only recommend the next action.

## Decision 5: Treat the Setup output change as a breaking skill-contract change

- **Decision**: Apply the repository Skill Versioning Policy to the Setup contract and classify the version change during implementation; run the required Constitution Compliance Review and applicable Experience Standard checks.
- **Rationale**: The successful output contract is removed and replaced, so the existing `highway-setup` contract changes materially.
- **Alternatives considered**: Treating the change as a documentation-only patch was rejected because the user-visible output and completion claim change.

## Decision 6: Use existing repository validation surfaces

- **Decision**: Extend the existing Setup contract and executable tests, preserve negative legacy-category checks, regenerate adapters/catalogs, and run the focused and full suites.
- **Rationale**: These checks already validate owner routing, field order, terminality, no-write behavior, and generated correspondence. Adding a parallel harness would duplicate governance infrastructure.
- **Alternatives considered**: Replacing existing tests with a new feature-only harness was rejected because it risks reducing regression coverage for the preserved Profile/Objectives/Controls paths.
