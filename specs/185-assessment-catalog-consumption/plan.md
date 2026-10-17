# Implementation Plan: Assessment Catalog Consumption

**Branch**: `185-assessment-catalog-consumption` | **Date**: 2026-10-17 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/185-assessment-catalog-consumption/spec.md`

## Summary

Extend the existing `highway-assessment` skill so its three domains can begin analysis from the
accepted ADR, Reference Architecture, Reference Implementation, and Capability Catalog indexes.
Catalogs provide navigation and direct relationship evidence; associated source records are opened
only for detail that the indexes do not contain. Assessment remains read-only for all owner
artifacts, preserves its existing finding lifecycle, and adds no capability or technology inventory.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown contracts and Bash 3.2.57-compatible repository tests

**Primary Dependencies**: Existing Highway catalogs, shared assessment findings contract, and shell test harness

**Storage**: Git-native Markdown catalogs and `.highway/library/knowledge/assessment-findings.md`

**Testing**: Focused shell contract test plus `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skill and documentation contract

**Performance Goals**: Catalog-first navigation avoids opening unrelated source records; no runtime latency target is required for this repository workflow

**Constraints**: Read-only owner boundaries, deterministic findings, Bash 3.2.57 compatibility, no new runtime dependencies, and no shipped reference to development paths

**Scale/Scope**: One repository-wide catalog view across the existing ADR, Architecture, Implementation, and Capability catalogs and three existing assessment domains

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Process gates:

- Packaging Gate: PASS. The feature modifies a shipped skill and requires path-reference validation under D1.1, D1.2, and D6.2.
- Toolchain Gate: PASS. The focused shell test uses only the declared toolchain under D2.1-D2.4.
- Validation Gate: PASS. The feature adds or modifies a test, so D3.4 and D3.5 apply.
- Correspondence Gate: PASS. The shipped skill is modified and generated adapters must be regenerated under D4.5-D4.7.
- Skill Content Gate: PASS pending implementation validation against the Highway Skills Constitution, required by D1.5 and D8.1.

No complexity exception is required.

## Project Structure

### Documentation (this feature)

```text
specs/185-assessment-catalog-consumption/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/           # Phase 1 output (/speckit-plan command)
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)

```text
.highway/
├── skills/highway-assessment/SKILL.md
└── tools/tests/
  └── highway-assessment.test.sh

.github/skills/highway-assessment/SKILL.md
.claude/skills/highway-assessment/SKILL.md
.cursor/skills/highway-assessment/SKILL.md
.agents/skills/highway-assessment/SKILL.md

specs/185-assessment-catalog-consumption/
├── plan.md
├── research.md
├── data-model.md
├── contracts/catalog-consumption-contract.md
└── quickstart.md
```

**Structure Decision**: Extend the canonical assessment skill and its existing focused shell
contract test, then regenerate the four declared agent adapters. Keep all feature design artifacts
under the 185 specification directory. No new runtime source tree, catalog, finding family, or
assessment domain is introduced.

## Complexity Tracking

No constitution violations. No complexity exception is required.
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
