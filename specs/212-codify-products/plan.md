# Implementation Plan: Codify Products

**Branch**: `212-codify-products` | **Date**: 2026-11-04 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/212-codify-products/spec.md`

## Summary

A CDY becomes a product folder named from its title. Feature records live at `.highway/features/001-<action>/`. The product catalog and a new integrations catalog decide join or start. `highway-codify` gains `project` for that decision and `revise` for the response. `propose` keeps every diagram rule and shows **Proposed project:** and **Rationale:**. Accepting a proposal writes any new integration it includes. A matching coding standard, read before the proposal, can replace the decision. The person can change the proposal.

## Technical Context

**Language/Version**: Markdown skill sources, Bash 3.2.57-compatible repository tests

**Primary Dependencies**: `.highway/skills/highway-codify/SKILL.md`, `.highway/skills/highway-adr/SKILL.md`, and the output templates `codify-catalog.md`, `codify-record.md`, and `codify-tasks.md`. New templates `codify-metadata.md` and `codify-integrations.md`. Generators `generate-library-catalog.sh`, `generate-catalog.sh`, and `generate-agent-adapters.sh`. Validators `validate-skill.sh` and `validate-library.sh`

**Storage**: `code/code.md` for products, `code/integrations.md` for accepted pairs, and one product folder `code/<folder>/` containing `.highway/metadata.md`, `.highway/features/<number>-<action>/`, the README, and the product files

**Testing**: New `.highway/tools/tests/codify-products.test.sh`, observed failing first. Version pins move as recorded in [research.md](research.md) R8. Then `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skills

**Performance Goals**: A proposal reads the two catalogs and the matching coding standard. It does not open product folders to decide

**Constraints**: Each `###` step stays at or under 400 words. New text is numbered conditions, not an explanation of products. The skill body does not gain the keywords MUST or SHOULD. No shipped path references `.specify/` or `specs/`. Existing `code/CDY…/` folders are not migrated

**Scale/Scope**: Two skills, three changed templates, two new templates, one new test, the version pins in R8

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Process gates, from `.specify/memory/constitution.md`:

- **Packaging Gate**: PASS. No manifest change. No shipped file gains a `.specify/` or `specs/` reference (D1.1).
- **Toolchain Gate**: PASS. The new test uses `awk` and `grep` only (D2.1 through D2.4).
- **Generator Gate**: N/A. No `generate-*.sh` script changes.
- **Correspondence Gate**: PASS. The library catalog, the skill catalog, and the adapters are regenerated (D4.5 through D4.7).
- **Validation Gate**: PASS with recorded replacements. Pins and the `Automation Path` assertion move for the reasons in R8 (D3.5).
- **Verification**: D3.1 needs a passing suite before the first edit, and D3.2 after the last. D3.3 is met by the new test. D3.6 needs the new test observed failing first.
- **Shared library review (D8.1)**: PASS pending `validate-skill.sh` on `highway-codify` and `highway-adr`, and `validate-library.sh` on the five templates. Those two skills are the ones that cite the changed record path.

Skill content gates, from `.highway/governance/constitution.md`:

- PASS pending `validate-skill.sh`. New instructions stay imperative and do not add MUST or SHOULD. `project` is its own step. `propose` stays at or under 400 words.

Version bumps:

| Source | From | To |
|---|---|---|
| `highway-codify` | 9.0.1 | 10.0.0 |
| `highway-adr` | 5.0.1 | 6.0.0 |
| `codify-catalog.md` | 2.0.0 | 3.0.0 |
| `codify-record.md` | 7.0.0 | 8.0.0 |
| `codify-tasks.md` | 4.0.0 | 5.0.0 |
| `codify-metadata.md` | none | 1.0.0 |
| `codify-integrations.md` | none | 1.0.0 |

MAJOR. The same action can join an existing folder, the catalog columns change, and the record path changes. `highway-adr` moves because the record it reads moves.

No complexity exception is required.

### Post-design re-check

PASS. Measured after implementation: `project` 395 words, `propose` 175 with `No arrow leaves a target.` kept, `revise` 250, `write` 186 (cap 250), and `index` 231. `codified` stops opening a product file. An existing From, To, and Kind is not written twice.

## Project Structure

### Documentation (this feature)

```text
specs/212-codify-products/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── product-steps.md
├── checklists/
│   └── requirements.md
└── tasks.md
```

### Source Code (repository root)

```text
.highway/skills/highway-codify/SKILL.md
.highway/skills/highway-adr/SKILL.md
.highway/library/templates/output/codify-catalog.md
.highway/library/templates/output/codify-record.md
.highway/library/templates/output/codify-tasks.md
.highway/library/templates/output/codify-metadata.md          (new)
.highway/library/templates/output/codify-integrations.md     (new)
.highway/tools/tests/codify-products.test.sh                 (new)
```

**Structure Decision**: Join or start is the `project` step, after `align` and before `layout`. `propose` shows the block. `revise` handles the response. Dedup stays in `codified` and reads catalog cells.

## Complexity Tracking

> No constitution violation requires a justification table.
