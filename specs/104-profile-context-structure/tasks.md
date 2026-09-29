---

description: "Task list for organizing Profile context"
---

# Tasks: Organize Profile Context

**Input**: Design documents from `specs/104-profile-context-structure/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/profile-record.md, contracts/profile-skill.md, quickstart.md

**Tests**: Required. The specification updates checks that still require the Experience authority sentence, recommendation-selection acceptance inside the Profile skill, or the former sibling optional headings. D3.6 requires each updated test to fail on the current text before the edit that makes it pass. D3.1 requires `.highway/tools/tests/run-all.sh` to exit 0 before the first edit of this feature.

**Organization**: The Profile skill is shared by User Stories 1, 2, and 4. The template is User Story 3. Test edits that touch different files can run together after the suite is green.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3, US4)
- Setup, Foundational, and Polish tasks have no story label

## Phase 1: Setup

**Purpose**: Confirm the current skill and template before changing them.

- [X] T001 Confirm `.highway/skills/highway-profile/SKILL.md` is metadata version 4.0.0, still has `## Evidence`, and still contains `The Experience Standard remains the normative authority for user-visible interaction.` Confirm `.highway/library/templates/output/profile-record.md` is template version 3.0.0 and `schema_version` 3.0.0, and its guidance still lists `## Repository Name`, `## Organization Name`, `## Organization URL`, and `## Organizational Context` as sibling headings. Do not edit those files in this task. Do not edit `.highway/tools/lib/profile.sh`, `.highway/tools/validate-profile.sh`, `.highway/governance/experience-standard.md`, `.highway/governance/constitution.md`, or any `generate-*.sh` script.

---

## Phase 2: Foundational

**Purpose**: Start from a green suite.

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T002 Run `.highway/tools/tests/run-all.sh` from the repository root with unrestricted filesystem access. Expect exit 0 before any edit in this feature. If it fails, update only the failing files under `.highway/tools/tests/` until the suite exits 0, and comment each replaced assertion with the superseded behavior. Do not edit `.highway/skills/highway-profile/SKILL.md` or `.highway/library/templates/output/profile-record.md` in this task.

**Checkpoint**: Suite exits 0. Story work can begin.

---

## Phase 3: User Story 1 - Profile behavior is easier to follow (Priority: P1) 🎯 MVP

**Goal**: The skill replaces Evidence with Profile model, Enrichment, and Operations, and the Experience section is one sentence.

**Independent Test**: `.highway/skills/highway-profile/SKILL.md` contains `## Profile model`, `## Enrichment`, and `## Operations`, does not contain `## Evidence`, and its Experience section is exactly `User-visible interaction follows the Highway Experience Standard.`

### Tests for User Story 1

- [X] T003 [US1] In `.highway/tools/tests/feature-092-contract.test.sh`, require `.highway/skills/highway-profile/SKILL.md` to contain `User-visible interaction follows the Highway Experience Standard.` Require it not to contain `Experience Standard remains the normative authority` and not to contain `a selected recommendation is accepted without a second confirmation`. Require `## Profile model`, `## Enrichment`, and `## Operations`. Comment that the authority sentence and the recommendation-acceptance sentence were superseded. Keep the existing assertions for the opening question, the website path, the four canonical questions, the enrichment category names, `those names are not retained`, `enrichment does not block completion`, `Next Action: /highway-profile setup`, and `Next Action: /highway-profile configure`. Run the test and confirm it fails before the skill is edited.

### Implementation for User Story 1

- [X] T004 [US1] In `.highway/skills/highway-profile/SKILL.md`, replace `## Evidence` with `## Profile model`, `## Enrichment`, and `## Operations` as specified in `specs/104-profile-context-structure/contracts/profile-skill.md`. Set the Experience section to exactly `User-visible interaction follows the Highway Experience Standard.` Remove one-question behavior, `**Why it matters:**` presentation, example behavior, recommendation-selection acceptance, redundant confirmation, and destructive-confirmation presentation. Keep metadata version 4.0.0, the four readiness domains, the opening question, the website path, the canonical questions, the enrichment categories, Error Handling, and `must not be promoted into the retained Profile`. Re-run `.highway/tools/tests/feature-092-contract.test.sh` and confirm it exits 0.

**Checkpoint**: The Experience section is one sentence, and the old Evidence block is gone.

