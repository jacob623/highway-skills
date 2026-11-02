# Implementation Plan: Codify Closing Guide

**Branch**: `206-codify-closing-guide` | **Date**: 2026-11-02 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/206-codify-closing-guide/spec.md`

## Summary

The README codify writes is headed `## Setup Instructions` and `## User Guide`. When every task is done, codify closes with the person's completion message, adding "The automation was not run." after the knowledge-base paragraph, the automation folder as the files path, and its README as the instructions path. A stopped run keeps the current stopped-task close.

`/highway-codify catalog`, or a request to show the code catalog, is handled before an implementation is chosen. It lists the five most recently accepted automations, newest first, with each one's implementation and task progress, says how many more exist, and asks which to discuss. It writes nothing. The automations catalog `code/code.md` is now in acceptance order so the last rows are the most recent.

## Technical Context

**Language/Version**: Markdown skill and template sources, Bash 3.2.57-compatible repository tests

**Primary Dependencies**: `.highway/skills/highway-codify/SKILL.md`, `.highway/library/templates/output/codify-record.md`, `.highway/library/templates/output/codify-catalog.md`. `.highway/tools/generate-agent-adapters.sh`, `.highway/tools/generate-catalog.sh`, `.highway/tools/generate-library-catalog.sh`, `.highway/tools/validate-library.sh`, and `.highway/tools/validate-skill.sh`

**Storage**: `code/code.md` and `code/[ID]/README.md`, unchanged in location. Existing catalogs and READMEs are not rewritten

**Testing**: New `.highway/tools/tests/codify-closing-guide.test.sh`, observed failing before the skill edits. Two existing assertions on the old headings in `highway-codify.test.sh` and two version pins in `codify-platform-catalog.test.sh` are replaced, with reasons in [research.md](research.md) R7. Then `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skills

**Performance Goals**: No runtime latency target

**Constraints**: The completion message is the person's text with one added sentence. Each `###` section stays at or under 400 words (P7.5), and the skill keeps 12 or fewer MUST-level rules (P7.4). Bash 3.2.57 only. No new runtime dependency. No shipped path may reference `.specify/` or `specs/`

**Scale/Scope**: One skill, two output templates, one new test, two amended tests

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Process gates, from `.specify/memory/constitution.md`:

- Packaging Gate: PASS. Only the shipped skill and templates change, and none gains a `.specify/` or `specs/` reference. D1.1, D1.2, and D6.2 hold.
- Toolchain Gate: PASS. The new test uses `grep` only. D2.1 through D2.4 stay satisfied.
- Generator Gate: N/A. No `generate-*.sh` script changes.
- Correspondence Gate: PASS. D4.5 through D4.7 require regenerating the skill catalog, the library catalog, and the adapters.
- Validation Gate: PASS with recorded replacements. `'## Implement'` and `'## Use'` in `highway-codify.test.sh` become `'## Setup Instructions'` and `'## User Guide'`. The codify and codify-record version pins in `codify-platform-catalog.test.sh` move to the new versions. D3.5 holds because each replacement keeps the same strength and its reason is in R7.
- D3.1 requires a passing suite before the first edit, and D3.2 after the last edit. D3.3 is met by the new test. D3.6 requires the new test to be observed failing before the skill edits.
- D8.1: `codify-record.md` and `codify-catalog.md` are cited by `highway-codify`. `highway-codify` is re-validated. `highway-adr` and `highway-assessment` read `code/code.md` without depending on row order, so they are unaffected.

Skill content gates, from `.highway/governance/constitution.md`:

- PASS pending `validate-skill.sh` on `highway-codify` and `validate-library.sh` on both templates. The catalog view and the completion message are procedure text, not new MUST-level rules.

Version bumps:

| Source | From | To |
|---|---|---|
| `highway-codify` | 5.0.0 | 6.0.0 |
| `codify-record.md` | 4.0.0 | 5.0.0 |
| `codify-catalog.md` | 1.0.0 | 2.0.0 |

All three are MAJOR. The same accepted automation now gets different README headings, a different close, and a different catalog row order.

No complexity exception is required.

### Post-design re-check

PASS. The decisions in [research.md](research.md) keep the stopped-task close, keep the person's text with the one agreed sentence, keep the catalog view read-only, and leave existing catalogs in place.

## Project Structure

### Documentation (this feature)

```text
specs/206-codify-closing-guide/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── readme-headings.md
│   ├── completion-close.md
│   └── catalog-view.md
├── checklists/
│   └── requirements.md
└── tasks.md
```

### Source Code (repository root)

```text
.highway/skills/highway-codify/SKILL.md
.highway/library/templates/output/codify-record.md
.highway/library/templates/output/codify-catalog.md
.highway/tools/tests/codify-closing-guide.test.sh
.highway/tools/tests/highway-codify.test.sh
.highway/tools/tests/codify-platform-catalog.test.sh
```

**Structure Decision**: `highway-codify` owns the README, the close, the catalog view, and `code/code.md`, so every change stays in that skill and its two templates. Generated catalogs and adapters are regenerated, not edited.

## Complexity Tracking

> No constitution violation requires a justification table.
