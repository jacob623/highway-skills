# Implementation Plan: Discovery Contract Alignment

**Branch**: `061-discovery-contract-alignment` | **Date**: 2026-09-21 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/061-discovery-contract-alignment/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Synchronize the canonical Discovery section contract, deterministic compliance vocabulary,
alignment value validation, Required Platform Match traceability, and Candidate Elimination Log
ordering across the Discovery skill and shared output template. Extend the existing developer-facing
Bash contract test with disposable fixtures, then regenerate and verify all generated adapters and
catalog artifacts without changing normal advisory Discovery execution.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown skill contracts and Bash 3.2.57-compatible validation scripts

**Primary Dependencies**: Existing `.highway/tools` validators, focused shell tests, and generators; no new dependency

**Storage**: Markdown source, template, generated adapters, and catalogs; no runtime storage

**Testing**: `.highway/tools/tests/highway-discovery.test.sh`, validators, adapter coverage, and `run-all.sh`

**Target Platform**: Distributed Highway skill tree consumed by GitHub Copilot, Claude Code, and Cursor; macOS and supported shell environments

**Project Type**: Repository governance and workflow skill suite

**Performance Goals**: Preserve the existing bounded, advisory Discovery workflow; no runtime evaluation or network call is added

**Constraints**: Keep canonical section order in source artifacts, use integer alignment values 0-100 inclusive, preserve no-write and ADR ownership semantics, isolate tests in disposable fixtures, and never hand-edit generated outputs

**Scale/Scope**: One Discovery skill, one shared record template, one focused test, three generated adapters, generated catalogs, and the full repository suite

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The feature changes shipped skill/template contracts, developer validation evidence, and generated
artifacts. It does not add a runtime, external service, package dependency, or governance decision.

| Gate | Verdict | Evidence / planned satisfaction |
|---|---|---|
| **Packaging Gate** | PASS | Shipped artifacts will be checked for development-only references and valid cross-references. (D1.1, D1.2, D6.2) |
| **Toolchain Gate** | PASS | Existing Bash 3.2-compatible utilities and test harness are used; no runtime dependency is added. (D2.1-D2.4) |
| **Generator Gate** | PASS | Existing adapter/catalog generators will be run after canonical source changes; no generator script changes are planned. (D4.1-D4.4) |
| **Correspondence Gate** | PASS | Generated adapters and catalogs will be regenerated and checked for coverage and currency. (D4.5-D4.7) |
| **Validation Gate** | PASS | Focused tests will use independent disposable invalid fixtures and preserve existing assertion strength. (D3.4-D3.5) |
| **Skill Content Gate** | PASS | The changed skill and shared template will retain complete output citations, deterministic workflow rules, advisory ownership, and failure behavior. (D1.5) |

Process result: PASS. No unjustified gate violations.

## Project Structure

### Documentation (this feature)

```text
specs/061-discovery-contract-alignment/
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
├── skills/highway-discovery/SKILL.md                    # canonical skill contract
├── library/templates/output/discovery-record.md         # shared output contract
├── tools/tests/highway-discovery.test.sh                # focused contract and fixture checks
├── tools/generate-agent-adapters.sh                     # generated adapter regeneration
├── tools/generate-catalog.sh                            # skill catalog regeneration
└── tools/generate-library-catalog.sh                   # library catalog regeneration
.github/skills/highway-discovery/SKILL.md                # generated adapter
.claude/skills/highway-discovery/SKILL.md                # generated adapter
.cursor/rules/highway-discovery.mdc                     # generated adapter
specs/061-discovery-contract-alignment/                  # development design artifacts
```

**Structure Decision**: Keep the canonical Markdown contracts under `.highway/`, extend the
existing Bash test harness with disposable fixtures, and regenerate all derived adapters/catalogs.
No application source tree, runtime module, or new interface is introduced.

## Implementation Sequence

1. Update `.highway/skills/highway-discovery/SKILL.md` and
   `.highway/library/templates/output/discovery-record.md` as the canonical contract sources:
   synchronize section names/order, require `Fully Compliant`, define integer alignment values
   from 0 through 100, document Required Platform Match as traceability-only, and declare
   deterministic elimination ordering.
2. Extend `.highway/tools/tests/highway-discovery.test.sh` with source-document,
   generated-artifact, and disposable-fixture assertions. Add independent valid and invalid
   fixture paths for each deterministic rule, including decimal, negative, and above-100
   alignment values; keep fixtures temporary and preserve canonical bytes.
3. Run `.highway/tools/generate-agent-adapters.sh`, `.highway/tools/generate-catalog.sh`, and
   `.highway/tools/generate-library-catalog.sh` so all derived artifacts reflect canonical changes.
4. Run focused validators, `highway-discovery.test.sh`, `adapter-coverage.test.sh`,
   `output-template.test.sh`, and `.highway/tools/tests/run-all.sh`; confirm no-write behavior,
   independent invalid-fixture failures, generated currency, and deterministic repeated checks.

## Post-Design Re-evaluation

- **Canonical contract ownership**: PASS. Section names/order remain declared by shipped skill and
  shared template; the feature requirement asserts correspondence without duplicating the list.
- **Deterministic validation**: PASS. Integer alignment boundaries, compliance vocabulary,
  traceability wording, and elimination ordering each have focused valid/invalid fixture coverage.
- **Generated artifact integrity**: PASS. Adapters and catalogs are regenerated from canonical
  inputs and checked by existing correspondence tests.
- **Toolchain and dependencies**: PASS. The design adds no package, interpreter, service, or
  runtime parser and remains compatible with Bash 3.2.57.
- **Governance ownership**: PASS. Discovery remains advisory; ADR retains selection, decision,
  rationale, consequence, and authorization ownership.

Post-design result: PASS. No unresolved clarification or constitution violation remains.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | The feature uses existing skill, template, validation, fixture, and generation mechanisms. |
