# Implementation Plan: Discovery Architecture Analysis

**Branch**: `049-discovery-architecture-analysis` | **Date**: 2026-09-19 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/049-discovery-architecture-analysis/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Extend `highway-discovery` from deterministic research summarization to deterministic
architectural analysis. The workflow will derive bounded Candidate Solution Options from closed
Request evidence, match governance and optional Reference Architectures using exact rules, render
the required Comparison Matrix, and calculate one advisory Recommendation for ADR review. The
implementation will preserve the existing Markdown skill, shared output-template, catalog
allocation, privacy-redaction, and no-partial-write boundaries; no new runtime or dependency is
introduced.

## Technical Context

**Language/Version**: Markdown skill instructions; POSIX-compatible Bash 3.2-compatible validation scripts

**Primary Dependencies**: Existing Highway shared templates, catalog/adapters generators, shell test harness, and governance baselines

**Storage**: User-owned Markdown files under `requests/` and `discoveries/`; repository-owned baselines and catalogs under `.highway/`

**Testing**: `.highway/tools/tests/highway-discovery.test.sh`, focused probe modes, `.highway/tools/validate-skill.sh`, `.highway/tools/validate-library.sh`, and `.highway/tools/tests/run-all.sh`

**Target Platform**: macOS and other environments supported by the existing shell skill toolchain

**Project Type**: Instruction-driven repository skill suite with generated agent adapters

**Performance Goals**: One bounded repository transaction; at most five retained options and finite closed-input catalogs; no network or unbounded service operation

**Constraints**: Exact deterministic matching only in Version 1; options are bounded to two through five; scores are 0-100; ADR remains authoritative; absent optional catalogs fall back as specified; source bytes remain unchanged on failure

**Scale/Scope**: One completed Request per invocation, five optional governance input classes, zero or more Reference Architectures, and one Discovery record/catalog transaction

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Pre-Research Gate

- **P1/P6 Unambiguous and deterministic directives**: PASS. The specification defines ordered
  generation, matching, scoring, tie-breaking, defaults, and failure behavior.
- **P4 Quality gates**: PASS. Privacy redaction, input validation, source immutability, and
  retained-output verification are explicit; the plan names focused tests and the full suite.
- **P8 Repeatability**: PASS. The feature requires byte-identical output for identical closed
  inputs and names validation commands.
- **P9 Shared output contracts**: PASS. The implementation will cite and extend the complete
  templates at `.highway/library/templates/output/discovery-record.md` and
  `.highway/library/templates/output/discovery-catalog.md`.
- **Security gate**: PASS. The workflow handles input files, redaction, and writes; the plan
  preserves the existing privacy-first and no-partial-write rules and requires the existing
  shell tests to prove them.
- **Testing gate**: PASS. New behavior requires focused contract/probe assertions that fail
  before implementation and pass after it, followed by the existing suite.

No constitution violation requires Complexity Tracking.

## Project Structure

### Documentation (this feature)

```text
specs/049-discovery-architecture-analysis/
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
├── skills/highway-discovery/SKILL.md
├── library/templates/output/
│   ├── discovery-record.md
│   └── discovery-catalog.md
└── tools/tests/highway-discovery.test.sh
.github/skills/highway-discovery/SKILL.md
.claude/skills/highway-discovery/SKILL.md
.cursor/rules/highway-discovery.mdc
specs/049-discovery-architecture-analysis/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
└── contracts/
```

**Structure Decision**: Update the canonical `.highway/` skill, shared output templates, and
focused test first; regenerate the declared agent adapters from the canonical skill. Keep all
Feature 049 design artifacts under this feature directory. User-owned `requests/` and
`discoveries/` remain runtime inputs/outputs and are not added as repository fixtures.

## Phase 0 Research Summary

Research decisions are recorded in [research.md](research.md). They resolve the planning
unknowns by selecting the existing Markdown/Bash distribution, preserving closed inputs, defining
exact matching and score formulas, and treating Reference Implementation evidence as an advisory
tie-break only.

## Phase 1 Design Summary

- [data-model.md](data-model.md) defines the Discovery-scoped entities, fields, relationships,
  validation rules, and state boundaries.
- [contracts/discovery-analysis-contract.md](contracts/discovery-analysis-contract.md) defines
  input loading, option generation, Reference Architecture matching, and failure behavior.
- [contracts/discovery-conversation-contract.md](contracts/discovery-conversation-contract.md)
  defines invocation, completion, failure, and advisory handoff responses.
- [contracts/discovery-artifact-contract.md](contracts/discovery-artifact-contract.md) defines
  the expanded record, matrix, recommendation, and ADR ownership boundary.
- [quickstart.md](quickstart.md) defines runnable validation scenarios and expected outcomes.

## Implementation Sequence

1. Extend the canonical Discovery skill and shared record template with Candidate Solution Options,
   Comparison Matrix, Recommendation, and Reference Architecture Matches.
2. Extend the analysis contract with option derivation, exact Reference Architecture matching,
   deterministic informational categories, and score calculation rules.
3. Add the Recommendation and ADR handoff contract assertions and update the focused Discovery
   test with positive, tie, absent-catalog, malformed-baseline, and no-write probes.
4. Regenerate agent adapters and catalogs using existing generators; never hand-edit generated
   outputs.
5. Run the focused tests, validators, adapter coverage, and full suite; confirm source baselines
   and generated artifacts remain consistent.

## Post-Design Constitution Check

- **Determinism and explicit criteria**: PASS. Every candidate, score, category, and tie-break has
  an ordered rule or numeric table, including zero-denominator and unavailable-catalog defaults.
- **Shared output contract**: PASS. The record template remains the complete structure authority;
  the skill cites it rather than maintaining a competing structure.
- **Security and privacy**: PASS. Redaction precedes copying and matching; no new network,
  deserialization, credential, or dependency behavior is introduced.
- **Verification**: PASS. The quickstart names focused probes, validation scripts, and the full
  suite, including byte-preservation assertions.
- **Governance ownership**: PASS. Discovery emits advisory analysis only; ADR records selection,
  rejection, acceptance, rationale, and consequences.

## Complexity Tracking

No violations.