---

## Phase 4: User Story 2 - Acquisition follows one order (Priority: P1)

**Goal**: Acquisition states the eight-step order and keeps the website trust boundary and canonical questions.

**Independent Test**: `.highway/tools/tests/feature-092-contract.test.sh` requires the eight-step order in `.highway/skills/highway-profile/SKILL.md` and exits 0.

### Tests for User Story 2

- [X] T005 [US2] In `.highway/tools/tests/feature-092-contract.test.sh`, require `.highway/skills/highway-profile/SKILL.md` to contain `## Acquisition` and these ordered steps from `specs/104-profile-context-structure/contracts/profile-skill.md`: classify the retained Profile; establish Repository Name when missing; use supported existing-information or website acquisition when available; reuse accepted or accepted-discovered evidence across all four domains; ask the first unresolved canonical domain question; use optional grounded enrichment where useful; persist accepted evidence; report readiness. Run the test and confirm it fails before the skill is edited.

### Implementation for User Story 2

- [X] T006 [US2] In `.highway/skills/highway-profile/SKILL.md`, add `## Acquisition` with that eight-step order. Keep the exact repository-name question and hint, the website trust boundary, and the four canonical questions from `specs/104-profile-context-structure/contracts/profile-skill.md`. Re-run `.highway/tools/tests/feature-092-contract.test.sh` and confirm it exits 0.

**Checkpoint**: Acquisition order is fixed, and a settled domain is not asked again.

---

## Phase 5: User Story 3 - Optional context has one home (Priority: P1)

**Goal**: The shared record owns optional Context. Empty Context is omitted. Schema 3.0.0 stays.

**Independent Test**: `.highway/tools/tests/output-template.test.sh` requires `## Context` and the four child headings in `.highway/library/templates/output/profile-record.md` and exits 0. The default template body does not emit an empty Context section.

### Tests for User Story 3

- [X] T007 [P] [US3] In `.highway/tools/tests/output-template.test.sh`, require `.highway/library/templates/output/profile-record.md` to contain `## Context`, `### Repository Name`, `### Organization Name`, `### Organization URL`, and `### Organizational Context`. Stop requiring the sibling headings `## Repository Name`, `## Organization Name`, `## Organization URL`, and `## Organizational Context`. Comment that those sibling headings were the superseded optional-context contract. Require that Context is not a domain key. Run the test and confirm it fails before the template is edited.

### Implementation for User Story 3

- [X] T008 [US3] In `.highway/library/templates/output/profile-record.md`, add the Context group and the narrative rules from `specs/104-profile-context-structure/contracts/profile-record.md` to the structural guidance. Keep template version 3.0.0, `schema_version` 3.0.0, `# Organizational Profile`, and the four domain keys. Do not emit an empty `## Context` section in the default body. Do not edit `.highway/tools/lib/profile.sh` or `.highway/tools/validate-profile.sh`. Re-run `.highway/tools/tests/output-template.test.sh` and confirm it exits 0.

**Checkpoint**: Context is optional template structure, and readiness still uses four domains.

---

## Phase 6: User Story 4 - Profile documents agree (Priority: P2)

**Goal**: The skill cites the template for Context and does not restate that heading skeleton.

**Independent Test**: `.highway/skills/highway-profile/SKILL.md` says the optional Context structure is owned by `.highway/library/templates/output/profile-record.md` and does not repeat the `###` Context headings.

### Tests for User Story 4

- [X] T009 [US4] In `.highway/tools/tests/feature-092-contract.test.sh`, require `.highway/skills/highway-profile/SKILL.md` to contain `optional Context structure is owned by .highway/library/templates/output/profile-record.md`. Require the skill not to contain `### Repository Name`. Run the test and confirm it fails before the skill is edited.

### Implementation for User Story 4

- [X] T010 [US4] In `.highway/skills/highway-profile/SKILL.md`, state that the optional Context structure is owned by `.highway/library/templates/output/profile-record.md` and do not repeat the Context heading skeleton. Do not add a technology or platform inventory. If a current document titled Highway Profile Intent Summary exists, update it to four domains, schema 3.0.0, no Highway Role, and no persistence verification; if it does not exist, do not create it. Do not edit a Brownfield Onboarding Idea. Re-run `.highway/tools/tests/feature-092-contract.test.sh` and confirm it exits 0.

