# Implementation Plan: Valid Profile YAML

**Branch**: `026-valid-profile-yaml` | **Date**: 2026-09-09 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/026-valid-profile-yaml/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

The canonical profile is currently indented with tab characters, which standard YAML parsers
reject. Replace indentation with spaces without changing the existing pure-YAML schema or values,
then add a focused parser-backed regression test and include it in the profile validation workflow.
The existing structural validator remains responsible for section ordering and profile semantics.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Bash 3.2.57-compatible scripts; Ruby/Psych for the parser-backed test on the development host

**Primary Dependencies**: Existing shell toolchain and the host's standard YAML parser library; no shipped runtime dependency

**Storage**: Repository files only

**Testing**: Focused profile YAML test, existing profile structure test, and `.highway/tools/tests/run-all.sh`

**Target Platform**: macOS and GNU/Linux development environments

**Project Type**: Repository tooling and generated distribution artifacts

**Performance Goals**: Profile validation completes within the existing test-suite execution envelope

**Constraints**: Preserve the exact 11-section schema and ordering; maintain Bash 3.2 compatibility; do not edit Feature 024

**Scale/Scope**: One canonical profile, one focused syntax test, and the existing profile fixtures/workflow

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Process Gates

| Gate | Verdict | Evidence |
|---|---|---|
| Packaging Gate | PASS | The canonical profile is shipped, so the plan preserves its canonical path and distribution inclusion while removing only invalid indentation. |
| Toolchain Gate | PASS | Shell changes remain Bash 3.2-compatible and use the existing toolchain; the parser is test-only and adds no shipped runtime dependency. |
| Validation Gate | PASS | The change adds a parser-backed regression test and evaluates the existing profile fixtures before enabling it. |
| Spec Record Gate | PASS | Feature 026 is the next sequential spec and is not a modification of completed Feature 024 or Feature 025 records. |
| Skill Content Gate | N/A | No skill file is modified. |

Applicable rules: D1.1, D1.2, D2.1-D2.4, D3.1-D3.6, D5.1-D5.4, D6.1-D6.2, and D7.1-D7.3.

## Project Structure

### Documentation (this feature)

```text
specs/026-valid-profile-yaml/
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
├── library/templates/output/profile.yaml
└── tools/
  └── tests/
    ├── profile-yaml.test.sh
    ├── profile-structure.test.sh
    └── run-all.sh

specs/026-valid-profile-yaml/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
└── checklists/requirements.md
```

**Structure Decision**: Keep the canonical profile in the existing shared library output
directory, place the focused regression test beside the existing profile tests, and wire it into
the existing test discovery script. Feature design artifacts remain under the numbered spec
directory; no new application source tree is introduced.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | The change fits the existing profile validator and test layout. |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
