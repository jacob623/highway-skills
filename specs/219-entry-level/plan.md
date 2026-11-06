# Implementation Plan: Entry Level

**Branch**: `219-entry-level` | **Date**: 2026-11-06 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/219-entry-level/spec.md`

## Summary

`highway-codify-config` gains `entry level`, nine numbered steps between `current` and `use entries` that propose When to use and When not to use as classes of automation, at most four per list, with no task. On an add, `use entries` follows `entry level`. On an update, it keeps saved entries. Both proposal shapes put a blank line between each entry and **Why it matters:**, and that sentence states the consequence of the entry. Both shapes drop **Consequences:**. A dropped rule and a remove's kept file are stated in the opening consequence sentence. The Coding Standards rules do not change.

## Technical Context

**Language/Version**: Markdown skill source, Bash 3.2.57-compatible repository tests

**Primary Dependencies**: `.highway/skills/highway-codify-config/SKILL.md`. Validator `validate-skill.sh`. Generators `generate-catalog.sh` and `generate-agent-adapters.sh`

**Storage**: N/A. No template or catalog format changes. The coding standard template keeps "This file does not contain a Why it matters line."

**Testing**: New `.highway/tools/tests/entry-level.test.sh`, observed failing first. Pins and moved assertions in [research.md](research.md) R5. Then `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skills

**Performance Goals**: N/A

**Constraints**: `entry level` and `use entries` stay at or under 250 words. `platform proposal` and `standard proposal` stay at or under 400. New and changed steps are a condition, then an action, or a named next step. No new or changed step contains so that, because, in order to, should, consider, prefer, usually, or where appropriate. The skill body does not gain MUST or SHOULD. No shipped path references `.specify/` or `specs/`

**Scale/Scope**: One skill, one new test, six version pins, and moved assertions in three tests

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Process gates, from `.specify/memory/constitution.md`:

- **Packaging Gate**: PASS. No manifest change. No shipped file gains a `.specify/` or `specs/` reference (D1.1).
- **Toolchain Gate**: PASS. The new test uses `awk` and `grep` only (D2.1 through D2.4).
- **Generator Gate**: N/A. No `generate-*.sh` script changes.
- **Correspondence Gate**: PASS. The skill catalog and the adapters are regenerated (D4.5 through D4.7). No library file changes.
- **Validation Gate**: PASS with recorded replacements in R5 (D3.5).
- **Verification**: D3.1 needs a passing suite before the first edit, and D3.2 after the last. D3.3 is met by the new test. D3.6 needs the new test observed failing first.
- **Shared library review (D8.1)**: PASS pending `validate-skill.sh`.

Skill content gates, from `.highway/governance/constitution.md`:

- PASS pending `validate-skill.sh`. The class rules do not fit in `use entries` within 250 words, so they are their own step, `entry level`. Every other change edits the step that already owns the sentence.

Version bump: `highway-codify-config` 3.2.1 to 3.2.2. PATCH. Tighter proposal guidance, one moved label sentence, and one removed proposal section whose content moves to the entry and the opening sentence. Saved catalogs and standard files keep the same format.

No complexity exception is required.

### Post-design re-check

PASS. The contract states `entry level` and the changed `use entries` steps as numbered conditions and actions, and both shapes show the blank line and the consequence sentence.

## Project Structure

### Documentation (this feature)

```text
specs/219-entry-level/
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
.highway/tools/tests/entry-level.test.sh
.highway/tools/tests/platform-starting-point.test.sh
.highway/tools/tests/standard-starting-point.test.sh
.highway/tools/tests/codify-config-skill.test.sh
.highway/tools/tests/config-live-rules.test.sh
.highway/tools/tests/codify-file-layout.test.sh
.highway/tools/tests/configure-handoff.test.sh
```

**Structure Decision**: The skill is the source. Tests pin its text and version. The catalog and adapters are generated.

## Complexity Tracking

No constitution violation requires a justification.
