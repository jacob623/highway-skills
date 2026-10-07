# Feature Specification: Constitution Runtime Boundary

**Feature Branch**: `145-constitution-runtime-boundary`

**Created**: 2026-10-06

**Status**: Draft

**Input**: User description: "Update the Highway Skills Constitution to establish a clean separation between development-time shipped-artifact governance and runtime behavior."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Govern shipped skills during development (Priority: P1)

As a Highway maintainer, I want the Highway Skills Constitution to govern the design and validity of shipped skills and shared runtime contracts during development, so that shipped artifacts are rigorously validated without loading the Constitution during runtime execution.

**Why this priority**: Establishing the Layer 1 boundary is the primary architectural change and prevents development governance from becoming a hidden runtime dependency.

**Independent Test**: Review the Constitution's scope, Governance, definitions, dependencies, and self-application text, then verify that it describes development validation of shipped artifacts and explicitly excludes runtime consumption.

**Acceptance Scenarios**:

1. **Given** a shipped skill or shared runtime contract is being authored or validated, **When** the Constitution applies, **Then** it evaluates design validity, ownership, structure, and contract safety during development.
2. **Given** an executing skill is handling a user interaction, **When** runtime behavior occurs, **Then** the skill does not need to load or consult the Highway Skills Constitution.
3. **Given** a Constitution rule affects a runtime contract, **When** that contract is validated, **Then** the Constitution shapes the contract without becoming the contract's runtime authority.
4. **Given** a skill owns domain semantics or an operational contract, **When** the Constitution reviews it, **Then** the skill remains responsible for those runtime decisions.

### User Story 2 - Preserve correctness-critical determinism (Priority: P1)

As a maintainer, I want deterministic requirements preserved for authoritative and contractual behavior while allowing bounded variation in advisory reasoning, so that correctness remains stable without forcing identical generative explanations or interpretations.

**Why this priority**: The refactor must remove overbroad runtime determinism without weakening state safety, persistence, ownership, routing, identifiers, artifact structure, or declared outcomes.

**Independent Test**: Review Principle VI, its rationale, precedence, and observables; classify representative requirements as contractual/authoritative or advisory/non-authoritative; verify each class receives the intended treatment.

**Acceptance Scenarios**:

1. **Given** a requirement controls authoritative state, mutation, persistence, ownership, routing, readiness, identifiers, artifact structure, output contracts, destructive behavior, declared outcomes, or deterministic generated content, **When** it is validated, **Then** the Constitution requires deterministic behavior where the contract requires it.
2. **Given** a runtime response offers an interpretation, connection, implication, possibility, alternative, tradeoff, concern, recommendation, explanation, example, or conversational phrasing, **When** it varies while honoring its owning contract, **Then** the Constitution does not reject it solely because identical context produced different advisory reasoning.
3. **Given** a precedence rationale describes determinism, **When** it is read, **Then** it frames determinism as development validation of correctness-critical contracts and does not direct an executing agent's runtime action selection.

### User Story 3 - Keep runtime interaction ownership with the Experience Standard (Priority: P1)

As an Experience Standard maintainer, I want the Constitution to validate Experience Standard compliance during development without governing conversational decisions at runtime, so that generic interaction behavior has one runtime owner.

**Why this priority**: The Experience Standard is Layer 2 and must remain the source of user-visible interaction requirements without upward runtime dependency on Layer 1.

**Independent Test**: Review Experience Compliance, Principle XIII or its replacement, Governance, precedence, and definitions; verify the Constitution validates conformance and does not prescribe collaboration, clarification, convergence, or advisory behavior.

**Acceptance Scenarios**:

1. **Given** an interactive skill is authored, **When** it is evaluated, **Then** the Constitution verifies compliance with applicable Experience Standard rules and avoids duplicating their generic behavior.
2. **Given** runtime interaction requires clarification, Working Idea development, contribution opportunities, re-evaluation, recommendations, or convergence, **When** the skill executes, **Then** those semantics come from the Experience Standard and owning skill contracts rather than the Constitution.
3. **Given** a skill-specific Experience exception is justified, **When** the exception is validated, **Then** it identifies the affected Experience rule and its justification without making the Constitution a runtime dependency.
4. **Given** the Experience Standard is read independently, **When** its dependency direction is reviewed, **Then** it does not depend on or know about the Highway Skills Constitution.

