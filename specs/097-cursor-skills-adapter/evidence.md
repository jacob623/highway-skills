# Evidence: Cursor Skills Adapter (feature 097)

Recorded during `/speckit-implement`. Check results and requirement coverage are kept separate
(D7.3); coverage is in the final section.

## Baseline (D3.1)

| Item | Result |
|---|---|
| Command | `.highway/tools/tests/run-all.sh` before the first edit |
| Exit status | 0 |
| Summary | 60 passed, 0 failed (3m42s) |
| Tracked files changed by the suite | None. `git status` unchanged outside this feature and the Spec Kit changes; `.adapter-manifest` byte-identical before and after |

## Pre-change snapshots (T002)

`.cursor/skills/speckit-*/SKILL.md` sha256 (10 files):

```text
057a2bd2cc91184a6a0b3b2e0fcf6704d4ef55cc1c5939b40e1968431ee10061  .cursor/skills/speckit-checklist/SKILL.md
225297f98e77807dd261ea5692ca0a5b286902d7c9b4855fc30b93f4283ce0a6  .cursor/skills/speckit-taskstoissues/SKILL.md
24e873a5a7adb75e832b6100d6c9140b0a0df4b9650ba32b8102e37697332beb  .cursor/skills/speckit-tasks/SKILL.md
3d13e010accc60766db3549a52f598e643f5f6c26570a475df418c7a74ba4cbb  .cursor/skills/speckit-plan/SKILL.md
442e1c84f9a9f2267700cf08157b2aff65e00abae687689f639ce8f62ff8b6f5  .cursor/skills/speckit-constitution/SKILL.md
7deb401f0e53be0264722db1c2d401b279ca64ad3fc886a186de39f7ffd5be42  .cursor/skills/speckit-analyze/SKILL.md
aca98c2c55ba124dbddc467642dc90c673f7657ff750b9a93d89916058dded0d  .cursor/skills/speckit-converge/SKILL.md
d0b83970b14be40bd1dcd5d3c15f3186c37ebebbe4617dda7e8d487763b70f79  .cursor/skills/speckit-specify/SKILL.md
df979ca34543fbde2336626752ef72020aa68f4b38c2d108a2da4473113977db  .cursor/skills/speckit-implement/SKILL.md
e1a1ddba9346721f41e7b8d0ad278b54d69399c0625db9d753756fd33e51a6e1  .cursor/skills/speckit-clarify/SKILL.md
```

Fixture leftover `.cursor/rules/test-catalog-fixture-20649.mdc`:
`60826b120becb64a3a2b971b30b3230250da19719cc14dd2750fce5f03527392` (matches the value the
migration contract expects).

Adapter manifest rows present before the change:

- 12 rows beginning `.cursor/rules/` (`highway-adr` 1.0.0, `highway-clarify` 2.0.0,
  `highway-controls` 3.0.0, `highway-discovery` 2.1.0, `highway-help` 3.0.4, `highway-inquiry` 1.0.2,
  `highway-new` 1.0.0, `highway-nfrs` 10.0.0, `highway-objectives` 2.0.0, `highway-profile` 3.0.0,
  `highway-relationships` 1.0.0, `highway-setup` 7.0.0).
- 12 rows beginning `.mock-agent-4/` (existing residue; must be preserved).
- 48 rows in total. A copy of the manifest before any edit is kept for comparison.

## Failing before change (D3.6)

Amended tests run against the unchanged generator, manifests and distribution manifest.

| Test | Exit | Failures | What failed (each names the missing Cursor skill behavior) |
|---|---|---|---|
| `generate-agent-adapters.test.sh` | 1 | 4 | `.cursor/skills/<tmp>/SKILL.md` not generated; a Cursor rule file was generated; the collision was not named at the skill path; the generator could not recover after the collision step |
| `adapter-coverage.test.sh` | 1 | 36 | For each of 12 skills: no adapter at `.cursor/skills/<id>/SKILL.md`, not included by the distribution manifest, no adapter manifest row |
| `highway-new.test.sh` | 1 | 1 | `.cursor/skills/highway-new/SKILL.md` missing from the manifest |

Notes:

