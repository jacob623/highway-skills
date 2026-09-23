# Implementation Plan: Highway Setup UX Simplification and Welcome Flow

**Branch**: `085-highway-setup-ux-simplification` | **Date**: 2026-09-23 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/085-highway-setup-ux-simplification/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Update the shipped `highway-setup` skill so ordinary input collection opens with a welcome,
active owner introduction, and one owner-supplied unresolved question in that order. Suppress
workflow-engine narration and routine progress framing while preserving readiness ordering,
owner authority, terminality, safe-stop behavior, and the existing completion dashboard. Amend
the focused static and executable setup tests to prove the new presentation and outcome rules.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown skill instructions; Bash 3.2.57-compatible validation scripts

**Primary Dependencies**: Existing Highway owner skills and `.highway/tools/tests/test-helpers.sh`

**Storage**: N/A; no setup persistence or new artifact store

**Testing**: `.highway/tools/tests/highway-setup.test.sh`, `highway-setup-executable.test.sh`, and `run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU-like environments

**Project Type**: Agent skill and governance-document suite

**Performance Goals**: Preserve existing single-question interaction and readiness ordering; no runtime performance target applies

**Constraints**: Preserve owner output bytes and semantics; remain Bash 3.2 compatible; add no runtime dependency or persistence; keep completion dashboard unchanged

**Scale/Scope**: One shipped skill, two focused tests, one feature contract, and four owner workflows

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Process gates:

| Gate | Verdict | Basis |
|---|---|---|
| Packaging Gate | PASS | D1.1, D1.2, and D6.2 will be checked because `.highway/skills/` is shipped. |
| Toolchain Gate | PASS | D2.1-D2.4 apply to the amended Bash tests; no new utility or runtime dependency is planned. |
| Generator Gate | N/A | No `generate-*.sh` file changes. |
| Correspondence Gate | N/A | No generator input or skill directory is added or removed. |
| Validation Gate | PASS | D3.4 and D3.5 apply; existing fixtures remain covered and no assertion is weakened. |
| Skill Content Gate | PASS | P1.1, P1.3, P1.5, P4.1, P5.1-P5.5, P6.1-P6.6, P7.1-P7.5, P8.1-P8.4, P10.1, and P10.2 will be reviewed. |

The output-contract change increments `metadata.version` from `2.0.0` to `3.0.0` under P7.7.
The Experience Standard remains the authority; no new X rule is introduced.

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

specs/085-highway-setup-ux-simplification/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/setup-output.md
└── tasks.md
```

**Structure Decision**: Keep the behavior in the existing shipped `highway-setup/SKILL.md`
and extend its focused Bash tests. The feature design artifacts document the output contract and
validation scenarios; no application source tree or persistence layer is introduced.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | The design stays within the existing skill and test boundaries. |
