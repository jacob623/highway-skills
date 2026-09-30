# Feature Specification: Final Setup Contract Cleanup

**Feature Branch**: `112-final-setup-cleanup`

**Created**: 2026-09-30

**Status**: Draft

**Input**: User description: "Final highway-setup cleanup instructions"

## User Scenarios & Testing

### User Story 1 - Route owner-specific results (Priority: P1)

As a person completing Highway setup, I want Setup to respect each owner's result contract so
Profile and Objectives are not forced into the Controls/NFR collection-result shape.

**Why this priority**: Incorrectly shared result semantics can misroute setup or block valid owner
work.

**Independent Test**: Exercise readiness and active-result cases for all four owners, confirming
that Setup delegates owner actions and consumes owner-specific result formats.

**Acceptance Scenarios**:

1. **Given** Setup is at an owner, **When** readiness is terminal with `Next Action: None`,
   **Then** Setup advances in Profile → Objectives → Controls → NFRs order.
2. **Given** an owner supplies a supported `Next Action`, **When** Setup delegates it, **Then**
   Setup consumes the result declared by that owner.
3. **Given** Controls or NFRs return their declared Collection Result, **When** the result is
   `Continue` or `Finished`, **Then** Setup follows that contract.
4. **Given** Profile or Objectives return their own owner result, **When** Setup consumes it,
   **Then** Setup does not require `Action Status` or `Collection Result`.
5. **Given** owner output is malformed, blocked, declined, aborted, or unsupported, **When** Setup
   consumes it, **Then** Setup stops without advancing.

### User Story 2 - Start and resume setup with correct user experience (Priority: P1)

As a person beginning or resuming setup, I want a clear first-run welcome and predictable domain
transitions without repeated openings or misleading previews.

**Why this priority**: The first interaction establishes ownership and the transitions explain why
each setup domain is being entered.

**Independent Test**: Start initial Setup and a resumed Setup separately, then inspect welcome
frequency, exact transition blocks, separators, and owner-opening behavior.

**Acceptance Scenarios**:

1. **Given** initial Setup is beginning, **When** Profile interaction is first delegated, **Then**
   Setup emits the specified Highway welcome exactly once before the Profile-owned action.
2. **Given** Setup is resumed, **When** fresh readiness is requested, **Then** the first-run welcome
   is not repeated.
3. **Given** Setup enters an active Objectives, Controls, or NFR domain, **When** its first owner
   interaction is delegated, **Then** Setup emits the exact transition block with `---`.
4. **Given** an owner is already terminal and skipped, **When** Setup advances, **Then** it emits
   no transition for that skipped domain.
5. **Given** Setup continues within one domain, **When** another owner interaction occurs, **Then**
   it does not repeat the domain transition or duplicate the owner opening.

### User Story 3 - Preserve the corrected thin contract (Priority: P1)

As a maintainer, I want the Setup skill to retain only its owner orchestration contract while its
metadata, Inputs, Completion, Resume, Error Handling, and Verification remain valid.

**Why this priority**: This cleanup completes the existing `8.0.0` contract without reopening
duplicated governance rules.

**Independent Test**: Inspect the canonical skill, generated adapters, and contract tests for the
valid Purpose heading, exact Inputs, concise exceptions, and required verification outcomes.

**Acceptance Scenarios**:

1. **Given** the skill frontmatter is read, **When** the Purpose section is located, **Then**
   `version: 8.0.0` is followed by `### Purpose` and the existing Purpose sentence is preserved.
2. **Given** Inputs are read, **When** dependencies are listed, **Then** only the seven declared
   Setup inputs remain and the duplicated readiness list is absent.
3. **Given** Resume is read, **When** a new interaction begins, **Then** Setup requests fresh
   readiness, persists no checkpoint, and restores no owner conversational state.
4. **Given** Completion is reached, **When** all four owners permit advancement in order, **Then**
   Setup emits the Outputs conclusion exactly once.
