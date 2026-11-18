# Research: Codex Smoke Failures

Resolves Technical Context unknowns for FR-002 (git pre-refuse + guidance), FR-003 (skill load),
and live confirmation bars. Clarify locks already fixed: pre-refuse git only; continue after
pre-refuse; completed git fatal; throwaway guidance required; ≥9/16 ×2 smokes; codify required
with no numeric floor.

## R1. How to pre-refuse `git` before it runs

- **Decision**: Write a Codex rules file into each throwaway home at
  `$CODEX_HOME/rules/default.rules` containing a `prefix_rule` with `pattern = ["git"]` and
  `decision = "forbidden"` (justification: Local mode — person owns git). Keep
  `approvalPolicy: "never"` and `sandboxMode: "workspace-write"`. The TypeScript SDK does **not**
  expose an approval/deny callback on streamed events, so harness-side “approve: false” cannot
  stop the CLI; Codex’s own rules engine is the pre-run gate. Keep effects-based classification as
  backup when a `git` command still reaches `command_execution` with status `completed`.
- **Rationale**: Codex docs (`learn.chatgpt.com` Rules): `forbidden` blocks matching commands
  without prompting; rules load from `rules/` under active config layers including user layer at
  `~/.codex/rules/` — our throwaway `CODEX_HOME` is that layer. Shell wrappers (`zsh -lc 'git …'`)
  are split when Codex can safely parse the script, so a `git` prefix still matches.
- **Alternatives considered**: Relying only on AGENTS guidance (clarify: not primary). Changing
  `approvalPolicy` to `on-request` without a callback (headless would hang or auto-path unclear).
  Marking all git classifications non-fatal (would allow completed git — forbidden by FR-001).

## R2. Driver semantics: pre-refuse vs completed git

- **Decision**: Specialize shell handling for git in `noteAccess` / classification:
  1. Always log a permission line for git (denied / rejected).
  2. If `command_execution` status is **`completed`** and the command is git → record
     `Rejection` with `fatal: true` and set effects-fatal (attempt fails) — backup path.
  3. If git is seen with any other status (`failed`, denied, empty mid-flight that never
     completes) → record `Rejection` with **`fatal: false`** (or omit from fatal filter) so the
     runner’s `drive.rejected.filter(r => r.fatal)` does **not** add `rejected-request`. Attempt
     continues.
  4. Outside-path and network-install shells keep today’s effects-fatal behavior (not in
     pre-refuse set).
- **Rationale**: Runner fails any fatal rejection even when `effectsFatalMessage` is unset
  (`runner.ts`). Clarify requires pre-refused git alone must not fail the attempt.
- **Alternatives considered**: Leaving `classifyCodexShell` git as always `fatal: true` (recreates
  F31 on every deny). Softening outside-path/network the same way (out of scope / weakens Local).

## R3. Throwaway-home Local-mode guidance

- **Decision**: On each attempt, after creating `agentHome`, write a short `AGENTS.md` (and/or
  Codex-equivalent instruction file under that home) stating: Local mode; do not run `git`; do
  not leave the project root; do not network-install packages; use in-project file reads/writes
  (shell-as-file-tool OK); load Highway skills / highway-experience first when required. Content
  is harness-authored constants — never copy from the operator’s real home.
- **Rationale**: FR-002 required support; clarify Session guidance.
- **Alternatives considered**: Guidance-only without rules (rejected as primary). Reading
  `~/.codex` or personal `AGENTS.md` (contamination).

## R4. Plugin / skill load (FR-003)

- **Decision**: Keep shared install checks (name `highway`, 16 skills, enabled). Research of
  Phase 9 logs shows install succeeded every attempt while unmatched-question / experience-order
  still happened — staging may place files where `installPlugin` counts skills but Codex does not
  activate the marketplace plugin for the thread. Implementation order:
  1. Ensure throwaway home enables plugins (`features.plugins`, marketplace staged).
  2. If filesystem staging alone is insufficient, run `codex plugin marketplace add` /
     `codex plugin add highway@…` with `CODEX_HOME`/`HOME` set to the throwaway home (same as
     R2 in 252 research), then re-verify skill count.
  3. Confirm `readRoots` includes the path Codex actually reads for `SKILL.md` so experience
     activation is recorded.
  Do not hand-edit generated `highway-agent-plugin/` files.
- **Rationale**: FR-003; Phase 9 install passed while skills were unused.
- **Alternatives considered**: Skill text edits (out of scope). Disabling experience-order checks
  (weakens contract).

## R5. Model and judge

- **Decision**: Keep pinned `models.codex = gpt-5.6-luna` and judge Cursor / Luna. Remap only if
  live Codex rejects the id; document in tasks Notes.
- **Rationale**: FR-004; Phase 9 already remapped as needed.
- **Alternatives considered**: Changing judge agent (not required).

## R6. Live confirmation and F31 close criteria

- **Decision**: Save `smoke-1.log`, `smoke-2.log`, `codify.log` under this spec’s `harness/`.
  Success: each smoke ≥9/16; codify saved with failures mapped to findings (no floor). Close F31
  only if both smokes meet the bar **and** git-driven fails are fewer than Phase 9 baseline
  (`specs/252-codex-driver/harness/`). Otherwise update F31 Runs/Basis/Proposed resolution.
- **Rationale**: FR-005–FR-008, SC-002/SC-003.
- **Alternatives considered**: Codify numeric floor (clarify: none). Closing F31 on guidance
  alone without smoke bar (forbidden).

## R7. Parallelism

- **Decision**: Keep configured parallel. Serialize only if live evidence shows cross-home races.
- **Rationale**: Unchanged from Phase 9 / clarify.
- **Alternatives considered**: Always-serial (no evidence yet).
