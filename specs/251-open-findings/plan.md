# Implementation Plan: Open Findings

**Branch**: `251-open-findings` | **Date**: 2026-11-17 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/251-open-findings/spec.md`

## Summary

Close the four open findings in `harness-model-findings.md`:

| Id | Change |
| --- | --- |
| F18 | highway-discovery `references/options.md`: name the empty Example Realization Matrix header-row case; MINOR skill bump; regenerate |
| F23 | `showsFailures` strips backticks; unit test; optional README note |
| F28 | `contains-any` case-insensitive; unit test; README note |
| F20 | Shorter attempt work/home/project paths (`hh-`, `h/`, `p/`, short labels); compare collapsed-path denials on confirmation |

Then: full bash suite + harness unit tests; confirmation Copilot smoke×1, Cursor smoke×2, Cursor targeted (discovery-smoke, codify-configure, objectives-smoke, request-smoke, setup-smoke); update findings (and optionally rollout Status).

## Technical Context

**Language/Version**: TypeScript on Node 24 for `harness/`; Markdown skill sources under `skills/`; Bash 3.2 for the suite.

**Primary Dependencies**: Existing Harness Toolchain (`@github/copilot-sdk`, `@cursor/sdk`). No new packages.

**Storage**: Files. Attempt state under shortened throwaway work roots. Committed logs under `specs/251-open-findings/harness/`.

**Testing**: `npm --prefix harness test`, `npm --prefix harness run typecheck`, `bash tests/run-all.sh`. Live confirmation per FR-010.

**Target Platform**: macOS and Linux; Copilot + Cursor local.

**Project Type**: Skill framework with bash suite and behavioral harness (CLI).

**Performance Goals**: Prefer confirmation logs under ~100 KB; Cursor may slightly exceed as in prior specs.

**Constraints**:

- No commit unless asked; secrets redacted; `mv` not `git mv`; MINOR bumps only; no backward compatibility.
- `rollout-plan.md` stays gitignored / distribution-excluded.
- F18 skill text only (named file); F23/F28/F20 harness (or layout) only; no scenario/fixture/template changes.
- F18 stays open if live smokes still fail the header check after the skill edit.

**Scale/Scope**: One skill reference + version; `checks.ts` + tests + README; `runner.ts` / `project.ts` path layout (+ judge prefixes if touched); four committed logs; findings update.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Process gates

| Gate | Trigger | Verdict |
| --- | --- | --- |
| Packaging (D1.1, D1.2, D6.2) | F18 skill text | PASS: no development-path names in skill; regenerate agent trees/plugin |
| Toolchain (D2.1–D2.5) | No Declared Toolchain script change | N/A |
| Generator (D4.1–D4.4) | No generator logic change | N/A (regenerate only) |
| Correspondence (D4.5–D4.7) | `skills/highway-discovery` changes | PASS: regenerate; second run no-op |
| Validation (D3.4, D3.5) | Harness assertion behavior | PASS: `shows` / `contains-any` strengthen matching; `contains` unchanged; new unit tests fail first (D3.6) |
| Skill Content | F18 | PASS: write-guidance clarification only; P7.2 MINOR bump; no Input/Verification removal |

Also: D3.1/D3.2 suite around edits; D3.8 live confirmation; D6.1 README + findings; D8.1 validate changed skill.

### Post-design re-check

Phase 1 contracts stay under this feature folder. Shorter paths are layout-only and keep storage/permission invariants. All gates hold. No constitution text change expected.

## Project Structure

### Documentation (this feature)

```text
specs/251-open-findings/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── harness-checks.md
│   ├── path-layout.md
│   └── live-runs.md
├── checklists/requirements.md
├── harness/                 # committed confirmation logs
└── tasks.md                 # /speckit-tasks
```

### Source Code (repository root)

```text
skills/highway-discovery/
├── SKILL.md                 # metadata.version MINOR
└── references/options.md    # F18 bullet

harness/
├── README.md                # contains-any case; shows backticks
├── src/
│   ├── checks.ts            # F23, F28
│   ├── runner.ts            # F20 workRoot + home labels
│   └── project.ts           # F20 projects folder + labels
└── test/
    └── checks.test.ts       # F23, F28 (path tests if layout asserted)

# regenerated, not hand-edited:
.github/skills/highway-discovery/
.cursor/skills/highway-discovery/
.claude/skills/highway-discovery/
.agents/skills/highway-discovery/
highway-agent-plugin/skills/highway-discovery/

harness-model-findings.md
rollout-plan.md              # optional Status note
```

**Structure Decision**: Same multi-finding pattern as specs 243/244 — skill + harness checks + layout, then live confirmation and findings.

## Complexity Tracking

> No constitution violations requiring justification.
