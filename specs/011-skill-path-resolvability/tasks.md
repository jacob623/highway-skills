---

description: "Task list template for feature implementation"
---

# Tasks: Skill Path Resolvability Rule

**Input**: Design documents from `/specs/011-skill-path-resolvability/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md (all present)

**Tests**: The check this feature delivers is itself enforcement, and two existing tests will fail
unless extended. Those extensions are mandatory in-scope work, not optional scaffolding.

**Organization**: Tasks are grouped by user story (spec.md P1/P2/P3) to enable independent
implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies on incomplete tasks)
- **[Story]**: Which user story this task belongs to (US1, US2, US3)
- Every task names its exact file path

## Path Conventions

Single project. All paths are repository-root-relative. `.highway/` is the framework root.

**The rule**: `P8.7` — a skill MUST NOT carry a link whose target is a relative filesystem path.
Observable: no Markdown link target in the skill body is a relative filesystem path. Tier `[auto]`,
Principle VIII, no not-applicable condition. Per contracts/skill-reference-contract.md.

**Why a prohibition rather than a resolution test**: a `SKILL.md` is copied byte-identically into
three further trees, one of which is a flat file, and no sibling file is ever copied. No relative
target can resolve in every location a skill is read. Per research.md R2.

---

## Phase 1: Setup

**Purpose**: Establish a known-good baseline before any change.

- [X] T001 Run `.highway/tools/tests/run-all.sh` from the repository root and confirm every test
      passes, so any later failure is attributable to this feature. Satisfies D3.1.

**Checkpoint**: Baseline confirmed green.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: The rule must exist in the constitution before a check for it can run. The validator
iterates the rules the constitution declares and dispatches by identifier, so a registered check
for an undeclared rule would never be invoked.

**⚠️ CRITICAL**: No user story work can begin until this phase is complete.

- [X] T002 In `.highway/governance/constitution.md`, add rule `P8.7` to the Principle VIII table,
      after `P8.6`, matching the column shape of its siblings: identifier, rule with exactly one
      keyword, Observable, tier `[auto]`. The rule text names no location that exists only during
      development. Per contracts/skill-reference-contract.md and research.md R1.
- [X] T003 In `.highway/governance/constitution.md`, increment the version by one minor step from
      `2.0.1` and record the amendment in the Sync Impact Report: the rule added, the
      classification reasoning cited against the versioning policy text rather than a previous
      amendment, and the confirmation that no registered skill is invalidated. Per research.md R5.
- [X] T004 Run `.highway/tools/tests/run-all.sh` and `.highway/tools/validate-skill.sh
      .highway/skills/highway-help`; confirm the suite passes and `P8.7` appears in the
      `UNCHECKED` group, since no check is registered for it yet. This is the expected
      intermediate state, not a defect.

**Checkpoint**: The rule is declared, the amendment is recorded, and the suite is green with
`P8.7` reported as unchecked.

---

## Phase 3: User Story 1 — An author can read the rule before breaking it (Priority: P1)

**Goal**: The rule is decided automatically for every skill, reported under its own identifier,
and stated where an author reads it.

**Independent Test**: Read the authoring standard without running any tool and find the
constraint; then seed a relative link into a skill and watch validation name `P8.7`.

- [X] T005 [US1] Add `rc_check_P8_7` to `.highway/tools/lib/rule-checks.sh`. It extracts Markdown
      link targets from the skill body, fails any target that is a relative filesystem path,
      passes an absolute URL, and evaluates nothing outside a link target so a command example is
      never flagged. It accesses no filesystem. Bash 3.2 compatible; Declared Toolchain only. Do
      **not** register it yet. Per contracts/skill-reference-contract.md and research.md R4.
- [X] T006 [US1] Satisfy D3.4 before the check is enabled: invoke `rc_check_P8_7` directly against
      each of the seven fixtures under `.highway/tools/tests/fixtures/` and against
      `.highway/skills/highway-help/SKILL.md`, and confirm each result matches the table in
      research.md R7 — all PASS, no existing verdict changed. Record any deviation before
      proceeding (depends on T005).
- [X] T007 [US1] Register the rule in `rc_registry` in `.highway/tools/lib/rule-checks.sh` by
      adding the row `P8.7<TAB>rc_check_P8_7<TAB>-`. The third column is `-` because the rule
      applies to every skill unconditionally (depends on T006).
- [X] T008 [US1] Prevent the rule misfiring on library content. `validate-library.sh` dispatches
      the same rule-check registry, and a library file is never copied into an adapter tree, so a
      relative link there resolves and must not be failed. Add `rc_library_exempt_ids` to
      `.highway/tools/lib/rule-checks.sh` returning `P8.7`, and apply it in
      `.highway/tools/validate-library.sh` for every library type — not only `template`, which is
      all the existing `rc_template_exempt_ids` covers. Report the exemption as N/A with a
      condition rather than skipping it silently, matching the existing pattern (depends on T007).
- [X] T009 [P] [US1] Create the fixture
      `.highway/tools/tests/fixtures/invalid-skill-relative-link/SKILL.md`, conformant in every
      respect except a single relative Markdown link target, so it produces exactly one failure.
      Its frontmatter `name` equals its directory name.
- [X] T010 [US1] Add a seeded `P8.7` case to `.highway/tools/tests/rule-checks.test.sh` using the
      existing `write_base_skill` and `assert_reports` helpers. **This is not optional**: that test
      ends with a loop asserting every registered rule has a seeded violation case, so the suite
      fails without it (depends on T007).
- [X] T011 [P] [US1] In `.highway/tools/tests/validate-skill.test.sh`, add
      `assert_exit_nonzero_naming` for the new fixture naming a substring of the `P8.7` finding,
      and `assert_single_failure` for the same fixture asserting the tag `P8.7`, so the rule is
      confirmed to report in the right group through the full validator (depends on T009).
- [X] T012 [US1] In `.highway/skills/_authoring-standard.md`, make the constraint discoverable to
      an author and cite `P8.7` by identifier. Restate no rule text — the test for that document
      rejects verbatim rule sentences and requires citation by identifier. Per P7.3 and
      contracts/governance-documentation-contract.md.
- [X] T013 [US1] Run `.highway/tools/tests/run-all.sh` and confirm it passes. Run
      `.highway/tools/validate-skill.sh .highway/skills/highway-help` and confirm `P8.7` now
      appears in `CHECKED` rather than `UNCHECKED`.

**Checkpoint**: A relative link fails validation naming `P8.7`; a command example does not; the
authoring standard states the constraint; the suite is green.

---

## Phase 4: User Story 2 — Someone new can find the governance at all (Priority: P2)

**Goal**: A reader starting at the repository front page reaches both governance documents.

**Independent Test**: Start at the front page and reach the constitution and the authoring
standard by following links only.

- [X] T014 [US2] Add a governance section to `README.md` naming and linking
      `.highway/governance/constitution.md` and `.highway/skills/_authoring-standard.md`, and
      stating what each is for. The front page documents how to author, validate, catalog, and
      distribute a skill but never names the rules a skill is judged by.
- [X] T015 [US2] Confirm both links added in T014 resolve from the repository root, satisfying
      D6.2 (depends on T014).

**Checkpoint**: The governance documents are reachable from the front page.

---

## Phase 5: User Story 3 — The follow-up list describes outstanding work (Priority: P3)

**Goal**: Every remaining follow-up entry describes work that has not been done.

**Independent Test**: Check each remaining entry against the repository and confirm its work is
genuinely outstanding.

**Note**: this phase amends the Sync Impact Report that T003 already touched. That is intended —
the removals belong to the same amendment and are recorded in the same report.

- [X] T016 [US3] In `.highway/governance/constitution.md`, remove the
      `TODO(PURPOSE_SECTION_ENFORCEMENT)` entry and record the evidence that its work is complete:
      `SV_REQUIRED_SECTIONS` in `.highway/tools/lib/schema-validate.sh` already includes `Purpose`.
- [X] T017 [US3] Remove the `TODO(BUMP_TYPE_REVIEW)` entry and record that its condition never
      triggered: `highway-help` exists and declares a `## Purpose` section, so no reclassification
      is needed.
