# Implementation Plan: Plugin Bump on Change

**Branch**: `259-plugin-bump-on-change` | **Date**: 2026-11-21 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/259-plugin-bump-on-change/spec.md`

## Summary

Enforce the covered-input finish order: full suite excluding a fixed closed list of plugin
generation checks → green → bump `framework/plugin/plugin.json` version → regenerate
`highway-agent-plugin/` → run that closed list. Add `tests/plugin-version-bump.test.sh`, suite
exclude/only support in `tests/run-all.sh`, document the order in `framework/README.md`, and amend
`.specify/memory/constitution.md` (not the Highway Skills Constitution). Publish remains out of
scope.

## Technical Context

**Language/Version**: Bash 3.2.57 (Declared Toolchain); Python 3 for JSON/semver compare (already
used by plugin tooling).

**Primary Dependencies**: `framework/generate-agent-plugin.sh`, `framework/plugin/plugin.json`,
`tests/agent-plugin.test.sh` (drift via `--check`), `tests/run-all.sh`.

**Storage**: Git working tree vs `main` merge-base; no new persisted store.

**Testing**: New `tests/plugin-version-bump.test.sh`; wire into `tests/run-all.sh` with exclude/only
for the closed list; keep `agent-plugin.test.sh` as the listed package-currency member.

**Target Platform**: Maintainer local / CI bash suite on this monorepo.

**Project Type**: Repository packaging / suite hygiene (not a new skill).

**Performance Goals**: Guard completes in seconds (git diff + two JSON reads).

**Constraints**:

- Working tree + index vs merge-base with `main`; fail closed if baseline missing.
- Strict major.minor.patch semver greater-than.
- Closed exclude list: `plugin-version-bump.test.sh` + `agent-plugin.test.sh` only (no open set).
- No publish; no new harness mandate; no Highway Skills Constitution or Spec Kit upstream skills.

**Scale/Scope**: 1 new test, run-all flags, README + Spec Kit constitution amendment, no skill
runtime change.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Process gates (Development Constitution)

| Gate | Trigger | Verdict |
| --- | --- | --- |
| Skill Content Gate | none (no skill text) | PASS: N/A |
| Validation Gate | new bash test | PASS: seeded fail/pass probes in version-bump test |
| Toolchain Gate | bash + existing python3 | PASS: no new interpreter |
| Packaging Gate | docs + suite; no skill content change required by this feature itself | PASS: no mandatory plugin regen for this feature’s own exit unless implement edits covered inputs |
| Correspondence Gate | D4.7 / new version currency | PASS: amend Spec Kit constitution; suite enforces |

This feature amends `.specify/memory/constitution.md` only (FR-009).

### Post-design re-check

Gates hold. Contracts are suite/docs contracts, not new runtimes.

## Project Structure

### Documentation (this feature)

```text
specs/259-plugin-bump-on-change/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── finish-order.md
│   ├── version-bump-guard.md
│   └── suite-plugin-gen-list.md
├── checklists/requirements.md
└── tasks.md
```

### Source Code (repository root)

```text
framework/
├── README.md                          # finish order + exclude/only
└── plugin/plugin.json                 # version source (bumped by features, not by 259 exit)

tests/
├── run-all.sh                         # --exclude-plugin-gen / --plugin-gen-only (or env)
├── plugin-version-bump.test.sh        # NEW
└── agent-plugin.test.sh               # listed package-currency check (existing --check)

.specify/memory/constitution.md        # finish-order / version currency obligation
```

**Structure Decision**: Extend existing suite and docs; no new packages.

## Complexity Tracking

> None — no constitution gate violations.
