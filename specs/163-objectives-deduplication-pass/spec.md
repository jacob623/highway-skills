# Feature Specification: Objectives Deduplication Pass

**Feature Branch**: `163-objectives-deduplication-pass`

**Created**: 2026-10-12

**Status**: Draft

**Input**: User description: "Refactor highway-objectives so each concept has one authoritative owner: the Objective Development Lifecycle owns lifecycle mechanics, the queue section owns queue boundaries, Creation Workflow owns evidence evaluation, Recommendation Development owns recommendation grounding, Interpretation Confidence owns interpretation confidence, and examples own presentation."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Follow one authoritative Objective lifecycle (Priority: P1)

As a person developing an Objective, I want proposal contents, proposal-first behavior, Success Measure proposals, User Acceptance, capture, and development sequence explained in one lifecycle so that other sections cannot create competing interpretations.

**Why this priority**: The lifecycle is the central contract. Making it the single source of truth removes the highest-risk form of behavioral drift.

**Independent Test**: Inspect the Objective Development Lifecycle and the rest of the skill, then verify lifecycle mechanics appear authoritatively in the lifecycle and all other sections reference it instead of restating them.

**Acceptance Scenarios**:

1. **Given** a recommendation is selected or a person provides an Objective, **When** development begins, **Then** the lifecycle remains the authoritative source for proposal presentation, User Acceptance, capture, and continuation.
2. **Given** the lifecycle defines proposal contents and proposal-first behavior, **When** another section needs that guidance, **Then** it references the lifecycle rather than defining a second version.
3. **Given** the person corrects, replaces, or rejects a proposal, **When** the workflow continues, **Then** no other section introduces a competing lifecycle stage or acceptance path.

### User Story 2 - Keep queue guidance limited to queue ownership (Priority: P1)

As a person selecting multiple recommendations, I want queue guidance to explain selection, queue membership, development order, and the capture boundary without repeating lifecycle mechanics so that queue processing remains consistent with the canonical lifecycle.

**Why this priority**: The queue section currently combines ownership, lifecycle, proposal, and example behavior, making it a major source of duplicated instructions.

**Independent Test**: Inspect the Objective Queue and Acceptance Boundaries section and verify it contains queue ownership and capture-boundary references while lifecycle examples and proposal mechanics remain owned by the lifecycle.

**Acceptance Scenarios**:

1. **Given** several recommendations are selected, **When** queue guidance is presented, **Then** it explains selection, active queue membership, selected order, and that selection does not capture an Objective.
2. **Given** queue guidance describes the capture boundary, **When** the person follows it, **Then** it references the Converged Objective proposal and User Acceptance defined by the lifecycle.
3. **Given** the queue section is read independently, **When** it reaches illustrative processing, **Then** it does not redefine the normal lifecycle or repeat the preliminary/second-proposal anti-pattern.

### User Story 3 - Keep evidence collection focused on evidence evaluation (Priority: P1)

As a person providing Objective information, I want Creation Workflow to own question selection, evidence classification, and correction re-evaluation without restating lifecycle or acceptance behavior so that questions resolve missing evidence rather than create a second development workflow.

**Why this priority**: Creation Workflow is the largest remaining mixed section and needs a clear boundary between evidence collection and Objective development.

**Independent Test**: Inspect Creation Workflow and verify it retains Business Objective, Success, Highway Relevance, supplied-evidence classification, and correction re-evaluation while lifecycle behavior is referenced rather than repeated.

**Acceptance Scenarios**:

1. **Given** Business Objective, Success, or Highway Relevance evidence is missing, **When** Creation Workflow chooses the next question, **Then** it owns that evidence evaluation and question ordering.
2. **Given** supplied evidence is sufficient for development, **When** Creation Workflow continues, **Then** it references the Objective Development Lifecycle instead of restating proposal, acceptance, or queue steps.
3. **Given** the person corrects staged evidence, **When** the workflow re-evaluates it, **Then** it discards unsupported staged interpretations without creating a duplicate lifecycle description.

### User Story 4 - Preserve focused owners for recommendations, interpretation, and examples (Priority: P2)

As a person reading Objective guidance, I want recommendations, interpretation confidence, and illustrative examples to each explain only their own concern so that the skill is easier to follow and examples demonstrate output without becoming hidden workflow definitions.