- [X] T018 [US3] Remove the `TODO(AUTHORING_STANDARD_REALIGNMENT)` entry and record the evidence:
      the authoring standard cites 28 distinct rule identifiers, restates no rule text, and
      contains no section by the name the entry uses; `authoring-standard.test.sh` enforces the
      first two and passes. The feature description assumed this entry still required work; it
      does not.
- [X] T019 [US3] Confirm exactly one follow-up entry remains, `TODO(AUTO_TIER_ENFORCEMENT)`, and
      that it describes genuinely outstanding work owned by a later phase (depends on T016–T018).

**Checkpoint**: One follow-up entry remains, and every removal carries its evidence.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Whole-feature validation.

- [X] T020 Run `.highway/tools/tests/run-all.sh` and confirm every test passes, with no test
      removed or weakened. Satisfies D3.2 and D3.5.
- [X] T021 Confirm nothing was regenerated: `git status --short .highway/catalog .github/skills
      .claude/skills .cursor/rules` produces no output. No skill content changed, so no catalog
      entry, adapter, or manifest row should differ (quickstart.md Scenario 13).
- [X] T022 Execute quickstart.md Scenarios 1–12 and confirm each matches its stated expected
      result. Scenario 6 requires temporarily adding an absolute URL to a fixture and removing it;
      Scenario 11 is a read-through confirming `P8.7` and the development constitution's
      cross-reference rule do not restate one another.

