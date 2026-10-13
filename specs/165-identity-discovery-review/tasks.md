# Tasks: Identity Discovery Contribution Opportunity

**Input**: Design documents from `specs/165-identity-discovery-review/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `quickstart.md`

## Phase 1: Setup

- [X] T001 Confirm the Feature 165 source, test, adapter, and validation paths in `specs/165-identity-discovery-review/plan.md`
- [X] T002 Record the passing pre-change repository validation baseline with `bash .highway/tools/tests/run-all.sh`

## Phase 2: Foundational

- [X] T003 [P] Verify the Feature 165 checklist is complete and the active feature pointer resolves to `specs/165-identity-discovery-review` in `.specify/feature.json`
- [X] T004 [P] Inspect `.highway/skills/highway-profile/SKILL.md` and adjacent Profile contract tests before editing the source skill

## Phase 3: User Story 1 - Review discovered organizational expressions (Priority: P1)

**Goal**: Present a structured, omission-detection Identity review before Identity convergence when material website, imported, or discovery evidence contributes.

**Independent Test**: The focused contract test finds the review heading, evidence triggers, required invitation, examples, and ordering before the existing Identity Converged Proposal.

- [X] T005 [US1] Add failing static contract assertions for the structured review, material evidence triggers, omission-detection purpose, review ordering, and correction invitation in `.highway/tools/tests/feature-165-identity-discovery-review.test.sh`
- [X] T006 [US1] Add the optional Identity Discovery Contribution Opportunity behavior and evidence-triggered ordering to `.highway/skills/highway-profile/SKILL.md`

## Phase 4: User Story 2 - Understand meaningful expressions rather than labels (Priority: P1)

**Goal**: Make each finding a concise meaningful title paired with one evidence-grounded summary, without fixed taxonomy or unsupported facts.

**Independent Test**: The focused contract test finds the four representative title-and-summary examples, the no-isolated-label rule, the supported-expression categories, and omission/uncertainty handling.

- [X] T007 [US2] Extend the failing static contract assertions for meaningful finding titles, one-sentence summaries, representative examples, flexible expression categories, and unsupported-label handling in `.highway/tools/tests/feature-165-identity-discovery-review.test.sh`
- [X] T008 [US2] Add the evidence-grounded finding format, representative examples, flexible expression scope, and unsupported-evidence boundary to `.highway/skills/highway-profile/SKILL.md`

## Phase 5: User Story 3 - Preserve Identity convergence and ownership boundaries (Priority: P1)

**Goal**: Keep review content proposed and transient, re-synthesize after meaningful corrections, wait for stability, and then use the existing convergence, acceptance, persistence, and readiness boundaries.

**Independent Test**: The focused contract test finds Contribution Opportunity terminology, all correction operations, re-synthesis/re-presentation, stability gating, separate review/proposal artifacts, existing acceptance/persistence boundaries, and setup repository-name guidance.

- [X] T009 [US3] Extend the failing static contract assertions for the Contribution Opportunity lifecycle, correction loop, stability gate, separate artifacts, protected Profile boundaries, and repository-name guidance in `.highway/tools/tests/feature-165-identity-discovery-review.test.sh`
- [X] T010 [US3] Add the transient proposed-evidence lifecycle, correction re-synthesis loop, stability transition, separate-artifact wording, review boundary, and repository-name guidance to `.highway/skills/highway-profile/SKILL.md`

## Phase 6: Polish and Cross-Cutting Validation

- [X] T011 Regenerate all Profile adapters from `.highway/skills/highway-profile/SKILL.md` with `.highway/tools/generate-agent-adapters.sh`
- [X] T012 [P] Run the focused Feature 165 contract and adjacent Profile contract tests listed in `specs/165-identity-discovery-review/quickstart.md`
- [X] T013 Run the complete repository suite with `.highway/tools/tests/run-all.sh`
- [X] T014 Run `git diff --check` and verify all generated Profile adapters remain synchronized with the source
- [X] T015 Mark all completed Feature 165 tasks `[X]` in `specs/165-identity-discovery-review/tasks.md` and record requirement coverage separately from test results

## Dependencies and Execution Order

- Setup (T001-T002) precedes all later work.
- Foundational checks (T003-T004) precede story work.
- User Story 1 (T005-T006) precedes User Story 2 because both edit the source and focused test files.
- User Story 2 (T007-T008) precedes User Story 3 for the same shared-file constraint.
- User Story 3 (T009-T010) precedes adapter regeneration and validation.
- T011 precedes T012-T014; T012 and T013 are validation gates, and T014 is the final hygiene check.
- T015 is last and is performed only after all checks pass.

## Parallel Opportunities

- T003 and T004 can be inspected in parallel after setup.
- No story implementation tasks are parallelized because US1, US2, and US3 intentionally edit the same source and focused test files.
- T012 can run in parallel with other read-only validation only after T011 completes; T013 remains the authoritative full-suite gate.

## Implementation Strategy

1. Establish the repository and checklist baseline.
2. Add the focused contract assertions and observe them fail against the current source.
3. Implement the three story slices in priority order while preserving existing Profile boundaries.
4. Regenerate adapters, run focused and adjacent checks, then run the full suite and whitespace validation.
5. Mark tasks complete only after executable validation passes.
