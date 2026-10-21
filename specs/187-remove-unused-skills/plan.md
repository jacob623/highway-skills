# Implementation Plan: Remove Unused Skills

**Branch**: `187-remove-unused-skills` | **Date**: 2026-10-21 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/187-remove-unused-skills/spec.md`

## Summary

Remove `highway-clarify`, `highway-inquiry`, `highway-relationships`, and `highway-new` from the skill sources, published copies, catalog, and distribution manifest. Delete the clarification record, clarification catalog, and requirements-inquiry template, plus tests that exist only for those skills. Keep `.highway/library/templates/output/request-record.md` and `request-catalog.md` because `highway-request` still cites them. Do not rewrite the twelve skills that stay, and do not edit either constitution or the experience standard.

## Technical Context

**Language/Version**: Markdown skill sources and Bash 3.2.57-compatible repository tests

**Primary Dependencies**: `.highway/tools/generate-catalog.sh`, `.highway/tools/generate-library-catalog.sh`, `.highway/tools/generate-agent-adapters.sh`, `.highway/tools/.distribution-manifest`

**Storage**: Git-native Markdown under `.highway/skills/` and `.highway/library/templates/`

**Testing**: `.highway/tools/tests/run-all.sh` after the obsolete checks are removed and the mixed checks are edited

**Target Platform**: Distributed Highway skill tree on macOS and GNU/Linux

**Project Type**: Git-native governance skill suite

**Performance Goals**: No runtime latency target. This is a repository removal

**Constraints**: Do not delete the shared request templates. Do not rewrite Discovery, the request skill, or the other skills that stay. Do not edit the Highway constitution, the Spec Kit constitution, or the experience standard. Bash 3.2.57 only. No new runtime dependency. No shipped path may reference `.specify/` or `specs/`

**Scale/Scope**: Four skill directories, four published copies in each of the four declared agent trees, three owned templates, and the tests that only those skills require

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Spec Kit process gates, from `.specify/memory/constitution.md`:

- Packaging Gate: PASS. Removed skills must disappear from the shipped tree. D1.1 and D1.2 still forbid a shipped reference to `.specify/` or `specs/`. D6.2 requires a documentation path that named a removed file to be updated in the same change.
- Toolchain Gate: PASS. No new command is introduced. D2.1 through D2.4 stay satisfied.
- Validation Gate: PASS. D3.1 requires a passing `.highway/tools/tests/run-all.sh` before the first edit. D3.5 allows a check to be removed when the removal names the superseded skill. D3.2 requires the remaining suite to pass after the last edit.
- Correspondence Gate: PASS. D4.6 forbids a catalog entry, adapter, adapter-manifest row, or distribution row for a skill with no source directory. `generate-agent-adapters.sh` does not delete an adapter, so the published copies and distribution rows are removed directly, then the declared generators are run so the catalogs match the remaining sources. D4.1 still forbids hand-editing a generated adapter that remains.
- Skill Content Gate: PASS. No remaining skill is rewritten. D1.5 does not require a new Highway Skills Constitution rule. D8.1 applies only if a shared template a remaining skill cites is changed. The request templates are not changed.

Highway Skills Constitution rule text is not restated here.

No complexity exception is required.

### Post-design re-check

PASS. Phase 1 deletes sources and owned templates. It does not add a dependency, a shipped development path, or a constitution edit. Direct deletion of generated adapters is the way to satisfy D4.6 because the adapter generator does not prune.

## Project Structure

### Documentation (this feature)

```text
specs/187-remove-unused-skills/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
└── tasks.md
```

### Source Code (repository root)

```text
.highway/skills/highway-clarify/          # delete
.highway/skills/highway-inquiry/          # delete
.highway/skills/highway-relationships/    # delete
.highway/skills/highway-new/              # delete
.highway/library/templates/output/clarification-record.md    # delete
.highway/library/templates/output/clarification-catalog.md   # delete
.highway/library/templates/requirements-inquiry.md           # delete
.highway/library/templates/output/request-record.md          # keep
.highway/library/templates/output/request-catalog.md         # keep
.highway/tools/.distribution-manifest     # drop the four skills
.github/skills/ .claude/skills/ .cursor/skills/ .agents/skills/  # drop published copies
.highway/tools/tests/                     # drop or edit checks that require the four skills
```

**Structure Decision**: One git-native repository. Sources are removed first. Published copies are then deleted because the adapter generator will not remove them. Catalogs are regenerated from the skills and library files that remain.

## Complexity Tracking

> No constitution violation requires a justification table. Deleting a generated adapter is required so the shipped tree does not name a skill that no longer has a source.