### User Story 4 - Validate context and ownership without runtime governance (Priority: P1)

As a skill author, I want context declarations, ownership boundaries, orchestration contracts, failure behavior, and accepted knowledge boundaries validated during development, so that runtime owners remain explicit without the Constitution executing those rules.

**Why this priority**: Removing runtime authority must not remove the safeguards that prevent false success, ambiguous ownership, unsafe mutation, or untraceable context use.

**Independent Test**: Review Principles XI and XII, common failure requirements, definitions, and Governance; verify they require skills to declare and own runtime contracts while removing Constitution-owned runtime semantics.

**Acceptance Scenarios**:

1. **Given** a skill depends on shared Highway context, **When** its contract is validated, **Then** it declares the context sources that can influence behavior and uses only the remaining applicable Highway Identity and user-owned or accepted repository knowledge sources.
2. **Given** Highway Identity is declared as context, **When** it is described, **Then** it remains contextual and non-normative, explaining what Highway is, why it exists, and what it is trying to achieve rather than supplying behavioral guidance.
3. **Given** a skill performs owner readiness, domain state, mutation sequencing, persistence, routing, or owner-result behavior, **When** its contract is validated, **Then** the applicable skill or orchestrator contract owns those runtime mechanics sufficiently for safe execution.
4. **Given** a skill handles a failure, **When** its contract is validated, **Then** required failure behavior is defined by the skill or intended shared runtime owner, preserves authoritative state, and prevents false success claims without relying on the Constitution at runtime.
5. **Given** an interactive skill uses Working Ideas, accepted knowledge, or proposals, **When** its contract is validated, **Then** the Constitution checks that runtime ownership is delegated to the Experience Standard and artifact-specific acceptance/persistence remains with the owning skill.

### User Story 5 - Maintain a coherent constitutional artifact (Priority: P2)

As a governance reviewer, I want the refactored Constitution to have coherent definitions, principles, precedence, observables, versioning, and self-application evidence, so that it remains independently checkable after the boundary change.

**Why this priority**: This is a structural and semantic amendment, not a wording cleanup; stale definitions and precedence can silently preserve the old runtime model.

**Independent Test**: Run the Constitution's inventory, coverage, rule, and self-application checks and inspect the complete document for retired runtime-governance references and obsolete context dependencies.

**Acceptance Scenarios**:

1. **Given** a definition exists only to describe Constitution-owned runtime governance, **When** the Constitution is refactored, **Then** that definition is removed or narrowed to a development-validation purpose.
2. **Given** a principle or rule is retired or redefined, **When** the amendment is recorded, **Then** stable surviving rule IDs are preserved, retired rules are accounted for, and the semantic version follows the existing amendment policy.
3. **Given** Principle Precedence is applied, **When** conflicts are evaluated, **Then** the order describes development-time evaluation of shipped artifacts rather than runtime agent behavior.
4. **Given** the Constitution is self-applied, **When** its own compliance is checked, **Then** its version, rule count, tiers, observables, and development/runtime boundary are independently verifiable.

### Edge Cases

