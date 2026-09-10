# Implementation Plan: Readiness Ownership Refactor

**Branch**: `037-readiness-ownership-refactor` | **Date**: 2026-09-10 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/037-readiness-ownership-refactor/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Move readiness determination into Profile, Objectives, Controls, and NFRs through explicit read-only `readiness` actions. Define one ordered four-field response contract, keep artifact validity rules with each owner, and make Setup invoke owners in order and route only from their responses. Implementation follows the existing Markdown skill and Bash test conventions; research decisions are recorded in [research.md](research.md).

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown skill specifications; Bash 3.2-compatible test scripts

**Primary Dependencies**: Existing Highway skills, artifact templates, validators, and shell utilities; no new runtime dependency

**Storage**: Existing Profile YAML, Objective/Control/NFR Markdown artifacts, catalogs, and candidate state; no new readiness artifact

**Testing**: Focused Bash tests under `.highway/tools/tests/`, `run-all.sh`, validators, static contract checks, and artifact regeneration checks

**Target Platform**: Distributed Highway skill tree on macOS and Linux-compatible Bash environments

**Project Type**: Markdown-based skill library with shell validation and generated agent adapters

**Performance Goals**: Readiness must complete as a local filesystem inspection with no network or persistent write; no latency target is required for this documentation-driven workflow

**Constraints**: Exact four-field output and status vocabulary; read-only and deterministic; Bash 3.2 portability; no duplicated owner rules in Setup; generated artifacts remain generator-owned

**Scale/Scope**: Five shipped skills, four owner state models, one ordered Setup workflow, isolated fixture matrices, and the existing generated adapter/catalog set

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The change is a new spec record and plans modifications to shipped skill content, tests, and documentation.

| Gate | Trigger | Verdict | Evidence / action |
|---|---|---|---|
| Packaging | Planned shipped skill changes | PASS | Skill content and generated-output validation are included in the design and quickstart. |
| Toolchain | Planned `.highway/tools/` test changes | PASS | Bash 3.2 and existing declared utilities only; no runtime dependency is added. |
| Generator | No generator script change planned | N/A | Existing generators are run for correspondence verification. |
| Correspondence | Planned skill input changes | PASS | Regenerate/check catalog, adapters, manifests, and distribution correspondence. |
| Validation | New readiness tests and helpers planned | PASS | Existing fixtures are preserved; focused tests cover owner behavior and Setup routing. |
| Spec Record | Feature 037 spec directory is new | PASS | Sequential directory 037 is active; no completed spec is edited. |
| Skill Content | Planned `.github/skills/` changes | PASS | Design preserves required frontmatter/body sections and delegates content checks to the Highway Skills Constitution. |

No gate violation requires a complexity exception.

## Project Structure

### Documentation (this feature)

```text
specs/037-readiness-ownership-refactor/
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
.github/skills/
├── highway-profile/SKILL.md
├── highway-objectives/SKILL.md
├── highway-controls/SKILL.md
├── highway-nfrs/SKILL.md
└── highway-setup/SKILL.md
.highway/tools/tests/
├── highway-setup.test.sh
├── test-helpers.sh
└── readiness-ownership.test.sh
specs/037-readiness-ownership-refactor/
├── contracts/
├── data-model.md
├── quickstart.md
├── research.md
└── spec.md
```

**Structure Decision**: Extend the five existing skill documents and the existing Bash test harness. Add Feature 037's design records and contracts under its spec directory. Generated catalogs and agent adapters remain outputs of their existing generators and are not hand-edited.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., 4th project] | [current need] | [why 3 projects insufficient] |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
