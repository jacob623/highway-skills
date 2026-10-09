---

description: "Task list for feature 153 implementation"
---

# Tasks: Conversation Delivery Hardening

**Input**: Design documents from `/specs/153-conversation-delivery-hardening/`

**Prerequisites**: [plan.md](./plan.md), [spec.md](./spec.md), [research.md](./research.md),
[data-model.md](./data-model.md), [contracts/delivery-sites.md](./contracts/delivery-sites.md),
[quickstart.md](./quickstart.md)

**Tests**: Test tasks are included and are not optional here. `D3.3` requires a behavioral change
to add or amend at least one test, and `D3.6` requires each assertion to be observed failing before
the text satisfying it is written. Every test task in this file is instrument class
`static-document-contract`.

**Organization**: Tasks are grouped by user story. Each story's phase is a complete increment that
can be implemented, tested and delivered on its own.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel — different files, no dependency on an incomplete task
- **[Story]**: The user story the task serves

## Path Conventions

Shipped sources live under `.highway/`. Generated agent trees are `.github/`, `.claude/`,
`.cursor/` and `.agents/`, plus `AGENTS.md`. No file outside those trees is written.

---

## Phase 1: Setup (Baseline Capture)

**Purpose**: Record the starting state. Every later claim in this feature is a comparison, and a
baseline taken after an edit is worthless.

- [X] T001 Run `.highway/tools/tests/run-all.sh` and record exit code, pass count and wall-clock duration in `specs/153-conversation-delivery-hardening/research.md` under a new "Implementation baseline" heading (`D3.1`)
- [X] T002 [P] Record the MUST-level keyword count of `.highway/skills/highway-profile/SKILL.md` and confirm it reads `0`, appending to the same heading in `specs/153-conversation-delivery-hardening/research.md` (FR-015 baseline)
- [X] T003 [P] Record the per-section word table and the `## Readiness` roll-up of `.highway/skills/highway-profile/SKILL.md`, confirming 1303 words, in `specs/153-conversation-delivery-hardening/research.md` (FR-017 baseline)
- [X] T004 [P] Record the count of `**What would you add, correct, or remove?**` in `.highway/skills/highway-profile/SKILL.md` and confirm it reads `1`, in `specs/153-conversation-delivery-hardening/research.md` (R6 guard baseline)
- [X] T005 Create `.highway/tools/tests/feature-153-delivery-sites.test.sh` with the instrument-class header from contract C6, sourcing `.highway/tools/tests/test-helpers.sh`, containing no assertions yet, and confirm it exits 0

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Two decisions and one evaluation that no story can proceed without.

**CRITICAL**: T006 blocks User Story 1, and T008 blocks every task that adds a rule to the
Experience Standard. T006 and T007 were both decided on 2026-10-09 and are closed.

- [X] T006 Obtain sign-off on the reaction literal's exact wording per contract C2 and record the accepted wording in `specs/153-conversation-delivery-hardening/contracts/delivery-sites.md`, replacing the "needs sign-off" marker — **blocks T016**. Decided: `**Here's a direction worth considering — what's missing from it?**`
- [X] T007 Obtain a decision on research item R5 in `specs/153-conversation-delivery-hardening/research.md`. Decided: **the heading level is not changed**. FR-005 is withdrawn, `highway-setup` is untouched, and T022, T030 and T057 are withdrawn with it
- [X] T008 For every skill returned by `grep -rl 'experience-standard' .highway/skills/`, record in `specs/153-conversation-delivery-hardening/research.md` whether its current text would satisfy or fail X2.68 through X2.72, naming any skill that would newly fail (`D3.4`, `D8.1`) — recorded as research R8

---

## Phase 3: User Story 1 — Nothing is recorded that I did not accept (Priority: P1)

**Goal**: A domain's substance is retained only after a finished candidate has been presented and
accepted, and the acceptance question appears only where a candidate exists.

**Independent Test**: Inspect the Profile workflow's four domain delivery sites for
candidate-before-retention text, and confirm the acceptance literal is restricted to moments when a
candidate has been presented.

