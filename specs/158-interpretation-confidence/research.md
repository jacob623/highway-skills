# Research: Interpretation Confidence

## Decision 1: Keep the change in Profile-owned guidance

- **Decision**: Add the new subsection to `.highway/skills/highway-profile/SKILL.md` and leave the Experience Standard unchanged.
- **Rationale**: The request is a Profile-specific tie-breaker. The Experience Standard already defines contribution, clarification, grounding, attribution, and convergence behavior, and the feature explicitly protects those contracts.
- **Alternatives considered**: Amending the Experience Standard was rejected because it would broaden a Profile-local change and risk changing shared runtime behavior.

## Decision 2: Treat interpretation confidence as selection guidance, not a new contribution type

- **Decision**: State that a grounded interpretation is preferred only when accepted evidence supports it and a competing move is an unnecessary permission-seeking exploratory question.
- **Rationale**: This preserves existing contribution taxonomy while addressing conservative-model hesitation. Consequential uncertainty remains governed by existing clarification behavior.
- **Alternatives considered**: Adding a new contribution category was rejected by the feature scope and would duplicate existing Working Idea behavior.

## Decision 3: Validate source placement, protected content, and generated correspondence statically

- **Decision**: Add a focused shell document-contract test, regenerate declared adapters, and run the full suite.
- **Rationale**: The repository's current Profile features use static document contracts for exact wording and placement, while the generator is the source of truth for distributed adapters.
- **Alternatives considered**: A runtime conversational test was not added because the repository's static contract harness cannot establish model dialogue quality; the spec records that residual limitation.

## Decision 4: Preserve macOS shell compatibility

- **Decision**: Use the existing POSIX/Bash 3.2-compatible shell test conventions.
- **Rationale**: The repository runs on macOS and its development constitution requires compatibility with the declared shell toolchain.
- **Alternatives considered**: Introducing a language-specific test dependency was rejected as unnecessary for a Markdown placement and correspondence contract.
