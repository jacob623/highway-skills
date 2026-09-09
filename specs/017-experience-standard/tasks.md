# Tasks: Highway Experience Standard

**Feature**: 017-experience-standard | **Date**: 2026-09-08

**Input**: [spec.md](spec.md), [plan.md](plan.md), [research.md](research.md), [data-model.md](data-model.md), [contracts/experience-standard.md](contracts/experience-standard.md), [quickstart.md](quickstart.md)

**Tests**: This phase writes a document, not a checker. Phase 6 builds enforcement. Verification
here is by hand against the contract's acceptance checks, plus the existing suite staying green.

---

## Phase 1: Setup & Baseline

- [X] T001 Run `.highway/tools/tests/run-all.sh` and record the pass count; it must be 0 failed before any edit, per `D3.1`
- [X] T002 Record the working tree state with `git status --porcelain`, so any file touched unintentionally is visible later
- [X] T003 [P] Record the current version of `.highway/governance/constitution.md` and both skills' versions, so the increments in Phase 5 can be stated precisely

---

## Phase 2: Foundational — the document's frame

**Purpose**: The framing decides what is admissible. Writing rules first and framing after is how a
standard ends up with rules it cannot justify.

**⚠️ No rule may be written until T008 is complete.**

- [X] T004 Create `.highway/governance/experience-standard.md` with the section order fixed by the contract: Sync Impact Report, Scope, Non-goals, Precedence, Tier definitions, Rules, Candidates, Versioning policy
- [X] T005 Write the Scope section: what Layer 2 governs — what a skill emits and how it interacts — and state that it constrains neither the `SKILL.md` text nor the user's own content
- [X] T006 Write the Precedence section: the Highway Skills Constitution outranks this document wherever both could apply, and security-affecting rules outrank everything
- [X] T007 Write the Tier definitions section, stating what each tier obliges **in this document**. Do not borrow a meaning from either constitution by analogy — `[auto]` already means two different things across them, and feature 014 had to correct exactly that error
- [X] T008 Write the Versioning policy: MAJOR / MINOR / PATCH, matching the precedent of the two constitutions, and note that demoting a rule to a candidate is MAJOR because it breaks every skill citing it

**Checkpoint**: The frame exists. Rules can now be admitted against it.

---

## Phase 3: User Story 1 — A third skill inherits the behaviour (P1)

**Goal**: The shared behaviours of the two existing skills are stated as rules, so the next skill
inherits them by reading rather than by imitation.

**Independent test**: Read the standard and list what a new skill must do, without consulting
either existing skill.

### Admit the rules

- [X] T009 [US1] Admit the X1 output-structure rules, traced to `highway-help`'s declared six-field order and `highway-inquiry`'s preserved file shape. Include the form of an empty result — `highway-help` declares an exact string rather than an empty table
- [X] T010 [US1] Admit the X2 interaction rule: a confirmation before an irreversible act must state what is lost. `highway-inquiry` explicitly rejects "Are you sure?" as insufficient. **Mark it single-sample**
- [X] T011 [US1] Admit the X4 artifact-placement rule: a skill declares the exact path it writes, or declares that it writes nothing. **Mark it single-sample**
- [X] T012 [US1] Admit the X5 provenance rule: a message names something its reader can act on. Derive it from the two skills' *disagreement*, not their agreement — see T016
- [X] T013 [US1] Admit the X6 determinism rule: an unchanged input set produces an unchanged artifact, with no recorded timestamp. **Mark it single-sample**
- [X] T014 [US1] Record X3 terminology as a **candidate, not a rule** — it needs a glossary to check against and none exists. Record cost disclosure as a candidate too: `highway-help` declares `O(n)`, one skill, no possible check

### Verify the rules against the contract

- [X] T015 [US1] **Restatement check — the central risk.** For each admitted rule, compare its text against the `P` and `D` inventories. Confirm no rule requires a skill to ask when ambiguous (`P1.7`), to name one of four next actions (`P5.2`), or to report rather than silently alter (`P4.6`). Those obligations belong to Layer 1
- [X] T016 [US1] Confirm the X5 rule leaves **both** skills correct: `highway-help` prints an exact error string, `highway-inquiry` deliberately omits rule identifiers for framework-owned parts. A rule that makes either wrong is the wrong rule
- [X] T017 [US1] Confirm every rule carries exactly one keyword, one obligation, an Observable applicable by hand today, and one tier
- [X] T018 [US1] Confirm **no rule is tagged `[auto]`**. Phase 6 owns enforcement; tagging before a check exists is the defect features 013 and 014 spent two features removing
- [X] T019 [US1] Walk every admitted rule against both skills and confirm each satisfies it, or record a deliberate exception with its reason
- [X] T020 [US1] Confirm every single-sample rule is marked as such, so a later reader knows which rules rest on one example rather than on agreement

**Checkpoint**: The standard states what it can justify, and nothing more.

---

## Phase 4: User Story 2 — A user's own content is never judged (P1)

**Goal**: The standard cannot be read as licence to validate a user's NFR text against Highway's
rules.

**Independent test**: Read the non-goal and confirm it forecloses that reading.

