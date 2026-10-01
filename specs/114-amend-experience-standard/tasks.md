---

description: "Task list for the Experience Standard 5.0.0 amendment"
---

# Tasks: Amend Experience Standard

**Input**: Design documents from `specs/114-amend-experience-standard/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/experience-standard-amendment.md, contracts/repository-review-checks.md, quickstart.md

**Tests**: Required. The specification requires repository checks to require the 5.0.0 contract. D3.6 requires each updated test to fail on the current text before the governance edit that makes it pass. D3.1 requires `.highway/tools/tests/run-all.sh` to exit 0 before the first edit of this feature.

**Organization**: All story implementation edits `.highway/governance/experience-standard.md`, so those tasks run in order. Test edits in different files may run in parallel inside a story. Skills, output templates, and other governance baselines are not edited.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3, US4)
- Setup, Foundational, and Polish tasks have no story label

## Path Conventions

- Shipped source: `.highway/governance/experience-standard.md`
- Review checks: `.highway/tools/tests/`
- Contracts: `specs/114-amend-experience-standard/contracts/`

## Phase 1: Setup

**Purpose**: Keep new rows readable by the existing rule parser.

- [X] T001 Confirm `.highway/tools/lib/constitution.sh` reads an Experience Standard rule row as identifier, rule, observable, and tier. Rows added or redefined in `.highway/governance/experience-standard.md` must keep that shape, including `[agent-checkable]`. Do not edit the parser. Do not edit `.highway/tools/lib/rule-checks.sh`. Do not register X2.32, X2.33, X2.34, or X2.35 as `[auto]`.

---

## Phase 2: Foundational

**Purpose**: Start from a green suite.

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T002 Run `.highway/tools/tests/run-all.sh` from the repository root with unrestricted filesystem access. Expect exit 0 before any edit in this feature. If it fails, stop. Do not edit `.highway/governance/experience-standard.md` and do not weaken an assertion to start this feature.

**Checkpoint**: Suite exits 0. Story work can begin.

---

## Phase 3: User Story 1 - Question Before Explanation (Priority: P1) 🎯 MVP

**Goal**: When Decision Context applies, one unresolved question appears before `**Why it matters:**` and one concise explanation. Setup keeps one response-demanding question or decision in the final interaction block, and Decision Context may follow it. Captured-content review stays proposal-first.

**Independent Test**: `.highway/tools/tests/highway-ux-alignment.test.sh`, `.highway/tools/tests/experience-standard-amendment.test.sh`, and `.highway/tools/tests/feature-092-contract.test.sh` require the X1.7 and X2.9 rows from `specs/114-amend-experience-standard/contracts/experience-standard-amendment.md` and exit 0. The former X1.7 and X2.9 rule sentences are absent. The X2.21 row is unchanged.

### Tests for User Story 1

- [X] T003 [P] [US1] In `.highway/tools/tests/highway-ux-alignment.test.sh`, replace the required X1.7 and X2.9 rule sentences with the rows in `specs/114-amend-experience-standard/contracts/experience-standard-amendment.md`. Comment that the replaced sentences required rationale before the question. Require those former sentences to be absent. Leave the `3.0.0 → 4.0.0 (MAJOR)` assertion, the X2.25 assertion, and the `Why it matters:` assertion on `.highway/skills/highway-objectives/SKILL.md` unchanged. Run the test with unrestricted filesystem access and confirm it fails before `.highway/governance/experience-standard.md` is edited.
- [X] T004 [P] [US1] In `.highway/tools/tests/feature-092-contract.test.sh`, replace only the Experience Standard assertion `| X1.7 | Setup presentation MUST place one decision or question last` with `| X1.7 | Setup presentation MUST keep one response-demanding question or decision`. Comment that the replaced prefix required the question after supporting rationale. Do not change the Profile skill `version: 4.0.0` assertion or any schema fixture version. Run the test with unrestricted filesystem access and confirm it fails before `.highway/governance/experience-standard.md` is edited.
- [X] T005 [P] [US1] In `.highway/tools/tests/experience-standard-amendment.test.sh`, replace the required X2.9 rule sentence with `Decision Context MUST follow the question it explains under the label "**Why it matters:**".` Comment that the replaced sentence placed the explanation before the question. Require the former X2.9 rule sentence to be absent. Leave `3.0.0 → 4.0.0 (MAJOR)`, the X2.13 rule sentence, and the X2.21 row assertion unchanged. Run the test with unrestricted filesystem access and confirm it fails before `.highway/governance/experience-standard.md` is edited.

### Implementation for User Story 1

- [X] T006 [US1] In `.highway/governance/experience-standard.md`, replace the X1.7 and X2.9 rows with the rows in `specs/114-amend-experience-standard/contracts/experience-standard-amendment.md`. Keep both tiers `[agent-checkable]`. Add the Decision Context non-compliant and compliant example row from that contract to the Interaction Examples table. Do not change the Sync Impact Report, the version footer, the X2.13 or X2.25 rule sentences, or the X2.21 row. Do not add X2.32 through X2.35. Do not introduce `.specify/` or `specs/`. Re-run the three tests from T003, T004, and T005 with unrestricted filesystem access and confirm each exits 0.

**Checkpoint**: Question-before-explanation is the Experience Standard contract for X1.7 and X2.9. The version record is still 4.0.0 until User Story 4.

---

## Phase 4: User Story 2 - Recommendations That Compound (Priority: P1)

**Goal**: Accepted context is re-evaluated before every unresolved guided-collection question. Recommendation wording matches the number shown. Accepted discovery becomes grounding without a website-specific rule.

**Independent Test**: `.highway/tools/tests/highway-ux-alignment.test.sh` and `.highway/tools/tests/experience-standard-amendment.test.sh` require the X2.13 observable, the X2.25 observable, the X2.32 rule, and the compounding sentence from `specs/114-amend-experience-standard/contracts/experience-standard-amendment.md`, and exit 0. The X2.13 and X2.25 rule sentences are unchanged.

### Tests for User Story 2

- [X] T007 [US2] In `.highway/tools/tests/highway-ux-alignment.test.sh`, require the X2.13 observable, the X2.25 observable, the X2.32 rule sentence, and `Accepted information compounds during a guided interaction.` from `specs/114-amend-experience-standard/contracts/experience-standard-amendment.md`. Require `Select any of these` and `Choose a suitable repository structure.` to be absent. Comment that those strings taught a generic or count-insensitive recommendation. Do not require the 5.0.0 version token yet. Run the test with unrestricted filesystem access and confirm it fails before those Experience Standard sections are edited.
- [X] T008 [P] [US2] In `.highway/tools/tests/experience-standard-amendment.test.sh`, require the X2.13 observable beginning `Before each unresolved guided-collection question` and the X2.32 rule sentence from `specs/114-amend-experience-standard/contracts/experience-standard-amendment.md`. Keep requiring the unchanged X2.13 rule sentence. Run the test with unrestricted filesystem access and confirm it fails before those rows are edited.

### Implementation for User Story 2

- [X] T009 [US2] In `.highway/governance/experience-standard.md`, replace the X2.13 and X2.25 observables and add the X2.32 row per `specs/114-amend-experience-standard/contracts/experience-standard-amendment.md`. Keep the X2.13 and X2.25 rule sentences. Replace the numbered interaction model with the ten-step sequence in that contract. Add the two compounding sentences under Contextual Guidance without rule identifiers. Replace the Context Awareness repository-structure row with the vision contrast. Revise the recommendation sketch so `Select any of these` is absent and the invitation permits one, several, all, or something different. Do not add a website-specific rule. Do not add X2.33, X2.34, or X2.35. Do not change the Sync Impact Report. Re-run `.highway/tools/tests/highway-ux-alignment.test.sh` and `.highway/tools/tests/experience-standard-amendment.test.sh` with unrestricted filesystem access and confirm each exits 0.

**Checkpoint**: Recommendation evaluation and choice wording follow the amended contract. Domain closure rules are not present yet.

---

## Phase 5: User Story 3 - Human Closure Without Machine Chatter (Priority: P1)

**Goal**: A completed guided Setup domain closes with at most one user-relevant synthesis. Machine-consumable owner results stay out of normal conversation. After the final guided decision, only user-relevant closure, synthesis, or the next-domain transition is visible.

**Independent Test**: `.highway/tools/tests/highway-ux-alignment.test.sh` and `.highway/tools/tests/experience-standard-amendment.test.sh` require the X2.33, X2.34, and X2.35 rows and the named machine-only fields from `specs/114-amend-experience-standard/contracts/experience-standard-amendment.md`, and exit 0. X2.27 and X2.28 are unchanged.

### Tests for User Story 3

- [X] T010 [US3] In `.highway/tools/tests/highway-ux-alignment.test.sh`, require the X2.33, X2.34, and X2.35 rule sentences and the field names Status, Summary, Next Action, Blocking Reason, Action Status, and Collection Result from `specs/114-amend-experience-standard/contracts/experience-standard-amendment.md`. Require the compliant sentence `I've captured that objective. We can build on it in the next part of Setup.` Do not require `Status: Complete` to be absent, because the non-compliant example retains it. Run the test with unrestricted filesystem access and confirm it fails before those rows are added.
- [X] T011 [P] [US3] In `.highway/tools/tests/experience-standard-amendment.test.sh`, require the X2.33, X2.34, and X2.35 rule sentences from `specs/114-amend-experience-standard/contracts/experience-standard-amendment.md`. Keep requiring the X2.27 and X2.28 rows already covered by the preserved-row list. Run the test with unrestricted filesystem access and confirm it fails before those rows are added.

