# Implementation Plan: Codify Write Refactor

**Branch**: `209-codify-write-refactor` | **Date**: 2026-11-03 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/209-codify-write-refactor/spec.md`

## Summary

`write` in `highway-codify` stops restating the task-list line rules. It names `codify-tasks.md` and keeps the record, the catalog row, and the rule that all three are written together. Verification stops repeating the same rules.

Recommendations stop repeating automations this implementation has already accepted. A new `### codified` step reads the accepted catalog rows for the selected implementation. It leaves out a suggestion whose title is word for word an Automation Title, ignoring case. When a title's words differ but its meaning suggests the same action, it reads that automation's `codify.md` and leaves the suggestion out only when the record verifies it.

## Technical Context

**Language/Version**: Markdown skill and template sources, Bash 3.2.57-compatible repository tests

**Primary Dependencies**: `.highway/skills/highway-codify/SKILL.md`, output template `codify-tasks.md` (read only), and `code/code.md` and `code/[ID]/codify.md` in the person's project (read only). Generators `generate-catalog.sh` and `generate-agent-adapters.sh`. Validator `validate-skill.sh`

**Storage**: No new artifact. `codified` writes nothing

**Testing**: New `.highway/tools/tests/codify-write-refactor.test.sh`, observed failing first. Version pins move in `codify-file-layout.test.sh`, `codify-config-skill.test.sh`, `codify-platform-catalog.test.sh`, and `codify-closing-guide.test.sh`, with reasons in [research.md](research.md) R6. Then `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skills

**Performance Goals**: A word-for-word title match opens no automation record. A record is opened only for a row whose meaning suggests the same action

**Constraints**: `write` at most 250 words (FR-005). `suggest` is at 364 words, so the catalog check goes in a new `### codified` section, and every section stays at or under 400 words (P7.5). Frontmatter description and usage are unchanged. No shipped path references `.specify/` or `specs/`

**Scale/Scope**: One changed skill, one new test, four amended tests. No template changes

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Process gates, from `.specify/memory/constitution.md`:

- **Packaging Gate**: PASS. No manifest change. No shipped file gains a `.specify/` or `specs/` reference (D1.1).
- **Toolchain Gate**: PASS. The new test uses `grep`, `awk`, and `wc` only (D2.1 through D2.4).
- **Generator Gate**: N/A. No `generate-*.sh` script changes.
- **Correspondence Gate**: PASS. The skill catalog and adapters are regenerated (D4.5 through D4.7). The library catalog is regenerated for currency, though no template changes.
- **Validation Gate**: PASS with recorded replacements. Four version pins move from `8.0.0` to `9.0.0`. Reasons are in R6 (D3.5).
- **Verification**: D3.1 needs a passing suite before the first edit, and D3.2 after the last. D3.3 is met by the new test. D3.6 needs the new test observed failing first.
- **Shared library review (D8.1)**: N/A. No shared template changes.

Skill content gates, from `.highway/governance/constitution.md`:

- PASS pending `validate-skill.sh` on `highway-codify`.

Version bumps:

| Source | From | To |
|---|---|---|
| `highway-codify` | 8.0.0 | 9.0.0 |
| `codify-tasks.md` | 4.0.0 | 4.0.0 |

`highway-codify` is MAJOR: the same implementation can now produce a different recommendation list. The task list template is unchanged, because it already states every rule `write` repeats (R1).

No complexity exception is required.

### Post-design re-check

PASS. The template is the one statement of the task list. `codified` reads and writes nothing else. The procedure order is unchanged apart from `codified` running inside `suggest`.

## Project Structure

### Documentation (this feature)

```text
specs/209-codify-write-refactor/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── write-step.md
│   └── codified-check.md
├── checklists/
│   └── requirements.md
└── tasks.md
```

### Source Code (repository root)

```text
.highway/skills/highway-codify/SKILL.md
.highway/tools/tests/codify-write-refactor.test.sh   (new)
.highway/tools/tests/codify-file-layout.test.sh
.highway/tools/tests/codify-config-skill.test.sh
.highway/tools/tests/codify-platform-catalog.test.sh
.highway/tools/tests/codify-closing-guide.test.sh
```

**Structure Decision**: `highway-codify` keeps the task list. The template owns its shape. The catalog check is a step of `highway-codify`, because only `suggest` uses it.

## Complexity Tracking

> No constitution violation requires a justification table.