- [X] T021 [US2] Write the Non-goals section: the standard governs only the *form* of generated content and states no obligation about the content of a user's own governance artifacts
- [X] T022 [US2] State the consequence explicitly — a future skill may require a user's NFR to carry a measurable threshold, but never what that threshold should be
- [X] T023 [US2] Confirm no admitted rule contradicts the non-goal by reaching into artifact content rather than form
- [X] T024 [US2] Confirm the non-goal is discoverable: it sits in its own section rather than buried in a rationale paragraph, because Phase 7 depends on a reader finding it

**Checkpoint**: The Layer 2 / Layer 3 boundary is stated before any skill is built against it.

---

## Phase 5: User Story 3 — Each skill declares which rules it satisfies (P2)

**Goal**: The link between rule and behaviour is visible from the skill, not only from the standard.

**⚠️ Depends on Phase 3 — no citation may point at a rule id that has not settled.**

- [X] T025 [US3] Add an `X`-rule citation line to `.highway/skills/highway-help/SKILL.md` in its Outputs section, naming only rules it satisfies and restating no rule text, per `P7.3`
- [X] T026 [US3] Add the same to `.highway/skills/highway-inquiry/SKILL.md`
- [X] T027 [US3] Increment both skills' versions. Classify against the Skill Versioning Policy — PATCH is expected, since no contract or behaviour changes. Confirm `P7.7` is not triggered
- [X] T028 [US3] Validate both skills and confirm `OK ... 0 unchecked`, watching `P7.5` specifically — the citation adds words to a normative section
- [X] T029 [US3] Confirm every cited id resolves to a rule in the standard, and that no skill claims a rule it does not satisfy
- [X] T030 [US3] **Discharge the Correspondence Gate**: run `generate-catalog.sh` and `generate-agent-adapters.sh`, so the catalog and all six adapters reflect the edited skills, per `D4.7`
- [X] T031 [US3] Run `adapter-coverage.test.sh` and confirm it reports no stale artifact. This is the first time `D4.7` governs a feature other than the one that wrote it
- [X] T032 [US3] Confirm the regenerated catalog carries both new versions

**Checkpoint**: Rules and skills point at each other, and the generated artifacts are current.

---

## Phase 6: Polish & Cross-Cutting

- [X] T033 [P] Run `shipped-tree-independence.test.sh` and confirm the standard names no development-only path, per `D1.1`
- [X] T034 [P] Confirm the standard contains no relative link target — it is copied into agent trees alongside the skills that cite it
- [X] T035 Confirm no `X` id is duplicated, and that any `P` or `D` id appearing in the standard is a citation rather than a restatement
- [X] T036 Complete the Sync Impact Report: initial version, ratification date, what was added, which rules are single-sample, and which candidates were recorded rather than admitted
- [X] T037 Walk [quickstart.md](quickstart.md) end to end and correct any step whose expected output differs from actual
- [X] T038 Update `governance-plan.md`: mark Phase 5 complete with the task count, the admitted rule count, and the findings worth carrying into Phase 6

---

## Dependencies

```text
Phase 1 (Setup)
      │
      ▼
Phase 2 (Frame) ──── decides what is admissible; blocks all rule writing
      │
      ├──────────────────────┐
      ▼                      ▼
Phase 3 (US1: rules)   Phase 4 (US2: non-goal)
      │                      │
      └──────────┬───────────┘
                 ▼
        Phase 5 (US3: citations)   ── needs settled rule ids
                 │
                 ▼
        Phase 6 (Polish)
```

**Critical path**: T004 → T008 → T009–T014 → T015 → T025 → T030.

**Why Phase 2 blocks**: the scope, precedence, and tier definitions decide which candidate rules
are admissible. Rules written first would have to be re-justified against a frame chosen to fit
them.

**Why Phase 5 comes last among the stories**: a citation naming a rule id that later moves is a
dangling reference in a shipped file.

## Parallel Opportunities

| Tasks | Why parallel-safe |
|---|---|
| T003 with T001–T002 | Reads different files, writes nothing |
| Phase 3 with Phase 4 | Different sections of the same document; coordinate edits or run sequentially |
| T033 with T034 | Independent checks, neither modifies the tree |

Phases 3 and 4 touch one file. They are logically independent but physically adjacent, so
sequential is safer for little lost time.

## Implementation Strategy

**MVP**: Phases 1, 2 and 3. That delivers a framed document with justified rules — the thing Phase
6 needs in order to build enforcement.

**Then**: Phase 4 is small but blocks Phase 7. Phase 5 makes the link visible from the skills.

**The failure this task list is shaped to avoid**: a standard that reads well, restates `P1.7` in
different words, tags rules `[auto]` that nothing checks, and generalises from one skill without
saying so. Each has a precedent here — the restatement risk is live and was found in Phase 0, the
false `[auto]` tier took two features to remove, and the single-sample problem is why the Gate
existed at all. T015, T018 and T020 exist specifically to catch those three.

## Task Summary

| Phase | Tasks | Story |
|---|---|---|
| 1 Setup | T001–T003 | — |
| 2 Frame | T004–T008 | — |
| 3 Rules | T009–T020 | US1 (P1) |
| 4 Non-goal | T021–T024 | US2 (P1) |
| 5 Citations | T025–T032 | US3 (P2) |
| 6 Polish | T033–T038 | — |

**Total**: 38 tasks. Six are verification tasks that could each reject work already done —
T015, T016, T018, T019, T020 and T031.
