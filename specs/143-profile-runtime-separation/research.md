# Feature 143 Research

## Decision: Use the existing source skill as the only authored runtime implementation

**Rationale**: `.highway/skills/highway-profile/SKILL.md` is the shipped source contract. The agent-tree copies are generated artifacts governed by the repository's generator correspondence rules. Editing the source and regenerating copies keeps all declared adapters aligned.

**Alternatives considered**: Editing each adapter independently was rejected because it would create generated-artifact drift and violate the repository's source-of-truth convention.

## Decision: Treat the retained Profile template as an external contract

**Rationale**: `.highway/library/templates/output/profile-record.md` owns retained frontmatter, domain keys, narrative order, and optional Context structure. Feature 143 must preserve that contract and remove only duplicated structural or interaction prose from the skill.

**Alternatives considered**: Repeating or revising the template in `highway-profile` was rejected because it creates competing schema authority and violates the explicit protected-file scope.

## Decision: Keep shared interaction and authority in their existing runtime documents

**Rationale**: The Experience Standard owns visible collaboration, convergence, clarification, Contribution Opportunity, advisory interaction, and acceptance interaction. The Highway Constitution owns authority, transience, owner completeness, mutation, persistence, orchestration, and precedence. Highway Identity owns behavioral identity and advisory posture. Profile should cite these boundaries and retain only Profile-specific application.

**Alternatives considered**: Copying condensed versions of the shared interaction loops into each Profile domain was rejected because it preserves the duplication and makes future runtime amendments inconsistent.

## Decision: Use static document contracts plus the existing full suite

**Rationale**: The requested change is a skill-document refactor. Static assertions can verify headings, forbidden historical language, preserved domain contracts, ownership references, protected-path behavior, and generated correspondence. The existing `.highway/tools/tests/run-all.sh` provides repository-wide regression coverage.

**Alternatives considered**: Adding a new runtime engine or end-to-end application harness was rejected because Profile execution is governed by Markdown skill instructions and existing shell contracts, not application code.

## Decision: No external interface contract is required

**Rationale**: Profile exposes an internal skill action contract and user-visible Markdown interaction, but this feature does not add or change a network API, file schema, CLI protocol, or external service integration. The quickstart documents the existing action and validation surface instead.

**Alternatives considered**: A new `contracts/` API document was considered unnecessary duplication of the skill and retained template contracts.

## Decision: Version classification remains policy-driven during implementation

**Rationale**: The spec requires applying the current Constitution Skill Versioning Policy without fixing a release number in advance. Planning will verify whether the semantic cleanup removes or redefines an existing skill guarantee and record the resulting version decision in the implementation artifacts.

**Alternatives considered**: Presetting a MINOR or MAJOR version before comparing the source contract was rejected because the Constitution policy is the authoritative classifier.
