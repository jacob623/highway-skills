# Implementation Plan: Group Realized Capabilities

**Branch**: `220-group-realized-capabilities` | **Date**: 2026-11-06 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/220-group-realized-capabilities/spec.md`

## Summary

`current` in `highway-codify-config` groups captured platform capabilities that perform the same automation, judged by meaning. The title names the automation as one noun phrase of five words or fewer. A product name and a handoff go in the evidence. A grouped capability is marked new only when the implementation does not already mean it. Steps 1 through 3 stay. Steps 4 through 7 become steps 4 through 9.

## Technical Context

**Language/Version**: Markdown skill source, Bash 3.2.57-compatible repository tests

**Primary Dependencies**: `.highway/skills/highway-codify-config/SKILL.md`. Validator `validate-skill.sh`. Generators `generate-catalog.sh` and `generate-agent-adapters.sh`

**Storage**: N/A. No template or catalog format changes

**Testing**: New `.highway/tools/tests/group-realized-capabilities.test.sh`, observed failing first. Pins and moved assertions in [research.md](research.md) R3. Then `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skills

**Performance Goals**: N/A

**Constraints**: `current` stays at or under 400 words. New and changed steps are a condition, then an action, or a named next step. No new or changed step contains so that, because, in order to, should, consider, prefer, usually, or where appropriate. The skill body does not gain MUST or SHOULD. No shipped path references `.specify/` or `specs/`

**Scale/Scope**: One skill, one new test, seven version pins, three moved assertions

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Process gates, from `.specify/memory/constitution.md`:

- **Packaging Gate**: PASS. No manifest change. No shipped file gains a `.specify/` or `specs/` reference (D1.1).
- **Toolchain Gate**: PASS. The new test uses `awk` and `grep` only (D2.1 through D2.4).
- **Generator Gate**: N/A. No `generate-*.sh` script changes.
- **Correspondence Gate**: PASS. The skill catalog and the adapters are regenerated (D4.5 through D4.7). No library file changes.
- **Validation Gate**: PASS with recorded replacements in R3 (D3.5).
- **Verification**: D3.1 needs a passing suite before the first edit, and D3.2 after the last. D3.3 is met by the new test. D3.6 needs the new test observed failing first.
- **Shared library review (D8.1)**: PASS pending `validate-skill.sh`.

Skill content gates, from `.highway/governance/constitution.md`:

- PASS pending `validate-skill.sh`. The grouping fits inside `current`, the step that already captures and marks capabilities.

Version bump: `highway-codify-config` 3.2.2 to 3.2.3. PATCH. Grouping changes which capabilities are proposed and how they are titled. The proposal shape, the catalog, and the implementation handoff keep their format.

No complexity exception is required.

### Post-design re-check

PASS. The contract states each `current` step as a numbered condition and action, in the order capture, group, title, mark.

## Project Structure

### Documentation (this feature)

```text
specs/220-group-realized-capabilities/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── current-steps.md
└── tasks.md
```

### Source Code (repository root)

```text
.highway/skills/highway-codify-config/SKILL.md
.highway/tools/tests/group-realized-capabilities.test.sh
.highway/tools/tests/platform-starting-point.test.sh
.highway/tools/tests/entry-level.test.sh
.highway/tools/tests/standard-starting-point.test.sh
.highway/tools/tests/codify-config-skill.test.sh
.highway/tools/tests/config-live-rules.test.sh
.highway/tools/tests/codify-file-layout.test.sh
.highway/tools/tests/configure-handoff.test.sh
```

**Structure Decision**: The skill is the source. Tests pin its text and version. The catalog and adapters are generated.

## Complexity Tracking

No constitution violation requires a justification.
