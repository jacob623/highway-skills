# Implementation Plan: Codify Coding Standards and Task List

**Branch**: `201-codify-coding-standards` | **Date**: 2026-10-31 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/201-codify-coding-standards/spec.md`

## Summary

The organization keeps one coding standard per technology at the repository root in `library/coding-standards/`, listed by one catalog, `library/coding-standards/coding-standards.md`. Highway ships that catalog with one sample standard for Terraform. After the person accepts an automation proposal, `highway-codify` writes `code/<id>/codify-tasks.md` together with the saved proposal and the automation catalog row. Each task produces one file, names the standard that applies or says none does, and is ordered after what it depends on. A test task follows a file only when its standard asks for tests. Codify then codes the tasks in order without asking again, reads each task's standard first, and marks each task done before the next. A task it cannot finish stops the run. The next run resumes at the first open task. The README is the last task. Acceptance still does not run the automation.

## Technical Context

**Language/Version**: Markdown skill, template, and library sources, Bash 3.2.57-compatible repository tests

**Primary Dependencies**: `.highway/skills/highway-codify/SKILL.md`, a new `.highway/library/templates/output/codify-tasks.md`, the new organization folder `library/coding-standards/`, and `.highway/tools/.distribution-manifest`. `.highway/tools/generate-agent-adapters.sh`, `.highway/tools/generate-catalog.sh`, `.highway/tools/generate-library-catalog.sh`, `.highway/tools/validate-library.sh`, and `.highway/tools/validate-skill.sh`

**Storage**: `library/coding-standards/coding-standards.md` and one file per standard, read only by codify. `code/<id>/codify-tasks.md` per automation. `code/<id>/codify.md`, `code/<id>/README.md`, component folders, and `code/code.md` keep their current shape

**Testing**: Amend `.highway/tools/tests/highway-codify.test.sh` with the task-list, standards, resume, and distribution strings. No assertion is removed. Then `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skill

**Performance Goals**: No runtime latency target

**Constraints**: One task produces one file. A test task only when the file's standard asks for tests. No question between acceptance and the first finished task. A blocked task stops the run. Codify never edits a standard or the standards catalog. Bash 3.2.57 only. No new runtime dependency. No shipped path may reference `.specify/` or `specs/`. Highway's library validator must not judge organization standards

**Scale/Scope**: One skill, one new output template, one organization catalog, one sample standard, one distribution manifest line, one amended test

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Spec Kit process gates, from `.specify/memory/constitution.md`:

- Packaging Gate: PASS. `library/coding-standards` becomes a shipped path through one `include` line in `.highway/tools/.distribution-manifest`, which keeps D1.6. The sample and catalog contain no `.specify/` or `specs/` reference, so D1.1 and D1.2 hold. D6.2 holds because codify cites `library/coding-standards/coding-standards.md`, which ships, and the new template, which ships under `.highway/library`.
- Toolchain Gate: PASS. The amended test is an existing shell test. D2.1 through D2.4 stay satisfied.
- Generator Gate: N/A. No `generate-*.sh` script changes. The organization folder is outside `.highway/library`, so the library catalog generator and validator are untouched.
- Correspondence Gate: PASS. D4.5 through D4.7 require regenerating the skill catalog, the library catalog (new template), and the adapters after `highway-codify` and `codify-tasks.md` change.
- Validation Gate: PASS. D3.1 requires a passing suite before the first edit. D3.3 requires the amended contract test. D3.4 does not rescore existing fixtures. D3.5 does not apply: no assertion is removed or loosened. D3.2 requires the suite to pass after the last edit.
- Skill Content Gate: PASS pending `validate-skill.sh` on `highway-codify` and `validate-library.sh` on `codify-tasks.md`. The skill must still satisfy P7.4 and P7.5 and the frontmatter lexicon. The new steps are procedure text, not new MUST-level rules.

Version bumps:

| Source | From | To |
|---|---|---|
| `highway-codify` | 2.0.0 | 3.0.0 |
| `codify-tasks.md` | new | 1.0.0 |

`highway-codify` is MAJOR because acceptance now writes a task list and code is produced from it, and the README is written by a task instead of with the proposal. `codify-record.md` stays 2.0.0. `codify-catalog.md` stays 1.0.0. `highway-request` and `highway-assessment` are unchanged.

No complexity exception is required.

### Post-design re-check

PASS. Organization standards stay outside the framework root, so Highway's authoring rules never judge them. The task list has one Highway template. Codify reads standards and never writes them. The distribution declares the new shipped folder once.

## Project Structure

### Documentation (this feature)

```text
specs/201-codify-coding-standards/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── coding-standards.md
│   ├── task-list.md
│   └── coding-flow.md
└── tasks.md
```

### Source Code (repository root)

```text
library/coding-standards/coding-standards.md
library/coding-standards/terraform.md
.highway/library/templates/output/codify-tasks.md
.highway/skills/highway-codify/SKILL.md
.highway/tools/.distribution-manifest
.highway/tools/tests/highway-codify.test.sh
```

**Structure Decision**: The organization owns `library/coding-standards/`. Highway owns the task list template and the codify steps that read the standards, write the task list, and code from it. Generated catalogs and adapters are regenerated, not edited.

## Complexity Tracking

> No constitution violation requires a justification table.
