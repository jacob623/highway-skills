# Feature 142 Research

## Decision 1: Keep governance ownership split across the two authoritative documents

**Decision**: `.highway/governance/constitution.md` owns authority, transience, accepted repository knowledge, Active Reasoning Context, owner completeness, mutation, persistence, orchestration, and context precedence. `.highway/governance/experience-standard.md` owns visible collaborative interaction, Working Idea development, Substantive Contribution, Conversational Clarification, Contribution Opportunity, convergence, and visible artifact-acceptance interaction. Owning skills retain domain semantics, artifact content, domain-specific completeness, and persistence implementation.

**Rationale**: The current Constitution's Principle XIII lifecycle describes interaction behavior that the finalized Experience Standard now owns. Keeping only authority and ownership statements in the Constitution prevents competing runtime models while preserving constitutional precedence.

**Alternatives considered**: Merging both documents into one contract was rejected because the repository already establishes separate Constitution and Experience layers. Copying Experience Standard rules into Principle XIII was rejected because it would recreate the duplication the feature is intended to remove.

## Decision 2: Treat complete candidate and Converged Proposal as separate states

**Decision**: A Converged Proposal requires both a complete owner candidate and satisfaction of the applicable Experience Standard convergence requirements.

**Rationale**: P12A.2 currently states only candidate completeness in its Observable, and the lifecycle says a complete candidate is a Converged Proposal. That permits premature convergence. The revised definition and Observable must express both conditions without copying X2.41's detailed criteria.

**Alternatives considered**: Keeping completeness as the sole condition was rejected because it conflicts with the finalized Experience Standard. Repeating detailed convergence criteria in the Constitution was rejected because it violates the ownership boundary.

## Decision 3: Classify the amendment as MAJOR under the Constitution's own policy

**Decision**: Plan for a MAJOR Constitution version increment because the Converged Proposal definition and P12A.2 Observable are redefined.

**Rationale**: The Constitution's Versioning Policy classifies removal or redefinition of a governance rule as MAJOR. Calling this a PATCH merely because the goal is alignment would contradict the document's policy.

**Alternatives considered**: MINOR or PATCH were rejected because the change alters the meaning of a constitutional rule and can change which artifacts conform.

## Decision 4: Use existing deterministic shell guards and the full suite

**Decision**: Validate with focused structural checks for definitions, P12A.1-P12A.4, lifecycle ownership, version metadata, and cross-document terms, followed by `.highway/tools/tests/run-all.sh`.

**Rationale**: The repository's existing validation is Bash 3.2-compatible and already governs constitutional rule inventories and Experience Standard alignment. No new runtime harness or dependency is justified for a Markdown-only change.

**Alternatives considered**: Adding an application-level test harness was rejected because the feature changes no application runtime. Manual review alone was rejected because the requested guarantees include countable rule and non-duplication invariants.

## Decision 5: No external contracts

**Decision**: Do not create `contracts/` artifacts.

**Rationale**: This feature changes internal governance documents and validation guards, not a public API, CLI command schema, file interchange format, or service boundary.

**Alternatives considered**: Treating the Constitution as an external API was rejected because its contract is covered by the document's rule inventory and repository governance checks rather than a separately consumed protocol.