### Tests first (`D3.6`)

- [X] T009 [US1] Add assertions to `.highway/tools/tests/feature-153-delivery-sites.test.sh` requiring candidate-before-retention text covering all four Profile domains (FR-001)
- [X] T010 [P] [US1] Add assertions to `.highway/tools/tests/feature-153-delivery-sites.test.sh` requiring the acceptance-question restriction text and the presence of X2.72 in `.highway/governance/experience-standard.md` (FR-002)
- [X] T011 [P] [US1] Add a guard assertion to `.highway/tools/tests/feature-153-delivery-sites.test.sh` that `**What would you add, correct, or remove?**` still occurs exactly once in `.highway/skills/highway-profile/SKILL.md` (R6)
- [X] T012 [US1] Run `.highway/tools/tests/feature-153-delivery-sites.test.sh`, confirm non-zero exit, and record the failing message for each assertion in `specs/153-conversation-delivery-hardening/research.md` (`D3.6`)

### Implementation

- [X] T013 [US1] Add rule X2.72 and its Observable to the `### X2 - Interaction` table in `.highway/governance/experience-standard.md` per contract C1, after X2.67
- [X] T014 [US1] Add candidate-before-retention text to `#### Domain completeness` in `.highway/skills/highway-profile/SKILL.md`, covering all four domains, with no MUST-level keyword and no restatement of any X rule (FR-001, FR-014, FR-015)
- [X] T015 [US1] Add the acceptance-question restriction to `#### Domain completeness` in `.highway/skills/highway-profile/SKILL.md`, referring to the acceptance literal by condition without adding a second emphasized copy of it (FR-002)
- [X] T016 [US1] Add the signed-off reaction literal from T006 to `.highway/skills/highway-profile/SKILL.md` as the invitation used when nothing has been captured (FR-002)
- [X] T017 [US1] Add a `## Verification` entry to `.highway/skills/highway-profile/SKILL.md` naming the checkable outcome for candidate-before-retention (`P8.4`)

### Verify

- [X] T018 [US1] Run `.highway/tools/tests/feature-153-delivery-sites.test.sh` and confirm exit 0, the keyword count still `0`, and the acceptance-literal count still `1`

**Checkpoint**: User Story 1 is independently deliverable here. It closes the only correctness
defect in the assessment.

---

## Phase 4: User Story 2 — The workflow carries my words forward (Priority: P2)

**Goal**: Each domain opening names accepted substance from the one before it, and the narration
prohibition reaches persistence, progression and domain state.

**Independent Test**: Inspect the Profile workflow for continuity text at each of its three domain
handoffs and for narration-prohibition coverage naming all three subjects.

### Tests first (`D3.6`)

- [X] T019 [US2] Add assertions to `.highway/tools/tests/feature-153-delivery-sites.test.sh` requiring continuity text at each of the three Profile domain handoffs, failing on a generic transition that names no accepted substance (FR-013)
- [X] T020 [P] [US2] Add assertions to `.highway/tools/tests/feature-153-delivery-sites.test.sh` requiring the narration prohibition's delivery in `.highway/skills/highway-profile/SKILL.md` to name persistence, progression and domain state (FR-003)
- [X] T021 [P] [US2] Add assertions to `.highway/tools/tests/feature-153-delivery-sites.test.sh` requiring X2.70 and X2.71 in `.highway/governance/experience-standard.md` (FR-012)
- [-] T022 **Withdrawn** with FR-005 (T007): no assertion for a setup heading level
- [X] T023 Run `.highway/tools/tests/feature-153-delivery-sites.test.sh`, confirm non-zero exit, and record each failing message in `specs/153-conversation-delivery-hardening/research.md` (`D3.6`)

### Implementation

