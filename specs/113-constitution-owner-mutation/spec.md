# Feature Specification: Constitution Owner Mutation Boundary

**Feature Branch**: `113-constitution-owner-mutation`

**Created**: 2026-09-30

**Status**: Draft

**Input**: User description: "Constitution-only update instructions"

## User Scenarios & Testing

### User Story 1 - Require owner mutation before dependent results (Priority: P1)

As a Highway workflow owner, I want the Constitution to require accepted mutations to occur before
the owner reports a result that depends on them.

**Why this priority**: It prevents an owner from reporting a dependent outcome before its
authoritative mutation has occurred.

**Independent Test**: Inspect the amended Principle XII rules and verify the mutation-before-result
observable is explicit and testable.

**Acceptance Scenarios**:

1. **Given** an accepted request requires an owner mutation, **When** the owner returns a dependent
   result, **Then** the mutation has already occurred.
2. **Given** the mutation has not occurred, **When** the owner would return a dependent result,
   **Then** the owner must not return that result yet.

### User Story 2 - Keep acceptance distinct from mutation and completion (Priority: P1)

As an orchestrator, I want acceptance, owner mutation, owner result, and orchestration advancement
to remain distinct lifecycle events.

**Why this priority**: It prevents acceptance from being mistaken for mutation and prevents
completion claims before all required owners report terminal outcomes.

**Independent Test**: Verify the Constitution distinguishes acceptance authorization from owner
mutation and requires terminal results from every required owner before completion.

**Acceptance Scenarios**:

1. **Given** a user accepts a mutation-bearing proposal, **When** orchestration receives acceptance,
   **Then** it waits for the owning skill's declared mutation result.
2. **Given** one required owner has not returned its terminal result, **When** orchestration would
   claim completion, **Then** the completion claim is not emitted.
3. **Given** an owner performs a mutation, **When** it returns its result, **Then** no post-write
   persistence-verification lifecycle is required.

### User Story 3 - Preserve Constitution scope and existing owner boundaries (Priority: P1)

As a maintainer, I want this amendment to change only `constitution.md` while preserving existing
owner-control rules and deferring user-visible experience changes.

**Why this priority**: The amendment must establish runtime governance without prematurely changing
skills, templates, or the Experience Standard.

**Independent Test**: Review the change set and Constitution rule inventory to confirm only
`constitution.md` changes and P12.5–P12.12 remain unchanged.

**Acceptance Scenarios**:

1. **Given** the amendment is applied, **When** changed paths are inspected, **Then** only
   `constitution.md` is modified.
2. **Given** Principle XII is reviewed, **When** existing owner-control rules are compared, **Then**
   P12.5 through P12.12 are unchanged.
3. **Given** future experience work is considered, **When** this amendment is complete, **Then**
   no Experience Standard or user-visible interaction rules are added.

### Edge Cases

- An accepted mutation is still pending when an owner result is requested.
- An orchestrator receives acceptance without a mutation result.
- One required owner remains non-terminal while other owners are complete.
- A mutation result is returned without requiring post-write verification.
- A proposed amendment accidentally edits a skill, template, or Experience Standard file.
- Existing Constitution rule counts, precedence, or self-application records are not synchronized.

## Requirements

### Functional Requirements

- **FR-001**: The change MUST modify only `.highway/governance/constitution.md`.
- **FR-002**: Principle XII MUST add P12.13 requiring an owner mutation before a dependent result.
- **FR-003**: P12.13 MUST declare the observable that the mutation occurs before the dependent result.
- **FR-004**: P12.13 MUST use the `[agent-checkable]` tier.
- **FR-005**: Principle XII MUST add P12.14 prohibiting acceptance from being treated as an owner mutation result.
- **FR-006**: P12.14 MUST declare that orchestration waits for the owning skill's declared result.
- **FR-007**: P12.14 MUST use the `[agent-checkable]` tier.
- **FR-008**: Principle XII MUST add P12.15 prohibiting completion before every required owner returns its terminal result.
- **FR-009**: P12.15 MUST declare that the Completion Claim follows every required owner's terminal result.
- **FR-010**: P12.15 MUST use the `[agent-checkable]` tier.
- **FR-011**: P12.5 through P12.12 MUST remain unchanged.
- **FR-012**: The Principle XII rationale MUST state that owners perform accepted mutations they own.
- **FR-013**: The Constitution MUST add the non-normative acceptance-to-owner-result persistence boundary clarification.
- **FR-014**: The persistence clarification MUST exclude post-write Persistence Verification and related read-back checks.
- **FR-015**: Principle XII MUST retain its existing precedence rank.
- **FR-016**: The Principle XII precedence reason MUST mention owner mutation, readiness, results, and orchestrator advancement.
- **FR-017**: The Constitution version MUST increment from `5.0.0` to `6.0.0`.
- **FR-018**: The Sync Impact Report MUST classify the amendment as MAJOR and identify P12.13–P12.15.
- **FR-019**: Constitution rule counts and internal references affected by P12.13–P12.15 MUST be updated.
- **FR-020**: The required self-application review MUST cover P1.1–P1.4, P6.4, P6.6, and P7.3.
- **FR-021**: The change MUST NOT modify the Experience Standard, skills, owner artifacts, or output templates.
- **FR-022**: The Constitution MUST NOT add recommendation, presentation, domain-wrap-up, question-order, or Setup transition rules.

### Key Entities

- **Owner mutation**: An accepted, owner-controlled change to authoritative state.
- **Owner result**: The declared result returned by the owning skill after its mutation lifecycle.
- **Completion Claim**: A workflow statement that all required owner work has completed.
- **Persistence boundary clarification**: Non-normative guidance distinguishing authorization, mutation,
  owner result, and orchestration.

## Success Criteria

### Measurable Outcomes

- **SC-001**: Constitution checks identify exactly three new Principle XII rules, P12.13 through P12.15.
- **SC-002**: All three new rules have one keyword, one observable, and the `[agent-checkable]` tier.
- **SC-003**: A diff audit confirms only `.highway/governance/constitution.md` changes.
- **SC-004**: Rule-count, precedence, version, Sync Impact Report, and self-application checks pass.
- **SC-005**: A text audit finds no new Experience Standard, recommendation, presentation, or Setup
  behavior in the Constitution.
- **SC-006**: The repository test suite passes with zero failures after the amendment.

## Assumptions

- The current Constitution version is `5.0.0`.
- Principle XII remains at its existing precedence rank.
- The Experience Standard will be amended separately after this Constitution change.
- Skills will be reviewed separately against the revised Constitution and are not changed here.
