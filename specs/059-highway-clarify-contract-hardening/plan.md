# Implementation Plan: Highway Clarify Contract Hardening

**Branch**: `059-highway-clarify-contract-hardening` | **Date**: 2026-09-21 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/059-highway-clarify-contract-hardening/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Harden the existing `highway-clarify` skill and shared `clarification-record` template while preserving Feature 058's supported artifact families and advisory semantics. The implementation will make identifiers, consumer fields, profile discovery, finding ordering, privacy filtering, status derivation, regeneration, revision conflicts, and serialized output explicit and testable. Existing repository validators, focused Bash tests, catalog generation, adapter generation, correspondence checks, and packaging checks remain the validation path.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown/YAML contract files and Bash 3.2-compatible repository tooling

**Primary Dependencies**: Existing Highway validators, generators, templates, and shell test harnesses; no new runtime dependency

**Storage**: Colocated Markdown clarification records with YAML frontmatter

**Testing**: `.highway/tools/tests/highway-clarify.test.sh`, validators, catalog/adapter correspondence tests, packaging tests, and full `run-all.sh`

**Target Platform**: macOS/Linux repository workspaces; scripts must remain compatible with macOS Bash 3.2

**Project Type**: Repository governance skill and shared output-template contract

**Performance Goals**: Deterministic local processing with no network dependency; existing test runtime remains acceptable for disposable-fixture probes

**Constraints**: Preserve Feature 058 compatibility, source immutability, advisory-only semantics, no partial writes on failure, privacy filtering before retention, stable public fields, and generated-adapter correspondence

**Scale/Scope**: One canonical skill, one shared output template, focused test coverage, generated distribution artifacts, and Feature 059 planning documents

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The following gates pass before research:

- **Traceability**: Every planned change maps to FR-001..FR-027 and the three prioritized user stories; generated artifacts remain derived from canonical sources.
- **Determinism**: Stable identifiers, explicit profile precedence, total finding ordering, canonical serialization, and no volatile inputs are required.
- **Testing**: The skill and its executable test contract are modified, so focused tests must fail before each new behavior and pass after it; the existing suite must remain passing.
- **Security (AS-2)**: Privacy filtering handles secrets/credentials and regulated personal data across all retained content. File writes and deserialization are constrained to repository artifacts, and redaction is validated before write.
- **Maintainability**: Retained skill/template files must remain structurally authoritative; comments are added only when they express intent not visible from adjacent text.
- **Completion accountability**: Completion claims must name the executable validation command and passing result.

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
├── skills/highway-clarify/SKILL.md
├── library/templates/output/clarification-record.md
└── tools/tests/highway-clarify.test.sh
.github/skills/highway-clarify/SKILL.md       # generated
.claude/skills/highway-clarify/SKILL.md       # generated
.cursor/rules/highway-clarify.mdc             # generated
specs/059-highway-clarify-contract-hardening/
├── spec.md
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
└── contracts/
  └── clarification-hardening-contract.md
```

**Structure Decision**: Keep the canonical behavior in `.highway/skills` and the authoritative generated-record shape in `.highway/library/templates/output`; extend the existing focused test and regenerate adapters/catalogs rather than introducing a new runtime or source tree. Feature 059's design artifacts remain under its specification directory. `tasks.md` is intentionally not created by this planning phase.

## Phase 0: Research

Research decisions are recorded in [research.md](research.md). The key conclusions are to preserve the Feature 058 baseline, derive stable IDs directly from source IDs, use first-resolvable profile precedence, redact every retained value, define a total finding order, reconcile regeneration against valid state, and make conflicts/no-write failures explicit.

## Phase 1: Design

The data model in [data-model.md](data-model.md) defines identifiers, consumer fields, profiles, findings, history, revisions, statuses, and privacy-filtered values. The contract in [contracts/clarification-hardening-contract.md](contracts/clarification-hardening-contract.md) defines observable behavior and compatibility rules. The runnable validation path is in [quickstart.md](quickstart.md).

## Post-Design Constitution Check

All pre-research gates remain satisfied. The design adds no new dependency, network call, or persistence mechanism. Security remains under AS-2 because the skill handles secrets, PII, deserialization, and file writes; the design requires redaction before retention and no-write behavior on failed validation or revision checks. Testing remains executable through the focused contract test and existing repository suite. No complexity violation is introduced.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., 4th project] | [current need] | [why 3 projects insufficient] |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
