# Tasks: Collaborative Convergence

**Input**: Design documents from `specs/150-collaborative-convergence/`

**Prerequisites**: [plan.md](plan.md), [spec.md](spec.md), [research.md](research.md), [data-model.md](data-model.md), [contracts/](contracts/)

**Tests**: Included and mandatory. D3.3 requires a behavioral change to add or amend at least one test, and D3.6 requires each test to be observed failing before the behavior is marked complete. This is not optional TDD preference — it is a constitutional obligation in this repository.

**Organization**: Tasks are grouped by user story. The two governed documents are edited serially within each story; test files are edited in parallel.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel — different file, no dependency on an incomplete task
- **[Story]**: US1–US5, mapping to the user stories in [spec.md](spec.md)

## Path Conventions

- `STD` = `.highway/governance/experience-standard.md`
- `PROF` = `.highway/skills/highway-profile/SKILL.md`
- Tests live in `.highway/tools/tests/`
- Exact text for every edit is in [contracts/rule-inventory.md](contracts/rule-inventory.md) and [contracts/profile-wording.md](contracts/profile-wording.md). Transcribe; do not re-derive.

## Critical constraints

- Bash 3.2.57 only. No associative array, `mapfile`, `readarray`, `${var^^}`, `&>>`.
- Declared Toolchain only inside scripts. No `git`, no `stat`.
- Never kill a running suite terminal — two tests seed probes into the live tree and a killed run leaves residue that fails the next run in the wrong file.
- `STD` and `PROF` are on the protected-file audit list. Both are modified only under this specification.
- Every assertion listed as frozen in [contracts/test-impact.md](contracts/test-impact.md) must still pass at the end.

---

## Phase 1: Setup

**Purpose**: Record the baseline and create the test file that will carry the new assertions.

- [X] T001 Run `.highway/tools/tests/run-all.sh` and record the summary line and exit code in the implementation log. Expected `73 passed, 0 failed`, exit 0. D3.1 is not satisfied until this is observed, and no edit may precede it.
- [X] T002 Create `.highway/tools/tests/feature-150-collaborative-convergence.test.sh` with the shebang, `set -u`, the `# Instrument class: static-document-contract` and `# Artifact classes: source-document, generated-artifact` declarations, `SCRIPT_DIR`/`HIGHWAY_ROOT`/`REPO_ROOT` resolution matching the existing tests, `require_text`/`require_absent` helpers, and a `fail=0` accumulator. No assertions yet.
- [X] T003 Run `bash .highway/tools/tests/feature-150-collaborative-convergence.test.sh` and confirm it exits 0 with no assertions, so later failures are attributable to assertions rather than scaffolding.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Move the version strings and the rule-count assertions to their final values **before** the rules exist. This deliberately turns the suite red, and that red run is the D3.6 evidence for every count-coupled test. Do not proceed to Phase 3 until the expected failures have been observed and recorded.

⚠️ **The suite will fail from T005 until T042. This is intended and recorded, not a defect.**

