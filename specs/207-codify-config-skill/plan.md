# Implementation Plan: Codify Config Skill

**Branch**: `207-codify-config-skill` | **Date**: 2026-11-03 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/207-codify-config-skill/spec.md`

## Summary

A new skill, `highway-codify-config`, opens with "How would you like to configure Highway Codify?" and three options: platforms, coding standards, and conflicts. It takes over `configure` from `highway-codify`. Every platform and standard proposal shows its fields as bold labels, When to use and When not to use as ordered lists, then Consequences and Conflicts. It ends with **What would you add or correct?** and "If you'd like to cancel, just say so." The catalogs store those lists in one table cell, separated by semicolons. Proposals always present them as ordered lists.

The platform catalog moves to `library/coding-standards/codify-platforms.md` with When to use and When not to use. The coding standards catalog gains When to use, When not to use, and Inherits From. Codify picks the Provider by fit and gives each proposal task a **Standards** list the person can correct. `highway-implementation` and `highway-onboarding` include a platform with blank guidance and ask "Would you like to configure [Platform] for automation?"

## Technical Context

**Language/Version**: Markdown skill and template sources, Bash 3.2.57-compatible repository tests

**Primary Dependencies**: `.highway/skills/highway-codify/SKILL.md`, `.highway/skills/highway-implementation/SKILL.md`, `.highway/skills/highway-onboarding/SKILL.md`, the new `.highway/skills/highway-codify-config/SKILL.md`, output templates `codify-platforms.md`, `codify-record.md`, `codify-tasks.md`, and the new `coding-standards-catalog.md` and `coding-standard.md`. The seeded `library/coding-standards/coding-standards.md`. Generators `generate-library-catalog.sh`, `generate-catalog.sh`, `generate-agent-adapters.sh`. Validators `validate-skill.sh`, `validate-library.sh`. `.highway/tools/.distribution-manifest`

**Storage**: `library/coding-standards/codify-platforms.md`, `library/coding-standards/coding-standards.md`, and standard files in `library/coding-standards/`. The old `library/knowledge/codify-platforms.md` is neither read nor migrated

**Testing**: New `.highway/tools/tests/codify-config-skill.test.sh`, observed failing first. Replaced assertions in `codify-platform-catalog.test.sh`, `codify-closing-guide.test.sh`, `output-template.test.sh`, and `record-purpose-titles.test.sh`, each with a reason in [research.md](research.md) R11. Then `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skills

**Performance Goals**: No runtime latency target

**Constraints**: Each `###` section stays at or under 400 words (P7.5). Each skill keeps 12 or fewer MUST-level rules (P7.4). Frontmatter prose uses only lexicon words or skill ids. Bash 3.2.57 only. No new runtime dependency. No shipped path may reference `.specify/` or `specs/`

**Scale/Scope**: One new skill, three changed skills, two new templates, three changed templates, one seeded catalog, one manifest, one new test, four amended tests

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Process gates, from `.specify/memory/constitution.md`:

- Packaging Gate: PASS. The new skill's four adapter trees are classified in `.highway/tools/.distribution-manifest`. No shipped file gains a `.specify/` or `specs/` reference. D1.1, D1.2, D1.6, and D6.2 hold.
- Toolchain Gate: PASS. The new test uses `grep` only. D2.1 through D2.4 hold.
- Generator Gate: N/A. No `generate-*.sh` script changes.
- Correspondence Gate: PASS. D4.5 through D4.7 require regenerating the skill catalog, the library catalog, and the adapters.
- Validation Gate: PASS with recorded replacements. Each replaced assertion checks the moved or renamed contract at the same strength. Reasons are in R11 (D3.5).
- D3.1 needs a passing suite before the first edit, and D3.2 after the last edit. D3.3 is met by the new test. D3.6 needs the new test observed failing first.
- D8.1: every skill citing a changed template is re-validated: `highway-codify`, `highway-codify-config`, `highway-implementation`, and `highway-onboarding`.

Skill content gates, from `.highway/governance/constitution.md`:

- PASS pending `validate-skill.sh` on the four skills and `validate-library.sh` on the five templates. The new skill uses the eight required body sections.

Version bumps:

| Source | From | To |
|---|---|---|
| `highway-codify` | 6.0.0 | 7.0.0 |
| `highway-implementation` | 6.0.0 | 7.0.0 |
| `highway-onboarding` | 8.0.0 | 9.0.0 |
| `highway-codify-config` | none | 1.0.0 |
| `codify-platforms.md` | 1.0.0 | 2.0.0 |
| `codify-record.md` | 5.0.0 | 6.0.0 |
| `codify-tasks.md` | 2.0.1 | 3.0.0 |
| `coding-standards-catalog.md` | none | 1.0.0 |
| `coding-standard.md` | none | 1.0.0 |

`highway-onboarding` `orchestrate` and `highway-implementation` `write` were already over 400 words before this feature. The validator marks P7.5 not applicable for them, and this feature adds no new oversized section.

Every change is MAJOR: configure moves, the platform path and columns change, inclusion asks a question, proposals gain a Standards field, and task lines name several standards.

No complexity exception is required.

### Post-design re-check

PASS. Proposals show list fields as ordered lists. Storage stays one table per catalog. Codify keeps the code catalog view. Removal keeps standard files.

## Project Structure

### Documentation (this feature)

```text
specs/207-codify-config-skill/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── config-menu.md
│   ├── platform-proposal.md
│   ├── standard-proposal.md
│   ├── conflicts.md
│   ├── codify-standards-field.md
│   └── platform-inclusion.md
├── checklists/
│   └── requirements.md
└── tasks.md
```

### Source Code (repository root)

```text
.highway/skills/highway-codify-config/SKILL.md          (new)
.highway/skills/highway-codify/SKILL.md
.highway/skills/highway-implementation/SKILL.md
.highway/skills/highway-onboarding/SKILL.md
.highway/library/templates/output/codify-platforms.md
.highway/library/templates/output/coding-standards-catalog.md   (new)
.highway/library/templates/output/coding-standard.md            (new)
.highway/library/templates/output/codify-record.md
.highway/library/templates/output/codify-tasks.md
library/coding-standards/coding-standards.md
.highway/tools/.distribution-manifest
.highway/tools/tests/codify-config-skill.test.sh               (new)
.highway/tools/tests/codify-platform-catalog.test.sh
.highway/tools/tests/codify-closing-guide.test.sh
.highway/tools/tests/output-template.test.sh
.highway/tools/tests/record-purpose-titles.test.sh
```

**Structure Decision**: `highway-codify-config` owns both catalogs and the standard files. `highway-codify` reads them. `highway-implementation` and `highway-onboarding` add platform rows with blank guidance. Generated catalogs and adapters are regenerated, not edited.

## Complexity Tracking

> No constitution violation requires a justification table.
