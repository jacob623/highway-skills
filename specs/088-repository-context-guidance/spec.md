---

 description: "Add repository context definitions and guidance to the Highway constitutions"
---

# Feature Specification: Repository Context Guidance

**Feature Branch**: `088-repository-context-guidance`

**Created**: 2026-09-24

**Status**: Draft

**Input**: User description: "Update the Highway Skills Constitution and Highway Experience Standard to define Repository Context Documents, require context-aware skill inputs when repository context influences behavior, and guide interactive workflows to use relevant repository context in recommendations and acknowledgments."

## Clarifications

### Session 2026-09-24

- Q: Should Feature 088 update existing repository-context-sensitive skills as part of this feature, or only amend the two governing documents and leave skill updates as follow-up work? → A: Amend only the two governing documents; update affected skills in follow-up features.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Establish Authoritative Repository Context (Priority: P1)

As a Highway maintainer, I want the constitutions to identify the repository context documents and their authority, so that participating skills have a shared foundation for understanding Highway identity, direction, objectives, and decision criteria.

**Why this priority**: Without an explicit authority boundary, skills cannot consistently distinguish repository context from workflow-specific inputs or user-owned governance content.

**Independent Test**: Review the Highway Skills Constitution and confirm it defines Repository Context Documents, lists the three authoritative paths, describes their purpose, and preserves the distinction between repository context, workflow inputs, governance artifacts, and user-owned content.

**Acceptance Scenarios**:

1. **Given** the Highway Skills Constitution is read, **when** its Definitions and repository-context sections are reviewed, **then** Repository Context Documents are defined and the three `.highway/library/knowledge/` paths are listed.
2. **Given** repository context documents are present, **when** a reader determines their authority, **then** the constitution states that they provide shared repository context without replacing workflow-specific inputs, governance artifacts, or user-owned content.
3. **Given** a repository context document is absent, **when** a skill evaluates whether context is available, **then** the specification does not require the skill to invent, silently substitute, or treat unrelated content as that document.

### User Story 2 - Declare Context as a Skill Input (Priority: P1)

As a skill author, I want a clear constitutional rule for declaring repository context inputs, so that recommendations, proposals, plans, and generated artifacts are grounded in repository knowledge when that knowledge affects the Behavior.

**Why this priority**: Declared inputs make context use inspectable and prevent skills from appearing repository-aware while silently relying on undeclared information.

**Independent Test**: Evaluate representative skills whose Behavior uses repository context and confirm their Inputs sections name Repository Context Documents; evaluate skills whose Behavior does not use repository context and confirm they are not forced to declare irrelevant inputs.

**Acceptance Scenarios**:

1. **Given** a skill's Behavior is influenced by repository context, **when** its contract is reviewed, **then** Repository Context Documents appear in its Inputs section.
2. **Given** a skill generates recommendations, guidance, proposals, onboarding experiences, governance artifacts, architectures, plans, or implementations, **when** repository context is relevant, **then** the skill's workflow consumes that context before generating the result.
3. **Given** workflow-specific inputs conflict with repository context, **when** the skill executes its workflow, **then** workflow-specific inputs remain authoritative for workflow execution.
4. **Given** repository context is not relevant to a skill's Behavior, **when** its contract is reviewed, **then** the new rule does not require an unrelated context declaration.

### User Story 3 - Make Interactive Guidance Context-Aware (Priority: P1)

As a Highway user, I want interactive recommendations to use relevant repository knowledge and briefly acknowledge information that changes future recommendations, so that each workflow becomes more useful without making the conversation longer than necessary.

**Why this priority**: The value of repository context is realized in the user experience, not only in document definitions or skill metadata.

**Independent Test**: Run or inspect an interactive workflow with relevant repository context and confirm its recommendation is grounded in that context, its material context acknowledgment appears before continuing, and no-context or irrelevant-context cases remain concise.

**Acceptance Scenarios**:

1. **Given** relevant repository context exists, **when** an Interactive Workflow produces a recommendation, **then** the recommendation references the applicable repository context rather than generic guidance alone.
2. **Given** user-provided information produces a Material Influence on future recommendations, **when** the workflow continues, **then** it briefly acknowledges that information before asking for or presenting the next action.
3. **Given** no relevant repository context exists, **when** the workflow produces guidance, **then** it does not fabricate repository-specific claims or add a context acknowledgment.
4. **Given** context can improve a recommendation but would add unnecessary collection steps, **when** the workflow continues, **then** it uses the context without increasing the required interaction beyond the next needed action.

### Edge Cases

