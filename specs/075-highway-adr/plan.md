# Implementation Plan: Highway ADR Decision Workflow

**Branch**: `075-highway-adr` | **Date**: 2026-09-22 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/075-highway-adr/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Implement a deterministic, consumer-only ADR workflow that resolves one completed Discovery
artifact, evaluates only its existing options, consumes optional Clarification and governance
evidence, and writes one accepted ADR plus one catalog entry. The implementation will follow the
existing Markdown skill, shared-template, Bash contract-test, and generated-adapter boundaries.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown contracts; Bash 3.2.57-compatible repository tooling

**Primary Dependencies**: Existing `.highway/tools/` validators, generators, catalogs, and Bash tests

**Storage**: Repository files only; ADR and catalog Markdown artifacts

**Testing**: Focused ADR/template tests, skill and library validators, generator correspondence tests, and `run-all.sh`

**Target Platform**: macOS authoring environment and distributed Highway trees

**Project Type**: Distributed Markdown skill suite with Bash validation and generation tooling

**Performance Goals**: Preserve existing bounded repository-test behavior; no runtime performance target

**Constraints**: Deterministic output, Bash 3.2 compatibility, no new dependencies, source immutability, no partial writes, and generated-artifact synchronization

**Scale/Scope**: One canonical skill, two shared output templates, focused tests, generated adapters/catalog entries, and Feature 075 design artifacts

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

* **D1.5 PASS**: This plan records a Constitution Check because it creates a skill and shared
  library templates.
* **D2.1-D2.4 PASS**: No new script, interpreter, package, or runtime dependency is planned;
  existing Bash/toolchain constraints remain binding.
* **D3.1-D3.8 PASS with execution evidence required**: The change adds focused behavioral and
  document-contract tests, preserves existing fixture classes, and requires before/after suite
  evidence plus seeded failure evidence for new checks.
* **D4.1-D4.7 PASS**: Canonical skill and templates are inputs; adapters, catalogs, and manifests
  are regenerated and never hand-edited.
* **D6.1-D6.2 PASS**: Skill, templates, tests, design documents, and generated copies are updated
  together and all references use existing or planned paths.
* **D8.1 PASS**: Any existing skill citing a changed shared template will be revalidated after the
  template change.
* **Skill Content Gate**: Triggered. The implementation must also satisfy the Highway Skills
  Constitution checks for skill frontmatter, dependency declarations, complete template citations,
  output structure, and generated distribution correspondence.

No constitution violation or complexity exception is expected.

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
├── skills/highway-adr/SKILL.md
├── library/templates/output/adr-record.md
├── library/templates/output/adr-catalog.md
├── tools/tests/highway-adr.test.sh
├── tools/tests/output-template.test.sh
└── catalog/ and generated manifests
.github/skills/highway-adr/SKILL.md
.claude/skills/highway-adr/SKILL.md
.cursor/rules/highway-adr.mdc
specs/075-highway-adr/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/adr-workflow.md
└── tasks.md                 # Created by /speckit-tasks
```

## Structure Decision

Keep canonical workflow and template inputs under `.highway/`, validate behavior with the existing
Bash test harness, regenerate all declared adapters/catalogs, and keep planning artifacts under the
active feature directory. No application source tree is introduced.

## Post-Design Constitution Check

* **D1.5, D2.1-D2.4, D6.1-D6.2 PASS**: The design adds no runtime dependency or new application
  layer and keeps all shipped behavior in the existing canonical Markdown and Bash boundaries.
* **D3.1-D3.8 PASS pending implementation evidence**: The design identifies focused static and
  executed-behavior fixtures, byte-preservation checks, deterministic-output checks, and the
  required before/after suite evidence. No validation rule is weakened.
* **D4.1-D4.7 PASS pending regeneration**: The design treats adapters, catalogs, and manifests as
  generated outputs and schedules regeneration from canonical inputs.
* **D8.1 PASS pending dependent validation**: The design calls for revalidating existing skills that
  cite either new shared ADR template only if they are added as dependents; no existing citation is
  assumed without verification.
* **Skill Content Gate PASS pending implementation validation**: The contract requires complete
  skill/template citations, valid frontmatter and output structure, and generated correspondence.

No design-stage constitution violation or complexity exception is present. Implementation evidence
remains intentionally pending `/speckit-implement`.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | No additional project, abstraction, service, or persistence layer is required. |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
