# Implementation Plan: Standard Alignment Self-Contained Skills

**Branch**: `feature/std-alignment-phase11` | **Date**: 2026-11-11 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/240-standard-alignment-self-contained-skills/spec.md`

## Summary

Phase 11 removes `.highway/` and proves each skill reads only its own folder.

- highway-help's index moves to `skills/highway-help/assets/index.json`. The generator writes it with
  each skill's dependencies and Example, and highway-help reads nothing else (R1–R3).
- `validate-library.sh` merges into `validate-skill.sh`. Complete templates in `assets/` keep their
  checks, and `references/` gets the body rule checks. The cache key covers both folders (R4, R5).
- A new `self-contained-skills.test.sh` enforces relative, one-level bundled-file paths, no path
  outside the skill, no `.highway` outside a code product's records, and setup's seeded-only writes
  (R6).
- Skills find the project at the repository root. 14 skills drop their `.highway/` input, and three
  drop the "cannot be located" stop (R7).
- The distribution ships the skills only in the agent trees, with its record at its root (R8). The
  harness test project gets the skill folders from `skills/` in `.github/skills/` (R9).
- The development constitution goes 3.3.0 → 3.4.0, MINOR. The Highway Skills Constitution is
  unchanged (R10). Tests are retired or repointed as R11 lists.

## Technical Context

**Language/Version**: Bash 3.2.57 with the Declared Toolchain; TypeScript on Node 24 for the harness.

**Primary Dependencies**: none new.

**Storage**: files in the repository.

**Testing**:

- `tests/run-all.sh`: 85 tests now. After the change there are 85: `validate-library` and
  `library-containment` are retired, and `bundled-files` and `self-contained-skills` are added.
- The harness TypeScript tests: 81, unchanged in number.
- `tsc`.
- `framework/validate-skill.sh --no-cache` over every skill and fixture, for the D3.4 comparison.
- The harness static checks; a live run needs a token.

**Target Platform**: macOS (BSD utilities) and Linux (GNU coreutils).

**Project Type**: authoring framework, skill sources, test suite, and harness in one repository.

**Performance Goals**: none. Bundled-file checks run in-process instead of in a child script.

**Constraints**:

- Every person-visible behavior stays the same, except the missing-root stop, which becomes the
  setup message (clarification 1).
- highway-help's six lines are unchanged.
- Nothing is committed. `rollout-plan.md` stays gitignored and excluded. Moves use `mv`.

**Scale/Scope**:

- 15 skills change (MINOR each): highway-help, the 14 with a root input, and highway-request.
- `paths.sh`, `generate-catalog.sh`, `validate-skill.sh`, `generate-distribution.sh`,
  `lib/dependency-check.sh`, `lib/rule-checks.sh`, `lib/validation-cache.sh`, the distribution
  manifest; `validate-library.sh` is removed.
- About 16 tests changed, 2 added, and 2 retired. `tests/fixtures/library/` moves.
- Harness: `project.ts`, `chain.ts`, `runner.ts`, `path-map.sh`, `fixture-check.sh`, `treatments.txt`,
  2 TypeScript tests, and `README.md`.
- `.specify/memory/constitution.md`, `README.md`, `framework/README.md`,
  `framework/authoring-standard.md`, and `standard-alignment.md`.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The development constitution is 3.3.0, and 3.4.0 after this change.

**Process gates**

| Gate | Trigger | Verdict |
| --- | --- | --- |
| Packaging | True: the manifest, the generator, and shipped skills change | D1.1 PASS: no shipped file names `.specify/` or `specs/`. D1.2 PASS: the verification tree validates the skills copied from `.agents/skills/`. D1.6 PASS: the manifest stays the one declaration. D6.2 PASS: no new link |
| Toolchain | True: `framework/`, `tests/`, and `harness/bin/` change | D2.1–D2.4 PASS: no new utility. D2.5 PASS: the index path is `HW_HELP_INDEX`, and the agent location comes from `HW_AGENT_COPILOT` through `path-map.sh` |
| Generator | True: `generate-catalog.sh` and `generate-distribution.sh` change | D4.2 PASS: the index and the distribution stay byte-stable on re-run. D4.3 PASS: the distribution still refuses an untracked or modified target, through the record at its new path |
| Correspondence | True: 15 skills change, and highway-help gains a generated asset | D4.5 PASS: each skill keeps an index entry, its agent copies, and its manifest rows, and `assets/index.json` gets adapter rows. D4.6 PASS. D4.7 PASS: regeneration leaves no diff |
| Validation | True: `validate-skill.sh` absorbs `validate-library.sh` | D3.4 PASS by design: skill and fixture verdicts are recorded before and after, and the only change is that `references/` is now checked, and passes. D3.5 PASS: every retired assertion is kept or superseded (R11). D3.6: each new check is observed failing on a seeded case before it counts |

Also evaluated:

- D3.1: the suite and the harness tests run before the first edit and after the last.
- D3.3 PASS: tests change with the code.
- D3.8: `self-contained-skills` and `bundled-files` are mixed static and executed checks with probes.
- D6.1: every live document naming `.highway/`, the library validator, or the distribution layout
  changes in this change.
- D5.3 and the constitution's self-application review: recorded in its Sync Impact Report.

**Skill content gates**

The Skill Content Gate triggers because 15 skills change. Verdicts are against the Highway Skills
Constitution 10.3.0:

- P2.6 PASS: each skill names only its own `assets/` and `references/`, and no repository folder.
- P3.5 PASS: highway-help drops its misapplied AS-4 citation; no citation remains in it.
- P7.2 and P9.5 PASS: each changed skill bumps MINOR, and its Example's version follows.
- P7.7 PASS: each change is MINOR. Invocations and outputs are unchanged, except the missing-root
  stop, which becomes the existing setup message.
- P9.1 PASS: no Outputs section changes.

The Highway Skills Constitution needs no amendment: no current rule names `.highway/` or the
library. The development constitution takes a MINOR amendment (R10). No FAIL. Re-checked after
design: unchanged.

## Project Structure

### Documentation (this feature)

```text
specs/240-standard-alignment-self-contained-skills/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── help-index.md
│   ├── bundled-files.md
│   └── harness-project.md
├── checklists/requirements.md
└── tasks.md
```

### Source Code (repository root)

```text
skills/highway-help/assets/index.json   # new, generated (moved from .highway/catalog/index.json)
skills/highway-help/SKILL.md            # reads assets/index.json only; MINOR
skills/<14 skills>/SKILL.md             # drop the .highway/ root input; MINOR
skills/highway-{request,codify,codify-config}/SKILL.md   # drop the missing-root stop
skills/highway-{controls,objectives,nfrs}/SKILL.md       # drop "beneath .highway"
framework/
├── lib/paths.sh                # HW_HELP_INDEX; HW_HIGHWAY, HW_CATALOG removed
├── generate-catalog.sh         # writes HW_HELP_INDEX; new fields
├── validate-skill.sh           # check_bundled for assets/ and references/
├── validate-library.sh         # removed
├── lib/rule-checks.sh          # rc_bundled_exempt_ids, rc_reference_exempt_ids
├── lib/body-scan.sh            # scans a file without frontmatter
├── lib/dependency-check.sh     # resolves in the skill folder
├── lib/validation-cache.sh     # key covers references/ and the folder name; env drops validate-library.sh
├── generate-distribution.sh    # record at root; verification from .agents/skills
├── .distribution-manifest      # skills excluded; .highway rows removed
├── .adapter-manifest           # regenerated
├── README.md, authoring-standard.md
harness/
├── src/project.ts, chain.ts, runner.ts   # buildSkills; baseDir
├── bin/path-map.sh             # --location agent-skills; catalog arm removed
├── bin/fixture-check.sh        # agent skill folders rejected
├── coverage/treatments.txt
├── test/runner.test.ts, chain.test.ts
├── test/project.test.ts        # new; the base holds only skill folders
└── README.md
tests/
├── self-contained-skills.test.sh   # new
├── bundled-files.test.sh           # new; replaces validate-library.test.sh
├── fixtures/bundled-files/         # moved from fixtures/library/
└── <repointed tests>
removed: .highway/, framework/validate-library.sh, tests/validate-library.test.sh,
         tests/library-containment.test.sh
.specify/memory/constitution.md     # 3.4.0
```

**Structure Decision**: Every location a skill used to share now sits in the skill that uses it. The
framework reaches it through `paths.sh`, and the harness and the distribution copy skill folders
whole.

## Complexity Tracking

None.
