# Implementation Plan: Codify Proposal Tasks

**Branch**: `203-codify-proposal-tasks` | **Date**: 2026-11-01 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/203-codify-proposal-tasks/spec.md`

## Summary

`highway-codify` suggests actions to automate and proposes each one as ordered tasks. The suggestion list opens on the implementation's product, platform, or application, read from its one Technology Choice, or on its title when it names none or several. Each suggestion is an action that starts with a verb, built from a realized capability, with one sentence that expands on it. The list ends with an invitation to describe another idea. The running-instance rule still orders the list and is no longer shown.

After an action is selected, `start` drafts the proposal and writes nothing. A new `align` step compares the executor and each task with the coding standard for its technology. It covers provider boundaries, accepted libraries or modules, and required patterns. It then checks named products, APIs, plugins, modules, and libraries against the vendor's current public documentation. Corrections and inconclusive results are named before the proposal and are not saved. A standard that cannot be met for the selected action returns to suggestions. A new `propose` step shows the title, summary, description, acceptance criteria, a top-to-bottom diagram, and the tasks. Each task is one action against one target, with scope, provider, method, and assumptions. An edit that changes a provider or method runs `align` again on that task.

Acceptance saves those six sections and drops Components, Current State, Action, Day, and Means from the record. The file list writes the executor once, then each task's own files, then the readme. `highway-adr` matches span coverage on the automation title instead of `## Action`.

## Technical Context

**Language/Version**: Markdown skill and template sources, Bash 3.2.57-compatible repository tests

**Primary Dependencies**: `.highway/skills/highway-codify/SKILL.md`, `.highway/skills/highway-adr/SKILL.md`, `.highway/library/templates/output/codify-record.md`, `.highway/library/templates/output/codify-tasks.md`. Organization standards at `library/coding-standards/` are read, never edited. `.highway/tools/generate-agent-adapters.sh`, `.highway/tools/generate-catalog.sh`, `.highway/tools/generate-library-catalog.sh`, `.highway/tools/validate-library.sh`, and `.highway/tools/validate-skill.sh`

**Storage**: Existing repository files only. `code/[ID]/codify.md` gains `## Tasks` and loses `## Components`, `## Current State`, `## Action`, `## Day`, and `## Means`. `code/[ID]/codify-tasks.md` tags each line with `Executor`, a proposal task number, or `README`. Check results are never written.

**Testing**: Amend `.highway/tools/tests/highway-codify.test.sh` where it asserts superseded strings, with the reason recorded in [research.md](research.md). Add `.highway/tools/tests/codify-proposal-tasks.test.sh` for the strings this feature adds, observed failing before the skill edits. Then `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skills

**Performance Goals**: No runtime latency target

**Constraints**: Nothing is written before acceptance. The source check sends only the product, feature, or library name and the vendor name, and a secondary source cannot confirm or contradict. The checks keep the selected action. Codify does not edit a coding standard or its catalog. Each `###` section of codify stays at or under 400 words (P7.5), and the skill keeps 12 or fewer MUST-level rules (P7.4). Existing strings asserted by `adr-span-progression.test.sh`, `onboarding-assessment-guidance.test.sh`, and `output-template.test.sh` stay. The assessment never contains `/highway-codify`. Bash 3.2.57 only. No new runtime dependency. No shipped path may reference `.specify/` or `specs/`

**Scale/Scope**: Two skills, two output templates, one amended test, one new test

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Process gates, from `.specify/memory/constitution.md`:

- Packaging Gate: PASS. Only shipped skills and templates change, and none gains a `.specify/` or `specs/` reference. D1.1 and D1.2 hold. D6.2 holds because every cited path already ships.
- Toolchain Gate: PASS. The new test uses `grep`, `sed`, and `awk` only. D2.1 through D2.4 stay satisfied.
- Generator Gate: N/A. No `generate-*.sh` script changes.
- Correspondence Gate: PASS. D4.5 through D4.7 require regenerating the skill catalog, the library catalog, and the adapters after the two skills and two templates change.
- Validation Gate: N/A. No validation check is added or changed.
- D3.1 requires a passing suite before the first edit, and D3.2 after the last edit. D3.3 is met by the amended and new tests. D3.6 requires the new test to be observed failing before the skill edits.
- D3.5: four assertions in `highway-codify.test.sh` are replaced. Each replacement names the superseded behavior in [research.md](research.md), and each is paired with a stricter assertion for the behavior that replaces it. No assertion is loosened.
- D8.1: `codify-record.md` and `codify-tasks.md` are cited by `highway-codify` only. `highway-adr` reads saved `codify.md` records and is re-validated after its coverage line changes.

Skill content gates, from `.highway/governance/constitution.md`:

- PASS pending `validate-skill.sh` on `highway-codify` and `highway-adr`, and `validate-library.sh` on both templates. Splitting the proposal into `start`, `align`, and `propose` keeps each section under P7.5. The checks are procedure text, not new MUST-level rules. P8.1 holds because the proposal tasks are one sequential ordered list.

Version bumps:

| Source | From | To |
|---|---|---|
| `highway-codify` | 3.0.0 | 4.0.0 |
| `highway-adr` | 5.0.0 | 5.0.1 |
| `codify-record.md` | 2.0.0 | 3.0.0 |
| `codify-tasks.md` | 1.0.0 | 2.0.0 |

`highway-codify` is MAJOR because the same selection now produces a different suggestion list and proposal. `codify-record.md` is MAJOR because sections are removed and a record in the old shape no longer matches. `codify-tasks.md` is MAJOR because line tags change from components to the executor and proposal tasks. `highway-adr` is PATCH because codify already writes the title as the action, so coverage gives the same result.

No complexity exception is required.

### Post-design re-check

PASS. The record keeps its `architecture` frontmatter as the trace to the accepted architecture. Coverage moves to the title, which codify already uses as the action, so no existing coverage result changes. The checks write nothing and only correct the provider, method, library, module, or pattern. The file list keeps one file per checkbox, standards matched by file pattern, test tasks only when required, and the readme last.

## Project Structure

### Documentation (this feature)

```text
specs/203-codify-proposal-tasks/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── suggest-list.md
│   ├── align-checks.md
│   ├── proposal.md
│   └── file-list.md
├── checklists/
│   └── requirements.md
└── tasks.md
```

### Source Code (repository root)

```text
.highway/skills/highway-codify/SKILL.md
.highway/skills/highway-adr/SKILL.md
.highway/library/templates/output/codify-record.md
.highway/library/templates/output/codify-tasks.md
.highway/tools/tests/highway-codify.test.sh
.highway/tools/tests/codify-proposal-tasks.test.sh
```

**Structure Decision**: `highway-codify` owns the suggestion list, the checks, the proposal, and the file list. `highway-adr` changes one coverage sentence. Organization standards stay unchanged. Generated catalogs and adapters are regenerated, not edited.

## Complexity Tracking

> No constitution violation requires a justification table.
