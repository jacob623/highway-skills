# Implementation Plan: Labeled Proposal Lines

**Branch**: `222-labeled-proposal-lines` | **Date**: 2026-11-06 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/222-labeled-proposal-lines/spec.md`

## Summary

`highway-codify-config` moves **Recommendation:** and **Evidence:** onto their own bold line, after a blank line and indented three spaces, the way **Why it matters:** sits under an entry. Recommendation changes in the platform proposal, the standard proposal, and the `conflicts` list. Evidence changes under New Realized Capabilities in the platform proposal. No step text, rule, or saved format changes.

## Technical Context

**Language/Version**: Markdown skill source, Bash 3.2.57-compatible repository tests

**Primary Dependencies**: `.highway/skills/highway-codify-config/SKILL.md`. Validator `validate-skill.sh`. Generators `generate-catalog.sh` and `generate-agent-adapters.sh`

**Storage**: N/A. No template, catalog, or record changes

**Testing**: New `.highway/tools/tests/labeled-proposal-lines.test.sh`, observed failing first. Pins and moved assertions in [research.md](research.md) R2. Then `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skills

**Performance Goals**: N/A

**Constraints**: `platform proposal` and `standard proposal` each stay at or under 400 words. `conflicts` stays at or under 250. The skill body does not gain MUST or SHOULD. No shipped path references `.specify/` or `specs/`

**Scale/Scope**: One skill, four shape lines, one new test, nine version pins, one moved assertion

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Process gates, from `.specify/memory/constitution.md`:

- **Packaging Gate**: PASS. No manifest change. No shipped file gains a `.specify/` or `specs/` reference (D1.1).
- **Toolchain Gate**: PASS. The new test uses `awk` and `grep` only (D2.1 through D2.4).
- **Generator Gate**: N/A. No `generate-*.sh` script changes.
- **Correspondence Gate**: PASS. The skill catalog and the adapters are regenerated (D4.5 through D4.7). No library file changes.
- **Validation Gate**: PASS with the recorded replacement in R2 (D3.5).
- **Verification**: D3.1 needs a passing suite before the first edit, and D3.2 after the last. D3.3 is met by the new test. D3.6 needs the new test observed failing first.
- **Shared library review (D8.1)**: N/A. No shared library file changes. `validate-skill.sh` still runs on the changed skill.

Skill content gates, from `.highway/governance/constitution.md`:

- PASS pending `validate-skill.sh`. Only output shapes change. No step gains a decision.

Version bump: `highway-codify-config` 3.2.4 to 3.2.5. PATCH. The shown layout changes. No field, rule, or saved format changes.

No complexity exception is required.

### Post-design re-check

PASS. Each shape in [contracts/shapes.md](contracts/shapes.md) uses the blank line and three-space indent that **Why it matters:** uses. Each step keeps its word count, per R3.

## Project Structure

### Documentation (this feature)

```text
specs/222-labeled-proposal-lines/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── shapes.md
└── tasks.md
```

### Source Code (repository root)

```text
.highway/skills/highway-codify-config/SKILL.md
.highway/tools/tests/labeled-proposal-lines.test.sh
.highway/tools/tests/platform-starting-point.test.sh
.highway/tools/tests/group-realized-capabilities.test.sh
.highway/tools/tests/config-live-rules.test.sh
.highway/tools/tests/codify-config-skill.test.sh
.highway/tools/tests/standard-starting-point.test.sh
.highway/tools/tests/entry-level.test.sh
.highway/tools/tests/single-rule-shape.test.sh
.highway/tools/tests/codify-file-layout.test.sh
.highway/tools/tests/configure-handoff.test.sh
```

**Structure Decision**: The skill is the source. Tests pin its shapes and version. The catalog and adapters are generated.

## Complexity Tracking

No constitution violation requires a justification.