**Why this priority**: These sections contain useful guidance but currently repeat proposal-first, Objective sequencing, Success Measure, or acceptance concepts owned elsewhere.

**Independent Test**: Inspect Recommendation Development, Interpretation Confidence, Objective Development Example, and Recommendation Presentation and verify each section keeps its declared concern while cross-cutting lifecycle mechanics are referenced.

**Acceptance Scenarios**:

1. **Given** accepted Profile evidence supports a recommendation, **When** Recommendation Development presents it, **Then** the section explains grounding, relevance, and the user-authored path without redefining proposal-first Objective development.
2. **Given** an interpretation is uncertain, **When** Interpretation Confidence guides the owner, **Then** it addresses confidence and correction without repeating Objective lifecycle mechanics.
3. **Given** an illustrative Objective example is shown, **When** the person reads it, **Then** it demonstrates that the Objective is visible before Success Measure questions without teaching a second workflow.
4. **Given** a recommendation presentation example is shown, **When** the person interprets it, **Then** the example demonstrates useful output and does not become an alternative lifecycle contract.

### Edge Cases

- A section needs to mention capture or acceptance; it references User Acceptance and capture as defined by the Objective Development Lifecycle.
- A queue item needs proposal development; queue guidance references the lifecycle rather than listing proposal fields or steps.
- Creation evidence is sufficient for a proposal; Creation Workflow stops at evidence evaluation and hands off to the lifecycle.
- Creation evidence is insufficient; discovery remains an evidence question path and does not become a parallel lifecycle.
- A Success Measure phrase appears outside the lifecycle for record-schema or evidence-evaluation reasons; it remains only when it does not redefine proposal behavior.
- An example includes lifecycle-like arrows or sequence; it is revised to demonstrate output rather than define mechanics.
- Recommendation grounding and proposal-first behavior both need mention; grounding stays in Recommendation Development and proposal-first behavior stays in the lifecycle.
- Generated adapters must preserve the same section ownership and references as the source.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Objective Development Lifecycle MUST be the sole authoritative owner of Objective development flow, Converged Objective proposal contents, proposal-first behavior, discovery exception behavior, Success Measure proposal behavior, User Acceptance, capture, and development sequence.
- **FR-002**: The lifecycle MUST retain the sequence Recommendation Selected or User Provided Objective, Present Converged Objective proposal, User Acceptance, Capture, and Next Objective.
- **FR-003**: The lifecycle MUST retain the authoritative Converged Objective proposal fields: Objective title, Objective statement, proposed Success Measures, and synthesized Rationale.
- **FR-004**: Other sections MUST reference the lifecycle when they need proposal, acceptance, capture, Success Measure proposal, discovery-exception, or development-sequence guidance and MUST NOT redefine those concepts.
- **FR-005**: Objective Queue and Acceptance Boundaries MUST own only selection, queue membership, development order, and the capture-boundary reference to the lifecycle.
- **FR-006**: Queue guidance MUST state that selection does not capture an Objective and that queue membership determines development order only.
- **FR-007**: Queue guidance MUST retain the illustrative queue example while removing duplicate normal-path, anti-pattern, proposal-presentation, and person-response lifecycle instructions.
- **FR-008**: Creation Workflow MUST own evidence evaluation, question selection, Business Objective evidence, Success evidence, Highway Relevance decisions, supplied-evidence classification, and correction re-evaluation.
- **FR-009**: Creation Workflow MUST reference the Objective Development Lifecycle when evidence evaluation hands off to Objective development and MUST NOT restate lifecycle mechanics.
- **FR-010**: Creation Workflow MUST NOT create a second proposal-first, Success Measure, acceptance, capture, or queue-processing workflow.
- **FR-011**: Interpretation Confidence MUST own interpretation confidence and correction-oriented reasoning without restating Objective-specific proposal-first behavior.
- **FR-012**: The illustrative Objective Development Example MUST demonstrate Objective visibility before Success Measure questions without defining a miniature lifecycle.
- **FR-013**: Recommendation Development MUST own recommendation grounding, relevance, and preservation of the user-authored path without restating proposal-first Objective development.
- **FR-014**: Recommendation Presentation examples MUST demonstrate useful recommendation output without defining alternative lifecycle or acceptance mechanics.
- **FR-015**: Success Measure guidance outside the lifecycle MUST be reduced to evidence-evaluation or record-contract references and MUST NOT redefine Success Measure proposal behavior.
- **FR-016**: Acceptance references outside the lifecycle MUST identify User Acceptance as defined in the Objective Development Lifecycle and MUST NOT introduce independent acceptance paths.
- **FR-017**: Every section that retains a cross-reference MUST preserve the existing user-authority, advisory, transient, and non-capture boundaries.
- **FR-018**: The source skill and all generated adapters MUST preserve equivalent section ownership, canonical references, and protected Objective behavior.
- **FR-019**: The feature MUST preserve Objective ownership, Business Objective, Success, Highway Relevance, recommendation adoption, queue continuation, portfolio assessment, identifiers, catalogs, atomic persistence, readiness, mutation output, non-write, duplicate, overlap, revalidation, setup orchestration, and Repository Context contracts.
- **FR-020**: The feature MUST not add a new lifecycle state, acceptance mechanism, durable queue, Objective record field, external service, or Objective dimension.