- [X] T024 [US2] Add rules X2.70 and X2.71 with their Observables to `.highway/governance/experience-standard.md` per contract C1
- [X] T025 [P] [US2] Add continuity text to `##### Vision` in `.highway/skills/highway-profile/SKILL.md` naming accepted Identity substance (FR-013)
- [X] T026 [P] [US2] Add continuity text to `##### Competitive Path` in `.highway/skills/highway-profile/SKILL.md` naming accepted Vision substance (FR-013)
- [X] T027 [P] [US2] Add continuity text to `##### Guiding Principles` in `.highway/skills/highway-profile/SKILL.md` naming accepted Competitive Path substance (FR-013)
- [X] T028 [US2] Extend the narration-prohibition delivery in `.highway/skills/highway-profile/SKILL.md` to cover persistence, progression and domain state rather than readiness vocabulary alone (FR-003)
- [X] T029 [US2] Add a `## Verification` entry to `.highway/skills/highway-profile/SKILL.md` naming the checkable outcome for continuity at the three handoffs (`P8.4`)
- [-] T030 **Withdrawn** with FR-005 (T007): `.highway/skills/highway-setup/SKILL.md` is not changed

### Verify

- [X] T031 [US2] Run `.highway/tools/tests/feature-153-delivery-sites.test.sh` and confirm exit 0 with the keyword count still `0`

**Checkpoint**: User Stories 1 and 2 are both independently deliverable.

---

## Phase 5: User Story 3 — The workflow adds something to my thinking (Priority: P3)

**Goal**: The Standard requires one grounded addition when reasoning would materially improve the
Working Idea, bounded to one and excluding padding, and the Profile workflow carries three worked
exemplars of that behavior.

**Independent Test**: Inspect the Experience Standard for the contribution rule and its bound, and
the Profile workflow for three exemplars — each concrete, each a different move, each closing on a
question that invites contribution.

### Tests first (`D3.6`)

- [X] T032 [US3] Add assertions to `.highway/tools/tests/feature-153-delivery-sites.test.sh` requiring X2.68 and X2.69 in `.highway/governance/experience-standard.md`, each with one keyword and 25 words or fewer (FR-009, FR-010, `P1.1`, `P1.3`)
- [X] T033 [P] [US3] Add an assertion to `.highway/tools/tests/feature-153-delivery-sites.test.sh` requiring X2.69's Observable to carry the exclusion list (FR-010, `P1.4`)
- [X] T034 [P] [US3] Add assertions to `.highway/tools/tests/feature-153-delivery-sites.test.sh` requiring exactly three exemplars in `.highway/skills/highway-profile/SKILL.md`, each closing on a question (FR-011)
- [X] T035 [US3] Run `.highway/tools/tests/feature-153-delivery-sites.test.sh`, confirm non-zero exit, and record each failing message in `specs/153-conversation-delivery-hardening/research.md` (`D3.6`)

### Implementation

- [X] T036 [US3] Add rules X2.68 and X2.69 with their Observables to `.highway/governance/experience-standard.md` per contract C1
- [X] T037 [US3] Create the `#### Contribution in practice` subsection in `.highway/skills/highway-profile/SKILL.md`, between `#### Domain completeness` and `##### Organizational expression`, per research item R1
- [X] T038 [US3] Write exemplar 1 in that subsection — a distinction drawn out of a single word the person used — using concrete domain content, closing on an open question, and not reproducing the acceptance literal (FR-011, R6, `D1.1`)
- [X] T039 [US3] Write exemplar 2 — latent structure named as an organizing principle — under the same constraints (FR-011)
- [X] T040 [US3] Write exemplar 3 — a stated preference reframed as a decision criterion — under the same constraints (FR-011)
- [X] T041 [US3] Add a `## Verification` entry to `.highway/skills/highway-profile/SKILL.md` naming the checkable outcome for the three exemplars (`P8.4`)

### Verify

- [X] T042 [US3] Run `.highway/tools/tests/feature-153-delivery-sites.test.sh` and confirm exit 0, the keyword count still `0`, and the acceptance-literal count still `1`

**Checkpoint**: User Stories 1 through 3 are deliverable. This is the point at which Pass B's
delivery exists.

