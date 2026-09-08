# Implementation Plan: Constitution Relocation and Shipped-Tree Independence

**Branch**: `010-constitution-relocation` | **Date**: 2026-09-08 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/010-constitution-relocation/spec.md`

## Summary

Move the Highway Skills Constitution from `.specify/memory/constitution.md` to
`.highway/governance/constitution.md`, so the governance document lives with the tooling that
reads it and inside the tree that is distributed to users. Change the fallback location resolved
by `lib/constitution.sh` (the `CONSTITUTION_FILE` override already exists and is unchanged).
Remove every reference to a development-only location from every distributed file — 34 references
across 20 files, comprising both document links and source comments — replacing each with a
name-only citation of the design record. Leave a placeholder at the vacated location so the ten
development workflow commands continue to function until the next phase replaces it. Add a
whole-tree check, modelled on the existing path-integrity test, that fails when a distributed file
references a development-only location and that proves itself capable of failing.

## Technical Context

**Language/Version**: Bash 3.2.57 (the macOS default `/bin/bash`)

**Primary Dependencies**: None. POSIX utilities already in use — `grep`, `sed`, `awk`, `find`,
`sort`, `basename`, `dirname`, `printf`, `mktemp`

**Storage**: Flat files. No database, no serialised state beyond the existing adapter manifest

**Testing**: The existing Bash harness, `.highway/tools/tests/run-all.sh`

**Target Platform**: macOS and Linux shells; no GNU-only utility flags

**Project Type**: Single internal tooling project

**Performance Goals**: N/A — this feature changes no hot path

**Constraints**:

- Bash 3.2 compatible; no associative arrays, no `mapfile`, no GNU-only flags
- The constitution's rule text is unchanged by the move; only its location changes
- The new check must be demonstrably capable of failing, following the self-probe precedent in
  `.highway/tools/tests/path-integrity.test.sh`
- The vacated location must not simply be deleted; ten development commands read it
- The relocated constitution must not itself violate the rule this feature introduces

**Scale/Scope**: One governance document relocated; 34 references across 20 distributed files
removed, plus 2 inside the relocated constitution and 6 in generated adapters corrected by
regeneration; one skill amended and its version incremented; catalog and three agent adapters
regenerated; one new test added

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-checked after Phase 1 design.*

Evaluated against the Highway Skills Constitution v2.0.1, which this feature relocates but does
not amend.

**Skill content gate — triggered.** This feature modifies `.highway/skills/highway-help/SKILL.md`.

| Rule | Verdict | Basis |
|---|---|---|
| P7.1 | PASS | The `## Purpose` section is untouched and still holds exactly one sentence. |
| P7.2 | PASS | `metadata.version` remains present and semantic; it is incremented by this feature. |
| P7.3 | PASS | No rule text is added to the skill; references are replaced, not restated. |
| P7.4 | PASS | No MUST-level rule is added; the count is unchanged. |
| P7.5 | PASS | No normative section grows; every edit removes or shortens text. |
| P7.7 | PASS | Classified PATCH, not MAJOR. See research.md R6: no declared input, output, or verification criterion changes — only a pointer to a design record. |
| P8.3 | PASS | The `## Verification` section remains present and non-empty. |
| P8.4 | PASS | The section continues to name a runnable command and a checkable output string; only a trailing pointer is reworded. |
| P3.1, P3.2, P3.5 | PASS | The skill's existing `[AS-4: .highway/catalog/index.json]` citation is untouched and still resolves in the distributed tree. |
| P1.1–P1.7 | N/A | No normative rule is added or altered. |

**Tooling changes**: not governed by the constitution, which addresses skill and library content.
No rule applies to `lib/constitution.sh` or to the test harness.

**Self-consistency note**: relocating the constitution into the distributed tree brings the
document itself within scope of the rule this feature introduces. Its Sync Impact Report currently
cites development-only paths, so the move would create a violation if left unhandled. Resolved in
research.md R7; this is a design obligation, not a constitution violation.

**Result**: PASS. No violation requires justification, so Complexity Tracking is empty.

## Project Structure

### Documentation (this feature)

```text
specs/010-constitution-relocation/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output
│   ├── governance-location-contract.md
│   └── shipped-tree-independence-contract.md
├── checklists/
│   └── requirements.md  # Written by /speckit.specify
└── tasks.md             # Phase 2 output (/speckit.tasks — not created here)
```

### Source Code (repository root)

```text
.highway/
├── governance/
│   └── constitution.md              # NEW — relocated, rule text unchanged
├── skills/
│   ├── _authoring-standard.md       # link to constitution retargeted
│   └── highway-help/
│       └── SKILL.md                 # 2 links removed; version incremented
├── catalog/
│   ├── README.md                    # 3 design-record links → name-only
│   ├── index.json                   # regenerated
│   └── index.md                     # regenerated
└── tools/
    ├── README.md                    # constitution path + 5 design-record links
    ├── validate-skill.sh            # header comment
    ├── validate-library.sh          # header comment
    ├── generate-catalog.sh          # header comments
    ├── generate-agent-adapters.sh   # header comments
    ├── generate-library-catalog.sh  # header comment
    ├── lib/
    │   ├── constitution.sh          # fallback location changed
    │   ├── body-scan.sh             # header comment
    │   ├── dependency-check.sh      # header comment
    │   └── schema-validate.sh       # header comment
    └── tests/
        ├── shipped-tree-independence.test.sh   # NEW
        ├── authoring-standard.test.sh          # constitution path
        ├── constitution-inventory.test.sh      # constitution path
        ├── coverage-summary.test.sh            # constitution path
        ├── dependency-check.test.sh            # header comment
        ├── generate-agent-adapters.test.sh     # header comment
        ├── new-agent-extensibility.test.sh     # header comment
        └── validate-library.test.sh            # header comment

.github/skills/highway-help/SKILL.md   # regenerated
.claude/skills/highway-help/SKILL.md   # regenerated
.cursor/rules/highway-help.mdc         # regenerated

.specify/memory/constitution.md        # replaced by a placeholder
```

**Structure Decision**: Single project, existing layout. This feature adds one directory,
`.highway/governance/`, deliberately as a sibling of `.highway/library/` rather than inside it:
`validate-library.sh` validates everything under `library/` *against* the constitution, and a
document cannot be both the yardstick and the thing measured without a circular dependency.

## Complexity Tracking

No Constitution Check violation. This section is intentionally empty.
