---

description: "Task list for Agent Manifests (rollout Phase 6)"
---

# Tasks: Agent Manifests

**Input**: Design documents from `specs/248-agent-manifests/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Required. FR-016 and Development Constitution D3.3 to D3.6 make tests part of the work.
Each new case is observed failing before the code that makes it pass. Each changed assertion
names what it supersedes.

## Format: `[ID] [P?] [Story] Description`

## Phase 1: Setup

- [X] T001 Run the baseline `bash tests/run-all.sh` before the first code edit (D3.1); record the totals in Notes.
- [X] T002 Ask the user to review the listing text and keywords drafted in research R11 before they are written.

## Phase 2: Foundational (blocks every story)

- [X] T003 Record the D3.4 placement verdicts in Notes: the verdict of each new validator and listing check on the committed plugin and on each existing seeded case in `tests/agent-plugin.test.sh`, before the checks are wired in.

**Checkpoint**: verdicts recorded; tests can be written.

## Phase 3: User Story 1 - One source renders every manifest (P1)

**Goal**: the five agent manifests and the logo are built from `framework/plugin/`.

**Independent test**: `bash tests/agent-plugin.test.sh` shipped-set, shared-field, and one-source cases.

- [X] T004 [US1] In `tests/agent-plugin.test.sh`, replace the shipped-set assertion with the new closed list (superseded: `LICENSE README.md plugin.json skills`), extend the copy check to `assets/logo.svg`, add a check that each manifest's shared fields equal the source (read with `python3` through the library, not in the test), and add the one-source case: a changed description in a copy's source reaches all six manifests and no other file. Run it and record the failures (D3.6).
- [X] T005 [US1] Update `framework/plugin/plugin.json`: add `author` and `keywords`, change `homepage` (data-model.md).
- [X] T006 [P] [US1] Create `framework/plugin/listing.json` with the reviewed text (contracts/manifests.md).
- [X] T007 [P] [US1] Create the placeholder `framework/plugin/assets/logo.svg` (research R8).
- [X] T008 [US1] Add the format table, `pm_render`, and `pm_listing_check` to `framework/lib/plugin-manifest.sh`, and update its header for the wider `python3` use.
- [X] T009 [US1] In `framework/generate-agent-plugin.sh`, run the listing check before writing in both modes, copy `assets/`, and render the manifests in `build_into`; update the header comment.
- [X] T010 [US1] Rebuild `highway-agent-plugin/` with `framework/generate-agent-plugin.sh`, then confirm `--check` is clean and two builds are byte-identical.

## Phase 4: User Story 2 - The suite stops drift (P1)

**Goal**: the drift check, listing check, and validator name each defect.

**Independent test**: the seeded cases in `bash tests/agent-plugin.test.sh`.

- [X] T011 [US2] In `tests/agent-plugin.test.sh`, add the seeded cases from contracts/checks.md: a hand-edited manifest drifts; a shared field and a derived field in the listing file each stop the build with nothing written; a missing manifest, a missing required field, a differing shared field, a wrong skills path, a missing logo, a forbidden key, an unlisted top-level file, an extra file in an agent folder, and an unnamed asset each fail validation. Change the `author` and `keywords` seeds to edit the existing fields (D3.5). Run it and record the failures (D3.6).
- [X] T012 [US2] Add `pm_check_agents` (manifests and closed list) to `framework/lib/plugin-manifest.sh`.
- [X] T013 [US2] Call it from `framework/validate-plugin.sh`, between the `[MANIFEST]` and `[SKILL]` findings; update the header comment.
- [X] T014 [US2] Run `bash tests/agent-plugin.test.sh` until it passes; record the D3.4 verdicts after.

## Phase 5: User Story 3 - Copilot still installs Highway (P2)

**Goal**: the harness installs `highway` with 16 skills from the root manifest.

**Independent test**: the smoke run's log.

- [X] T015 [US3] Run `npm --prefix harness test` and `npm --prefix harness run typecheck` (the harness's stale-plugin check runs `--check`).

The smoke run itself is T022, after the final suite.

## Phase 6: User Story 4 - Docs and governance (P3)

- [X] T016 [P] [US4] Update `framework/README.md`: the generator and validator sections name the source, the listing file, the logo, the six manifests, where each field comes from, and how to change a field or the version.
- [X] T017 [P] [US4] Update the plugin line in `README.md` and the agent-plugin paragraph in `tests/README.md`.
- [X] T018 [P] [US4] Amend `.specify/memory/constitution.md` to 3.7.0 with a Sync Impact Report: the `python3` note names rendering the manifests, and the D4.7 Enforcement Map note and the declared generators paragraph name the manifest set (D5.3).

## Phase 7: Polish and the live check

- [X] T019 Confirm the distribution and the per-agent skill copies are unchanged: `bash tests/distribution-packaging.test.sh` and `bash tests/adapter-coverage.test.sh` pass (SC-007), and `git status` shows no change under `.github/`, `.claude/`, `.cursor/`, `.agents/`, or `skills/`.
- [X] T020 Run the final `bash tests/run-all.sh` (D3.2) and record the totals.
- [X] T021 Run the final `npm --prefix harness test` and typecheck; record the totals.
- [X] T022 [US3] Run `node harness/src/cli.ts --agent copilot --smoke` with standard output to `specs/248-agent-manifests/harness/smoke.log`; confirm every attempt installed `highway (16 skills)`, the log is under 100 KB, and it holds no token, temporary path, or escape character.
- [X] T023 [US3] Match each smoke failure to `harness-model-findings.md` (Runs lines or a new finding); an install or load failure blocks completion.
- [X] T024 Mark Phase 6 complete in `rollout-plan.md` with a Status paragraph.
- [X] T025 Narrow the Highway root folder match in `tests/self-contained-skills.test.sh` to a path segment, so the `https://www.highway.systems` host name is not reported, with a probe for it (found by T020).

