# Feature Specification: Recommendation Exploration Simplification Pass

**Feature Branch**: `174-recommendation-exploration-simplification`

**Created**: 2026-10-14

**Status**: Draft

**Input**: User description: "Create a Recommendation Exploration Simplification Pass for highway-objectives, highway-controls, and highway-nfrs. Make Recommendation Presentation, Recommendation Exploration, the domain Development Lifecycle, and Queue and Acceptance Boundaries the primary behavioral owners; reduce Creation Workflow to orchestration only; replace user-facing queue-processing language with review-of-selected-artifacts language; preserve internal queue concepts and existing ownership and lifecycle boundaries."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Explore Objective Recommendations Without Competing Paths (Priority: P1)

As a person setting up or extending Business Objectives, I want recommendation presentation and exploration to guide selection and review so that one clear path governs the interaction.

**Why this priority**: Objectives are a primary entry point for downstream Highway context, and competing creation instructions can cause the interaction to bypass recommendation exploration.

**Independent Test**: Starting from useful accepted context, present Objective recommendations, select some or all, add more recommendations while exploration remains active, and request review using ordinary review language. Confirm that review begins only after exhaustion or explicit review intent, then follows the Objective Development Lifecycle.

**Acceptance Scenarios**:

1. **Given** accepted context supports useful Objective recommendations, **When** Objective setup begins, **Then** the interaction follows Recommendation Presentation and Recommendation Exploration before reviewing selected Objectives.
2. **Given** a person selects recommendations and asks for more, **When** useful grounded recommendations remain, **Then** the selected Objective queue can grow and exploration remains active without beginning review.
3. **Given** recommendation exhaustion or explicit review intent, **When** review begins, **Then** selected Objectives proceed through the existing Objective Development Lifecycle, acceptance boundary, and capture behavior.

### User Story 2 - Explore Control Recommendations Without Competing Paths (Priority: P1)

As a person establishing Controls, I want recommendation presentation and exploration to own selection and review initiation so that Control creation instructions do not compete with the recommendation model.

**Why this priority**: Controls govern enforceable safeguards and must preserve independent ownership while making recommendation review predictable.

**Independent Test**: Starting from useful accepted context, present Control recommendations, select and extend the selected set, and request review using ordinary review language. Confirm that review begins only after exhaustion or explicit review intent, then follows the existing Control Development Lifecycle.

**Acceptance Scenarios**:

1. **Given** accepted context supports useful Control recommendations, **When** Control setup begins, **Then** the interaction follows Recommendation Presentation and Recommendation Exploration before reviewing selected Controls.
2. **Given** a person selects Control recommendations and asks for more, **When** useful grounded recommendations remain, **Then** exploration remains active and no Control proposal or capture begins.
3. **Given** recommendation exhaustion or explicit review intent, **When** review begins, **Then** selected Controls proceed through the existing Control Development Lifecycle, acceptance boundary, and capture behavior.

### User Story 3 - Explore NFR Recommendations Without Competing Paths (Priority: P1)

As a person establishing Non-Functional Requirements, I want recommendation presentation and exploration to own selection and review initiation so that NFR setup follows the same understandable model as Objectives and Controls.

**Why this priority**: NFRs already provide the reference recommendation-exploration model, and aligning the three owners reduces inconsistent behavior across Highway governance workflows.

**Independent Test**: Starting from useful accepted context, present NFR recommendations, select and extend the selected set, and request review using ordinary review language. Confirm that review begins only after exhaustion or explicit review intent, then follows the existing NFR Development Lifecycle.

**Acceptance Scenarios**:

1. **Given** accepted context supports useful NFR recommendations, **When** NFR setup begins, **Then** the interaction follows Recommendation Presentation and Recommendation Exploration before reviewing selected NFRs.
2. **Given** a person selects NFR recommendations and asks for more, **When** useful grounded recommendations remain, **Then** exploration remains active and no NFR proposal or capture begins.
3. **Given** recommendation exhaustion or explicit review intent, **When** review begins, **Then** selected NFRs proceed through the existing NFR Development Lifecycle, acceptance boundary, and capture behavior.

### User Story 4 - Preserve Existing Ownership and Lifecycle Boundaries (Priority: P2)

As a maintainer of Highway governance workflows, I want the simplification to remove duplicate orchestration without changing domain ownership, acceptance, persistence, or lifecycle semantics.

**Why this priority**: The change is a behavioral simplification, not a redesign. Preserving boundaries prevents downstream regressions while making the primary path clearer.

**Independent Test**: Compare the three owner contracts before and after simplification and exercise direct user-authored contributions, recommendation selection, review, correction, acceptance, capture, continuation, and explicit finish. Confirm that only orchestration and user-facing terminology change.

**Acceptance Scenarios**:

1. **Given** a person provides a user-authored Objective, Control, or NFR, **When** no useful recommendation is available, **Then** the canonical owner question and existing domain lifecycle remain available without manufacturing a recommendation.
2. **Given** a selected recommendation has not entered review, **When** the person requests explanation, comparison, more information, or additional suggestions, **Then** it remains a Working Idea and no capture occurs.
3. **Given** a selected artifact reaches review, **When** the person corrects, accepts, rejects, or captures it, **Then** existing owner-specific acceptance, persistence, continuation, and explicit-finish behavior remains unchanged.

### Edge Cases

