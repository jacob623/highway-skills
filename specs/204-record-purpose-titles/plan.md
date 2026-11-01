# Implementation Plan: Record Purpose Titles

**Branch**: `204-record-purpose-titles` | **Date**: 2026-11-01 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/204-record-purpose-titles/spec.md`

## Summary

`highway-architecture` titles an architecture with the decision's purpose, and `highway-implementation` titles an implementation with the decision's product. Both split the decision title "Adopt [product] for [purpose]" at the first " for " after a leading "Adopt", compared without regard to case. Each capitalizes its first letter and keeps every other word as written. Both proposals gain a **Title:** line so the person accepts the title the lists will show.

An architecture title never names a product. A supplied one that does is left out, using the architecture's existing product rule. When the purpose would be empty, the person is asked for one. When the decision title has no " for ", the decision's Selected Option names the product if that name appears in the title. Otherwise the remaining title is used.

An implementation that shares its product title with an implementation of a different architecture becomes "[product] for [purpose]". When that is also taken, the existing title step runs. The same title under the same architecture still reuses that record. An architecture whose purpose title already belongs to an architecture with a different decision goes to the existing title step instead of reusing that record. Onboarding inherits both rules because it already follows these skills for identifiers. Existing records are not converted.

## Technical Context

**Language/Version**: Markdown skill and template sources, Bash 3.2.57-compatible repository tests

**Primary Dependencies**: `.highway/skills/highway-architecture/SKILL.md`, `.highway/skills/highway-implementation/SKILL.md`, `.highway/library/templates/output/architecture-record.md`, `.highway/library/templates/output/implementation-record.md`. `.highway/tools/generate-agent-adapters.sh`, `.highway/tools/generate-catalog.sh`, `.highway/tools/generate-library-catalog.sh`, `.highway/tools/validate-library.sh`, and `.highway/tools/validate-skill.sh`

**Storage**: Existing repository files only. Record headings and the catalog title cells receive the new titles. Ids continue to be derived from titles

**Testing**: New `.highway/tools/tests/record-purpose-titles.test.sh` for the strings this feature adds, observed failing before the skill edits. No existing assertion asserts the copied-title rule, so none is removed. Then `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skills

**Performance Goals**: No runtime latency target

**Constraints**: The decision title and record are never changed. The architecture stays conceptual. Each `###` section stays at or under 400 words (P7.5), and each skill keeps 12 or fewer MUST-level rules (P7.4). The onboarding text does not change. Bash 3.2.57 only. No new runtime dependency. No shipped path may reference `.specify/` or `specs/`

**Scale/Scope**: Two skills, two output templates, one new test

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Process gates, from `.specify/memory/constitution.md`:

- Packaging Gate: PASS. Only shipped skills and templates change, and none gains a `.specify/` or `specs/` reference. D1.1, D1.2, and D6.2 hold.
- Toolchain Gate: PASS. The new test uses `grep` only. D2.1 through D2.4 stay satisfied.
- Generator Gate: N/A. No `generate-*.sh` script changes.
- Correspondence Gate: PASS. D4.5 through D4.7 require regenerating the skill catalog, the library catalog, and the adapters.
- Validation Gate: N/A. No validation check is added or changed. D3.5 holds because no assertion is removed or loosened.
- D3.1 requires a passing suite before the first edit, and D3.2 after the last edit. D3.3 is met by the new test. D3.6 requires the new test to be observed failing before the skill edits.
- D8.1: `architecture-record.md` is cited by `highway-architecture`, `highway-adr`, and `highway-onboarding`. `implementation-record.md` is cited by `highway-implementation` and `highway-onboarding`. All four skills are re-validated. `highway-adr` and `highway-onboarding` need no text change.

Skill content gates, from `.highway/governance/constitution.md`:

- PASS pending `validate-skill.sh` on the four skills and `validate-library.sh` on both templates. The title rules are procedure text in each `identifier` section, not new MUST-level rules.

Version bumps:

| Source | From | To |
|---|---|---|
| `highway-architecture` | 4.0.0 | 5.0.0 |
| `highway-implementation` | 4.0.0 | 5.0.0 |
| `architecture-record.md` | 2.0.0 | 2.1.0 |
| `implementation-record.md` | 2.0.0 | 2.1.0 |

Both skills are MAJOR because the same decision now produces a different title and id. Both templates are MINOR because only the heading placeholder is renamed and every section stays.

No complexity exception is required.

### Post-design re-check

PASS. Discovery and ADR still match an architecture by exact title, and a purpose title is easier to match than a decision sentence. Coverage of a span still reads automation titles. The ADR exact-title rule compares option titles, not architecture titles, so it is unaffected. The request close and codify can now match a short implementation title such as "Notion" inside a request's text. That is recorded in [research.md](research.md) R7 and left unchanged.

## Project Structure

### Documentation (this feature)

```text
specs/204-record-purpose-titles/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── record-titles.md
├── checklists/
│   └── requirements.md
└── tasks.md
```

### Source Code (repository root)

```text
.highway/skills/highway-architecture/SKILL.md
.highway/skills/highway-implementation/SKILL.md
.highway/library/templates/output/architecture-record.md
.highway/library/templates/output/implementation-record.md
.highway/tools/tests/record-purpose-titles.test.sh
```

**Structure Decision**: Each skill owns its own title. Onboarding, ADR, discovery, request, and codify read the titles and are unchanged. Generated catalogs and adapters are regenerated, not edited.

## Complexity Tracking

> No constitution violation requires a justification table.
