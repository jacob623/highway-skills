# Implementation Plan: Codify Feature Wording, Governance, and Plan

**Branch**: `213-codify-feature-wording` | **Date**: 2026-11-04 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/213-codify-feature-wording/spec.md`

## Summary

`highway-codify` shows the proposal as a codify feature, checks every active Control and NFR before that proposal, and writes a plan after acceptance. The plan check asks only a question the person has to answer. The menu offers a review or to continue. The task list is written when they continue. Each addition is its own numbered step.

## Technical Context

**Language/Version**: Markdown skill sources, Bash 3.2.57-compatible repository tests

**Primary Dependencies**: `.highway/skills/highway-codify/SKILL.md`, `.highway/library/templates/output/codify-record.md`, and `.highway/library/templates/output/codify-tasks.md`. New template `codify-plan.md`. The Controls catalog `library/governance/controls.md` and the NFRs catalog `library/governance/nfrs.md` are read when present. Validators `validate-skill.sh` and `validate-library.sh`. Generators `generate-library-catalog.sh`, `generate-catalog.sh`, and `generate-agent-adapters.sh`

**Storage**: The accepted proposal stays `codify.md`. The plan is `plan.md` beside it. The task list stays `codify-tasks.md` and is written on continue

**Testing**: New `.highway/tools/tests/codify-feature-wording.test.sh`, observed failing first. Version pins move as recorded in [research.md](research.md) R7. Then `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skills

**Performance Goals**: The plan check reads the accepted proposal, the standards, the Controls, the NFRs, and the implementation record. It asks at most five questions

**Constraints**: Each `###` step stays at or under 400 words, excluding its heading. New text is a condition, then the action. The skill body does not gain the keywords MUST or SHOULD, and does not say should, consider, prefer, usually, or where appropriate. No shipped path references `.specify/` or `specs/`

**Scale/Scope**: One skill, two changed templates, one new template, one new test, the version pins in R7

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Process gates, from `.specify/memory/constitution.md`:

- **Packaging Gate**: PASS. No manifest change. No shipped file gains a `.specify/` or `specs/` reference (D1.1).
- **Toolchain Gate**: PASS. The new test uses `awk` and `grep` only (D2.1 through D2.4).
- **Generator Gate**: N/A. No `generate-*.sh` script changes.
- **Correspondence Gate**: PASS. The library catalog, the skill catalog, and the adapters are regenerated (D4.5 through D4.7).
- **Validation Gate**: PASS with recorded replacements. Pins move for the reasons in R7 (D3.5).
- **Verification**: D3.1 needs a passing suite before the first edit, and D3.2 after the last. D3.3 is met by the new test. D3.6 needs the new test observed failing first.
- **Shared library review (D8.1)**: PASS pending `validate-skill.sh` on `highway-codify` and `validate-library.sh` on `codify-record.md`, `codify-tasks.md`, and `codify-plan.md`. `highway-codify` is the skill that cites them.

Skill content gates, from `.highway/governance/constitution.md`:

- PASS pending `validate-skill.sh`. New instructions stay imperative. `govern`, `plan`, `check`, `menu`, and `tasks` are their own steps. No step exceeds 400 words.

Version bumps:

| Source | From | To |
|---|---|---|
| `highway-codify` | 10.0.0 | 11.0.0 |
| `codify-record.md` | 8.0.0 | 9.0.0 |
| `codify-tasks.md` | 5.0.0 | 6.0.0 |
| `codify-plan.md` | none | 1.0.0 |

MAJOR. Acceptance no longer writes the task list, an edit that would break a Control or NFR is refused, and the saved feature gains the applied list.

No complexity exception is required.

### Post-design re-check

PASS. Drafted steps, excluding headings: `govern` 212, `plan` 142, `check` 108, `menu` 56, `tasks` 142. `govern` names a Control-or-NFR conflict in the proposal. `propose` is 175 and gains the heading, one sentence, and the Controls list. `project` at 395 and `suggest` at 388 are unchanged. `write` loses the task-list sentence and stays under its 250-word cap.

## Project Structure

### Documentation (this feature)

```text
specs/213-codify-feature-wording/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── feature-steps.md
└── tasks.md
```

### Source Code (repository root)

```text
.highway/skills/highway-codify/SKILL.md
.highway/library/templates/output/codify-record.md
.highway/library/templates/output/codify-tasks.md
.highway/library/templates/output/codify-plan.md          (new)
.highway/tools/tests/codify-feature-wording.test.sh      (new)
```

**Structure Decision**: `govern` follows `align` and precedes `project`. Acceptance writes the proposal, then `plan`, `check`, and `menu`. Continue is `tasks`, then `code`.

## Complexity Tracking

> No constitution violation requires a justification table.
