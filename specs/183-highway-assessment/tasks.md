---

description: "Task list for Highway Assessment MVP implementation"
---

# Tasks: Highway Assessment

**Input**: Design documents from `/specs/183-highway-assessment/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Organization**: Tasks are grouped by user story so each story can be implemented and validated independently.

## Phase 1: Setup (Shared Infrastructure)

- [X] T001 [P] Confirm the canonical assessment skill, findings template, findings knowledge artifact, and focused test paths in `.highway/skills/highway-assessment/SKILL.md`, `.highway/library/templates/output/assessment-findings.md`, `.highway/library/knowledge/assessment-findings.md`, and `.highway/tools/tests/highway-assessment.test.sh`.
- [X] T002 [P] Review the Highway Experience Standard and repository governance constraints used by assessment in `.highway/governance/experience-standard.md` and `.highway/governance/constitution.md`.

## Phase 2: Foundational (Blocking Prerequisites)

- [X] T003 Implement the shared findings output structure and revision field in `.highway/library/templates/output/assessment-findings.md`.
- [X] T004 Implement the validated findings record schema, fields, statuses, and initial revision in `.highway/library/knowledge/assessment-findings.md`.
- [X] T005 [P] Add focused static and shell contract coverage for findings categories, statuses, identity, advisory boundaries, and supported domains in `.highway/tools/tests/highway-assessment.test.sh`.
- [X] T006 Run `.highway/tools/validate-library.sh` for the findings template and knowledge artifact and `.highway/tools/validate-skill.sh` for the canonical skill.

## Phase 3: User Story 1 - Review Existing Findings (Priority: P1) MVP

**Goal**: Present retained Open findings before any new assessment analysis and default to Portfolio when no domain is supplied.

**Independent Test**: Seed a findings record with mixed statuses, invoke assessment without a domain, and verify every Open finding appears first as a concise ID-and-summary bullet while non-Open findings do not appear in the open queue.

### Tests for User Story 1

- [X] T007 [US1] Add focused assertions for Open-first presentation, empty-open behavior, mixed-status filtering, and Portfolio default in `.highway/tools/tests/highway-assessment.test.sh`.

### Implementation for User Story 1

- [X] T008 [US1] Document the `/highway-assessment` entry point, `architectures`, `implementations`, and `portfolio` domains, and Portfolio default in `.highway/skills/highway-assessment/SKILL.md`.
- [X] T009 [US1] Document findings loading and concise Open finding presentation before new analysis in `.highway/skills/highway-assessment/SKILL.md`.
- [X] T010 [US1] Validate User Story 1 with `bash .highway/tools/tests/highway-assessment.test.sh` and the manual scenarios in `specs/183-highway-assessment/quickstart.md`.

## Phase 4: User Story 2 - Assess Accepted Knowledge (Priority: P1)

**Goal**: Analyze accepted repository knowledge across supported domains and propose only grounded advisory observations.

**Independent Test**: Provide accepted context supporting a coverage gap, inconsistency, dependency, opportunity, reuse pattern, or risk; run each supported domain and verify the proposal identifies category, domain, evidence, and uncertainty without mutating owner artifacts.

### Tests for User Story 2

- [X] T011 [P] [US2] Add focused assertions for all six finding categories, all three domains, evidence grounding, uncertainty preservation, and owner-artifact non-mutation in `.highway/tools/tests/highway-assessment.test.sh`.

### Implementation for User Story 2

- [X] T012 [US2] Define accepted repository context precedence and supported analysis scope for Profile, Objectives, Controls, NFRs, ADRs, Reference Architectures, and Reference Implementations in `.highway/skills/highway-assessment/SKILL.md`.
- [X] T013 [US2] Define the correction-oriented Response Support Text, Interpretation Confidence, and Onboarding Contribution Opportunity interaction sections in `.highway/skills/highway-assessment/SKILL.md`.
- [X] T014 [US2] Define advisory routing and explicit exclusions for architecture, implementation, dependency, capability, inventory, and substitute artifact creation in `.highway/skills/highway-assessment/SKILL.md`.
- [X] T015 [US2] Validate User Story 2 with `.highway/tools/validate-skill.sh` and `bash .highway/tools/tests/highway-assessment.test.sh`.

## Phase 5: User Story 3 - Review and Disposition Findings (Priority: P1)

**Goal**: Support explicit human review dispositions while retaining advisory status and preserving unrelated findings.

**Independent Test**: Exercise Accept, Dismiss, Resolve, Supersede, and Request More Information, reload the findings record, and verify status, disposition, and unrelated rows behave according to the transition contract.

### Tests for User Story 3

- [X] T016 [P] [US3] Add focused assertions for supported transitions, status-neutral Request More Information, malformed-record rejection, and unrelated-row preservation in `.highway/tools/tests/highway-assessment.test.sh`.

### Implementation for User Story 3

- [X] T017 [US3] Define the finding status transition table and disposition semantics in `.highway/skills/highway-assessment/SKILL.md` and `.highway/library/templates/output/assessment-findings.md`.
- [X] T018 [US3] Define complete-record validation, stale revision rejection, reload-before-retry behavior, and exactly-once revision increments in `.highway/skills/highway-assessment/SKILL.md` and `.highway/library/templates/output/assessment-findings.md`.
- [X] T019 [US3] Define persistence and review behavior for `.highway/library/knowledge/assessment-findings.md` without changing unrelated rows.
- [X] T020 [US3] Validate User Story 3 with the focused test and the stale-update scenario in `specs/183-highway-assessment/quickstart.md`.

## Phase 6: User Story 4 - Reuse Findings as Context (Priority: P2)

**Goal**: Make reviewed findings reusable repository context without transferring mutation authority or creating duplicate findings.

**Independent Test**: Load findings with every supported status in a consuming workflow and verify category, domain, status, and disposition remain distinguishable; repeat equivalent analysis and verify the existing F-series row is reused.

### Tests for User Story 4

- [X] T021 [P] [US4] Add focused assertions for reusable status/category/domain/disposition context and duplicate prevention by deterministic fingerprint in `.highway/tools/tests/highway-assessment.test.sh`.

### Implementation for User Story 4

- [X] T022 [US4] Define deterministic normalization and fingerprint composition from Category, Domain, and Finding Text in `.highway/skills/highway-assessment/SKILL.md` and `specs/183-highway-assessment/data-model.md`.
- [X] T023 [US4] Define sequential zero-padded `F###` allocation, existing-ID reuse, and no-new-identifier-family constraints in `.highway/skills/highway-assessment/SKILL.md`.
- [X] T024 [US4] Define downstream context consumption and the boundary that prevents findings from creating owner artifacts in `.highway/skills/highway-assessment/SKILL.md` and `specs/183-highway-assessment/contracts/assessment-findings.md`.
- [X] T025 [US4] Validate User Story 4 with the focused test and repeated-input scenarios in `specs/183-highway-assessment/quickstart.md`.

