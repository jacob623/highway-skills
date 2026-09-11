# Implementation Plan: Highway Setup Orchestration

**Branch**: `033-highway-setup` | **Date**: 2026-09-10 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/033-highway-setup/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Create the `highway-setup` Markdown skill as the user-facing onboarding orchestrator for the existing Profile, Business Objective, Control, and NFR owner workflows. The skill will evaluate readiness in strict order, delegate missing-area mutations to the owning skill, pause at pending NFR author approval, and emit deterministic complete or in-progress dashboards. Focused Bash 3.2-compatible fixtures will validate ordering, delegation, continuation, safe stopping, idempotence, and exact output.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown skill contract; Bash 3.2-compatible test fixtures

**Primary Dependencies**: Existing Highway owner skills and `.highway/` catalog/generator tools

**Storage**: Existing user-owned Profile, Objective, Control, and NFR artifacts according to each owner contract; no new artifact store

**Testing**: `.highway/tools/validate-skill.sh`, focused Bash fixtures, `.highway/tools/tests/run-all.sh`, generator and packaging checks

**Target Platform**: Agent-facing Highway skill distribution; validation on Bash 3.2/macOS-compatible shell

**Project Type**: Markdown-based agent skill and repository governance workflow

**Performance Goals**: One deterministic readiness pass per setup continuation; no network service or throughput target

**Constraints**: Preserve owner workflows and confirmation gates; exact dashboard text; strict Profile -> Objectives -> Controls -> NFR order; no direct governance writes; no new runtime dependency; shipped tree must not reference development artifacts

**Scale/Scope**: One repository's foundational baselines and one onboarding session; six owner/admin routes in completion guidance

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Highway Development Constitution

- **D1.5**: PASS. This plan records a Constitution Check for a new skill and names the applicable Highway Skills Constitution rules below.
- **D2.4**: PASS. The design adds no package manager, interpreter, binary, or runtime dependency.
- **D3.3**: PASS by plan. The behavioral skill change includes a focused test under `.highway/tools/tests/`.
- **D4.5-D4.7**: PASS by plan. Adding the source skill requires catalog, adapter, manifest, and distribution regeneration and correspondence validation.
- **D5.4**: PASS. Feature 033 follows the sequential feature directory.
- **D7.1-D7.2**: Tracked for implementation completion. Tasks will name concrete artifacts, and a requirement-coverage record will map every requirement exactly once.

### Highway Skills Constitution

- **P1.5, P3.1-P3.5**: The skill plan will name every owner skill, file, prior step, and approved authority citation required by its normative rules.
- **P4.1-P4.6**: Each readiness and failure claim will map to a focused fixture or file-state check; no verification bypass is permitted.
- **P5.1-P5.6**: Every numbered workflow step will define failure detection and exactly one next action; retry, if needed, will have a bounded attempt count.
- **P6.1-P6.6**: The ordered readiness table is the deterministic decision structure and covers missing, empty, malformed, blocked, pending, and complete states.
- **P7.1-P7.7**: The skill will have one Purpose, semantic versioning, owner cross-references instead of duplicated rules, and normative sections within limits.
- **P8.1-P8.7**: The workflow will be numbered, ordering dependencies explicit, verification commands named, repository configuration read, and no relative filesystem links used in the shipped skill.
- **P9.1**: No new file-emitting owner artifact is introduced by `highway-setup`; existing owner templates remain authoritative.

**Gate status**: PASS for design. Implementation must preserve these conditions and rerun the repository suite before completion.

## Project Structure

### Documentation (this feature)

```text
specs/033-highway-setup/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/
│   ├── setup-output.md
│   └── owner-delegation.md
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)
```text
.highway/
├── skills/
│   └── highway-setup/
│       └── SKILL.md
└── tools/
  └── tests/
    └── highway-setup.test.sh

specs/033-highway-setup/
├── spec.md
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── setup-output.md
│   └── owner-delegation.md
└── tasks.md
```

**Structure Decision**: Add one shipped Markdown skill under `.highway/skills/highway-setup/` and one focused disposable-tree test under `.highway/tools/tests/`. Regenerate the existing catalog, agent adapters, adapter manifests, and distribution manifest rather than editing generated outputs. Keep all design and coverage records under `specs/033-highway-setup/`.

## Complexity Tracking

No constitution violations are planned; no complexity exception is required.
