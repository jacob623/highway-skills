# Tasks: Standard Alignment Progressive Disclosure

**Input**: design documents in `specs/242-standard-alignment-progressive-disclosure/`
(plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md).

**Tests**: requested by the spec: US4 is the boundary test, and US3 requires seeded validator and
inventory cases (D3.6).

**Order note**: the story phases run US4, US3, US1, US2, US5, not in priority order.
- The boundary test must report today's verdicts before any skill changes (D3.4).
- The validator and the inventory must read flow files before the first split, or moved text
  would go ungoverned and `covers:` hashes would stop resolving.

## Format: `[ID] [P?] [Story] Description`

## Phase 1: Setup

- [X] T001 Run the baseline suite `bash tests/run-all.sh` (needs "all" permission, about 7 minutes) and record the pass and fail counts in the Notes section of specs/242-standard-alignment-progressive-disclosure/tasks.md (D3.1)
- [X] T002 Run the harness unit tests and type check (`cd harness && node --test "test/*.test.ts"`, `npm --prefix harness run typecheck`), recording results in the Notes section of specs/242-standard-alignment-progressive-disclosure/tasks.md
- [X] T003 Save the inventory baseline: `harness/bin/inventory.sh > specs/242-standard-alignment-progressive-disclosure/baseline-inventory.tsv`. The 12 originals are `git show HEAD:skills/<id>/SKILL.md`, since `skills/` is clean at HEAD.

## Phase 2: Foundational (blocks every story)

- [X] T004 Confirm the Copilot model id for GPT-5.6 Luna through `client.listModels()` (needs a token in harness/.env) and set `"model"` in harness/harness.config.json (R8)
- [X] T005 GATE: run `node harness/src/cli.ts --smoke --transcripts specs/242-standard-alignment-progressive-disclosure/harness/pre-smoke`. If it fails or cannot start, STOP and ask the person before any change under skills/ (Q2, contracts/live-harness-evidence.md).
- [X] T006 Create framework/lib/flows.sh with `fl_table`, `fl_files`, `fl_steps`, and `fl_skill_text` (R1, R2, R3). Bash 3.2, Declared Toolchain only, fenced blocks skipped.

## Phase 3: User Story 4 — The boundary test (Priority: P2)

**Goal**: one test checks boundaries 1 to 12 on every skill.

**Independent test**: before the split, the output matches the baseline in data-model.md; the probe reports each seeded boundary; the neutralised run passes.

- [X] T007 [US4] Write tests/skill-flow-pattern.test.sh per contracts/boundary-test.md, sourcing framework/lib/flows.sh, with the probe header, `--probe source-document`, and `--neutralise`
- [X] T008 [US4] Run tests/skill-flow-pattern.test.sh on today's skills. Compare its output to the "Validation baseline (D3.4)" table in specs/242-standard-alignment-progressive-disclosure/data-model.md and record the actual verdicts in Notes. Resolve any difference before continuing.

## Phase 4: User Story 3 — Moved text stays governed (Priority: P1)

**Goal**: the validator, the harness inventory, and the tests read flow files.

**Independent test**:
- a seeded P2.6 breach in a flow file fails the validator, and the same text in a plain reference passes;
- the inventory lists a fixture flow file's steps and bullets with unchanged ids.

- [X] T009 [US3] Add `rc_flow_exempt_ids` (prints `P7.1 P7.2 P8.7`) to framework/lib/rule-checks.sh
- [X] T010 [US3] In framework/validate-skill.sh, judge each file `fl_files` names as kind `flow` with `rc_flow_exempt_ids`, leaving other references as kind `reference` (contracts/validator-flow-kind.md)
- [X] T011 [US3] Add a fixture skill with a flows table under tests/fixtures/flow-skill/ and add the flow-kind cases to tests/bundled-files.test.sh, which already judges references: P2.6 seeded in a flow file fails; the same text in a non-flow reference passes; no Purpose or version in a flow file passes
- [X] T012 [US3] In harness/bin/inventory.sh, after SKILL.md, read each flow file from `fl_files` in table order: steps are `### ` outside fences, and bullets come from `## Verification` (R5)
- [X] T013 [US3] Add an inventory case for the fixture's flow file to tests/harness-coverage.test.sh: its steps and bullets are listed, and a bullet's id equals the id it had in SKILL.md

