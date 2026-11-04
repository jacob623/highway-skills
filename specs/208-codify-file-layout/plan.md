# Implementation Plan: Codify File Layout

**Branch**: `208-codify-file-layout` | **Date**: 2026-11-03 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/208-codify-file-layout/spec.md`

## Summary

A coding standard gains a required **File and Folder Structure**: the layout, as paths relative to the automation folder. Its **Tests** section names a test path inside that layout when tests are required. `highway-codify-config` refuses a standard proposal without them, and creates the coding standards catalog with the first accepted standard. The repository stops shipping the seeded catalog and Terraform standard.

`highway-codify` organizes the task list the way Speckit organizes a feature: each proposal task is a feature, its lines are grouped, and each line names the files it creates or changes. The standards place those files. Each proposal task shows **Files:** so the person can correct a path for that automation. A required test is the feature's first line. The `executor/` and `task-N/` folders are removed.

## Technical Context

**Language/Version**: Markdown skill and template sources, Bash 3.2.57-compatible repository tests

**Primary Dependencies**: `.highway/skills/highway-codify-config/SKILL.md`, `.highway/skills/highway-codify/SKILL.md`, output templates `coding-standard.md`, `codify-tasks.md`, and `codify-record.md`, `.highway/tools/.distribution-manifest`, and the seeded `library/coding-standards/` files. Generators `generate-library-catalog.sh`, `generate-catalog.sh`, `generate-agent-adapters.sh`. Validators `validate-skill.sh`, `validate-library.sh`

**Storage**: `library/coding-standards/coding-standards.md` and standard files, created in the person's project by `highway-codify-config`. `code/[ID]/` plus each task line's relative path, written by `highway-codify`

**Testing**: New `.highway/tools/tests/codify-file-layout.test.sh`, observed failing first. Replaced assertions in `highway-codify.test.sh`, `codify-config-skill.test.sh`, `codify-platform-catalog.test.sh`, and `codify-closing-guide.test.sh`, each with a reason in [research.md](research.md) R9. Then `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skills

**Performance Goals**: Coding one task line reads the layout and the files that line names, not the whole automation

**Constraints**: Each `###` section stays at or under 400 words (P7.5). Codify's `propose` (386 words) and `write` (383 words) are near that limit, so the new placement rules go in a new `### layout` section. Frontmatter is unchanged. No shipped path references `.specify/` or `specs/`

**Scale/Scope**: Two changed skills, three changed templates, two removed seed files, one manifest line, one new test, four amended tests

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Process gates, from `.specify/memory/constitution.md`:

- **Packaging Gate**: PASS. The `include library/coding-standards` line is removed. `exclude library` stays, so a developer's local library is never shipped. No shipped file gains a `.specify/` or `specs/` reference. D1.1, D1.2, and D1.6 hold.
- **Toolchain Gate**: PASS. The new test uses `grep` and `test -e` only. D2.1 through D2.4 hold.
- **Generator Gate**: N/A. No `generate-*.sh` script changes.
- **Correspondence Gate**: PASS. The skill catalog, library catalog, and adapters are regenerated (D4.5 through D4.7).
- **Validation Gate**: PASS with recorded replacements. Each assertion on the seeded files becomes an assertion of their absence. Each version pin moves to the new version. Reasons are in R9 (D3.5).
- **Verification**: D3.1 needs a passing suite before the first edit, and D3.2 after the last. D3.3 is met by the new test. D3.6 needs the new test observed failing first.
- **Shared library review (D8.1)**: re-validate `highway-codify` and `highway-codify-config`, which cite the changed templates.

Skill content gates, from `.highway/governance/constitution.md`:

- PASS pending `validate-skill.sh` on both skills and `validate-library.sh` on the three templates.

Version bumps:

| Source | From | To |
|---|---|---|
| `highway-codify` | 7.0.0 | 8.0.0 |
| `highway-codify-config` | 1.0.0 | 2.0.0 |
| `coding-standard.md` | 1.0.0 | 2.0.0 |
| `codify-tasks.md` | 3.0.0 | 4.0.0 |
| `codify-record.md` | 6.0.0 | 7.0.0 |

All are MAJOR. The same input now produces different paths and lines, a standard needs a structure, and the record gains a **Files** field.

No complexity exception is required.

### Post-design re-check

PASS. Features own their lines. The layout lives in the standard, not the catalog. The completion message is unchanged from spec 206.

## Project Structure

### Documentation (this feature)

```text
specs/208-codify-file-layout/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── standard-structure.md
│   ├── task-list.md
│   ├── proposal-files.md
│   └── seed-removal.md
├── checklists/
│   └── requirements.md
└── tasks.md
```

### Source Code (repository root)

```text
.highway/skills/highway-codify-config/SKILL.md
.highway/skills/highway-codify/SKILL.md
.highway/library/templates/output/coding-standard.md
.highway/library/templates/output/codify-tasks.md
.highway/library/templates/output/codify-record.md
.highway/tools/.distribution-manifest
library/coding-standards/coding-standards.md      (removed)
library/coding-standards/terraform.md             (removed)
.highway/tools/tests/codify-file-layout.test.sh   (new)
.highway/tools/tests/highway-codify.test.sh
.highway/tools/tests/codify-config-skill.test.sh
.highway/tools/tests/codify-platform-catalog.test.sh
.highway/tools/tests/codify-closing-guide.test.sh
```

**Structure Decision**: `highway-codify-config` owns the layout because it owns the standard. `highway-codify` reads the layout to place files and never writes a standard or the catalog. The task list is ordered by feature. The layout only decides placement.

## Complexity Tracking

> No constitution violation requires a justification table.
