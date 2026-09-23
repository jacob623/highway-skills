# Implementation Plan: Clarification Record Integrity

**Branch**: `073-clarification-record-integrity` | **Date**: 2026-09-22 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/073-clarification-record-integrity/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Restore a structurally valid, deterministic clarification-record template by making resolution
history traceable to findings, separating retained data from explanatory rules, normalizing
evidence and fingerprints, and documenting recommendation basis and option lifecycle states.
Implementation remains canonical Markdown contract content plus Bash contract probes; generated
adapters and catalogs are refreshed through existing generators.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown contracts and Bash 3.2.57-compatible contract tests

**Primary Dependencies**: Existing Highway clarification template, canonical skill, validators,
focused contract tests, and catalog/adapter generators; no new dependency

**Storage**: User-owned Markdown clarification records and generated catalogs/adapters; no new storage

**Testing**: `.highway/tools/tests/highway-clarify.test.sh`, `output-template.test.sh`, validators,
generated-artifact checks, and `.highway/tools/tests/run-all.sh`

**Target Platform**: macOS and environments supporting the declared Bash-compatible toolchain

**Project Type**: Distributed Markdown-based agent skill suite with shell contract tests

**Performance Goals**: Preserve bounded deterministic validation; no new latency or throughput target

**Constraints**: Preserve version 2.0.0 identity, privacy, source immutability, no-partial-write
behavior, advisory ownership, and generated-artifact correspondence; keep explanatory prose outside
retained record sections

**Scale/Scope**: One shared clarification-record template, four artifact types (`REQ`, `DISC`, `ADR`,
`RA`), representative findings, and existing catalog/adapter outputs

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Gate | Trigger | Verdict | Evidence |
|---|---|---|---|
| Packaging Gate | Shared template changes ship in the distribution | PASS planned | Regenerate catalogs/adapters and run packaging and full-suite checks |
| Toolchain Gate | Focused Bash contract tests change | PASS planned | Preserve Bash 3.2.57 compatibility and add no runtime dependency |
| Correspondence Gate | Canonical template input changes | PASS planned | Regenerate all declared adapters/catalogs and verify correspondence |
| Validation Gate | Existing clarification/output-template tests change | PASS planned | Add focused probes for history, structure, evidence, basis, state, and lifecycle |
| Skill Content Gate | Shared library artifact changes | PASS planned | Revalidate `highway-clarify` and every dependent citation under D8.1 |

No gate is violated and no complexity exception is required.

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
├── library/templates/output/clarification-record.md
├── skills/highway-clarify/SKILL.md
└── tools/tests/
  ├── highway-clarify.test.sh
  └── output-template.test.sh

.github/skills/highway-clarify/SKILL.md
.claude/skills/highway-clarify/SKILL.md
.cursor/rules/highway-clarify.mdc
.highway/catalog/index.json
.highway/catalog/index.md
.highway/catalog/library-index.json
.highway/catalog/library-index.md
```

**Structure Decision**: Update the canonical shared output template and focused contract tests.
Use existing generators for distributed adapters and catalogs, then validate the dependent
Clarification skill. No application source tree, runtime service, or persistence layer is added.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | No constitution violation identified |
