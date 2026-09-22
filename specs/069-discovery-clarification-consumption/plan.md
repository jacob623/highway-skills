# Implementation Plan: Discovery Consumption of Clarification Artifacts

**Branch**: `069-discovery-clarification-consumption` | **Date**: 2026-09-22 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/069-discovery-clarification-consumption/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Enhance `highway-discovery` to resolve an optional Request-linked Clarification artifact through
`clarifications/clarifications.md` immediately after Request resolution and consume validated
Clarification responses and findings as advisory evidence. The implementation adds a dedicated
consumer contract, extends the Discovery skill workflow and fallback rules, and adds focused
fixtures to the existing Discovery contract test. Existing Discovery sections, scoring,
recommendation selection, Clarification ownership, and ADR handoff remain unchanged.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown skill contracts and Bash 3.2.57-compatible test scripts

**Primary Dependencies**: Existing Highway skill contracts, shared Markdown output templates, and declared shell utilities; no new dependency

**Storage**: User-owned Markdown artifacts and catalogs under `requests/`, `clarifications/`, and `discoveries/`

**Testing**: `.highway/tools/tests/highway-discovery.test.sh` and `.highway/tools/tests/run-all.sh`

**Target Platform**: macOS and other environments supporting the declared Bash 3.2.57-compatible toolchain

**Project Type**: Distributed Markdown-based agent skill suite with shell contract tests

**Performance Goals**: Preserve the existing Discovery workflow's bounded, deterministic processing; no new latency or throughput target is required for optional catalog lookup

**Constraints**: Catalog-only lookup; read-only Clarification consumption; no Discovery schema, scoring, recommendation, ADR, or Clarification lifecycle changes; no runtime dependency; deterministic output; graceful fallback for unavailable optional input

**Scale/Scope**: One completed Request and zero or one unique Request-linked Clarification mapping per Discovery run; existing two-to-five candidate bounds and output limits remain in force

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Process gates

| Gate | Trigger | Verdict | Evidence |
|---|---|---|---|
| Packaging Gate | Implementation will touch shipped skill content | PASS planned | Generated shipped artifacts will be regenerated and validated after canonical edits; D1.1, D1.2, and D6.2 will be checked then |
| Toolchain Gate | Test script and skill validation changes | PASS | D2.1-D2.4: use existing Bash 3.2.57-compatible patterns and declared utilities only; no runtime dependency |
| Generator Gate | N/A unless a generator script itself changes | N/A | No generator change is planned |
| Correspondence Gate | Canonical skill input changes | PASS planned | D4.5-D4.7: regenerate catalog/adapters and verify correspondence after changing `.highway/skills/highway-discovery/SKILL.md` |
| Validation Gate | Existing Discovery test is amended | PASS planned | D3.4-D3.5: preserve existing fixtures/assertions and evaluate new probes without weakening checks |

### Skill content gate

| Rule | Verdict | Evidence |
|---|---|---|
| D1.5 | PASS | The implementation plan records this Constitution Check for the planned `.highway/skills/` and `.highway/library/` changes |
| D8.1 | PASS planned | The shared Clarification templates are consumed as dependencies; `highway-clarify` and all citing skill contracts will be re-validated if shared library artifacts change |

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

```text
specs/069-discovery-clarification-consumption/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
└── contracts/
  └── clarification-consumption-contract.md
```

### Source Code (repository root)

```text
.highway/
├── skills/highway-discovery/SKILL.md
├── library/templates/output/
│   ├── clarification-catalog.md
│   ├── clarification-record.md
│   └── discovery-record.md
└── tools/tests/highway-discovery.test.sh

.github/skills/highway-discovery/SKILL.md
.claude/skills/highway-discovery/SKILL.md
.cursor/rules/highway-discovery.mdc
```

**Structure Decision**: The feature changes the canonical Discovery skill and its existing
contract test, consumes the already-established Clarification library templates, and regenerates
the three distributed agent adapters. No application source tree, runtime service, or new output
schema is introduced.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

No constitution violations; this section is intentionally empty.

### Post-design re-evaluation

Phase 1 design preserves the pre-design verdicts. The design introduces no new dependency, no
Discovery schema section, no scoring or recommendation rule, and no ownership mutation. The
implementation remains subject to the planned D1.1-D1.2, D2.1-D2.4, D3.1-D3.8, D4.5-D4.7,
D6.2, and D8.1 checks when canonical shipped files and tests are edited.
