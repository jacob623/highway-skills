# Research: Claude Bash Failures

Resolves Technical Context unknowns for F33 recovery. Clarify locks: refused Bash still
fails the attempt; smoke ≥14/16 each; throwaway-home guidance required; clearer denial
feedback optional (not an exit gate); no Codex-style continue-after-refuse; Haiku pin and
Cursor/Luna judge stay; no skill/template/fixture/scenario edits.

## R1. How throwaway-home guidance is delivered and loaded

- **Decision**: Mirror Codex’s `prepareCodexAgentHome` / `AGENTS.md` pattern. Add
  `prepareClaudeAgentHome(agentHome)` that writes short Local-mode / no-Bash guidance to
  `join(agentHome, ".claude", "CLAUDE.md")` (create `.claude/` as needed). Export the
  markdown string as `CLAUDE_LOCAL_GUIDANCE` (or equivalent). Change Claude drive sessions
  from `settingSources: []` to `settingSources: ["user"]` so the SDK loads user-level
  `~/.claude/CLAUDE.md` under the remapped throwaway `HOME`. Do **not** enable `"project"`
  or `"local"` (avoids fixture / operator project CLAUDE.md and `.local` settings). Keep
  `CLAUDE_CONFIG_DIR` under the throwaway home, `CLAUDE_CODE_DISABLE_AUTO_MEMORY=1`, and
  `strictMcpConfig: true`. Call `prepareClaudeAgentHome` once per attempt before `query`
  (same place plugin install / env prep runs). Leave `claudeAsk` on `settingSources: []`
  (no plugin, no guidance needed for one-shot judge asks).
- **Rationale**: Official Agent SDK docs: CLAUDE.md is not loaded when
  `settingSources: []`; `"user"` loads `~/.claude/CLAUDE.md`. With `HOME=agentHome`, that
  path is the throwaway file we write — not the operator’s personal config. Matches FR-002
  “throwaway home carries guidance” and User Story 1 acceptance.
- **Alternatives considered**:
  - `systemPrompt: { type: "preset", preset: "claude_code", append }` only — reliable, but
    does not literally put guidance in the throwaway home as the spec requires; keep as
    fallback only if live proves `"user"` CLAUDE.md is ignored under our env.
  - `settingSources: ["project"]` + write into fixture cwd — contaminates / depends on
    scenario trees and can load project hooks/skills.
  - Copying operator `~/.claude` — forbidden by FR-002 / Phase 8 isolation.

## R2. Guidance content (what the file says)

- **Decision**: Short bullet list, Codex-AGENTS tone:

  - Prefer Read / Write / Edit / Glob / Grep for in-project listing and file work.
  - Do **not** use Bash for exploration or file I/O; the harness refuses every Bash request
    and the attempt fails.
  - Stay inside the project root; do not read or write outside it; do not use memory.
  - Load and follow Highway skills; activate `highway-experience` before person-visible
    output when the scenario requires it.

  No skill text edits; no long essays; no softening of deny-all-Bash.
- **Rationale**: FR-002 primary lever; enough to steer Haiku without fighting the Claude Code
  preset. Parallel to `CODEX_LOCAL_AGENTS_MD`.
- **Alternatives considered**: Long CLAUDE.md with examples (noise). Only denial-message
  changes (clarify: optional, not enough alone).

## R3. Optional denial-feedback wording

- **Decision**: Optional. If implemented cheaply in the same change, when denying Bash via
  `canUseTool`, set the deny `message` to name Read / Write / Edit / Glob / Grep as the
  alternative and state that Bash is refused. Must still produce a fatal storage
  `rejected-request` (FR-001). Unit-test the message if added. Exit does **not** require
  this change.
- **Rationale**: Clarify Q3 Option B.
- **Alternatives considered**: Required denial rewrite (rejected in clarify). Softening
  refuse / continue-after-deny (forbidden).

## R4. Enforcement stays Phase 8

- **Decision**: No change to deny-all-Bash, fatal refuse → storage fail, path/memory bans,
  effects backup for tool_use-without-canUseTool shell (assistant tool_use alone still must
  not false-trigger). No Codex Phase 9 continue-after-refuse for Claude Bash.
- **Rationale**: Clarify Q1; FR-001; SC-006.
- **Alternatives considered**: Codex-style non-fatal pre-refuse (rejected).

## R5. Confirmation bar and logs

- **Decision**: Two `--agent claude --smoke` (≥14/16 each) and one
  `--agent claude --skills highway-codify` (no numeric floor). Logs under
  `specs/255-claude-bash-failures/harness/` (`smoke-1.log`, `smoke-2.log`, `codify.log`),
  redacted. Compare Bash-driven `rejected-request` counts to Phase 8 baseline under
  `specs/254-claude-code-driver/harness/`. F33 closes only if both smoke bars hold **and**
  Bash-driven fails are fewer than baseline; else update Runs / Basis / Proposed resolution.
  Model `models.claude` (Haiku); judge Cursor/Luna. Parallelism unchanged unless live proves
  unsafe.
- **Rationale**: Clarify Q2; FR-003–FR-005, FR-007–FR-008.
- **Alternatives considered**: ≥15/16 or 16/16 (stricter than clarify). Codify numeric floor
  (rejected for this phase).

## R6. Tests and docs

- **Decision**: Extend `harness/test/claude.test.ts`: assert `prepareClaudeAgentHome` writes
  `.claude/CLAUDE.md` with expected guidance; assert drive `query` options use
  `settingSources: ["user"]` and that guidance was prepared for the attempt home; keep Bash
  deny tests; if optional denial message is added, assert it. Suite `tests/run-all.sh` and
  harness unit/typecheck stay green. Update `harness/README.md` Claude section (FR-009).
  Update findings and rollout Phase Status from live evidence. No constitution bump expected
  (no new harness dependency).
- **Rationale**: FR-006, FR-009, D3.1–D3.3, D6.1.
- **Alternatives considered**: Live-only validation without unit coverage (fails FR-006).
