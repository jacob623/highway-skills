# Implementation Plan: Codify Platform Catalog

**Branch**: `205-codify-platform-catalog` | **Date**: 2026-11-01 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/205-codify-platform-catalog/spec.md`

## Summary

`highway-implementation` includes a platform in `library/knowledge/codify-platforms.md` when an accepted implementation can start automation, then says it is included and points to `/highway-codify configure`. A store, a newsletter, a records product, or a backup is not included. Opening a record does not include it. Accepting it again does, including after a removal. Onboarding applies that same inclusion after it writes an implementation.

`/highway-codify configure` is handled before an implementation is chosen. It shows the catalog and asks what to add, correct, or remove. It does not start an automation.

The Provider on every task is the one platform that executes the automation. The diagram is one logical flow: that platform performs each action on that action's target. The target is not the Provider, and the diagram has no separate executor node.

## Technical Context

**Language/Version**: Markdown skill and template sources, Bash 3.2.57-compatible repository tests

**Primary Dependencies**: `.highway/skills/highway-implementation/SKILL.md`, `.highway/skills/highway-codify/SKILL.md`, `.highway/skills/highway-onboarding/SKILL.md`, `.highway/library/templates/output/codify-record.md`, `.highway/library/templates/output/codify-tasks.md`. `.highway/tools/generate-agent-adapters.sh`, `.highway/tools/generate-catalog.sh`, `.highway/tools/generate-library-catalog.sh`, `.highway/tools/validate-library.sh`, and `.highway/tools/validate-skill.sh`

**Storage**: `library/knowledge/codify-platforms.md` at the repository root, created on the first inclusion. The shape is `.highway/library/templates/output/codify-platforms.md`. Automation records already saved are not rewritten

**Testing**: New `.highway/tools/tests/codify-platform-catalog.test.sh`, observed failing before the skill edits. No existing assertion is removed. Then `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skills

**Performance Goals**: No runtime latency target

**Constraints**: The catalog is not an inventory of every accepted implementation. Each `###` section stays at or under 400 words (P7.5), and each skill keeps 12 or fewer MUST-level rules (P7.4). Bash 3.2.57 only. No new runtime dependency. No shipped path may reference `.specify/` or `specs/`

**Scale/Scope**: Three skills, one new output template, one changed output template, one task-template sentence, one new test

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Process gates, from `.specify/memory/constitution.md`:

- Packaging Gate: PASS. Only shipped skills and templates change, and none gains a `.specify/` or `specs/` reference. D1.1, D1.2, and D6.2 hold.
- Toolchain Gate: PASS. The new test uses `grep` only. D2.1 through D2.4 stay satisfied.
- Generator Gate: N/A. No `generate-*.sh` script changes.
- Correspondence Gate: PASS. D4.5 through D4.7 require regenerating the skill catalog, the library catalog, and the adapters.
- Validation Gate: N/A. No validation check is added or changed. D3.5 holds because no assertion is removed or loosened. The `[Executor]` task tag and the `executor/` folder stay, so the spec 203 assertions that require them still pass.
- D3.1 requires a passing suite before the first edit, and D3.2 after the last edit. D3.3 is met by the new test. D3.6 requires the new test to be observed failing before the skill edits.
- D8.1: `codify-record.md` is cited by `highway-codify`. The new platforms template is cited by `highway-implementation`, `highway-codify`, and `highway-onboarding`. Those three skills are re-validated.

Skill content gates, from `.highway/governance/constitution.md`:

- PASS pending `validate-skill.sh` on the three skills and `validate-library.sh` on both templates. The inclusion and configure rules are procedure text, not new MUST-level rules.

Version bumps:

| Source | From | To |
|---|---|---|
| `highway-implementation` | 5.0.0 | 6.0.0 |
| `highway-codify` | 4.0.0 | 5.0.0 |
| `highway-onboarding` | 7.0.0 | 8.0.0 |
| `codify-record.md` | 3.0.0 | 4.0.0 |
| `codify-tasks.md` | 2.0.0 | 2.0.1 |
| `codify-platforms.md` | none | 1.0.0 |

`highway-implementation` and `highway-onboarding` are MAJOR because accepting an initiator now also writes the catalog and shows the inclusion message. `highway-codify` and `codify-record.md` are MAJOR because the same automation now has a different Provider and a different diagram. `codify-tasks.md` is PATCH because the task lines and the `[Executor]` tag stay, and one explanatory sentence changes.

No complexity exception is required.

### Post-design re-check

PASS. The decisions in [research.md](research.md) keep saved automations unchanged, leave the `[Executor]` file tag in place, and stop `align` from replacing the Provider. The catalog lists only platforms that can start automation.

## Project Structure

### Documentation (this feature)

```text
specs/205-codify-platform-catalog/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── platform-catalog.md
│   ├── configure.md
│   └── provider-diagram.md
├── checklists/
│   └── requirements.md
└── tasks.md
```

### Source Code (repository root)

```text
.highway/skills/highway-implementation/SKILL.md
.highway/skills/highway-codify/SKILL.md
.highway/skills/highway-onboarding/SKILL.md
.highway/library/templates/output/codify-platforms.md
.highway/library/templates/output/codify-record.md
.highway/library/templates/output/codify-tasks.md
.highway/tools/tests/codify-platform-catalog.test.sh
```

**Structure Decision**: `highway-implementation` owns inclusion. `highway-codify` owns configure and the proposal. Onboarding writes implementations itself, so it follows the same inclusion after that write. Generated catalogs and adapters are regenerated, not edited.

## Complexity Tracking

> No constitution violation requires a justification table.