- Only one or two of the three repository context documents are present; the workflow uses the available relevant context and does not claim the absent document was consulted.
- A repository context document contains information unrelated to the current workflow; the workflow does not force that information into its recommendation.
- Repository context and workflow-specific input address different concerns; the workflow uses each for its stated role without treating context as a replacement for the workflow input.
- Identity, Vision, and Platform Objectives overlap; the workflow applies their behavioral, strategic, and evaluation roles in that order.
- Overlapping Repository Context Documents require a deterministic resolution path; the workflow evaluates Identity first, then Vision, then Platform Objectives.
- Repository context conflicts with repository governance artifacts; governance and workflow-specific content remain authoritative for workflow execution.
- Repository context produces a Material Influence on a recommendation but the user is already answering a required question; the acknowledgment remains concise and does not introduce an additional unresolved question.
- A user-provided statement changes future recommendations without changing the current answer; the workflow acknowledges the statement before proceeding.
- A recommendation cannot be grounded in available context; the workflow provides a bounded generic recommendation without inventing a context relationship.
- A context acknowledgment could be phrased as product promotion; the workflow explains only the current or future recommendation or Behavior affected by the information.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Highway Skills Constitution MUST define Repository Context Documents as authoritative repository-level documents describing Highway identity, vision, objectives, decision evaluation, knowledge use, and strategic direction.
- **FR-002**: The Highway Skills Constitution MUST list `highway-identity.md`, `highway-vision.md`, and `highway-platform-objectives.md` under `.highway/library/knowledge/` as Repository Context Documents.
- **FR-003**: The Highway Skills Constitution MUST state that Repository Context Documents do not replace workflow-specific inputs, governance artifacts, or user-owned content.
- **FR-004**: The Highway Skills Constitution MUST require a skill to declare Repository Context Documents in its Inputs section when repository context influences its Behavior.
- **FR-005**: The Highway Skills Constitution MUST guide participating skills to consume relevant Repository Context Documents before generating recommendations, guidance, proposals, onboarding experiences, governance artifacts, architectures, plans, or implementations.
- **FR-006**: The Highway Skills Constitution MUST state that workflow-specific inputs remain authoritative for workflow execution.
- **FR-007**: The Highway Skills Constitution MUST require verification that participating skills reference Repository Context Documents when repository context is required to support recommendations, guidance, or generation activities.
- **FR-008**: The Highway Experience Standard MUST define Repository Context as information contained in Repository Context Documents and accepted repository artifacts that can improve recommendations, explanations, decision support, or workflow guidance.
- **FR-009**: The Highway Experience Standard MUST add a Contextual Guidance section beneath X2 Interaction describing how existing repository knowledge improves user guidance without unnecessary workflow complexity.
- **FR-010**: The Highway Experience Standard MUST add rule X2.7 requiring an Interactive Workflow to ground recommendations in relevant repository context when such context exists.
- **FR-011**: The Highway Experience Standard MUST add rule X2.8 requiring an Interactive Workflow to acknowledge information only when it produces a Material Influence on future recommendations, workflow actions, governance interpretation, or decision support.
- **FR-012**: The Highway Experience Standard MUST add Context Awareness guidance stating that relevant repository context grounds recommendations, repository knowledge is used over generic guidance when available, material information may be acknowledged concisely, and context reduces user effort rather than increasing conversation length.
- **FR-013**: The Highway Experience Standard MUST include an illustrative contrast between generic guidance and context-aware guidance without making the example a separate normative rule.
- **FR-014**: The feature MUST preserve existing authority precedence, workflow-specific ownership, user-owned content boundaries, and the existing X2 interaction rules except for the addition of X2.7 and X2.8.
- **FR-015**: The feature MUST update the governing documents' amendment metadata, rule counts, and self-application or non-restatement records to account for the new definitions, section, guidance, and rules.
- **FR-016**: The feature MUST limit implementation changes to the Highway Skills Constitution and Highway Experience Standard; amendments to existing skills are follow-up work.
- **FR-017**: The Highway Skills Constitution MUST state that Repository Context Documents are located under `.highway/library/knowledge/` and that additional Repository Context Documents may be added through future amendments.
- **FR-018**: The Highway Skills Constitution MUST establish a deterministic Repository Context precedence for overlapping guidance in which Highway Identity provides behavioral guidance, Highway Vision provides strategic direction, and Highway Platform Objectives provide evaluation criteria; this precedence governs conflict resolution among Repository Context Documents.
- **FR-019**: After FR-004 declares repository context as an input, a Participating Skill MUST consume only the Repository Context Documents relevant to its declared purpose, inputs, outputs, or workflow decisions.
- **FR-020**: The Highway Experience Standard MUST state that contextual acknowledgments explain how relevant information influences current or future Highway recommendations or Behavior and do not promote, advertise, or restate unrelated Highway capabilities.
- **FR-021**: The Highway Skills Constitution MUST require verification that absent Repository Context Documents do not result in fabricated recommendations, assumed content, or substituted repository context.
- **FR-022**: The constitutional amendment MUST be reviewed against existing rule structure, Observable, rule-count, and normative-section-length constraints before completion.

### Key Entities *(include if feature involves data)*

