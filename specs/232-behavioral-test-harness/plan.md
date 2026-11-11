# Implementation Plan: Behavioral Test Harness

**Branch**: `232-behavioral-test-harness` | **Date**: 2026-11-10 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/232-behavioral-test-harness/spec.md`

## Summary

Build a headless test harness in a top-level `harness/` folder that drives real GitHub Copilot
sessions against Highway skills through the Copilot SDK. A TypeScript runner on Node 24 builds a
fresh test project per attempt from the distribution output plus a fixture, answers the agent from
keyed replies (exact question text first, judge-model fallback), checks the files written
structurally, enforces the storage invariant from `writes:` patterns, retries a failure once, and
prints a self-contained failure block to stdout. Scenario files are plain `key: value` lines, so the
bash suite checks fixtures, coverage, smoke count, chain positions, and the path map without Node.
Two bash scripts under `harness/bin/` own the coverage inventory and the path map, and the runner
calls them, so each rule has one implementation. highway-codify is the only gated skill.

## Technical Context

**Language/Version**: TypeScript run directly by Node 24 LTS (native type stripping, no build
step); Bash 3.2 for the static checks.

**Primary Dependencies**: `@github/copilot-sdk` (runtime, bundles the Copilot CLI runtime);
`typescript` (dev, `tsc --noEmit` type check only). Node built-ins for everything else: `node:test`,
`node:crypto`, `node:child_process`, `node:fs`.

**Storage**: Files. Scenarios, fixtures, coverage treatments, and selection lists are committed
under `harness/`. Run output goes to `harness/runs/` (gitignored).

**Testing**: The bash suite (`.highway/tools/tests/run-all.sh`) gains `harness-*.test.sh` checks
that need no Node. Runner logic is unit-tested with `node --test harness/test/`. Live sessions need a
Copilot token in `harness/.env` and are run by hand.

**Target Platform**: macOS and Linux developer machines; a CI runner later.

**Project Type**: CLI tool (development-only).

**Performance Goals**: Defaults of 4 parallel scenarios, 40 turns, and 20 minutes per attempt. No
cost cap until the spike shows how usage is reported.

**Constraints**: Nothing under `harness/` ships. The runner never waits on a person. Every failure
is diagnosable from stdout alone. Shared rules (coverage hashing, path map) have one implementation.

**Scale/Scope**: 15 skills, about 68 highway-codify bullets, 15 smoke scenarios, 6 chain scenarios,
5 stage fixtures.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Evaluated against the Highway Development Constitution 2.2.0.

**Process gates**

| Gate | Triggered | Verdict |
|---|---|---|
| Packaging Gate | Yes: the distribution manifest gains `exclude harness` | D1.1 PASS (nothing under `harness/` ships, so no shipped file gains a development reference). D1.2 PASS (no shipped file changes). D6.2 PASS (README links resolve inside `harness/`). |
| Toolchain Gate | Yes: tests are added under `.highway/tools/tests/` | D2.1 PASS (new bash tests and `harness/bin/*.sh` use no Bash 4 features). D2.2 PASS (only declared utilities). D2.3 PASS (no platform-specific flags). D2.4 PASS after the amendment below: Node, TypeScript, the Copilot SDK, and `git` are declared as a development-only Harness Toolchain confined to `harness/`. No script under `.highway/tools/` invokes them. |
| Generator Gate | No | N/A |
| Correspondence Gate | No: no skill directory or generator input changes | N/A |
| Validation Gate | Yes: new checks are added | D3.4 PASS (each new check is evaluated against the committed scenarios and fixtures before wiring, recorded in research.md R12). D3.5 PASS (no assertion is loosened). |
| Skill Content Gate | No | N/A: Skill Content Gate not triggered |

Principle III: D3.1 baseline and D3.2 final suite runs are recorded in `baseline.txt` and
`final.txt`. D3.3: new `harness-*.test.sh` tests. D3.6: each new test is observed failing on its
seeded probe before the behavior it covers is complete. D3.8: the bash checks are
static-document-contract evidence. Executed-behavior evidence for live sessions is not claimed;
the `node --test` suite is the executed evidence for runner logic.

**Development constitution amendment (MINOR, 2.2.0 → 2.3.0)**: add a Harness Toolchain declaration
under Principle II. It names Node 24, TypeScript, `@github/copilot-sdk`, and `git` as
development-only, used only under `harness/`, and outside the Declared Toolchain that D2.2 and D2.4
govern. No rule text changes, and no conforming work fails. The amendment carries a Sync Impact
Report with the D1.3, D1.4, and D5.3 self-application review.

Post-design re-check: PASS. The design keeps every Node dependency inside `harness/` and adds only
Bash 3.2 and declared-toolchain scripts to the bash suite.

## Project Structure

### Documentation (this feature)

```text
specs/232-behavioral-test-harness/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── cli.md
│   ├── scenario-format.md
│   └── failure-output.md
├── checklists/requirements.md
└── tasks.md
```

### Source Code (repository root)

```text
harness/
├── README.md
├── package.json              # private; scripts: harness, test, typecheck
├── package-lock.json
├── tsconfig.json             # noEmit, erasableSyntaxOnly, allowImportingTsExtensions
├── harness.config.json       # pinned default model, judge default
├── bin/
│   ├── inventory.sh          # coverage inventory: skill, kind, hash, text
│   ├── path-map.sh           # path -> skills | shared | none, with a reason
│   └── lib/scenario.sh       # line-based scenario reader for bash
├── src/
│   ├── cli.ts                # entry point
│   ├── switches.ts           # one switch per line; parser and help read it
│   ├── args.ts               # parser, conflicts, help text
│   ├── config.ts             # harness.config.json and .env
│   ├── scenario.ts           # scenario reader
│   ├── select.ts             # full, smoke, targeted selection with reasons
│   ├── project.ts            # distribution build, test project per attempt
│   ├── replies.ts            # exact-text match, fallback decision
│   ├── driver.ts             # Copilot SDK session, permissions, turn loop
│   ├── checks.ts             # structural file assertions, storage invariant
│   ├── judge.ts              # advisory judge and reply fallback session
│   ├── redact.ts
│   ├── failure.ts            # failure kinds, likely causes, stdout blocks
│   ├── report.ts             # run report, JUnit XML, selection reasons
│   ├── chain.ts              # chain order, candidates, promote
│   └── runner.ts             # attempts, retry, rate limits, parallelism
├── test/*.test.ts            # node --test
├── scenarios/<skill>/<name>.scenario
├── fixtures/
│   ├── templates.map         # fixture path pattern -> output template
│   ├── stages/{setup,request,discovery,architecture,implementation}/
│   └── overlays/<name>/      # files copied over a stage; optional .delete list
├── coverage/treatments.txt   # invariants and waivers
├── selection/shared.txt      # shared files that select the smoke set
└── runs/                     # gitignored

.highway/tools/tests/
├── harness-placement.test.sh
├── harness-scenarios.test.sh
├── harness-fixtures.test.sh
├── harness-coverage.test.sh
├── harness-path-map.test.sh
└── harness-switches.test.sh
```

Also changed: `.highway/tools/.distribution-manifest` (`exclude harness`), `.gitignore`
(`harness/runs/`, `harness/node_modules/`, `harness/.env`, `.env`),
`.specify/memory/constitution.md` (2.3.0 amendment), and `rollout-plan.md` (Phase 2 status).

**Structure Decision**: One top-level `harness/` tool. Rules that both bash and the runner need
(coverage hashing, path map) live in `harness/bin/*.sh`, and the runner spawns them, so they have
one implementation each.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|---|---|---|
| A second toolchain (Node) in the repository | The Copilot SDK is a Node package, and the spec names it | Driving the Copilot CLI from bash would need `jq`-style JSON handling outside the declared toolchain and could not answer `ask_user` requests |
