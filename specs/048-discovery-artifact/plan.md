# Implementation Plan: Discovery Analysis

**Branch**: `048-discovery-artifact` | **Date**: 2026-09-19 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/048-discovery-artifact/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Create the `highway-discovery` skill as the deterministic analysis stage between a completed
Request and later ADR work. The implementation will read one explicitly selected completed
`REQ` artifact plus the closed repository baselines, derive analysis sections and advisory
relationship candidates with ordered rule-based extraction, and transactionally write a
`DISC` record and catalog entry. The source skill, shared output templates, focused behavior
test, catalog registration, and three generated adapters will be kept in correspondence.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown skill instructions; repository scripts must remain Bash 3.2.57-compatible

**Primary Dependencies**: Existing skill/library validators, catalog generator, adapter generator, and test suite; no new runtime dependency

**Storage**: Plain Markdown source/templates and user-owned `requests/` and `discoveries/` artifacts

**Testing**: New focused discovery contract test, `validate-skill.sh`, `validate-library.sh`, generators, adapter coverage, and `run-all.sh`

**Target Platform**: macOS and Linux repository environments; GitHub Copilot, Claude Code, and Cursor adapters

**Project Type**: Internal agent skill and repository governance tooling

**Performance Goals**: One repository-local analysis per invocation; no service throughput target in Version 1

**Constraints**: Explicit completed-Request selection, closed inputs, deterministic output, privacy exclusion, advisory-only relationships, no partial writes, bounded allocation retries, and no new runtime dependency

**Scale/Scope**: One `REQ` source and one catalog allocation per invocation; Profile, Objective, Control, and NFR baselines are optional and repository-local

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Gate | Verdict | Evidence / planned satisfaction |
|---|---|---|
| **Packaging Gate** | PASS | The shipped skill and templates will contain no `.specify/` or `specs/` references; packaged-tree validation and cross-reference checks will run. (D1.1, D1.2, D6.2) |
| **Toolchain Gate** | PASS | Baseline test repairs and the new focused test will use only the declared Bash 3.2-compatible toolchain; no package, interpreter, or binary dependency is added. (D2.1-D2.4) |
| **Generator Gate** | N/A | No generator script changes are planned. |
| **Correspondence Gate** | PASS | The new source skill will receive catalog entries, three generated adapters, manifest rows, and a regeneration check. (D4.5-D4.7) |
| **Validation Gate** | PASS | Baseline fixture repairs and the focused Discovery test will preserve existing assertion strength; seeded expectations will be recorded before changes are enabled. (D3.4-D3.5) |
| **Skill Content Gate** | PASS | The source skill will be checked against the Highway Skills Constitution authoring rules P1-P9, including complete template citations, ordered workflow, bounded failures, and verification. (D1.5) |

**Process result**: PASS. No unjustified gate violations.

**Baseline note**: Before Feature 048 implementation, `.highway/tools/tests/run-all.sh` reported
36 passes and 3 failures: `constitution-inventory.test.sh`, `distribution-packaging.test.sh`,
and the existing `highway-new.test.sh`. These are recorded baseline conditions and must remain
separate from Feature 048 coverage claims.

## Baseline Failure Remediation

The implementation plan includes resolving the three baseline failures before claiming the
repository suite is green. These repairs are prerequisite work, not evidence of Discovery
behavior:

| Failure | Remediation | Exit evidence |
|---|---|---|
| `constitution-inventory.test.sh` | Repair the D1.2 seeded-defect probes so a malformed source document and malformed generated artifact make `distribution-packaging.test.sh` exit non-zero for the intended reason. Preserve the neutralized-probe success path. | The inventory test reports both D1.2 probes failing when seeded and passing when neutralized. |
| `distribution-packaging.test.sh` | Remove or correctly classify the stray `.DS_Store` path, then repair the negative packaging fixtures so development-only references, unresolved references, and overwrite guards each fail with their expected diagnostic. | The packaging test exits 0 and names the expected cause for each seeded failure. |
| `highway-new.test.sh` | Restore the allowed no-constraint phrases in the authoritative `highway-new` source skill, then regenerate and validate its catalog and agent adapters. | The focused `highway-new` test and generated-artifact correspondence checks exit 0. |

Remediation evidence: the three focused tests now exit 0; the catalog and agent adapters were
regenerated; and `.highway/tools/tests/run-all.sh` reports 39 passed and 0 failed. The negative
fixture diagnostics printed by `highway-setup` tests are expected assertions within passing tests,
not remaining suite failures.

## Completion Evidence

Executable checks: the Discovery focused test, adapter coverage, skill validation, library
validation, output-template correspondence, and `.highway/tools/tests/run-all.sh` all pass. The
final suite reports 40 passed and 0 failed, including `highway-discovery.test.sh`; the three
baseline failures remain resolved.

