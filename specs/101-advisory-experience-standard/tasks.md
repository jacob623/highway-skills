# Tasks: Revise the Runtime Experience Standard

**Input**: Design documents from `specs/101-advisory-experience-standard/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/experience-standard-amendment.md, contracts/constitution-output-relocation.md, quickstart.md

**Tests**: Required. FR-045 and D3.6 require each updated test to fail on the current text before the governance edit that makes it pass. D3.1 requires `.highway/tools/tests/run-all.sh` to exit 0 before those governance edits.

**Organization**: The Experience Standard and the Skills Constitution are shared files, so story phases run in order. Skill citation tasks touch different files and can run together after the standard no longer contains the removed contract.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3, US4)
- Setup, Foundational, and Polish tasks have no story label

## Phase 1: Setup

**Purpose**: Keep new rows readable by the existing parser.

- [X] T001 Confirm `.highway/tools/lib/constitution.sh` reads a rule row as identifier, rule, observable, and tier. New rows in `.highway/governance/experience-standard.md` and `.highway/governance/constitution.md` must keep that shape, including a tier. Do not edit the parser.

---

## Phase 2: Foundational

**Purpose**: Start the governance edits from a green suite.

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T002 Run `.highway/tools/tests/run-all.sh` from the repository root. If it fails on assertions of the pre-amendment contract, update only the failing files under `.highway/tools/tests/` until the suite exits 0. Comment each replaced assertion with the superseded behavior. Do not edit `.highway/governance/experience-standard.md` or `.highway/governance/constitution.md` in this task.

**Checkpoint**: Suite exits 0. Story work can begin.

---

## Phase 3: User Story 1 - Guided interaction starts from evidence (Priority: P1) 🎯 MVP

**Goal**: The Experience Standard requires accepted information, available evidence, and a grounded recommendation before a question, and it forbids a question asked only to fill an internal workflow dimension.

**Independent Test**: `.highway/tools/tests/experience-standard-amendment.test.sh` requires current rows X2.2 and X2.11 through X2.15 and exits 0.

### Tests for User Story 1

- [X] T003 [US1] In `.highway/tools/tests/experience-standard-amendment.test.sh`, require current rows X2.2, X2.11, X2.12, X2.13, X2.14, and X2.15 in `.highway/governance/experience-standard.md` for the obligations in `specs/101-advisory-experience-standard/contracts/experience-standard-amendment.md`. Run the test and confirm it fails before the standard is edited.

### Implementation for User Story 1

- [X] T004 [US1] In `.highway/governance/experience-standard.md`, redefine X2.2 and add X2.11 through X2.15 per `specs/101-advisory-experience-standard/contracts/experience-standard-amendment.md`. Keep one keyword and the tier column. Do not introduce `.specify/` or `specs/`. Re-run `.highway/tools/tests/experience-standard-amendment.test.sh` and confirm it exits 0.

**Checkpoint**: Evidence-first priority is a current rule set.

---

## Phase 4: User Story 2 - Recommendations are selected once and captured (Priority: P1)

**Goal**: A recommendation set is at most 5 distinct choices, selection is acceptance, and the inferred-content review appears only for material interpretation.

**Independent Test**: `.highway/tools/tests/experience-standard-amendment.test.sh` requires X2.7 and X2.16 through X2.22, including the inferred-content heading and the limit of 5, and exits 0.

### Tests for User Story 2

- [X] T005 [US2] In `.highway/tools/tests/experience-standard-amendment.test.sh`, require current rows X2.7 and X2.16 through X2.22 in `.highway/governance/experience-standard.md`, including `Here's what I've captured as your [category]:` and `at most 5`, per `specs/101-advisory-experience-standard/contracts/experience-standard-amendment.md`. Run the test and confirm it fails before those rows exist.

### Implementation for User Story 2

- [X] T006 [US2] In `.highway/governance/experience-standard.md`, redefine X2.7 and add X2.16 through X2.22 per `specs/101-advisory-experience-standard/contracts/experience-standard-amendment.md`. Re-run `.highway/tools/tests/experience-standard-amendment.test.sh` and confirm it exits 0.

**Checkpoint**: Recommendation, acceptance, inferred review, and direct capture are current rules.

---

## Phase 5: User Story 3 - One interaction contract (Priority: P2)

**Goal**: The long Interactive Workflow UX Contract is gone. One short model and the remaining presentation rules govern what the person sees. Skills cite that standard instead of the removed contract.

**Independent Test**: `.highway/tools/tests/highway-ux-alignment.test.sh` and `.highway/tools/tests/feature-092-contract.test.sh` exit 0. No current heading `### Interactive Workflow UX Contract` remains in `.highway/governance/experience-standard.md` or in the cited skill files.