### Implementation for User Story 3

- [X] T012 [US3] In `.highway/governance/experience-standard.md`, add the X2.33, X2.34, and X2.35 rows after X2.31 per `specs/114-amend-experience-standard/contracts/experience-standard-amendment.md`. Add the explanatory prose naming Status, Summary, Next Action, Blocking Reason, Action Status, Collection Result, and orchestrator-only mutation results, including that those results may still be returned to the orchestrator and that a direct request may still show the requested result. Add the owner-result example row from that contract. Do not change the X2.3, X2.27, or X2.28 rows. Do not change the Sync Impact Report. Do not reference a file under `.highway/tools/tests/` from this document. Re-run `.highway/tools/tests/highway-ux-alignment.test.sh` and `.highway/tools/tests/experience-standard-amendment.test.sh` with unrestricted filesystem access and confirm each exits 0.

**Checkpoint**: Closure and hidden owner results are stated. The version record is still 4.0.0.

---

## Phase 6: User Story 4 - A Traceable Major Amendment (Priority: P2)

**Goal**: The Experience Standard is 5.0.0, classified major, with one current Sync Impact Report. Preserved rules are unchanged. Skills and other governance baselines are unchanged. Review checks are not runtime dependencies.

**Independent Test**: `.highway/tools/tests/experience-standard-amendment.test.sh` requires exactly one `Sync Impact Report`, `4.0.0 → 5.0.0 (MAJOR)`, and the 5.0.0 footer, and exits 0. `3.0.0 → 4.0.0 (MAJOR)` is absent from `.highway/governance/experience-standard.md`. No skill file differs.

