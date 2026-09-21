# Implementation Plan: Highway Clarify

**Branch**: `058-highway-clarify` | **Date**: 2026-09-21 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/058-highway-clarify/spec.md`

## Summary

Add the `highway-clarify` Highway skill as the canonical source for deterministic clarification
lifecycle management. The implementation will add a Markdown/YAML clarification output template,
source skill instructions, focused contract and disposable-fixture tests, and regenerated agent
adapters/catalog entries. Generate and Update will preserve source bytes; Update will use an
integer revision for optimistic concurrency, abort conflicts without merging, and expose stable
Generate, Update, Inspect, Read, and Status contracts.

## Technical Context

**Language/Version**: Markdown skill instructions; repository validation tooling in Bash 3.2.57-compatible shell.

**Primary Dependencies**: `.highway/tools/validate-skill.sh`, `.highway/tools/validate-library.sh`,
`.highway/tools/tests/run-all.sh`, catalog generation, agent-adapter generation, and existing
Highway Markdown/YAML output conventions; no new runtime dependency.

**Storage**: User-owned colocated Markdown clarification artifacts with YAML frontmatter; no
centralized clarification directory and no new service or database.

**Testing**: A focused `highway-clarify.test.sh` covering static contract and disposable fixtures,
`validate-skill.sh`, `validate-library.sh`, catalog and adapter correspondence checks, and the full
`.highway/tools/tests/run-all.sh` suite.

**Target Platform**: macOS and Linux repository environments; generated adapters target GitHub
Copilot, Claude Code, and Cursor.

**Project Type**: Internal agent skill and repository governance tooling.

**Performance Goals**: Deterministic local artifact operations; no independent service latency,
throughput, or availability target is introduced.

**Constraints**: Preserve source-artifact bytes, use exact uppercase identifiers, resolve only
through declared deterministic mechanisms, keep clarification advisory, reject malformed state,
avoid automatic merges, remain Bash 3.2-compatible, and add no runtime dependency.

**Scale/Scope**: One clarification artifact per supported source artifact; initial identifier
families are REQ, DISC, ADR, and RA; five analysis categories; five commands; no external service
scale requirement.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Process Gates

| Gate | Result | Evidence planned |
|---|---|---|
| Packaging Gate | PASS | Shipped skill, template, test, catalog, and adapters contain no development-only `.specify/` or `specs/` dependency; packaging and link checks run. |
| Toolchain Gate | N/A | No file under `.highway/tools/` is modified by the feature; the focused test uses the existing declared Bash-compatible toolchain. |
| Generator Gate | N/A | No generator script is modified; declared generators are rerun after adding generator inputs. |
| Correspondence Gate | PASS | New `.highway/skills/highway-clarify/` source and shared template are inputs to catalog and adapter generators; regenerated outputs and correspondence tests are checked. |
| Validation Gate | PASS | New focused validation declares artifact classes, is evaluated against existing fixtures where applicable, and includes seeded failure probes. |
| Skill Content Gate | PASS | The new skill is checked against P1.1-P8.7 and P9.1 of `.highway/governance/constitution.md`, with complete shared-template citation and named verification/error paths. |

### Skill Content Gate Review

| Rule family | Plan application |
|---|---|
| P1.1-P1.7 | Normative skill rules will be atomic, bounded, dependency-declared, and explicit about absent or contradictory inputs. |
| P2.1-P2.5 | The skill remains technology-agnostic and labels any technology-specific example as illustrative. |
| P3.1-P3.5 | Normative claims cite approved repository policy sources using the required AS-6 format. |
| P4.1-P4.6 | Every quality claim names a validation check; no verification bypass or silent vulnerability alteration is introduced. |
| P5.1-P5.6 | Workflow failures map to abort, retry, fall back, or escalate with maximum attempts where retries exist. |
| P6.1-P6.6 | Resolution precedence, category ordering, status transitions, and revision checks are explicit and deterministic. |
| P7.1-P7.3 | Required skill sections, metadata, versioning, and source ownership remain conformant. |
| P8.1-P8.7 | Workflow, verification, configuration, output, and link rules use concrete repository paths and contracts. |
| P9.1 | The file-emitting skill cites the complete clarification output template rather than duplicating its structure. |

**Result: PASS.** No unjustified violations.

## Project Structure

### Documentation (this feature)

```text
specs/058-highway-clarify/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── clarification-artifact-contract.md
│   ├── command-response-contract.md
│   └── analysis-rules-contract.md
└── tasks.md                         # created by /speckit-tasks, not this command
```

### Source Code (repository root)

```text
.highway/
├── skills/highway-clarify/SKILL.md                         # canonical source skill
├── library/templates/output/clarification-record.md        # complete shared output template
└── tools/tests/highway-clarify.test.sh                     # focused contract and fixture test

.github/skills/highway-clarify/SKILL.md                     # generated GitHub Copilot adapter
.claude/skills/highway-clarify/SKILL.md                     # generated Claude Code adapter
.cursor/rules/highway-clarify.mdc                           # generated Cursor adapter
.highway/catalog/                                            # regenerated catalog output
```

**Structure Decision**: Extend the existing canonical `.highway/skills` and
`.highway/library/templates/output` model. The skill writes only user-owned colocated artifacts
outside the framework tree; tests use disposable temporary fixtures and never create live
`requests/`, `discoveries/`, `adrs/`, or `clarifications/` directories.

## Phase 0: Research Summary

Research is complete in [research.md](research.md). Decisions resolved:

- Use Markdown with YAML frontmatter and structured body sections for the clarification record.
- Use explicit identifier-family resolution and declared paths/catalogs, never filesystem ordering.
- Model updates with integer revision validation, abort-on-conflict, no merge, and a maximum of three retries.
- Keep findings advisory and permit repository users to invoke all five commands under existing repository access controls.
- Reuse existing validators, fixture-based tests, catalog generation, adapter generation, and no-partial-write conventions.

## Phase 1: Design Summary

Design artifacts:

- [data-model.md](data-model.md) defines source resolution, clarification records, findings, responses, history, revisions, and statuses.
- [contracts/clarification-artifact-contract.md](contracts/clarification-artifact-contract.md) defines the shared Markdown/YAML output shape.
- [contracts/command-response-contract.md](contracts/command-response-contract.md) defines command inputs and response fields.
- [contracts/analysis-rules-contract.md](contracts/analysis-rules-contract.md) defines deterministic category analysis and resolution rules.
- [quickstart.md](quickstart.md) defines runnable validation scenarios and expected outcomes.

## Post-Design Constitution Re-check

| Gate | Result | Evidence planned |
|---|---|---|
| P1/P5 workflow clarity | PASS | The skill workflow and Error Handling sections map every resolution, analysis, write, conflict, and malformed-input failure to one bounded action. |
| P6 determinism | PASS | Uppercase exact identifiers, explicit resolution precedence, category order, stable finding identity, revision comparison, and no time/randomness dependence are specified. |
| P9.1 shared output contract | PASS | The source skill cites `clarification-record.md`; the template owns the complete frontmatter and body structure. |
| D3 behavioral evidence | PASS | Focused disposable fixtures cover generation, update, conflict, read-only commands, malformed records, source immutability, and deterministic repeats. |
| D4 generated correspondence | PASS | Catalog and all three adapters are regenerated and checked for source correspondence. |
| D1 shippability and D6 currency | PASS | Shipped-path scans exclude development references and all documented paths resolve. |

**Post-design result: PASS.** No constitution amendment is required.

## Complexity Tracking

No constitution violations require justification; no additional runtime or persistence complexity is introduced.