---

## Phase 6: User Story 4 — Each domain stays on its own subject (Priority: P4)

**Goal**: The future-oriented domain keeps approach and sequencing out of its retained wording and
names the domain that owns them.

**Independent Test**: Inspect the future-oriented domain's delivery site for an emitted cue
excluding approach and sequencing and naming the owning domain.

- [X] T043 [US4] Add an assertion to `.highway/tools/tests/feature-153-delivery-sites.test.sh` requiring an emitted cue in `##### Vision` of `.highway/skills/highway-profile/SKILL.md` that excludes approach and sequencing and names `Competitive Path` (FR-004)
- [X] T044 [US4] Run `.highway/tools/tests/feature-153-delivery-sites.test.sh` and record the failing message in `specs/153-conversation-delivery-hardening/research.md` (`D3.6`)
- [X] T045 [US4] Add the emitted cue to `##### Vision` in `.highway/skills/highway-profile/SKILL.md` (FR-004)
- [X] T046 [US4] Run `.highway/tools/tests/feature-153-delivery-sites.test.sh` and confirm exit 0

---

## Phase 7: User Story 5 — The small literal corrections (Priority: P5)

**Goal**: The reassurance, the inline amendment form, and the named grounding trigger.

**Independent Test**: Inspect the emitted validation block for the unemphasized reassurance, the
Experience Standard for the inline amendment form, and the grounding source for the named trigger.

- [X] T047 [P] [US5] Add an assertion to `.highway/tools/tests/feature-153-delivery-sites.test.sh` requiring an unemphasized "I don't know" reassurance accompanying the acceptance literal in `.highway/skills/highway-profile/SKILL.md` (FR-006)
- [X] T048 [P] [US5] Add an assertion to `.highway/tools/tests/feature-153-delivery-sites.test.sh` requiring X2.56's Observable in `.highway/governance/experience-standard.md` to name the inline form (FR-007)
- [X] T049 [P] [US5] Add an assertion to `.highway/tools/tests/feature-153-delivery-sites.test.sh` requiring `.highway/instructions/highway-agent-context.md` to name the moment the Experience Standard is read (FR-008)
- [X] T050 [US5] Run `.highway/tools/tests/feature-153-delivery-sites.test.sh` and record each failing message in `specs/153-conversation-delivery-hardening/research.md` (`D3.6`)
- [X] T051 [US5] Add the unemphasized reassurance to `.highway/skills/highway-profile/SKILL.md`, keeping the acceptance question the only emphasized element (FR-006, `X2.67`)
- [X] T052 [P] [US5] Amend X2.56's Observable in `.highway/governance/experience-standard.md` to name the inline form, leaving the rule text unchanged (FR-007)
- [X] T053 [P] [US5] Replace the "consult" phrasing in `.highway/instructions/highway-agent-context.md` with text naming the moment the Experience Standard is read (FR-008)
- [X] T054 [US5] Run `.highway/tools/tests/feature-153-delivery-sites.test.sh` and confirm exit 0

---

## Phase 8: Polish, Regeneration and Reporting

**Purpose**: Version provenance, generated-artifact correspondence, the measurements no check
produces, and the honest completion report.

