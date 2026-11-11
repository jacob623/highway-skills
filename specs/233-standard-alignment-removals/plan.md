# Implementation Plan: Standard Alignment Removals

**Branch**: `feature/std-alignment-phase4` | **Date**: 2026-11-11 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/233-standard-alignment-removals/spec.md`

## Summary

Phase 4 of `standard-alignment.md` removes files that later phases would otherwise convert and
move: the shared library index and its generator, the skill catalog's `index.md` with its
`overlap_flags` and `generated_at` fields, four README files, and three finished one-off tools with
their tests. The approach is deletion plus reference repair. The skill catalog generator writes only
`entries` to `index.json`, so its output is byte-identical across runs. Its test, the correspondence
test, and the packaging test lose their timestamp filters. The development constitution drops the
timestamp exception from D4.2 and D4.7 in a MAJOR amendment. Every assertion that leaves with a
removed test is kept elsewhere or recorded as superseded in [research.md](research.md) R9.

## Technical Context

**Language/Version**: Bash 3.2.57 for every script under `.highway/tools/` (D2.1). Markdown for
skills, documentation, and the constitution.

**Primary Dependencies**: The Declared Toolchain only (D2.2). No new utility.

**Storage**: Files in the repository. No runtime storage.

**Testing**: `.highway/tools/tests/run-all.sh`, which discovers every `*.test.sh`. The harness
TypeScript tests are not affected: no harness source names a removed file.

**Target Platform**: macOS (BSD utilities) and Linux (GNU coreutils) (D2.3).

**Project Type**: A skill-authoring framework with generators, validators, and a distribution
step.

**Performance Goals**: N/A.

**Constraints**: No backward compatibility (spec Assumptions). Phase 4 removes only what
`standard-alignment.md` assigns to it. No commit unless the user asks.

**Scale/Scope**: 11 files and 4 tests deleted; 3 local `.DS_Store` files deleted; about 16 files
edited; 4 generated agent copies and 1 catalog regenerated.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Evaluated against `.specify/memory/constitution.md` 2.3.0, with the output shape that document
requires.

### Process gates

| Gate | Trigger | Verdict |
|---|---|---|
| Packaging | True: `.highway/tools/`, `.highway/catalog/`, `.highway/library/`, and `.highway/skills/` are shipped | D1.1 PASS: no edit adds `.specify/` or `specs/` to a shipped file. D1.2 PASS: the distribution test runs the packaged validator after the change. D6.2 PASS: the catalog README links are removed with the generator lines that wrote them, and no remaining document links to a removed file (research R1) |
| Toolchain | True: files under `.highway/tools/` change | D2.1–D2.4 PASS: edits only remove code paths; no new command, flag, or dependency |
| Generator | True: `generate-catalog.sh` changes and `generate-library-catalog.sh` is removed | D4.1 PASS: `index.json` and the help agent copies are regenerated, not hand-edited. D4.2 PASS: the generator's output depends only on skill sources, and the test asserts byte identity. D4.3 N/A: no generator gains or loses a write target it did not produce. D4.4 PASS: `index.json` is regenerated in the same change |
| Correspondence | True: highway-help's source changes | D4.5 PASS and D4.6 PASS: no skill is added or removed. D4.7 PASS: the adapter and catalog generators are re-run, and the correspondence test compares raw bytes |
| Validation | True: `generate-catalog.test.sh`, `adapter-coverage.test.sh`, `distribution-packaging.test.sh`, `feature-092-correspondence.test.sh`, and `harness-path-map.test.sh` change, and four tests are removed | D3.4 PASS: the stricter catalog checks are evaluated against the committed catalog and the fixture skills before they are wired in; the only fixture whose verdict changes is the committed `index.json`, which is regenerated. D3.5 PASS: every removed or loosened assertion is recorded with the behavior it covered (research R9, R5, R6, R7) |

D3.1 and D3.2: the full suite runs before the first edit and after the last. D3.3: the catalog
generator's behavior changes and its test is amended. D3.6: the amended catalog test is run and
observed failing against the current generator before the generator changes.

### Skill content gates

Triggered: `.highway/skills/highway-help/SKILL.md` and `.highway/skills/_authoring-standard.md`
change, and three README files under `.highway/library/` are removed. Evaluated against
`.highway/governance/constitution.md`.

| Rule | Verdict |
|---|---|
| P1.5 | PASS: highway-help's Inputs still name `.highway/catalog/index.json`, which stays |
| P5.6 | PASS: highway-help's "When to use" is unchanged |
| P7.2 | PASS: `metadata.version` stays MAJOR.MINOR.PATCH (3.1.0 to 3.1.1) |
| P7.3 | PASS: the authoring standard's overlap review keeps citing the constitution's threshold and restates no rule |
| P7.5 | PASS: "When not to use" gets shorter |
| P7.7 | PASS: removing a guidance line is not a contract break; the bump is a patch (research R12) |
| P9.1, P9.2, P9.4 | PASS: highway-help's Outputs are unchanged, and both modes read only `entries` |

D8.1: no skill cites a removed README or the library index, so no citing skill needs
re-validation.

**Result**: no FAIL. Proceed.

### Post-design re-check

The design artifacts add no shipped path, generator, or validation check beyond those evaluated
above. The constitution amendment (research R8) strengthens D4.2 and D4.7, and the design meets the
strengthened rules: after the change, no declared generator writes a timestamp. Result unchanged:
no FAIL.

## Project Structure

### Documentation (this feature)

```text
specs/233-standard-alignment-removals/
├── plan.md              # This file
├── research.md          # Decisions, the reference inventory, and the superseded-assertion record
├── data-model.md        # The skill catalog shape before and after
├── quickstart.md        # Validation scenarios
├── checklists/
│   └── requirements.md  # Spec quality checklist
└── tasks.md             # /speckit-tasks output
```

No `contracts/` folder: the only changed interface is the skill catalog file, which is internal
to the repository and described in [data-model.md](data-model.md).

### Source Code (repository root)

```text
.highway/
├── catalog/
│   ├── index.json                 # regenerated: entries only
│   ├── index.md                   # removed
│   ├── library-index.json         # removed
│   ├── library-index.md           # removed
│   └── README.md                  # removed
├── library/
│   ├── governance/README.md       # removed
│   ├── knowledge/README.md        # removed
│   └── templates/README.md        # removed
├── skills/
│   ├── _authoring-standard.md     # overlap review step 4 removed
│   └── highway-help/SKILL.md      # overlap_flags line removed; 3.1.1
└── tools/
    ├── .distribution-manifest     # five dead rows removed
    ├── .objective-rename-allowlist  # removed
    ├── README.md                  # catalog section reworded; library catalog section removed
    ├── audit-objective-rename.sh  # removed
    ├── audit-profile-migration.sh # removed
    ├── generate-catalog.sh        # writes index.json with entries only
    ├── generate-library-catalog.sh  # removed
    ├── seed-library-context.sh    # removed
    └── tests/
        ├── adapter-coverage.test.sh            # no library generator; raw-byte comparison
        ├── distribution-packaging.test.sh      # no timestamp normalization
        ├── feature-092-correspondence.test.sh  # no library index
        ├── generate-catalog.test.sh            # byte identity; no removed fields or index.md
        ├── harness-path-map.test.sh            # index.json expectation
        ├── fixtures/profile-092/*.tsv          # library index rows removed
        ├── generate-library-catalog.test.sh    # removed
        ├── objective-rename-contract.test.sh   # removed
        ├── profile-migration.test.sh           # removed
        └── seed-library-context.test.sh        # removed
.agents|.claude|.cursor|.github/skills/highway-help/SKILL.md  # regenerated
.specify/memory/constitution.md    # 3.0.0
harness/selection/shared.txt       # three README rows removed
README.md                          # catalog line reworded
```

**Structure Decision**: no new folder. Every change is a deletion or an edit in place.

## Complexity Tracking

No Constitution Check violation. Nothing to justify.
