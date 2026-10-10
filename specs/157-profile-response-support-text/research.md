# Feature 157 Research

## Decision: Keep support text Profile-owned

- **Decision**: Add one `Response Support Text` section to `.highway/skills/highway-profile/SKILL.md` immediately after `##### Domain completeness` and before `##### Advisory question scaffolding`.
- **Rationale**: Profile owns domain completeness and Profile-specific validation behavior. The Experience Standard remains the owner of generic interaction rules and is explicitly out of scope.
- **Alternatives considered**: Moving the wording into `.highway/governance/experience-standard.md` was rejected because it would change a generic governance artifact for Profile-specific language and would violate the requested ownership boundary.

## Decision: Use canonical labels for behavioral references

- **Decision**: Define Validation Question, Acceptance Reassurance, Discovery Reassurance, and Combined Reassurance once, then reference those labels in behavioral guidance. Retain literal wording in worked examples, transcript-style examples, illustrations, and example outputs.
- **Rationale**: This removes duplicated behavioral definitions while preserving user-visible examples and the exact support language that defines each reusable element.
- **Alternatives considered**: Removing every literal occurrence was rejected because the feature explicitly requires literal examples to remain available.

## Decision: Preserve the existing review and discovery boundaries

- **Decision**: Render the capture heading, Validation Question, and applicable reassurance in that order; select Discovery Reassurance only when no meaningful starting point exists for reaction. Treat a grounded Working Idea, possibility, interpretation, implication, connection, tension, tradeoff, recommendation, or other advisory contribution as a meaningful starting point.
- **Rationale**: These are the behavior-preserving rules supplied by the feature and align with the existing Profile ownership boundary and the shared Experience Standard vocabulary.
- **Alternatives considered**: Retaining the old first-Substantive-Contribution switch was rejected because it incorrectly makes the presence or absence of a user contribution decide reassurance when a meaningful Working Idea may already be available.

## Decision: Add a static document-contract regression test

- **Decision**: Add one Feature 157 test under `.highway/tools/tests/` that identifies itself as a `static-document-contract` check, covers source-document and generated-artifact classes, asserts the centralized definitions and ordering, protects literal examples, and verifies unchanged advisory/domain boundaries. Regenerate the four Profile adapters from the source.
- **Rationale**: The repository's existing Feature 152-156 tests use this contract style for skill-document delivery. Static checks can prove document ownership and correspondence, but they are not runtime conversational evidence.
- **Alternatives considered**: Adding runtime conversation fixtures was rejected because the repository's current Profile feature contracts are document-level and this refactor changes prose ownership rather than executable conversation code.

## Decision: No interface contract artifact

- **Decision**: Do not create a `contracts/` artifact for this feature.
- **Rationale**: The feature exposes no external API, CLI schema, persistence format, or cross-system interface. Its observable contract is captured by the source-document test and quickstart validation scenarios.
- **Alternatives considered**: A prose UI contract was rejected as duplicative of the Profile skill's authoritative support-text section and the static test assertions.
