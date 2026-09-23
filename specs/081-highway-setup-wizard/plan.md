# Implementation Plan: Highway Setup Wizard

**Branch**: `081-highway-setup-wizard` | **Date**: 2026-09-23 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/081-highway-setup-wizard/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Replace the passive `/highway-setup` readiness-and-stop flow with an active, ordered wizard that delegates every collection and mutation to the Profile, Objectives, Controls, and NFR owner workflows. The wizard will keep only in-session progress, re-derive the first incomplete stage from persisted owner readiness after interruption, preserve verbatim owner questions and examples, and retain the existing completion dashboard.

The implementation will update the shipped Setup skill contract and its focused executable/static tests. It will not add a Setup artifact store, modify owner artifact formats, or change the distribution manifest.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown skill instructions; Bash 3.2.57-compatible validation scripts

**Primary Dependencies**: Existing `highway-profile`, `highway-objectives`, `highway-controls`, and `highway-nfrs` owner workflows; existing test helpers and `run-all.sh`

**Storage**: Existing owner readiness and owner artifact state; no new Setup checkpoint or artifact store

**Testing**: `.highway/tools/tests/highway-setup.test.sh`, `.highway/tools/tests/highway-setup-executable.test.sh`, and `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and other environments supporting Bash 3.2.57-compatible scripts

**Project Type**: Governed interactive skill suite with command-style workflows

**Performance Goals**: One owner question per interaction turn; no additional latency or scale target is introduced by this documentation-driven orchestration change

**Constraints**: Preserve owner authority and no-write semantics; fixed stage order; exact terminality table; verbatim owner question/example output; Bash 3.2 compatibility; no new runtime dependency; no persisted Setup checkpoint

**Scale/Scope**: One shipped skill, four existing owner workflows, focused Setup tests, and Feature 081 development documentation

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The change modifies a shipped skill and its validation tests, so the following gates apply:

| Gate | Verdict | Basis |
|---|---|---|
| Packaging Gate | PASS | The skill remains self-contained and does not reference `.specify/` or `specs/` in shipped content; D1.1, D1.2, and D6.2 remain satisfied. |
| Toolchain Gate | PASS | Validation changes remain Bash 3.2.57-compatible and use the declared toolchain; D2.1-D2.4 apply. |
| Validation Gate | PASS | Focused checks are additive and preserve existing assertions; D3.4 and D3.5 apply. |
| Generator Gate | N/A | No generator is changed. |
| Correspondence Gate | N/A | No skill directory, generator input, catalog, or adapter is added or removed. |
| Skill Content Gate | PASS | The change is governed by the Highway Skills Constitution under D1.5; owner boundaries, output contracts, and X2 interaction rules are preserved. |

Implementation must re-run the full suite before completion and report requirement coverage separately from check results per D3.1, D3.2, D3.6, D3.8, and D7.3.

### Post-Design Constitution Check

The Phase 1 design preserves the pre-design gate results. The data model and contracts add no
runtime dependency, shipped reference to development artifacts, generated artifact, new
generator input, or competing owner store. The focused tests remain additive and continue to
separate static document-contract evidence from executed-behavior evidence. All gates remain
`PASS` or `N/A` as recorded above; no complexity exception is required.

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
├── skills/highway-setup/SKILL.md
└── tools/tests/
  ├── highway-setup.test.sh
  └── highway-setup-executable.test.sh

specs/081-highway-setup-wizard/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
└── contracts/setup-wizard.md
```

**Structure Decision**: Keep orchestration behavior in the existing shipped Setup skill, extend its focused static and executable tests, and keep design artifacts under the Feature 081 development directory. Owner skills remain unchanged unless implementation discovers a contract defect that must be addressed explicitly.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | No constitution violation or extra project boundary is required. |
