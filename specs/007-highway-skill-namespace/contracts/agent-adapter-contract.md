# Contract: Agent Adapter Generation (Namespaced)

**Supersedes**: `specs/001-multi-agent-skill-suite/contracts/agent-adapter-contract.md`, for the
target-path column only. Every other guarantee in that contract (transform behavior, idempotency,
drift detection, failure handling) is carried forward unchanged and re-stated here for a single
authoritative reference.

This contract governs `.highway/tools/generate-agent-adapters.sh`: what it MUST produce for each
of the 3 in-scope agents, so that adding a 4th agent later means extending this contract and the
generator's declarative config, never editing files under `.highway/skills/`.

## Per-agent target and transform

| `agent_id` | Target path pattern | Transform | Guarantee |
|---|---|---|---|
| `github-copilot` | `.github/skills/highway.<id>/SKILL.md` | `identity-copy` | Byte-identical to `.highway/skills/<id>/SKILL.md`. |
| `claude-code` | `.claude/skills/highway.<id>/SKILL.md` | `identity-copy` | Byte-identical to `.highway/skills/<id>/SKILL.md`. |
| `cursor` | `.cursor/rules/highway.<id>.mdc` | `mdc-transform` | Deterministic re-encoding, see below. |

The `highway.` prefix is part of the target **path**, not of any file's content. It is what makes
the skill discoverable to a coding agent as `highway.<id>` (research.md R1): every in-scope agent
derives the identifier it lists from the generated artifact's directory/file name, not from a
`name:` frontmatter field.

## `identity-copy` transform

Unchanged from specs/001: the generator copies `.highway/skills/<id>/SKILL.md` verbatim to the
target path. No field is renamed, reordered, added, or removed — including the frontmatter
`name:` field, which keeps its original, unprefixed, possibly-mixed-case value (e.g. `Help`),
since it is not the mechanism read by the agent (research.md R1).

## `mdc-transform` transform (Cursor)

Unchanged from specs/001: `description` copied verbatim, `alwaysApply` always `false`, `globs`
omitted, body copied verbatim below the transformed frontmatter block. The namespace is carried
entirely by the target file name (`highway.<id>.mdc`), since Cursor's `.mdc` frontmatter has no
`name` field to prefix.

## Stale non-namespaced artifact removal (new in this feature)

- Before writing the namespaced target for a given (skill, agent) pair, the generator MUST check
  whether an artifact exists at that pair's **pre-namespace** path (e.g.
  `.github/skills/<id>/SKILL.md`).
- If it exists and is tracked by `.highway/tools/.adapter-manifest` with a hash matching its
  current content, the generator MUST delete it and prune its manifest row.
- If it exists but is untracked, or its hash no longer matches the manifest, the generator MUST
  refuse (non-zero exit, explicit error naming the file) — identical to the existing
  hand-edit-drift refusal behavior for overwrites.
- If it does not exist (e.g. a brand-new skill authored after this feature ships), this step is a
  no-op.

## Idempotency and drift detection

- Re-running `generate-agent-adapters.sh` with unchanged `.highway/skills/` content MUST produce
  zero-diff output across all three namespaced target locations, and MUST NOT attempt the stale
  non-namespaced removal step a second time (the row and file no longer exist after the first
  run, so the no-op case above applies).
- The generator MUST refuse (non-zero exit, explicit error naming the file) to overwrite a
  namespaced target file that has been hand-edited outside the generator, exactly as before.
- Existing `speckit-*` folders under `.github/skills/` MUST NOT be read, written, or otherwise
  referenced by this generator (FR-009).

## Failure handling

If any canonical skill fails `.highway/tools/validate-skill.sh` validation, the generator MUST
skip adapter generation entirely (no partial adapter set) and exit non-zero, naming the failing
skill — unchanged from specs/001.
