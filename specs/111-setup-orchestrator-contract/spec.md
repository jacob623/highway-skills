# Feature Specification: Setup Orchestrator Contract Simplification

**Feature Branch**: `111-setup-orchestrator-contract`

**Created**: 2026-09-30

**Status**: Draft

**Input**: User description: "highway-setup update instructions"

## User Scenarios & Testing

### User Story 1 - Orchestrate owners in order (Priority: P1)

As a person setting up Highway, I want Setup to move through Profile, Objectives, Controls, and NFRs
in a predictable order while each owner retains its own domain behavior.

**Why this priority**: Correct owner ordering and delegation are the core value of Setup.

**Independent Test**: Exercise each owner readiness state and verify Setup delegates only the
owner-provided action, advances only on terminal readiness, and never inspects owner artifacts.

**Acceptance Scenarios**:

1. **Given** Setup begins, **When** it requests readiness, **Then** it evaluates owners in exactly
   Profile, Objectives, Controls, NFRs order.
2. **Given** an owner returns terminal readiness with `Next Action: None`, **When** Setup consumes
   it, **Then** Setup advances to the next owner.
3. **Given** an owner returns a supported `Next Action`, **When** Setup enters that domain, **Then**
   it emits the domain transition when required and delegates only that action.
4. **Given** an owner returns `Blocked`, malformed, or unsupported output, **When** Setup consumes
   it, **Then** Setup stops without invoking a later owner.

### User Story 2 - Continue and resume owner collection safely (Priority: P1)

As a person completing setup, I want collection continuation and completion to be determined by owner
results rather than Setup-specific state or artifact inspection.

**Why this priority**: It prevents Setup from duplicating readiness, persistence, or recovery logic.

**Independent Test**: Exercise owner collection results of Continue, Finished, Declined, Aborted, and
Blocked, then verify fresh readiness and advancement behavior.

**Acceptance Scenarios**:

1. **Given** an owner returns successful `Continue`, **When** Setup consumes the result, **Then** it
   remains with that owner.
2. **Given** an owner returns successful `Finished`, **When** Setup consumes the result, **Then**
   Setup requests fresh readiness before advancing.
3. **Given** a new Setup interaction begins, **When** Setup starts, **Then** it requests fresh
   readiness in Setup order and restores no Setup checkpoint or owner conversational state.
4. **Given** Setup completes, **When** all required owners have returned their declared terminal
   results, **Then** Setup emits the final completion message exactly once.

### User Story 3 - Provide concise domain transitions and completion (Priority: P1)

As a person moving through Setup, I want concise transitions that explain the outcome of the next
domain without duplicating the owner's opening or exposing internal orchestration.

**Why this priority**: Clear transitions preserve the advisor experience while keeping ownership with
the domain skills.

**Independent Test**: Inspect emitted transitions and final completion output for exact wording,
horizontal separation, no owner labels, and no copied owner questions.

**Acceptance Scenarios**:

1. **Given** Setup enters Objectives, **When** it transitions, **Then** it uses an outcome-oriented
   transition equivalent to "Let's identify some outcomes worth pursuing." without copying the
   Objective opening.
2. **Given** Setup enters Controls, **When** it transitions, **Then** it uses the safeguards
   transition without copying the Controls opening or examples.
3. **Given** Setup enters NFRs, **When** it transitions, **Then** it uses the operational-expectations
   transition without previewing owner recommendations.
4. **Given** Setup completes, **When** it emits its conclusion, **Then** it uses the specified
   forward-looking completion message and does not restore a dashboard.

### User Story 4 - Keep the Setup contract thin and shared-governance aligned (Priority: P2)

As a maintainer, I want Setup to declare only orchestration-specific inputs, outputs, workflow,
verification, and exceptions while shared interaction and failure behavior remain centralized.

**Why this priority**: A thin orchestrator reduces duplicated contracts and prevents drift from owner
skills and shared governance.

**Independent Test**: Inspect the canonical Setup skill and contract tests for absence of removed
sections, owner internals, persistence language, and generic experience restatements.

**Acceptance Scenarios**:

1. **Given** Setup Inputs are read, **When** dependencies are listed, **Then** only the project root,
   four owner contracts, Experience Standard, and active user request are named.
2. **Given** Setup behavior is described, **When** the skill is reviewed, **Then** it contains no
   owner-internal candidate state, records, relationships, domain schemas, or artifact persistence.
3. **Given** the Setup skill version is inspected, **When** this rewrite is complete, **Then** it is
   version `8.0.0`.
