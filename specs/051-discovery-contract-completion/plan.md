# Implementation Plan: Discovery Contract Completion

**Branch**: `051-discovery-contract-completion` | **Date**: 2026-09-19 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/051-discovery-contract-completion/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Complete the shipped Discovery skill contract by replacing its malformed Outputs section and adding
explicit Reference Implementation matching, unique counting, deterministic tie-breaking,
determinism, traceability, verification, and error-handling rules. Preserve the existing ADR
ownership boundary and validate the changed skill with the repository's shell checks.

## Technical Context

**Language/Version**: Markdown skill contract; Bash-compatible repository validation scripts

**Primary Dependencies**: Existing `highway-discovery` skill, shared Discovery output templates,
Feature 050 Reference Implementation semantics, and `.highway/tools/tests/` shell harness

**Storage**: Repository Markdown skill and validation artifacts; user-owned Discovery records and
catalogs remain governed by the existing workflow

**Testing**: Discovery skill validation, structural Markdown checks, focused Discovery test, and
full repository shell test suite

**Target Platform**: Distributed Highway skill tree on macOS and supported environments

**Project Type**: Repository governance and workflow skill suite

**Performance Goals**: Preserve the existing bounded Discovery transaction; Reference
Implementation evaluation adds no network access or unbounded search

**Constraints**: Explicit deterministic references only; advisory evidence only; no score or
confidence mutation; no ADR ownership mutation; no-output-on-failure; preserve shared output
template order; no new runtime dependency

**Scale/Scope**: One Discovery invocation, its bounded Candidate Solution Options, authoritative
Reference Architecture and Reference Implementation baselines, and the user-owned record/catalog
output contract

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The feature changes the shipped `highway-discovery` skill body and its repository validation
evidence. It does not change generators, package manifests, distribution manifests, or external
services.

| Gate | Verdict | Basis |
|---|---|---|
| Packaging Gate | N/A | No distribution manifest or packaged tree is changed. |
| Toolchain Gate | PASS | Existing validation commands will be run; no new tool is introduced. |
| Generator Gate | N/A | No generator script or generated artifact is changed. |
| Correspondence Gate | N/A | No generator input or generated adapter is changed. |
| Validation Gate | PASS | The changed skill contract will be checked by focused and full shell tests. |
| Skill Content Gate | PASS | `highway-discovery` receives the complete output, evaluation, workflow, verification, and error contracts. |

The plan follows P9.1 by preserving the complete shared Discovery output-template references in
the skill's Inputs and Outputs contract. It follows P6.1, P6.2, and P6.5 by expressing matching
and tie-breaking as explicit ordered conditions with a fallback path.

## Project Structure

### Documentation (this feature)

```text
specs/051-discovery-contract-completion/
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
discovery.md                              # Shipped Discovery skill contract
.highway/tools/tests/                     # Existing validation harness
specs/051-discovery-contract-completion/
├── spec.md
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── discovery-output-contract.md
│   ├── reference-implementation-evaluation-contract.md
│   └── recommendation-tie-break-contract.md
└── checklists/
  └── requirements.md
```

**Structure Decision**: Update the repository-root `discovery.md` skill contract and validate it
through the existing shell harness. Keep Feature 051's design artifacts under its numbered
`specs/` directory; no application source tree or runtime module is introduced.

**Post-Design Re-evaluation**: PASS. Phase 0 and Phase 1 add only development-side design
artifacts while the planned implementation changes one existing skill contract and its existing
validation surface. No packaging, generator, correspondence, or dependency gate is newly
triggered. Toolchain, validation, and skill-content gates remain satisfied.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | The feature uses the existing Discovery skill and test harness without new projects, services, or runtime dependencies. |
