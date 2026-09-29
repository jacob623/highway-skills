---

description: "Task list for the simplified Profile skill"
---

# Tasks: Simplify the Profile Skill

**Input**: Design documents from `specs/103-simplify-profile-skill/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/profile-record.md, contracts/profile-skill.md, quickstart.md

**Tests**: Required. The specification updates checks that still require five domains, Highway Role, schema 2.0.0 as valid, a validator instruction, or persist-and-verify. D3.6 requires each updated test to fail on the current text before the edit that makes it pass. D3.1 requires `.highway/tools/tests/run-all.sh` to exit 0 before the first edit of this feature.

**Organization**: The Profile skill, the shared template, and several tests are shared files, so later stories follow User Story 1. Test edits that touch different files can run together.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1, US2, US3, US4, US5, US6)
- Setup, Foundational, and Polish tasks have no story label

## Phase 1: Setup

**Purpose**: Confirm the current structural check before changing it.

- [X] T001 Confirm `.highway/tools/lib/profile.sh` returns five domain keys including `highway_role`, and `.highway/tools/validate-profile.sh` requires `schema_version` 2.0.0. Do not edit those files in this task. Do not edit `.highway/governance/experience-standard.md`, `.highway/governance/constitution.md`, or any `generate-*.sh` script.

---

## Phase 2: Foundational

**Purpose**: Start from a green suite.

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T002 Run `.highway/tools/tests/run-all.sh` from the repository root with unrestricted filesystem access. Expect exit 0 before any edit in this feature. If it fails, update only the failing files under `.highway/tools/tests/` until the suite exits 0, and comment each replaced assertion with the superseded behavior. Do not edit `.highway/skills/highway-profile/SKILL.md` or `.highway/library/templates/output/profile-record.md` in this task.

**Checkpoint**: Suite exits 0. Story work can begin.

---

## Phase 3: User Story 1 - Profile is four organizational domains (Priority: P1) 🎯 MVP

**Goal**: Readiness uses Identity, Vision, Competitive Path, and Guiding Principles. Highway Role is gone. Schema 3.0.0 is the only supported schema. Schema 2.0.0 is Blocked and is not rewritten.

**Independent Test**: `.highway/tools/tests/profile-structure.test.sh` and `.highway/tools/tests/output-template.test.sh` accept a schema 3.0.0 four-domain record and reject schema 2.0.0. `.highway/skills/highway-profile/SKILL.md` no longer treats Highway Role as a Profile domain.

### Tests for User Story 1

- [X] T003 [P] [US1] In `.highway/tools/tests/output-template.test.sh`, `.highway/tools/tests/profile-structure.test.sh`, and `.highway/tools/tests/fixtures/profile-092/`, require schema 3.0.0, the four domain keys, and the four narrative headings from `specs/103-simplify-profile-skill/contracts/profile-record.md`. Remove `highway_role` and `## How Highway Helps` from the valid fixtures. Comment that schema 2.0.0 and five domains were the superseded contract. Point the unsupported-schema fixture at a version other than 3.0.0. Run the two tests and confirm they fail before the template is edited.
- [X] T004 [P] [US1] In `.highway/tools/tests/feature-092-contract.test.sh`, `.highway/tools/tests/profile-migration.test.sh`, `.highway/tools/tests/profile-markdown-contract.test.sh`, `.highway/tools/tests/profile-lifecycle.test.sh`, and `.highway/tools/tests/profile-behavior.test.sh`, stop treating schema 2.0.0 as valid and stop producing an unsupported record by writing schema 3.0.0. Require schema 3.0.0 as valid and schema 2.0.0 as rejected without rewriting the file. Comment the superseded 2.0.0 behavior. Keep the assertions for `Experience Standard remains the normative authority`, `Next Action: /highway-profile setup`, and `Next Action: /highway-profile configure`. Run `.highway/tools/tests/feature-092-contract.test.sh` and confirm it fails before the template is edited.

### Implementation for User Story 1

