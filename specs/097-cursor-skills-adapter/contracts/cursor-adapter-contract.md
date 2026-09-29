# Contract: Cursor Adapter

Defines what the adapter generator delivers to Cursor after feature 097. It supersedes the Cursor
part of the adapter contract recorded in `specs/008-help-output-namespacing/contracts/agent-adapter-contract.md`.
Rule text is cited by id, not restated (D1.3, D1.4).

## Deliverable

For every directory `<id>` under `.highway/skills/` whose `SKILL.md` validates:

- The generator writes `.cursor/skills/<id>/SKILL.md`.
- The file is a byte-for-byte copy of `.highway/skills/<id>/SKILL.md`.
- The file is therefore byte-identical to `.claude/skills/<id>/SKILL.md` and
  `.github/skills/<id>/SKILL.md`.
- The generator writes nothing under `.cursor/rules/`.

## Generator behavior

| Behavior | Contract |
|---|---|
| Validation first | Every skill is validated before any adapter is written; one failure aborts with no partial set (unchanged) |
| Overwrite refusal | A target that exists and either has no manifest row or differs from its recorded hash is not overwritten; the run exits non-zero and names the file (D4.3, unchanged) |
| Determinism | Two runs on unchanged inputs produce identical files (D4.2) |
| Non-interference | The generator never creates, modifies or removes `.cursor/skills/speckit-*` or `.github/skills/speckit-*` |
| No removal | The generator removes no file, ever (FR-017) |
| Extension seam | The three `AGENT_*` arrays remain single-line; `identity-copy` remains a valid transform |

### Collision case

If `.cursor/skills/<id>/SKILL.md` exists for a Highway skill `<id>` and is not tracked, the
generator exits non-zero, names the file, writes no adapter for any agent (validation and drift
checks precede all writes), and leaves the file untouched.

## Manifest contracts

- **Adapter manifest**: one row for `.cursor/skills/<id>/SKILL.md` per source skill (fields: path,
  id, version, sha256), and no row whose path begins `.cursor/rules/` (D4.5, D4.6).
- **Distribution manifest**: one `include` row for `.cursor/skills/<id>` per source skill; the
  `exclude .cursor` row remains; no row names `.cursor/rules/` (D1.6).

## Supersession (D5.3)

Elements this contract changes from the feature 008 adapter contract, for Cursor only. Everything
not listed carries forward unchanged, including the GitHub Copilot and Claude Code deliverables.

| Element | Before | After |
|---|---|---|
| Target path | `.cursor/rules/<id>.mdc` | `.cursor/skills/<id>/SKILL.md` |
| Transform | `mdc-transform` | `identity-copy` |
| Frontmatter delivered | `description` line only, plus `alwaysApply: false` | Entire source frontmatter |
| `globs` key | Omitted | Not applicable (no rule frontmatter is emitted) |
| Body | Re-emitted below the rule frontmatter | Copied unchanged |
| Relationship to other agents | Different kind of artifact | Byte-identical artifact |
| Distribution rows | Per-file `.cursor/rules/<id>.mdc` includes | Per-directory `.cursor/skills/<id>` includes |

## Verification (observables)

| Requirement | Observable |
|---|---|
| FR-001, FR-002 | For a temporary skill, `diff` of the Cursor file against the source and against the Claude Code file reports no difference |
| FR-003 | After generation, no `.cursor/rules/<id>.mdc` exists for a source skill; the generator source contains neither `transform_mdc` nor `mdc-transform` |
| FR-004 | A hand-edited adapter is refused and preserved (existing test, unchanged) |
| FR-005 | The sha256 of a `speckit-*` sentinel under `.cursor/skills/` and `.github/skills/` is equal before and after a run |
| FR-008 | Two consecutive runs leave no diff |
| FR-011 | `adapter-coverage.test.sh` reports a missing or orphaned Cursor adapter, manifest row or distribution row (its seeded probes cover each) |