- The collision assertions were initially inside an `if` that skipped when the Cursor target was
  absent, so the old generator never reached them. The block was made unconditional so the behavior
  can be observed failing. Under the old generator the collision run refused for a different file
  (an untracked `.cursor/rules/<tmp>.mdc` it had produced itself), so the "names the skill path"
  assertion fails, which is the intended signal.
- The three test runs reordered rows in the tracked adapter manifest but did not change its
  contents: `sort` of the manifest is identical before and after. The generator moves each row it
  writes to the end, and only the suite's 4-agent extensibility test restores the interleaved
  order, so the final order is settled by the full-suite run in T029.
- `new-agent-extensibility.test.sh`, `run-all.sh` and `feature-038-helpers.sh` edits are path
  changes with no assertion of their own to fail; they are exercised by T014 and T029.

Superseded assertions (D3.5), each with its reason:

| Removed assertion | Reason |
|---|---|
| `alwaysApply: false` present in the Cursor file | The rule conversion was removed; the Cursor file is now a skill |
| `globs:` omitted | Same |
| Description line only, matching source | Same; the whole frontmatter is now delivered and checked key by key |
| `## When to use` present below rule frontmatter | Same; byte-identity to source and to the Claude Code file supersedes it |

## US1: Cursor deliverable is a skill (T012 to T014)

Generator change: the Cursor entries of `AGENT_TARGET_TEMPLATES` and `AGENT_TRANSFORMS` are now
`.cursor/skills/%s/SKILL.md` and `identity-copy`; `transform_mdc` and the `mdc-transform` case arm
are deleted; the three `AGENT_*` arrays remain one line each. `write_target_from_content` is kept
as the extension seam for a future agent that needs a conversion, with its comment reworded.

Generator run (`generate-agent-adapters.sh`): exit 0, 12 `Generated .cursor/skills/...` lines.

Quickstart step 1 results:

| Check | Expected | Observed |
|---|---|---|
| `.cursor/skills/highway-*` directories | 12 | 12 |
| `cmp` against Claude Code, GitHub Copilot and source, per skill | no output | no output |
| `usage:` present in `.cursor/skills/highway-help/SKILL.md` | 1 | 1 |
| `mdc-transform` / `transform_mdc` matches in the generator | 0 | 0 |
| Manifest rows for `.cursor/skills/highway-*` | 12 | 12 |
| Manifest row hash for `highway-help` Cursor vs Claude Code | equal | equal (`66081363cf64a2aa...`) |
| `speckit-*` checksums vs pre-change snapshot | unchanged | UNCHANGED |

Tests: `generate-agent-adapters.test.sh` exit 0 (was 4 failures); `new-agent-extensibility.test.sh`
exit 0. The generator was left unmodified by the extensibility test and no `.mock-agent-4` or
fixture directory remained.

State after US1: the 12 old `.cursor/rules/` rows and files are still present, so the manifest
holds 60 rows until US2 removes them. `adapter-coverage.test.sh` still fails on the distribution
rows until US3, as the tasks state.

## US2: guard and migration (T015 to T017)

### Guard observed failing (T015)

`generate-agent-adapters.test.sh` with the new regression guard, run before the migration: exit 1,
13 failures: 12 `superseded Cursor rule file still present: .cursor/rules/highway-<id>.mdc` and
`the adapter manifest still holds 12 row(s) naming .cursor/rules/`. This is the failure the
migration must clear.

### Migration scenarios (T017)

Script `specs/097-cursor-skills-adapter/migrate-cursor-rules.sh` (Bash 3.2; toolchain used: `awk`,
`cat`, `dirname`, `grep`, `mktemp`, `mv`, `rm`, `sha256sum`/`shasum`, `tr`, `wc`; no `git`). Each case
ran against a fresh temporary copy of `.highway`, `.cursor/rules` and the script; the copy was
deleted afterwards. Result: **32 passed, 0 failed** across 8 cases.