### Tests for User Story 4

- [X] T013 [US4] In `.highway/tools/tests/experience-standard-amendment.test.sh` and `.highway/tools/tests/highway-ux-alignment.test.sh`, stop requiring `3.0.0 → 4.0.0 (MAJOR)`. Comment that this superseded token was the prior Experience Standard report. Require `4.0.0 → 5.0.0 (MAJOR)` and, in `.highway/tools/tests/experience-standard-amendment.test.sh`, require `**Version**: 5.0.0 | **Ratified**: 2026-09-08 | **Last Amended**: 2026-10-01` and exactly one `Sync Impact Report`. Do not change Skills Constitution history tokens in `.highway/tools/tests/constitution-inventory.test.sh`. Run both Experience Standard tests with unrestricted filesystem access and confirm they fail before the report is replaced.

### Implementation for User Story 4

- [X] T014 [US4] In `.highway/governance/experience-standard.md`, replace the opening Sync Impact Report and the version footer with the 5.0.0 text in `specs/114-amend-experience-standard/contracts/experience-standard-amendment.md`. Record the rule count as 35 to 39. Do not keep the 4.0.0 report. Do not name a test file, a feature number, `.specify/`, or `specs/`. Do not change the preserved sentences listed in that contract. Re-run `.highway/tools/tests/experience-standard-amendment.test.sh` and `.highway/tools/tests/highway-ux-alignment.test.sh` with unrestricted filesystem access and confirm each exits 0.
- [X] T015 [US4] Confirm this feature did not modify any file under `.highway/skills/`, `.highway/library/templates/`, or `.highway/governance/` other than `.highway/governance/experience-standard.md`. Confirm `.highway/governance/experience-standard.md` and no shipped skill reference `.highway/tools/tests/highway-ux-alignment.test.sh`, `.highway/tools/tests/experience-standard-amendment.test.sh`, or `.highway/tools/tests/feature-092-contract.test.sh`. Confirm `.highway/tools/validate-skill.sh` was not given a new runtime dependency on those tests.