- A person selects recommendations, then requests additional suggestions repeatedly; exploration remains active while useful grounded non-duplicates remain and stops when none remain.
- A person explicitly requests review before recommendation exhaustion; review begins without presenting additional recommendations first.
- No useful grounded recommendation exists; the interaction asks the canonical Objective, Control, or NFR question rather than manufacturing a choice.
- A person provides a complete user-authored artifact while a selected recommendation set exists; the authored artifact follows its normal owner lifecycle and does not silently process the selected set.
- A person asks to process or capture a queue using internal terminology; the interaction responds through the user-facing review language and does not expose internal queue mechanics unnecessarily.
- A recommendation is selected but review has not started; it remains an unreviewed Working Idea and cannot be captured directly.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Objective, Control, and NFR recommendation-exploration contracts MUST each describe Recommendation Exploration, Queue Construction, Recommendation Exhaustion or Explicit Review Intent, and review of the selected domain artifacts as the primary sequence.
- **FR-002**: The Objective exploration contract MUST use "Review of selected Objectives begins only when:" as the user-facing review trigger and MUST retain internal queue processing as an internal workflow concept.
- **FR-003**: The Control exploration contract MUST use "Review of selected Controls begins only when:" as the user-facing review trigger and MUST retain internal queue processing as an internal workflow concept.
- **FR-004**: The NFR exploration contract MUST use "Review of selected NFRs begins only when:" as the user-facing review trigger and MUST retain internal queue processing as an internal workflow concept.
- **FR-005**: Each domain MUST provide explicit review-intent examples using that domain's artifact name and MUST remove user-facing examples that ask the person to process or capture a queue.
- **FR-006**: Recommendation exploration MUST remain active while useful grounded recommendations remain, the person requests additional suggestions, or the person continues selecting recommendations.
- **FR-007**: Recommendation selection MUST NOT begin review, proposal development, acceptance, or capture before recommendation exhaustion or explicit review intent.
- **FR-008**: The three domain workflows MUST preserve queue construction and queue processing as internal concepts where required for lifecycle orchestration, without exposing unnecessary internal processing terminology as user-facing instructions.
- **FR-009**: Objective, Control, and NFR Creation Workflow sections MUST act as orchestration only: invoke Recommendation Presentation when useful context supports recommendations, invoke Recommendation Exploration, invoke review of selected artifacts after exploration ends, invoke the existing domain Development Lifecycle, and continue until explicit finish.
- **FR-010**: Creation Workflow MUST retain the canonical domain question path when useful recommendations cannot be supported and MUST NOT manufacture recommendations.
- **FR-011**: Creation Workflow MUST NOT duplicate recommendation presentation, recommendation exploration, domain development lifecycle, queue membership, acceptance, capture, or continuation rules owned by their dedicated sections.
- **FR-012**: The Objective, Control, and NFR contracts MUST preserve existing domain ownership, recommendation grounding, user-authored alternatives, Working Idea status, correction behavior, acceptance boundaries, persistence behavior, continuation behavior, and explicit-finish behavior.
- **FR-013**: A user-authored Objective, Control, or NFR MUST continue through its existing owner-specific development and acceptance path, even when selected recommendations are present.
- **FR-014**: The simplification MUST preserve the existing distinction between recommendation selection, review, proposal development, acceptance, and capture.
- **FR-015**: User-visible workflow examples and labels MUST use review language for selected Objectives, Controls, and NFRs and MUST NOT instruct the person to "Process the queue" or "Capture the queue."
- **FR-016**: Generated adapters and catalogs MUST remain synchronized with the authoritative Objective, Control, and NFR sources after the contract changes.

## Key Entities *(include if feature involves data)*

- **Recommendation Set**: A transient, grounded collection of Objective, Control, or NFR Working Ideas presented for the person's consideration.
- **Selected Artifact Queue**: A transient ordered set of recommendations selected for later review; membership does not constitute review, acceptance, or capture.
- **Review Intent**: The person's explicit request to begin reviewing selected Objectives, Controls, or NFRs.
- **Domain Development Lifecycle**: The existing owner-specific proposal, acceptance, capture, and continuation path for an Objective, Control, or NFR.
- **Creation Workflow Orchestrator**: The owner entry path that invokes the dedicated recommendation and lifecycle sections without redefining their behavior.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: All three owner contracts use the same four-step recommendation flow: Recommendation Exploration, Queue Construction, Recommendation Exhaustion or Explicit Review Intent, and review of selected domain artifacts.
- **SC-002**: All three owner contracts contain at least one explicit review-intent example and contain zero user-facing examples instructing the person to process or capture a queue.
- **SC-003**: In contract validation, every owner passes checks that selection alone does not begin review, proposal development, acceptance, or capture, and that exploration can continue across multiple recommendation sets.
- **SC-004**: Creation Workflow in each owner contains only orchestration guidance plus the canonical no-recommendation question path, with no duplicated domain lifecycle or queue-boundary behavior.
- **SC-005**: Existing Objective, Control, and NFR lifecycle, acceptance, persistence, continuation, and explicit-finish contract tests remain green after the simplification.
- **SC-006**: Generated adapters remain byte-correspondent with their authoritative sources, and the complete repository validation suite exits with zero failures.

## Assumptions

- The existing NFR recommendation-exploration contract is the behavioral reference for terminology and sequencing.
- Queue construction and queue processing remain internal lifecycle concepts where existing owner workflows require them; this feature changes user-facing wording and ownership of instructions, not the underlying lifecycle.
- No new persisted entity, lifecycle stage, identifier, ownership relationship, readiness state, external dependency, or runtime API is introduced.
- Existing owner-specific canonical questions, proposal formats, acceptance boundaries, persistence transactions, continuation behavior, and explicit-finish rules remain authoritative unless explicitly covered by a requirement above.
- Generated adapters and catalogs continue to be produced from authoritative source files by the repository's existing generators.
- The feature applies only to `highway-objectives`, `highway-controls`, and `highway-nfrs`; other skills are out of scope unless required for generated correspondence.
