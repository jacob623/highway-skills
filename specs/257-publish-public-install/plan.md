# Implementation Plan: Publish and Public Install

**Branch**: `257-publish-public-install` | **Date**: 2026-11-20 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/257-publish-public-install/spec.md`

## Summary

Point every shipped plugin identity at `https://github.com/highway-systems/agent-plugin`, generate
marketplace catalogs into the plugin build, add a one-way publish script that pushes a fresh
`highway-agent-plugin/` tree as that repository's root (first publish may keep version `0.1.0`),
guard against the old install URL, update end-user install docs, and teach the harness to install
from a pinned public ref for verification smokes on Copilot, Cursor, Claude Code, and Codex.
Phase 9 (adapters) and Phase 11 (directory listings) stay out of scope.

## Technical Context

**Language/Version**: Bash 3.2.57 (Declared Toolchain) for generators, publish, and URL guard;
TypeScript / Node 24 under `harness/` for `--plugin-source` / `--plugin-ref`.

**Primary Dependencies**: existing `generate-agent-plugin.sh` / `plugin-manifest.sh`; `git` for
publish and for cloning a pinned public ref into the harness; no new npm packages unless research
forces one (none expected).

**Storage**: Files. Sources in `framework/plugin/`; output in `highway-agent-plugin/`; public
remote `https://github.com/highway-systems/agent-plugin.git`.

**Testing**: `tests/run-all.sh`; new bash cases for URL guard, marketplace catalogs, and publish
refusal paths (seeded / dry-run); `npm --prefix harness test` and `typecheck`; live
`--plugin-source public --plugin-ref <tag|sha> --smoke` per agent after a real publish.

**Target Platform**: macOS and Linux maintainer machines with git credentials for
`highway-systems`.

**Project Type**: Skill framework packaging + harness verification.

**Performance Goals**: Publish and URL guard complete in seconds for a ~plugin-sized tree; harness
clone of one ref is comparable to today's local install setup.

**Constraints**:

- No commit unless the user asks later.
- No skill behavior changes; README/install docs and packaging only for skills-adjacent paths.
- Secrets redacted; PAT never printed.
- `mv`, not `git mv`; MINOR constitution bump only if a declared generator or harness switch is
  added.
- `rollout-plan.md` stays gitignored.
- First publish may keep `0.1.0`; later releases must bump (clarification).
- Public-install smoke must pin tag or commit (clarification).
- Contributor docs may still mention adapters/distribution (clarification).

**Scale/Scope**: one repository URL change; four marketplace catalogs; one publish script; harness
switch + four public smokes; end-user doc updates.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Process gates (Development Constitution 3.10.0)

| Gate | Trigger | Rules | Verdict |
| --- | --- | --- | --- |
| Packaging Gate | Public plugin README / `framework/plugin/README.md` changes | D1.1, D1.2, D6.2 | PASS: shipped README names agent install commands and the public URL only; no `.specify/` or `specs/` paths. |
| Toolchain Gate | New bash publish/URL-guard scripts; harness CLI switches | D2.1–D2.5 | PASS: Bash 3.2 only in `framework/` and `tests/`; harness stays under `harness/` with existing Node toolchain. No new undeclared interpreter. |
| Generator Gate | `generate-agent-plugin.sh` gains marketplace catalog outputs | D4.1–D4.4 | PASS: catalogs are generated (hand edit = drift); fixed formatting; regenerate in this change. |
| Correspondence Gate | New generated marketplace files in the plugin | D4.5–D4.7 | PASS: D4.7 rebuild compares the full plugin including new catalogs. |
| Validation Gate | URL-guard test; catalog / publish refusal tests | D3.4, D3.5 | PASS: new checks recorded with seeded cases before wiring. |
| Skill Content Gate | No skill workflow change | D1.5 | N/A unless a skill file is touched (avoid). |

Verification: D3.1 baseline before edits; D3.2 final suite; D3.3 new cases; D3.6 observe fail then
pass; D6.1 update `framework/README.md` / harness README; D7.3 report suite vs requirements
separately.

### Post-design re-check

Re-evaluated after Phase 1. Contracts describe maintainer-facing scripts and harness switches only.
No unjustified complexity. Gates hold.

## Project Structure

### Documentation (this feature)

```text
specs/257-publish-public-install/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── publish.md
│   ├── marketplace-catalogs.md
│   └── harness-plugin-source.md
├── checklists/requirements.md
└── tasks.md
```

### Source Code (repository root)

```text
framework/
├── plugin/
│   ├── plugin.json              # repository URL → highway-systems/agent-plugin
│   ├── README.md                # end-user install sections
│   └── … listing.json, LICENSE, assets/
├── generate-agent-plugin.sh     # also writes marketplace catalogs
├── publish-agent-plugin.sh      # NEW: one-way publish + gates
└── lib/…                        # catalog render helpers if needed

highway-agent-plugin/            # regenerated: manifests + catalogs + README
  .cursor-plugin/marketplace.json
  .claude-plugin/marketplace.json
  .agents/plugins/marketplace.json
  .github/plugin/marketplace.json

tests/
├── agent-plugin.test.sh         # catalog drift / shipped set
└── publish-url.test.sh          # NEW: URL guard (+ publish dry-run seeds as needed)

harness/
├── src/cli.ts                   # --plugin-source, --plugin-ref
├── src/project.ts               # resolve public plugin into a local dir
└── README.md
```

**Structure Decision**: Extend the existing plugin generator and add one publish script plus harness
resolution of a pinned public clone. No new top-level package.

## Complexity Tracking

> None. No constitution violations requiring justification.
