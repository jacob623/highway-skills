# Feature Specification: Highway New Proposal-First Request Development

**Feature Branch**: `181-highway-new-proposal-first`

**Created**: 2026-10-15

**Status**: Draft

**Input**: User description: "Modernize highway-new from questionnaire-first intake to proposal-first Request development while preserving Request ownership, evidence completeness, Request creation, and Discovery handoff contracts."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Review a Proposed Request Starting Point (Priority: P1)

As a requester who has supplied enough initial evidence for a responsible interpretation, I want Highway to present a proposed starting point for my Request so I can correct omissions and misunderstandings instead of constructing the Request domain by domain.

**Why this priority**: Proposal-first intake is the central change and gives immediate value whenever the requester's evidence already supports a useful understanding.

**Independent Test**: Provide initial evidence covering a meaningful subset of Request domains and confirm Highway presents a Request Discovery Contribution Opportunity with a grounded proposal, a correction-oriented question, and no acceptance request.

**Acceptance Scenarios**:

1. **Given** accepted evidence supports a responsible first-pass interpretation, **When** the requester begins `highway-new`, **Then** Highway presents "Here is a proposed starting point for your Request:" followed by the available Request understanding.
2. **Given** a Request Discovery Contribution Opportunity is presented, **When** the requester reviews it, **Then** the opportunity ends with "What would you add, correct, or remove?" and does not ask the requester to accept or create the Request.
3. **Given** the initial evidence does not support a responsible proposal, **When** the requester begins `highway-new`, **Then** Highway asks for one consequential missing contribution and does not invent an interpretation.

### User Story 2 - Refine the Request and Collect Only Missing Evidence (Priority: P1)

As a requester refining a proposed Request, I want my additions, corrections, removals, and refinements to update the active understanding while Highway asks only for evidence that remains consequentially missing.

**Why this priority**: Refinement must be reliable before the workflow can converge or create a durable Request.

**Independent Test**: Start with a proposal, provide a substantive correction, and verify that the next proposal reflects the change, accepted evidence is not requested again, and only unresolved evidence domains remain available for collection.

**Acceptance Scenarios**:

1. **Given** a Request Proposal contains a current process already supplied by the requester, **When** Highway continues intake, **Then** it reuses that evidence and does not ask the requester to describe the current process again.
2. **Given** the requester adds, corrects, removes, combines, narrows, or qualifies substantive information, **When** Highway processes the contribution, **Then** it re-evaluates the active proposal and reflects the change in the next user-relevant interaction.
3. **Given** some evidence domains remain incomplete, **When** the proposal is refreshed, **Then** Highway asks only for the next consequential missing evidence and leaves known evidence unchanged.
4. **Given** evidence is unavailable or uncertain, **When** Highway presents the proposal, **Then** it represents that evidence as `Unknown` rather than inventing content.

### User Story 3 - Accept a Converged Proposal and Create the Request (Priority: P1)

As a requester whose Request understanding has stabilized, I want to review and accept a Converged Request Proposal before creation so that acceptance authorizes creation without being confused with an earlier contribution or draft review.

**Why this priority**: The feature must improve collaboration without weakening the existing Request creation and evidence completeness boundary.

**Independent Test**: Converge all seven evidence domains, present the complete proposal under the required review heading, provide an unambiguous acceptance, and verify that creation occurs only after completeness validation and successful persistence.

**Acceptance Scenarios**:

1. **Given** all seven evidence domains are complete and the proposal has converged, **When** Highway presents the Request for review, **Then** it uses "Here's what I've captured as your request:" and includes Title, Problem, Actors, Current Process, Desired Change, Success Measures, Business Constraints, and Solution Constraints.
2. **Given** a Contribution Opportunity or draft proposal is shown, **When** the requester says it is accurate, **Then** Highway does not treat that response as Request acceptance unless the workflow has reached the Converged Request Proposal acceptance boundary.
3. **Given** the requester accepts a complete Converged Request Proposal, **When** evidence completeness validation and persistence validation succeed, **Then** Highway creates the Request and provides a concise synthesis and Discovery guidance.
4. **Given** any evidence domain is incomplete or persistence validation fails, **When** the requester attempts to proceed, **Then** Highway creates no Request artifact and preserves existing Request-owned state.

### User Story 4 - Preserve Request Ownership and Downstream Boundaries (Priority: P1)

As a repository owner, I want proposal-first intake to preserve Request ownership and the existing boundaries with Discovery and ADR so that improved interaction does not create architectural decisions or substitute artifacts.

**Why this priority**: Boundary preservation is essential for trust, traceability, and compatibility with existing workflows.