5. **Given** Verification is reviewed, **When** generic Constitution boundary rules are considered,
   **Then** only Setup-specific checks remain.

### Edge Cases

- An owner can be terminal without using the Controls/NFR collection-result fields.
- A supported owner action can produce a valid owner-specific result that requires continued work.
- A transition must not appear when a domain is skipped or while its interaction continues.
- A resumed Setup interaction must not emit the initial welcome.
- A malformed metadata/Purpose boundary must fail validation even if the Purpose sentence exists.
- Setup must not complete after a blocked, declined, aborted, malformed, or unsupported owner result.

## Requirements

### Functional Requirements

- **FR-001**: `highway-setup` MUST keep version `8.0.0`.
- **FR-002**: The metadata MUST place `### Purpose` after the `version: 8.0.0` line.
- **FR-003**: The Purpose section MUST preserve the existing owner-orchestration sentence.
- **FR-004**: Setup MUST process owners in Profile → Objectives → Controls → NFRs order.
- **FR-005**: Setup MUST consume each owner's declared result contract.
- **FR-006**: Setup MUST NOT impose `Action Status` and `Collection Result` on Profile or Objectives.
- **FR-007**: Setup MUST use Controls and NFRs declared Collection Result contracts.
- **FR-008**: Setup MUST request fresh readiness after an owner's active collection/work finishes.
- **FR-009**: Setup MUST stop on malformed, blocked, declined, aborted, or unsupported owner output.
- **FR-010**: Setup MUST emit the specified first-run welcome before the initial Profile interaction.
- **FR-011**: Setup MUST omit the first-run welcome on resumed interactions.
- **FR-012**: Setup MUST emit each exact domain transition with a preceding horizontal rule only when
  delegating the first active interaction for that domain.
- **FR-013**: Setup MUST NOT repeat a domain transition during continued interaction.
- **FR-014**: Setup MUST NOT duplicate an owner opening after a Setup transition.
- **FR-015**: Setup Inputs MUST contain only the project root, four owner contracts, Experience
  Standard, and active user request.
- **FR-016**: Setup Inputs MUST omit the duplicated readiness list.
- **FR-017**: Setup MUST retain fresh-readiness resume behavior without a checkpoint or conversational
  state restoration.
- **FR-018**: Setup Completion MUST state that the conclusion is emitted once after all four owners
  permit advancement in Setup order.
- **FR-019**: Setup Verification MUST cover owner-specific result contracts, welcome behavior,
  transition separators, resume behavior, and final completion.
- **FR-020**: Setup MUST retain only Setup-specific Error Handling exceptions and keep version `8.0.0`.

### Key Entities

- **Owner readiness**: The readiness result supplied by the current domain owner.
- **Owner-specific action result**: The result contract supplied after Setup delegates an owner action.
- **First-run welcome**: The one-time introductory Setup message shown before initial Profile work.
- **Domain transition**: A Setup-owned separator and concise context block before first active domain work.

## Success Criteria

### Measurable Outcomes

- **SC-001**: Contract tests confirm the Purpose heading, version, sentence, and exact Inputs structure.
- **SC-002**: Contract tests confirm all four owners are routed in the required order and no owner
  is forced into an unrelated collection-result schema.
- **SC-003**: Interaction tests confirm the initial welcome appears once, resumed interactions omit it,
  and each active-domain transition contains `---`.
- **SC-004**: Interaction tests confirm skipped domains and continued domains do not emit duplicate
  transitions or owner openings.
- **SC-005**: The complete repository suite passes with zero failures and generated artifacts remain
  synchronized.
- **SC-006**: No linter diagnostics are introduced in changed files.

## Assumptions

- Existing Profile, Objectives, Controls, and NFR owner contracts remain authoritative.
- Controls and NFRs continue to use their existing Collection Result contracts.
- Profile and Objectives continue to use their existing owner-specific result contracts.
- The Highway Experience Standard remains authoritative for generic interaction behavior.
- The `8.0.0` version remains correct because this is a cleanup/correction of that contract.
