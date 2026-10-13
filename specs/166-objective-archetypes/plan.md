# Implementation Plan: Objective Archetypes

**Branch**: `166-objective-archetypes` | **Date**: 2026-10-13 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/166-objective-archetypes/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Add an `Objective Archetypes` guidance section to the source `highway-objectives` skill between
Recommendation Development and the Objective Development Lifecycle. Keep accepted Profile evidence
as the preferred recommendation source, use four internal archetype families only to identify
meaningful coverage gaps, present any resulting recommendations as one unified set, and preserve all
existing Objective ownership, acceptance, persistence, and lifecycle boundaries. Regenerate the four
identity-copy adapters and add a static document-contract test.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown source and Bash 3.2-compatible validation scripts

**Primary Dependencies**: Existing Highway skill validator, adapter generator, and test harness

**Storage**: N/A; no Objective Archetype or coverage data is persisted

**Testing**: Focused Bash static-document-contract test and `.highway/tools/tests/run-all.sh`

**Target Platform**: Highway distributed tree and declared agent adapter trees

**Project Type**: Git-native documentation and skill distribution system

**Performance Goals**: N/A; this feature changes guidance text and static validation only

**Constraints**: Source-first editing; adapters must remain byte-identical identity copies; no new
runtime dependency, persisted schema, lifecycle state, or external integration

**Scale/Scope**: One source skill, four generated adapters, one focused contract test, and the full
existing validation suite

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Process Gates

- Packaging Gate: **PASS** — the shipped skill path is touched; D1.1 and D6.2 remain satisfied,
  and the distributed tree remains validator-compatible.
- Correspondence Gate: **PASS** — a declared generator input changes; D4.5-D4.7 are satisfied by
  regenerating all declared adapters and checking source/output correspondence.
- Validation Gate: **PASS** — a new static contract test is added and evaluated against the existing
  test harness; D3.4 and D3.5 require fixture coverage and no weakened assertions.
- Generator Gate: **N/A** — no generator script changes.
- Toolchain Gate: **N/A** — no `.highway/tools/` implementation script changes are required.

### Skill Content Gate

- **PASS** — the source skill remains governed by the Highway Skills Constitution and Experience
  Standard. The change preserves accepted-context grounding, user authority, Working Idea status,
  recommendation limits, and existing owner-controlled lifecycle and persistence behavior.

Relevant development rules: D1.5, D3.1-D3.8, D4.1, D4.4-D4.7, D6.1-D6.2, and D8.1.
No violations require Complexity Tracking.

## Project Structure

### Documentation (this feature)

```text
specs/[###-feature]/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/           # Phase 1 output (/speckit-plan command)
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)
<!--
  ACTION REQUIRED: Replace the placeholder tree below with the concrete layout
  for this feature. Delete unused options and expand the chosen structure with
  real paths (e.g., apps/admin, packages/something). The delivered plan must
  not include Option labels.
-->

```text
.highway/
├── skills/highway-objectives/SKILL.md
└── tools/tests/feature-166-objective-archetypes.test.sh
.github/skills/highway-objectives/SKILL.md
.claude/skills/highway-objectives/SKILL.md
.cursor/skills/highway-objectives/SKILL.md
.agents/skills/highway-objectives/SKILL.md
```

**Structure Decision**: Modify the source skill and focused test under `.highway/`, then regenerate
the four declared identity-copy adapters. The test is auto-discovered by `run-all.sh`; no runtime
source tree, data store, contract endpoint, or separate integration project is introduced.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | No constitution violation is present. |