**Checkpoint**: The amended standard is versioned, and the review checks are development-only.

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Prove the 5.0.0 contract is the passing baseline.

- [X] T016 Run `.highway/tools/tests/highway-ux-alignment.test.sh`, `.highway/tools/tests/experience-standard-amendment.test.sh`, `.highway/tools/tests/feature-092-contract.test.sh`, and `.highway/tools/tests/run-all.sh` from the repository root with unrestricted filesystem access, as specified in `specs/114-amend-experience-standard/quickstart.md`. Expect each to exit 0.
- [X] T017 [P] Confirm `.highway/governance/experience-standard.md` contains no `.specify/` or `specs/` string, still contains `Every user-visible response excludes Implementation details unless requested.`, and still contains the unchanged X2.21 row from `specs/114-amend-experience-standard/contracts/experience-standard-amendment.md`.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies.
- **Foundational (Phase 2)**: Depends on Setup. Blocks every user story.
- **User Stories (Phases 3–6)**: Depend on Foundational. Implementation tasks share `.highway/governance/experience-standard.md`, so they run US1, then US2, then US3, then US4.
- **Polish (Phase 7)**: Depends on User Story 4.

### User Story Dependencies

- **User Story 1 (P1)**: Starts after Foundational. No dependency on US2, US3, or US4 for its row assertions.
- **User Story 2 (P1)**: Starts after US1 implementation because it edits the same governance file. Its new assertions do not require the 5.0.0 report.
- **User Story 3 (P1)**: Starts after US2 implementation because it edits the same governance file. It does not rewrite X2.27 or X2.28.
- **User Story 4 (P2)**: Starts after US3 implementation. The version record is false until this story replaces the 4.0.0 report.

### Within Each User Story

- Tests are written and observed failing before the governance edit.
- A test file edited by an earlier story is not edited in parallel with that story's implementation.
- Tests in different files inside one story may run in parallel.

### Parallel Opportunities

- T003, T004, and T005 touch different test files and may run together.
- T008 may run with T007 only after T005 has finished, because both T005 and T008 edit `.highway/tools/tests/experience-standard-amendment.test.sh`.
- T011 may run with T010 only after T008 has finished, for the same reason.
- T017 may run with T016 after T015.

---

## Parallel Example: User Story 1

```text
T003 Update X1.7 and X2.9 assertions in .highway/tools/tests/highway-ux-alignment.test.sh
T004 Update the X1.7 prefix in .highway/tools/tests/feature-092-contract.test.sh
T005 Update the X2.9 assertion in .highway/tools/tests/experience-standard-amendment.test.sh
```

Do not start T006 until all three tests have been observed failing.

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1 and Phase 2.
2. Complete Phase 3.
3. Stop and validate the three User Story 1 tests.
4. Do not treat that checkpoint as a releasable 5.0.0 amendment. The document still records 4.0.0 until User Story 4.

### Incremental Delivery

1. User Story 1 makes question-before-explanation the checked contract.
2. User Story 2 makes recommendation compounding and choice wording checkable.
3. User Story 3 makes domain synthesis and hidden owner results checkable.
4. User Story 4 records the major version and removes the superseded report.
5. Polish runs the full repository review. The passing baseline is the 5.0.0 contract.

### Parallel Team Strategy

One implementer should own `.highway/governance/experience-standard.md`. A second implementer may prepare a story's test edits only after the previous story's test edits to that same file are complete.

---

## Notes

- Do not edit files under `.highway/skills/` or `.highway/library/templates/`.
- Do not retarget a skill `version: 4.0.0` assertion.
- Do not preserve the old X1.7, X2.9, or X2.13 contract as an alternate passing token.
- Replaced assertions name the superseded behavior in a comment.
