# Implementation Plan: Experience Runtime Refactor

**Branch**: `146-experience-runtime-refactor` | **Date**: 2026-10-06 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/146-experience-runtime-refactor/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Refactor the Highway Experience Standard into a self-contained runtime interaction contract. Remove
its Highway Skills Constitution dependency and development/test metadata, preserve owner and accepted-
knowledge boundaries, and consolidate overlapping questioning, re-evaluation, advisory, convergence,
and acceptance guidance. The implementation is a focused Markdown amendment to
`.highway/governance/experience-standard.md`, validated by the existing shell test suite and a
targeted document-contract audit.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown governance artifact; Bash 3.2-compatible validation scripts

**Primary Dependencies**: `.highway/governance/experience-standard.md`, existing Experience Standard
validators, `.specify/memory/constitution.md`, and the repository test harness

**Storage**: N/A; no runtime or persistent schema changes

**Testing**: Experience Standard amendment/convergence/refactor tests and
`.highway/tools/tests/run-all.sh`

**Target Platform**: Highway repository development on macOS and GNU-compatible environments

**Project Type**: Governance/documentation repository with shell-based validation

**Performance Goals**: Preserve current validation runtime; add no runtime execution cost

**Constraints**: Change only the Experience Standard and feature design records; do not edit the
Constitution, Identity, owning skills, templates, or runtime persistence contracts. Preserve stable
surviving X IDs and retire no ID for reuse.

**Scale/Scope**: One Layer 2 Experience Standard, its X-rule inventory, runtime definitions,
Interaction Model, explanatory sections, amendment metadata, and focused validation evidence

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **D1.3/D1.4**: PASS. The amendment will not copy Layer 0 rule text and will record changed
  Experience elements with stable X IDs and retired-ID accounting.
- **D3.1-D3.5**: PASS with implementation evidence. Run focused checks and the full suite before
  completion; keep requirement coverage distinct from test results; do not weaken existing checks.
- **D4.5-D4.7**: N/A. No generated adapter, catalog, or skill input changes.
- **D6.1-D6.2**: PASS. The Experience Standard and its feature records remain internally current,
  and all retained references resolve.
- **D8.1**: N/A. No shared library artifact or output template changes.

No gate violations require a complexity exception. The feature changes a runtime governance document
but does not introduce runtime code, storage, external interfaces, or a new execution dependency.

**Post-design gate**: PASS. Research resolves the document version, stable X-ID consolidation,
protected-file boundary, validation strategy, and the absence of external contracts.

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
.highway/governance/experience-standard.md       # Layer 2 runtime standard
.highway/tools/tests/                             # Existing document validators
├── experience-standard-amendment.test.sh
├── experience-standard-convergence.test.sh
├── feature-141-experience-standard-refactor.test.sh
└── run-all.sh

specs/146-experience-runtime-refactor/
├── spec.md
├── plan.md
├── research.md
├── data-model.md
└── quickstart.md
```

**Structure Decision**: Keep the implementation in the existing Layer 2 governance document and
validate it through existing development tests. No source-code, generated-artifact, API-contract, or
`contracts/` directory is needed. Feature design records remain under the Feature 146 directory.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | The existing single-document governance surface and shell validators are sufficient. |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
