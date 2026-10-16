---

description: "Implementation tasks for Highway Onboarding"
---

# Tasks: Highway Onboarding

**Input**: Design documents from `/specs/182-highway-onboarding/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

## Phase 1: Setup

- [X] T001 [P] Add the canonical onboarding skill directory and test fixture directory at `.highway/skills/highway-onboarding/` and `.highway/tools/tests/fixtures/highway-onboarding/`
- [X] T002 [P] Add focused onboarding test entrypoint `.highway/tools/tests/highway-onboarding.test.sh` following the existing Bash 3.2 test harness
- [X] T003 Record Feature 182 source and generated paths in `.highway/tools/.adapter-manifest` through the existing generator workflow

## Phase 2: Foundational

- [X] T004 Add failing contract assertions for onboarding invocation, accepted-context summary, proposal validation, and prohibited substitute artifacts in `.highway/tools/tests/highway-onboarding.test.sh`
- [X] T005 Add failing contract assertions for direct onboarding ADR creation, unchanged Discovery-based ADR behavior, and scalar/list provenance in `.highway/tools/tests/highway-onboarding.test.sh` and `.highway/tools/tests/highway-adr.test.sh`
- [X] T006 Add failing contract assertions for owner ordering, three-attempt retry ceiling, stop-on-failure, durable progress, and manual resume in `.highway/tools/tests/highway-onboarding.test.sh`
- [X] T007 [P] Add canonical interaction and contract references under `.highway/skills/highway-onboarding/SKILL.md` using the Experience Standard, constitution, and shared ADR/Architecture/Implementation contracts
- [X] T008 [P] Preserve `.highway/skills/highway-adr/SKILL.md` as the separate Discovery-based ADR owner while onboarding receives direct ADR creation coverage

## Phase 3: User Story 1 - Understand Existing Capability Coverage (Priority: P1) MVP

**Independent test**: Seed accepted repository artifacts and verify onboarding presents one concise accepted capability summary before requesting new environment evidence, with provisional interpretations clearly labeled.

- [X] T009 [US1] Implement declared repository-context inputs and accepted-versus-observed evidence boundaries in `.highway/skills/highway-onboarding/SKILL.md`
- [X] T010 [US1] Implement the first-response accepted capability summary and provisional interpretation behavior in `.highway/skills/highway-onboarding/SKILL.md`
- [X] T011 [US1] Implement source limitation handling for unavailable or contradictory manually provided websites and imported materials in `.highway/skills/highway-onboarding/SKILL.md`

## Phase 4: User Story 2 - Discover and Confirm Missing Business Capabilities (Priority: P1)

**Independent test**: Present grounded missing capabilities, require the exact correction question, and verify additions, corrections, removals, and uncertainty update only the active onboarding scope.

- [X] T012 [US2] Implement grounded business-language capability proposals and no-grounding behavior in `.highway/skills/highway-onboarding/SKILL.md`
- [X] T013 [US2] Implement the Working Idea, Contribution Opportunity, validation question, uncertainty, rejection, and re-evaluation boundaries in `.highway/skills/highway-onboarding/SKILL.md`
- [X] T014 [US2] Add capability state and queue fixtures for proposed, unknown, accepted, and rejected findings in `.highway/tools/tests/fixtures/highway-onboarding/`

## Phase 5: User Story 3 - Map Capabilities to Existing Platforms (Priority: P1)

**Independent test**: Accept a capability, record multiple platform/process mappings in either direction, preserve optional primary mapping and unknown values, and review grouping without creating an inventory artifact.

- [X] T015 [US3] Implement one-capability-at-a-time mapping prompts with business purpose context in `.highway/skills/highway-onboarding/SKILL.md`
- [X] T016 [US3] Implement many-to-many mapping representation, optional requester-supplied primary mapping, explicit unknowns, and provider grouping projection in `.highway/skills/highway-onboarding/SKILL.md`
- [X] T017 [US3] Add mapping fixtures and assertions proving no provider, application, technology, or landscape catalog is emitted in `.highway/tools/tests/fixtures/highway-onboarding/` and `.highway/tools/tests/highway-onboarding.test.sh`

## Phase 6: User Story 4 - Validate a Proposed Pre-existing Architecture Decision (Priority: P1)

**Independent test**: Review a grouped provider proposal with grounded alternatives and rationale, correct or qualify it, and verify only the accepted stabilized proposal reaches normal ADR persistence.

- [X] T018 [US4] Implement provider-group proposal development, grounded alternatives, historical uncertainty, and rationale limits in `.highway/skills/highway-onboarding/SKILL.md`
- [X] T019 [US4] Implement ADR acceptance boundary and correction-oriented review for proposed pre-existing decisions in `.highway/skills/highway-onboarding/SKILL.md`
- [X] T020 [US4] Add proposal fixtures proving unaccepted rationale and rejected material remain non-durable in `.highway/tools/tests/fixtures/highway-onboarding/` and `.highway/tools/tests/highway-onboarding.test.sh`

## Phase 7: User Story 5 - Continue Through Architecture and Implementation Owners (Priority: P1)

**Independent test**: Accept one onboarding ADR, verify ADR then Architecture then Implementation sequencing, failure stop behavior, bounded retries, resume boundary, and final user-facing relationship summary.

- [X] T021 [US5] Implement direct onboarding ADR input/output, normal shared-template structure, and one-to-one scalar provenance in `.highway/skills/highway-onboarding/SKILL.md` and `.highway/library/templates/output/adr-record.md`
- [X] T022 [US5] Implement successful onboarding ADR-to-Architecture-to-Implementation handoff and user-facing final summary in `.highway/skills/highway-onboarding/SKILL.md`
- [X] T023 [US5] Implement owner failure handling, three retries, preserved successful mutations, and manual resume from the failed owner boundary in `.highway/skills/highway-onboarding/SKILL.md`
- [X] T024 [US5] Add direct onboarding ADR fixtures and compatibility assertions for Discovery-based ADR behavior in `.highway/tools/tests/fixtures/highway-onboarding/`, `.highway/tools/tests/highway-onboarding.test.sh`, and `.highway/tools/tests/highway-adr.test.sh`

## Phase 8: Polish and Cross-Cutting Validation

- [X] T025 [P] Regenerate all declared adapters, catalogs, and manifests from canonical sources using the repository generator tooling
- [X] T026 [P] Update generated correspondence and catalog tests for `highway-onboarding` and the amended `highway-adr` adapters in `.highway/tools/tests/`
- [X] T027 Run focused onboarding and ADR tests, canonical validators, and `.highway/tools/tests/run-all.sh`; record any unrelated baseline failures without altering unrelated files
- [X] T028 Validate `specs/182-highway-onboarding/quickstart.md` against the implemented commands and confirm all tasks in this file are marked complete

## Dependencies & Execution Order

- Setup (T001-T003) precedes all other work.
- Foundational contract tests and canonical skill scaffolds (T004-T008) precede story implementation.
- US1 precedes US2 because capability-gap proposals consume the accepted-context summary.
- US2 precedes US3 because only accepted capabilities enter the mapping queue.
- US3 precedes US4 because provider proposals consume grouped accepted mappings.
- US4 precedes US5 because downstream owners require a persisted accepted ADR.
- Polish begins after all story work and includes adapter regeneration plus full validation.

## Parallel Opportunities

- T001-T003 can run in parallel.
- T004-T006 can run in parallel before implementation.
- T007 and T008 can run in parallel because they modify different canonical skills.
- Fixture-only tasks T014, T017, T020, and T024 can run in parallel with their corresponding canonical contract work once the fixture schema is agreed.
- T025 and T026 can run in parallel after canonical sources are complete.

## Implementation Strategy

1. Establish the canonical skill and failing contract tests.
2. Deliver the accepted-context and capability-discovery MVP through US2.
3. Add many-to-many mapping and validated pre-existing ADR proposal flow.
4. Add direct onboarding ADR creation and downstream owner orchestration.
5. Regenerate all derived artifacts and run focused plus full validation.