## Phase 5: User Story 1 — The model reads each flow (Priority: P1) 🎯 MVP

**Goal**: the twelve skills split per the split map in data-model.md, with no wording change.

**Independent test**: for each skill:
- the boundary test passes;
- the validator passes;
- the moved text joins back to HEAD's text (SC-002);
- the inventory equals the baseline, apart from row order.

For each split task:
1. Cut the named `### ` steps into the flow files under a title-case L1, in original order.
2. Move each rule that only that flow applies.
3. Move each Verification bullet whose steps all sit in one flow file. A bullet spanning files stays (R11); record the assignment in Notes.
4. Add the flows sentence and table to the Procedure introduction.
5. Take a MINOR version bump in the frontmatter and in the Example.
6. Check the join against `git show HEAD:skills/<id>/SKILL.md`.

- [X] T014 [P] [US1] Split skills/highway-codify/SKILL.md into references/catalog.md, suggest.md, proposal.md, record.md, plan.md, code.md. `code tasks` items 10 and 11 go to code.md; step 3 of `index` stays in SKILL.md (Q1).
- [X] T015 [P] [US1] Split skills/highway-implementation/SKILL.md into references/proposal.md, record.md, amend.md
- [X] T016 [P] [US1] Split skills/highway-adr/SKILL.md into references/proposal.md (with the evidence reading order) and record.md
- [X] T017 [P] [US1] Split skills/highway-codify-config/SKILL.md into references/platforms.md, standards.md, conflicts.md. `current`, `entry level`, `use entries`, and `platform entries` stay.
- [X] T018 [P] [US1] Split skills/highway-discovery/SKILL.md into references/analysis.md (with the evidence loading order), record.md, explore.md. The redaction rule stays.
- [X] T019 [P] [US1] Split skills/highway-nfrs/SKILL.md into references/proposal.md and record.md
- [X] T020 [P] [US1] Split skills/highway-controls/SKILL.md into references/proposal.md and record.md
- [X] T021 [P] [US1] Split skills/highway-objectives/SKILL.md into references/proposal.md and record.md
- [X] T022 [P] [US1] Split skills/highway-onboarding/SKILL.md into references/proposal.md and orchestrate.md. The queue rules stay.
- [X] T023 [P] [US1] Split skills/highway-architecture/SKILL.md into references/proposal.md and record.md
- [X] T024 [P] [US1] Split skills/highway-assessment/SKILL.md into references/findings.md (with the category and trace-chain rules) and ready-records.md. The catalog-first rule stays.
- [X] T025 [P] [US1] Split skills/highway-request/SKILL.md into references/proposal.md (with the seven-domain order) and record.md. The secrets exclusion stays.
- [X] T026 [US1] Run tests/skill-flow-pattern.test.sh and framework/validate-skill.sh on all 16 skills, and compare `harness/bin/inventory.sh` to specs/242-standard-alignment-progressive-disclosure/baseline-inventory.tsv (same rows, sorted)
- [X] T027 [US1] Run the suite and fix each test that pinned moved text: read it through `fl_skill_text`, or from the flow file now holding it, removing or loosening no assertion (R6, D3.5) in tests/*.test.sh
- [X] T028 [US1] Regenerate the catalog and the agent trees (`framework/generate-catalog.sh`, `framework/generate-agent-adapters.sh`), updating skills/highway-help/assets/index.json, framework/.adapter-manifest, and .github/ .claude/ .cursor/ .agents/

## Phase 6: User Story 2 — The size ceiling (Priority: P1)

**Goal**: every SKILL.md and every flow file is at most 500 lines and 20,000 characters.

**Independent test**: quickstart.md step 4 shows no file over either limit.

- [X] T029 [US2] Measure every skills/*/SKILL.md and skills/*/references/*.md that is a flow file. If skills/highway-codify/SKILL.md is over 20,000 characters, move further Verification bullets per Phase 13 and record which ones in Notes.

## Phase 7: User Story 5 — The authoring standard (Priority: P3)

**Goal**: the live documentation describes the router, flow files, and limits (D6.1).

**Independent test**: the authoring standard states every boundary that the test checks.

- [X] T030 [P] [US5] Add the router, flow file, flows table, and the 500-line and 20,000-character limits to framework/authoring-standard.md
- [X] T031 [P] [US5] Update harness/README.md: the inventory reads flow files, and the smoke count matches harness/scenarios
- [X] T032 [P] [US5] Mark Phase 14 done in standard-alignment.md (phase table status and exit criteria)

## Phase 8: Polish and live evidence

- [X] T033 Regenerate a second time and confirm nothing changes (D4.6, FR-015). Run `framework/generate-distribution.sh` into a temporary folder and confirm no unclassified path, with rollout-plan.md excluded.
- [X] T034 Run the full suite `bash tests/run-all.sh` and the harness unit tests and type check; all pass (D3.2)
- [X] T035 Live post-smoke run: `node harness/src/cli.ts --smoke --transcripts specs/242-standard-alignment-progressive-disclosure/harness/post-smoke`. Compare it scenario by scenario with baseline `20261112-162017Z-smoke-49ab958` per contracts/live-harness-evidence.md ("No worse than the baseline"), and record each verdict in Notes.
- [X] T036 Live affected run (Option B): `node harness/src/cli.ts --changed-since main`. Each scenario passes, or each failing attempt shows a finding F1 to F10 from harness-model-findings.md; record each verdict in Notes.
- [X] T037 Search specs/242-standard-alignment-progressive-disclosure/harness/ for the token value and find nothing; mark every task done in specs/242-standard-alignment-progressive-disclosure/tasks.md

## Dependencies

- Setup (T001–T003), then Foundational (T004–T006). T005 is a hard gate on every task that changes skills/.
- US4 (T007–T008) needs T006.
- US3 (T009–T013) needs T006.
- US1 (T014–T028) needs US4 and US3.
- US2 (T029) needs US1.
- US5 (T030–T032) can follow US3.
- Polish needs everything.

## Parallel opportunities

- T014–T025 touch disjoint skill folders.
- T030–T032 touch disjoint documents.
- T009 and T012 touch different files.

## Implementation strategy

The MVP is US4, then US3, then the US1 split of one skill (highway-request, T025), checked end to end before the other eleven.

## Notes

- T001 (2026-11-12): the baseline `tests/run-all.sh` has 84 passed, 0 failed.
- T002: the harness unit tests have 82 passed, 0 failed; the type check is clean.
- T003: `baseline-inventory.tsv` has 608 rows: 178 step, 350 verification, 80 error.
- T004: `listModels()` lists `gpt-5.6-luna` as "GPT-5.6 Luna", and `harness/harness.config.json`
  uses it.
- T005, first attempt: ended `missing-token`, because there was no `harness/.env`. The person
  created it.
- T005, second attempt (FAILED, gate): run `20261112-162017Z-smoke-49ab958`, transcripts under
  `harness/pre-smoke/`. 6 passed (3 of them flaky) and 10 failed. The run made 314 model calls.
  The token value appears in no transcript.
  - unmatched-question (adr, codify-config, discovery, nfrs, onboarding, profile): the model asks
    a question the scenario has no keyed reply for, often re-asking the question just answered.
  - assertion (implementation, setup): an expected file was not written.
  - controls and objectives: an assertion on attempt 1, then a Copilot service error (`-32603`) on
    attempt 2.

  No skill had changed, so these are the model's behavior on today's skills. Implementation
  stopped before any change under `skills/`, per Q2.
- T005 decision (2026-11-12): the person made this run the baseline. Its failures are recorded as
  F1 to F10 in `harness-model-findings.md` at the repository root. That file is excluded in
  `framework/.distribution-manifest`. The rule from here on is "no worse" (spec Clarifications,
  contracts/live-harness-evidence.md).
- While the run was in flight, only tooling that no skill reads and the harness does not use was
  built: T006 to T011. `tests/skill-flow-pattern.test.sh` on today's skills matches the D3.4
  baseline exactly: boundary 1 fails 8 skills, and every other boundary passes everywhere. The
  probe reports all 11 seeded breaches one for one, and the neutralised run passes.
  `tests/bundled-files.test.sh` passes with the flow-kind cases.
- T012, T013: the inventory reads each flow file after `SKILL.md`. On today's skills its output
  matched `baseline-inventory.tsv` before the split. The fixture's flow steps and bullets are
  listed, and a bullet keeps its id.
- Split rule (T014 to T025): rule steps stay in `SKILL.md`, and stage steps move with their flow.
  - A rule step exists only to be followed or applied ("follow", "from", "as X does"). No step
    reaches it by "go to". When steps in more than one file apply it, it stays in `SKILL.md`, as
    data-model.md allows.
  - A stage step is reached by "go to". It moves with its flow, even when another step borrows a
    detail from it ("as `write` does", "From `folder`").
  - highway-implementation: `execution`, `field`, `why it matters`, and `capability title` are
    applied by steps in `proposal.md`, `record.md`, and `amend.md`, so they stay in `SKILL.md`.
    `proposal.md` holds only `start`. Phase 13 had placed them in `proposal.md`.
  - highway-codify-config: `conflicts` moves to `conflicts.md`.
- highway-codify edits beyond the verbatim move, as Phase 14 step 2 directs:
  - Step 3 of `index` becomes "The Features rule" in the Procedure introduction. `index` item 3
    reads "Apply the Features rule to this feature's entry.", and `code` says "apply the Features
    rule" in place of "apply step 3 of `index`".
  - `code tasks` items 10 and 11 open `code.md` as two bullets under "For a code project, these
    rules apply in this flow:". The `code` and `close` lines that named `code tasks` for them now
    name "the code project rules at the start of this flow".
- Verification bullets: a bullet moves when every step it checks is in that flow file. A bullet
  spanning files stays in `SKILL.md`, for example the "written once" and "Written records match"
  bullets of the nfrs, controls, and objectives skills, and codify's Features-entry bullet, which
  checks the Features rule.
- Every split passed a line-multiset check: the non-blank lines before equal the lines after,
  less the added titles, the flows table, and the `## Verification` headings. The codify edits
  above were made before the check.
- Sizes after the split (T029): every `SKILL.md` and flow file is within 500 lines and 20,000
  characters. The largest are codify `references/proposal.md` (250 lines, 18,304 characters) and
  implementation `SKILL.md` (15,543 characters). No further move was needed.
- T026: `skill-flow-pattern.test.sh` passes. `validate-skill.sh --no-cache` passes all 16 skills
  and the fixture. The inventory equals `baseline-inventory.tsv` row for row (608 rows), so every
  `covers:` hash still resolves.
- T027: 46 tests pinned moved text. `fl_skill_text_file` in `framework/lib/flows.sh` writes a
  skill's `fl_skill_text` to a file named by its hash. Each test reads the skill through it in
  place of `SKILL.md`, with no assertion removed. Five tests needed more:
  - `code-project` and `codify-products` pin the codify edits above where they now live.
  - `propose-edit-lines` ends `revise` at the flow file's `## Verification`.
  - `standard-starting-point` orders codify-config's steps as the router and its flows now hold
    them.
  - `configure-handoff` orders `lineage` before `configure` in `orchestrate.md`, and finds
    `summary` in `SKILL.md`.
  - `storage-contract` also runs P2.6 on every flow file.
- Sandbox caveat: in the sandbox, `xargs` fails ("sysconf(_SC_ARG_MAX) failed"). The validation
  cache then computes one key for every skill and replays one verdict for all. Validate with
  `--no-cache` in the sandbox. `vc_key` does not yet disable the cache when hashing fails.
- T033, T034: done. The packaging crash came from forking once or more per distributed file.
  `generate-distribution.sh` now batches that work: one `find -exec` hash pass for the record and
  the drift check, one `find -exec awk` link scan, and `dist_destination_many` in
  `framework/lib/distribution.sh` for destinations; `dist_destination` and `dist_files` are gone.
  The batch destinations match the single-path form on all 305 included paths, and each record
  hash matches an independent hash. The adapter generator does not drop manifest rows for
  deleted files, so the 20 rows for the merged flow files were removed from
  `framework/.adapter-manifest` by hand. `self-contained-skills.test.sh` now skips
  `harness/runs/`, the gitignored run output, which it had scanned as live files. The suite has
  85 passed and 0 failed; the harness unit tests pass 82 of 82; the type check passes. A second
  generation changes nothing. `rollout-plan.md` stays gitignored and excluded in the manifest.
- T035: post-smoke run `20261112-170628Z-smoke-49ab958`, transcripts under
  `harness/post-smoke/`. 6 passed and 10 failed, the same six passing as the baseline, now with
  none flaky. The verdicts, per scenario, are in the "Post-change run for spec 242" section of
  `harness-model-findings.md`.
  - Fourteen scenarios: no worse.
  - implementation-smoke: the kind changed from assertion to unmatched-question. The cause is F1
    and F3, at `choose`, which is unchanged in `SKILL.md`.
  - nfrs-smoke attempt 1: fails by F10. It also shows `experience-order`, a kind no baseline
    attempt shows. Recorded as F11: the model read highway-experience's `SKILL.md` with `view`
    instead of invoking the skill. The activation line is unchanged. This is the one result
    outside "no worse" as written, and the person decides. Decision: accepted as model
    behavior; nfrs-smoke counts as no worse.
  - The token value appears in no transcript under `harness/`.
- T036: affected run `20261112-171321Z-targeted-49ab958` (`--changed-since main`, 50
  scenarios). 33 passed (7 flaky) and 17 failed. The per-scenario table is in the "Affected run
  for spec 242 (Option B)" section of `harness-model-findings.md`.
  - Every failing attempt but one shows a finding: F1 to F10, F11, F12 (shell commands), or F13
    (an exact message without its bold).
  - codify-plan-review attempt 1 is S1, caused by the split. `index` in `references/record.md`
    hands off to `plan` in the same turn. The model never opened `references/plan.md`, skipped
    `check` and the menu, and closed. A handoff that crosses files between turns works in every
    transcript.
  - S1 needs a decision before Phase 14 can be marked done (T032).
- S1 fix (decision: keep handoffs within one turn inside one flow file):
  - Boundary 12, with seed 12, checks that a flow file handoff outside a reply line names a step
    in that file or in `SKILL.md`. The fixture's accept lines became reply lines. The authoring
    standard, standard-alignment.md, the contract, and the spec state it.
  - The audit of the 12 split skills found five breaches, in codify and discovery only.
  - codify: `plan.md` merged into `record.md` (164 lines). `suggest.md`'s steps went back into
    `SKILL.md` (253 lines, 19,244 characters), since it and `proposal.md` hand off to each other
    and together exceed 20,000 characters.
  - discovery: `analysis.md`, `record.md`, and `explore.md` merged into `options.md` (227 lines).
  - The moves are verbatim; the line multiset of each skill against HEAD changes only in the
    table and the known codify edits. Versions stay 14.7.0 and 5.6.0, one minor bump over HEAD.
  - 27 flow files. The inventory has the same 608 rows in a new order. The boundary test, the
    validator with `--no-cache`, and the 39 tests that read either skill or the fixture pass.
  - Regenerated twice with no change. The generator leaves deleted flow files in the agent trees;
    the five stale copies in each tree were removed.
- S1 rerun: two targeted runs of highway-codify and highway-discovery on `gpt-5.6-luna`, under
  `harness/s1-rerun/` (26 passed and 4 failed, then 25 passed and 5 failed). codify-plan-review
  passes in both. No scenario that passed in Option B fails both runs; each one-run failure is
  F6, F11, F14, or F15, at a step this fix did not change. The "Rerun after the S1 fix" section
  of `harness-model-findings.md` has the table. The token value appears in neither run.
- Packaging diagnosis (`bash -x`, temporary folder): forks begin failing partway through the
  cross-reference loop, at file 251 of 317, after about 2,700 forks from one bash process.
  `$(dirname …)` returns empty, every `awk` returns nothing ("0 cross-references"), `mktemp`
  fails, and `rm -rf` segfaults. The logic is sound; the fork count grew with 124 flow file
  copies.
- T032: Phase 14 is marked complete. Its harness exit is met as "no worse than the baseline":
  the remaining failures are model, scenario, or service findings in `harness-model-findings.md`.
- T037: the token value appears in no file under `specs/242-standard-alignment-progressive-disclosure/harness/`.
