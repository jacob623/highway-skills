# Implementation Plan: Discovery Solution Constraints

**Branch**: `060-discovery-solution-constraints` | **Date**: 2026-09-21 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/060-discovery-solution-constraints/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Extend Discovery to consume the eight closed Request Solution Constraints fields before candidate
generation and filtering, eliminate candidates that violate mandatory solution boundaries, and
score only surviving candidates with deterministic platform and known-system alignment. Extend the
canonical Discovery skill, shared record template, analysis/artifact contracts, focused tests, and
generated adapters/catalogs without changing Request schema ownership or ADR decision ownership.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown skill instructions; POSIX-compatible Bash 3.2-compatible validation scripts

**Primary Dependencies**: Existing Highway shared templates, catalog/adapters generators, shell test harness, and governance baselines

**Storage**: User-owned Markdown files under `requests/` and `discoveries/`; repository-owned baselines and catalogs under `.highway/`

**Testing**: `.highway/tools/tests/highway-discovery.test.sh`, focused probe modes, `.highway/tools/validate-skill.sh`, `.highway/tools/validate-library.sh`, adapter/catalog checks, and `.highway/tools/tests/run-all.sh`

**Target Platform**: macOS and other environments supported by the existing shell skill toolchain

**Project Type**: Instruction-driven repository skill suite with generated agent adapters

**Performance Goals**: One bounded repository transaction; at most five retained options and finite closed-input catalogs; no network or unbounded service operation

**Constraints**: Exact deterministic rules; options bounded to two through five; scores 0-100; mandatory constraints filter before scoring; ADR remains authoritative; source bytes remain unchanged on failure

**Scale/Scope**: One completed Request per invocation, eight Solution Constraint fields, five optional governance input classes, zero or more Reference Architectures, and one Discovery record/catalog transaction

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Pre-Research Gate

- **D1.5**: PASS. The plan modifies a shipped skill and shared library template and records the
  Highway Skills Constitution gate below.
- **D2.1-D2.4**: PASS. No new script runtime, package, interpreter, binary, or non-portable shell
  construct is introduced.
- **D3.1-D3.3**: PASS with implementation prerequisite. Existing focused tests and the full suite
  are the baseline; the implementation must amend `.highway/tools/tests/highway-discovery.test.sh`.
- **D4.4-D4.7**: PASS with implementation prerequisite. Canonical skill changes require adapter
  regeneration; template changes require library catalog regeneration.
- **D6.1-D6.2**: PASS. Discovery contracts, shared templates, focused tests, and generated outputs
  are updated together and all referenced paths exist.

### Skill Content Gate

- **Highway Skills Constitution**: PASS pending implementation validation. The plan preserves the
  existing skill's advisory ownership, privacy-first processing, deterministic ordering, source
  immutability, and no-partial-write behavior; final validation must run the canonical validators
  and focused tests against the changed skill and template.

No constitution violation requires Complexity Tracking.

## Project Structure

### Documentation (this feature)

```text
specs/060-discovery-solution-constraints/
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
├── library/templates/output/
│   ├── discovery-record.md
│   └── discovery-catalog.md
└── tools/tests/
  └── highway-discovery.test.sh
.github/skills/highway-discovery/SKILL.md
.claude/skills/highway-discovery/SKILL.md
.cursor/rules/highway-discovery.mdc
specs/060-discovery-solution-constraints/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
└── contracts/
```

**Structure Decision**: Update canonical Discovery skill, shared output templates, analysis and
artifact contracts, and focused shell tests; regenerate declared agent adapters and catalogs from
canonical sources. Request and Discovery user-owned runtime artifacts remain inputs/outputs and are
not added as repository fixtures.

## Phase 0 Research Summary

Research decisions are recorded in [research.md](research.md). They resolve the implementation
unknowns by preserving the existing Markdown/Bash distribution, consuming the Request contract as
closed input, separating mandatory filtering from retained-candidate scoring, and extending the
existing Discovery contracts rather than introducing a new interface.

## Phase 1 Design Summary

- [data-model.md](data-model.md) defines Request constraints, candidate eligibility, elimination
  entries, retained candidate alignment, matrix rows, and output state boundaries.
- [contracts/discovery-analysis-contract.md](contracts/discovery-analysis-contract.md) defines
  input loading, constraint evaluation order, deterministic filtering, scoring, ordering, and
  failure behavior.
- [contracts/discovery-conversation-contract.md](contracts/discovery-conversation-contract.md)
  preserves invocation, completion, failure, and ADR handoff behavior.
- [contracts/discovery-artifact-contract.md](contracts/discovery-artifact-contract.md) defines
  the expanded record, elimination log, matrix, alignment fields, and compliance semantics.
- [quickstart.md](quickstart.md) defines runnable validation scenarios and expected outcomes.

## Implementation Sequence

1. Extend the canonical Discovery skill with the eight inputs, filtering order, required-platform
   elimination, deterministic known-system table, canonical constraint ordering, elimination-log
   ordering, retained-only alignment semantics, and revised score weights.
2. Extend the shared Discovery record template with Request Solution Constraints, Candidate
   Elimination Log, retained-candidate constraint traceability, matrix columns, compliance values,
   and updated Recommendation score fields.
3. Extend the analysis and artifact contracts while preserving conversation and ADR ownership;
   update focused Discovery and shared-template tests with positive, negative, deterministic, and
   no-write probes.
4. Regenerate GitHub, Claude, and Cursor adapters plus skill/library catalogs using existing
   generators; never hand-edit generated outputs.
5. Run focused validators, adapter/catalog/package checks, seeded probes, and the full suite; verify
   source baselines remain byte-for-byte unchanged on failure paths.

## Post-Design Constitution Check

- **Determinism and explicit criteria**: PASS. Allowed classes, mandatory filtering, known-system
  100/75/50 scoring, platform scoring, canonical field ordering, elimination ordering, score
  weights, and failure behavior are explicit.
- **Shared output contract**: PASS. The shared Discovery record template remains authoritative;
  the skill and artifact contract reference the same section and field order.
- **Security and privacy**: PASS. Existing redaction precedes copying, matching, scoring, and
  serialization; no new network or credential behavior is introduced.
- **Verification**: PASS. Focused tests must prove required-platform elimination, elimination-log
  ordering, retained-only scoring, known-system table behavior, canonical output order, and no-write
  aborts before the full suite.
- **Governance ownership**: PASS. Discovery remains advisory; ADR remains responsible for
  selection, rejection, rationale, consequences, and authorization.

## Complexity Tracking

No violations.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., 4th project] | [current need] | [why 3 projects insufficient] |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
