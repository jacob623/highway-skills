# Research: Collaborative Knowledge Development

## Decision: Amend the canonical Constitution only

**Decision**: Implement Feature 124 in `.highway/governance/constitution.md`, with repository validation and generated distribution updates only where existing tooling requires them.

**Rationale**: The specification names the Constitution as canonical and explicitly prohibits a runtime dependency, storage schema, public interface, durable reasoning state, Working Idea file, reasoning log, or thread catalog. Existing governance tests already validate constitutional inventory, rule coverage, rule shape, and generated adapters.

**Alternatives considered**: Adding a conversation-state model, a retained Working Idea artifact, or a new runtime service was rejected because each would violate FR-025 and expand ownership beyond the constitutional amendment.

## Decision: Insert `XII-A` between X and XI

**Decision**: Add Collaborative Knowledge Development below Experience Compliance and above Repository Context, preserving all existing P12 rule identifiers and semantics.

**Rationale**: FR-028 defines the precedence placement. The sub-principle label avoids renumbering existing principles and keeps P12.5-P12.15 stable.

**Alternatives considered**: Renumbering Principle XI or extending Principle XII directly was rejected because it would disturb stable governance identifiers or blur the distinction between owner-controlled completion and collaborative development.

## Decision: Use additive MINOR versioning unless compatibility review finds a break

**Decision**: Initially classify the amendment as MINOR, then verify that no currently conforming governed skill becomes non-conforming. Reclassify to MAJOR only if that review finds a breaking obligation.

**Rationale**: The new rules add explicit handling for transient collaborative context while preserving existing acceptance, mutation, and orchestration contracts. The Constitution's own semantic-version policy controls the final classification.

**Alternatives considered**: Automatically selecting MAJOR because the document is constitutional was rejected; the policy requires classification based on impact to previously conforming governed work.

## Decision: Keep the lifecycle non-normative

**Decision**: Describe the flow from accepted context through Working Ideas, Converged Proposal, acceptance, owner mutation, and re-evaluation in a non-normative lifecycle section.

**Rationale**: The lifecycle makes authority transitions inspectable without adding conversational technique, literal wording, turn counts, visible reasoning requirements, or a durable state artifact.

**Alternatives considered**: Encoding each conversational move as a new rule was rejected by FR-027 and would make the Experience Standard and owning skills' responsibilities overlap.

## Decision: No external contracts artifact

**Decision**: Do not create `contracts/` content.

**Rationale**: The repository exposes governance documents and shell validation, not a new API, CLI schema, or external integration for this feature. The quickstart references existing test commands instead.

**Alternatives considered**: A runtime or API contract was rejected because the feature introduces no public runtime interface.