- [X] T055 Update `## Version and Amendment Provenance` in `.highway/governance/experience-standard.md` to version `11.1.0`, naming the five added identifiers, the one amended Observable, and that no identifier is retired (`D5.3`, `P7.7`)
- [X] T056 [P] Increment `metadata.version` to `11.1.0` in `.highway/skills/highway-profile/SKILL.md` (`P7.2`, `P7.7`)
- [-] T057 **Withdrawn** with FR-005 (T007): `highway-setup` is unchanged, so it takes no version increment
- [X] T058 Run `.highway/tools/generate-catalog.sh`, `.highway/tools/generate-library-catalog.sh`, `.highway/tools/generate-agent-adapters.sh` and `.highway/tools/generate-instructions.sh`, then confirm `.github/`, `.claude/`, `.cursor/`, `.agents/` and `AGENTS.md` are updated with no hand edit (FR-016, `D4.5`, `D4.6`, `D4.7`)
- [X] T059 [P] Audit every changed file under `.highway/skills/` for restatement of an Experience Standard rule sentence and record the result (FR-014, `P7.3`)
- [X] T060 [P] Confirm the MUST-level keyword count of `.highway/skills/highway-profile/SKILL.md` is `0` and record it (FR-015)
- [X] T061 [P] Re-measure the per-section word table of `.highway/skills/highway-profile/SKILL.md`, record the new `## Readiness` roll-up against the 1303 baseline, and state that no check decides it (FR-017)
- [X] T062 Verify no shipped artifact changed in this feature contains `specs/` or `.specify/` (`D1.1`)
- [X] T063 Run `time .highway/tools/tests/run-all.sh`, confirm exit 0, and record the pass count and duration delta against T001 (`D3.2`, SC-009)
- [X] T064 Walk `specs/153-conversation-delivery-hardening/quickstart.md` end to end and confirm every expected value matches
- [X] T065 Write the completion report stating, as separate claims: the suite result; requirement coverage FR-001 through FR-020; that every requirement's evidence is a document contract and none is evidence of runtime behavior; the recorded section size; and that conversational evaluation is deferred to a follow-up feature (FR-018, FR-019, FR-020, `D7.3`)

---

## Dependencies

```text
Phase 1 (Setup)
   │
Phase 2 (Foundational)
   ├── T006 ──────────────► T016   (reaction literal wording)
   ├── T007 ──────────────► T030   (heading level decision)
   └── T008 ──────────────► T013, T024, T036   (rules may not be enabled before evaluation)
   │
   ├── Phase 3 (US1, P1) ── independently deliverable
   ├── Phase 4 (US2, P2) ── independently deliverable
   ├── Phase 5 (US3, P3) ── independently deliverable
   ├── Phase 6 (US4, P4) ── independently deliverable
   └── Phase 7 (US5, P5) ── independently deliverable
   │
Phase 8 (Polish) ── requires every delivered phase
```

**Story independence**: the five stories touch different delivery sites and share only the test
file, which is append-only across phases. They may be implemented in any order after Phase 2. The
priority order is the recommended order because it delivers the correctness defect first.

**Serialization constraint**: tasks marked `[P]` within a phase write to different files or
different sections. Two tasks editing `.highway/skills/highway-profile/SKILL.md` are marked `[P]`
only when they target different headings, as in T025 through T027.

## Parallel Execution Examples

**Phase 1**: T002, T003 and T004 are independent measurements and run together.

**Phase 4**: T025, T026 and T027 each edit a different `#####` heading and run together; T020 and
T021 each append a distinct assertion group and run together.

**Phase 7**: T047, T048 and T049 target three different files and run together, as do T052 and
T053.

**Phase 8**: T059, T060 and T061 are independent audits.

## Implementation Strategy

**MVP**: Phases 1, 2 and 3 — User Story 1 alone. It is the only correctness defect in the
assessment; everything after it is quality. Delivering it stops a record being written from
material the person never saw in final form.

**Increment 2**: Phase 4. Narration failed in four of six observed runs and is the most common
defect; continuity is the same vacuum from the other side.

**Increment 3**: Phase 5. The generative behavior, and the largest change in volume.

**Increment 4**: Phases 6 and 7, then Phase 8.

**Phase 8 cannot be skipped on any increment that ships.** Without T058 the generated agent trees
drift from source, and `adapter-coverage.test.sh` fails. Without T065 the feature's evidence limit
goes unstated, which is the thing the spec was rewritten to prevent.

## A standing note on what these tasks produce

Every assertion in this file is a string match or a count over a source document. Completing all
sixty-five tasks establishes that the text exists, is shaped as contracted, and reaches all four
agent trees. It establishes nothing about whether a conversation improves. That is deliberate, it
is recorded in FR-018, and the evaluation that would test it is a separate feature.
