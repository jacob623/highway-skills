Implementation Plan: Controls Alignment Recommendation

**Branch**: `170-controls-alignment-recommendation` | **Date**: 2026-10-14 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/170-controls-alignment-recommendation/spec.md`

## Summary

Align the authoritative `highway-controls` skill with the proposal-first interaction model already established by `highway-objectives`. Recommendations become the normal entry point, selection creates an ordered development queue without persistence, and capture remains gated by proposal review, explicit acceptance, and the existing Control owner. Coverage Areas supplement context-grounded recommendations internally, while existing Control records, classification, ownership, persistence, and Control-derived NFR behavior remain unchanged.

The implementation will update the source skill, add or amend focused executable contract tests, regenerate all derived adapters/catalog/manifest artifacts, and validate both distributed correspondence and the full repository suite.

## Technical Context

**Language/Version**: Markdown skill contracts and Bash 3.2.57-compatible validation scripts

**Primary Dependencies**: Existing Highway skill library, Experience Standard, generator scripts, and shell test harness

**Storage**: Existing Markdown Control records and catalog under `.highway/library/governance/`; no new retained fields or artifacts

**Testing**: `.highway/tools/tests/run-all.sh` plus focused Controls, generated-adapter, catalog, and distribution checks

**Target Platform**: macOS and Linux-compatible shell environments supported by the repository

**Project Type**: Source-first conversational skill suite with generated agent adapters

**Performance Goals**: Preserve existing deterministic generation and validation behavior; no new runtime performance target is introduced

**Constraints**: Preserve existing public output contracts and retained Control schema; do not expose Coverage Areas; do not modify `highway-profile`; keep scripts Bash 3.2.57-compatible; regenerate derived artifacts rather than hand-editing them

**Scale/Scope**: One authoritative skill, its focused tests, four generated agent trees, catalog/manifest correspondence, and repository-wide regression validation

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Rule | Status | Evidence / Plan |
|---|---|---|
| D1.5 | PASS | This plan records a Constitution Check because the authoritative skill and its library-facing behavior will change. |
| D1.4 | PASS | This plan cites rule IDs and does not reproduce constitution rule text. |
| D3.1 | PASS | The repository suite was clean before this planning/implementation phase: 92 passed, 0 failed. |
| D3.2 | REQUIRED | The full suite will be rerun after implementation and regeneration. |
| D3.3 | REQUIRED | Focused Controls tests will be added or amended for the behavioral interaction change. |
| D4.1/D4.7 | REQUIRED | Generated adapters, catalogs, and manifests will be regenerated from the changed source skill. |
| D2.4 | PASS | No runtime package, interpreter, binary, or other dependency is introduced. |

No gate violation or complexity exception is identified.

## Project Structure

### Documentation (this feature)

```text
specs/170-controls-alignment-recommendation/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
└── tasks.md
```

### Source Code (repository root)

```text
.highway/
├── skills/highway-controls/SKILL.md       # authoritative source contract
├── tools/tests/                            # executable contract and regression tests
├── tools/generate-agent-adapters.sh        # derived adapter generator
├── tools/generate-catalog.sh               # derived catalog generator
└── library/                                # retained records, templates, and knowledge
.github/skills/highway-controls/SKILL.md    # generated adapter
.claude/skills/highway-controls/SKILL.md    # generated adapter
.cursor/skills/highway-controls/SKILL.md    # generated adapter
.agents/skills/highway-controls/SKILL.md    # generated adapter
.highway/catalog/                           # generated indexes and manifests
```

**Structure Decision**: Preserve the repository's source-first structure. Behavior is authored in `.highway/skills/highway-controls/SKILL.md`; focused tests live under `.highway/tools/tests/`; generated adapters and catalogs are refreshed by the existing generators; feature artifacts remain under the Feature 170 directory. No new source project or external contract directory is needed.

## Phase 0: Research

Research will resolve implementation boundaries rather than introduce technology choices:

1. Compare the existing Controls contract with the Objectives proposal-first contract and identify reusable response-support, recommendation, queue, proposal, continuation, and portfolio patterns.
2. Trace the current Control persistence, classification, relationship, and Control-derived NFR boundaries so the interaction change does not alter retained ownership or downstream behavior.
3. Identify the focused executable tests and generator correspondence checks that must change with the authoritative skill.

The resulting `research.md` records decisions, rationale, and rejected alternatives. There are no unresolved technology unknowns.

## Phase 1: Design

`data-model.md` documents the transient recommendation, queue, proposal, coverage, accepted-Control, and portfolio-assessment entities and their state boundaries. `quickstart.md` documents focused and full-suite validation. No `contracts/` directory is generated because this is an internal Markdown skill contract with no external API, endpoint, or serialized interface beyond the existing owner output contracts documented in the authoritative skill.

## Complexity Tracking

None. The feature extends one existing skill and its established validation and generation surfaces.