### Tests for User Story 3

- [X] T007 [US3] In `.highway/tools/tests/highway-ux-alignment.test.sh` and `.highway/tools/tests/feature-092-contract.test.sh`, replace assertions that require `### Interactive Workflow UX Contract` with assertions for the eleven-step model and for X1.6, X1.7, X2.1, X2.3 through X2.6, X2.8 through X2.10, X2.23 through X2.31, X5.1, and X5.2 in `.highway/governance/experience-standard.md`. Comment the superseded contract assertions. Run both tests and confirm they fail.

### Implementation for User Story 3

- [X] T008 [US3] In `.highway/governance/experience-standard.md`, remove the Interactive Workflow UX Contract, the N/A token table, and the Sample column. Redefine X1.6, X2.1, X2.3, X2.4, X2.5, X2.6, X2.8, X2.9, X2.10, X5.1, and X5.2. Add X1.7 and X2.23 through X2.31. Keep the observable sentence `Every user-visible response excludes Implementation details unless requested.` Add the eleven-step model and the shortened non-goal from `specs/101-advisory-experience-standard/contracts/experience-standard-amendment.md`. Keep the tier column on every row.

- [X] T009 [P] [US3] In `.highway/skills/highway-adr/SKILL.md`, replace the Interactive Workflow UX Contract citation with a reference to the Experience Standard. Leave the domain workflow in place.
- [X] T010 [P] [US3] In `.highway/skills/highway-clarify/SKILL.md`, replace the Interactive Workflow UX Contract citation with a reference to the Experience Standard. Leave the domain workflow in place.
- [X] T011 [P] [US3] In `.highway/skills/highway-controls/SKILL.md`, replace the Interactive Workflow UX Contract citation and any current citation of a retired X identifier with a reference to the Experience Standard or to P9.2 through P9.8. Leave the domain workflow in place.
- [X] T012 [P] [US3] In `.highway/skills/highway-discovery/SKILL.md`, replace the Interactive Workflow UX Contract citation with a reference to the Experience Standard. Leave the domain workflow in place.
- [X] T013 [P] [US3] In `.highway/skills/highway-help/SKILL.md`, replace current citations of X1.1, X1.2, and X1.3 with P9.2, P9.3, and P9.4. Leave the domain workflow in place.
- [X] T014 [P] [US3] In `.highway/skills/highway-inquiry/SKILL.md`, replace current citations of X1.1, X1.2, X4.1, and X6.1 with P9.2, P9.3, P9.7, and P9.8. Leave the domain workflow in place.
- [X] T015 [P] [US3] In `.highway/skills/highway-new/SKILL.md`, replace the Interactive Workflow UX Contract citation with a reference to the Experience Standard. Leave the domain workflow in place.
- [X] T016 [P] [US3] In `.highway/skills/highway-nfrs/SKILL.md`, replace the Interactive Workflow UX Contract citation with a reference to the Experience Standard. Leave the domain workflow in place.
- [X] T017 [P] [US3] In `.highway/skills/highway-objectives/SKILL.md`, replace the Interactive Workflow UX Contract citation with a reference to the Experience Standard. Leave the domain workflow in place.
- [X] T018 [P] [US3] In `.highway/skills/highway-profile/SKILL.md`, replace the Interactive Workflow UX Contract citation with a reference to the Experience Standard. Leave the domain workflow in place.
- [X] T019 [P] [US3] In `.highway/skills/highway-setup/SKILL.md`, replace the Interactive Workflow UX Contract citation with a reference to the Experience Standard. Leave the domain workflow in place.
- [X] T020 [US3] Re-run `.highway/tools/generate-agent-adapters.sh` so generated copies of the skills edited in T009 through T019 match the sources. Do not hand-edit those generated copies. Re-run `.highway/tools/tests/highway-ux-alignment.test.sh` and `.highway/tools/tests/feature-092-contract.test.sh` and confirm both exit 0.

