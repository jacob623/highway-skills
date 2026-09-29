# Implementation Plan: Revise the Runtime Experience Standard

**Branch**: `101-advisory-experience-standard` | **Date**: 2026-09-29 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/101-advisory-experience-standard/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Amend `.highway/governance/experience-standard.md` from 2.0.0 to 3.0.0 so user-visible interaction is evidence-first: understand, reuse, recommend, select, capture, and continue. Replace the long Interactive Workflow UX Contract with one short interaction model and normative rules. Remove development review vocabulary from the current sections.

Move seven skill-file and retained-artifact obligations into `.highway/governance/constitution.md` as P9.2 through P9.8. That constitution goes from 4.0.0 to 4.1.0. Principle precedence does not change. Tests and live citations of the removed contract or retired identifiers are updated in the same change. The specimen check reports under P9.5. Skill domain workflows, shared templates, and the development constitution stay unchanged.

The identifier maps are in [contracts/experience-standard-amendment.md](./contracts/experience-standard-amendment.md) and [contracts/constitution-output-relocation.md](./contracts/constitution-output-relocation.md).

## Technical Context

**Language/Version**: Markdown governance documents. No script changes.

**Primary Dependencies**: Each document's own versioning policy, the Skills Constitution clarity rules for the new constitution rows, and the existing rule parser. No new dependency.

**Storage**: Two shipped files. Existing sync-impact history stays in each file. Each new report is prepended.

**Testing**: `.highway/tools/tests/run-all.sh` exits 0 before the governance edits and after the final edit. Tests that name the removed contract, the 4.0.0 footer, or a retired X identifier as a current row are updated first, with a comment naming the superseded behavior. The specimen check in `.highway/tools/lib/rule-checks.sh` reports under P9.5.

**Target Platform**: The shipped Highway tree. Both documents already ship under `.highway/governance`.

**Project Type**: Runtime governance amendment for a repository-distributed skill suite

**Performance Goals**: None. This is a document change.

**Constraints**: Retired identifiers are not reused. Each new constitution rule has one keyword, one obligation, and no more than 25 words. P9.5 is `[auto]`. The other new constitution rules are `[agent-checkable]`. Experience Standard rows keep a tier column because the shipped parser rejects a row without one. Neither shipped governance file contains `.specify/` or `specs/`. Skill edits are citation updates only. Shared templates and the development constitution stay unchanged. No rule is added only to keep a historical test green.

**Scale/Scope**: One major Experience Standard amendment and one minor Skills Constitution amendment. The two contracts are the full identifier maps.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

This feature edits the two governance documents, the tests and check that read them, and skill citations that name the removed contract or a retired identifier. It runs the existing adapter generator after those citation edits. It does not edit a generator script, a shared template, or the development constitution.

### Process gates

| Gate | Verdict | Evidence / scope |
|---|---|---|
| Packaging Gate (D1.1, D1.2, D6.2) | PASS | Both governance documents already ship. The amendments must not introduce `.specify/` or `specs/`. Citation edits point at shipped documents and at P9.2 through P9.8. |
| Toolchain Gate (D2.1–D2.4) | PASS | The specimen-check edit stays in the existing shell toolchain. No new dependency or non-portable construct is added. |
| Generator Gate (D4.1–D4.4) | N/A | No `generate-*.sh` script is edited. Generated copies are regenerated, not hand-edited. |
| Correspondence Gate (D4.5–D4.7) | PASS | Skill citation edits are generator input. The declared generators are re-run so catalog, adapter, and manifest rows still match the sources. |
| Validation Gate (D3.4, D3.5) | PASS | The specimen check keeps the same verdict and changes only its reported identifier to P9.5. Existing fixtures are recorded against that identifier before the retarget is enabled. Replaced assertions name the superseded behavior. |
| D3.1 | PASS | The suite is brought to exit 0 before the governance documents are edited. That opening work updates tests still aimed at the pre-amendment contract, footer, or retired identifiers. |
| D3.2 | PASS | The suite exits 0 after the final edit. `constitution-inventory.test.sh`, `output-template.test.sh`, `highway-ux-alignment.test.sh`, `feature-092-contract.test.sh`, `frontmatter-lexicon.test.sh`, and `rule-checks.test.sh` follow the new identifiers. |
| D3.3 | PASS | Those test files are edited in this change. |
| D3.6 | PASS | Each updated test is observed failing on the old text before the governance edit that makes it pass. |
| D6.1 | PASS | Live skill text that names the Interactive Workflow UX Contract, or that cites X1.1, X1.2, X1.3, X1.4, X1.5, X4.1, or X6.1 as a current Experience Standard rule, is updated in this change. Historical sync reports stay. |

Process result: PASS. No gate is left as an exception.

### Skill content gates

The Skill Content Gate triggers because skill files are edited. The edits replace a citation. They do not add domain rules.

| Rule | Verdict | Evidence |
|---|---|---|
| P7.3 | PASS | A skill points at the Experience Standard or at P9.2 through P9.8. It does not copy the new rule sentences. |
| P10.1 | PASS | The citation names the Experience Standard for generic interaction behavior. |
| P9.5 | PASS | Skills are not asked to restate the specimen rule. The check reports it. |

Other Skills Constitution rules are unchanged by a citation edit. The amended constitution still records its own self-application review against P1.1 through P1.4, P6.4, P6.6, and P7.3.

**Post-design re-check**: PASS. The identifier maps, the P9.5 tier, the test list, and the citation boundary are fixed in the contracts and in [research.md](./research.md).

## Project Structure

### Documentation (this feature)

```text
specs/101-advisory-experience-standard/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── experience-standard-amendment.md
│   └── constitution-output-relocation.md
├── checklists/requirements.md
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)

```text
.highway/governance/experience-standard.md
.highway/governance/constitution.md
.highway/tools/lib/rule-checks.sh
.highway/tools/tests/constitution-inventory.test.sh
.highway/tools/tests/output-template.test.sh
.highway/tools/tests/highway-ux-alignment.test.sh
.highway/tools/tests/feature-092-contract.test.sh
.highway/tools/tests/frontmatter-lexicon.test.sh
.highway/tools/tests/rule-checks.test.sh
.highway/skills/highway-adr/SKILL.md
.highway/skills/highway-clarify/SKILL.md
.highway/skills/highway-controls/SKILL.md
.highway/skills/highway-discovery/SKILL.md
.highway/skills/highway-help/SKILL.md
.highway/skills/highway-inquiry/SKILL.md
.highway/skills/highway-new/SKILL.md
.highway/skills/highway-nfrs/SKILL.md
.highway/skills/highway-objectives/SKILL.md
.highway/skills/highway-profile/SKILL.md
.highway/skills/highway-setup/SKILL.md
```

Generated adapter copies of those skills are regenerated. They are not hand-edited.

**Structure Decision**: The Experience Standard and the Skills Constitution remain the governance sources. Tests and the specimen check follow the new identifiers. Skill files change only where they name the removed contract or a retired identifier. Shared templates and the development constitution stay untouched.

## Complexity Tracking

No constitution gate is violated. The earlier exceptions for D3.1, D3.2, D3.3, and D6.1 are cleared by including the tests, the specimen-check retarget, and the citation updates in this change.