## Phase 7: Polish & Cross-Cutting Concerns

- [X] T026 [P] Regenerate adapters and catalogs with `.highway/tools/generate-agent-adapters.sh`, `.highway/tools/generate-catalog.sh`, and `.highway/tools/generate-library-catalog.sh`.
- [X] T027 [P] Register the assessment adapters and output template in `.highway/tools/.distribution-manifest` and extend output-template governance in `.highway/tools/tests/output-template.test.sh`.
- [X] T028 Run `bash .highway/tools/tests/run-all.sh` and `git diff --check` from the repository root.
- [X] T029 Review generated adapter parity across `.github/skills/highway-assessment/SKILL.md`, `.claude/skills/highway-assessment/SKILL.md`, `.cursor/skills/highway-assessment/SKILL.md`, and `.agents/skills/highway-assessment/SKILL.md`.

## Dependencies & Execution Order

Phase 1 precedes Phase 2. Phase 2 precedes all user stories. User Stories 1, 2, and 3 are P1 and share the foundational findings contract; User Story 4 depends on the identity and persistence behavior established by User Story 3. Phase 7 follows all story work.

Parallel opportunities: T001-T002, T005-T006 after foundational files exist, T011 and T016 and T021 within their story phases, and T026-T027 after canonical files are stable.

## Implementation Strategy

Deliver the MVP in this order: retained Open finding review and Portfolio default (US1), grounded domain analysis (US2), explicit disposition and concurrency-safe persistence (US3), then reusable context and duplicate prevention (US4). Finish by regenerating all derived artifacts and running the complete validation suite.
