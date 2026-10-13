# Implementation Plan: Profile Structured Proposals

**Branch**: `167-profile-structured-proposals` | **Date**: 2026-10-13 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/167-profile-structured-proposals/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Add proposal-first, structured Discovery Contribution Opportunities for Vision, Competitive Path,
and Guiding Principles in the source `highway-profile` skill. Ground starting points in accepted
Profile context, preserve focused questions when evidence is insufficient, retain the existing
convergence and acceptance boundaries, regenerate the four identity-copy adapters, and add a
focused static document-contract test.

## Technical Context

**Language/Version**: Markdown source and Bash 3.2-compatible validation scripts

**Primary Dependencies**: Existing Highway skill validator, adapter generator, and test harness

**Storage**: N/A; starting points are Working Ideas and no new Profile data is persisted

**Testing**: Focused Bash static-document-contract test and `.highway/tools/tests/run-all.sh`

**Target Platform**: Highway distributed tree and declared agent adapter trees

**Project Type**: Git-native documentation and skill distribution system

**Performance Goals**: N/A; this feature changes guidance text and static validation only

**Constraints**: Source-first editing; adapters remain byte-identical identity copies; no new runtime
dependency, persisted schema, lifecycle state, or external integration

**Scale/Scope**: One source skill, four generated adapters, one focused contract test, and the full
existing validation suite

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Process Gates

- Packaging Gate: **PASS** — the shipped Profile skill path is touched; the source remains
  validator-compatible and the distributed copies will be regenerated.
- Correspondence Gate: **PASS** — a declared generator input changes; D4.5-D4.7 will be satisfied
  by regenerating all declared adapters and checking source/output correspondence.
- Validation Gate: **PASS** — a focused static contract test will cover the three new opportunities,
  protected boundaries, and adapter equality; D3.1-D3.8 remain satisfied.
- Generator Gate: **N/A** — no generator script changes.
- Toolchain Gate: **N/A** — no `.highway/tools/` implementation script changes are required.

### Skill Content Gate

- **PASS** — the Profile skill remains governed by the Highway Skills Constitution and Experience
  Standard. The change preserves accepted-context grounding, user authority, Working Idea status,
  Contribution Opportunity boundaries, focused-question fallback, and existing owner-controlled
  convergence and persistence behavior.

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
├── skills/highway-profile/SKILL.md
└── tools/tests/feature-167-profile-structured-proposals.test.sh
.github/skills/highway-profile/SKILL.md
.claude/skills/highway-profile/SKILL.md
.cursor/skills/highway-profile/SKILL.md
.agents/skills/highway-profile/SKILL.md
```

**Structure Decision**: Modify the source Profile skill and focused test under `.highway/`, then
regenerate the four declared identity-copy adapters. The test is auto-discovered by `run-all.sh`;
no runtime source tree, data store, external endpoint, or separate integration project is added.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | No constitution violation is present. |
