# Implementation Plan: Profile and Setup Advisory Hardening

**Branch**: `154-profile-setup-advisory-hardening` | **Date**: 2026-10-09 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/154-profile-setup-advisory-hardening/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Update the Profile and Setup delivery contracts for clearer reassurance, cross-domain transitions,
approval flow, grounded exploratory questions, and first-message ordering. Amend only X2.72 for the
proposed-starting-point heading. Validate the source documents with focused static contract checks,
regenerate all declared agent outputs, and run the existing suite.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Bash 3.2.57-compatible shell scripts and Markdown source documents

**Primary Dependencies**: Existing `.highway/tools/tests` shell harness and repository generators; no new dependencies

**Storage**: Markdown source documents and generated agent-tree copies; no new storage

**Testing**: Focused static document-contract checks plus `.highway/tools/tests/run-all.sh`

**Target Platform**: macOS/Linux repository environments using the declared shell toolchain

**Project Type**: Internal governance and agent-instruction document suite

**Performance Goals**: Preserve the existing suite's completion behavior; no runtime latency target applies

**Constraints**: Preserve owner boundaries; use Bash 3.2 syntax; do not hand-edit generated artifacts; static checks are not runtime-behavior evidence

**Scale/Scope**: Three source contracts, one Experience Standard rule, generated agent adapters, and focused test coverage across five user stories

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **D1.1**: PASS. Shipped source and generated artifacts contain no `specs/` or `.specify/` references.
- **D1.5**: PASS. The change remains within the owning Profile, Setup, and Experience Standard boundaries.
- **D2.1**: PASS. Any shell checks use Bash 3.2.57-compatible constructs.
- **D3.1**: PASS. Implementation begins from the existing passing suite baseline.
- **D3.2**: PASS condition. The full suite must pass after implementation.
- **D3.3**: PASS. New delivery behavior receives focused static contract assertions.
- **D3.4**: PASS condition. New checks will be evaluated against existing fixtures before enablement.
- **D3.6**: PASS condition. Focused assertions will observe their seeded failures before source edits.
- **D3.8**: PASS. Static document checks are explicitly treated as delivery-site evidence, not runtime behavior evidence.
- **D4.1/D4.5-D4.7**: PASS condition. Generated outputs will be regenerated from source and checked for correspondence.
- **D5.3**: PASS condition. The completion record will report suite results separately from requirement coverage.
- **D7.3**: PASS condition. Completion will separate check results, coverage, document-contract evidence, and deferred conversational evaluation.
- **D8.1**: PASS condition. Changed shared Experience Standard content will trigger re-validation of every citing skill.

No gate is violated; no complexity exception is required.

## Project Structure

### Documentation (this feature)

```text
specs/154-profile-setup-advisory-hardening/
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
├── skills/highway-profile/SKILL.md
├── skills/highway-setup/SKILL.md
└── tools/tests/feature-154-delivery-sites.test.sh
.github/skills/highway-profile/SKILL.md
.claude/skills/highway-profile/SKILL.md
.cursor/skills/highway-profile/SKILL.md
.agents/skills/highway-profile/SKILL.md
AGENTS.md
```

**Structure Decision**: Keep source-of-truth wording in the three owning `.highway` documents,
place the focused static contract test beside the existing shell tests, and regenerate the four
agent trees plus `AGENTS.md`. Feature design records remain under the feature directory and are not
shipped runtime artifacts.

## Complexity Tracking

No complexity violations.
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