- [X] T005 [P] [US1] In `.highway/library/templates/output/profile-record.md`, set metadata version and `schema_version` to 3.0.0, remove `highway_role` and `## How Highway Helps`, and keep the four domain keys and headings from `specs/103-simplify-profile-skill/contracts/profile-record.md`. Do not add optional-context headings in this task.
- [X] T006 [P] [US1] In `.highway/tools/lib/profile.sh`, return only `identity`, `vision`, `competitive_path`, and `guiding_principles` from `profile_domain_keys`, and remove the Highway Role heading from `profile_domain_heading`.
- [X] T007 [P] [US1] In `.highway/tools/validate-profile.sh`, require `schema_version` 3.0.0 and exactly four domain outcomes. Do not add a migration or rewrite of a 2.0.0 file.
- [X] T008 [US1] In `.highway/skills/highway-profile/SKILL.md`, state the four readiness domains, the Complete / Missing / Blocked results from `specs/103-simplify-profile-skill/data-model.md`, and that schema 2.0.0 is Blocked and left unchanged. Remove every statement that Highway Role or five domains are part of Profile. Re-run `.highway/tools/tests/profile-structure.test.sh`, `.highway/tools/tests/output-template.test.sh`, and `.highway/tools/tests/feature-092-contract.test.sh` and confirm they exit 0.

**Checkpoint**: A new Profile is schema 3.0.0 with four domains. A schema 2.0.0 file is rejected and unchanged.

---

## Phase 4: User Story 2 - The repository name starts the conversation (Priority: P1)

**Goal**: First-time setup asks for the repository name, keeps that answer as accepted optional context, and omits optional values that were not accepted.

**Independent Test**: The skill contains the exact opening question and hint. The template renders `## Repository Name`, `## Organization Name`, `## Organization URL`, and `## Organizational Context` only as optional body headings outside the domain map.

### Tests for User Story 2

- [X] T009 [US2] In `.highway/tools/tests/output-template.test.sh`, require the four optional headings from `specs/103-simplify-profile-skill/contracts/profile-record.md` and require that they are not domain keys. In `.highway/tools/tests/feature-092-contract.test.sh`, require `.highway/skills/highway-profile/SKILL.md` to contain `**What would you like to call your Highway repository?**` and `If you're using Highway for a company or organization, its name is usually a good choice.` Run both tests and confirm they fail before those headings and questions are added.

### Implementation for User Story 2

- [X] T010 [US2] In `.highway/library/templates/output/profile-record.md`, document the four optional headings as body Markdown rendered only when accepted, with no placeholder when absent. In `.highway/skills/highway-profile/SKILL.md`, begin first-time setup with that question and hint, treat the answer as accepted Repository Name context, and reuse it in the next prompt. Re-run `.highway/tools/tests/output-template.test.sh` and `.highway/tools/tests/feature-092-contract.test.sh` and confirm they exit 0.

**Checkpoint**: The opening question is fixed, and optional context is Markdown that does not affect readiness.

---

## Phase 5: User Story 3 - A public website can fill the Profile (Priority: P1)

**Goal**: When website retrieval is available, Profile asks for the public site before ordinary domain questions. Derived facts stay proposed until accepted. When retrieval is unavailable, the conversation continues without mentioning the missing capability.

**Independent Test**: `.highway/tools/tests/feature-092-contract.test.sh` requires the website-path sentences in `.highway/skills/highway-profile/SKILL.md` and exits 0.

### Tests for User Story 3

- [X] T011 [US3] In `.highway/tools/tests/feature-092-contract.test.sh`, require `.highway/skills/highway-profile/SKILL.md` to ask for the organization's public website using the accepted Repository Name, to treat the supplied Organization URL as accepted, to keep website-derived Organization Name and other derived facts proposed until accepted, and to continue without exposing a missing retrieval capability. Run the test and confirm it fails before the skill is edited.

### Implementation for User Story 3

- [X] T012 [US3] In `.highway/skills/highway-profile/SKILL.md`, add the website-assisted path from `specs/103-simplify-profile-skill/contracts/profile-skill.md`. Do not name a shell command for retrieval. Re-run `.highway/tools/tests/feature-092-contract.test.sh` and confirm it exits 0.

**Checkpoint**: Website-derived information stays proposed until the person accepts it.

---

## Phase 6: User Story 4 - Unresolved domains use one canonical question (Priority: P1)

**Goal**: Each unresolved domain asks its canonical question. A reply is read across all four domains. A domain that already has evidence is not asked again.

**Independent Test**: `.highway/tools/tests/feature-092-contract.test.sh` requires the four canonical questions in `.highway/skills/highway-profile/SKILL.md` and exits 0.

### Tests for User Story 4

- [X] T013 [US4] In `.highway/tools/tests/feature-092-contract.test.sh`, require these questions in `.highway/skills/highway-profile/SKILL.md`: `**What does [Organization Name] do?**`, `**What is the future vision of [Organization Name]?**`, `**How does [Organization Name] plan to get there?**`, and `**What principles or values guide decisions at [Organization Name]?**`. Also require that the accepted Repository Name is used when Organization Name is not accepted, and that a domain with accepted or active evidence is not asked. Run the test and confirm it fails before the skill is edited.

