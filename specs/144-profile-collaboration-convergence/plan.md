# Implementation Plan: Profile Collaboration Convergence

**Branch**: `144-profile-collaboration-convergence` | **Date**: 2026-10-06 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/144-profile-collaboration-convergence/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Add a Profile-owned semantic convergence decision near Domain completeness, keeping the Experience
Standard authoritative for generic collaboration behavior. Add development-only transcript fixture
definitions and a reusable semantic rubric, execute all eight fixtures through the repository's
development validation workflow, and preserve the current retained Profile schema, readiness,
persistence, acceptance, generated adapters, and runtime dependency boundary.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown and Bash 3.2.57-compatible test scripts

**Primary Dependencies**: Existing Highway Experience Standard, Constitution, Profile skill,
repository test harness, and generated adapter process

**Storage**: No new runtime storage; retained Profile remains the existing Markdown artifact and
schema

**Testing**: `.highway/tools/tests/run-all.sh`, existing Profile contract tests, and eight
development-time transcript fixture evaluations

**Target Platform**: Distributed Highway skill tree on macOS and GNU-compatible development
environments using the declared Bash/toolchain conventions

**Project Type**: Governance skill/documentation repository with generated agent adapters and
development-time shell validation

**Performance Goals**: No new runtime latency or throughput target; the development fixture suite
must remain suitable for the existing full validation workflow

**Constraints**: No runtime fixture dependency, no new retained Profile fields or readiness
dimensions, no model-specific branches, no duplicate generic Experience Standard or Constitution
rules, Bash 3.2 compatibility, and generated adapters must remain source-correspondent

**Scale/Scope**: One Profile skill, four generated adapters, eight synthetic transcript fixture
categories, one shared rubric, and focused/full repository validation

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **D1.1, D1.2, D2.4**: PASS. Development fixtures and rubric remain outside shipped artifacts
  and are not runtime dependencies.
- **D3.2, D3.3, D3.4, D3.6, D3.8**: PASS with implementation evidence. The change adds focused
  behavioral validation, observes fixture failures before completion, and distinguishes semantic
  behavior evaluation from static document checks.
- **D4.4, D4.7**: PASS with implementation evidence. Profile adapters and catalog/manifests will
  be regenerated after source changes.
- **D5.3, D7.3**: PASS. This plan identifies changed Profile behavior and separates requirement
  coverage from test results.
- **P7.2, P7.3, P7.7**: PASS. `highway-profile` receives the next minor capability version,
  generic ownership remains referenced rather than duplicated, and no breaking contract is
  introduced.
- **P8.3, P8.4, P10.1**: PASS. The Profile Verification section names checkable outcomes and
  continues to defer generic interaction rules to the Experience Standard.
- **P9.1, P9.6, P9.8**: PASS. No shared retained output skeleton or runtime artifact schema is
  duplicated or changed; development fixtures are deterministic repository artifacts.

No gate violations require a complexity exception.

**Post-design gate**: PASS. Research resolved all technical unknowns; the data model adds no
retained fields; the fixture contract keeps all evaluation artifacts development-only; the
quickstart uses the existing validation and adapter-generation commands; and no Constitution,
Experience Standard, or shared Profile output artifact requires modification.

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
├── skills/highway-profile/SKILL.md                 # Profile semantic decision and verification
└── tools/tests/
  ├── profile-convergence-behavior.test.sh        # Fixture execution/contract entry point
  └── fixtures/profile-convergence/               # Synthetic transcript scenarios and rubric data
    ├── fixtures/*.md
    └── rubric.md

specs/144-profile-collaboration-convergence/
├── contracts/profile-behavioral-evaluation.md      # Fixture and rubric contract
├── data-model.md                                   # Transient evaluation entities
├── quickstart.md                                   # Validation commands and expected results
└── research.md                                     # Design decisions and alternatives

.agents/skills/highway-profile/SKILL.md             # Generated adapter
.claude/skills/highway-profile/SKILL.md             # Generated adapter
.cursor/skills/highway-profile/SKILL.md             # Generated adapter
.github/skills/highway-profile/SKILL.md             # Generated adapter
```

**Structure Decision**: Keep the shipped semantic guidance in the source Profile skill, keep
behavioral evaluation inputs under development-only test fixtures, and store the design contract
with this feature. The existing `run-all.sh` discovery mechanism will pick up the new focused test
without runtime code or a new package dependency. Generated adapters remain derived outputs.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
