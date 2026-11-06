# Implementation Plan: Standard Starting Point

**Branch**: `218-standard-starting-point` | **Date**: 2026-11-05 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/218-standard-starting-point/spec.md`

## Summary

`highway-codify-config` gains the standard starting-point line and a `standard rules` step that holds the rule-building paragraph as numbered steps. `standard proposal` follows `standard rules`, then `use entries`, and assesses conflicts as `conflicts` does. `Classify` tests the reply classes in a fixed order. `platforms` applies its name rules to a name carried from Entry without emitting the list. Four yes or no asks state `question`, `unknown`, and `decline`. `conflicts`, `resolve`, and the close of both proposals become numbered steps. `use entries` moves after `current`, and `standard rules` stands after `standards`.

## Technical Context

**Language/Version**: Markdown skill source, Bash 3.2.57-compatible repository tests

**Primary Dependencies**: `.highway/skills/highway-codify-config/SKILL.md`. Validator `validate-skill.sh`. Generators `generate-catalog.sh` and `generate-agent-adapters.sh`

**Storage**: N/A. No template or catalog format changes

**Testing**: New `.highway/tools/tests/standard-starting-point.test.sh`, observed failing first. Pins and moved assertions in [research.md](research.md) R6. Then `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skills

**Performance Goals**: N/A

**Constraints**: `standard rules` stays at or under 250 words. `Classify`, `platform proposal`, `standard proposal`, `conflicts`, and `resolve` stay at or under 400 words. New sentences are a condition, then an action, or a named next step. No new or changed step contains so that, because, in order to, should, consider, prefer, usually, or where appropriate. The skill body does not gain MUST or SHOULD. No shipped path references `.specify/` or `specs/`

**Scale/Scope**: One skill, one new test, five pin moves, four moved assertions, one changed word-count check

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Process gates, from `.specify/memory/constitution.md`:

- **Packaging Gate**: PASS. No manifest change. No shipped file gains a `.specify/` or `specs/` reference (D1.1).
- **Toolchain Gate**: PASS. The new test uses `awk` and `grep` only (D2.1 through D2.4).
- **Generator Gate**: N/A. No `generate-*.sh` script changes.
- **Correspondence Gate**: PASS. The skill catalog and the adapters are regenerated (D4.5 through D4.7). No library file changes.
- **Validation Gate**: PASS with recorded replacements in R6 (D3.5).
- **Verification**: D3.1 needs a passing suite before the first edit, and D3.2 after the last. D3.3 is met by the new test. D3.6 needs the new test observed failing first.
- **Shared library review (D8.1)**: PASS pending `validate-skill.sh`.

Skill content gates, from `.highway/governance/constitution.md`:

- PASS pending `validate-skill.sh`. Rule building does not fit `standard proposal` within 400 words, so it is its own step, `standard rules`. Every other change numbers sentences inside the step that already owns them.

Version bump: `highway-codify-config` 3.2.0 to 3.2.1. PATCH. One emitted line, moved instructions with the same meaning, and steps that state behavior Verification already describes. No contract is narrowed.

No complexity exception is required.

### Post-design re-check

PASS. The contract states `standard rules`, the proposal closes, `conflicts`, `resolve`, and `Classify` as numbered steps. Each branch names its next step. Heading order follows the flow.

## Project Structure

### Documentation (this feature)

```text
specs/218-standard-starting-point/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── config-steps.md
└── tasks.md
```

### Source Code (repository root)

```text
.highway/skills/highway-codify-config/SKILL.md
.highway/tools/tests/standard-starting-point.test.sh
.highway/tools/tests/config-live-rules.test.sh
.highway/tools/tests/platform-starting-point.test.sh
.highway/tools/tests/codify-config-skill.test.sh
.highway/tools/tests/codify-file-layout.test.sh
.highway/tools/tests/configure-handoff.test.sh
```

**Structure Decision**: The skill is the source. Tests pin its text and version. The catalog and adapters are generated.

## Complexity Tracking

No constitution violation requires a justification.
