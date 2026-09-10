# Implementation Plan: Profile Setup Readiness and Zero-NFR Completion

**Branch**: `035-profile-setup-readiness` | **Date**: 2026-09-10 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/035-profile-setup-readiness/spec.md`

## Summary

Make `highway-profile` the authoritative owner of organization identity and Profile completeness, make `highway-setup` a numbered and internally verifiable orchestration workflow, and define `NFRs: Not Applicable` as the deterministic terminal state for valid Controls that generate zero NFR candidates.

## Technical Context

**Language/Version**: Markdown skill contracts; Bash 3.2-compatible verification fixtures

**Primary Dependencies**: Existing `highway-profile`, `highway-setup`, `highway-controls`, `highway-nfrs`, validator scripts, and repository test fixtures

**Storage**: Existing Profile, Control, Objective, and NFR artifacts; no new artifact store

**Testing**: Focused Profile and Setup contract tests, workflow-number integrity assertions, zero-candidate fixtures, profile validator, skill validator, adapter coverage, and full repository suite

**Target Platform**: macOS Bash 3.2-compatible development environment and distributed Highway skill trees

**Project Type**: Markdown-based governance skills and Bash validation suite

**Performance Goals**: Deterministic single-pass readiness evaluation; no service latency target

**Constraints**: Preserve owner confirmation gates, do not duplicate Profile validity in Setup, do not fabricate NFRs, satisfy P8.1 numbered workflow requirements, and regenerate derived artifacts after source changes

**Scale/Scope**: Two source skills, one focused test area, four readiness paths, one workflow integrity check, and one zero-candidate terminal state

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **D3.1-D3.3**: PASS by plan. Capture a passing suite baseline, amend focused tests, and rerun the full suite after edits.
- **D3.5-D3.6**: PASS by plan. Preserve existing assertions and record failing-before-passing evidence for new Profile, workflow-numbering, and zero-candidate checks.
- **D4.1, D4.5-D4.7**: PASS by plan. Regenerate catalogs, adapter manifests, distribution manifests, and agent adapters after source skill changes without hand-editing generated outputs.
- **D7.1-D7.3**: PASS by plan. Tasks will name changed artifacts, coverage will map every FR exactly once, and final reporting will separate checks from coverage.

### Highway Skills Constitution

- **P3.1-P3.5**: PASS by citation. P8.1 and repository constitution rules are treated as the governing written policy source.
- **P5.1-P5.5**: PASS by design. Profile setup, numbered workflow validation, and zero-candidate handling each define failure conditions and one next action.
- **P6.1-P6.6**: PASS by design. Profile readiness and NFR candidate outcomes use ordered decision tables with explicit default branches.
- **P7.3**: PASS by ownership. Setup references the Profile owner contract rather than restating Profile field rules.
- **P8.1-P8.4**: PASS by design. Setup steps are sequentially numbered and the quickstart names executable verification commands.

**Gate status**: PASS for design. Recheck after the contracts and quickstart are complete.

## Project Structure

### Documentation (this feature)

```text
specs/035-profile-setup-readiness/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/           # Phase 1 output (/speckit-plan command)
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source and Test Artifacts

```text
.highway/
├── skills/highway-profile/SKILL.md
├── skills/highway-setup/SKILL.md
└── tools/tests/
    ├── profile-structure.test.sh
    ├── profile-behavior.test.sh
    ├── highway-setup.test.sh
    ├── test-helpers.sh
    └── fixtures/feature-035/README.md
```

Generated catalogs and agent adapters remain derived outputs and are refreshed only through the repository generators.

**Structure Decision**: Keep ownership changes in the existing Profile and Setup skills, use the existing Controls contract as the source of candidate results, and store Feature 035 contracts and evidence under the development-only specification directory.

## Phase 0: Research

Resolve the existing Profile artifact contract, Setup workflow numbering expectations, and Control-derived NFR zero-candidate semantics. Record the decisions in `research.md`.

## Phase 1: Design and Contracts

Create the Profile readiness contract, numbered workflow contract, NFR candidate outcome table, data model, and runnable quickstart. Re-evaluate the constitution gate after these artifacts are complete.

## Complexity Tracking

No constitution violation or complexity exception is required.