- A skill still references the Constitution's common failure model at runtime; the Constitution change must expose that downstream cleanup without recreating the failure model inside Layer 1.
- A skill declares `highway-vision.md` or `highway-platform-objectives.md`; the Constitution must remove its own dependencies on those retired context documents without silently editing the skill.
- A runtime contract requires deterministic identifier allocation and persistence but permits adaptive advisory wording; both obligations must coexist without one broad rule swallowing the other.
- A skill-specific Experience exception names a rule that no longer exists; development validation must make the stale exception visible.
- A remaining mention of Working Idea, Converged Proposal, Active Reasoning Context, or Collaborative Knowledge Development may be valid only when it references Experience-owned semantics for development validation.
- Highway Identity may be required as declared context for a skill while remaining non-normative and never becoming a runtime governance source.
- A generated or persisted artifact may require deterministic content under its contract even though surrounding explanatory reasoning remains adaptive.
- Existing downstream references may fail after the Constitution leaves runtime; this feature reports those dependencies rather than hiding them with duplicated runtime rules.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Constitution MUST state that it governs the design and validity of shipped Highway skills and shared runtime contracts during development and validation.
- **FR-002**: The Constitution MUST state that it is not a runtime dependency of executing Highway skills and does not govern an executing Highway interaction.
- **FR-003**: The Constitution MUST state that development governance may validate shipped artifacts against the Constitution without accompanying the Constitution into runtime execution.
- **FR-004**: The Constitution MUST preserve the Experience Standard as the source of generic user-visible interaction requirements and MUST describe Experience Compliance as development-time validation.
- **FR-005**: The Constitution MUST NOT state that it supersedes runtime governance or takes runtime precedence over the Experience Standard.
- **FR-006**: The Constitution MUST preserve deterministic requirements for authoritative state, mutation, persistence, ownership, orchestration, routing, readiness and domain state where specified, identifier allocation, artifact structure, output contracts, destructive behavior, declared workflow outcomes, and deterministic generated or persisted content when contractually required.
- **FR-007**: Principle VI MUST explicitly permit bounded runtime variation in non-authoritative interpretations, connections, implications, possibilities, alternatives, tradeoffs, challenges, concerns, recommendations, explanations, examples, and conversational phrasing.
- **FR-008**: Principle VI and its precedence rationale MUST NOT require identical generative reasoning from identical context or state that determinism determines which action an executing agent selects at runtime.
- **FR-009**: Principle XI MUST describe `highway-identity.md` as shared contextual information about what Highway is, why it exists, and what it is trying to achieve, not as behavioral guidance.
- **FR-010**: Principle XI MUST remove dependencies on `highway-vision.md` and `highway-platform-objectives.md` and MUST preserve the development requirement that skills declare runtime context sources that can influence behavior.
- **FR-011**: Principle XI MUST move generic runtime interaction semantics out of the Constitution while allowing development validation that the applicable runtime owner defines or delegates those semantics correctly.
- **FR-012**: The Constitution MUST remove Principle XIII as runtime behavioral governance and MUST reduce any collaborative knowledge development requirement to development validation that interactive skills delegate generic Working Idea and convergence semantics to the Experience Standard.
- **FR-013**: The Constitution MUST NOT retain Active Reasoning Context as a Constitution-owned runtime concept unless a concrete development-validation use requires a narrowed definition.
- **FR-014**: The Constitution MUST validate user-ownership and accepted-knowledge boundaries without acting as runtime authority for conversational epistemic status.
- **FR-015**: Principle XII MUST retain development requirements for explicit ownership and safe orchestration contracts while removing language that makes the Constitution itself an executing runtime authority.
- **FR-016**: The Constitution MUST remove the assumption that skills rely on the Constitution at runtime for common failure handling, while preserving development requirements for required failure behavior, authoritative-state protection, and prevention of false success claims.
- **FR-017**: The Constitution MUST remove or narrow definitions that exist only because it acts as runtime governance, including Agent, Repository Context Document, Repository Context, Accepted Repository Knowledge, Active Reasoning Context, Working Idea, Converged Proposal, Accepted User-Owned Artifact, Behavior, Participating Skill, Material Influence, and Completion Claim.
- **FR-018**: Principle Precedence MUST describe conflict resolution during development-time evaluation of shipped artifacts and MUST not describe runtime agent behavior.
- **FR-019**: Governance MUST state that the Constitution does not supersede the Experience Standard at runtime, that conforming interactive skills are designed to follow it, and that domain semantics, artifact ownership, persistence, and operational contracts belong to applicable runtime owners.
- **FR-020**: The Constitution MUST remove generic runtime interaction and governance prose whose authoritative owner is the Experience Standard or an individual skill.
- **FR-021**: The Constitution MUST preserve development-oriented requirements for checkability, portability, approved authority sources, measurable quality gates, skill structure, maintainability, verification, shared output contracts, dependency declaration, mutation and state safety, semantic versioning, Experience Standard compliance, explicit ownership, runtime contracts, and correctness-critical determinism.
- **FR-022**: The Constitution MUST not modify the Experience Standard, Highway Identity, or individual skill files as part of this feature.
- **FR-023**: The Constitution MUST record downstream references that will require later cleanup, including runtime references to the Constitution common failure model and references to removed Highway context documents.
- **FR-024**: The amendment MUST follow the Constitution's existing versioning, Sync Impact Report, rule-ID retirement, self-application, and verification conventions without renumbering surviving stable rule IDs.
- **FR-025**: The complete Constitution MUST contain no stale unqualified references that characterize it as runtime governance, runtime precedence, an authority for executing agents, a dependency on `highway-vision.md` or `highway-platform-objectives.md`, Identity as behavioral guidance, or Constitution-owned convergence.

