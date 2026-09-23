# Implementation Plan: Setup Wizard Contract Hardening

**Branch**: `082-setup-wizard-contract-hardening` | **Date**: 2026-09-23 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from [spec.md](spec.md)

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Harden the Feature 081 Setup Wizard contract so terminal progress, owner-output ordering, user exits, owner outcomes, resume boundaries, and mutation ownership are explicit and directly verifiable. The change updates the Setup skill documentation, its focused static and executable tests, and the corresponding generated adapters and catalogs; it does not introduce a new persistence store or runtime dependency.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown contracts and Bash 3.2.57-compatible test fixtures

**Primary Dependencies**: Existing Highway owner skills, `.highway/tools/tests/`, and repository generators

**Storage**: Existing owner readiness artifacts only; no Setup-owned persistence

**Testing**: Focused static and executable Bash tests plus `.highway/tools/tests/run-all.sh`

**Target Platform**: macOS default shell/toolchain and the distributed Highway Skills tree

**Project Type**: Documentation-driven skill suite with generated agent adapters

**Performance Goals**: Focused validation remains bounded to the existing repository test suite; no runtime performance target changes

**Constraints**: Preserve Feature 081 behavior and dashboard; preserve owner authority; ask no new clarification questions; keep scripts Bash 3.2-compatible; keep shipped files free of development-only references; do not add runtime dependencies

**Scale/Scope**: One Setup skill, two focused test files, Feature 082 design artifacts, and generated outputs derived from the changed skill

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **D1.5**: PASS. The plan records this Constitution Check because it changes a shipped skill and generated adapters.
- **D2.1-D2.4**: PASS. No script language or runtime dependency is added; any test edits remain Bash 3.2-compatible and use the declared toolchain.
- **D3.1-D3.8**: PASS with implementation obligation. Focused tests will be observed before and after contract edits, and static evidence will remain separate from executed behavior.
- **D4.1-D4.7**: PASS with implementation obligation. Generated catalogs and adapters will be regenerated after source changes and checked for correspondence.
- **D6.1-D6.2**: PASS. The Setup skill, focused tests, and Feature 082 validation artifacts are updated together; all documented paths resolve.
- **D8.1**: PASS with implementation obligation. The changed Setup skill's generated adapters will be regenerated and revalidated.
- **D1.1-D1.4**: PASS. Feature artifacts remain development-only and no shipped artifact will gain `.specify/` or `specs/` references.

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
├── skills/highway-setup/SKILL.md
├── tools/tests/highway-setup.test.sh
├── tools/tests/highway-setup-executable.test.sh
├── tools/generate-catalog.sh
└── tools/generate-agent-adapters.sh
.github/skills/highway-setup/SKILL.md
.claude/skills/highway-setup/SKILL.md
.cursor/rules/highway-setup.mdc
specs/082-setup-wizard-contract-hardening/
├── spec.md
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/setup-wizard.md
└── tasks.md
```

**Structure Decision**: Keep the source-of-truth behavior in `.highway/skills/highway-setup/SKILL.md`, place static and executable evidence in the two existing Setup test files, regenerate the three declared agent adapters and catalogs, and keep Feature 082 planning records under its own `specs/` directory.

### Post-Design Constitution Check

- **D1.5**: PASS. The design still changes only the shipped Setup skill, its focused tests, and generated outputs already named in this plan.
- **D3.1-D3.8**: PASS. The quickstart separates static contract evidence, executable behavior evidence, focused tests, and full-suite validation; implementation will preserve the before/after and seeded-failure requirements.
- **D4.1-D4.7**: PASS. The quickstart requires regeneration and adapter coverage after changing the source skill.
- **D6.1-D6.2**: PASS. The normative contract, data model, quickstart, and source paths are aligned and resolve within their containing trees.
- **D8.1**: PASS. Generated adapter revalidation is explicitly included.
- **D1.1-D1.4 and D2.1-D2.4**: PASS. Design artifacts remain development-only, no shipped development references or runtime dependencies are introduced, and Bash 3.2 compatibility remains required.

## Complexity Tracking

No constitution violations require justification. The feature adds contract clarity and verification only; it does not add a service, persistence layer, dependency, or new project boundary.
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
