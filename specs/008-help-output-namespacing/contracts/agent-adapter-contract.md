# Contract: Agent Adapter Generation (Hyphen-Namespaced)

**Supersedes**: `specs/007-highway-skill-namespace/contracts/agent-adapter-contract.md`, for the
target-path column's separator only. Every other guarantee in that contract (transform behavior,
idempotency, drift detection, stale-artifact removal mechanism, failure handling) is carried
forward unchanged and re-stated here for a single authoritative reference.

This contract governs `.highway/tools/generate-agent-adapters.sh`: what it MUST produce for each
of the 3 in-scope agents, so that adding a 4th agent later means extending this contract and the
generator's declarative config, never editing files under `.highway/skills/`.

## Per-agent target and transform

| `agent_id` | Target path pattern | Transform | Guarantee |
|---|---|---|---|
| `github-copilot` | `.github/skills/highway-<id>/SKILL.md` | `identity-copy` | Byte-identical to `.highway/skills/<id>/SKILL.md`. |
| `claude-code` | `.claude/skills/highway-<id>/SKILL.md` | `identity-copy` | Byte-identical to `.highway/skills/<id>/SKILL.md`. |
| `cursor` | `.cursor/rules/highway-<id>.mdc` | `mdc-transform` | Deterministic re-encoding, see below. |

The `highway-` prefix (hyphen separator) is part of the target **path**, not of any file's
content. Research (research.md R1) found GitHub Copilot's Agent Skills spec requires a skill's
`name`/directory value to contain only lowercase letters, numbers, and hyphens, and to match its
parent directory exactly — a dot-separated directory (`highway.<id>`, specs/007's original form)
can never satisfy both rules at once. The hyphen form is spec-compliant on all three agents.

## `identity-copy` transform

Unchanged from specs/001/007: the generator copies `.highway/skills/<id>/SKILL.md` verbatim to
the target path. No field is renamed, reordered, added, or removed.

## `mdc-transform` transform (Cursor)

Unchanged from specs/001/007: `description` copied verbatim, `alwaysApply` always `false`,
`globs` omitted, body copied verbatim below the transformed frontmatter block. The namespace is
carried entirely by the target file name (`highway-<id>.mdc`).

## Stale prior-namespace artifact removal

Unchanged mechanism from specs/007, retargeted at the dot-separated paths that feature shipped:

- Before writing the hyphen-namespaced target for a given (skill, agent) pair, the generator MUST
  check whether an artifact exists at that pair's **dot-separated** path (e.g.
  `.github/skills/highway.<id>/SKILL.md`).
- If it exists and is tracked by `.highway/tools/.adapter-manifest` with a hash matching its
  current content, the generator MUST delete it and prune its manifest row.
- If it exists but is untracked, or its hash no longer matches the manifest, the generator MUST
  refuse (non-zero exit, explicit error naming the file) — identical to the existing
  hand-edit-drift refusal behavior for overwrites.
- If it does not exist (e.g. a brand-new skill authored after this feature ships, which never had
  a dot-separated artifact), this step is a no-op.
- The pre-namespace (specs/001-era, unprefixed) removal step specs/007 already added stays in
  place unchanged; a skill regenerated for the first time after this feature ships MUST have
  both its unprefixed and its dot-separated prior artifacts cleaned up, if either exists.

## Idempotency and drift detection

- Re-running `generate-agent-adapters.sh` with unchanged `.highway/skills/` content MUST produce
  zero-diff output across all three hyphen-namespaced target locations, and MUST NOT attempt
  either stale-removal step a second time (the rows and files no longer exist after the first
  run, so the no-op case applies).
- The generator MUST refuse (non-zero exit, explicit error naming the file) to overwrite a
  hyphen-namespaced target file that has been hand-edited outside the generator, exactly as
  before.
- Existing `speckit-*` folders under `.github/skills/` MUST NOT be read, written, or otherwise
  referenced by this generator.

## Failure handling

If any canonical skill fails `.highway/tools/validate-skill.sh` validation, the generator MUST
skip adapter generation entirely (no partial adapter set) and exit non-zero, naming the failing
skill — unchanged from specs/001/007.
