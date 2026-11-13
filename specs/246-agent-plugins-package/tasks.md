---

description: "Task list for the Agent Plugins Package (Phase 16)"
---

# Tasks: Agent Plugins Package

**Input**: Design documents from `specs/246-agent-plugins-package/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Required. FR-012 and Development Constitution D3.3, D3.4, D3.6, and D3.7 make tests part
of the work. Each test is observed failing before the code that makes it pass.

## Format: `[ID] [P?] [Story] Description`

## Phase 1: Setup

- [X] T001 Run the baseline `tests/run-all.sh` and `npm test` in `harness/` before the first edit (D3.1); record the totals in this file's Notes.
- [X] T002 [P] Add `specs/246-agent-plugins-package/harness/*` to `.gitignore`, beside the other spec harness rows.
- [X] T003 [P] Add `HW_PLUGIN` (`$HW_ROOT/highway-agent-plugin`) and `HW_PLUGIN_SOURCE` (`$HW_FRAMEWORK/plugin`) to `framework/lib/paths.sh`, and document them in its header.
- [X] T004 [P] Add `exclude	highway-agent-plugin	-` to `framework/.distribution-manifest`, under a comment saying Phase 18 publishes it.

## Phase 2: Foundational

- [X] T005 Create the plugin sources in `framework/plugin/`:
  - `plugin.json` with the fields in data-model.md;
  - `README.md`, saying what Highway is, how to install the plugin, and naming each of the 16 skills;
  - `LICENSE`, the canonical Apache 2.0 text (research R9).
- [X] T006 Amend `.specify/memory/constitution.md` from 3.5.0 to 3.6.0 (research R10):
  - the declared generators;
  - the `python3` note;
  - the D4.7 Enforcement Map note;
  - the version line and the date;
  - a Sync Impact Report with its D1.3, D1.4, and D5.3 review.

**Checkpoint**: the sources exist, and the toolchain and generator declarations allow the new scripts.

## Phase 3: User Story 1 - The repository builds the plugin from the source skills (P1)

**Goal**: `generate-agent-plugin.sh` builds the exact shipped set reproducibly.

**Independent Test**: build twice and diff, list the four entries, and compare each skill with its source.

- [X] T007 [US1] Write the build and shipped-set legs of `tests/agent-plugin.test.sh` (exact four entries, skills identical to `skills/`, two builds byte-identical, README names every skill, no `.specify/` or `specs/` string in the plugin, refusal of a folder it did not produce), and observe them fail with no generator present (D3.6).
- [X] T008 [US1] Implement build mode of `framework/generate-agent-plugin.sh` per contracts/generate-agent-plugin.md.
- [X] T009 [US1] Run `framework/generate-catalog.sh`, `framework/generate-agent-adapters.sh`, and `framework/generate-agent-plugin.sh` to create `highway-agent-plugin/`; confirm the T007 legs pass.

**Checkpoint**: `highway-agent-plugin/` exists, and SC-001 and SC-002 hold.

## Phase 4: User Story 2 - The suite guards the plugin (P1)

**Goal**: The validator, the drift check, and the seeded defects fail on what they should.

**Independent Test**: `bash tests/agent-plugin.test.sh` passes on the committed plugin, and each seeded copy fails, naming the defect.

- [X] T010 [US2] Add the validator and drift legs to `tests/agent-plugin.test.sh`. They check the committed plugin and seeded copies:
  - a missing `name`;
  - a wrong `$schema`;
  - an unknown field;
  - repeated keys;
  - non-JSON;
  - a bad `name`;
  - a symbolic link;
  - a skill folder without `SKILL.md`;
  - an invalid skill;
  - a stale skill file;
  - an extra top-level file;
  - an extra file inside a skill;
  - a missing file.

  Observe each leg fail first (D3.6).
- [X] T011 [P] [US2] Implement `framework/lib/plugin-manifest.sh` (python3 `json`, repeated keys rejected) per research R3 and R4.
- [X] T012 [US2] Implement `framework/validate-plugin.sh` per contracts/validate-plugin.md, using `lib/plugin-manifest.sh` and `framework/validate-skill.sh`.
- [X] T013 [US2] Implement `--check` in `framework/generate-agent-plugin.sh` per contracts/generate-agent-plugin.md.
- [X] T014 [US2] Record each check's verdict on the committed plugin and on each seeded copy in this file's Notes before wiring the test into the suite (D3.4); then confirm `bash tests/agent-plugin.test.sh` passes.
- [X] T015 [US2] Extend D4.7 in `tests/adapter-coverage.test.sh`:
  - its currency tree runs `generate-agent-plugin.sh`;
  - it diffs `highway-agent-plugin/` against the result;
  - its `source-document` probe still exits 1 seeded and 0 neutralised (D3.7).

**Checkpoint**: SC-003 holds.

## Phase 5: User Story 3 - The harness runs from the installed plugin (P2)

**Goal**: each attempt installs the committed plugin into its own Copilot home, and the harness refuses a stale plugin.

**Independent Test**: `npm test` in `harness/` passes. One live attempt's transcript opens with `installed plugin highway (16 skills)`.

- [X] T016 [P] [US3] Update `harness/bin/path-map.sh`:
  - `--location plugin` replaces `agent-skills`;
  - a path under `highway-agent-plugin/` selects nothing ("generated plugin; its source selects scenarios").

  Update `tests/harness-path-map.test.sh` if it names either.
- [X] T017 [US3] Rewrite the `harness/test/project.test.ts` assertions for `buildPlugin`:
  - the base project is empty;
  - the plugin is the repository's `highway-agent-plugin/` with 16 skills;
  - a stale check fails with the DRIFT lines.

  Record under D3.5 that the `.github/skills` copy assertion is superseded by FR-013. Observe the tests fail first.
- [X] T018 [P] [US3] Add `harness/test` cases:
  - `permissionPolicy` approves a read inside a read root;
  - it rejects a write there as a fatal outside-write;
  - `plugin-install` is a failure kind that is not an exit-2 kind.

  Observe them fail first.
- [X] T019 [US3] Implement `buildPlugin` in `harness/src/project.ts` and replace `buildSkills`. Widen `BuildResult` with `plugin`, and change `location()` to `"skills" | "framework" | "plugin"`.
- [X] T020 [US3] Implement the install, the enable, the `system` log entry, the `plugin-install` failure, and `readRoots` in `harness/src/driver.ts`. Add the kind and its likely cause to `harness/src/failure.ts`, and pass `plugin` from `harness/src/runner.ts` (`DriveOptions`, `RunnerDeps.build`).
- [X] T021 [US3] Run `npm test` and `npm run typecheck` in `harness/`; both pass.
- [X] T022 [US3] Update `harness/README.md`:
  - where the plugin comes from;
  - the install per attempt;
  - the stale-plugin refusal;
  - the reads allowed in `installed-plugins/`;
  - the deprecation notice;
  - `--location plugin`.

**Checkpoint**: the harness no longer reads `.github/skills/`.

## Phase 6: User Story 5 - Today's delivery keeps working (P3)

**Goal**: the adapters and the distribution are unchanged, and the plugin does not ship in the distribution.

**Independent Test**: the adapter and distribution tests pass, and `git status` shows no change under `.github/`, `.claude/`, `.cursor/`, or `.agents/`.

- [X] T023 [US5] Add a leg to `tests/agent-plugin.test.sh` asserting `dist_classify highway-agent-plugin` is `exclude`; confirm `tests/distribution-packaging.test.sh`, `tests/adapter-coverage.test.sh`, and `tests/generate-agent-adapters.test.sh` pass unchanged.
- [X] T024 [P] [US5] Document the generator and the validator in `framework/README.md` (with no `.specify/` or `specs/` path, since it ships), in the root `README.md`, and in `tests/README.md` (D6.1).

## Phase 7: User Story 4 - A smoke run from the installed plugin is recorded (P2)

**Goal**: after the full suite passes, the smoke set runs from the installed plugin, and each failure is recorded.

**Independent Test**: the transcripts are under the spec folder and ignored by git, and every failure is matched to a finding.

- [X] T025 [US4] Run `tests/run-all.sh` and `npm test` in `harness/`. Both must pass before the smoke run (FR-017, D3.2).
- [X] T026 [US4] Run `node harness/src/cli.ts --smoke --transcripts specs/246-agent-plugins-package/harness`, and confirm `git status --short specs/246-agent-plugins-package/harness` is empty.
- [X] T027 [US4] Classify each failing scenario per contracts/smoke-findings.md. Fix any load failure in this spec and repeat T025 and T026 (FR-021).
- [X] T028 [US4] Record each skill-behavior failure in `harness-model-findings.md`:
  - as a new F26-onward finding, or as a Runs line on a matching finding;
  - placed under Harness Failures when confirmed, or under Research Harness Failures when not;
  - with a Proposed resolution.

## Phase 8: Polish

- [X] T029 Update the Phase 16 row and add a Status paragraph in `standard-alignment.md` (FR-024): step 3 deferred, the model kept on GPT-5.6 Luna, and the deprecation notice.
- [X] T030 Run the final `tests/run-all.sh` and `npm test` (D3.2), and confirm that regenerating every declared generator leaves no diff (D4.7).
- [X] T031 Mark the tasks done and write the completion report, giving check results and requirement coverage separately (D7.3).

## Dependencies

- Setup (T001 to T004) comes first, then Foundational (T005, T006).
- US1 (T007 to T009) comes next, then US2 (T010 to T015), which needs the built plugin.
- US3 (T016 to T022) needs T013 (`--check`) and T009 (the plugin).
- US5 (T023, T024) needs US1.
- US4 (T025 to T028) needs everything above.
- Polish comes last.

## Parallel examples

- T002, T003, and T004 touch different files.
- T011 can be written while the T010 legs are drafted.
- T016 and T018 touch different harness files.
- T024 can run once T013 is final.

## Implementation strategy

US1 and US2 are the MVP, giving a committed, checked plugin. US3 proves it installs. US4 is the
evidence run. US5 guards today's delivery throughout.

## Notes

### Baseline (T001, D3.1)

Before the first edit, `tests/run-all.sh` passed 86 of 86 and `npm test` in `harness/` passed 94
of 94.

### Paths (T003)

`HW_PLUGIN_SKILLS` (`$HW_PLUGIN/skills`) joins `HW_PLUGIN` and `HW_PLUGIN_SOURCE`. D2.5 forbids
joining any variable to a literal `skills` segment, so the generator, the validator, and the
tests reach the plugin's skills folder through it.

### Check verdicts (T014, D3.4)

Each check's verdict on the committed plugin and on each seeded copy in
`tests/agent-plugin.test.sh`, observed before the test joined the suite. Every seeded copy fails
with the line shown, and the committed plugin passes every check.

| Seeded copy | Verdict | Finding |
| --- | --- | --- |
| Committed `highway-agent-plugin/` | pass | `OK: highway-agent-plugin (16 skill(s))`; `--check` exit 0 |
| No `name` | fail | `[MANIFEST] name: is required` |
| `$schema` names 9.9.9 | fail | `[MANIFEST] $schema: must be https://agent-plugins.org/schemas/1.0.0/plugin.schema.json` |
| Unknown field `homepageUrl` | fail | `[MANIFEST] homepageUrl: is not a manifest field` |
| Repeated `name` key | fail | `[MANIFEST] plugin.json: the key 'name' is repeated` |
| Not JSON | fail | `[MANIFEST] plugin.json: is not valid JSON: ...` |
| `name` is `Highway--Skills` | fail | `[MANIFEST] name: must be 1 to 64 characters ...` |
| `version` is a number | fail | `[MANIFEST] version: must be a string` |
| `author.nick` | fail | `[MANIFEST] author.nick: is not an author field` |
| `keywords` holds a number | fail | `[MANIFEST] keywords: must be a list of strings` |
| An extension that is not an object | fail | `[MANIFEST] extensions.com.example: must be an object` |
| No `plugin.json` | fail | `[MANIFEST] plugin.json: is missing from the plugin root` |
| `skills` is a file | fail | `[LAYOUT] skills: is not a folder` |
| `mcp.json` is a folder | fail | `[LAYOUT] mcp.json: is not a regular file` |
| A skill folder without `SKILL.md` | fail | `[LAYOUT] skills/empty-skill: has no SKILL.md` |
| An invalid skill | fail | `[SKILL] skills/highway-help: ...` |
| A symbolic link (by hand, see below) | fail | `[LAYOUT] skills/highway-help/link.md: is a symbolic link ...` |
| A skill source changed, no rebuild | `--check` fail | `DRIFT differs skills/highway-help/SKILL.md` |
| An extra top-level file | `--check` fail | `DRIFT extra NOTES.md` |
| An extra file inside a skill | `--check` fail | `DRIFT extra skills/highway-help/notes.md` |
| A missing file | `--check` fail | `DRIFT missing LICENSE` |
| No plugin folder | `--check` fail | `DRIFT missing .` |
| A folder the generator did not produce | build refuses | names `'highway-agent-plugin'`; the folder is unchanged |
| An invalid skill at build time | build refuses | the plugin is not written |

The Declared Toolchain has no utility that creates a link, so the test has no symbolic-link case.
The check was observed by hand with `ln -s` on a temporary copy, and the test header says so.

### D4.7 (T015, D3.6)

With a line appended to `highway-agent-plugin/skills/highway-help/SKILL.md` and an extra
top-level file, `tests/adapter-coverage.test.sh` failed with
`highway-agent-plugin/skills/highway-help is stale` and `highway-agent-plugin/ is stale`. After
regenerating, it passed. Its probes still behave: source-document and generated-artifact each
exit 1 seeded and 0 neutralised. The test writes `.claude/` and `.cursor/` in a temporary tree,
which the agent's sandbox blocks, so it was run outside the sandbox.

### Harness tests (T017, T018, D3.5, D3.6)

D3.5: the `project.test.ts` assertion that the base holds a `.github/skills/` copy of every skill
is superseded by FR-013. The base is now empty, and each attempt installs the plugin. The new
assertions are that the base is empty, the plugin is the repository's build with as many skills
as `skills/`, and a stale plugin stops the run with its DRIFT lines.

D3.6: `project.test.ts` and `runner.test.ts` failed the typecheck against the old code
(`buildPlugin` and `BuildResult.plugin` did not exist). The `driver.test.ts` cases were observed
failing by mutation: without the read-root clause the policy test fails, and with manifest
warnings ignored the install test fails. Each passes with the code restored. `npm test` now passes
102 of 102.

### Smoke runs (T025 to T028)

T025: the first full suite failed `shipped-tree-independence.test.sh`, because
`tests/agent-plugin.test.sh` held the development-path tokens as literals in its leak check. The
test now assembles them, and the suite passed 87 of 87 with `npm test` at 102 of 102.

T026 ran twice, with transcripts in `specs/246-agent-plugins-package/harness/` (gitignored). In
`20261113-141852Z-smoke-be6a1d0`, 15 passed, 3 were flaky, and 1 failed. All 40 attempts across
both runs installed the plugin with 16 skills and no warnings, and loaded skills with
`source: plugin`, so there was no load failure (FR-021). The first run showed a stale harness
message: a rejected read said reads outside the project were unavailable, though the installed
plugin is readable. In setup-smoke, that led Luna to ask for `cat`. The message now names the
installed plugin, `driver.test.ts` asserts it, and T025 and T026 were repeated. In
`20261113-142757Z-smoke-be6a1d0`, 13 passed, 1 was flaky, and 3 failed, and no attempt turned to
the shell.

T027 and T028: each failure is a skill-behavior, scenario, harness-check, or model case, recorded
in `harness-model-findings.md` with a Runs line per run. The section "Plugin install smoke for
spec 246" maps scenarios to findings: F1, F18, F20, and F25 recur, and F26 (onboarding skips the
Profile), F27 (experience-order), and F28 (`contains-any` matches case-sensitively) are new.
No skill changed (FR-023).