**Checkpoint**: The skill points at the template for Context. Brownfield onboarding is untouched.

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Regenerate shipped copies and confirm the whole change.

- [X] T011 Run `.highway/tools/generate-agent-adapters.sh` from the repository root. Run it a second time and confirm the second run leaves no further diff. Run `.highway/tools/generate-catalog.sh` and `.highway/tools/generate-library-catalog.sh` and confirm their entries are unchanged aside from a generation timestamp. Do not hand-edit generated skill copies or `.highway/catalog/library-index.md`.
- [X] T012 Run `.highway/tools/tests/run-all.sh` from the repository root with unrestricted filesystem access. Expect exit 0.
- [X] T013 [P] Walk steps 3 through 5 of `specs/104-profile-context-structure/quickstart.md`. Confirm the diff does not include `.highway/governance/experience-standard.md`, `.highway/governance/constitution.md`, `.specify/memory/constitution.md`, `.highway/tools/lib/profile.sh`, `.highway/tools/validate-profile.sh`, or another skill's `SKILL.md`.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies.
- **Foundational (Phase 2)**: Depends on Setup. Blocks all user stories.
- **User Story 1 (Phase 3)**: Depends on Foundational. Establishes the four behavior sections and the Experience sentence.
- **User Story 2 (Phase 4)**: Depends on User Story 1 because it edits the same skill and the same test.
- **User Story 3 (Phase 5)**: Depends on Foundational. It edits the template and can proceed beside User Story 1.
- **User Story 4 (Phase 6)**: Depends on User Stories 1 and 3 so the citation matches the template that now owns Context.
- **Polish (Phase 7)**: Depends on User Story 4.

### User Story Dependencies

- **User Story 1 (P1)**: No dependency on later stories.
- **User Story 2 (P1)**: Follows User Story 1. Adds the acquisition order to the skill User Story 1 reorganized.
- **User Story 3 (P1)**: No dependency on User Stories 1 or 2. Different file.
- **User Story 4 (P2)**: Follows User Stories 1 and 3. Does not restate the template skeleton.

### Within Each User Story

- The test task runs and fails before the matching source edit.
- T006 waits until T004 has kept the opening question, website path, and canonical questions.
- T010 waits until T008 has put the Context skeleton in the template.

### Parallel Opportunities

- T003 and T007 edit different tests and can run together after T002.
- T004 and T008 edit the skill and the template and can run together after their tests have failed.
- T012 and T013 can run together after regeneration.
- User Stories 2 and 4 stay sequential with User Story 1 because they share `.highway/skills/highway-profile/SKILL.md` and `.highway/tools/tests/feature-092-contract.test.sh`.

---

## Parallel Example: User Story 1 and User Story 3

```text
T003 .highway/tools/tests/feature-092-contract.test.sh
T007 .highway/tools/tests/output-template.test.sh

T004 .highway/skills/highway-profile/SKILL.md
T008 .highway/library/templates/output/profile-record.md
```

T005 and T006 follow T004 because they edit the same skill and the same test.

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1 and Phase 2.
2. Complete Phase 3 (T003 and T004).
3. Stop and confirm the Experience section is the single follow sentence and `## Evidence` is gone.

### Incremental Delivery

1. Setup and a green suite.
2. User Story 1: behavior sections and the one-sentence Experience citation.
3. User Story 2: eight-step acquisition order.
4. User Story 3: optional Context in the template, schema 3.0.0 unchanged.
5. User Story 4: the skill cites the template and does not repeat the Context skeleton.
6. Polish: regenerate copies, run the suite, walk the quickstart.

### Parallel Team Strategy

One implementer can update the template after T007 fails. Another can update the skill after T003 fails. User Story 2 waits for the skill. User Story 4 waits for both.

---

## Notes

- Skill metadata stays 4.0.0. Template metadata and `schema_version` stay 3.0.0.
- A replaced assertion needs a comment naming the superseded behavior.
- The skill cites the Highway Experience Standard and does not copy its interaction rules or a constitution rule sentence.
- Do not chmod every test. `.highway/tools/tests/run-all.sh` invokes each test with bash.
- Run the full suite with unrestricted filesystem access. A sandboxed run can fail regeneration probes without a defect in this change.
