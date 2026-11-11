# Implementation Plan: Standard Alignment Catalog Seeding

**Branch**: `237-standard-alignment-catalog-seeding` | **Date**: 2026-11-11 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/237-standard-alignment-catalog-seeding/spec.md`

## Summary

Phase 8 makes highway-setup write every catalog a project needs, and moves each catalog's rules into
the skills that write it.

- highway-setup's `assets/` holds 12 skeletons: the 11 seeded catalogs and the storage record. A new
  first step writes each absent one, silently, before the welcome (R1, R3).
- Nine writing skills check at entry that the seeded files they edit exist, and stop with the fixed
  setup-needed message when one is missing (R4).
- Each writing skill states its catalog's rules, moved verbatim from the retired template (R5). The
  capability title rule and the ADR ID cell format each have one source under `framework/shared-rules/`,
  and a bash test fails when a skill's copy differs (R6).
- The Phase 1 ownership changes for codify platforms, capabilities, ADRs, and architectures take effect.
- The governance catalog templates move to their skills' `assets/`. The findings file moves to the
  project and is seeded (R11, R13).
- The paths helper, the template check, P9.1's checker, the fixtures, and the harness follow (R2, R7,
  R8, R10). The harness gains a `shows:` assertion and a scenario for the stop (R9).

## Technical Context

**Language/Version**: Bash 3.2.57 with the Declared Toolchain; TypeScript on Node 24 for the harness.

**Primary Dependencies**: none new.

**Storage**: files in the repository.

**Testing**:

- `tests/run-all.sh`: 81 tests now, 83 after the change (`catalog-seeding.test.sh` and
  `shared-rules.test.sh` added);
- the harness TypeScript tests;
- `framework/validate-skill.sh --no-cache` over every skill and fixture, for the D3.4 comparison.

**Target Platform**: macOS (BSD utilities) and Linux (GNU coreutils).

**Project Type**: authoring framework, skill sources, and test suite in one repository.

**Performance Goals**: the suite's run time does not grow noticeably; two small static tests are added.

**Constraints**:

- skill edits are limited to seeding, the entry check, catalog rules, the ownership changes, the moved
  templates, and the version (FR-016);
- the setup-needed message is the maintainer's wording, byte for byte;
- nothing is committed;
- `rollout-plan.md` stays gitignored and excluded;
- moves use `mv`.

**Scale/Scope**:

- 13 skills changed;
- 12 skeletons added, 14 templates removed or moved, 1 knowledge file removed;
- 2 shared-rule sources;
- `paths.sh`, `rule-checks.sh`, `template-check.sh`, the distribution manifest;
- about 20 tests repointed, 2 added;
- 3 harness source files, 5 stage fixtures, 4 scenarios changed, 1 added;
- the Highway Skills Constitution and 5 live documents.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Development constitution 3.3.0.

**Process gates**

| Gate | Trigger | Verdict |
| --- | --- | --- |
| Packaging | True: shipped skills, assets, and `.highway/library/` change | D1.1 PASS: skeletons and skill text name no `.specify/` or `specs/`; shipped-tree-independence scans them. D1.2 PASS: `hw_template` resolves under `skills/` in the verification tree. D6.2 PASS: no new link |
| Toolchain | True: `framework/lib/`, `tests/`, and `harness/bin/` change | D2.1–D2.4 PASS: awk, grep, find, cp, and diff only. D2.5 PASS: `HW_SETUP`, `hw_seeded`, and the new `hw_template` arms live in the paths helper, and tests use `hw_template` instead of joining a template name to a folder |
| Generator | False: no `generate-*.sh` changes | Not triggered. Regeneration still runs for the changed skills (D4.7) |
| Correspondence | True: 13 skills change and gain assets | D4.5 PASS: each skill keeps its catalog entry, copies, and manifest rows, and assets get rows. D4.6 PASS. D4.7 PASS: regeneration leaves no diff |
| Validation | True: P9.1's checker and the template check change | D3.4 PASS by design: every skill and fixture verdict is recorded before and compared after; P9.1 only accepts more citations, and skeleton mode reads the same kinds of parts. D3.5 PASS: every template-text assertion moves to the skill or skeleton that now holds the text; placeholder-cell assertions move to the prose that states the same values (R5) |

Also evaluated:

- D3.1: the suite runs before the first edit (`/tmp/hw-baseline-237.log`).
- D3.3 PASS: tests change.
- D3.6: the two new tests, the `shows:` check, and the skeleton mode of the template check are observed
  failing on a seeded case before they count.
- D1.3, D1.4, and D5.3 are recorded in the Highway Skills Constitution's Sync Impact Report.
- D6.1: every live document naming a moved path changes.

**Skill content gates**

The Skill Content Gate triggers: 13 skills change. Verdicts are against the Highway Skills Constitution
10.2.0, as amended to 10.3.0:

- P1.3 PASS: the moved rule paragraphs carry no MUST or SHOULD, so the 25-word limit does not apply.
- P2.6 PASS: no skill names `framework/` or another skill's folder; each names only its own `assets/`.
- P7.7 PASS: each change is MINOR; nothing depends on the old arrangement.
- P8.7 PASS: assets are named in inline code, not linked.
- P9.1 PASS as amended: Outputs cite a remaining template, the skill's own `assets/`, or only seeded files.
- P9.5 PASS: no Example section changes.
- P10.1 PASS: every user-visible message, including the setup-needed message, follows the Experience
  Standard through highway-experience.

No FAIL. Re-checked after design: unchanged.

## Project Structure

### Documentation (this feature)

```text
specs/237-standard-alignment-catalog-seeding/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── seeding.md
│   ├── entry-check.md
│   ├── shared-rules.md
│   └── harness-shows.md
├── checklists/requirements.md
└── tasks.md
```

### Source Code (repository root)

```text
skills/highway-setup/
├── SKILL.md                          # Seed step, Inputs, Outputs, Verification; MINOR
└── assets/                           # new: 11 catalog skeletons and storage.md
skills/highway-objectives/assets/objective-catalog.md   # moved, byte-identical
skills/highway-controls/assets/control-catalog.md       # moved, byte-identical
skills/highway-nfrs/assets/nfr-catalog.md               # moved, byte-identical
skills/<9 writing skills>/SKILL.md    # entry check, catalog rules, ownership; MINOR
skills/<3 governance skills>/SKILL.md # assets/ paths; MINOR
framework/
├── shared-rules/capability-title.txt # new
├── shared-rules/adr-id-cell.txt      # new
├── lib/paths.sh                      # HW_SETUP, hw_seeded, hw_template arms; HW_KNOWLEDGE removed
├── lib/rule-checks.sh                # P9.1 accepts assets/ and seeded files
├── .distribution-manifest            # catalog template rows removed
├── .adapter-manifest                 # regenerated
├── constitution.md                   # 10.3.0
└── README.md, authoring-standard.md
tests/
├── catalog-seeding.test.sh           # new
├── shared-rules.test.sh              # new
└── <repointed tests>, run-all.sh
harness/
├── bin/template-check.sh             # skeleton mode
├── src/scenario.ts, runner.ts, checks.ts   # shows:
├── test/scenario.test.ts, checks.test.ts
├── fixtures/templates.map, fixtures/stages/*/   # seeded files
├── scenarios/highway-setup/*.scenario, highway-assessment/assessment-smoke.scenario
├── scenarios/highway-request/request-setup-needed.scenario   # new
└── README.md
.highway/catalog/index.json           # regenerated
removed: 14 files under .highway/library/templates/output/, .highway/library/knowledge/
```

**Structure Decision**: Skeletons live in highway-setup's `assets/`, its only reader. Shared-rule sources
live under `framework/`, which does not ship.

## Complexity Tracking

None.