- **Repository Context Document**: An authoritative repository-level document describing Highway identity, vision, objectives, decision evaluation, knowledge use, or strategic direction.
- **Repository Context**: Information from Repository Context Documents and accepted repository artifacts that improves recommendations, explanations, decision support, or workflow guidance.
- **Behavior**: The recommendations, guidance, decisions, explanations, proposals, generated artifacts, workflow actions, or user-visible outputs produced by a skill.
- **Material Influence**: Information that alters a recommendation, Behavior, governance interpretation, prioritization, decision support, or generated artifact outcome.
- **Participating Skill**: A Highway skill whose outputs, recommendations, guidance, proposals, onboarding experiences, generated artifacts, plans, architectures, or implementation decisions are influenced by repository context. A skill that neither consumes repository context nor produces context-dependent output is not a Participating Skill.
- **Relevant Repository Context**: Repository context that can produce a Material Influence on a recommendation, proposal, explanation, decision, prioritization, generated artifact, or user guidance. Context is not relevant solely because it exists.
- **Interactive Workflow**: A workflow that emits user-visible messages and expects a response, decision, confirmation, approval, rejection, or other input.
- **Contextual Acknowledgment**: A concise user-facing statement recognizing information that produces a Material Influence on future recommendations.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of the three named Repository Context Document paths appear in the Highway Skills Constitution's repository-context section.
- **SC-002**: 100% of reviewed Participating Skill contracts declare Repository Context Documents in Inputs when repository context influences their Behavior.
- **SC-003**: 100% of reviewed Participating Skills consume relevant repository context before producing recommendations, guidance, proposals, onboarding experiences, governance artifacts, architectures, plans, or implementations.
- **SC-004**: 100% of Interactive Workflow reviews with relevant repository context confirm recommendations reference that context rather than generic guidance alone.
- **SC-005**: 100% of Interactive Workflow reviews where user information produces a Material Influence on future recommendations confirm a concise acknowledgment before continuation.
- **SC-006**: 0 workflows fabricate repository-specific claims when the relevant context document is absent.
- **SC-007**: 0 workflows treat Repository Context Documents as replacements for workflow-specific inputs, governance artifacts, or user-owned content.
- **SC-008**: 100% of existing X2.1-X2.6 rule identifiers, rule text, Observables, tiers, and applicability conditions remain unchanged.
- **SC-009**: 100% of amendment metadata and self-application records identify the added definitions, Contextual Guidance section, X2.7, and X2.8.
- **SC-010**: At least 90% of reviewed context-aware interactions complete without adding a new collection question solely to acknowledge or apply context.
- **SC-011**: 100% of reviewed Participating Skills consume only the Repository Context Documents relevant to their declared purpose, inputs, outputs, or workflow decisions.
- **SC-012**: 100% of reviewed contextual acknowledgments explain a current or future recommendation or Behavior, and 0% promote unrelated Highway capabilities.
- **SC-013**: 100% of reviewed no-context cases verify that absent Repository Context Documents produce no fabricated recommendations, assumed content, or substituted repository context.
- **SC-014**: 100% of constitutional amendment reviews confirm that every added normative rule has one keyword, one Observable, an allowed tier, and a section length within the existing constitutional limit.

## Assumptions

- The three repository context documents already exist under `.highway/library/knowledge/` and remain byte-preserved source artifacts from Feature 087.
- The Highway Skills Constitution at `.highway/governance/constitution.md` and the Highway Experience Standard at `.highway/governance/experience-standard.md` are the authoritative amendment targets.
- Context availability is determined by the presence and contents of the named documents and accepted repository artifacts; this feature does not add a new persistence mechanism.
- Repository Context Documents are authoritative repository context. Accepted repository artifacts may supplement repository context but do not replace or reinterpret Repository Context Documents.
- “Relevant” context is determined by the workflow's declared purpose and inputs; irrelevant context is not surfaced merely because it exists.
- Repository context is relevant only when it can produce a Material Influence on a recommendation, proposal, explanation, decision, prioritization, generated artifact, or user guidance.
- When context documents overlap, Identity takes behavioral precedence, Vision supplies strategic direction, and Platform Objectives supply evaluation criteria.
- Contextual acknowledgments are emitted only when information produces a Material Influence on future recommendations, workflow actions, governance interpretation, or decision support.
- A Participating Skill consumes only the Repository Context Documents relevant to its declared purpose, inputs, outputs, or workflow decisions; it does not read all three documents by default.
- The new X2.7 and X2.8 rules apply to Interactive Workflows and do not replace or rewrite X2.2-X2.6.
- A future `highway-experience-principles.md` document may capture interaction principles such as advisor behavior, demonstrated understanding, professional tone, significance explanations, and reduced repeated questioning; that document is outside Feature 088.
- Existing skills may require follow-up amendments when their Behavior is influenced by repository context; this feature defines the governing contract and does not silently rewrite every skill.
- This feature does not modify existing skill contracts; follow-up features will apply the new input and interaction guidance to affected skills.

## Out of Scope

- Changing the identity, vision, or objective content of the three Repository Context Documents.
- Replacing workflow-specific inputs, governance artifacts, or user-owned content with repository context.
- Requiring every skill or every interaction to read every repository context document regardless of relevance.
- Adding a context database, indexing service, persistence layer, or external integration.
- Changing the existing X2.1-X2.6 rules, their identifiers, their Observables, their tiers, or their applicability conditions.
- Rewriting unrelated skills that do not use repository context.
- Amending existing repository-context-sensitive skills as part of this feature.
- Adding Experience Principles or a `highway-experience-principles.md` Repository Context Document.