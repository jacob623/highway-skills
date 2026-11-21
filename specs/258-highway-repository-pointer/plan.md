# Implementation Plan: Highway Repository Pointer

**Branch**: `258-highway-repository-pointer` | **Date**: 2026-11-21 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/258-highway-repository-pointer/spec.md`

## Summary

Extend the storage contract and `highway-experience` so every skill resolves an **effective Highway
knowledge root** (local pointer → cwd knowledge root → URL-only stop → dual gate), owns the
setup-or-pointer gate and pointer persistence in experience alone, strips duplicated setup-only
stops from owning skills, and keeps `.highway/repository*` knowledge-only for Phase 16. Local
file tools only; no Remote/Chat/MCP.

## Technical Context

**Language/Version**: Bash 3.2.57 (Declared Toolchain) for suite tests; skill/Markdown content for
runtime behavior; no new harness TypeScript required for MVP (optional fixture note in research).

**Primary Dependencies**: existing `skills/highway-experience/`, storage-contract tests,
`tests/catalog-seeding.test.sh`, `tests/experience-activation.test.sh`, agent-plugin generator.

**Storage**: Files in the person's open project and optional knowledge checkout; pointer files
`hw-repository.md` and `hw-repository.local.md`.

**Testing**: `tests/run-all.sh`; extend `storage-contract.test.sh` and `catalog-seeding.test.sh`;
add `tests/repository-pointer.test.sh` (static contract); regenerate plugin via
`generate-agent-plugin.sh`.

**Target Platform**: Coding agents loading Highway skills (Local mode).

**Project Type**: Skill framework / storage-contract extension.

**Performance Goals**: Resolution is a handful of file existence reads; negligible.

**Constraints**:

- No `git` in skill procedures (P2.6); `.gitignore` edits are file writes, not git commands.
- Absolute paths forbidden as storage-operation arguments; local pointer `path:` may be absolute
  as configuration only (document exception in storage contract).
- No new skill; no MCP; no Remote/Chat column fill beyond URL-only Local guidance.
- No backward compatibility for old Oops-only gate copy.
- `rollout-plan.md` stays gitignored; do not require committing it for this feature.

**Scale/Scope**: 1 storage-contract MINOR, 1 experience skill + gate asset, ~9 owning skills strip
gates, 2–3 test files, plugin regenerate.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Process gates (Development Constitution)

| Gate | Trigger | Verdict |
| --- | --- | --- |
| Skill Content Gate | experience + owning skills + storage contract | PASS: changes are skill/procedure and contract prose; Experience Standard still governs user-visible gate copy |
| Validation Gate | new/updated bash tests | PASS: seeded fail probes before wiring where required |
| Toolchain Gate | bash tests only | PASS: no new interpreter |
| Packaging Gate | plugin regen after skill edits | PASS: regenerate `highway-agent-plugin/` |
| Correspondence Gate | plugin rebuild | PASS: D4.7 after generate |

P2.6: documenting absolute `path:` in the local pointer file is configuration that sets the root,
not a storage-operation path argument — state that explicitly so validators/skills stay clean.

### Post-design re-check

Gates hold. Contracts are markdown procedure/schema contracts, not new runtimes.

## Project Structure

### Documentation (this feature)

```text
specs/258-highway-repository-pointer/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── storage-effective-root.md
│   ├── experience-gate.md
│   └── pointer-files.md
├── checklists/requirements.md
└── tasks.md
```

### Source Code (repository root)

```text
skills/highway-experience/
├── SKILL.md
├── assets/repository-gate.md          # NEW: shared dual-gate / URL-only / bind copy
└── references/storage-contract.md     # effective root + pointers

skills/highway-{request,discovery,adr,architecture,implementation,
  onboarding,codify,codify-config,assessment}/SKILL.md   # strip Oops gate

tests/
├── storage-contract.test.sh           # extend
├── catalog-seeding.test.sh            # stop requiring Oops block
├── repository-pointer.test.sh         # NEW
└── experience-activation.test.sh      # expect new asset if listed

highway-agent-plugin/                  # regenerated
```

**Structure Decision**: Extend existing experience + storage contract + suite tests; no new
packages.

## Complexity Tracking

> None. No constitution violations requiring justification.
