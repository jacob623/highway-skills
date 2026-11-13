# Implementation Plan: Harness Failure Resolutions

**Branch**: `243-harness-failure-resolutions` | **Date**: 2026-11-12 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/243-harness-failure-resolutions/spec.md`

## Summary

Resolve harness findings F1, F2, F4, F5, F6, F8, F9, F10, F11, F12, F13, and F14 from
`harness-model-findings.md`, then prove the result with live runs on GPT-5.6 Luna.

- Skill text (R1 to R8):
  - Title selection in four `Entry` steps.
  - highway-profile `offer` as a state list.
  - Storage contract `1.2.0`: exact paths, no shell, and folders created by writing.
  - Governance record paths.
  - Onboarding `unknown` and GitHub Copilot.
  - Codify `check` and `record check`.
  - The governance `queue` question.
  - highway-implementation's `Classify the reply:` lines, its `field` split, and `accept`
    re-emitting the block.
- Scenarios: F4, F5, F9, and F14 script corrections, with keys ordered by R10.
- Harness: `service-error` with one retry and a `blocked` outcome (F8), a read of the experience
  `SKILL.md` counted as activation (F11), and `shows` without emphasis (F13).
- Last: the full suite, harness unit tests, regeneration, then the final live runs, with
  transcripts captured in this folder (gitignored) and the findings updated with their run ids.

## Technical Context

**Language/Version**: Bash 3.2.57 for scripts (D2.1). Markdown skill sources. TypeScript under
`harness/` for the runner and its unit tests (Node 24).

**Primary Dependencies**: the Declared Toolchain. For live runs only, the Harness Toolchain:
`@github/copilot-sdk`, with a token in `harness/.env`.

**Storage**: files, under `skills/*/` (source only), `harness/scenarios/**`, `harness/src/*.ts`,
`harness/test/*.ts`, and `tests/*.test.sh`. The agent trees (`.github/`, `.cursor/`, `.claude/`,
`.agents/`) and `skills/highway-help/assets/index.json` are regenerated, never edited.

**Testing**: `bash tests/run-all.sh` (85 tests today, 86 after). In `harness/`: `node --test
"test/*.test.ts"` and `tsc -p tsconfig.json`. Live runs: `node harness/src/cli.ts --model
gpt-5.6-luna`.

**Target Platform**: macOS (Apple/BSD utilities) and Linux (GNU) (D2.3).

**Project Type**: an authoring framework (validators, generators, tests, and a live harness) for a
set of Agent Skills.

**Performance Goals**: none.

**Constraints**:
- No backward compatibility.
- MINOR version bumps only.
- `rollout-plan.md` stays gitignored and excluded from the distribution.
- Secrets and tokens are redacted from every captured transcript.
- No commit unless asked.
- No harness run before the changes.

**Scale/Scope**:
- 11 skills change: adr, architecture, discovery, implementation, profile, onboarding, codify,
  objectives, controls, nfrs, and experience.
- 13 scenarios change: profile-smoke, setup-smoke, chain-setup, codify-config-smoke,
  onboarding-smoke, chain-implementation, implementation-onboards-platform, implementation-smoke,
  codify-needed-language, codify-platform-no-row, discovery-smoke, chain-discovery, and
  chain-architecture.
- 4 harness source files change: `failure.ts`, `driver.ts`, `runner.ts`, and `checks.ts`.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Process gates (development constitution 3.5.0)

| Gate | Triggered | Verdict |
| --- | --- | --- |
| Packaging (D1.1, D1.2, D6.2) | Yes: skill text changes | PASS: no changed line names a development path. The agent trees are regenerated from `skills/`. |
| Toolchain (D2.1–D2.5) | Yes: one new bash test | PASS: Bash 3.2 and Declared Toolchain utilities. It sources `paths.sh` and `flows.sh` and builds no root path. |
| Generator (D4.1–D4.4) | No: no `generate-*.sh` change | N/A |
| Correspondence (D4.5–D4.7) | Yes: skill folders change | PASS: the generators run, and a second run changes nothing (FR-021). |
| Validation (D3.4, D3.5) | Yes | D3.4: no new validator check. D3.5 PASS: no assertion is loosened. `code-project.test.sh` is tightened to the full rule-2 line. The `shows` comparison drops emphasis, and the harness README records the superseded exact comparison (FR-019). |
| Skill Content | Yes | Delegated below (D1.5). |

Also applied:
- D3.1: the baseline suite is not rerun; spec 242 ended green at 85 of 85.
- D3.2: the full suite runs after the last edit.
- D3.3: `tests/` changes.
- D3.6: every new assertion is observed failing first (FR-020).
- D3.7: the new test declares its probe.
- D3.8: the live runs are the behavior evidence (FR-023).
- D8.1: each changed skill is validated.

### Skill content gates (Highway Skills Constitution 10.4.0)

| Rule | Verdict |
| --- | --- |
| P2.6 | PASS: no skill names a script, `git`, or an absolute path. The storage contract names "shell command" and "search or pattern tool" as acts a skill does not do, and bundled files are exempt from P2.6. |
| P5.6, P5.15, P5.16 | PASS: descriptions and `## When to use` are unchanged. |
| P7.2, P7.7 | PASS: each changed skill takes one MINOR bump. No Input, Output, or Verification element is removed. Profile's retrieval bullet is rewritten, not dropped. |
| P8.3, P8.4 | PASS: every `## Verification` stays non-empty. |
| X2.67 (Experience Standard) | PASS: each new question is bold. The setup-needed message stays bold. |
| Flow pattern (boundaries 1 to 12) | PASS by design: new reply lines are list items that start with a backticked class. Step references are backticked step names. Checked by `skill-flow-pattern.test.sh`. |

Post-design re-check: unchanged. No FAIL, no exception.

## Project Structure

### Documentation (this feature)

```text
specs/243-harness-failure-resolutions/
├── spec.md
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── skill-text.md
│   ├── scenario-scripts.md
│   ├── harness-behavior.md
│   └── final-run-evidence.md
├── checklists/requirements.md
├── harness/                    # gitignored: final run transcripts
└── tasks.md
```

### Source Code (repository root)

```text
skills/
├── highway-adr/SKILL.md                         # Entry step 1 (R1)
├── highway-architecture/SKILL.md                # Entry step 1 (R1)
├── highway-discovery/SKILL.md                   # Entry step 1 (R1)
├── highway-implementation/SKILL.md              # Entry step 3 (R1), choose, field (R8)
├── highway-implementation/references/{proposal,record,amend}.md   # Classify the reply:, accept (R8)
├── highway-profile/SKILL.md                     # offer, Verification (R2)
├── highway-experience/SKILL.md                  # version 1.2.0
├── highway-experience/references/storage-contract.md   # 1.2.0 (R3)
├── highway-objectives/SKILL.md, references/proposal.md # Entry (R4), queue (R7)
├── highway-controls/SKILL.md, references/proposal.md   # Entry (R4), queue (R7)
├── highway-nfrs/SKILL.md, references/proposal.md       # Entry (R4), queue (R7)
├── highway-onboarding/references/proposal.md    # map (R5)
└── highway-codify/SKILL.md, references/record.md       # record check, check (R6)
harness/
├── src/failure.ts, driver.ts, runner.ts, checks.ts     # R9
├── test/failure.test.ts, checks.test.ts, runner.test.ts
├── scenarios/**                                  # 13 scripts (contracts/scenario-scripts.md)
└── README.md                                     # service-error kind, shows note
tests/
├── harness-failure-resolutions.test.sh           # new
└── code-project.test.sh                          # rule 2 line
.gitignore                                        # specs/243-harness-failure-resolutions/harness/*
harness-model-findings.md                         # resolutions and confirming runs
.github/ .claude/ .cursor/ .agents/, skills/highway-help/assets/index.json   # regenerated
```

**Structure Decision**: Skill source changes only under `skills/`. The generators carry them to
the agent trees.

## Complexity Tracking

No violations.
