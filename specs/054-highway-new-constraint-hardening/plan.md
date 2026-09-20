# Implementation Plan: Highway New Constraint Hardening

**Branch**: `054-highway-new-constraint-hardening` | **Date**: 2026-09-20 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/054-highway-new-constraint-hardening/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Harden the existing `highway-new` Solution Constraints contract without adding a new evidence
domain. Require `allowed_solution_classes` to be a non-empty list or `unknown`, standardize the
Business Constraints absence phrase as `None known` while preserving the existing persisted empty
state, and provide field-specific recovery guidance for malformed Solution Constraints values.
The implementation extends the authoritative skill, focused shell tests, and existing shared
contract surfaces, then regenerates catalog and agent adapters.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown skill instructions; Bash 3.2.57-compatible repository tooling

**Primary Dependencies**: Existing `validate-skill.sh`, `validate-library.sh`, focused Request
test, catalog generator, adapter generator, distribution checks, and full test suite; no new
runtime dependency

**Storage**: Plain Markdown source, shared templates, generated adapters/catalogs, and user-owned
Request records; no new storage

**Testing**: `.highway/tools/tests/highway-new.test.sh`, skill/library validators, adapter coverage,
distribution packaging, shipped-tree independence, and `run-all.sh`

**Target Platform**: macOS and Linux repository environments; generated adapters for GitHub Copilot,
Claude Code, and Cursor

**Project Type**: Internal agent skill and repository governance tooling

**Performance Goals**: Preserve one-question-per-turn behavior; no service latency or throughput
target

**Constraints**: Preserve deterministic intake order, privacy exclusion, bounded retry behavior,
no-partial-write transaction semantics, shared-template authority, generated correspondence, and
Request-only ownership boundaries

**Scale/Scope**: One Request conversation at a time; seven evidence domains; eight existing
Solution Constraints fields; no external service scale requirement

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Rule | Requirement | How this feature satisfies it |
|---|---|---|
| D1.5 | Plans modifying skill or library files record a Constitution Check | This plan names the skill-content and development gates governing the change. |
| D2.1-D2.4 | Tooling remains Bash 3.2-compatible and adds no undeclared dependency | Changes use existing Markdown and shell tooling only. |
| D3.1-D3.6 | Baseline, behavioral tests, and observed failure evidence are maintained | Focused tests will fail for the tightened cases before implementation and pass afterward; the full suite is rerun. |
| D3.8 | Static contract checks are not presented as behavioral evidence | Intake recovery cases are tested separately from document-contract assertions. |
| D4.5-D4.7 | Generated catalog and adapters correspond to authoritative inputs | Both generators and correspondence checks run after source changes. |
| D6.1-D6.2 | Live documentation and references remain current and resolvable | Feature contracts and quickstart document the changed wording, value states, and validation commands. |
| D8.1 | Shared-library changes trigger dependent skill validation | The plan revalidates the complete `highway-new` skill and Request template. |

Result: PASS. No unjustified constitution violations or new runtime dependencies.

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
├── skills/highway-new/SKILL.md                         # authoritative skill source
├── library/templates/output/request-record.md          # shared Request output contract
├── tools/tests/highway-new.test.sh                     # focused behavioral coverage
├── tools/tests/output-template.test.sh                 # shared contract assertions
├── tools/validate-skill.sh                             # skill validation
├── tools/validate-library.sh                           # template validation
├── tools/generate-catalog.sh                           # catalog generation
└── tools/generate-agent-adapters.sh                    # adapter generation

.github/skills/highway-new/SKILL.md                     # generated adapter
.claude/skills/highway-new/SKILL.md                     # generated adapter
.cursor/rules/highway-new.mdc                           # generated adapter
specs/054-highway-new-constraint-hardening/             # design artifacts
```

**Structure Decision**: Extend the existing authoritative `highway-new` skill, shared Request
template, focused tests, and generated outputs. No runtime service, package, persistence layer, or
new evidence domain is introduced.

## Phase 0: Research Summary

Research is complete in [research.md](research.md). Decisions resolve the only design questions:

- Keep `allowed_solution_classes` as a list-or-`unknown` field, with a non-empty list required.
- Keep `None known` as intake wording only; preserve the existing persisted empty-state shape.
- Use field-specific recovery messages based on each field's value shape.
- Extend existing tests and validators rather than introducing a new validation framework.

## Phase 1: Design Summary

Design artifacts:

- [data-model.md](data-model.md) defines value states and error-recovery semantics.
- [contracts/constraint-hardening-intake-contract.md](contracts/constraint-hardening-intake-contract.md) defines intake wording and recovery behavior.
- [contracts/constraint-hardening-record-contract.md](contracts/constraint-hardening-record-contract.md) defines durable-state compatibility boundaries.
- [quickstart.md](quickstart.md) defines focused and repository-wide validation.

No external API contract is required; the contracts document repository-owned skill and Request
record interfaces.

## Post-Design Constitution Re-check

| Gate | Result | Evidence planned |
|---|---|---|
| D2 toolchain discipline | PASS | No new utility, interpreter, package, or shell feature is introduced. |
| D3 behavioral evidence | PASS | Focused tests cover valid, malformed, retry, privacy, and no-write cases; static wording checks remain separate. |
| D4 generated correspondence | PASS | Catalog and adapter generators plus coverage checks run after source changes. |
| D6 documentation currency | PASS | Contract and quickstart artifacts state the canonical wording and field-specific recovery rules. |
| D8 shared-library review | PASS | Request template consumers are revalidated after any shared-template edit. |

**Post-design result**: PASS. No constitution amendment is required.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., 4th project] | [current need] | [why 3 projects insufficient] |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
