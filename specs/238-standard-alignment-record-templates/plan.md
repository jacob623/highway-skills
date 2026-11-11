# Implementation Plan: Standard Alignment Record Templates in Their Skills

**Branch**: `feautre/std-alignment-phase9` | **Date**: 2026-11-11 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/238-standard-alignment-record-templates/spec.md`

## Summary

Phase 9 moves the 11 single-reader record templates into the `assets/` of the skills that create the
records, and keeps every check that covered them.

- The templates move with `mv`, byte-identical. Eight skills name them as `assets/<file>.md` and take a
  MINOR version. highway-profile drops its two guards against `.highway/library/knowledge/profile.md`
  (R1, R2).
- `hw_template` points the 11 names at their new homes, and the tests that joined `$HW_OUTPUT_TEMPLATES`
  with a moved name use `hw_template` instead (R3).
- The skill validator checks each complete template in a skill's own `assets/`, by running the library
  validator's template checks through a new `--asset` mode. The validation cache key gains the skill's
  `assets/` files (R4, R5).
- `catalog-seeding.test.sh` compares each of highway-setup's 12 skeletons with a reference copy, so a
  dropped heading or column fails (R6).
- A new `record-templates.test.sh` checks the placement, the citations, and the validator's asset check
  (R7). The harness, the manifest, and the documents follow (R8, R9).

## Technical Context

**Language/Version**: Bash 3.2.57 with the Declared Toolchain; TypeScript on Node 24 for the harness.

**Primary Dependencies**: none new.

**Storage**: files in the repository.

**Testing**:

- `tests/run-all.sh`: 83 tests now, 84 after the change (`record-templates.test.sh` added);
- the harness TypeScript tests (81, unchanged in number);
- `framework/validate-skill.sh --no-cache` over every skill and fixture, for the D3.4 comparison.

**Target Platform**: macOS (BSD utilities) and Linux (GNU coreutils).

**Project Type**: authoring framework, skill sources, and test suite in one repository.

**Performance Goals**: validation of a skill with assets runs the template checks once per complete
template (14 in total); the suite's run time does not grow noticeably.

**Constraints**:

- skill edits are limited to the template paths, the profile guards, and the version (FR-004);
- each template moves byte-identical, checked with `cmp` before the move;
- the skill validator's verdict lines (CHECKED, FAILED, N/A, DEFERRED, UNCHECKED) stay the same for every
  passing skill, so asset findings appear only as errors;
- nothing is committed; `rollout-plan.md` stays gitignored and excluded; moves use `mv`.

**Scale/Scope**:

- 8 skills changed, 11 templates moved;
- `paths.sh`, `validate-skill.sh`, `validate-library.sh`, `validation-cache.sh`, the distribution manifest;
- about 20 tests repointed, 1 added, 12 reference skeleton copies added;
- 1 harness test file, `harness/README.md`;
- 4 live documents and `standard-alignment.md`.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Development constitution 3.3.0.

**Process gates**

| Gate | Trigger | Verdict |
| --- | --- | --- |
| Packaging | True: shipped skills, their assets, and `.highway/library/` change | D1.1 PASS: the moved templates and skill text name no `.specify/` or `specs/`. D1.2 PASS: `hw_template` resolves under `skills/` in the verification tree. D6.2 PASS: no new link |
| Toolchain | True: `framework/`, `framework/lib/`, and `tests/` change | D2.1–D2.4 PASS: find, grep, diff, cmp, sed only. D2.5 PASS: tests get every template path from `hw_template` and reference copies from `$HW_FIXTURES` |
| Generator | False: no `generate-*.sh` changes | Not triggered. Regeneration still runs for the changed skills (D4.7) |
| Correspondence | True: 8 skills change and gain assets | D4.5 PASS: each skill keeps its catalog entry, copies, and manifest rows, and its assets get rows. D4.6 PASS. D4.7 PASS: regeneration leaves no diff |
| Validation | True: `validate-skill.sh`, `validate-library.sh`, and the validation cache change | D3.4 PASS by design: every skill and fixture verdict is recorded before and compared after; asset findings add errors only, and all 14 templates pass today. D3.5 PASS: every template assertion moves with its template; the library-validator assertions on four templates become skill-validator assertions on their owners |

Also evaluated:

- D3.1: the suite runs before the first edit (`/tmp/hw-baseline-238.log`), and the harness tests after it.
- D3.3 PASS: tests change.
- D3.6: the validator's asset check, the cache key change, and the skeleton comparison are each observed
  failing on a seeded case before they count.
- D6.1: every live document naming a moved path changes.

**Skill content gates**

The Skill Content Gate triggers: 8 skills change. Verdicts are against the Highway Skills Constitution
10.3.0:

- P2.6 PASS: no skill names `framework/` or another skill's folder; each names only its own `assets/`.
- P7.7 PASS: each change is MINOR; nothing depends on the old arrangement.
- P8.7 PASS: assets are named in inline code, not linked.
- P9.1 PASS: each Outputs section cites an `assets/` file that exists in the skill.
- P9.5 PASS: no Example section changes.

No amendment to either constitution: neither names these templates' location (FR-012). No FAIL.
Re-checked after design: unchanged.

## Project Structure

### Documentation (this feature)

```text
specs/238-standard-alignment-record-templates/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── asset-template-check.md
│   └── skeleton-reference.md
├── checklists/requirements.md
└── tasks.md
```

### Source Code (repository root)

```text
skills/highway-codify/assets/          # codify-metadata, codify-plan, codify-record, codify-tasks (moved)
skills/highway-codify-config/assets/   # coding-standard.md (moved)
skills/highway-controls/assets/        # + control-record.md (moved)
skills/highway-nfrs/assets/            # + nfr-record.md (moved)
skills/highway-objectives/assets/      # + objective-record.md (moved)
skills/highway-discovery/assets/       # discovery-record.md (moved)
skills/highway-request/assets/         # request-record.md (moved)
skills/highway-profile/assets/         # profile-record.md (moved)
skills/<those 8>/SKILL.md              # assets/ paths; profile guards removed; MINOR
framework/
├── lib/paths.sh                       # 11 hw_template arms
├── lib/validation-cache.sh            # key includes the skill's assets/ and validate-library.sh
├── validate-skill.sh                  # checks complete templates in assets/
├── validate-library.sh                # --asset mode
├── .distribution-manifest             # 3 record rows removed
├── .adapter-manifest                  # regenerated
├── README.md, authoring-standard.md
tests/
├── record-templates.test.sh           # new
├── catalog-seeding.test.sh            # skeleton reference comparison
├── fixtures/catalog-seeding/skeletons/   # new: 12 reference copies
└── <repointed tests>
harness/
├── test/select.test.ts                # asset path
└── README.md
.highway/catalog/index.json            # regenerated
removed: 11 files from .highway/library/templates/output/
```

**Structure Decision**: Each template lives in its only reader's `assets/`. The asset check reuses the
library validator's template checks rather than copying them, so Phase 11 merges one implementation.

## Complexity Tracking

None.
