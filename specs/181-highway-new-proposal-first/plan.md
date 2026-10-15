# Implementation Plan: Highway New Proposal-First Request Development

**Branch**: `181-highway-new-proposal-first` | **Date**: 2026-10-15 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/181-highway-new-proposal-first/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Modernize `highway-new` from questionnaire-first intake to proposal-first Request development.
The canonical skill will adopt the established Profile/Objectives interaction model: present a
grounded Request Discovery Contribution Opportunity when evidence supports a responsible first
pass, re-evaluate after substantive contributions, collect only consequential missing evidence,
and present a Converged Request Proposal before the existing acceptance and creation boundary.
Existing Request templates, seven evidence domains, Solution Constraints validation, privacy rules,
allocation transaction, no-write guarantees, and Discovery/ADR ownership remain authoritative.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Markdown skill contracts and POSIX-compatible Bash 3.2 test scripts

**Primary Dependencies**: Existing Highway Experience Standard, Request templates, and shell test harness; no new dependency

**Storage**: Existing user-owned `requests/REQXXXXXX.md` records and `requests/requests.md` catalog

**Testing**: `.highway/tools/tests/highway-new.test.sh`, `output-template.test.sh`, canonical validators, generated-adapter correspondence, and `.highway/tools/tests/run-all.sh`

**Target Platform**: Git-native Highway distribution on macOS Bash 3.2 and declared agent adapter trees

**Project Type**: Governance skill suite with generated agent adapters and Markdown output contracts

**Performance Goals**: No new runtime performance target; proposal review must avoid duplicate evidence questions and preserve deterministic existing behavior

**Constraints**: Preserve Request ownership and seven-domain Evidence Completeness Rules; preserve all eight Solution Constraint fields and states; preserve privacy, allocation, retry, validation, no-write, pause/cancel, Discovery handoff, and ADR boundaries; generated adapters must remain source-correspondent

**Scale/Scope**: One canonical `highway-new` skill, its four generated adapters, existing Request templates, focused tests, and Feature 181 design artifacts; no new service, UI, database, or external integration

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The plan changes a shipped skill, generated adapters, focused tests, and no shared output template.
The applicable process gates are:

- **D3.1/D3.2/D3.3/D3.5/D3.6**: begin and end with the full suite, add or amend focused tests,
  preserve existing assertions, and observe new contract tests fail before implementation.
- **D4.1/D4.4/D4.5/D4.6/D4.7**: regenerate catalogs and all declared adapters from canonical
  `highway-new` after source changes; do not hand-edit generated artifacts.
- **D6.1/D6.2**: keep the live skill and its referenced templates/standards current and resolvable.
- **D8.1**: revalidate the changed skill against every shared library artifact it cites.

The applicable Highway Skills Constitution gates are **P1.1-P1.4** (layer and artifact boundary),
**P6.4** (deterministic decision criteria), **P7.3-P7.5** (contract references and maintainability),
**P8.3/P8.7** (verification and failure behavior), **P9.1-P9.8** (shared output contracts),
**P11.1-P11.5** (declared repository context), and **P12.5/P12.13-P12.15** (owner-controlled
completion, results, and orchestration boundaries). All are PASS by design: the change keeps
runtime ownership in `highway-new`, cites existing templates rather than duplicating them, and
adds deterministic contract tests for proposal/refinement/acceptance boundaries. No complexity
exception is required.

## Project Structure

### Documentation (this feature)

```text
specs/181-highway-new-proposal-first/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/           # Phase 1 output (/speckit-plan command)
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)

```text
.highway/skills/highway-new/SKILL.md
.highway/library/templates/output/request-record.md
.highway/library/templates/output/request-catalog.md
.highway/tools/tests/highway-new.test.sh
.highway/tools/tests/output-template.test.sh
.github/skills/highway-new/SKILL.md
.claude/skills/highway-new/SKILL.md
.cursor/skills/highway-new/SKILL.md
.agents/skills/highway-new/SKILL.md
.highway/catalog/index.json
.highway/catalog/index.md
.highway/tools/.adapter-manifest
```

**Structure Decision**: Keep the existing canonical-skill/generated-adapter architecture. Modify
only the canonical `highway-new` skill and focused contract tests, preserve the shared Request
templates unless a structural contract requires no change, regenerate all derived adapters/catalogs,
and store design/validation artifacts under Feature 181.

**Post-design Constitution Check**: PASS. Phase 0 research and Phase 1 design preserve the
canonical skill/template ownership model, introduce no runtime dependency or new persistence state,
keep proposal content transient, define deterministic no-write and evidence-reuse boundaries, and
identify focused tests plus generated correspondence validation for every changed shipped surface.
No gate requires a complexity exception.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | The feature fits the existing skill, template, test, and generator structure. |
