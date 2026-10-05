# Implementation Plan: Profile Convergence Alignment

**Branch**: `140-profile-convergence-alignment` | **Date**: 2026-10-05 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/140-profile-convergence-alignment/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Align Profile-specific enrichment, acquisition, and verification guidance with the shared distinction between domain completeness and conversational convergence. Amend only `.highway/skills/highway-profile/SKILL.md`, add focused static document-contract coverage, regenerate the distributed Profile adapters, and preserve all retained Profile, ownership, persistence, and shared-standard contracts.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown skill documents and Bash 3.2-compatible contract tests

**Primary Dependencies**: Highway Experience Standard, Highway Identity, Highway Skills Constitution, existing shell test harness, adapter generator

**Storage**: Markdown skill and generated adapter files; no retained-schema or runtime storage change

**Testing**: Focused Feature 140 static document-contract test, adapter correspondence checks, and `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill trees consumed by supported agents; development validation on macOS and Bash 3.2-compatible shells

**Project Type**: Agent skill and governance documentation distribution

**Performance Goals**: No runtime performance change; preserve existing validation and acquisition behavior

**Constraints**: Do not modify `profile-record.md`, Constitution, Experience Standard, Highway Identity, setup, Objectives, readiness semantics, persistence behavior, or downstream owner artifacts; do not duplicate generic interaction mechanics

**Scale/Scope**: One source skill, four generated adapters, one focused contract test, and four Profile domains

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The pre-design gate passes:

- D1.5: this plan records a Constitution Check for the skill change.
- D3.1: the existing full test suite is the required passing baseline before implementation.
- D3.2: the full suite must pass after implementation.
- D3.3: the behavioral guidance amendment includes a focused test amendment.
- D6.1 and D6.2: Profile guidance and its resolvable shared-document references remain current.
- D8.1: the Profile skill's complete frontmatter and body output structure will be revalidated after the shared collaborative contract is applied.

No gate violation or runtime dependency is introduced.

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
└── tools/tests/feature-140-profile-convergence-alignment.test.sh
specs/140-profile-convergence-alignment/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
└── tasks.md
.github/skills/highway-profile/SKILL.md
.claude/skills/highway-profile/SKILL.md
.cursor/skills/highway-profile/SKILL.md
.agents/skills/highway-profile/SKILL.md
```

**Structure Decision**: This is a documentation-and-contract change. The source skill remains under `.highway/skills`, its static validation remains under `.highway/tools/tests`, and generated agent adapters are refreshed from the source. No external contracts directory is required because the repository exposes no API or command schema for this feature.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | The design stays within the existing skill, test, and adapter-generation boundaries. |