- [X] T004 In `STD`, change line 3 to ``**Layer 2 - Experience.** Version `10.0.0`.`` and the provenance line to ``**Version**: `10.0.0` | **Ratified**: 2026-09-08 | **Last Amended**: 2026-10-07``. Add one sentence to the provenance paragraph naming this amendment and stating that it retires no identifier.
- [X] T005 In `PROF` frontmatter, change `version: 9.0.0` to `version: 10.0.0`.
- [X] T006 [P] Update `.highway/tools/tests/experience-standard-amendment.test.sh`: `9.1.0` → `10.0.0` in both tokens, `2026-10-06` → `2026-10-07`, and `-ne 33` → `-ne 49`. Add a `# Superseded behavior:` comment naming the old values and the reason.
- [X] T007 [P] Update `.highway/tools/tests/experience-standard-convergence.test.sh`: `-ne 33` → `-ne 49`, with a superseded-behavior comment.
- [X] T008 [P] Update `.highway/tools/tests/constitution-experience-alignment.test.sh`: the Standard's `-ne 33` → `-ne 49`, with a superseded-behavior comment. Leave the constitution's `-ne 73` untouched.
- [X] T009 [P] Update `.highway/tools/tests/highway-ux-alignment.test.sh`: `-ne 33` → `-ne 49`, with a superseded-behavior comment.
- [X] T010 [P] Update `.highway/tools/tests/feature-141-experience-standard-refactor.test.sh`: `-ne 33` → `-ne 49` and the version/date token, with a superseded-behavior comment. Do not touch the five-row Interaction Boundaries assertions.
- [X] T011 [P] Update `.highway/tools/tests/profile-behavior.test.sh`: `'version: 9.0.0'` → `'version: 10.0.0'`, and replace `'Is this an accurate description of your organization?'` with the open Identity sentence from [contracts/profile-wording.md](contracts/profile-wording.md). Leave the four `You can also change it or provide your own ...` assertions untouched.
- [X] T012 [P] Update `'version: 9.0.0'` → `'version: 10.0.0'` in `.highway/tools/tests/feature-138-visible-profile-structure.test.sh`.
- [X] T013 [P] Update `'version: 9.0.0'` → `'version: 10.0.0'` in `.highway/tools/tests/feature-137-profile-acquisition-expression-persistence.test.sh`.
- [X] T014 [P] Update `'version: 9.0.0'` → `'version: 10.0.0'` in `.highway/tools/tests/feature-136-profile-substantive-re-evaluation.test.sh`.
- [X] T015 [P] Update `'version: 9.0.0'` → `'version: 10.0.0'` in `.highway/tools/tests/feature-140-profile-convergence-alignment.test.sh`.
- [X] T016 [P] Update `version: 9.0.0` → `version: 10.0.0` in `.highway/tools/tests/feature-092-contract.test.sh`.
- [X] T017 [P] Update `'version: 9.0.0'` → `'version: 10.0.0'` in `.highway/tools/tests/profile-runtime-separation.test.sh`.
- [X] T018 [P] Update `'version: 9.0.0'` → `'version: 10.0.0'` in `.highway/tools/tests/profile-structure.test.sh`.
- [X] T019 Run the suite and record which tests fail and with what message. Expected: the five count-coupled tests fail naming 33 vs 49, and `profile-behavior` fails naming the removed Identity sentence. This is the D3.6 observation for T006–T011. Record it before continuing.

**Checkpoint**: version strings and count assertions are at their final values; the rules they describe do not yet exist.

---

## Phase 3: User Story 1 — Shape the substance before it is captured (P1) 🎯 MVP

**Goal**: A Contribution Opportunity is owed on a fact Highway cannot talk itself out of, has a shape that cannot be collapsed into a capture, and cannot become a ritual.

**Independent test**: Drive a Profile domain in which Highway interprets. Verify the person is given substance to change before any capture heading appears, and that approving it does not by itself permit convergence.

### Definitions and the two factual rules

- [X] T020 [US1] In `STD` `### Definitions`, amend **Contribution Opportunity** per [contracts/rule-inventory.md](contracts/rule-inventory.md): remove the `Highway materially shaped` clause and add the sentence stating its substance is not a candidate.
- [X] T021 [US1] In `STD` `### Definitions`, insert **Exploratory Move**, **Grounded Possibility**, and **Attribution** after **Contribution Opportunity**, using the exact text in the contract.
- [X] T022 [US1] In `STD`, replace the X2.37 row's Rule and Observable with the contracted text. Keep the row in place; do not renumber.
- [X] T023 [US1] In `STD`, replace the X2.41 row's Rule and Observable with the contracted factual condition.
- [X] T024 [US1] In `STD`, add row X2.42 carrying the previous X2.41 Rule and Observable verbatim, immediately after X2.41. Confirm X2.22 is left byte-unchanged — its reference to X2.41 reads correctly against the new condition (research §3).

### Shape rules

- [X] T025 [US1] In `STD`, add rows X2.43, X2.44, X2.45, X2.46 and X2.57 with the contracted Rule and Observable text.

### Prose

- [X] T026 [US1] In `STD`, replace the `## Contribution Opportunity` section body with the contracted paragraph. It must state the factual trigger, exclude approval and selection, name the short path explicitly, and keep the `anything else?` ritual prohibition.
- [X] T027 [US1] In `STD` `## Interaction Model`, replace step 9 with the contracted text. Leave steps 7, 8, 3 and 10 unchanged — `grounded reasoning materially improves it`, `Working Idea material`, and `acceptance boundary as approval of the representation` are asserted elsewhere.
- [X] T028 [US1] In `STD` `## Interaction Boundaries`, replace only the Compliant cell of the `Contribution Opportunity` row. The table must contain exactly five rows before and after; `feature-141` asserts this.
- [X] T029 [US1] In `PROF` `##### Identity`, delete the sentence beginning `When Profile materially assembles Identity from multiple sources`. Replace it with nothing. Leave the two preceding Identity sentences byte-identical.

