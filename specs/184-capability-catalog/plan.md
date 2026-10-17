# Implementation Plan: Capability Catalog

**Branch**: `184-capability-catalog` | **Date**: 2026-10-16 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/184-capability-catalog/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Extend the accepted Reference Implementation workflow so each RI can publish explicit, business-readable realized-capability evidence and a deterministic repository-wide projection at `implementations/capabilities.md`. The RI record remains authoritative; the catalog owns only stable `CAP######` navigation identifiers, one RI parent per entry, and one or more canonical realization values. Publication validates and writes the RI record, implementation catalog, and capability catalog as one operation.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: POSIX shell scripts and Markdown/YAML contract documents; no new runtime language

**Primary Dependencies**: Existing Highway implementation skill, shared output-template validators, catalog and adapter generators, and shell test harness

**Storage**: Git-tracked Markdown catalogs and Reference Implementation records under `implementations/`

**Testing**: `.highway/tools/tests/highway-implementation-onboarding.test.sh`, a focused capability-catalog contract test, `.highway/tools/tests/run-all.sh`, `validate-skill.sh`, and `validate-library.sh`

**Target Platform**: macOS and other POSIX-like environments supported by the repository shell toolchain

**Project Type**: Git-native governance skill and generated Markdown artifact contract

**Performance Goals**: Complete catalog generation in one repository-local workflow without network access; no external latency or throughput target is required for the MVP

**Constraints**: Preserve source ownership, avoid standalone capability artifacts, exclude timestamps and environment state, validate before persistence, preserve pre-operation bytes on failure, and keep generated adapters/catalogs synchronized

**Scale/Scope**: One repository-wide capability catalog derived from all accepted RIs; no live external integrations or separate technology inventory

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The design passes the applicable constitution gates:

- **D1.1 / D1.2**: The change remains shippable within the existing repository layout and does not introduce a prohibited dependency or runtime service.
- **D1.3 / D1.4**: The plan cites governing constitution rules without copying constitution rule text into a shipped skill contract.
- **D3.1 / D3.2**: Focused contract probes and the full repository test harness will run before completion; generated artifacts will be validated after regeneration.
- **D4.1 / D4.2 / D4.5-D4.7**: Shared templates, adapter outputs, and catalog outputs are regenerated through their declared generators and checked for correspondence and deterministic content apart from existing generator timestamps.
- **D6.1 / D6.2**: The implementation skill, shared templates, tests, and generated adapters remain synchronized and document the new output contract.

No constitution violation requires a complexity exception.

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
├── skills/highway-implementation/SKILL.md
├── library/templates/output/implementation-record.md
├── library/templates/output/implementation-catalog.md
├── library/templates/output/capability-catalog.md
└── tools/tests/
  ├── highway-implementation-onboarding.test.sh
  └── capability-catalog.test.sh

.github/skills/highway-implementation/SKILL.md
.claude/skills/highway-implementation/SKILL.md
.cursor/rules/highway-implementation.mdc
implementations/
├── implementations.md
├── capabilities.md
└── RI######.md
```

**Structure Decision**: Extend the canonical implementation skill and its shared output templates, add one focused contract test under the existing shell harness, and regenerate the declared agent adapters. The runtime output is Git-native Markdown: the RI record remains the source evidence, while `implementations/capabilities.md` is the derived index. No new application source tree or standalone capability record directory is introduced.

## Complexity Tracking

No constitution violations. No complexity exception is required.
