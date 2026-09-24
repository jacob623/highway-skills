# Research: Repository Context Guidance

## Decision 1: Limit implementation to the two governing documents

- **Decision**: Amend `.highway/governance/constitution.md` and `.highway/governance/experience-standard.md` only. Existing skill migrations are follow-up work.
- **Rationale**: The clarification explicitly bounds Feature 088 to the shared governance contract. This avoids silently expanding the feature into a repository-wide skill migration.
- **Alternatives considered**: Updating every context-sensitive skill now was rejected because it expands scope and requires a separate inventory and behavioral review.

## Decision 2: Treat named context documents as authoritative

- **Decision**: The three files under `.highway/library/knowledge/` are authoritative Repository Context Documents. Accepted repository artifacts may supplement them but cannot replace or reinterpret them.
- **Rationale**: The feature needs a stable authority boundary between foundational context, governance artifacts, workflow inputs, and user-owned content.
- **Alternatives considered**: Treating every accepted repository artifact as equal context was rejected because it would make authority and review outcomes inconsistent.

## Decision 3: Use deterministic context precedence

- **Decision**: Resolve overlap in the ordered path Identity -> Vision -> Platform Objectives. Identity supplies behavioral guidance, Vision supplies strategic direction, and Platform Objectives supply evaluation criteria.
- **Rationale**: The order gives future reviewers a repeatable conflict-resolution path when context documents overlap.
- **Alternatives considered**: Treating the documents as peers with agent discretion was rejected because identical inputs could produce different decisions.

## Decision 4: Declare before selective consumption

- **Decision**: FR-004 governs declaration in Inputs; only after declaration does FR-019 govern consumption. A Participating Skill selects only documents relevant to its declared purpose, inputs, outputs, or workflow decisions.
- **Rationale**: Separating declaration from consumption makes the contract inspectable and prevents both undeclared dependence and mandatory reading of all three documents.
- **Alternatives considered**: Requiring all three files for every skill was rejected because it adds noise and violates the relevance boundary.

## Decision 5: Define reviewable participation and material influence

- **Decision**: A Participating Skill produces Behavior influenced by repository context. Relevant context produces a Material Influence on a recommendation, Behavior, governance interpretation, prioritization, decision support, or generated artifact outcome.
- **Rationale**: These definitions make scope and acknowledgment decisions reviewable from the skill contract and workflow output.
- **Alternatives considered**: Leaving participation and relevance to general judgment was rejected because it would produce inconsistent compliance reviews.

## Decision 6: Add contextual guidance without changing existing interaction rules

- **Decision**: Add X2.7 for context-grounded recommendations and X2.8 for concise acknowledgments only when Material Influence exists. Preserve X2.1-X2.6 unchanged.
- **Rationale**: The feature adds context awareness while maintaining the existing interaction authority and avoiding acknowledgement noise.
- **Alternatives considered**: Rewriting existing X2 rules was rejected because it would broaden the amendment and invalidate the explicit preservation requirement.

## Decision 7: Validate governance structure as well as prose

- **Decision**: Review every added constitutional rule for one keyword, one Observable, an allowed tier, unique identifiers, and normative-section length; run existing inventory and UX checks plus the full suite.
- **Rationale**: The governing documents are highly prescriptive, so a semantically correct amendment can still violate structural limits.
- **Alternatives considered**: Relying on prose review alone was rejected because the repository already has executable checks for these contracts.

## Decision 8: No external contracts artifact

- **Decision**: Do not create `contracts/` for Feature 088.
- **Rationale**: The feature changes retained repository documents and their validation rules; it introduces no API, command schema, endpoint, or protocol.
- **Alternatives considered**: A document contract was considered but rejected because the data model and quickstart fully describe the internal governance surface.
