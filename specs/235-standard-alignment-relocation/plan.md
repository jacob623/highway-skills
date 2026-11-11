# Implementation Plan: Standard Alignment Relocation

**Branch**: `235-standard-alignment-relocation` | **Date**: 2026-11-11 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/235-standard-alignment-relocation/spec.md`

## Summary

Give the repository the Phase 3 layout. The skills move from `.highway/skills/` to `skills/`, the
bash suite from `.highway/tools/tests/` to `tests/`, and the rest of `.highway/tools/` to
`framework/`, with the Highway Skills Constitution, the authoring standard, and the word list.
`DISTRIBUTION.md` and the tools README merge into `framework/README.md`. Because every script gets
its locations from the paths helper (Phase 5), the scripts follow by editing the helper; its
variables are renamed so `HW_FRAMEWORK` means `framework/` and `HW_HIGHWAY` means `.highway/`.

The framework stops shipping. The distribution keeps its layout for users: the manifest maps
`skills/` to `.highway/skills/` and ships `framework/README.md` as `README.md`. Packaging verifies
the distribution's skills in a temporary tree made of the distribution plus the repository's
`framework/`. Both constitutions take MINOR amendments for the new locations, P2.6 names
`framework/`, and the committed test leftovers are removed along with the gaps that leaked them.

## Technical Context

**Language/Version**: Bash 3.2.57 with the Declared Toolchain (development constitution,
Principle II); TypeScript on Node 24 for the harness.

**Primary Dependencies**: none new.

**Storage**: files in the repository.

**Testing**: `tests/run-all.sh` (82 bash tests), the harness TypeScript tests
(`node --test "test/*.test.ts"` in `harness/`), and `tests/path-construction.test.sh`.

**Target Platform**: macOS (BSD utilities) and Linux (GNU coreutils).

**Project Type**: authoring framework, skill sources, and test suite in one repository.

**Performance Goals**: the suite's run time does not grow.

**Constraints**: no `SKILL.md` content changes; no regenerated artifact changes; nothing is
committed; `rollout-plan.md` stays gitignored and excluded.

**Scale/Scope**: 15 skill folders; 253 test files; 4 generators, 3 validators, 13 libraries, and 4
manifests; the two constitutions, the authoring standard, the word list, and two READMEs.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Development constitution 3.1.0.

**Process gates**

| Gate | Trigger | Verdict |
| --- | --- | --- |
| Packaging | True: the skills and the manifest change | D1.1 PASS: `framework/README.md` and the manifest name no development location, and the shipped set shrinks. D1.2 PASS by design: the verification tree has no `specs/`, `.specify/`, or `tests/` (research R5). D6.2 PASS by design: `framework/README.md` links only to files the distribution holds (R7) |
| Toolchain | True: every file under `.highway/tools/` and `harness/bin/` changes | D2.1–D2.4 PASS: moves, renames, and one new `awk` branch in `dist_destination`; no new command or flag. D2.5 PASS after conversion: the check scans the new folders (R10) |
| Generator | True: the generators change | D4.1–D4.4 PASS: only their location and path variables change; regeneration leaves no diff |
| Correspondence | True: every skill folder moves | D4.5–D4.7 PASS: adapters, manifest rows, and the catalog are regenerated from `skills/` with no diff; the leftover entries for undeclared skills and agents go (R12) |
| Validation | True: the P2.6 check changes | D3.4 PASS: no skill or fixture names `framework/` outside a fenced block before the change, so no verdict changes (R8). D3.5 PASS: no assertion is removed; literals change location only |

Also evaluated: D3.1 PASS (82/82 on the unchanged tree, 2026-11-11). D3.3 PASS (tests change).
D5.3 and D1.3/D1.4 apply to both amendments and are recorded in their Sync Impact Reports. D6.1:
every live document naming a moved path changes in this change (FR-014).

**Skill content gates**

The Skill Content Gate triggers: files under `.highway/skills/` move. Highway Skills Constitution
10.0.0: no skill text changes, so every P-rule verdict carries forward. P2.6 is amended to name
`framework/` (10.1.0) and its check follows; D3.4 above covers its verdicts. P7.3 (the authoring
standard restates no rule text) is unaffected by the path updates.

No FAIL. Re-checked after design: unchanged.

## Project Structure

### Documentation (this feature)

```text
specs/235-standard-alignment-relocation/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── paths-helper.md
│   └── distribution.md
└── tasks.md
```

### Source Code (repository root)

```text
skills/<id>/                       # from .highway/skills/<id>/, byte-identical
framework/                         # from .highway/tools/ (without tests/)
├── generate-*.sh, validate-*.sh
├── lib/paths.sh                   # the helper, renamed variables (R2)
├── .adapter-manifest, .distribution-manifest, .frontmatter-contract, .instruction-manifest
├── constitution.md                # from .highway/governance/, 10.1.0
├── authoring-standard.md          # from .highway/skills/_authoring-standard.md
├── frontmatter-lexicon.txt        # from .highway/library/knowledge/
└── README.md                      # DISTRIBUTION.md + tools README (R7)
tests/                             # from .highway/tools/tests/
├── paths.sh                       # shim: ../framework/lib/paths.sh
└── path-construction.test.sh      # scans framework/, tests/, harness/bin/
harness/bin/lib/paths.sh           # shim: ../../../framework/lib/paths.sh
harness/bin/path-map.sh            # REL_FRAMEWORK, REL_TESTS, --location framework
harness/src/project.ts             # location("framework")
harness/selection/shared.txt       # drops the constitution and word-list rows
.highway/                          # catalog/, governance/ (2 files), instructions/, library/
.specify/memory/constitution.md    # 3.2.0
```

**Structure Decision**: the Phase 3 layout, with `.highway/` reduced to the shipped data later
phases remove.

## Complexity Tracking

None.