**Checkpoint**: Feature complete; full regression green; every quickstart scenario verified.

---

## Dependencies

- **Phase 1** (T001) has no dependencies.
- **Phase 2** (T002–T004) depends on T001 and blocks every later task: the validator dispatches
  only rules the constitution declares, so a check registered for an undeclared rule is never
  invoked. T002 blocks T003; T004 depends on both.
- **Phase 3** (US1, T005–T013) depends on Phase 2. T005 blocks T006, which blocks T007, which
  blocks T008 and T010. T009 and T011 are the fixture and its assertions, and T009 blocks T011.
  T012 is independent of the tooling tasks. T013 depends on all of T005–T012.
- **Phase 4** (US2, T014–T015) depends only on Phase 2 for the constitution path being stable. It
  may run before or after Phase 3.
- **Phase 5** (US3, T016–T019) depends on T003, which establishes the amendment record the
  removals are added to. Independent of Phases 3 and 4.
- **Phase 6** (T020–T022) depends on all prior phases.

### Ordering hazards

- **T007 before T006** skips the fixture evaluation D3.4 requires. The rule exists precisely
  because an unconditional new check silently changes the verdict of every artifact already
  present, and a fixture expected to produce one failure can quietly begin producing two.
- **T007 without T010** turns the suite red. `rule-checks.test.sh` ends with a loop asserting that
  every registered rule has a seeded violation case; registering `P8.7` without adding one fails
  that assertion, and the failure names a missing test rather than the real cause.
- **T007 without T008** applies a rule about skills to library files. `validate-library.sh`
  dispatches the same registry, and its only existing exemption covers the `template` type, so
  knowledge and governance files would be judged by a rule whose subject they are not.
- **Registering the check as a standalone test** instead of in the registry would enforce the rule
  while leaving it absent from the per-skill report — the same enforced-but-invisible defect this
  feature exists to remove, reproduced one level down.

## Parallel Execution Examples

**Phase 3** — the fixture and the authoring standard are independent of the tooling chain:

```text
T009  .highway/tools/tests/fixtures/invalid-skill-relative-link/SKILL.md
T012  .highway/skills/_authoring-standard.md
```

**Phases 4 and 5** are mutually independent and may run concurrently with Phase 3 once Phase 2 is
complete:

```text
T014  README.md
T016  .highway/governance/constitution.md   (report only)
```

## Implementation Strategy

**MVP is Phase 2 plus Phase 3.** At that point the rule exists, is enforced, is reported under its
own identifier, and is readable by an author before they break it — which is the entire premise of
the feature. It is deliverable there if interrupted.

**Phase 4 makes the governance discoverable** from the obvious starting point rather than only to
someone who already knows where to look.

**Phase 5 is bookkeeping.** All three entries were verified already satisfied; none hides
implementation work. It is last because it changes no behaviour, and its value is that a future
reader can trust the follow-up list without re-verifying every entry.

**Next phase after this feature**: packaging, or the automatic-tier work — `governance-plan.md`
Phases 3 and 4, which are independent of each other.
