# Implementation Plan: Standard Alignment Progressive Disclosure

**Branch**: `feature/std-alignment-phase14` | **Date**: 2026-11-12 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/242-standard-alignment-progressive-disclosure/spec.md`

## Summary

Twelve skills split along the cross-skill pattern Phase 13 of `standard-alignment.md` records.

- `SKILL.md` becomes a router. Its Procedure introduction gains the flows-table sentence and a File
  and Steps table. Every other step moves, unchanged, into one flow file in `references/`.
- Each flow file starts with a level-1 heading and ends with `## Verification`, holding the checks
  for its steps.
- A new library, `framework/lib/flows.sh`, reads the flows table. The validator, the harness
  inventory, the new boundary test, and the tests that pin skill text all read flow files through
  it (R1).
- `validate-skill.sh` judges a flow file by every rule that judges `SKILL.md`'s instructions,
  except P7.1, P7.2, and P8.7 (R4).
- `tests/skill-flow-pattern.test.sh` checks Phase 13's eleven boundaries, and boundary 12, on every skill (R10).
- The harness runs on GPT-5.6 Luna. The live smoke run before any skill change passed 6 of 16
  on unchanged skills. It is the baseline, with its failures recorded in
  `harness-model-findings.md`. The smoke run after the change, and a live run of every affected
  scenario, must do no worse (R8, R9, contracts/live-harness-evidence.md).

## Technical Context

**Language/Version**: Bash 3.2.57 for every script (D2.1). Markdown skill sources. TypeScript
under `harness/` for its runner and unit tests.

**Primary Dependencies**: the Declared Toolchain. The Harness Toolchain (Node 24,
`@github/copilot-sdk`) for live runs only.

**Storage**: files: `skills/*/SKILL.md`, `skills/*/references/*.md`, the agent trees,
`framework/.adapter-manifest`, `skills/highway-help/assets/index.json`.

**Testing**: `tests/run-all.sh` (84 tests today, 85 after: +1). Harness: `node --test
"test/*.test.ts"`, `tsc`, and live runs through `node harness/src/cli.ts`.

**Target Platform**: macOS (Apple/BSD utilities) and Linux (GNU) (D2.3).

**Project Type**: an authoring framework (validators, generators, tests) for a set of Agent
Skills.

**Performance Goals**: none beyond today's. Each skill validation reads its flows table once.

**Constraints**:
- no backward compatibility;
- skill versions take MINOR bumps;
- `rollout-plan.md` stays gitignored and excluded from the distribution;
- secrets and tokens are redacted, including from the kept transcripts;
- no commit unless asked.

**Scale/Scope**:
- 12 skills split into 27 flow files; 4 skills unchanged;
- 49 of 84 tests name a split skill's `SKILL.md`; those that pin moved text read it through
  `fl_skill_text` (R6);
- 16 smoke scenarios and about 45 affected scenarios for the live runs.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Process gates (development constitution 3.5.0)

| Gate | Triggered | Verdict |
| --- | --- | --- |
| Packaging (D1.1, D1.2, D6.2) | Yes: skills and agent trees change | D1.1 PASS: flow files name no development path. D1.2 PASS: the agent trees carry `references/`, so validating from `.agents/skills/` resolves each flows table. D6.2 PASS: the distribution's cross-reference check covers flow files. |
| Toolchain (D2.1–D2.5) | Yes: `framework/lib/`, `validate-skill.sh`, `tests/`, `harness/bin/inventory.sh` | PASS: Bash 3.2, Declared Toolchain utilities only, no new flags. `flows.sh` takes a skill folder as its argument and builds no root path (D2.5). |
| Generator (D4.1–D4.4) | No: no `generate-*.sh` changes | N/A |
| Correspondence (D4.5–D4.7) | Yes: skill folders change | PASS: the adapter generator copies each flow file with its own manifest row; the catalog and agent trees are regenerated, and a second run changes nothing. |
| Validation (D3.4, D3.5) | Yes: a new test and a new validator file kind | D3.4 PASS: the boundary test's verdict for every skill is recorded in `data-model.md` before it is wired in. D3.5 PASS: tests that pin moved text read it from the skill folder; no assertion is removed or loosened (R6). |
| Skill Content | Yes | Delegated below (D1.5). |

Also applied:
- D3.1: baseline `tests/run-all.sh` before the first edit.
- D3.2: the full suite after the last edit.
- D3.3: tests change.
- D3.6: each boundary and each newly applied validator rule is observed failing on a seeded defect.
- D3.7: the boundary test declares its probe.
- D3.8: live harness runs, not the text checks, are the evidence that behavior is unchanged.
- D6.1: the authoring standard and the harness README change in this change.
- D8.1: each split skill is re-validated with its flow files.

### Skill content gates (Highway Skills Constitution 10.4.0)

| Rule | Verdict |
| --- | --- |
| P1.1, P1.3, P7.4, P7.5 | PASS: no skill has a MUST-level line, and flow files are now judged by these rules (R4). |
| P2.6 | PASS: moved text is judged by it in its flow file; no moved step names a framework path, `git`, or an absolute path. |
| P5.6, P5.15, P5.16 | PASS: `## When to use` and the descriptions are unchanged. |
| P7.1 | PASS: `## Purpose` stays in `SKILL.md`. |
| P7.2, P7.7 | PASS: each split skill takes a MINOR bump. No Input, Output, or Verification element is removed; Verification bullets move with their flows. |
| P8.3, P8.4 | PASS: `SKILL.md` keeps a non-empty `## Verification`, and every flow file has one. |
| P8.7 | PASS: the flows table names files in inline code, not links. |
| P9.5 | PASS: each Example that repeats a version shows the new one. |

Post-design re-check: unchanged. No FAIL, no exception.

## Project Structure

### Documentation (this feature)

```text
specs/242-standard-alignment-progressive-disclosure/
├── spec.md
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── router-and-flow-file.md
│   ├── boundary-test.md
│   ├── validator-flow-kind.md
│   └── live-harness-evidence.md
├── harness/
│   ├── pre-smoke/                      # transcripts of the smoke run before any skill change
│   └── post-smoke/                     # transcripts of the smoke run after the split
├── checklists/requirements.md
└── tasks.md
```

### Source Code (repository root)

```text
skills/<12 split skills>/SKILL.md            # router: flows table; MINOR bump
skills/<12 split skills>/references/*.md     # new: 27 flow files
framework/
├── lib/flows.sh                             # new: fl_table, fl_files, fl_steps, fl_skill_text
├── lib/rule-checks.sh                       # rc_flow_exempt_ids
├── validate-skill.sh                        # flow kind for files a flows table names
├── authoring-standard.md                    # router, flow files, flows table, limits
├── .adapter-manifest                        # regenerated: flow file rows
tests/
├── skill-flow-pattern.test.sh               # new: boundaries 1 to 12
├── validate-skill.test.sh                   # flow kind cases
└── <tests that pin split skill text>        # read through fl_skill_text (R6)
harness/
├── harness.config.json                      # model: GPT-5.6 Luna
├── bin/inventory.sh                         # steps and bullets from flow files
└── README.md                                # inventory reads flow files
.github/ .claude/ .cursor/ .agents/          # regenerated agent trees
skills/highway-help/assets/index.json        # regenerated versions
standard-alignment.md                        # Phase 14 status
```

**Structure Decision**: one library, `flows.sh`, is the only reader of the flows table. Every
consumer goes through it, so the table's format is defined once.

## Complexity Tracking

No violations.