### Key Entities *(include if data involved)*

- **Highway Development Constitution**: Layer 0 governance for how the Highway project is built, tested, packaged, generated, and separated from runtime artifacts; it delegates shipped-artifact validation to the Highway Skills Constitution.
- **Highway Skills Constitution**: Layer 1 development-time governance for the design and validity of shipped Highway skills and shared runtime contracts; it is not loaded by executing skills.
- **Highway Experience Standard**: Layer 2 runtime contract for user-visible interaction; it remains the generic owner of collaborative interaction semantics and does not depend on Layer 1 after its corresponding update.
- **Highway Identity**: Non-normative shared context describing what Highway is, why it exists, and what it is trying to achieve.
- **Shipped Runtime Contract**: A skill contract or shared runtime contract whose correctness, ownership, persistence, output, and interaction boundaries are validated during development.
- **Downstream Runtime Reference**: An existing skill or shared artifact that currently relies on Constitution-owned runtime behavior and therefore requires later cleanup.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of the Constitution's opening scope, Governance, dependency, and precedence statements describe development-time validation rather than runtime governance.
- **SC-002**: 100% of correctness-critical deterministic obligations remain explicitly represented, and 0 requirements mandate identical generative reasoning solely for advisory runtime content.
- **SC-003**: 100% of generic runtime interaction concepts identified in the Constitution are either removed or explicitly delegated to the Experience Standard, with no new Constitution-owned runtime interaction rules introduced.
- **SC-004**: 100% of references to `highway-vision.md` and `highway-platform-objectives.md` are removed from the Constitution, while downstream references are listed for follow-up cleanup.
- **SC-005**: 100% of surviving stable rule IDs remain unchanged, and every retired or redefined rule is accounted for in the Sync Impact Report and self-application evidence.
- **SC-006**: The Constitution inventory, coverage, rule-check, version, and self-application validations report zero failures after the amendment.
- **SC-007**: The Experience Standard, Highway Identity, retained Profile/runtime artifacts, and individual skill files have zero modifications attributable to this feature.
- **SC-008**: A review of all remaining definitions finds no definition that asserts the Constitution is a runtime authority or that an executing skill must consult it.
- **SC-009**: Downstream runtime references requiring later cleanup are reported with their owning file or artifact and are not concealed by duplicating a replacement runtime failure or collaboration contract in the Constitution.
- **SC-010**: The resulting mental model is unambiguous: the Development Constitution governs project construction, the Skills Constitution validates shipped contracts, the Experience Standard governs runtime interaction, skills own domain/runtime contracts, and Highway Identity supplies non-normative shared context.

## Assumptions

- The current branch already contains the separate Highway Development Constitution direction and the Highway Identity update; this feature changes only the Highway Skills Constitution.
- The Experience Standard update that removes its Layer 1 dependency is treated as an existing or parallel change; this feature validates the intended dependency direction and does not edit that file.
- Existing rule IDs are stable identifiers; removed rules will be recorded as retired rather than renumbering surviving rules.
- Downstream skill migrations are intentionally out of scope and will be handled in subsequent features.
- The Constitution may retain development-validation terminology that references Experience-owned runtime concepts when that reference is necessary to validate a shipped contract, but it will not redefine those runtime semantics.
- Existing repository test and compliance tooling remains the authoritative way to verify inventory, coverage, observables, tiers, versioning, and self-application.
- No new runtime failure contract is created by this feature; any required replacement owner will be identified as follow-up work.
- Highway Identity is included only as a declared, non-normative context source when a shipped skill depends on it.
