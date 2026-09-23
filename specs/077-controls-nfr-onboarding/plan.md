# Implementation Plan: Controls and NFRs Onboarding Enhancement

**Branch**: `077-controls-nfr-onboarding` | **Date**: 2026-09-23 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/077-controls-nfr-onboarding/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Extend the existing governance skill contracts so onboarding can collect proposed Controls without
writes, require explicit per-item decisions before a Review Complete transaction, generate ordered
Control-derived NFR candidates only after successful Control persistence, and review those
candidates through an all-or-nothing NFR transaction. Preserve direct NFR authoring, existing
readiness contracts, root-level user-owned governance paths, and generated agent artifacts.

The implementation will use deterministic shell workflows and Markdown contracts, temporary
fixture roots for behavioral tests, catalog `next_id` as the only identifier source, and staged
validation before replacing governed bytes. Candidate state remains disposable proposal state; no
new persistent artifact type is introduced.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Bash 3.2-compatible shell plus Markdown/YAML contracts

**Primary Dependencies**: Existing `.highway/tools/` generators, validators, and shell test harness

**Storage**: Root-level `library/governance/` Markdown records and catalogs; in-memory or temporary
proposal/candidate state during review

**Testing**: Bash fixture tests under `.highway/tools/tests/`, focused tests, generators, validators,
and `.highway/tools/tests/run-all.sh`

**Target Platform**: macOS and Linux shells; Bash 3.2 compatibility is required for scripts

**Project Type**: Internal command/skill contract suite with generated agent adapters

**Performance Goals**: Complete onboarding for the repository's existing governance baseline within
one interactive invocation; no new latency or throughput target is required

**Constraints**: Deterministic output; no timestamps, randomness, or session state; no writes or ID
allocation during collection or active review; Bash 3.2 and declared utility toolchain; failure
paths preserve all pre-operation bytes; user-owned records remain outside `.highway`

**Scale/Scope**: Four fixed Control categories, ordered proposal/candidate collections, existing
Control/NFR record and catalog formats, and the three owning skills `/highway-controls`,
`/highway-nfrs`, and `/highway-setup`

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Process gates before Phase 0:

- Packaging Gate: `N/A` until a shipped path is touched.
- Toolchain Gate: `N/A` for the plan; implementation scripts must satisfy D2.1-D2.4 if added or changed.
- Generator Gate: `N/A` until a generator is changed.
- Correspondence Gate: `PASS pending implementation regeneration`; source skill changes require D4.4 and D4.7 regeneration checks.
- Validation Gate: `N/A` until a validation check is added or changed.
- Skill Content Gate: `PASS pending implementation review` against the Highway Skills Constitution because source skill contracts will change.
- Development verification: D3.1 requires a passing suite before implementation; D3.2 requires a passing suite after implementation; D3.3 requires tests for the behavioral changes.

No gate is an unresolved violation. Phase 0 research and Phase 1 design may proceed; implementation
must re-evaluate triggered gates after source and generated artifacts are changed.

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
├── skills/
│   ├── highway-controls/SKILL.md
│   ├── highway-nfrs/SKILL.md
│   └── highway-setup/SKILL.md
├── library/templates/output/
└── tools/tests/
  ├── control-derived-nfr.test.sh
  ├── highway-setup.test.sh
  ├── nfr-management.test.sh
  ├── readiness-owner-states.test.sh
  └── fixtures/

.github/skills/       # generated adapters
.claude/skills/       # generated adapters
.cursor/rules/         # generated adapters
library/governance/    # user-owned runtime records, outside this feature's source tree
specs/077-controls-nfr-onboarding/
├── plan.md
├── research.md
├── data-model.md
├── contracts/
├── quickstart.md
└── tasks.md           # generated by /speckit-tasks
```

**Structure Decision**: Keep the existing skill source, template, generator, and fixture layout.
Feature design artifacts live under the feature directory. No application source tree or new
runtime dependency is introduced. User-owned governance files are test fixtures or runtime targets,
never implementation files under `.highway`.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