### Tests

- [X] T030 [US1] In the new test, assert `| X2.42 |` through `| X2.46 |` and `| X2.57 |` are present, the new X2.37 and X2.41 Rule text is present, the superseded X2.37 and X2.41 text is absent, the three new definitions are present, `Development Turn` appears in neither document (FR-027), and the Identity permissive hook is absent from `PROF`.
- [X] T031 [US1] Add the retired-identifier assertion: none of X1.7, X2.2, X2.8, X2.14, X2.23, X2.25, X2.26, X2.27, X2.28, X2.33, X2.39, X2.40 appears as a rule row (FR-025).
- [X] T032 [US1] Run the probe from [contracts/test-impact.md](contracts/test-impact.md): copy `STD`, delete the `| X2.43 |` row, run the new test, confirm non-zero and that the message names the rule. Restore. Record the failing message.

**Checkpoint**: the convergence condition is factual, the opportunity has a shape, and the short path is preserved without an exemption clause.

---

## Phase 4: User Story 2 — Never face a blank strategic question (P2)

**Goal**: Vision, Competitive Path, and Guiding Principles each open with grounded possibilities, offered unprompted, distinguished from a choice set, and honestly absent when nothing supports them.

**Independent test**: Reach each of the three later domains and verify material to react to appears before the question, and that it is not framed as options to pick from.

- [X] T033 [US2] In `STD`, amend the X2.7 **Observable only** to add the marked-speculative clause. The Rule text is unchanged. Without this, X2.7 and X2.54 contradict (research §5).
- [X] T034 [US2] In `STD`, add rows X2.47 and X2.48 with the contracted Rule and Observable text.
- [X] T035 [US2] In `PROF`, add the contracted `Open that subject with grounded possibilities...` sentence to `##### Vision`, `##### Competitive Path`, and `##### Guiding Principles`, each immediately after its existing `When entering unresolved ...` sentence. Add nothing to `##### Identity` — Identity opportunities are conditional. Do not restate what a grounded possibility is; that is Standard-owned.
- [X] T036 [US2] In the new test, assert `| X2.47 |` and `| X2.48 |` are present, the three `Open that subject with grounded possibilities` sentences are present in `PROF`, and no such sentence appears in the Identity section.

**Checkpoint**: the three strategic domains no longer start from nothing.

---

## Phase 5: User Story 3 — Acceptance that requires a real answer (P3)

**Goal**: No acceptance request can be satisfied by agreeing; partial agreement is interrogated; confirmed content is never re-reviewed.

**Independent test**: Reach any materially interpreted capture and verify the request cannot be answered "yes", whether the default sentence or a sharper substitute is used.

- [X] T037 [US3] In `STD`, add rows X2.49, X2.50 and X2.51 with the contracted Rule and Observable text. X2.49 governs every acceptance request, including a substituted one, so FR-035 needs no separate rule. Leave X2.21 unchanged.
- [X] T038 [US3] In `PROF`, replace all four closed acceptance questions with the contracted open sentences. Retain each trailing `You can also change it or provide your own ...` line byte-identical, and retain the sentence frames `After convergence, validate with` and `Validate the Converged Proposal with`.
- [X] T039 [US3] In `PROF` `#### Domain completeness`, add the one contracted sentence permitting a sharper open question to replace the default. Do not restate the constraint that it cannot be answered by agreement alone — that is X2.49.
- [X] T040 [US3] In the new test, assert `| X2.49 |`, `| X2.50 |`, `| X2.51 |` are present; none of the four closed sentences remains in `PROF`; all four open sentences are present; and the four user-authored-alternative lines survive.

**Checkpoint**: saying "yes" is no longer a valid answer to a question about content the person did not write.

---

## Phase 6: User Story 4 — Know whose words these are (P4)

