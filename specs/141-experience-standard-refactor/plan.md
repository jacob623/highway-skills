# Implementation Plan: Experience Standard Runtime Contract Refactor

**Branch**: `141-experience-standard-refactor` | **Date**: 2026-10-05 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/141-experience-standard-refactor/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Refactor `.highway/governance/experience-standard.md` into a materially shorter shared runtime
interaction contract while preserving every current X-rule identifier, Observable, ownership and
acceptance boundary, and current user-visible behavior. The implementation will consolidate the
adaptive collaboration loop into one Interaction Model, retain only targeted guidance and five
boundary examples, remove runtime history and compatibility prose, update version metadata, and
validate the result with focused document-contract checks plus the full repository suite.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown governance document; Bash 3.2-compatible validation scripts

**Primary Dependencies**: Highway Identity, Highway Skills Constitution, existing Experience Standard
contract checks, and the repository shell test harness

**Storage**: Markdown source and development validation artifacts; no runtime or persisted-state change

**Testing**: Focused Experience Standard static contract test, diff/protected-path checks, and
`.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway governance consumers; development validation on macOS and
Bash 3.2-compatible shells

**Project Type**: Agent interaction governance and documentation distribution

**Performance Goals**: Reduce document length by at least 25% without reducing contract coverage or
changing supported user-visible behavior

**Constraints**: Modify only the Experience Standard and focused Feature 141 artifacts/tests; do not
modify Highway Identity, Constitution, Profile, any other skill, schemas, runtime state, or external
interfaces; preserve all current X-rule IDs and pre-release versioning policy

**Scale/Scope**: One shipped governance document, one focused contract test, and Feature 141 design
artifacts; no generated adapter changes

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The pre-design gate passes:

- D1.3 and D1.4: the plan cites the governing Constitution without copying its rule text.
- D3.1 and D3.2: the existing full suite is the required passing baseline and completion check.
- D3.3: the behavioral contract refactor includes focused validation coverage.
- D6.1 and D6.2: the live Experience Standard and its references remain current and resolvable.
- D2.4: no runtime dependency is added.

The Packaging, Generator, Correspondence, and Skill Content gates are N/A because the change does
not modify generated artifacts, generators, skill directories, or library content. No gate violation
requires a complexity exception.

## Project Structure

### Documentation (this feature)

```text
specs/141-experience-standard-refactor/
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
├── governance/experience-standard.md
└── tools/tests/feature-141-experience-standard-refactor.test.sh
specs/141-experience-standard-refactor/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
└── tasks.md
```

**Structure Decision**: This is a documentation-and-contract change. The authoritative runtime
document remains under `.highway/governance`, focused validation remains under `.highway/tools/tests`,
and planning artifacts remain under the Feature 141 directory. No contracts directory is required
because the repository exposes no external API or command schema for this feature.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | The design stays within the existing governance document and validation boundaries. |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
