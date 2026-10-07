# Implementation Plan: Setup Runtime Architecture Alignment

**Branch**: `147-setup-runtime-alignment` | **Date**: 2026-10-06 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/147-setup-runtime-alignment/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Update the existing `highway-setup` Markdown skill so it remains a thin orchestrator over the
Profile, Objectives, Controls, and NFR owners. Remove its runtime Constitution dependency, make
orchestration failure behavior explicit, preserve owner-specific result contracts and fresh-resume
semantics, and absorb only the Setup-specific transition, separation, synthesis, and final-block
presentation behavior retired from the generic Experience Standard. Validate the document with the
existing Setup contract tests plus focused assertions for the revised failure and presentation
boundaries.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown skill contract; Bash 3.2-compatible validation scripts

**Primary Dependencies**: Existing Highway owner skills and Highway Experience Standard

**Storage**: N/A; Setup persists no checkpoint or owner conversational state

**Testing**: `.highway/tools/tests/highway-setup.test.sh`, `setup-owner-loop-contract.test.sh`,
`highway-setup-executable.test.sh`, related readiness-owner tests, and the full test suite

**Target Platform**: Highway skill runtime and distributed Markdown skill adapters

**Project Type**: Internal Markdown skill contract with shell-based document and executable tests

**Performance Goals**: No new runtime performance target; orchestration remains bounded by the
existing owner interaction contracts

**Constraints**: Do not modify owner skills in this feature; do not create a common result schema;
do not add persistence, convergence, advisory, or artifact-acceptance logic to Setup; preserve
existing welcome, transition, and completion copy unless required by the clarified boundary

**Scale/Scope**: One shipped skill, its Setup-specific tests, and the Feature 147 design records

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- D1.3/D1.4: PASS. The plan and implementation will reference the Experience Standard and owner
  contracts rather than restating their generic rules or introducing a competing runtime contract.
- D3.1-D3.5: PASS. Existing focused tests and the full suite will validate the revised document;
  requirements and implementation behavior remain traceable through the feature records.
- D4.5-D4.7: N/A. No generated adapter or catalog output is changed by this feature.
- D6.1-D6.2: PASS. Setup documentation and its verification section will remain current with the
  revised runtime boundary and will not introduce stale Constitution references.
- D8.1: N/A. No shared library artifact is changed.

## Project Structure

### Documentation (this feature)

```text
specs/147-setup-runtime-alignment/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/           # Not applicable: no external interface
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
├── skills/highway-setup/SKILL.md
└── tools/tests/
  ├── highway-setup.test.sh
  ├── highway-setup-executable.test.sh
  ├── readiness-owner-states.test.sh
  ├── readiness-ownership.test.sh
  └── setup-owner-loop-contract.test.sh
```

**Structure Decision**: Update the existing Setup skill and its focused shell validators. No
runtime source tree, storage layer, API, generated artifact, or external contract is introduced.

## Complexity Tracking

No Constitution violations require justification.
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