| Case | Seed | Observed |
|---|---|---|
| 1 Clean | none | Exit 0; 13 `REMOVED` (12 adapters + leftover); `MIGRATION COMPLETE: 13 removed, 12 rows dropped`; `.cursor/rules` empty; 0 rules rows; all other rows byte-identical and in order; 12 `.mock-agent-4` rows preserved |
| 2 Edited adapter | appended a line to `highway-help.mdc` | Exit 1; `EDITED` reported; file kept intact; the other 11 adapters and the leftover removed; only that row remains; `MIGRATION INCOMPLETE: 1 edited file(s) need a decision` |
| 3 Re-run after resolving | deleted the edited file, re-ran | Exit 0; `ROW-DROPPED` for it; 0 rules rows |
| 4 Foreign rule | added `.cursor/rules/hand-written.mdc` | Exit 0; file checksum unchanged; never named in the output |
| 5 Edited leftover | appended to the fixture leftover | Exit 1; `EDITED` reported and kept; the 12 adapters still removed |
| 6 Idempotent | ran twice on a clean copy | Both exit 0; second run changed nothing (`0 removed, 0 rows dropped`) |
| 7 Missing manifest | deleted the manifest | Exit 1; `ERROR: .highway/tools/.adapter-manifest not found`; all 13 files still present |
| 8 Tracked file already absent | deleted one adapter first | Exit 0; `ROW-DROPPED` reported; 12 rows dropped |

### Real migration and regeneration (T018, T019)

`bash specs/097-cursor-skills-adapter/migrate-cursor-rules.sh`: exit 0, 13 `REMOVED`, no `EDITED`
file, `MIGRATION COMPLETE: 13 removed, 12 rows dropped`. No hand-edited rule file was found, so no
maintainer decision was needed.

| Check | Expected | Observed |
|---|---|---|
| Files under `.cursor/rules/` matching `highway-*` or `test-catalog-fixture-*` | 0 | 0 (the directory is empty) |
| Manifest rows beginning `.cursor/rules/` | 0 | 0 |
| Manifest rows beginning `.cursor/skills/highway-` | 12 | 12 |
| `.mock-agent-4` rows | 12, preserved | 12 |
| Manifest total | 48 | 48 |
| Every other row vs the pre-migration manifest | identical, in order | identical |
| `generate-agent-adapters.test.sh` (guard included) | exit 0 | exit 0 (was 13 failures) |
| Adapters generator, two consecutive runs: `git status --short .highway .cursor` | identical | identical |
| Adapters generator, two consecutive runs: manifest | identical | identical |
| `.cursor/skills/highway-*/SKILL.md` combined checksum, two runs | equal | equal (`624ce53dabd260c6...`) |
| `generate-catalog.sh`, `generate-library-catalog.sh`, `generate-agent-adapters.sh` in a temporary copy vs the real tree | no diff aside from the recorded timestamp | no diff, for all four catalog files |

The catalog generators were run in a temporary copy, not in place, because each run stamps a new
generation timestamp into tracked files and no skill source changed. The empty `.cursor/rules/`
directory was left in place; git does not track an empty directory and no file was touched.

### Correction found during US3

T007 originally changed `highway-new.test.sh` to expect `.cursor/skills/highway-new/SKILL.md`. That
test reads the distribution manifest, whose rows are directory paths (`.github/skills/highway-new`,
`.claude/skills/highway-new`), so the correct expectation is the directory `.cursor/skills/highway-new`.
The T011 failure for that test was real but would not have been cleared by any manifest change;
it was corrected once T020 exposed it, and `research.md`, `plan.md` and `tasks.md` were updated to
match. `highway-new.test.sh` now exits 0.

## US3: coexistence and distribution (T020 to T023)

T020: in `.highway/tools/.distribution-manifest`, the 12 `include<TAB>.cursor/rules/highway-<id>.mdc<TAB>-`
rows became 12 `include<TAB>.cursor/skills/highway-<id><TAB>-` rows, same order, tabs preserved;
`exclude<TAB>.cursor<TAB>-` is unchanged.

T021 test results:

| Test | Before (T011) | After |
|---|---|---|
| `adapter-coverage.test.sh` | exit 1, 36 failures | exit 0 |
| `distribution-packaging.test.sh` | not run | exit 0 |
| `shipped-tree-independence.test.sh` | not run | exit 0 |
| `highway-new.test.sh` | exit 1 | exit 0 (after the correction recorded above) |

T022 distribution produced into a temporary directory with `generate-distribution.sh`:

| Check | Expected | Observed |
|---|---|---|
| Exit status | 0 | 0 (`distribution accepted`, 101 paths included) |
| Verification 1: no development-only reference in a distributed file | pass | PASS |
| Verification 2: cross-references resolve inside the distribution | pass | PASS (7) |
| Verification 3: the distribution's own validator against every skill | pass | PASS (12 skills) |
| `highway-*` entries under `.cursor/skills/` | 12 | 12 |
| `speckit-*` entries under `.cursor/skills/` | 0 | 0 |
| `.cursor/rules/` in the distribution | absent | absent |
| `migrate-cursor-rules.sh` anywhere in the distribution | 0 | 0 |
| Development references (`specs/`, `.specify/`) in the distribution `README.md` | 0 | 0 |
| Each distributed Cursor skill vs its Claude Code counterpart | identical | identical |

The temporary distribution was removed except for a `.cursor` directory the sandbox would not let me delete, left in the OS temporary directory outside the repository for the OS to clear. The migration script existed in the tree during
this run and did not ship, which shows the exclusion holds without relying on its later removal.

T023: the sha256 of all 10 `.cursor/skills/speckit-*/SKILL.md` files, taken after generation,
migration and distribution, matches the pre-change snapshot: **UNCHANGED (10 of 10)**.

## US4: documentation (T024 to T027)

| Document | Change |
|---|---|
| `README.md` | The adapter description now names `.cursor/skills/` |
| `.highway/tools/README.md` | The Cursor target is `.cursor/skills/<id>/SKILL.md`; states that all three deliverables are byte-identical so Cursor receives skills, not rules; the `speckit-*` sentence now covers `.cursor/skills/` as well as `.github/skills/` and adds that the generator removes no file |
| `.highway/DISTRIBUTION.md` | The adapter sentence names `.cursor/skills/`; adds the FR-016 note that an earlier install's `.cursor/rules/<id>.mdc` Highway files are superseded and can be deleted, while other rules stay |

Verification:

| Check | Expected | Observed |
|---|---|---|
| `rg '\.cursor/rules\|\.mdc'` over the three documents | only the FR-016 note | only `.highway/DISTRIBUTION.md` lines 21 to 22 |
| `rg 'specs/\|\.specify/'` over `DISTRIBUTION.md` and the tools `README.md` | no match | no match |
| `path-integrity.test.sh` | exit 0 | exit 0 |
| `distribution-packaging.test.sh` | exit 0 | exit 0 |
| `shipped-tree-independence.test.sh` | exit 0 | exit 0 |

`.highway/skills/_authoring-standard.md` and `.specify/memory/constitution.md` were deliberately
not edited (see research.md, Decision 6).

## Polish (T028 to T030)

| Task | Result |
|---|---|
| T028 regeneration | Adapters generator run twice: exit 0 both times; adapter manifest and `git status` unchanged. Catalog generators, run in a temporary copy: no diff aside from the recorded timestamp for all four catalog files; every `.cursor`, `.claude` and `.github` adapter equals its regenerated counterpart |
| T029 full suite | `run-all.sh` exit 0, **60 passed, 0 failed** (3m56s), the same as the baseline |
| T029 manifest | 48 rows: 0 rows for `.cursor/rules/`, 12 for `.cursor/skills/`, 12 `.mock-agent-4` rows, 0 stray fixture rows. `git diff --stat`: 12 insertions, 12 deletions, exactly the 12 Cursor rows swapped in place. Every non-Cursor row is identical to `HEAD` |
| T030 cleanup | `migrate-cursor-rules.sh` removed and confirmed absent from the whole tree. No removal code was added to the generator (its only `rm` is the existing temporary-file cleanup on line 119) |

## Check results (D7.3: separate from requirement coverage)

| Check | Before | After |
|---|---|---|
| Full suite (`run-all.sh`) | 60 passed, 0 failed | 60 passed, 0 failed |
| `generate-agent-adapters.test.sh` | not applicable | exit 0, including the collision case, the byte-identity and frontmatter checks, and the rule-file regression guard |
| `adapter-coverage.test.sh` | 36 failures under the amended helpers | exit 0 |
| Distribution (`generate-distribution.sh`) | not run | accepted first time; 3 of 3 verifications pass |
| Seeded migration cases | not applicable | 32 of 32 assertions, 8 cases |

