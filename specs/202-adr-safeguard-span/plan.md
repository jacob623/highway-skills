# Implementation Plan: ADR Safeguard Span

**Branch**: `202-adr-safeguard-span` | **Date**: 2026-10-31 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/202-adr-safeguard-span/spec.md`

## Summary

When several architectures match a decision only through one shared Control or NFR, and the selected option turns that safeguard on for each, `highway-adr` shows one span proposal instead of asking which architecture to use. The person can leave architectures out. Narrowing to one returns to the existing replace-or-beside question. Acceptance writes one ADR whose catalog cell and handoff list every RA id in the set, and adds that ADR beside the current decision of each architecture in the same write. Nothing is superseded and no architecture is created. The close offers codify for one uncovered implementation at a time, and opening the recorded decision again continues there.

`highway-assessment` opens on **What would you like to review?** Gaps go to the unchanged findings list. Ready artifacts show numbered categories with lettered records, at most five per category, read from the catalogs and never written as findings. Choosing a record continues in the skill for its next stage. `highway-discovery` adds one plain-text line after the exploration question, and choosing it continues as `highway-adr` with the Discovery id and the explored option id.

Before discovery writes generated options, it checks each named product or feature against that vendor's current public documentation. A claim the vendor no longer offers is removed before the two-to-five cap and before scoring, recorded in Research Findings and the elimination log, and named with its source ahead of the option list. A check that cannot confirm or contradict leaves the option and records `inconclusive`. An option that depends on a required platform is held out of the scored options when accepted evidence does not say that platform supports it. Vendor documentation does not count as that support. Opening a written discovery does not run the check, and an option the person adds is not removed by it.

## Technical Context

**Language/Version**: Markdown skill and template sources, Bash 3.2.57-compatible repository tests

**Primary Dependencies**: `.highway/skills/highway-adr/SKILL.md`, `.highway/skills/highway-assessment/SKILL.md`, `.highway/skills/highway-discovery/SKILL.md`, and the output templates `adr-catalog.md`, `adr-record.md`, `architecture-catalog.md`, and `discovery-record.md`. `.highway/tools/generate-agent-adapters.sh`, `.highway/tools/generate-catalog.sh`, `.highway/tools/generate-library-catalog.sh`, `.highway/tools/validate-library.sh`, and `.highway/tools/validate-skill.sh`

**Storage**: Existing repository files only. `adrs/adrs.md` Architecture ID may list several RA ids. `architectures/[RA id].md` Current Decisions and `architectures/architectures.md` ADR ID cells gain the span ADR id. Assessment reads `requests/requests.md`, `discoveries/discoveries.md`, `adrs/adrs.md`, `architectures/architectures.md`, `implementations/implementations.md`, and `code/code.md`, and writes nothing for ready records

**Testing**: New `.highway/tools/tests/adr-span-progression.test.sh` for the strings this feature adds, including the product-claim check. No existing assertion is removed or loosened. Then `.highway/tools/tests/run-all.sh`

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skills

**Performance Goals**: No runtime latency target

**Constraints**: One Discovery has at most one ADR. ADR copies matches and never recomputes them. Assessment never creates the next record and never writes a ready record as a finding. The literal `/highway-codify` must not appear in assessment. The product-claim check sends only the product or feature name and the vendor name, removes an option only from the vendor's own documentation, and does not change the score of an option that remains. Existing strings asserted by `multiple-reference-implementations.test.sh`, `adr-record-completeness.test.sh`, `onboarding-assessment-guidance.test.sh`, `promotion-invariants.test.sh`, and `highway-codify.test.sh` stay. The new discovery steps stay inside P7.4 and P7.5. Bash 3.2.57 only. No new runtime dependency. No shipped path may reference `.specify/` or `specs/`

**Scale/Scope**: Three skills, four output templates, one new test

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Process gates, from `.specify/memory/constitution.md`:

- Packaging Gate: PASS. Only shipped skills and templates change, and none gains a `.specify/` or `specs/` reference, so D1.1 and D1.2 hold. D6.2 holds because every path cited already ships.
- Toolchain Gate: PASS. The new test is a shell test that uses `grep`, `sed`, and `awk` only. D2.1 through D2.4 stay satisfied.
- Generator Gate: N/A. No `generate-*.sh` script changes.
- Correspondence Gate: PASS. D4.5 through D4.7 require regenerating the skill catalog, the library catalog, and the adapters after the three skills and three templates change.
- Validation Gate: N/A. No validation check is added or changed. D3.5 still applies to the suite: no existing assertion is removed or loosened.
- D3.1 requires a passing suite before the first edit, and D3.2 after the last edit. D3.3 is met by the new test. D3.6 requires the new test to be observed failing before the skill edits make it pass.
- D8.1: `adr-catalog.md`, `adr-record.md`, and `architecture-catalog.md` are cited by `highway-adr`, `highway-architecture`, and `highway-onboarding`. All three are re-validated. `highway-architecture` and `highway-onboarding` need no text change: the architecture skill already treats a Reference Architecture field that names an RA id as recorded, and onboarding writes one id. `discovery-record.md` is cited by `highway-discovery`, which is re-validated with it.

Skill content gates, from `.highway/governance/constitution.md`:

- PASS pending `validate-skill.sh` on `highway-adr`, `highway-assessment`, and `highway-discovery`, and `validate-library.sh` on the four templates. Each skill must still satisfy P7.4 and P7.5 and the frontmatter lexicon. The new steps are procedure text, not new MUST-level rules. P8.1 holds because lettered records are bold lines, not ordered-list items.

Version bumps:

| Source | From | To |
|---|---|---|
| `highway-adr` | 4.0.0 | 5.0.0 |
| `highway-assessment` | 4.0.0 | 5.0.0 |
| `highway-discovery` | 4.0.0 | 5.0.0 |
| `adr-catalog.md` | 4.0.0 | 4.1.0 |
| `adr-record.md` | 3.0.0 | 3.1.0 |
| `architecture-catalog.md` | 3.0.0 | 3.1.0 |
| `discovery-record.md` | 1.0.0 | 1.1.0 |

`highway-adr` is MAJOR because a safeguard-only multi-match no longer asks for one architecture. `highway-assessment` is MAJOR because it opens on a menu instead of the findings list. `highway-discovery` is MAJOR because analysis no longer writes an option whose named product or feature the vendor no longer offers. The templates are MINOR because each adds a case and every existing record stays valid.

No complexity exception is required.

### Post-design re-check

PASS. The span reuses the comma-separated id list the architecture catalog already uses, so no new syntax enters the catalogs. Readiness uses each next skill's own waiting rule, so assessment never offers a record that skill would refuse. Every handoff continues in the owning skill, and the existing findings path is untouched. The product-claim check writes into the discovery record's existing findings and elimination log. A result from the check is recorded as such and is not accepted repository evidence.

## Project Structure

### Documentation (this feature)

```text
specs/202-adr-safeguard-span/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── adr-span.md
│   ├── assessment-review.md
│   ├── discovery-select.md
│   └── product-claim-check.md
├── checklists/
│   └── requirements.md
└── tasks.md
```

### Source Code (repository root)

```text
.highway/skills/highway-adr/SKILL.md
.highway/skills/highway-assessment/SKILL.md
.highway/skills/highway-discovery/SKILL.md
.highway/library/templates/output/adr-catalog.md
.highway/library/templates/output/adr-record.md
.highway/library/templates/output/architecture-catalog.md
.highway/library/templates/output/discovery-record.md
.highway/tools/tests/adr-span-progression.test.sh
```

**Structure Decision**: `highway-adr` owns the span and its close. `highway-assessment` owns the review menu and the ready view, and hands each record to the skill that owns its next stage. `highway-discovery` owns the selection line, the product-claim check, and the handoff to `highway-adr`. Generated catalogs and adapters are regenerated, not edited.

## Complexity Tracking

> No constitution violation requires a justification table.