**Independent Test**: Exercise proposal, refinement, evidence collection, and acceptance paths and verify that Request remains the only owner of Request creation, Discovery analysis is not performed, ADR content is not generated, and existing Solution Constraint rules remain unchanged.

**Acceptance Scenarios**:

1. **Given** a Request Proposal is being developed, **When** Highway offers interpretations or suggestions, **Then** they remain Working Idea material and are not retained as accepted Request evidence without the applicable acceptance boundary.
2. **Given** a requester asks for architecture or solution analysis during intake, **When** Highway identifies the request as outside `highway-new`, **Then** it routes to the owning workflow without creating Discovery or ADR content.
3. **Given** Solution Constraints are partially known, **When** Highway presents or refreshes the proposal, **Then** all existing constraint fields remain available, missing values remain `Unknown`, and the rules for valid field shapes and evidence completeness remain unchanged.

### Edge Cases

- Initial evidence may support only a partial interpretation; Highway must present a useful starting point only when it can do so responsibly.
- The requester may provide a complete domain statement immediately; Highway must reuse it without forcing unnecessary exploratory turns.
- The requester may correct or remove a previously proposed interpretation; the active proposal must reflect the correction and must not preserve the rejected framing as accepted evidence.
- The requester may ask for more information or examples; that request must not be treated as acceptance.
- Evidence may contain secrets or regulated personal data; existing privacy handling must remain in force and blocked content must not be retained.
- A requester may stop responding, pause, cancel, or provide an owner outcome before convergence; no incomplete Request may be created.
- A proposal may remain incomplete because one or more evidence domains are unknown; Highway must continue with explicit `Unknown` values and ask only consequential missing questions.
- A Request catalog or allocation may be missing, malformed, or changed during creation; existing validation, retry, and no-write behavior must remain in force.
- A requester may ask for Discovery or ADR behavior before Request creation; intake must not perform that downstream analysis.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Highway MUST begin Request development from a Request Proposal whenever accepted evidence supports a responsible first-pass understanding.
- **FR-002**: Highway MUST present the Request Discovery Contribution Opportunity with the exact starting-point prompt "Here is a proposed starting point for your Request:".
- **FR-003**: A Request Discovery Contribution Opportunity MUST describe proposed understanding as a Working Idea and MUST not request acceptance, create a Request, persist a Request, perform Discovery analysis, or propose an architecture decision.
- **FR-004**: A Request Discovery Contribution Opportunity MUST end with the correction-oriented Validation Question "What would you add, correct, or remove?" or a sharper equivalent that still invites correction rather than agreement.
- **FR-005**: Highway MUST provide Response Support Text for validation, acceptance reassurance, uncertainty, combined confirmation and uncertainty, additional suggestions, and Request Proposal purpose as appropriate to the active interaction.
- **FR-006**: The Validation Question MUST be the only emphasized element in a Request review block.
- **FR-007**: Highway MUST maintain the Request Development Lifecycle from requester evidence through contribution opportunity, proposal refinement, Converged Request Proposal, user acceptance, completeness validation, and Request creation.
- **FR-008**: Highway MUST re-evaluate the active proposal after each substantive addition, correction, removal, combination, narrowing, qualification, or redirection from the requester.
- **FR-009**: Highway MUST reuse accepted evidence that already satisfies a Request evidence domain and MUST not ask for that evidence again merely because the workflow has advanced.
- **FR-010**: After a proposal exists, Highway MUST collect only consequential missing evidence owned by the requester and MUST not follow a fixed questionnaire order when that order would repeat known evidence.
- **FR-011**: A Converged Request Proposal MUST contain Title, Problem, Actors, Current Process, Desired Change, Success Measures, Business Constraints, and Solution Constraints.
- **FR-012**: Unknown or unavailable evidence MUST remain explicitly `Unknown`; Highway MUST NOT invent missing evidence or present its own interpretation as accepted requester evidence.
- **FR-013**: A materially interpreted Converged Request Proposal MUST appear beneath "Here's what I've captured as your request:" and MUST end with the Validation Question followed by applicable reassurance.
- **FR-014**: Request acceptance MUST occur only after a Converged Request Proposal, user acceptance, and Evidence Completeness Validation; acceptance MUST authorize creation but MUST NOT itself create the Request.
- **FR-015**: Highway MUST preserve the existing seven Request evidence domains: Problem, Actors, Current Process, Desired Change, Success Measure, Business Constraints, and Solution Constraints.
- **FR-016**: Highway MUST preserve the existing Solution Constraint fields and validation rules: `allowed_solution_classes`, `existing_platforms_required`, `existing_platforms_preferred`, `known_systems`, `hosting_restrictions`, `vendor_restrictions`, `procurement_constraints`, and `regulatory_restrictions`.
- **FR-017**: Highway MUST create a Request only when all seven evidence domains satisfy the existing Evidence Completeness Rules and all existing allocation, validation, privacy, and persistence checks succeed.
- **FR-018**: Highway MUST preserve Request ownership of identifiers, Request records, Request catalogs, completeness, acceptance, and creation outcomes.
- **FR-019**: Highway MUST not perform Discovery analysis, create ADR content, propose architecture decisions, or create substitute artifacts during Request development.
- **FR-020**: After successful Request creation, Highway MUST provide a concise synthesis and point the requester to `/highway-discovery REQXXXXXX` for option evaluation against available Objectives, Controls, and NFRs.
- **FR-021**: Highway MUST preserve existing pause, cancellation, stop-response, declined, aborted, blocked, privacy, allocation, retry, validation, no-write, and deterministic behavior.
- **FR-022**: Highway MUST preserve the distinction between Working Idea material, Contribution Opportunities, Converged Proposals, accepted Request evidence, and persisted Request artifacts.

