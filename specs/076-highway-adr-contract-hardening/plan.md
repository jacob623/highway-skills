# Implementation Plan: Highway ADR Contract Hardening

**Branch**: `076-highway-adr-contract-hardening` | **Date**: 2026-09-22 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/076-highway-adr-contract-hardening/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Harden the existing `highway-adr` contract so mandatory confidence, catalog-owned uniqueness and
allocation, alternative semantics, frontmatter-only supersession metadata, scalar Clarification
absence, normalized matrix projection, and conditional Recommendation Override behavior are
explicitly specified, validated, and synchronized across canonical and generated artifacts.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown contracts; Bash 3.2.57-compatible repository tooling

**Primary Dependencies**: Existing Highway validators, Bash contract tests, catalogs, and generators

**Storage**: Repository Markdown, YAML frontmatter, and generated catalog/adapter files

**Testing**: Focused ADR/template tests, validators, generator correspondence tests, and `run-all.sh`

**Target Platform**: macOS authoring environment and distributed Highway agent trees

**Project Type**: Distributed Markdown skill suite with Bash validation and generation tooling

**Performance Goals**: Preserve bounded repository-test behavior; no runtime performance target

**Constraints**: Deterministic output, source immutability, no partial writes, Bash 3.2 compatibility,
no new dependencies, and generated-artifact synchronization

**Scale/Scope**: One canonical ADR skill, one ADR record template, one ADR catalog template, focused
tests, generated adapters/catalogs, and Feature 076 design artifacts

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

* **D1.5 PASS**: The change updates an existing skill and shared output contract within the
  established Highway boundaries.
* **D2.1-D2.4 PASS**: No new interpreter, package, runtime service, or persistence mechanism is
  introduced; Bash 3.2 compatibility remains binding.
* **D3.1-D3.5 PASS with execution evidence required**: Focused fixtures cover every new contract
  rule, including seeded failures and no-partial-write behavior, followed by full-suite evidence.
* **D4.1-D4.7 PASS**: Canonical skill/template inputs are edited directly; catalogs and adapters
  are regenerated and correspondence-tested.
* **D6.1-D6.2 PASS**: The feature specification, canonical inputs, tests, documentation, and
  generated copies remain synchronized.
* **D8.1 PASS**: Dependent ADR output-template citations are revalidated after template changes.
* **Skill Content Gate PASS pending implementation validation**: The canonical skill and output
  templates must remain valid under their existing validators and generated distribution checks.

No constitution violation or complexity exception is expected.

## Project Structure

### Documentation (this feature)

```text
specs/076-highway-adr-contract-hardening/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/           # Phase 1 output (/speckit-plan command)
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)

```text
 .highway/skills/highway-adr/SKILL.md
 .highway/library/templates/output/adr-record.md
 .highway/library/templates/output/adr-catalog.md
 .highway/tools/tests/highway-adr.test.sh
 .highway/tools/tests/output-template.test.sh
 .github/skills/highway-adr/SKILL.md
 .claude/skills/highway-adr/SKILL.md
 .cursor/rules/highway-adr.mdc
 specs/076-highway-adr-contract-hardening/
```

**Structure Decision**: Keep the canonical contract under `.highway/`, extend the existing ADR and
shared-template test surfaces, regenerate all declared adapters/catalogs, and retain planning
artifacts under Feature 076. No application source tree or runtime layer is introduced.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | No constitution violation or additional abstraction is required. |
