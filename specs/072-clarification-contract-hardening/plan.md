# Implementation Plan: Clarification Contract Hardening

**Branch**: `072-clarification-contract-hardening` | **Date**: 2026-09-22 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/072-clarification-contract-hardening/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Align the retained clarification-record template with the version 2.0.0 guided-resolution skill
contract, then make recommendation source filtering, precedence, conflict states, evidence
traceability, escalation ownership, option selection, and consumer restrictions explicit and
executable. The implementation remains Markdown contract content plus Bash contract probes;
generated adapters and catalogs are refreshed through the existing generators.

## Technical Context

**Language/Version**: Markdown skill contracts and Bash 3.2.57-compatible contract tests

**Primary Dependencies**: Existing Highway skill contracts, shared output templates, Clarification
catalogs, declared shell utilities, and existing generator scripts; no new dependency

**Storage**: User-owned Markdown clarification records and catalogs; generated adapters/catalogs;
no new storage system

**Testing**: `.highway/tools/tests/highway-clarify.test.sh`, skill and library validators,
generated-artifact checks, and `.highway/tools/tests/run-all.sh`

**Target Platform**: macOS and environments supporting the declared Bash-compatible toolchain

**Project Type**: Distributed Markdown-based agent skill suite with shell contract tests

**Performance Goals**: Preserve bounded deterministic contract validation; no new latency or
throughput target is required

**Constraints**: Select the artifact-specific source set before applying precedence; distinguish
`Unknown` from `Unknown / Escalate for Decision`; preserve source bytes, finding identity,
open-to-resolved lifecycle, privacy, no-partial-write behavior, and decision ownership; keep
generated artifacts synchronized

**Scale/Scope**: Four supported artifact types (`REQ`, `DISC`, `ADR`, `RA`); one guidance contract
per finding; existing record, catalog, revision, privacy, and count limits remain unchanged

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Process gates

| Gate | Trigger | Verdict | Evidence |
|---|---|---|---|
| Packaging Gate | Shipped skill or shared template changes | PASS planned | Regenerate adapters/catalogs and run packaging, validation, and full-suite checks |
| Toolchain Gate | Focused Bash contract test changes | PASS planned | Preserve Bash 3.2.57 compatibility and declared utilities; add no runtime dependency |
| Generator Gate | Generator scripts unchanged | N/A | Existing generators are invoked but not modified |
| Correspondence Gate | Canonical skill or shared template input changes | PASS planned | Regenerate all declared adapters/catalogs and verify source/generated correspondence |
| Validation Gate | Existing Clarification contract test changes | PASS planned | Preserve current probes and add version, fingerprint, source-set, conflict, traceability, lifecycle, and ownership probes |
| Skill Content Gate | `.highway/skills/` and `.highway/library/` files change | PASS planned | Apply D1.5 and revalidate all citing skills under D8.1 |

### Skill content gates

| Rule | Verdict | Evidence |
|---|---|---|
| D1.5 | PASS planned | The plan records the applicable constitution gates for canonical skill and shared-template changes |
| D8.1 | PASS planned | Revalidate `highway-clarify` and every generated adapter that cites the changed clarification-record template |

No gate is violated and no complexity exception is required.

## Project Structure

### Documentation (this feature)

```text
specs/072-clarification-contract-hardening/
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
├── skills/highway-clarify/SKILL.md
├── library/templates/output/clarification-record.md
└── tools/tests/highway-clarify.test.sh

.github/skills/highway-clarify/SKILL.md
.claude/skills/highway-clarify/SKILL.md
.cursor/rules/highway-clarify.mdc
.highway/catalog/index.json
.highway/catalog/index.md
.highway/catalog/library-index.json
.highway/catalog/library-index.md
```

**Structure Decision**: Update the canonical Clarification skill, shared clarification-record
template, and focused contract test. Use existing generators for distributed adapters and
catalogs, and validate every dependent emitted contract. No application source tree, runtime
service, or persistence layer is introduced.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | No constitution violation identified |

### Post-design re-evaluation

Phase 1 design preserves the pre-design verdicts. The design adds no dependency or runtime
service, keeps source and decision ownership boundaries intact, and makes the shared output
contract explicit. It remains subject to packaging, generator correspondence, validation, and
shared-template dependent-skill checks.
