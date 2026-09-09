# Implementation Plan: Completion Claim Accountability

**Branch**: `021-completion-claim-accountability` | **Date**: 2026-09-08 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/021-completion-claim-accountability/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Feature 021 makes completion claims auditable. It adds D3.6 to require recorded behavior-specific
red-to-green evidence before a test-backed task is complete, adds D7.1 for semantic task-to-artifact
correspondence, adds D7.2 for mechanically complete requirement coverage, and adds D7.3 for reports
that separate checks from coverage. The implementation uses feature-local `coverage.md` and
`test-evidence.md` records, a new feature-level coverage test registered in the Development
Constitution Enforcement Map, and review guidance for the semantic rules.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Bash 3.2.57 and Markdown/YAML records

**Primary Dependencies**: Existing Spec Kit structure, `.highway/tools/tests/run-all.sh`, and the
Development Constitution Enforcement Map

**Storage**: Feature-local Markdown files under `specs/`; no runtime database

**Testing**: Bash test scripts under `.highway/tools/tests/`, temporary fixtures, and manual review
for semantic correspondence and report claims

**Target Platform**: macOS Bash 3.2.57 and the repository's supported GNU/Apple utility surface

**Project Type**: Repository governance and development-tooling feature

**Performance Goals**: Coverage validation completes as part of the existing suite without requiring
network access or repository history.

**Constraints**: Bash 3.2.57 compatibility; no runtime dependency; no edits to completed feature
directories; no proxy checks for semantic rules; static prose-contract tests remain valid.

**Scale/Scope**: All completed Spec Kit feature directories, their requirement IDs, implementation
tasks, coverage records, and feature-local evidence records.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Pre-Design Gate

| Gate | Trigger | Rules | Verdict |
|---|---|---|---|
| Spec Record Gate | Feature creates and modifies files under `specs/` | D5.1-D5.4 | PASS: new sequential directory `021-completion-claim-accountability`; no completed spec is edited |
| Toolchain Gate | Implementation adds or modifies files under `.highway/tools/` | D2.1-D2.4 | PASS: planned scripts use Bash 3.2.57 and the declared utility surface |
| Validation Gate | Implementation adds a validation test | D3.4-D3.5 | PASS: fixture verdicts will be recorded before enabling D7.2; no existing assertion is weakened |
| Packaging Gate | No shipped path is changed | D1.1, D1.2, D6.2 | N/A: no shipped artifact is in scope |
| Generator Gate | No generator script is changed | D4.1-D4.4 | N/A: generators are not in scope |
| Correspondence Gate | No declared generator input is changed | D4.5-D4.7 | N/A: generated artifact inputs are not changed |
| Skill Content Gate | No `.highway/skills/` or `.highway/library/` path is changed | D1.5 and Highway Skills Constitution | N/A: no skill or library content is in scope |

No gate has a FAIL or unresolved clarification. Phase 0 research may proceed.

## Project Structure

### Documentation (this feature)

```text
specs/021-completion-claim-accountability/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── coverage.md          # Feature completion requirement coverage (created during implementation)
├── test-evidence.md     # Red-to-green evidence record (created during implementation)
├── contracts/           # Not used: internal development-tooling feature
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)

```text
.highway/
├── tools/
│   ├── lib/
│   └── tests/
│       ├── fixtures/
│       └── completion-coverage.test.sh
└── ...
.specify/
└── memory/constitution.md
specs/
├── 001-... through 020-...
└── 021-completion-claim-accountability/
    ├── coverage.md
    └── test-evidence.md
```

**Structure Decision**: Extend the existing `.highway/tools/tests/` fixture-based test suite with
one feature-level coverage test. Store coverage and red-to-green evidence beside the feature's
planning artifacts under `specs/021-completion-claim-accountability/`; do not add a parallel
repository-wide report location or edit historical feature directories.

## Post-Design Constitution Check

The design introduces no new gate failures. The Validation Gate remains PASS because the coverage
check will be evaluated against every existing completed feature before enablement, with missing
coverage recorded rather than hidden. D7.1, D3.6, and D7.3 remain agent-checkable; only D7.2 is
automatic. The Spec Record Gate remains PASS because all new artifacts live in the new sequential
feature directory. Packaging, Generator, Correspondence, and Skill Content gates remain N/A.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

No constitution violations require justification.
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
