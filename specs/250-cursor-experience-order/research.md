# Research: Cursor Experience Order (F29)

Every FR-001 / FR-002 unknown is answered from spec 249 live logs, the Cursor driver, and
`@cursor/sdk` 1.4.0 message types. Technical Context unknowns are resolved. Skills do not need to
change.

## R1. How local Cursor reports skill use (FR-001)

- **Decision**: Cursor local does **not** emit a Copilot-style `skill.invoked` stream event.
  Published `SDKMessage` types are `system` | `assistant` | `user` | `tool_call` | `thinking` |
  `status` | `request` | `task` | `summary` | `usage`. Skill use appears as:
  1. **Primary**: `tool_call` with name `read` (and similar) whose `args` path points under the
     installed plugin at `…/skills/<skill-id>/…`, especially `…/skills/<skill-id>/SKILL.md`.
  2. **Proven load (not per-turn activation)**: host/SDK log lines
     `CursorPluginsAgentSkillsService load completed … skillCount: 16` on every attempt in the
     spec 249 smokes — the plugin’s 16 skills are loaded before the conversation.
  3. **Not usable alone**: `system`/`init` `tools?: string[]` lists host tools, not Highway skill
     ids. The driver’s old regex on `name + JSON.stringify(args)` is **wrong**: paths like
     `…/plugins/local/highway/skills/…` match `highway/` and capture the next segment **`skills`**,
     which produced the ubiquitous `skill: skills` log lines and never `highway-experience`.
- **Rationale**: Smoke-1/2 and codify show install of 16 skills, skillCount 16, almost universal
  `experience-order` with `actual no skill` or `actual skills, skills`, and (when reads appear)
  denied reads of `…/highway-experience/…` and other skill files. Copilot’s activation path
  (`skill.invoked` + approved SKILL.md read) is the shared check this driver must feed.
- **Alternatives considered**: Treat ambient skill load (skillCount 16) as experience activation
  (rejected — would pass experience-order without highway-experience). Wait for a future SDK
  skill event (rejected — F29 needs a harness fix now). Stop for person (rejected — signal is
  workable via reads + corrected mapping).

## R2. Install path makes skills available (FR-002)

- **Decision**: The copy into `<agentHome>/.cursor/plugins/local/highway/` with
  `settingSources: ["plugins"]` **does** make skills available. Evidence: every attempt’s
  `skillCount: 16` load line; agents attempt reads under that plugin tree; experience-smoke passed
  once on smoke-2 when an approved `highway-experience/SKILL.md` read was counted (approved
  permission lines are omitted from non-verbose logs). No change to the install copy layout is
  required for load proof.
- **Rationale**: F29’s “install reported 16 / activation never recorded” split is real: load is
  fine; harness mapping and path policy accounting are not.
- **Alternatives considered**: Re-install under the project `.cursor/plugins` (unnecessary if path
  normalization maps plugin-suffix reads onto the install read root). Symlink (Cursor skips
  outside symlinks — already rejected in 249).

## R3. Why experience-order stays `actual no skill`

- **Decision**: Three harness defects stack:
  1. **False skill name**: regex captures `skills` from `/highway/skills/` (R1).
  2. **Activation not mapped from reads**: skill ids must be taken from
     `/skills/<skill-id>/` path segments; `isExperienceSkillRead` already handles
     `…/highway-experience/SKILL.md` when the read is **approved**.
  3. **Plugin reads often marked rejected**: many `tool_call` read paths are
     `<work>/.cursor/plugins/local/highway/…` (workspace-rooted) or
     `<tmp>/.cursor/plugins/…` with a collapsed temp segment (F20-style). Shared
     `permissionPolicy` then rejects them against `readRoots =
     [agentHome/.cursor/plugins/local/highway]`, so `skillsBeforeOutput` never gains
     `highway-experience` even when Cursor’s hooks may still serve the file from HOME.
- **Rationale**: Direct from smoke-2 denied-read lines and the `noteTool` / `runlog` code paths.
- **Alternatives considered**: Weaken experience-order (forbidden by FR-004). Count denied reads
  (rejected — would hide real outside reads).

## R4. Fix shape (harness only)

- **Decision**: In `harness/src/drivers/cursor.ts` (and tests):
  1. Replace the regex with `skillIdFromCursorTool(name, args)` that extracts `<skill-id>` only
     from a `/skills/<skill-id>/` path (or explicit skill fields), never from the
     `…/highway/skills` directory name.
  2. Before `permissionPolicy`, **normalize** read/write paths that contain
     `.cursor/plugins/local/highway/` onto the attempt’s install read root (suffix after
     `highway/`), so plugin-relative paths count as in-root when that suffix exists under the
     install tree.
  3. Keep using `isExperienceSkillRead` on approved reads; also record the extracted skill id into
     `skillsInvoked` / `skillsBeforeOutput` when appropriate.
  4. Map Cursor `glob` / `grep` / `ls` tool calls to path-scoped read requests (not bare `other`)
     so allowlisted filesystem tools are not spuriously `denied: glob glob` in the transcript.
     Shared `permissionPolicy` and Copilot stay unchanged.
  5. **Defer `outputSeen`** until after the turn’s `agent` log line. Cursor often streams
     assistant text tokens before `tool_call` events for the same turn; setting `outputSeen` on
     those tokens left `skillsBeforeOutput` empty even when `skill: highway-experience` appeared
     above the agent line in the log (confirmed on the aborted 250 smoke-1).
- **Rationale**: Fixes mapping and load accounting without skill text changes; satisfies FR-003–
  FR-006.
- **Alternatives considered**: Broaden shared `permissionPolicy` for all drivers (rejected —
  Copilot must stay unchanged). Auto-pass experience when skillCount is 16 (rejected — R1).
  Set `outputSeen` only when an assistant event has no `tool_use` blocks (insufficient — Cursor
  emits separate text token events before `tool_call`).

## R5. Confirmation bar (from clarify)

- **Decision**: One cycle: two `--agent cursor --smoke` and one `--agent cursor --skills
  highway-codify`. F29 resolves only if **zero** attempts in those three logs fail experience-order
  with `actual no skill`. Remaining experience-order with named skills → F27. Unworkable research
  would have stopped for a person; this research is workable.
- **Rationale**: Spec clarifications 2026-11-16.
- **Alternatives considered**: Copilot pass-parity gate (rejected in clarify).

## R6. Model and parallel

- **Decision**: Keep `models.cursor` = `gpt-5.6-luna` and the shared parallel setting. No Cursor
  serial override. Judge stays Copilot.
- **Rationale**: Spec assumptions; load is not model-blocked.
- **Alternatives considered**: Model switch to force skill tools (unnecessary given R1–R4).
