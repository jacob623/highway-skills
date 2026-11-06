# Implementation Plan: Single Rule Shape

**Branch**: `221-single-rule-shape` | **Date**: 2026-11-06 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/221-single-rule-shape/spec.md`

## Summary

`highway-codify-config` writes each coding rule as one must, one condition, and one outcome, in eight words or fewer. The model suggests at most fifteen rules. Rules the person provides are kept beyond that, and a rule that lacks must, runs past eight words, or combines rules is rewritten before the proposal is shown. The rewrite is named in the opening consequence sentence. **Why it matters:** sits under each rule on the proposal and is not saved.

## Technical Context

**Language/Version**: Markdown skill source, Bash 3.2.57-compatible repository tests

**Primary Dependencies**: `.highway/skills/highway-codify-config/SKILL.md`. Template `.highway/library/templates/output/coding-standard.md`. Validator `validate-skill.sh`. Generators `generate-catalog.sh`, `generate-agent-adapters.sh`, and `generate-library-catalog.sh`

**Storage**: The saved standard and the catalog cell keep the rule line only. The template skeleton changes. The catalog row format does not

**Testing**: New `.highway/tools/tests/single-rule-shape.test.sh`, observed failing first. Pins and moved assertions in [research.md](research.md) R4. Then `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skills

**Performance Goals**: N/A

**Constraints**: `rule shape` and `standard rules` each stay at or under 250 words. `standard proposal` stays at or under 400. New and changed steps are a condition, then an action, or a named next step. No new or changed step contains so that, because, in order to, should, consider, prefer, usually, or where appropriate. The skill body does not gain MUST or SHOULD. No shipped path references `.specify/` or `specs/`

**Scale/Scope**: One skill, one template, one new test, eight skill version pins, two template version pins, six moved assertions

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Process gates, from `.specify/memory/constitution.md`:

- **Packaging Gate**: PASS. No manifest change. No shipped file gains a `.specify/` or `specs/` reference (D1.1).
- **Toolchain Gate**: PASS. The new test uses `awk` and `grep` only (D2.1 through D2.4).
- **Generator Gate**: N/A. No `generate-*.sh` script changes.
- **Correspondence Gate**: PASS. The skill catalog, the adapters, and the library catalog are regenerated (D4.5 through D4.7).
- **Validation Gate**: PASS with recorded replacements in R4 (D3.5).
- **Verification**: D3.1 needs a passing suite before the first edit, and D3.2 after the last. D3.3 is met by the new test. D3.6 needs the new test observed failing first.
- **Shared library review (D8.1)**: PASS pending `validate-skill.sh` on `highway-codify-config`, the skill that cites `coding-standard.md`.

Skill content gates, from `.highway/governance/constitution.md`:

- PASS pending `validate-skill.sh`. `rule shape` holds the word limit, the split, and the rewrite. `standard rules` keeps its step numbers and follows that step.

Version bump: `highway-codify-config` 3.2.3 to 3.2.4. PATCH. The proposal offers shorter rules and names a rewrite in the opening sentence. The catalog cell stays the rule text. The coding-standard template moves from 3.0.0 to 3.0.1. PATCH. The skeleton describes one rule and a suggestion cap, and it no longer caps how many rules the file holds.

No complexity exception is required.

### Post-design re-check

PASS. The contract states `rule shape` and the changed `standard rules` steps as numbered conditions and actions. The proposal shape keeps **Why it matters:** off the saved file. `standard rules` is 241 words and `rule shape` is 144, both under 250. `standard proposal` stays under 400.

## Project Structure

### Documentation (this feature)

```text
specs/221-single-rule-shape/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── rule-shape.md
└── tasks.md
```

### Source Code (repository root)

```text
.highway/skills/highway-codify-config/SKILL.md
.highway/library/templates/output/coding-standard.md
.highway/tools/tests/single-rule-shape.test.sh
.highway/tools/tests/standard-starting-point.test.sh
.highway/tools/tests/entry-level.test.sh
.highway/tools/tests/config-live-rules.test.sh
.highway/tools/tests/codify-file-layout.test.sh
.highway/tools/tests/codify-config-skill.test.sh
.highway/tools/tests/configure-handoff.test.sh
.highway/tools/tests/platform-starting-point.test.sh
.highway/tools/tests/group-realized-capabilities.test.sh
```

**Structure Decision**: The skill is the source. The coding-standard template is the saved-file skeleton. Tests pin both. The skill catalog, the adapters, and the library catalog are generated.

## Complexity Tracking

No constitution violation requires a justification.
