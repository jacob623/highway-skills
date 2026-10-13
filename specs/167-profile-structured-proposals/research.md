# Research: Profile Structured Proposals

## Decision: Keep proposal-first behavior in the source Profile skill

**Rationale**: The feature changes the existing Profile owner's interaction guidance. The source
`highway-profile` skill is the authoritative shipped contract, while the four agent-facing copies
are generated identity adapters. Keeping the behavior in the skill avoids a new runtime service,
persisted baseline, schema, or ownership boundary.

**Alternatives considered**: Adding a separate proposal engine or persisted interpretation records
was rejected because the feature explicitly preserves existing Profile ownership, acceptance,
persistence, and lifecycle behavior.

## Decision: Reuse the Identity Discovery Contribution Opportunity pattern

**Rationale**: Identity already demonstrates the required provisional, correction-oriented flow:
accepted context supports a structured contribution opportunity, the person reacts, the working
understanding is re-synthesized, and normal convergence follows. Applying that pattern to Vision,
Competitive Path, and Guiding Principles keeps the experience coherent.

**Alternatives considered**: Creating three unrelated interaction patterns was rejected because it
would increase behavioral drift and make the Profile domains inconsistent.

## Decision: Use domain-visible structured items, not narrative proposals

**Rationale**: Vision and Competitive Path need visible, reviewable elements of the interpretation;
Guiding Principles need individually visible values. Structured bullets make additions, corrections,
removals, and comparisons easier while keeping each result a Working Idea.

**Alternatives considered**: Narrative paragraphs were rejected because they hide the domain's
substance and make targeted correction harder.

## Decision: Preserve focused questions as an evidence-insufficiency fallback

**Rationale**: The Profile domains remain discovery domains. A starting point is preferred only when
accepted evidence supports a responsible interpretation; otherwise the workflow must ask the one
consequential question that accepted context cannot resolve.

**Alternatives considered**: Always presenting a proposal was rejected because it would manufacture
unsupported organizational meaning and conflict with the user's authority.

## Decision: Validate through one focused static contract and the existing suite

**Rationale**: The implementation surface is Markdown guidance and generated adapters. A focused
Bash contract can verify section placement, structured presentation requirements, provisional and
fallback boundaries, preserved lifecycle language, and adapter equality. The full suite catches
regressions in shared Profile behavior.

**Alternatives considered**: Runtime integration tests or an external interface contract were
rejected because this feature introduces no executable service, API, or persisted data model.

## Decision: No external contract artifact

**Rationale**: The repository exposes no external API or command schema for Profile interaction. The
user-visible contract is owned by the Profile skill and verified by its static contract test.

**Alternatives considered**: A separate `contracts/` document was considered but would duplicate the
owning skill contract without defining an external interface.
