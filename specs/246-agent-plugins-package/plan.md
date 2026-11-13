# Implementation Plan: Agent Plugins Package

**Branch**: `246-agent-plugins-package` | **Date**: 2026-11-13 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/246-agent-plugins-package/spec.md`

## Summary

A new declared generator, `framework/generate-agent-plugin.sh`, builds `highway-agent-plugin/` from
`skills/` and `framework/plugin/`:

- `plugin.json`, copied from `framework/plugin/plugin.json`;
- `skills/<name>/` for each of the 16 skills, copied byte for byte;
- `README.md` and `LICENSE`.

`framework/validate-plugin.sh` checks the manifest and layout against Agent Plugins 1.0.0 and runs
`validate-skill.sh` on every plugin skill. `tests/agent-plugin.test.sh` checks four things:

- the committed plugin passes the validator;
- it matches a fresh build, using `generate-agent-plugin.sh --check`;
- it holds only the shipped set;
- seeded defects fail.

The harness changes how each attempt gets the skills. It installs the committed plugin through
Copilot's plugin install, into the attempt's own Copilot home, and no longer copies `skills/` into
`.github/skills/`. It refuses a stale plugin, and it allows reads inside the installed plugin. The
Development Constitution takes a MINOR amendment to 3.6.0, declaring the generator and the
`python3` JSON use. After the full suite passes, the smoke set runs on `gpt-5.6-luna` with
transcripts in `specs/246-agent-plugins-package/harness/`, and its failures are recorded in
`harness-model-findings.md`.

## Technical Context

**Language/Version**: Bash 3.2.57 with the Declared Toolchain, plus `python3` and the standard-library
`json` module, for `framework/` and `tests/`. The harness uses TypeScript on Node 24.

**Primary Dependencies**: `@github/copilot-sdk` 1.0.30, with CLI 1.0.108, for the harness install
(`rpc.plugins.install`). No new dependency.

**Storage**: Files. The committed folder `highway-agent-plugin/` holds four entries; the sources
are in `framework/plugin/`.

**Testing**: `tests/run-all.sh` runs the bash suite, and `npm test` in `harness/` runs the
`node:test` suite. The harness itself runs with `node harness/src/cli.ts --smoke`.

**Target Platform**: macOS (BSD utilities) and Linux (GNU coreutils).

**Project Type**: A skill framework, with a generator, a validator, a bash test suite, and a
behavioral harness.

**Performance Goals**: Running `generate-agent-plugin.sh --check` once at harness start adds under
10 seconds. Installing the plugin adds about one second to each attempt.

**Constraints**:

- No commit.
- No skill text or version changes (FR-023).
- Secrets are redacted, and the token is never printed.
- Edits use `mv`, not `git mv`.
- Version bumps are MINOR only.

**Scale/Scope**: 16 skills and about 150 files in the plugin.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Process gates (Development Constitution 3.5.0, amended to 3.6.0 by this change)

| Gate | Trigger | Rules | Verdict |
| --- | --- | --- | --- |
| Packaging Gate | `framework/README.md` ships as the distribution's `README.md` and gains a section | D1.1, D1.2, D6.2 | PASS: the new section names `framework/` and `highway-agent-plugin/` paths only, no `.specify/` or `specs/`. The distribution excludes `highway-agent-plugin/` (R8), and every cross-reference resolves. |
| Toolchain Gate | New and changed scripts under `framework/`, `tests/`, and `harness/bin/` | D2.1 to D2.5 | PASS: Bash 3.2 with no associative arrays. Utilities are from the Declared Toolchain, plus `python3` with `json`, declared by the amendment (D2.2, D2.4). Flags are portable (D2.3). Paths come from `HW_PLUGIN` and `HW_PLUGIN_SOURCE` in `paths.sh` (D2.5). |
| Generator Gate | New `generate-agent-plugin.sh` | D4.1 to D4.4 | PASS: a hand edit shows as drift and is replaced on regeneration (D4.1, R5). Two builds are byte-identical (D4.2). It refuses a target folder it did not produce (D4.3). The plugin is regenerated in this change (D4.4). |
| Correspondence Gate | New inputs to a declared generator (`framework/plugin/`) | D4.5 to D4.7 | PASS: D4.5 and D4.6 are unchanged. D4.7's regeneration in `adapter-coverage.test.sh` now covers the plugin. |
| Validation Gate | New checks in `validate-plugin.sh` and `agent-plugin.test.sh`, and the extended D4.7 regeneration | D3.4, D3.5 | PASS: each check's verdict on the current plugin and the probes is recorded before it is wired in (D3.4, tasks). The changed `project.test.ts` assertion is replaced, with the superseded behavior recorded (D3.5). |
| Skill Content Gate | No file under `skills/` changes | Delegated (D1.5) | N/A |

Verification rules: D3.1 is the baseline run before the first edit. D3.2 is the final run. D3.3:
`tests/agent-plugin.test.sh` and harness tests are added. D3.6: each new check is observed failing
on its seeded defect before the code that makes it pass. D3.7: the D4.7 leg's probe in
`adapter-coverage.test.sh` still fails on a seeded source change. D5.3: the amendment names every
changed element. D7.3: the report states suite results and requirement coverage separately.

### Skill content gates

N/A: Skill Content Gate not triggered.

### Post-design re-check

Re-evaluated after Phase 1. The contracts add no shipped path beyond `framework/README.md`, no
utility outside the amended toolchain, and no skill edit. All gates hold.

## Project Structure

### Documentation (this feature)

```text
specs/246-agent-plugins-package/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── generate-agent-plugin.md
│   ├── validate-plugin.md
│   ├── harness-plugin-install.md
│   └── smoke-findings.md
├── checklists/requirements.md
├── harness/            # smoke-run transcripts (gitignored)
└── tasks.md
```

### Source Code (repository root)

```text
framework/
├── generate-agent-plugin.sh      # new: build, or --check
├── validate-plugin.sh            # new: Agent Plugins 1.0.0 manifest and layout, plus Agent Skills per skill
├── lib/paths.sh                  # HW_PLUGIN, HW_PLUGIN_SOURCE
├── lib/plugin-manifest.sh        # new: strict plugin.json reader (python3 json)
├── plugin/                       # new: plugin.json, README.md, LICENSE sources
├── constitution.md               # unchanged (Highway Skills Constitution)
├── .distribution-manifest        # exclude highway-agent-plugin
└── README.md                     # generator and validator sections
highway-agent-plugin/             # new, generated and committed
tests/
├── agent-plugin.test.sh          # new
├── adapter-coverage.test.sh      # D4.7 regenerates the plugin too
└── README.md                     # lists the new test
harness/
├── bin/path-map.sh               # --location plugin; plugin paths select nothing
├── src/project.ts                # buildPlugin: stale check plus an empty base project
├── src/driver.ts                 # install per attempt; reads inside installed-plugins
├── src/failure.ts                # plugin-install kind
├── src/runner.ts                 # passes the plugin to the driver
├── test/*.test.ts                # project, driver policy, failure kinds
└── README.md                     # the plugin install
.specify/memory/constitution.md   # 3.6.0
.gitignore                        # specs/246-agent-plugins-package/harness/*
harness-model-findings.md         # F26 and onward, if the smoke run fails
standard-alignment.md             # Phase 16 status
README.md                         # names the plugin generator
```

**Structure Decision**: the existing layout is kept. The new generator and validator sit beside
the existing ones in `framework/`, the plugin sources sit in `framework/plugin/`, and the built
plugin sits at the repository root, where Phase 18 publishes it from.

## Complexity Tracking

No violations to justify.