### Implementation for User Story 4

- [X] T014 [US4] In `.highway/skills/highway-profile/SKILL.md`, replace adaptive question generation with the canonical questions and the cross-domain response rule from `specs/103-simplify-profile-skill/contracts/profile-skill.md`. Leave one-question behavior, `**Why it matters:**`, and examples to the Highway Experience Standard by citation. Re-run `.highway/tools/tests/feature-092-contract.test.sh` and confirm it exits 0.

**Checkpoint**: Unresolved domains use the four canonical questions, and settled domains are not asked again.

---

## Phase 7: User Story 5 - Enrichment stays optional (Priority: P1)

**Goal**: A readiness-complete domain may still receive grounded enrichment. The internal categories are not stored. Selecting a recommendation accepts it without a second confirmation.

**Independent Test**: `.highway/tools/tests/feature-092-contract.test.sh` requires the enrichment categories in `.highway/skills/highway-profile/SKILL.md`, requires that those names are not Profile fields, and exits 0.

### Tests for User Story 5

- [X] T015 [US5] In `.highway/tools/tests/feature-092-contract.test.sh`, require `.highway/skills/highway-profile/SKILL.md` to name the Vision, Competitive Path, and Guiding Principles grounding categories from `specs/103-simplify-profile-skill/contracts/profile-skill.md`, to say those names are not retained, to say enrichment does not block completion, and to treat a selected recommendation as accepted without a second confirmation. Run the test and confirm it fails before the skill is edited.

### Implementation for User Story 5

- [X] T016 [US5] In `.highway/skills/highway-profile/SKILL.md`, add the enrichment behavior from `specs/103-simplify-profile-skill/contracts/profile-skill.md`. Do not add the category names to `.highway/library/templates/output/profile-record.md`. Do not store a small-business, enterprise, maturity, persona, or advisory classification. Re-run `.highway/tools/tests/feature-092-contract.test.sh` and confirm it exits 0.

**Checkpoint**: Enrichment is optional, and its category names stay out of the retained record.

---

## Phase 8: User Story 6 - The skill keeps only Profile behavior (Priority: P2)

**Goal**: The skill cites the Experience Standard, states order only where Profile needs it, names persistence Persist, and no longer instructs a validator run or a byte check. The skill version is 4.0.0.

**Independent Test**: `.highway/skills/highway-profile/SKILL.md` metadata version is 4.0.0. The Experience section is the two-sentence citation. The file does not contain `.highway/tools/validate-profile.sh`, `Persist and verify`, or the eight-step failure table. The behavior added in earlier stories remains.

### Tests for User Story 6

- [X] T017 [US6] In `.highway/tools/tests/highway-ux-alignment.test.sh`, stop requiring `Current Question`, `Domain Progress`, and `Current Activity` in `.highway/skills/highway-profile/SKILL.md`. Comment that those labels were restated in the skill and are now left to the Highway Experience Standard. Keep the requirement that `Highway Experience Standard` appears on one line. In `.highway/tools/tests/feature-092-contract.test.sh`, require skill metadata version 4.0.0 and require the skill not to contain `.highway/tools/validate-profile.sh`. Run both tests and confirm they fail before the skill simplification.

### Implementation for User Story 6

- [X] T018 [US6] In `.highway/skills/highway-profile/SKILL.md`, set `metadata.version` to 4.0.0. Reduce the Experience section to: `Profile responses follow the Highway Experience Standard. The Experience Standard remains the normative authority for user-visible interaction.` Remove the numbered eight-step workflow and the per-step Error Handling table. Keep ordering only for classifying the retained record, acquiring context, accepting evidence, persisting, and reporting readiness. Name the write Persist. Record only the three Profile failure exceptions from `specs/103-simplify-profile-skill/contracts/profile-skill.md`. Replace Verification with the checks in that contract. Preserve the opening question, website path, canonical questions, enrichment categories, and four-domain readiness from earlier stories. Re-run `.highway/tools/tests/highway-ux-alignment.test.sh` and `.highway/tools/tests/feature-092-contract.test.sh` and confirm both exit 0.

**Checkpoint**: The skill states Profile behavior, cites the shared interaction rules, and is version 4.0.0.

---

## Phase 9: Polish & Cross-Cutting Concerns

**Purpose**: Regenerate shipped copies and confirm the whole change.

