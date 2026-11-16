# Contract: Cursor activation mapping

## Surface

`harness/src/drivers/cursor.ts` must:

1. **`skillIdFromCursorTool(name, args)`** (exported for tests): return a Highway skill id when the
   tool names one, else `undefined`. Must extract from a path containing `/skills/<id>/` (id is the
   directory under `skills/`). Must **not** return `skills` solely because the path contains
   `…/highway/skills/`.
2. **`normalizeCursorPluginPath(path, readRoot)`** (exported for tests): if `path` contains
   `.cursor/plugins/local/highway/`, return `join(readRoot, suffixAfterHighway)`; otherwise return
   `path` unchanged.
3. **`toolCallToAccessRequest`**: map `glob` / `grep` / `ls` to a `read` request using the best
   path argument (or project-relative placeholder the policy can approve inside the project), not
   bare `other` that becomes `denied: glob glob`.
4. **`noteTool` / stream handling**: normalize paths, run shared `permissionPolicy`, record
   experience via `isExperienceSkillRead` on approved reads, and record extracted skill ids into
   `skillsInvoked` / `skillsBeforeOutput` before first output.
5. **`outputSeen`**: set only after the turn’s person-visible `agent` log line, not on streamed
   assistant tokens (Cursor often emits text tokens before `tool_call` in the same turn).

## Invariants

- Shared `experienceInvariant` and `installPlugin` checks are unchanged.
- Copilot driver behavior is unchanged.
- No skill, template, fixture, or scenario file changes.

## Unit coverage (minimum)

- Path `…/highway/skills/highway-experience/SKILL.md` → skill id `highway-experience`, not `skills`.
- Normalized workspace-rooted plugin path under the install read root is approved for policy.
- Output before any experience activation still fails experience-order.
- Install success with 16 skills unchanged.