**Checkpoint**: One interaction model remains, and skill citations no longer name the removed contract.

---

## Phase 6: User Story 4 - The two amendments agree (Priority: P2)

**Goal**: Moved obligations live in the Skills Constitution as P9.2 through P9.8. The Experience Standard is 3.0.0. The Skills Constitution is 4.1.0. The specimen check reports under P9.5.

**Independent Test**: `.highway/tools/tests/constitution-inventory.test.sh`, `.highway/tools/tests/output-template.test.sh`, `.highway/tools/tests/frontmatter-lexicon.test.sh`, and `.highway/tools/tests/rule-checks.test.sh` exit 0. P9.5 is `[auto]`. The other new P9 rows are `[agent-checkable]`.

### Tests for User Story 4

- [X] T021 [P] [US4] In `.highway/tools/tests/constitution-inventory.test.sh`, require footer `**Version**: 4.1.0`, `**Last Amended**: 2026-09-29`, current rows P9.2 through P9.8, P9.5 tagged `[auto]`, the other new P9 rows tagged `[agent-checkable]`, and an unchanged precedence table. Keep the historical `3.0.1 → 4.0.0 (MAJOR)` report. Comment that the 4.0.0 footer assertion described the superseded version. Run the test and confirm it fails.
- [X] T022 [P] [US4] In `.highway/tools/tests/output-template.test.sh`, require P9.6 in `.highway/governance/constitution.md` instead of a current X1.5 row in `.highway/governance/experience-standard.md`. Comment the superseded X1.5 assertion. Run the test and confirm it fails.
- [X] T023 [P] [US4] In `.highway/tools/tests/frontmatter-lexicon.test.sh`, require P9.5 as an existing rule id instead of X1.4 as a current Experience Standard row. Comment the superseded assertion. Run the test and confirm it fails.
- [X] T024 [P] [US4] In `.highway/tools/tests/rule-checks.test.sh`, require the specimen check to report under P9.5. Comment that reporting under X1.4 described the superseded identifier. Run the test and confirm it fails.

### Implementation for User Story 4

- [X] T025 [US4] Record the current specimen-check verdict for the existing fixtures, then retarget the check in `.highway/tools/lib/rule-checks.sh` so the same verdict reports under P9.5. Do not add a second specimen check. Re-run `.highway/tools/tests/rule-checks.test.sh` and confirm it exits 0.
- [X] T026 [US4] In `.highway/governance/constitution.md`, add P9.2 through P9.8 after P9.1 using the rows in `specs/101-advisory-experience-standard/contracts/constitution-output-relocation.md`. Tag P9.5 `[auto]` and the others `[agent-checkable]`. Prepend the 4.1.0 sync impact report. Set the footer to version `4.1.0`, ratified `2026-09-06`, last amended `2026-09-29`. Keep the older reports and the precedence table.
- [X] T027 [US4] In `.highway/governance/experience-standard.md`, remove current rows X1.1, X1.2, X1.3, X1.4, X1.5, X4.1, and X6.1. Prepend the 3.0.0 sync impact report listing every retired, redefined, and added identifier. Set the footer to version `3.0.0`, ratified `2026-09-08`, last amended `2026-09-29`. Keep the older reports. Remove current citations of constitution rules retired by the 4.0.0 amendment and any runtime dependency on the development constitution.
- [X] T028 [US4] Re-run `.highway/tools/tests/constitution-inventory.test.sh`, `.highway/tools/tests/output-template.test.sh`, `.highway/tools/tests/frontmatter-lexicon.test.sh`, and `.highway/tools/tests/rule-checks.test.sh`. Confirm each exits 0.