- [X] T019 Run `.highway/tools/generate-agent-adapters.sh` and `.highway/tools/generate-library-catalog.sh` from the repository root. Run each a second time and confirm the second run leaves no further diff. Do not hand-edit generated skill copies or `.highway/catalog/library-index.md`.
- [X] T020 Run `.highway/tools/tests/run-all.sh` from the repository root with unrestricted filesystem access. Expect exit 0.
- [X] T021 [P] Walk steps 3 through 5 of `specs/103-simplify-profile-skill/quickstart.md`. Confirm the diff does not include `.highway/governance/experience-standard.md`, `.highway/governance/constitution.md`, `.specify/memory/constitution.md`, or another skill's `SKILL.md`.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies.
- **Foundational (Phase 2)**: Depends on Setup. Blocks all user stories.
- **User Story 1 (Phase 3)**: Depends on Foundational. Establishes the record and the structural check.
- **User Story 2 (Phase 4)**: Depends on User Story 1 because it edits the same template and skill.
- **User Story 3 (Phase 5)**: Depends on User Story 2 because it edits the skill and `feature-092-contract.test.sh`.
- **User Story 4 (Phase 6)**: Depends on User Story 3 for the same files.
- **User Story 5 (Phase 7)**: Depends on User Story 4 for the same files.
- **User Story 6 (Phase 8)**: Depends on User Stories 2 through 5 so the simplification keeps the behavior those stories added.
- **Polish (Phase 9)**: Depends on User Story 6.

### User Story Dependencies

- **User Story 1 (P1)**: No dependency on later stories.
- **User Story 2 (P1)**: Follows User Story 1.
- **User Story 3 (P1)**: Follows User Story 2. Does not change the domain map.
- **User Story 4 (P1)**: Follows User Story 3.
- **User Story 5 (P1)**: Follows User Story 4. Does not add fields to the template.
- **User Story 6 (P2)**: Follows User Story 5. Removes restated workflow text without removing the earlier behavior.

### Within Each User Story

- The test task runs and fails before the matching source edit.
- T005, T006, and T007 wait until T003 and T004 have failed, then they can run together.
- T008 waits until the template and both helpers are updated.
- T018 waits until T017 has failed, and it must keep the text added by T010, T012, T014, and T016.

### Parallel Opportunities

- T003 and T004 edit different tests.
- T005, T006, and T007 edit the template, `profile.sh`, and `validate-profile.sh`.
- T020 and T021 can run together after regeneration.
- Stories 2 through 6 stay sequential because they share `.highway/skills/highway-profile/SKILL.md` and `.highway/tools/tests/feature-092-contract.test.sh`.

---

## Parallel Example: User Story 1

```text
T003 .highway/tools/tests/output-template.test.sh
T003 .highway/tools/tests/profile-structure.test.sh
T003 .highway/tools/tests/fixtures/profile-092/
T004 .highway/tools/tests/feature-092-contract.test.sh
T004 .highway/tools/tests/profile-migration.test.sh

T005 .highway/library/templates/output/profile-record.md
T006 .highway/tools/lib/profile.sh
T007 .highway/tools/validate-profile.sh
```

T008 updates the skill only after T005, T006, and T007 are in place.

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1 and Phase 2.
2. Complete Phase 3 (T003 through T008).
3. Stop and confirm a schema 3.0.0 four-domain record passes structural classification and a schema 2.0.0 record is rejected unchanged.

### Incremental Delivery

1. Setup and a green suite.
2. User Story 1: four domains, schema 3.0.0, Highway Role removed.
3. User Story 2: repository-name question and optional Markdown context.
4. User Story 3: website-assisted acquisition.
5. User Story 4: canonical questions.
6. User Story 5: optional enrichment categories.
7. User Story 6: shorter skill at version 4.0.0.
8. Polish: regenerate copies, run the suite, walk the quickstart.

### Parallel Team Strategy

One implementer owns the template, `profile.sh`, and `validate-profile.sh` after T003 and T004 fail. Another can prepare the skill's four-domain readiness text, then wait for those files before T008. From User Story 2 onward, one implementer should edit the skill and `feature-092-contract.test.sh`.

---

## Notes

- Schema 2.0.0 is unsupported. Do not add a reader or a rewrite that carries Highway Role forward.
- A replaced assertion needs a comment naming the superseded behavior.
- The skill cites the Highway Experience Standard and does not copy its interaction rules or a constitution rule sentence.
- Do not chmod every test. `.highway/tools/tests/run-all.sh` invokes each test with bash.
- Run the full suite with unrestricted filesystem access. A sandboxed run can fail regeneration probes without a defect in this amendment.
