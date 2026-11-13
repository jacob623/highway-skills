# Implementation Plan: Harness Failure Follow-ups

**Branch**: `244-harness-failure-followups` | **Date**: 2026-11-13 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/244-harness-failure-followups/spec.md`

## Summary

Resolve the eight findings under `# Harness Failures` in `harness-model-findings.md`: F3, F5, F7,
F15, F16, F17, F18, and F21. Then prove the result with live runs on GPT-5.6 Luna, against spec
243's final runs.

- Skill text (R1 to R4):
  - A `close` step in highway-objectives, highway-controls, and highway-nfrs. It returns `Finished`
    silently to highway-setup, and otherwise emits one closing line.
  - highway-codify-config's menu `decline` emits a closing line.
  - highway-codify's refusal line re-emits the proposal, and `Entry` step 2 excludes a bare
    invocation from `catalog`.
  - highway-discovery's and highway-adr's write steps keep every template heading and table
    header row.
- Scenarios (R5 to R7):
  - 10 catch-alls replaced or removed.
  - The governance smoke scripts move to a new `contains-any` assertion and check the closing
    line.
  - Three onboarding scripts answer the `Unknown` provider prompts.
  - codify-configure opens in prose.
- Harness (R8 to R10):
  - The fallback is offered only the earliest unused reply.
  - A new `repeated-question` failure kind.
  - The end-of-turn check judges only the text after the last in-turn answer.
  - The `contains-any` assertion.
- Last:
  - The full suite, the harness unit tests, and regeneration.
  - One live run, `--changed-since 42a0569`, plus `--paths` for the spec 243 failures that
    selection leaves out.
  - Transcripts captured in this folder (gitignored).
  - The findings document updated per FR-020.

## Technical Context

**Language/Version**: Bash 3.2.57 for scripts (D2.1). Markdown skill sources. TypeScript under
`harness/` for the runner and its unit tests (Node 24).

**Primary Dependencies**: the Declared Toolchain. For live runs only, the Harness Toolchain:
`@github/copilot-sdk`, with a token in `harness/.env`.

**Storage**: files, under:
- `skills/*/` (source only)
- `harness/scenarios/**`, `harness/src/*.ts`, and `harness/test/*.ts`
- `tests/*.test.sh`

The agent trees (`.github/`, `.cursor/`, `.claude/`, `.agents/`) and
`skills/highway-help/assets/index.json` are regenerated, never edited.

**Testing**:
- `bash tests/run-all.sh`: 86 tests today, 87 after.
- In `harness/`: `node --test "test/*.test.ts"` and `tsc -p tsconfig.json`.
- Live runs: `node harness/src/cli.ts --model gpt-5.6-luna`.

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
- Templates do not change.

**Scale/Scope**:
- 7 skills change: objectives, controls, nfrs, codify-config, codify, discovery, and adr.
- 14 scenarios change:
  - Catch-alls: adr-smoke, architecture-smoke, assessment-smoke, chain-request, codify-control-unmet, codify-standard-unmet, controls-smoke, nfrs-smoke, objectives-smoke, and request-smoke.
  - Onboarding replies: onboarding-smoke, chain-implementation, and implementation-onboards-platform.
  - Opening: codify-configure.
  - Assertion and closing line: the three governance smokes, already counted above.
- 6 harness source files change: `replies.ts`, `driver.ts`, `runner.ts`, `failure.ts`, `checks.ts`, and `scenario.ts` (the assertion list).
- 1 new bash test. 2 bash tests are amended: `configure-handoff.test.sh` and `harness-scenarios.test.sh`.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Process gates (development constitution 3.5.0)

| Gate | Triggered | Verdict |
| --- | --- | --- |
| Packaging (D1.1, D1.2, D6.2) | Yes: skill text changes | PASS: no changed line names a development path. The agent trees are regenerated from `skills/`. |
| Toolchain (D2.1–D2.5) | Yes: one new bash test | PASS: Bash 3.2 and Declared Toolchain utilities. It sources `paths.sh` and `flows.sh` and builds no root path. |
| Generator (D4.1–D4.4) | No: no `generate-*.sh` change | N/A |
| Correspondence (D4.5–D4.7) | Yes: skill folders change | PASS: the generators run, and a second run changes nothing (FR-015). |
| Validation (D3.4, D3.5) | Yes | D3.4: no new validator check. D3.5 PASS: `contains` keeps its meaning; `contains-any` is a new assertion. The fallback rule narrows what passes. `configure-handoff.test.sh` is amended to the new `decline` line, which keeps the return-step clause it pinned. |
| Skill Content | Yes | Delegated below (D1.5). |

Also applied:
- D3.1: the baseline suite is not rerun; spec 243 ended green at 86 of 86.
- D3.2: the full suite runs after the last edit.
- D3.3: `tests/` changes.
- D3.6: every new assertion is observed failing first (FR-014).
- D3.7: the new test declares its probe.
- D3.8: the live runs are the behavior evidence (FR-017).
- D8.1: each changed skill is validated.

### Skill content gates (Highway Skills Constitution 10.4.0)

| Rule | Verdict |
| --- | --- |
| P2.6 | PASS: no skill names a script, `git`, or an absolute path. The closing lines name skills by their invocation name, as existing lines do ("run highway-controls"). |
| P5.6, P5.15, P5.16 | PASS: descriptions and `## When to use` are unchanged. |
| P7.2, P7.7 | PASS: each changed skill takes one MINOR bump. No Input or Verification element is removed. An Output line is added to the governance skills. Two Verification bullets are rewritten, not dropped. |
| P8.3, P8.4 | PASS: every `## Verification` stays non-empty. |
| X2.67 (Experience Standard) | PASS: no new question. The closing lines are statements and are not bold. |
| Flow pattern (boundaries 1 to 12) | PASS by design: `close` is a `###` step with no reply list. Step references are backticked step names. Checked by `skill-flow-pattern.test.sh`. |

Post-design re-check: unchanged. No FAIL, no exception.

## Project Structure

### Documentation (this feature)

```text
specs/244-harness-failure-followups/
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
├── highway-objectives/SKILL.md, references/{proposal,record}.md   # close (R1)
├── highway-controls/SKILL.md, references/{proposal,record}.md     # close (R1)
├── highway-nfrs/SKILL.md, references/{proposal,record}.md         # close (R1)
├── highway-codify-config/SKILL.md                                 # menu decline (R2)
├── highway-codify/SKILL.md, references/proposal.md                # Entry step 2, refusal (R3)
├── highway-discovery/SKILL.md, references/options.md              # write (R4)
└── highway-adr/SKILL.md, references/record.md                     # write, onboarding (R4)
harness/
├── src/replies.ts, driver.ts, runner.ts, failure.ts, checks.ts, scenario.ts   # R8–R10
├── test/replies.test.ts, checks.test.ts, failure.test.ts, runner.test.ts, scenario.test.ts
├── scenarios/**                                  # 14 scripts (contracts/scenario-scripts.md)
└── README.md                                     # contains-any, repeated-question, end-of-turn rule
tests/
├── harness-failure-followups.test.sh             # new
├── configure-handoff.test.sh                     # menu decline line
└── harness-scenarios.test.sh                     # contains-any in the assertion list
.gitignore                                        # specs/244-harness-failure-followups/harness/*
harness-model-findings.md                         # FR-020 update
.github/ .claude/ .cursor/ .agents/, skills/highway-help/assets/index.json   # regenerated
```

**Structure Decision**: Skill source changes only under `skills/`. The generators carry them to
the agent trees.

## Complexity Tracking

No violations.