**Goal**: Introduced domain vocabulary and unstated claims are marked as Highway's at the point of use; ordinary paraphrase is not; unadopted terms stay out of the record.

**Independent test**: Run a conversation in which Highway introduces a term the person did not use. Verify it is attributed where it appears, that paraphrase carries no marking, and that the term does not enter the capture unless adopted.

- [X] T041 [US4] In `STD`, add rows X2.52, X2.53 and X2.54 with the contracted Rule and Observable text. X2.52 is deliberately one rule over two subjects; do not split it (research §6).
- [X] T042 [US4] In `STD` `## Constructive Advisory`, add the contracted attribution paragraph after the existing example pair. It must state the paraphrase exemption and that an unadopted term stays out of the record.
- [X] T043 [US4] In the new test, assert `| X2.52 |`, `| X2.53 |`, `| X2.54 |` are present and the Constructive Advisory paragraph is present.
- [X] T044 [US4] Run the suite. The rule count should now reach 49 and every count-coupled test should pass. Record the summary.

**Checkpoint**: the person can reject Highway's framing, not only its conclusion.

---

## Phase 7: User Story 5 — Review only what changed (P5)

**Goal**: An addition to accepted content preserves the accepted text byte-for-byte and shows only what changed.

**Independent test**: Accept a domain, then add one fact. Verify the accepted text is unchanged and the addition is visibly distinguished.

- [X] T045 [US5] In `STD`, add rows X2.55 and X2.56 with the contracted Rule and Observable text. Keep them as two rules — preserve and distinguish are two obligations (P1.2).
- [X] T046 [US5] In the new test, assert `| X2.55 |` and `| X2.56 |` are present.

**Checkpoint**: all 16 new rules are in place; the Standard contains 49 rule rows.

---

## Phase 8: Rule-shape enforcement

**Purpose**: Make FR-024 and FR-025 enforceable rather than asserted. These checks must be written after the rules exist so each can be seen failing against a real defect.

- [X] T047 In the new test, add the one-keyword check: for each of X2.42–X2.57, extract the Rule cell and assert it contains exactly one of `MUST`, `MUST NOT`, `SHOULD`. Count `MUST NOT` as one, and exclude the token `MUST-level`.
- [X] T048 In the new test, add the 25-word check: for each of X2.42–X2.57, assert the Rule cell is 25 words or fewer. Use `awk` field counting on the extracted cell; do not use `wc -w` on the whole row.
- [X] T049 Run the two shape probes from [contracts/test-impact.md](contracts/test-impact.md): copy `STD`, extend one new rule past 25 words, confirm non-zero and that the message names the rule; restore. Then add a second `MUST` to one new rule, confirm non-zero and that the message names the rule; restore. Record both failing messages — this is the D3.6 evidence for T047 and T048.
- [X] T050 In the new test, assert `PROF` contains zero occurrences of `MUST` and zero occurrences of `X2.41`. Run the probe: copy `PROF`, insert a `MUST` line, confirm non-zero; restore.

---

## Phase 9: Regeneration

- [X] T051 Run the adapter generator so `.github/skills/highway-profile/SKILL.md`, `.claude/skills/highway-profile/SKILL.md`, `.cursor/skills/highway-profile/SKILL.md`, and `.agents/skills/highway-profile/SKILL.md` match the amended source. Before running it, verify `generate-agent-adapters.sh` is uncorrupted — its `AGENT_TRANSFORMS` entry count must equal its `AGENT_IDS` count. A mismatch is residue from a killed run and must be repaired first.
- [X] T052 In the new test, assert all four adapters are byte-identical to `PROF` via `cmp -s`. Run the probe: append a byte to one adapter, confirm non-zero and that the message names the adapter; regenerate.
- [X] T053 Run `bash .highway/tools/tests/adapter-coverage.test.sh` and confirm no diff remains against the committed artifacts (D4.4, D4.7).

---

## Phase 10: Polish and Verification

