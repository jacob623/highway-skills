# Implementation Plan: Highway UX Standard Alignment

**Branch**: `083-highway-ux-standard-alignment` | **Date**: 2026-09-23 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/083-highway-ux-standard-alignment/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Add one authoritative Interactive Workflow UX Contract to the Highway Experience Standard and align the eight in-scope Highway skills with it. Preserve the existing X2.2-X2.6 rule text, domain-specific output contracts, owner authority, packaging, and generated correspondence. Validate the shared contract and each skill with a focused mixed static/document and executable shell test, then run the full repository suite.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown governance/skill documents; POSIX-compatible shell with macOS Bash 3.2 test compatibility

**Primary Dependencies**: Existing `.highway/tools/tests/test-helpers.sh`, repository test suite, and existing catalog/adapter correspondence checks

**Storage**: N/A; no runtime or hidden interactive persistence is introduced

**Testing**: Focused static/executable shell validation plus `.highway/tools/tests/run-all.sh`, `git diff --check`, and generated-artifact correspondence checks

**Target Platform**: Distributed Highway skill tree and macOS/Linux shell validation environments

**Project Type**: Internal governance/documentation and shell-tooling repository; packaged skill distribution

**Performance Goals**: Deterministic, repository-scale validation with no new runtime or interaction observer

**Constraints**: Keep X2.2-X2.6 normative text unchanged; maintain one contract authority; preserve owner boundaries and existing output formats; use ASCII-compatible shell patterns; do not add dependencies or persistence

**Scale/Scope**: One Experience Standard section, eight in-scope skill documents, one focused validation test, and related generated correspondence; Help and Relationships remain out of guided-collection scope

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **D1 Layer Separation and Shippability**: PASS. All shipped changes remain under `.highway/`; planning artifacts remain under `specs/`; no `.specify/` content is added to the distributed tree.
- **D2 Environment and Dependency Discipline**: PASS. The feature uses existing Markdown and shell tooling only, adds no runtime dependency, and remains compatible with the declared macOS Bash 3.2 baseline.
- **D3 Verification Before and After**: PASS with planned evidence. Run the focused UX test and full `run-all.sh` before and after implementation; include static versus executed evidence and seeded failure probes for the new test.
- **D4 Generated Artifact Integrity**: PASS with conditional regeneration. Skill source edits trigger catalog/adapter correspondence checks; regenerate only if the repository's existing generator contract requires it, then verify correspondence and distribution packaging.
- **D6 Documentation Currency**: PASS with planned cross-reference validation. The Experience Standard, eight skill references, focused test, and Feature 083 planning artifacts will be kept mutually consistent.
- **D8 Shared Artifact Dependents**: PASS with planned review. Every changed skill citing the Experience Standard will be reviewed against the complete shared contract and its existing output structure.
- **Highway Experience Compliance P10.1-P10.2**: PASS with planned compliance review. Each amended skill will record applicable X2.2-X2.6 behavior; X2.5/X2.6 use N5 where no long-running activity exists, and any exception is explicit.

## Project Structure

### Documentation (this feature)

```text
specs/083-highway-ux-standard-alignment/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)
```text
.highway/
├── governance/
│   └── experience-standard.md
├── skills/
│   ├── highway-profile/SKILL.md
│   ├── highway-objectives/SKILL.md
│   ├── highway-controls/SKILL.md
│   ├── highway-nfrs/SKILL.md
│   ├── highway-new/SKILL.md
│   ├── highway-discovery/SKILL.md
│   ├── highway-adr/SKILL.md
│   └── highway-clarify/SKILL.md
└── tools/tests/
  └── highway-ux-alignment.test.sh
```

**Structure Decision**: Use the existing distributed `.highway/` source tree. The Experience Standard owns the reusable contract, each listed skill owns its domain-specific wording and authority, and a focused test under `.highway/tools/tests/` verifies the cross-file contract. No external contracts directory is needed because this is an internal documentation and shell-tooling change with no API or runtime protocol.

## Complexity Tracking

No constitution violations require justification. The feature adds one shared governance section and one focused validation test rather than a new runtime, persistence layer, or parallel contract library.