Requirement coverage: the source skill defines explicit completed-Request resolution, closed
inputs, deterministic extraction and relationship rules, privacy exclusion, advisory governance
boundaries, ADR handoff, catalog-authoritative allocation, bounded retries, and no-partial-write
behavior. The shared record/catalog templates and disposable byte-preservation harness cover the
required artifact structure and failure invariants.

Generated status: catalog and library indexes were regenerated; GitHub Copilot, Claude Code, and
Cursor Discovery adapters were generated; the distribution manifest and output-template coverage
include all new shipped paths.

Unresolved risk: Version 1 is an instruction-driven skill contract and static/disposable harness;
it does not add a separate runtime parser or service. Runtime agent interpretation remains bounded
by the deterministic rules and validation contracts in the shipped skill.

Run the remediation checks before adding Feature 048 coverage, capture the new baseline, and
then rerun the complete suite after Discovery implementation. Do not weaken an assertion or
attribute these failures to Feature 048.

## Project Structure

### Documentation (this feature)

```text
specs/048-discovery-artifact/
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
├── library/templates/output/
│   ├── discovery-record.md                 # NEW shared output template
│   └── discovery-catalog.md                # NEW shared output template
├── skills/
│   └── highway-discovery/SKILL.md          # NEW source skill
└── tools/tests/
    └── highway-discovery.test.sh           # NEW focused behavior test

.github/skills/highway-discovery/SKILL.md   # GENERATED
.claude/skills/highway-discovery/SKILL.md   # GENERATED
.cursor/rules/highway-discovery.mdc         # GENERATED
.highway/catalog/                            # REGENERATED catalog/manifests
requests/                                    # EXISTING user-owned source artifacts
discoveries/                                 # USER-OWNED runtime output created by the skill
├── discoveries.md
└── DISCXXXXXX.md
```

**Structure Decision**: Add one source skill, two shared output templates, and one focused
transaction/analysis test. Regenerate catalog and adapter artifacts through existing generators;
do not hand-edit generated outputs. Runtime Discovery files remain outside `.highway/`.

## Phase 0: Research Summary

Research is complete in [research.md](research.md). Decisions resolved:

- Use the existing Markdown skill plus generated catalog/adapter distribution pattern.
- Select exactly one completed Request by explicit `REQ` identifier.
- Apply ordered, deterministic extraction and matching rules defined in the research artifact.
- Use a read-only closed input set: Request, Profile, Objective, Control, and NFR baselines.
- Build, validate, and exclusively allocate both outputs before any write; retry allocation at most three times.
- Keep relationship candidates advisory and preserve source governance bytes.
- Exclude secrets and regulated personal data before output construction.

## Phase 1: Design Summary

Design artifacts:

- [data-model.md](data-model.md) defines Request Input, Discovery Record, Discovery Catalog,
  Analysis Section, Relationship Candidate, confidence, and transaction state.
- [contracts/discovery-conversation-contract.md](contracts/discovery-conversation-contract.md) defines
  the agent-facing invocation, resolution, completion, and failure responses.
- [contracts/discovery-analysis-contract.md](contracts/discovery-analysis-contract.md) defines
  the closed inputs, deterministic rule order, and analysis failure behavior.
- [contracts/discovery-artifact-contract.md](contracts/discovery-artifact-contract.md) defines
  the record and catalog structures, invariants, and ADR handoff.
- [quickstart.md](quickstart.md) defines runnable validation scenarios and expected evidence.

## Post-Design Constitution Re-check

| Gate | Result | Evidence |
|---|---|---|
| P5 bounded failure handling | PASS | Missing/invalid source, privacy failure, validation failure, write failure, and catalog conflicts have explicit abort behavior; allocation retries are capped at three. |
| P6 deterministic decisions | PASS | Source resolution, input ordering, redaction, section extraction, relationship confidence, sorting, title derivation, and serialization order are specified. |
| P9 shared output contracts | PASS | The source skill will cite the complete discovery record and catalog templates rather than duplicating their full structures. |
| D3 verification | PASS | Focused behavior coverage is planned; static contract checks will be reported separately from executable behavior. (D3.3, D3.6, D3.8) |
| D4 generated correspondence | PASS | Catalog/adapters will be regenerated and checked after source/template changes. (D4.5-D4.7) |
| D8 shared-library dependency review | PASS | The new skill will be validated against both newly added templates after they are created. (D8.1) |

**Post-Design result**: PASS. No constitution amendment is required.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | The feature extends existing skill, template, generator, and test patterns without adding a runtime or parallel application structure. |