### Key Entities *(include if feature involves data)*

- **Requester Evidence**: User-owned information supplied during Request development across the seven evidence domains.
- **Request Discovery Contribution Opportunity**: A transient, proposed starting point that invites substantive correction or extension and is not eligible for acceptance or persistence.
- **Request Proposal**: A Working Idea that organizes available evidence into a provisional understanding of a Request.
- **Converged Request Proposal**: A complete, reviewable proposal whose understanding has stabilized enough to cross the Request acceptance boundary.
- **Response Support Text**: Context-sensitive reassurance and validation language that helps the requester correct, accept, or originate evidence without changing ownership.
- **Request Evidence Domain**: One of the seven completeness domains required for Request creation.
- **Solution Constraints**: The eight existing fields that constrain the future candidate space without selecting an architecture or solution.
- **Request Acceptance**: The user-owned boundary authorizing creation after a Converged Request Proposal and completeness validation.
- **Request Record and Catalog**: The durable Request artifacts owned by `highway-new` after successful creation.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In at least 95% of test scenarios where initial evidence supports a responsible interpretation, Highway presents a Request Proposal before asking a domain question.
- **SC-002**: In 100% of proposal-refinement scenarios, evidence already represented in the active proposal is reused and is not requested again as a duplicate question.
- **SC-003**: In 100% of Contribution Opportunity scenarios, the interaction uses a correction-oriented closing question and contains no acceptance request.
- **SC-004**: In 100% of Converged Request Proposal scenarios, all eight required proposal fields appear beneath the required request-review heading before acceptance is requested.
- **SC-005**: In 100% of incomplete, cancelled, blocked, privacy-rejected, or failed-persistence scenarios, no Request record or catalog mutation occurs.
- **SC-006**: In 100% of acceptance scenarios, Request creation occurs only after all seven evidence domains pass existing completeness validation and the requester has accepted the Converged Request Proposal.
- **SC-007**: In 100% of proposal-first scenarios, no Discovery analysis, ADR content, architecture decision, or substitute Request artifact is created.
- **SC-008**: Requesters can identify the next consequential missing evidence after reviewing a proposal in at least 90% of usability evaluations.
- **SC-009**: At least 90% of representative intake evaluations report that proposal-first review makes it easier to correct Highway's understanding than questionnaire-first intake.
- **SC-010**: Existing Request creation and Discovery handoff regression scenarios retain their current pass rate with no loss of Solution Constraint validation coverage.

## Assumptions

- `highway-new` remains the sole owner of Request evidence completeness, acceptance, identifiers, Request records, Request catalogs, and Request creation.
- The seven evidence domains and all existing Solution Constraint field shapes remain unchanged in this feature.
- A Request Proposal and Contribution Opportunity are conversational Working Ideas and do not require new durable artifacts before Request creation.
- Existing Highway Experience Standard rules govern emphasis, contribution opportunities, convergence, acceptance, evidence reuse, attribution, and user-visible support text.
- Profile, Objectives, Controls, and NFRs may provide contextual examples or grounded evidence through their owning workflows, but they do not become Request evidence automatically without the existing ownership and acceptance rules.
- Discovery and ADR remain downstream boundaries; the feature does not add solution recommendation, architecture selection, or decision persistence to Request intake.
- Unknown evidence is an acceptable explicit state during development but does not satisfy a required completeness rule unless the existing Request contract already permits it for that field.
- Existing privacy screening, deterministic behavior, allocation retry limits, and no-write guarantees remain authoritative.
- The feature is limited to Request intake interaction and its verification; new UI, service, storage, or external integration capabilities are out of scope.