4. **Given** Setup error handling is inspected, **When** generic failures are considered, **Then**
   they rely on the Constitution common failure model and only Setup-specific exceptions remain.

### Edge Cases

- A terminal owner readiness with a non-None action must not be treated as terminal advancement.
- A successful collection result with an unsupported action must stop rather than manufacture routing.
- A zero-Control or Not Applicable owner state must be consumed from the owner result, never inferred
  from identifiers or artifact counts.
- Setup must not claim completion after Declined, Aborted, Blocked, malformed, or unsupported results.
- A resumed interaction must not restore a prior transition, question, draft, checkpoint, or owner
  conversational state.

## Requirements

### Functional Requirements

- **FR-001**: `highway-setup` MUST be version `8.0.0`.
- **FR-002**: Setup MUST own only owner ordering, transitions, delegation, owner-result consumption,
  and final Setup completion.
- **FR-003**: Setup MUST NOT own domain discovery, recommendations, interpretation, readiness
  calculation, persistence, or owner-internal state.
- **FR-004**: Setup MUST declare only the project root, Profile/Objectives/Controls/NFR owner
  contracts, Experience Standard, and active user request as Inputs.
- **FR-005**: Setup MUST process owners in exactly Profile → Objectives → Controls → NFRs order.
- **FR-006**: Setup MUST request readiness from the current owner and advance only on the owner's
  declared terminal readiness with `Next Action: None`.
- **FR-007**: Setup MUST delegate only an owner-provided supported `Next Action`.
- **FR-008**: Setup MUST stop on owner `Blocked`, `Declined`, `Aborted`, malformed, or unsupported
  results without invoking a later owner.
- **FR-009**: Successful collection `Continue` MUST remain with the current owner; successful
  `Finished` MUST trigger fresh owner readiness.
- **FR-010**: Setup MUST never derive readiness by inspecting owner artifacts or internal state.
- **FR-011**: A new Setup interaction MUST begin by requesting fresh owner readiness in Setup order
  and MUST persist no Setup checkpoint or wizard state.
- **FR-012**: Setup MUST use concise, horizontal-rule-separated transitions for Objectives, Controls,
  and NFRs without duplicating owner openings or exposing owner labels.
- **FR-013**: Setup MUST emit the specified final completion message once and only after all required
  owners reach their declared terminal results.
- **FR-014**: Setup Error Handling MUST contain only Setup-specific exceptions and rely on the
  Constitution common failure model for generic failures.
- **FR-015**: Setup MUST remove the 30-step workflow, Profile routing section, Controls orchestration
  state, Guided Setup interaction contract, per-step error table, persistence-verification language,
  historical `Created Control IDs`, and owner-internal state descriptions.
- **FR-016**: Setup Verification MUST assert owner order, result consumption, delegation, continuation,
  transitions, no artifact writes/checkpoint, fresh resume behavior, and exact completion.
- **FR-017**: Owner artifact schemas MUST NOT change as part of this Setup rewrite.

### Key Entities

- **Setup orchestrator**: The owner-ordering and delegation workflow.
- **Owner readiness result**: The owner-declared state and action that determines whether Setup
  advances, delegates, or stops.
- **Owner collection result**: The owner-declared continuation or completion result consumed by Setup.
- **Domain transition**: Concise Setup-owned context before entering a new owner domain.

## Success Criteria

### Measurable Outcomes

- **SC-001**: The canonical Setup skill and all generated adapters report version `8.0.0`.
- **SC-002**: Contract checks confirm exactly four owner domains are processed in Profile, Objectives,
  Controls, NFRs order.
- **SC-003**: Contract checks confirm Setup never inspects owner artifacts, candidate state, counts,
  records, relationships, or persistence results to derive readiness.
- **SC-004**: Contract checks confirm Continue/Finished, fresh readiness, stop conditions, transitions,
  and final completion behavior.
- **SC-005**: The complete repository suite passes with zero failures and generated artifacts are
  synchronized.
- **SC-006**: No linter diagnostics are introduced in changed canonical, test, or generated files.

## Assumptions

- Existing Profile, Objectives, Controls, and NFR owner contracts remain authoritative and are not
  structurally changed by this feature.
- The Constitution and Experience Standard remain authoritative for generic failure and interaction
  behavior.
- Setup has no independent durable state and does not need a new persistence artifact.
- Existing owner-result fixtures and setup executable tests can be updated to the simplified contract.