- [X] T054 In `PROF` `## Verification`, add one line stating that each domain's validation question asks what is missing or wrong. Keep it a checkable outcome (P8.4); add no `MUST`.
- [X] T055 Verify P7.5 by counting words in each `PROF` normative section that changed. Each must be 400 or fewer.
- [X] T056 Verify the frozen-assertion list in [contracts/test-impact.md](contracts/test-impact.md) item by item: the five Interaction Boundaries rows, the surviving Interaction Model phrases, the absent tier tokens, the constitution's 73-rule count, `rule-checks.test.sh` on X2.4 and X2.13, and `coverage-summary.test.sh` on X2.5 and X2.6.
- [X] T057 Run `.highway/tools/tests/run-all.sh`. Expected `74 passed, 0 failed`, exit 0. This is the D3.2 observation. Record the summary line and exit code.
- [X] T058 Write `specs/150-collaborative-convergence/coverage.md` mapping each FR-001 through FR-038 to the artifact that satisfies it. Mark SC-001 through SC-007 human-decided and claimed by nothing. Keep this claim textually separate from the suite result (D7.3, D3.8).
- [ ] T059 Execute [quickstart.md](quickstart.md) Part 3, the short-path regression: a fresh `/highway-profile setup`, answered with a complete domain-ready paragraph. Confirm no exploratory turn is interposed. This is the single highest-risk outcome of the change and the plan's reasoning that it cannot fail is not a substitute for running it.
- [ ] T060 Execute [quickstart.md](quickstart.md) Part 2 against the `setup-model.md` stimulus sequence, save the transcript beside the nine baselines, and record the human judgement for SC-001 through SC-007. Report it as a separate claim from the suite result.

---

## Dependencies

```text
Phase 1 (T001-T003)  ─ baseline and scaffolding
        │
Phase 2 (T004-T019)  ─ versions and counts to final values; suite goes red (intended)
        │
        ├──► Phase 3  US1  (T020-T032)   definitions, X2.37/41/42/43/44/45/46/57, prose
        │          │
        │          ├──► Phase 4  US2  (T033-T036)   X2.7 obs, X2.47, X2.48, Profile openings
        │          ├──► Phase 5  US3  (T037-T040)   X2.49, X2.50, X2.51, Profile sentences
        │          ├──► Phase 6  US4  (T041-T044)   X2.52, X2.53, X2.54, advisory prose
        │          └──► Phase 7  US5  (T045-T046)   X2.55, X2.56
        │                     │
Phase 8 (T047-T050)  ◄────────┘  rule-shape checks; need the rules to exist
        │
Phase 9 (T051-T053)  ─ regenerate adapters; needs the final Profile text
        │
Phase 10 (T054-T060) ─ polish, suite green, coverage, human evidence
```

**US1 blocks the others** for one reason only: it installs the amended definitions that US2–US5 rules depend on. The rule rows themselves are independent.

**US2, US3, US4 and US5 do not block each other.** They add disjoint rule rows and touch disjoint Profile sections.

---

## Parallel execution

Phase 2 is where nearly all the parallelism is — thirteen test files, no shared state:

```text
T006 T007 T008 T009 T010 T011 T012 T013 T014 T015 T016 T017 T018
```

Within the story phases, the Standard edits are serial because they all touch one table in one file. Across stories, these pairs are parallel because they touch different files:

```text
T034 (STD rows)       ║  T035 (PROF domain sections)
T037 (STD rows)       ║  T038/T039 (PROF sentences)
T041 (STD rows)       ║  T054 (PROF Verification line)
```

The new test file is written by one task per story (T030, T036, T040, T043, T046) and those are **not** parallel — they append to the same file.

---

## Implementation Strategy

**MVP is Phase 1 + Phase 2 + Phase 3 (US1).** That delivers the change that actually caused the failure in the captures: convergence can no longer happen on a domain the person never contributed to, and the opportunity to contribute cannot be collapsed into a capture heading. Everything after it improves the conversation; US1 is what stops Highway persisting an identity the person never supplied.

**Deliver in story order after that.** US3 (open acceptance) is the second-most valuable, because it is the mechanism that failed most visibly — in `setup-copilot-luna-2.md` the person answered yes to an entirely wrong organizational identity. US2, US4 and US5 can land in any order.

**The suite is red from T005 to T044.** That is the design: moving the assertions first makes every subsequent rule addition a verified fix rather than an unverified claim. Do not "fix" the red by reverting an assertion.

**Two things the suite cannot tell you**, and which must not be reported as if it could (D3.8, D7.3):

1. Whether the conversation actually improved — T060, human-read.
2. Whether the amendment overcorrected into ceremony — T059, and the plan's argument that it cannot is not evidence.
