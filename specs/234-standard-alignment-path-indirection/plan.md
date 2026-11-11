# Implementation Plan: Standard Alignment Path Indirection

**Branch**: `feature/std-alignment-phase5` | **Date**: 2026-11-11 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/234-standard-alignment-path-indirection/spec.md`

## Summary

Phase 5 of `standard-alignment.md` prepares the Phase 6 move without moving anything. It first
retires the regression-only tests and every exact version check, so the conversion count is final
before conversion starts. It then adds one paths helper, `.highway/tools/lib/paths.sh`, which
declares every repository location once, gives each output template and governance or knowledge
document its own lookup by name, and maps any location into a disposable copy. Every bash test,
framework tool, shared library, and harness script gets its locations from that helper, through
one bootstrap line. A new registered check, `path-construction.test.sh`, fails on any path built
outside the helper and decides a new development-constitution rule, D2.5, in a MINOR amendment to
3.1.0. The harness path map reads the helper and supplies the skills and tools locations to the
TypeScript runner.

## Technical Context

**Language/Version**: Bash 3.2.57 for every script under `.highway/tools/` and `harness/bin/`
(D2.1). TypeScript on Node for the harness runner (unchanged toolchain). Markdown for documents
and the constitution.

**Primary Dependencies**: The Declared Toolchain only (D2.2). No new utility.

**Storage**: Files in the repository. No runtime storage.

**Testing**: `.highway/tools/tests/run-all.sh` (88 tests at the start), run outside the sandbox.
The harness TypeScript tests run with `npm test` in `harness/`.

**Target Platform**: macOS (BSD utilities) and Linux (GNU coreutils) (D2.3).

**Project Type**: A skill-authoring framework with generators, validators, a distribution step,
and a behavioral harness.

**Performance Goals**: The full suite stays within its current run time (about 4 to 6 minutes).
The helper adds one `source` per script and no subprocess per lookup beyond a `case` statement.

**Constraints**: Nothing moves (FR-012). No backward compatibility. The helper must not contain
the strings the shipped-tree check forbids. No commit unless the user asks.

**Scale/Scope**: 7 tests removed (5 regression-only, 2 consolidated Experience Standard tests),
3 fixtures removed, about 40 tests lose version checks, then about 81 tests, 7 tools, 12 shared
libraries, and 4 harness scripts are converted; 1 helper, 2 shims, and 1 check are added; the
harness path map and 2 TypeScript files change.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Evaluated against `.specify/memory/constitution.md` 3.0.0.

### Process gates

| Gate | Trigger | Verdict |
|---|---|---|
| Packaging | True: `.highway/tools/` is shipped and gains `lib/paths.sh` | D1.1 PASS: the helper names no prohibited location, and the shipped-tree check scans it. D1.2 PASS: the packaged validator sources the helper from its own position, and the distribution test runs it with the development folders absent. D6.2 PASS: the tools README and root README are updated in the same change (FR-013) |
| Toolchain | True: every file under `.highway/tools/` changes | D2.1–D2.4 PASS: the helper uses `case`, parameter expansion, `cd`, and `pwd` only; no array, no new command, no new flag. D2.5 (new) PASS after conversion: the new check reports 0 violations |
| Generator | True: `generate-agent-adapters.sh`, `generate-catalog.sh`, `generate-instructions.sh`, and `generate-distribution.sh` change how they find paths | D4.1 PASS: no generated file is hand-edited. D4.2 PASS: output depends only on inputs. D4.3 PASS: write targets are unchanged. D4.4 PASS: every generator is re-run and leaves no diff (FR-012) |
| Correspondence | True: generators change | D4.5, D4.6 PASS: no skill is added or removed. D4.7 PASS: regeneration into a temporary tree shows no diff |
| Validation | True: tests are removed, reduced, converted, and added | D3.4 PASS: the new check is evaluated against the converted tree and a seeded copy before it is registered. D3.5 PASS: every removed or loosened assertion is in the dropped-assertion record (research R3). D3.6 PASS: the new check is run and observed failing on the unconverted tree before conversion completes. D3.7 PASS: the check declares `source-document` and implements `--probe` and `--neutralise` |

D3.1 and D3.2: the full suite and the harness tests run before the first edit and after the last.
D3.3: no tool behavior changes; only path resolution changes, which the whole suite exercises.

### Skill content gates

Not triggered. No skill, template, governance document, or knowledge document changes content.

**Result**: no FAIL. Proceed.

### Post-design re-check

The design adds one shipped file, `lib/paths.sh`, evaluated above under Packaging. The amendment
(research R10) adds D2.5 and extends the Toolchain Gate to D2.1–D2.5 and to `harness/bin/`; the
design meets the new rule once the conversion is complete. Result unchanged: no FAIL.

## Project Structure

### Documentation (this feature)

```text
specs/234-standard-alignment-path-indirection/
├── plan.md                  # This file
├── research.md              # Decisions and the dropped-assertion record
├── data-model.md            # Locations, lookups, and check rules
├── quickstart.md            # Validation scenarios
├── contracts/
│   └── paths-helper.md      # The helper's interface
├── checklists/
│   └── requirements.md      # Spec quality checklist
└── tasks.md                 # /speckit-tasks output
```

### Source Code (repository root)

```text
.highway/tools/
├── lib/paths.sh                       # new: the paths helper (ships)
├── lib/*.sh                           # root argument becomes the repository root; locations from the helper
├── *.sh                               # source lib/paths.sh; no root derivation
├── README.md                          # describes the helper
└── tests/
    ├── paths.sh                       # new: test bootstrap shim (not a test)
    ├── path-construction.test.sh      # new: the D2.5 check
    ├── run-all.sh                     # sources the shim
    ├── *.test.sh                      # source the shim; version pins removed
    ├── experience-standard-convergence.test.sh  # holds the consolidated Experience Standard checks
    ├── experience-standard-amendment.test.sh    # removed (consolidated)
    ├── feature-141-experience-standard-refactor.test.sh  # removed (consolidated)
    ├── profile-yaml.test.sh, path-integrity.test.sh, feature-092-correspondence.test.sh,
    │   profile-adaptive.test.sh, runtime-contract-hygiene.test.sh  # removed
    └── fixtures/profile-092/{dependent-artifact-inventory,impact-review}.tsv,
        fixtures/profile-091/adaptive-corpus.md               # removed
harness/
├── bin/lib/paths.sh                   # new: harness bootstrap shim
├── bin/{path-map,inventory,template-check,fixture-check}.sh  # locations from the helper
├── src/select.ts                      # skills location from the path map
└── src/project.ts                     # tools location from the path map
.specify/memory/constitution.md        # 3.1.0: D2.5, Enforcement Map row, Toolchain Gate
README.md                              # describes the helper
```

**Structure Decision**: one new shipped file and three new development files. Everything else is
an edit in place or a removal.

## Complexity Tracking

No Constitution Check violation. Nothing to justify.
