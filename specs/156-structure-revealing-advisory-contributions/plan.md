# Implementation Plan: Structure-Revealing Advisory Contributions

**Branch**: `156-structure-revealing-advisory-contributions` | **Date**: 2026-10-10 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/156-structure-revealing-advisory-contributions/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Add a separate Profile-owned guidance section that improves selection and execution of existing
advisory contributions. The section will prefer revealing supported structure before a connected
linear chain of directly derived implication, possibility, or tradeoff. It will explicitly reject
summary-only contributions, detached strategic leaps, and branching alternatives without changing
the Experience Standard or the existing advisory scaffolding and examples.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown source documents; Bash 3.2.57-compatible test scripts

**Primary Dependencies**: Existing Highway Profile skill, Experience Standard, and static-document test harness

**Storage**: N/A; no Profile schema or persistence change

**Testing**: Focused static-document contract test plus `.highway/tools/tests/run-all.sh`

**Target Platform**: Packaged Highway agent skill trees on macOS-compatible shell tooling

**Project Type**: Git-native agent skill and governance document suite

**Performance Goals**: No runtime performance change; static verification remains deterministic

**Constraints**: Modify only Profile-owned guidance and its focused test; preserve Experience Standard,
existing advisory scaffolding, ordering preference, anti-paraphrase guidance, named exemplars, and
bakery counter-example; regenerate all Profile adapters after source change; distinguish static
document evidence from runtime conversational behavior.

**Scale/Scope**: One source skill, four generated adapters, and one focused static-document test.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The following gates pass before design:

- D1.1: The feature does not add development-artifact references to shipped documents.
- D1.3/D1.4: The plan and source guidance cite the Experience Standard by name and do not restate constitution rule text.
- D1.5: This plan records the applicable constitution check because it modifies a skill file.
- D2.4: No runtime dependency or package is added.
- D3.3: Implementation will add or amend a focused test under `.highway/tools/tests/`.
- D3.6: The focused test will be observed failing for the missing guidance before the source edit is marked complete.
- D3.8: The focused test will be labeled static-document-contract and will not be claimed as runtime behavior evidence.
- D4.7: Profile adapters will be regenerated after the source skill changes.

**Gate status**: PASS. No constitution violation or complexity exception is required.

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
├── skills/highway-profile/SKILL.md
└── tools/tests/feature-156-structure-revealing-advisory-contributions.test.sh
generated adapters/
├── .github/skills/highway-profile/SKILL.md
├── .claude/skills/highway-profile/SKILL.md
├── .cursor/skills/highway-profile/SKILL.md
└── .agents/skills/highway-profile/SKILL.md
```

**Structure Decision**: Keep the behavior in the existing Profile skill source, add one focused
static-document contract test, and regenerate the repository's four declared Profile adapters.
No runtime source tree, persistence layer, or external contract is introduced.

**Post-Design Constitution Check**: PASS. The research and design artifacts introduce no shipped
development-artifact references, runtime dependencies, persistence, external interfaces, or
constitution exceptions. The implementation remains subject to focused-test observation,
full-suite verification, static/runtime evidence separation, and adapter regeneration.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | The design uses the existing Profile document and test/generator boundaries. |
