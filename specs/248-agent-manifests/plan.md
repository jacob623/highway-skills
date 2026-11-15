# Implementation Plan: Agent Manifests

**Branch**: `248-agent-manifests` | **Date**: 2026-11-14 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/248-agent-manifests/spec.md`

## Summary

`framework/generate-agent-plugin.sh` writes five agent manifests beside the root `plugin.json` in
`highway-agent-plugin/`:

- `.claude-plugin/plugin.json`;
- `.codex-plugin/plugin.json`;
- `.cursor-plugin/plugin.json`;
- `.antigravity-plugin/plugin.json`;
- `gemini-extension.json`.

It also copies `assets/logo.svg`, a placeholder. The manifests are rendered from
`framework/plugin/plugin.json`, which keeps the shared fields and gains `author` and `keywords`,
and from a new `framework/plugin/listing.json`, which holds the fields only Codex, Cursor, or
Antigravity reads. The renderer and its format table live in `framework/lib/plugin-manifest.sh`
(R1), so the generator and the validator share one field list. The generator refuses a listing
file that repeats a shared or derived field. `framework/validate-plugin.sh` gains `[AGENT]`
findings for each manifest and a closed list of shipped entries.

`tests/agent-plugin.test.sh` covers the new shipped set and seeds each defect the spec names.
`framework/README.md` documents where each field lives. The Development Constitution takes a MINOR
amendment to 3.7.0, naming the manifest set. The plan follows the documented formats where they
differ from the spec's first field list: Cursor carries no display name or category, and
Antigravity no category (R4, R5; FR-002 updated). After the full suite passes, one Copilot smoke
run proves Copilot still installs `highway` with 16 skills, and its log is committed at
`specs/248-agent-manifests/harness/smoke.log`.

## Technical Context

**Language/Version**: Bash 3.2.57 with the Declared Toolchain, plus `python3` and the
standard-library `json` module, inside `framework/lib/plugin-manifest.sh`.

**Primary Dependencies**: none new. The harness (Node 24, `@github/copilot-sdk`) is unchanged and
is used only for the smoke run.

**Storage**: Files. Sources in `framework/plugin/` (`plugin.json`, `listing.json`, `README.md`,
`LICENSE`, `assets/logo.svg`); output in the committed `highway-agent-plugin/`.

**Testing**: `tests/run-all.sh` (bash suite, about 11 minutes, run alone and unsandboxed), and
`npm --prefix harness test` and `npm --prefix harness run typecheck` for the harness. The live
check is `node harness/src/cli.ts --agent copilot --smoke`.

**Target Platform**: macOS (BSD utilities) and Linux (GNU coreutils).

**Project Type**: A skill framework, with generators, validators, a bash test suite, and a
behavioral harness.

**Performance Goals**: The generator's run time stays within a second of today's; rendering five
small JSON files is one `python3` call.

**Constraints**:

- No commit.
- No skill, template, fixture, or scenario change (FR-020).
- Secrets are redacted, and the token is never printed.
- `mv`, not `git mv`; MINOR version bumps only; no backward compatibility.
- `rollout-plan.md` stays gitignored and excluded from the distribution.

**Scale/Scope**: six manifests, one listing file, one logo, 16 skills.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Process gates (Development Constitution 3.6.0, amended to 3.7.0 by this change)

| Gate | Trigger | Rules | Verdict |
| --- | --- | --- | --- |
| Packaging Gate | `framework/README.md` ships as the distribution's `README.md` and changes | D1.1, D1.2, D6.2 | PASS: the new text names `framework/` and `highway-agent-plugin/` paths only, no `.specify/` or `specs/`. The distribution still excludes `highway-agent-plugin/`, and every cross-reference resolves. |
| Toolchain Gate | Changed `framework/lib/plugin-manifest.sh`, `generate-agent-plugin.sh`, `validate-plugin.sh`, and `tests/agent-plugin.test.sh` | D2.1 to D2.5 | PASS: Bash 3.2 with no associative arrays (D2.1). `python3` stays confined to `plugin-manifest.sh`; the amendment widens its stated purpose to rendering (D2.2, D2.4). Flags are portable (D2.3). Paths come from `HW_PLUGIN` and `HW_PLUGIN_SOURCE` (D2.5). |
| Generator Gate | `generate-agent-plugin.sh` changes | D4.1 to D4.4 | PASS: a hand-edited manifest shows as drift (D4.1). Fixed key order and formatting make two builds byte-identical (D4.2). The refusal of a folder it did not produce is unchanged (D4.3). The plugin is regenerated in this change (D4.4). |
| Correspondence Gate | New generator inputs (`listing.json`, `assets/`) | D4.5 to D4.7 | PASS: D4.7's regeneration in `adapter-coverage.test.sh` covers the new inputs, since it rebuilds from the whole `framework/plugin/` folder; a task confirms it. |
| Validation Gate | New checks in `validate-plugin.sh`, the generator's listing check, and changed assertions in `agent-plugin.test.sh` | D3.4, D3.5 | PASS: each new check's verdict on the committed plugin and on each existing seeded case is recorded before it is wired in (D3.4). The shipped-set assertion is replaced, recording the superseded set (D3.5). |
| Skill Content Gate | No file under `skills/` changes | Delegated (D1.5) | N/A |

Verification rules: D3.1 is the baseline run before the first edit. D3.2 is the final run. D3.3:
`tests/agent-plugin.test.sh` gains cases. D3.6: each new case is observed failing before the code
that makes it pass. D3.7: unchanged checks keep their probes. D5.3: the amendment names every
changed element. D6.1: `framework/README.md`, `tests/README.md`, and the constitution change in
this change. D7.3: the report states suite results and requirement coverage separately.

### Skill content gates

N/A: Skill Content Gate not triggered.

### Post-design re-check

Re-evaluated after Phase 1. The contracts add no shipped path beyond `framework/README.md`, no
utility outside the declared toolchain, no new `python3` caller, and no skill edit. All gates
hold.

## Project Structure

### Documentation (this feature)

```text
specs/248-agent-manifests/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── manifests.md        # each manifest's fields, order, and sources; the listing file
│   └── checks.md           # generator listing errors, drift, validator findings
├── checklists/requirements.md
├── harness/smoke.log       # committed run log
└── tasks.md
```

### Source Code (repository root)

```text
framework/
├── plugin/
│   ├── plugin.json               # gains author and keywords; homepage changes
│   ├── listing.json              # new: codex, cursor, antigravity listing fields
│   └── assets/logo.svg           # new: placeholder logo
├── lib/plugin-manifest.sh        # format table, renderer, listing and manifest checks
├── generate-agent-plugin.sh      # renders the manifests, copies assets, checks the listing
├── validate-plugin.sh            # [AGENT] findings and the closed list
└── README.md                     # where each field lives
highway-agent-plugin/             # regenerated: five manifests and assets/ added
tests/
├── agent-plugin.test.sh          # shipped set and seeded defects
├── self-contained-skills.test.sh # root folder match ignores the www.highway.systems host name
└── README.md                     # describes the new cases
.specify/memory/constitution.md   # 3.7.0
harness-model-findings.md         # Runs lines for the smoke run
rollout-plan.md                   # Phase 6 complete, Status paragraph (gitignored)
```

**Structure Decision**: the existing layout is kept. The new sources sit in `framework/plugin/`
with the existing ones, and the format knowledge sits in the library both scripts already source.

## Complexity Tracking

No violations to justify.