## Requirement coverage (D7.3)

Each requirement is mapped to the evidence that shows it met. "Seeded run" means proved once against
a temporary copy; that evidence is not re-runnable now that the script is gone.

| Requirement | Status | Evidence |
|---|---|---|
| FR-001 Cursor deliverable at `.cursor/skills/<id>/SKILL.md` | Met | US1 table; `generate-agent-adapters.test.sh` |
| FR-002 Byte-identical to the other agents | Met | `cmp` for all 12 skills; the test's byte-identity check |
| FR-003 No rule output; conversion removed | Met | 0 matches in the generator; the regression guard |
| FR-004 Validation-first, no partial set, refuse to overwrite | Met | Unchanged code; collision case; existing hand-edit case |
| FR-005 `speckit-*` never touched | Met | Test sentinels under `.github/` and `.cursor/`; 10 of 10 checksums unchanged |
| FR-006 Rule files retired, manifest rows replaced | Met | Real migration; 0 and 12 row counts |
| FR-007 Edited or foreign files handled safely | Met by seeded run only | Cases 2, 4, 5 and 3. No edited file existed in the real tree, so this path was not exercised there |
| FR-008 Deterministic output | Met | Two runs identical |
| FR-009 Distribution manifest | Met | 12 directory rows, `.cursor` still excluded; 12 shipped, 0 `speckit-*` |
| FR-010 Distribution passes its verifications | Met | 3 of 3 pass |
| FR-011 Correspondence checks use the new path | Met | `adapter-coverage.test.sh` exit 0 with its seeded probes unchanged |
| FR-012 Tests cover the new form | Met | See the test change table in `research.md`; each superseded assertion has a recorded reason |
| FR-013 Live documents updated | Met | US4 |
| FR-014 Declared agent tree stays accurate | Met by inspection | The constitution names `cursor` by id and gives no path, so no edit was needed |
| FR-015 Generated artifacts current | Met | T028 |
| FR-016 Note for existing users | Met | `.highway/DISTRIBUTION.md`, lines 18 to 23 |
| FR-017 One-time migration, script removed | Met | T030 |

| Success criterion | Status | Evidence |
|---|---|---|
| SC-001 Skills listed under Skills in Cursor, none under Rules | **Partly observed** | 12 of 12 have a `.cursor/skills/` copy and 0 Highway files remain in `.cursor/rules/`. Cursor's own Skills and Rules panels have **not** been checked (T031, needs a person in Cursor) |
| SC-002 Byte-identical; no frontmatter field lost | Met | `cmp`; `usage:` present |
| SC-003 No Highway rule files or rows | Met | 0 and 0 |
| SC-004 Second regeneration produces no diff | Met | T019, T028 |
| SC-005 `speckit-*` unchanged and not shipped | Met | 10 of 10 unchanged; 0 in the distribution |
| SC-006 Suite passes before and after | Met | 60/0 before and after |
| SC-007 Distribution passes first time | Met | 3 of 3 |
| SC-008 No live document names `.cursor/rules/` as a delivery location | Met | Only the FR-016 note remains, and it says the files are superseded |

## Observations recorded, out of scope

- `test-catalog-fixture-20649` is still committed in `.github/skills/` and `.claude/skills/` with no
  source skill; only its Cursor rule file was in scope and it is gone.
- The 12 `.mock-agent-4` rows still sit in the adapter manifest, left by
  `new-agent-extensibility.test.sh`. They were preserved unchanged and are still not cleaned up by
  the test.
- The empty `.cursor/rules/` directory remains; git does not track an empty directory.
- A throwaway `.cursor` directory from the T022 distribution is left in the OS temporary directory,
  outside the repository, because the sandbox refused to delete it.
- Under the sandbox, `xargs` fails with `sysconf(_SC_ARG_MAX)`, so the `xargs -0 shasum` form in
  `quickstart.md` step 0 should be run as a `for` loop there.
- Whether Cursor lists a skill twice through `.claude/skills/` (clarification Q1) is not yet observed.
