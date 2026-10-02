# Research: Experience Contribution Precedence

## Decision 1: Amend the shared Experience Standard only

**Decision**: Implement the feature in `.highway/governance/experience-standard.md` and do not modify individual skills or retained artifact templates.

**Rationale**: The requested behavior is shared interaction policy, and the specification explicitly defers Profile, Objectives, Controls, and NFR synchronization. Keeping one authoritative source prevents local copies from redefining the precedence.

**Alternatives considered**: Updating Profile immediately was rejected because the shared standard must become authoritative first. Updating every consuming skill in this feature was rejected because it would widen the change beyond the requested amendment.

## Decision 2: Use explicit contribution precedence

**Decision**: State the order as Converged Proposal, useful Working Idea, then focused unresolved question.

**Rationale**: The existing standard already defines both recommendation forms and requires grounded contribution before questions, but it does not explicitly distinguish incomplete artifact grounding from absence of useful contribution. The ordered rule closes that decision gap.

**Alternatives considered**: Retaining the current generic “grounded recommendations” wording was rejected because it permits premature questioning when a useful Working Idea is available. Making Working Ideas mandatory before every question was rejected because mature contributions may converge immediately and no useful contribution should be forced.

## Decision 3: Keep acceptance and ownership boundaries unchanged

**Decision**: Treat Working Ideas as transient collaborative development and keep Converged Proposal acceptance governed by existing rules, including X2.18, X2.19, X2.21, X2.22, and X2.25.

**Rationale**: Contribution-first behavior must help the person think without turning suggestions into accepted organizational truth or altering artifact persistence.

**Alternatives considered**: Introducing provisional acceptance or new rule IDs was rejected because the current standard already distinguishes the forms and explicitly avoids provisional artifact acceptance.

## Decision 4: Express useful contribution through guidance and examples

**Decision**: Add the distinction, precedence, useful-contribution criteria, fallback conditions, and three non-normative examples to the Interaction model and Collaborative Development guidance.

**Rationale**: The behavior needs both an agent-checkable normative rule and concrete examples that make the distinction usable without exposing internal workflow mechanics.

**Alternatives considered**: Adding another normative rule for every contribution category was rejected because it would duplicate existing interaction obligations and make the standard more brittle.

## Decision 5: Preserve active-development versioning and rule numbering

**Decision**: Follow the repository's current development-versioning practice and do not rationalize or renumber X rules.

**Rationale**: The user explicitly requests no renumbering, and the current standard's policy distinguishes rule redefinition from additive guidance while acknowledging active-development versioning.

**Alternatives considered**: A compatibility-focused versioning rationalization was rejected because the repository has a later planned rationalization pass and the request explicitly defers it.
