# Implementation Plan: Propose Edit Lines

**Branch**: `210-propose-edit-lines` | **Date**: 2026-11-03 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/210-propose-edit-lines/spec.md`

## Summary

The `edit` reply in `propose` stops being one line of 1,007 characters. Each kind of edit becomes its own line, and none of those lines exceeds 240 characters. The words of each consequence stay. The proposal block and the other replies stay. `propose` stays one step, at 392 words.

## Technical Context

**Language/Version**: Markdown skill sources, Bash 3.2.57-compatible repository tests

**Primary Dependencies**: `.highway/skills/highway-codify/SKILL.md`. Generators `generate-catalog.sh` and `generate-agent-adapters.sh`. Validator `validate-skill.sh`

**Storage**: None. This feature writes no artifact

**Testing**: New `.highway/tools/tests/propose-edit-lines.test.sh`, observed failing first. The `highway-codify` version pin moves from `9.0.0` to `9.0.1` in five tests, with reasons in [research.md](research.md) R3. Then `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skills

**Performance Goals**: None. The person sees the same proposal and the same edit result

**Constraints**: `propose` stays at or under 400 words (P7.5). No new step. No edit line exceeds 240 characters. No shipped path references `.specify/` or `specs/`

**Scale/Scope**: One changed skill, one new test, five amended version pins

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Process gates, from `.specify/memory/constitution.md`:

- **Packaging Gate**: PASS. No manifest change. No shipped file gains a `.specify/` or `specs/` reference (D1.1).
- **Toolchain Gate**: PASS. The new test uses `awk` only (D2.1 through D2.4).
- **Generator Gate**: N/A. No `generate-*.sh` script changes.
- **Correspondence Gate**: PASS. The skill catalog and adapters are regenerated (D4.5 through D4.7). The library catalog is regenerated for currency, though no template changes.
- **Validation Gate**: PASS with recorded replacements. Five version pins move from `9.0.0` to `9.0.1`. The onboarding pin in `codify-platform-catalog.test.sh` stays. Reasons are in R3 (D3.5).
- **Verification**: D3.1 needs a passing suite before the first edit, and D3.2 after the last. D3.3 is met by the new test. D3.6 needs the new test observed failing first.
- **Shared library review (D8.1)**: N/A. No shared template changes.

Skill content gates, from `.highway/governance/constitution.md`:

- PASS pending `validate-skill.sh` on `highway-codify`.

Version bumps:

| Source | From | To |
|---|---|---|
| `highway-codify` | 9.0.0 | 9.0.1 |

PATCH. The proposal the person sees and the result of each edit are unchanged.

No complexity exception is required.

### Post-design re-check

PASS. The edit lines are the same clauses, one per line. `propose` stays one step at 392 words. The longest edit line is 175 characters.

## Project Structure

### Documentation (this feature)

```text
specs/210-propose-edit-lines/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── edit-lines.md
├── checklists/
│   └── requirements.md
└── tasks.md
```

### Source Code (repository root)

```text
.highway/skills/highway-codify/SKILL.md
.highway/tools/tests/propose-edit-lines.test.sh   (new)
.highway/tools/tests/codify-file-layout.test.sh
.highway/tools/tests/codify-config-skill.test.sh
.highway/tools/tests/codify-platform-catalog.test.sh
.highway/tools/tests/codify-closing-guide.test.sh
.highway/tools/tests/codify-write-refactor.test.sh
```

**Structure Decision**: The edit handling stays inside `propose`. A new step would add a handoff the spec forbids.

## Complexity Tracking

> No constitution violation requires a justification table.
