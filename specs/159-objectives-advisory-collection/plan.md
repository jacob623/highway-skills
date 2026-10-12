# Implementation Plan: Objectives Advisory Collection

**Branch**: `159-objectives-advisory-collection` | **Date**: 2026-10-11 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/[###-feature-name]/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Centralize Objective response support wording, add bounded Profile-grounded advisory and portfolio
guidance, and change multi-selection into an ordered transient queue that cannot bypass Success
Measures. Implement this in the authored `.highway/skills/highway-objectives/SKILL.md`, regenerate
all registered agent adapters byte-for-byte, and extend focused static/fixture checks without
changing Objective record, catalog, identifier, persistence, or orchestration ownership.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown skill contracts; Bash 3.2-compatible verification scripts

**Primary Dependencies**: Highway Experience Standard, Highway Identity, Profile skill, Objective
record and catalog output templates, adapter generation tooling

**Storage**: User-owned Markdown records under `library/objectives/` and catalog under
`library/governance/objectives.md`; no storage change

**Testing**: Focused shell contract tests, adapter correspondence checks, and
`.highway/tools/tests/run-all.sh`

**Target Platform**: Highway skill consumers across the registered agent trees

**Project Type**: Documentation-driven multi-agent skill suite

**Performance Goals**: N/A; bounded prose and static verification only

**Constraints**: Preserve owner-controlled mutation, readiness, output, catalog, identifier,
duplicate/overlap, atomic persistence, setup, and Repository Context contracts. Keep normative
sections within constitutional maintainability limits and do not restate generic Experience rules.

**Scale/Scope**: One source skill, five generated adapters, focused Objective tests, and full-suite
regeneration/verification; no new durable entities or external interfaces

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- P7.1-P7.2: PASS; the skill has one Purpose and semantic version metadata.
- P7.3-P7.6: PASS by design; generic interaction rules remain delegated, and the new guidance is
  bounded to Objective-specific behavior within existing section limits.
- P7.7: MAJOR version increment required because multi-selection and review behavior are changed.
- P8.2-P8.4: PASS; ordered processing is specified because it affects acceptance, mutation, and
  capture behavior, and Verification names executable outcomes.
- P9.1-P9.8: PASS; retained output templates and paths remain unchanged.
- P10.1: PASS; the skill continues to reference the Experience Standard without copying its rules.
- P11.1-P11.4: PASS; Identity, Highway Vision, Highway Platform Objectives, Profile, and accepted
  Objective records retain declared roles and missing-context boundaries.
- P12.6-P12.15 and P13.2: PASS; Objective ownership remains authoritative for readiness, domain
  state, acceptance, mutation, persistence, and terminal results.

[Gates determined based on constitution file]

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
├── skills/highway-objectives/SKILL.md       # authored Objective contract
└── tools/tests/
  ├── objective-management.test.sh          # existing owner/persistence fixture contract
  └── feature-159-objectives-advisory.test.sh # focused behavior contract

.github/skills/highway-objectives/SKILL.md
.claude/skills/highway-objectives/SKILL.md
.cursor/skills/highway-objectives/SKILL.md
.agents/skills/highway-objectives/SKILL.md
.mock-agent-4/skills/highway-objectives/SKILL.md
```

**Structure Decision**: Keep the single authored skill as the source of truth. Generated adapters
are distribution artifacts and must be regenerated rather than hand-edited. Add no contracts
directory because the feature exposes no API, file schema, or external service interface.

## Phase 0: Research Summary

Research decisions are recorded in [research.md](research.md). The design introduces no new
technology, durable state, or external dependency. The transient queue is specified as behavioral
working state only; it is never emitted as a retained Objective artifact.

## Phase 1: Design Summary

- [data-model.md](data-model.md) defines the response-support, observation, portfolio, recommendation,
  queue, Success Measure, and accepted Objective concepts while distinguishing transient from durable
  state.
- No `contracts/` directory is created because there are no external interfaces.
- [quickstart.md](quickstart.md) provides focused and full-suite validation commands.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | The feature fits the existing authored-skill and generated-adapter structure. |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