## Key Entities *(include if feature involves data)*

- **Objective Development Lifecycle**: The sole authoritative owner of Objective development mechanics and transitions.
- **Objective Queue and Acceptance Boundaries**: The section owning recommendation selection, queue membership, development order, and the reference to the lifecycle's capture boundary.
- **Creation Workflow**: The section owning evidence evaluation, question selection, classification, and correction re-evaluation.
- **Recommendation Development**: The section owning recommendation grounding, relevance, and the user-authored alternative.
- **Interpretation Confidence**: The section owning confidence-oriented reasoning and correction preference.
- **Illustrative Examples**: Examples that demonstrate useful output without becoming workflow definitions.
- **Canonical Cross-Reference**: A reference to an authoritative owner used instead of duplicating that owner's behavior.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% of focused ownership checks identify the Objective Development Lifecycle as the only owner of lifecycle mechanics, proposal contents, proposal-first behavior, discovery exception behavior, Success Measure proposal behavior, User Acceptance, capture, and development sequence.
- **SC-002**: 100% of focused queue checks find selection, queue membership, development order, and a lifecycle capture-boundary reference, with 0 duplicate lifecycle examples in the queue section.
- **SC-003**: 100% of focused Creation Workflow checks find evidence evaluation responsibilities and 0 duplicate proposal, acceptance, capture, or queue-processing workflows.
- **SC-004**: 100% of focused Interpretation Confidence and Recommendation Development checks find their declared owners without Objective-specific lifecycle restatements.
- **SC-005**: 100% of focused example checks show Objective visibility and useful recommendation output without treating examples as alternative workflow contracts.
- **SC-006**: 100% of focused Success Measure and acceptance cross-reference checks resolve to the Objective Development Lifecycle as the authoritative owner.
- **SC-007**: 100% of generated Objective adapters preserve source section ownership and canonical cross-references.
- **SC-008**: Existing Objective and full repository verification suites remain passing, with no changes to protected ownership, persistence, readiness, or non-write behavior.

## Assumptions

- Feature 162 is the behavioral baseline; Feature 163 removes duplicate explanations without changing the canonical Objective Development Lifecycle.
- Section ownership is a documentation contract validated by focused static checks, not a new runtime dispatch system.
- Existing headings remain unless a small heading adjustment is necessary to make ownership unambiguous.
- Cross-references may mention the lifecycle, User Acceptance, capture, or proposal behavior when needed, but they do not repeat the owned mechanics.
- Existing Experience Standard and Highway Constitution rules remain authoritative and are not copied into the skill.
- Generated adapters remain identity copies of the source skill.
- Static checks can prove ownership markers and absence of duplicate wording, but cannot alone measure conversational quality.

## Out of Scope

- Changing the Objective Development Lifecycle's substantive sequence, proposal fields, Success Measure behavior, User Acceptance semantics, capture mechanics, or user authority.
- Changing Objective record schema, identifiers, catalog format, baseline versions, persistence, readiness, mutation output, duplicate detection, overlap handling, or revalidation.
- Changing Profile behavior, Recommendation grounding sources, Repository Context ownership, Highway Identity, or the Experience Standard.
- Adding a new lifecycle state, acceptance mechanism, durable queue, external service, or Objective dimension.
- Rewriting illustrative examples into mandatory response templates beyond removing workflow duplication.
