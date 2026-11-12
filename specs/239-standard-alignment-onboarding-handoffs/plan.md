# Implementation Plan: Standard Alignment Onboarding Handoffs

**Branch**: `feature/std-alignment-phase10` | **Date**: 2026-11-11 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/239-standard-alignment-onboarding-handoffs/spec.md`

## Summary

Phase 10 makes highway-onboarding hand each provider to the three owning skills. Each record template
then has one reader, so it moves into that owner's `assets/` and `.highway/library/` empties.

- highway-adr, highway-architecture, and highway-implementation each gain an `onboarding` entry step.
  The step writes the record as accepted without a question and returns the id to highway-onboarding.
  The architecture and implementation steps ask the owner's own title question only in the cases
  FR-021 names (R1, R2).
- highway-onboarding's `orchestrate` loses the ADR rules, the id derivation, the architecture and
  implementation rules, and the template citations. It hands off ADR → RA → RI and retries a failed
  handoff once (R3).
- highway-architecture's `name` step also sets the ADR catalog Architecture ID, which closes the gap
  for every caller (R4).
- The implementation `onboarding` step returns to highway-onboarding, never to a step another visit
  holds, so the execution chain resumes in the right place (R5).
- The three templates move with `mv`. `hw_template` points at the owners, `HW_LIBRARY` and
  `HW_OUTPUT_TEMPLATES` go, path-map loses its library arm, and the manifest loses the three rows
  (R6–R8).
- The tests that assert moved rules repoint to the owners. A new `onboarding-handoffs.test.sh` covers the
  handoff contract, and `record-templates.test.sh` covers all 14 templates (R9). Two harness scenarios
  gain expectations and one scenario is added (R10).

## Technical Context

**Language/Version**: Bash 3.2.57 with the Declared Toolchain; TypeScript on Node 24 for the harness.

**Primary Dependencies**: none new.

**Storage**: files in the repository.

**Testing**:

- `tests/run-all.sh`: 84 tests now, 85 after the change (`onboarding-handoffs.test.sh` added);
- the harness TypeScript tests (81, unchanged in number);
- `framework/validate-skill.sh --no-cache` over every skill and fixture, for the D3.4 comparison;
- harness scenarios checked statically (`harness-scenarios.test.sh`, `harness-fixtures.test.sh`); a live
  run needs a token and is not part of this change.

**Target Platform**: macOS (BSD utilities) and Linux (GNU coreutils).

**Project Type**: authoring framework, skill sources, test suite, and harness in one repository.

**Performance Goals**: none; no check changes cost.

**Constraints**:

- each template moves byte-identical, checked with `cmp` before the move;
- every behavior today's onboarding text defines stays the same for the person (FR-009), except the ADR
  catalog Architecture ID, which is now set;
- nothing is committed; `rollout-plan.md` stays gitignored and excluded; moves use `mv`.

**Scale/Scope**:

- 4 skills changed (MINOR each), 3 templates moved;
- `paths.sh`, `rule-checks.sh`, `validation-cache.sh`, `harness/bin/path-map.sh`, the distribution
  manifest;
- about 12 tests changed, 1 added; 2 orphan fixtures removed;
- 3 harness scenarios (2 changed, 1 added), `harness/test/select.test.ts`, `harness/README.md`;
- `README.md`, `framework/README.md`, `framework/authoring-standard.md`, `standard-alignment.md`.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Development constitution 3.3.0.

**Process gates**

| Gate | Trigger | Verdict |
| --- | --- | --- |
| Packaging | True: shipped skills, their assets, and `.highway/library/` change | D1.1 PASS: the moved templates and skill text name no `.specify/` or `specs/`. D1.2 PASS: `hw_template` resolves under `skills/` in the verification tree. D1.6 PASS: the manifest stays the one declaration. D6.2 PASS: no new link |
| Toolchain | True: `framework/lib/`, `tests/`, and `harness/bin/` change | D2.1–D2.4 PASS: no new utility. D2.5 PASS: every template path comes from `hw_template`; no script joins a folder to a template name |
| Generator | False: no `generate-*.sh` changes | Not triggered. Regeneration still runs for the changed skills (D4.7) |
| Correspondence | True: 4 skills change and 3 gain assets | D4.5 PASS: each keeps its catalog entry, copies, and manifest rows, and its new asset gets a row. D4.6 PASS. D4.7 PASS: regeneration leaves no diff |
| Validation | True: `rule-checks.sh` P9.1 and the validation cache change | D3.4 PASS by design: verdicts are recorded before and after. The P9.1 branch for `.highway/library/templates/output/` goes. Its only users are two orphan fixtures, which are removed; no other verdict changes. D3.5 PASS: every moved assertion is kept against the owner that now holds the rule |

Also evaluated:

- D3.1: the suite runs before the first edit (`/tmp/hw-baseline-239.log`), and the harness tests after it.
- D3.3 PASS: tests change.
- D3.6: the new handoff checks, the ADR catalog Architecture ID check, and the P9.1 change are each
  observed failing on a seeded case before they count.
- D3.8: `onboarding-handoffs.test.sh` is a static document contract; the executed-behavior evidence is the
  harness scenarios, which need a live run.
- D6.1: every live document naming a moved path or the old onboarding behavior changes.

**Skill content gates**

The Skill Content Gate triggers: 4 skills change. Verdicts are against the Highway Skills Constitution
10.3.0:

- P2.6 PASS: each skill names only its own `assets/`; skills name each other by skill name, not folder.
- P7.7 PASS: each change is MINOR; the skills' invocations and outputs for the person stay the same.
- P8.7 PASS: assets are named in inline code, not linked.
- P9.1 PASS: highway-adr, highway-architecture, and highway-implementation cite an `assets/` file that
  exists. highway-onboarding's Outputs name only `library/coding-standards/codify-platforms.md`, a seeded
  file, because the records are written by their owners.
- P9.5 PASS: no Example section changes.

No amendment to either constitution: neither names these templates' location or onboarding's write path
(FR-018). No FAIL. Re-checked after design: unchanged.

## Project Structure

### Documentation (this feature)

```text
specs/239-standard-alignment-onboarding-handoffs/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── onboarding-entry-steps.md
│   └── adr-catalog-architecture-id.md
├── checklists/requirements.md
└── tasks.md
```

### Source Code (repository root)

```text
skills/highway-adr/assets/adr-record.md                       # moved
skills/highway-architecture/assets/architecture-record.md     # moved
skills/highway-implementation/assets/implementation-record.md # moved
skills/highway-adr/SKILL.md             # onboarding step; Discovery ID exemption; assets path; MINOR
skills/highway-architecture/SKILL.md    # onboarding step; name sets catalog id; assets path; MINOR
skills/highway-implementation/SKILL.md  # onboarding step; assets path; MINOR
skills/highway-onboarding/SKILL.md      # hands off; record rules removed; MINOR
framework/
├── lib/paths.sh                       # 3 hw_template arms; HW_LIBRARY, HW_OUTPUT_TEMPLATES removed
├── lib/rule-checks.sh                 # P9.1 library branch removed
├── lib/validation-cache.sh            # HW_LIBRARY dropped from the environment key
├── .distribution-manifest             # .highway/library rows removed
├── .adapter-manifest                  # regenerated
├── README.md, authoring-standard.md
harness/
├── bin/path-map.sh                    # library arm removed
├── scenarios/highway-onboarding/onboarding-smoke.scenario       # through + record expects
├── scenarios/highway-architecture/chain-architecture.scenario   # catalog id expect
├── scenarios/highway-implementation/implementation-onboards-platform.scenario  # new
├── test/select.test.ts
└── README.md
tests/
├── onboarding-handoffs.test.sh        # new
├── record-templates.test.sh           # 14 templates; library absent
└── <repointed tests>
removed: .highway/library/ (3 templates and the folders), tests/fixtures/output-template/
.highway/catalog/index.json            # regenerated
```

**Structure Decision**: Each owner keeps one entry step for onboarding, which reuses its own `identifier`,
`write`, and catalog rules instead of restating them. Onboarding keeps the conversation and the review
edits, so the person sees the same flow.

## Complexity Tracking

None.
