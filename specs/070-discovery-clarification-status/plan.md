# Implementation Plan: Discovery Clarification Status Rules

**Branch**: `070-discovery-clarification-status` | **Date**: 2026-09-22 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/070-discovery-clarification-status/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Clarify the existing `highway-discovery` Clarification Consumption Contract with explicit
status, evidence precedence, finding-state, invalid-record, verification, and determinism
rules. Update the canonical Discovery contract and its focused shell contract test, then
regenerate distributed adapters and catalogs. No Discovery schema, scoring, recommendation,
ownership, or ADR behavior changes are permitted.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown skill contracts and Bash 3.2.57-compatible test scripts

**Primary Dependencies**: Existing Highway skill contracts, shared Clarification templates,
and declared shell utilities; no new dependency

**Storage**: User-owned Markdown artifacts and catalogs under `requests/`, `clarifications/`,
and `discoveries/`; no new storage

**Testing**: `.highway/tools/tests/highway-discovery.test.sh`, skill validation, generators,
and `.highway/tools/tests/run-all.sh`

**Target Platform**: macOS and environments supporting the declared Bash-compatible toolchain

**Project Type**: Distributed Markdown-based agent skill suite with shell contract tests

**Performance Goals**: Preserve bounded, deterministic Discovery processing; no new latency or
throughput target is required for optional catalog validation

**Constraints**: Catalog-only lookup; read-only Clarification consumption; invalid records are
unavailable; no schema, scoring, recommendation, ADR, or lifecycle changes; deterministic
fallback; generated artifacts must remain synchronized

**Scale/Scope**: One completed Request and zero or one unique Request-linked Clarification per
Discovery run; existing candidate and output limits remain unchanged

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Process gates

| Gate | Trigger | Verdict | Evidence |
|---|---|---|---|
| Packaging Gate | Shipped skill content changes | PASS planned | Regenerate adapters/catalogs and run packaging, validation, and full-suite checks |
| Toolchain Gate | Markdown contract and Bash test changes | PASS | Existing Bash 3.2-compatible patterns and utilities; no runtime dependency |
| Generator Gate | Generator scripts unchanged | N/A | No generator implementation changes |
| Correspondence Gate | Canonical Discovery skill changes | PASS planned | Regenerate all adapters/catalogs and verify source/generated correspondence |
| Validation Gate | Existing Discovery contract test changes | PASS planned | Preserve existing probes and add status/finding/invalidity/determinism probes |

### Skill content gate

| Rule | Verdict | Evidence |
|---|---|---|
| D1.5 | PASS | The plan records the applicable Constitution Check for shipped skill and test changes |
| D8.1 | PASS planned | Revalidate dependent Clarification and Discovery contracts if shared templates are touched |

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
├── skills/highway-discovery/SKILL.md
└── tools/tests/highway-discovery.test.sh

.github/skills/highway-discovery/SKILL.md
.claude/skills/highway-discovery/SKILL.md
.cursor/rules/highway-discovery.mdc
.highway/catalog/index.json
.highway/catalog/index.md
.highway/catalog/library-index.json
.highway/catalog/library-index.md
```

**Structure Decision**: Update the canonical Discovery skill and its focused contract test,
then use existing generators for distributed adapters and catalogs. The already-established
Clarification templates remain dependencies and are not re-owned by Discovery. No application
source tree, runtime service, or new output schema is introduced.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
No constitution violations; this section is intentionally empty.

### Post-design re-evaluation

Phase 1 design preserves the pre-design verdicts. The design adds no dependency, no output
section, no scoring or recommendation rule, and no ownership mutation. It remains subject to
the planned packaging, generator correspondence, validation, and shared-template checks.
