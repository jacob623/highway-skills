# Implementation Plan: Experience Standard Alignment

**Branch**: `117-experience-standard-alignment` | **Date**: 2026-10-01 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/117-experience-standard-alignment/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Amend the shared Highway Experience Standard from 5.0.0 to 6.0.0 so its observable interaction
rules align with the current Setup, Profile, Objectives, Controls, and NFR owner contracts. The
implementation will update the authoritative governance document, correct its non-normative
examples and amendment report, and update focused Bash contract tests that pin the standard's
version and rule observables. Owner skill workflows remain authoritative for domain behavior and
are not copied into the shared standard.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown; Bash 3.2-compatible validation scripts

**Primary Dependencies**: Existing POSIX/macOS shell utilities and repository test helpers; no new dependencies

**Storage**: Git-tracked Markdown governance and shell test files

**Testing**: Focused Experience Standard tests followed by `.highway/tools/tests/run-all.sh`

**Target Platform**: Highway repository on macOS and compatible Bash-based development environments

**Project Type**: Governance documentation and executable shell contract tests

**Performance Goals**: No runtime performance target; validation must remain a fast static-document check

**Constraints**: Preserve existing X identifiers; do not restate Constitution rule text; keep owner-specific
workflows, persistence, readiness, and orchestration in their owning documents; keep scripts compatible
with macOS Bash 3.2; do not modify generated artifacts unless a source generator input is changed

**Scale/Scope**: One shared Experience Standard, its amendment metadata and examples, focused contract tests,
and cross-document consistency review against six current governance/owner documents

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The following gates pass before research and remain required after design:

- **D1.1 / D1.3 / D1.4 PASS**: The change remains in the correct Layer 2 governance artifact and
  cites the Development Constitution without copying its rule text.
- **D2.1 / D2.3 PASS**: Validation scripts use the repository's Bash 3.2-compatible toolchain and
  avoid unsupported shell features or non-portable commands.
- **D3.1 / D3.2 / D3.7 PASS**: Focused tests and the full discovered suite are run after edits;
  static document checks remain distinguishable from executed behavior.
- **D4.1-D4.7 N/A**: No generator, catalog, adapter, or other generated artifact is changed.
- **D6.1 / D6.2 PASS**: The amended standard and its tests remain current and cross-references resolve
  within the repository's intended document scope.
- **D8.1 N/A**: No shared library artifact is changed, so dependent skill validation is not opened by
  this feature.

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
├── governance/
│   └── experience-standard.md
└── tools/
  └── tests/
    ├── experience-standard-amendment.test.sh
    ├── experience-x23-contract.test.sh
    ├── highway-ux-alignment.test.sh
    └── run-all.sh

specs/
└── 117-experience-standard-alignment/
  ├── spec.md
  ├── plan.md
  ├── research.md
  ├── data-model.md
  └── quickstart.md
```

**Structure Decision**: This is a repository-governance document change. The shipped standard and
its existing shell contract tests are the implementation surface; Feature 117 design artifacts
remain under its `specs/` directory. No external interface contract is required.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | The plan conforms to the Constitution gates above. |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
