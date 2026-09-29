# Implementation Plan: Deliver Highway Skills to Cursor as Skills, Not Rules

**Branch**: `097-cursor-skills-adapter` | **Date**: 2026-09-29 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/097-cursor-skills-adapter/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Change the Cursor row of the adapter generator from a rule conversion
(`.cursor/rules/<id>.mdc`, `mdc-transform`) to a plain copy
(`.cursor/skills/<id>/SKILL.md`, `identity-copy`), the same delivery Claude Code and Copilot already
receive. Retire the 12 tracked rule files and one untracked fixture leftover through a one-time,
hash-checked migration that skips hand-edited files and is deleted afterward. Move the distribution
manifest, the adapter-coverage and generator tests, the sweep globs, and four live documents to the
skill location. No skill source, version, or catalog entry changes, and the generator gains no
file-removal behavior.

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: Bash 3.2.57-compatible scripts; Markdown documents

**Primary Dependencies**: The existing declared toolchain only (`awk`, `cp`, `grep`, `mkdir`, `mktemp`, `mv`, `rm`, `sed`, `sha256sum`/`shasum`, `sort`, `tr`); no new dependency

**Storage**: Tracked files: the adapter manifest (tab-delimited: path, skill id, version, sha256), the distribution manifest (tab-delimited: classification, source, destination), and the generated adapter trees

**Testing**: Existing Bash test harness under `.highway/tools/tests/`; the full suite via `run-all.sh` (up to 240 seconds); a seeded migration run against a temporary copy of the tree, recorded as evidence

**Target Platform**: macOS and GNU-like shells; consumed by Cursor, Claude Code, and GitHub Copilot

**Project Type**: Repository-distributed agent skill suite with shell tooling (no application source tree)

**Performance Goals**: None beyond the existing suite budget. The change adds no per-run work: one row is repointed, not added.

**Constraints**: Cursor deliverable byte-identical to the Claude Code deliverable; the three `AGENT_*` arrays in the generator stay single-line (the extensibility test rewrites them with `sed`); the generator never removes a file; no `specs/` or `.specify/` string enters a distributed file; historical specs and the profile-092 evidence fixtures are not rewritten

**Scale/Scope**: 12 source skills; 12 Cursor deliverables to add; 13 rule files to remove; 12 distribution rows to replace; 4 documents; 1 generator; 6 tests and helpers; 1 temporary migration script

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

This feature changes the generator, manifests, tests and documents. It changes no skill or library
file, so the Highway Skills Constitution's skill-content rules (`P` namespace) do not apply. D1.5
is satisfied by this section naming rule ids from the development constitution.

### Process gates

| Gate | Verdict | Evidence / scope |
|---|---|---|
| Packaging Gate (D1.1, D1.2, D1.6, D6.2) | PASS | The distributed path set stays declared once, in `.distribution-manifest`. The new `.cursor/skills/highway-*` rows mirror the `.claude/skills` rows, so shipped content is byte-identical to content already shipping. The FR-016 note is written without `specs/` or `.specify/` strings. |
| Toolchain Gate (D2.1-D2.4) | PASS | The migration script and generator edit use only the declared toolchain and no Bash 4 constructs. Version control is not invoked. |
| Verification Gate (D3.1-D3.6) | PASS | Baseline suite run before the first edit; tests amended in the same change; each replaced assertion carries a recorded reason (D3.5); the new Cursor assertions are observed failing before the generator change (D3.6). |
| Auto-check Gate (D3.7) | PASS | The `generated-artifact` probes in `adapter-coverage.test.sh` seed defects through the shared path helpers, so repointing those helpers keeps every class able to fail. |
| Generator Gate (D4.1-D4.4) | PASS | The generator keeps its validation-first, no-partial-set, and refuse-to-overwrite behavior. Output is deterministic. Adapters are regenerated after the change. |
| Correspondence Gate (D4.5-D4.7) | PASS | Each source skill gets a Cursor adapter, a manifest row and a distribution row at the new path. No row names a `.cursor/rules/` path afterward. Re-running every declared generator leaves no diff. |
| Documentation Gate (D6.1, D6.2) | PASS | `README.md`, `.highway/DISTRIBUTION.md` and `.highway/tools/README.md` are edited in the same change. The `_authoring-standard.md` mentions of `cursor` are agent ids, not paths, and stay. |
| Supersession Gate (D5.3) | PASS | [contracts/cursor-adapter-contract.md](./contracts/cursor-adapter-contract.md) lists every element it supersedes from the feature 008 adapter contract. |

Process result: PASS. No unresolved gate violations or complexity exceptions.

**Post-design re-check**: PASS. Phase 1 introduced no new dependency, no new distributed path
class, and no constitution amendment. FR-014 is met without one: the constitution names the
declared agent tree `cursor` by id and never states its adapter path, so nothing in it is stale.

## Project Structure

### Documentation (this feature)

```text
specs/097-cursor-skills-adapter/
├── plan.md              # This file (/speckit-plan command output)
├── research.md          # Phase 0 output (/speckit-plan command)
├── data-model.md        # Phase 1 output (/speckit-plan command)
├── quickstart.md        # Phase 1 output (/speckit-plan command)
├── contracts/
│   ├── cursor-adapter-contract.md   # Phase 1 output
│   └── migration-contract.md        # Phase 1 output
├── checklists/
│   └── requirements.md
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)
<!--
  ACTION REQUIRED: Replace the placeholder tree below with the concrete layout
  for this feature. Delete unused options and expand the chosen structure with
  real paths (e.g., apps/admin, packages/something). The delivered plan must
  not include Option labels.
-->

```text
.highway/
├── tools/
│   ├── generate-agent-adapters.sh     # Cursor row repointed; transform_mdc and mdc-transform case removed
│   ├── .adapter-manifest              # 12 .cursor/rules rows replaced by 12 .cursor/skills rows
│   ├── .distribution-manifest         # 12 .cursor/rules includes replaced by 12 .cursor/skills includes
│   ├── README.md                      # Cursor path; speckit non-interference sentence widened
│   └── tests/
│       ├── generate-agent-adapters.test.sh   # Cursor assertions rewritten for the skill form
│       ├── adapter-coverage.test.sh          # adapter_paths, adapter_files, orphan path case
│       ├── new-agent-extensibility.test.sh   # cleanup path
│       ├── highway-new.test.sh               # expected distribution-manifest path
│       ├── feature-038-helpers.sh            # cursor source-path key
│       └── run-all.sh                        # residue sweep glob
└── DISTRIBUTION.md                    # Cursor path; superseded-rule note for existing users
.cursor/
├── skills/highway-*/SKILL.md          # 12 generated Cursor deliverables (new)
├── skills/speckit-*/                  # Spec Kit's; never touched
└── rules/                             # Highway .mdc files removed
README.md                              # Cursor path in the adapter description
specs/097-cursor-skills-adapter/
└── migrate-cursor-rules.sh            # Temporary; deleted once the migration completes (FR-017)
```

**Structure Decision**: Reuse the existing generator, manifests and Bash tests. The Cursor change is
a one-row repoint plus a deletion of the now-unused transform, so the generator's extension
mechanism (the three single-line arrays) is preserved. The migration script lives beside the spec,
outside the distributed tree, and is removed as the last task. No application source tree, external
interface, or runtime component is introduced.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | Existing repository structure is sufficient. |