## Dependencies

T001 and T002 first. T003 before T004 and T011. US1 (T004 to T010) before US2 (T011 to T014),
since the validator checks the built manifests. T015 after T010. US4 after US2. T019 to T024 in
order, last; T025 came out of T020 and was followed by a second T020 run.

## Parallel examples

- T006 and T007 (different new files).
- T016, T017, and T018 (different documents).

## Implementation strategy

MVP is US1: the manifests built from one source. US2 makes them safe to keep. US3 and US4 close
the phase.

## Notes

**T001 baseline (D3.1)**: `bash tests/run-all.sh` before the first code edit: 87 passed, 0 failed.

**T002 listing review**: the user approved the listing text and keywords in research R11 as drafted.

**T003 placement verdicts before (D3.4)**: the new checks, run from a scratch copy of the program
against the committed plugin before they were wired in:

- the validator's agent check: FAIL, naming each of the five manifests as missing (expected: the
  plugin had not been rebuilt);
- the generator's listing check: FAIL, `listing.json: is missing` (expected: not yet written);
- each of the 19 existing seeded validator cases in `tests/agent-plugin.test.sh` copies the
  committed plugin, so under the new checks each also gains the five missing-manifest findings.
  Its verdict stays FAIL, and its own pattern still matches.

**T004 and T011 observed failing (D3.6)**: the updated `tests/agent-plugin.test.sh`, run before any
implementation, failed on each new case, including:

- `highway-agent-plugin/ holds 'LICENSE README.md plugin.json skills '`;
- `a changed description changed 'plugin.json '; expected exactly the six manifests`;
- `the generator built the plugin with a shared field in the listing file` and the derived-field
  case, each also with `--check passed`;
- `--check passed with a hand-edited manifest`;
- `validate-plugin.sh passed a plugin with` each of the 11 new seeded defects: a missing agent
  manifest, a missing required field, a differing shared field, a differing derived field, a
  skills path that leads nowhere, a missing logo, `hooks`, `contextFileName`, an unlisted file, an
  extra file in an agent folder, and an unnamed asset;
- the rewritten `author` and `keywords` seeds, which edit fields the root did not yet hold.

**Superseded assertions (D3.5)**:

- The shipped-set assertion `LICENSE README.md plugin.json skills` is replaced by the closed list
  with the five agent manifests and `assets` (FR-007, FR-014).
- The `author` and `keywords` seeds inserted a second key at the top of `plugin.json`. Now that the
  root holds both fields, that would be reported as a repeated key, not as the defect the case
  names. They now edit the existing values; each pattern is unchanged.
- No assertion was removed.

**T014 placement verdicts after (D3.4)**: the committed plugin passes `validate-plugin.sh` and
`--check`. Every existing seeded case still fails with its own pattern. Cases that touch the root
manifest also report the affected shared fields under `[AGENT]` where the root still parses, and
the `mcp-folder` case also reports `mcp.json` as outside the shipped set. `tests/agent-plugin.test.sh`:
`OK: agent-plugin`.

**T010 rebuild**: `framework/generate-agent-plugin.sh` wrote 16 skills; `--check` exit 0; two
consecutive builds `diff -r` identical.

**T015 harness**: `npm --prefix harness test` 147 passed, 0 failed; typecheck clean.

**T020 first final run**: 86 passed, 1 failed. `self-contained-skills.test.sh` reported
`framework/plugin/plugin.json:8` and `:10`, the new `https://www.highway.systems` URLs, because
it matched the Highway root folder name as a bare substring, which the host name contains. The
check now matches the folder name only where it starts a path segment (not after a letter, digit,
or underscore), and a new probe requires a host name holding the folder name not to be reported.
That failing run is the D3.6 observation for the probe. D3.5: the superseded behavior is that any
occurrence of the substring was reported. Under the old pattern, the live tree had no match
before this spec, so no earlier detection is lost, and the existing `folder token` and `live file`
probes still pass.

**T019 unchanged copies (SC-007)**: `git status` shows no change under `.github/`, `.claude/`,
`.cursor/`, `.agents/`, or `skills/`; `distribution-packaging.test.sh` and
`adapter-coverage.test.sh` pass in the final suite.

**T020 final run (D3.2)**: after T025, `bash tests/run-all.sh`: 87 passed, 0 failed.

**T021 harness**: `npm --prefix harness test` 147 passed, 0 failed; typecheck clean.

**T022 smoke run**: `20261114-203043Z-smoke-557dddb`, exit 1. 14 of 16 passed (1 flaky), 2 failed,
0 blocked. All 19 attempts printed `system: installed plugin highway (16 skills)`. The log is
63,331 bytes with no token, temporary path, or escape character.

**T023 findings**: discovery-smoke (both attempts) and onboarding-smoke attempt 1 match F18;
onboarding-smoke attempt 2 matches F25; setup-smoke attempt 1 and 5 rejected reads in passing
attempts match F20. No install or load failure. Runs lines and a run section were added to
`harness-model-findings.md`.