**Checkpoint**: The two governance documents and the four tests describe the same amendment.

---

## Phase 7: Polish

**Purpose**: Confirm the suite and the quickstart.

- [X] T029 Run `.highway/tools/tests/run-all.sh` from the repository root and confirm it exits 0.
- [X] T030 Walk steps 1 through 6 in `specs/101-advisory-experience-standard/quickstart.md`. Confirm the diff includes the two governance files, the named tests, `.highway/tools/lib/rule-checks.sh`, and citation updates under `.highway/skills/`, and that `.specify/memory/constitution.md` and shared templates are unchanged.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies.
- **Foundational (Phase 2)**: Depends on Setup. Blocks every story.
- **User Story 1 (Phase 3)**: Depends on Foundational.
- **User Story 2 (Phase 4)**: Depends on User Story 1. Both edit `.highway/tools/tests/experience-standard-amendment.test.sh` and `.highway/governance/experience-standard.md`.
- **User Story 3 (Phase 5)**: Depends on User Story 2. The standard edit precedes the skill citations. The generator run follows every citation task.
- **User Story 4 (Phase 6)**: Depends on User Story 3. The specimen check is retargeted before P9.5 is tagged `[auto]`.
- **Polish (Phase 7)**: Depends on User Story 4.

### User Story Dependencies

- **User Story 1 (P1)**: First slice of the Experience Standard. No dependency on later stories.
- **User Story 2 (P1)**: Follows User Story 1 because both edit the same test and the same standard.
- **User Story 3 (P2)**: Follows User Story 2 so the removed contract is replaced after the recommendation rules exist.
- **User Story 4 (P2)**: Follows User Story 3 so the version footers and the moved rows are written once the interaction rules are in place.

### Within Each User Story

- The test task runs and fails before the matching document edit.
- Skill citation tasks T009 through T019 can run together after T008.
- T021 through T024 can run together. T025 through T028 stay in order.

### Parallel Opportunities

- T009 through T019 edit different skill files.
- T021 through T024 edit different test files.
- Story phases themselves stay sequential because the Experience Standard is shared.

---

## Parallel Example: User Story 3

```text
T009 highway-adr
T010 highway-clarify
T011 highway-controls
T012 highway-discovery
T013 highway-help
T014 highway-inquiry
T015 highway-new
T016 highway-nfrs
T017 highway-objectives
T018 highway-profile
T019 highway-setup
```

After those finish, T020 regenerates the adapter copies.

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1 and Phase 2.
2. Complete Phase 3 (T003, T004).
3. Stop and confirm `.highway/tools/tests/experience-standard-amendment.test.sh` exits 0 with the evidence-first rows present.

### Incremental Delivery

1. Setup and a green suite.
2. User Story 1: evidence-first priority.
3. User Story 2: recommendations, acceptance, and inferred review.
4. User Story 3: one interaction model and citation updates.
5. User Story 4: P9.2 through P9.8, versions 3.0.0 and 4.1.0, specimen check reports P9.5.
6. Polish: full suite and quickstart.

### Parallel Team Strategy

One implementer for the shared standard and constitution. After T008, the eleven skill citation tasks can be split across people. The four User Story 4 test edits can also be split. T020 and T025 through T028 stay with one implementer.

---

## Notes

- The 2026-09-29 clarification keeps skill domain workflows, shared templates, and the development constitution unchanged. This task list adds tests, the specimen-check retarget, and citation updates so D3.1, D3.2, D3.3, and D6.1 pass.
- A replaced assertion needs a comment naming the superseded behavior.
- Retired identifiers may remain in older sync reports. Assertions must target current rows and current headings.
- Each new constitution row: one keyword, one obligation, 25 words or fewer, plus an observable and a tier.
