# Implementation Plan: Standard Alignment highway-experience

**Branch**: `236-standard-alignment-experience` | **Date**: 2026-11-11 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/236-standard-alignment-experience/spec.md`

## Summary

Phase 7 adds a new skill, highway-experience, and moves into it the three files every skill used to
reach through the project or through always-on instructions:

- the Highway Identity and the Experience Standard, unchanged;
- the storage contract, which also gains the bundled-file exemption, the project mode record, and the
  stop on an unsupported mode.

Every other skill opens its Procedure with one identical activation sentence and stops naming the old
paths. Each takes a MINOR version.

The always-on instructions, their generator, and their manifest are removed, along with their outputs
and tests. The paths helper resolves the three documents to highway-experience's references, so the
validator and the tests follow.

The adapter generator copies a skill's bundled files to each agent tree. The harness records which
skills loaded before the first output and fails a run where highway-experience did not.

Both constitutions take MINOR amendments for the new locations.

## Technical Context

**Language/Version**: Bash 3.2.57 with the Declared Toolchain; TypeScript on Node 24 for the harness.

**Primary Dependencies**: none new. The harness reads `toolRequests` from the Copilot SDK's
`assistant.message` event, which it already receives.

**Storage**: files in the repository.

**Testing**:

- `tests/run-all.sh`: 82 tests now, 81 after the change;
- the harness TypeScript tests;
- `framework/validate-skill.sh --no-cache` over every skill and fixture, for the D3.4 comparison.

**Target Platform**: macOS (BSD utilities) and Linux (GNU coreutils).

**Project Type**: authoring framework, skill sources, and test suite in one repository.

**Performance Goals**: the suite's run time does not grow; one skill and one test are added, and two
tests are removed.

**Constraints**:

- skill edits are limited to the activation step, old-path removal, and the version (FR-018);
- nothing is committed;
- `rollout-plan.md` stays gitignored and excluded;
- moves use `mv`.

**Scale/Scope**:

- 15 existing skills and 1 new skill;
- 3 moved documents;
- 7 removed always-on files and sources;
- the adapter generator and the paths helper;
- 7 tests changed, 2 removed, and 1 added;
- 4 harness source files;
- both constitutions and 6 live documents.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Development constitution 3.2.0.

**Process gates**

| Gate | Trigger | Verdict |
| --- | --- | --- |
| Packaging | True: shipped skills, the manifest, and `.highway/governance/` change | D1.1 PASS: the moved documents and the new skill name no `.specify/` or `specs/` (both already shipped or new text checked by shipped-tree-independence). D1.2 PASS by design: the verification tree resolves `hw_doc experience-standard` under `skills/` (R9). D6.2 PASS: `framework/README.md` links only to files the distribution holds |
| Toolchain | True: `framework/`, `tests/`, and `harness/bin/` change | D2.1–D2.4 PASS: no new command or flag; the generator's file loop uses `find` and `cp`, both declared. D2.5 PASS: the helper declares `HW_EXPERIENCE`, and the check's rules follow (R8) |
| Generator | True: `generate-agent-adapters.sh` changes, `generate-instructions.sh` is removed | D4.1–D4.3 PASS: the drift refusal covers every copied file; determinism holds because files are copied byte for byte in sorted order. D4.4: every adapter is regenerated in this change |
| Correspondence | True: a skill is added and 15 change | D4.5 PASS by design: highway-experience gets a catalog entry, copies, manifest rows, and distribution rows. D4.6 PASS: no artifact names an absent skill. D4.7 PASS: regeneration leaves no diff |
| Validation | True: the P2.6 rule text and the cache key change; no check's logic changes | D3.4 PASS: every skill and fixture verdict is recorded before and compared after (R9). D3.5 PASS with recorded reasons: the removed tests and rule-2 segments check behavior that no longer exists (R8, R10); every other assertion is kept or moved to the new location |

Also evaluated:

- D3.1: the suite runs before the first edit (`/tmp/hw236-baseline.log`).
- D3.3 PASS: tests change.
- D3.6: the new activation test and the harness invariant are observed failing on a seeded case
  before they are counted.
- D1.3, D1.4, and D5.3 are recorded in both Sync Impact Reports.
- D6.1: every live document naming a moved or removed path changes (R12).

**Skill content gates**

The Skill Content Gate triggers: `skills/` gains a skill and 15 skills change. Verdicts are against
the Highway Skills Constitution 10.1.0, as amended to 10.2.0:

- P1.5 PASS: each skill names highway-experience in Inputs.
- P2.6 PASS: no skill names `framework/`, a script, `git`, an absolute path, or a file time; the new
  skill names only its own `references/` files.
- P7.3 PASS: highway-experience cites the Experience Standard and the storage contract and restates
  neither; the other skills cite them by name.
- P7.7 PASS: each change is MINOR, and nothing depends on the old arrangement (clarification).
- P8.7 PASS: references are named in inline code, not linked.
- P9.5 PASS: highway-help's Example version follows its frontmatter.
- P10.1 PASS: every skill references the Experience Standard through highway-experience.

No FAIL. Re-checked after design: unchanged.

## Project Structure

### Documentation (this feature)

```text
specs/236-standard-alignment-experience/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── highway-experience.md
│   ├── storage-contract.md
│   └── harness-invariant.md
├── checklists/requirements.md
└── tasks.md
```

### Source Code (repository root)

```text
skills/highway-experience/            # new
├── SKILL.md
└── references/
    ├── highway-identity.md           # from .highway/library/knowledge/, byte-identical
    ├── experience-standard.md        # from .highway/governance/, byte-identical
    └── storage-contract.md           # from .highway/governance/storage.md, 1.1.0
skills/<15 others>/SKILL.md           # activation sentence, old paths removed, MINOR version
framework/
├── lib/paths.sh                      # HW_EXPERIENCE; hw_doc arms; removed variables
├── lib/validation-cache.sh           # hashes hw_doc experience-standard
├── generate-agent-adapters.sh        # copies bundled files
├── .distribution-manifest            # highway-experience rows; always-on rows removed
├── .adapter-manifest                 # regenerated
├── constitution.md                   # 10.2.0
├── authoring-standard.md, README.md
├── generate-instructions.sh          # removed
└── .instruction-manifest             # removed
tests/
├── experience-activation.test.sh     # new
├── storage-contract, adapter-coverage, generate-agent-adapters, harness-path-map,
│   path-construction .test.sh; run-all.sh   # amended
└── generate-instructions, instruction-coverage .test.sh  # removed
harness/
├── src/driver.ts, checks.ts, failure.ts, runner.ts
├── test/checks.test.ts, runner.test.ts
├── bin/path-map.sh, selection/shared.txt
├── scenarios/highway-experience/experience-smoke.scenario   # new
└── README.md
.highway/                             # catalog/, library/ only
.specify/memory/constitution.md       # 3.3.0
removed: AGENTS.md, .cursor/rules/highway-agent-context.mdc, .claude/CLAUDE.md,
         .github/copilot-instructions.md, .highway/instructions/, .highway/governance/
```

**Structure Decision**: highway-experience is an ordinary skill folder under `skills/`. Everything that
pointed at `.highway/governance/` or the always-on files now points at it.

## Complexity Tracking

None.
