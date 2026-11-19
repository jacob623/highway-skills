# Feature Specification: Claude Bash Failures

**Feature Branch**: `255-claude-bash-failures`

**Created**: 2026-11-18

**Status**: Draft

**Input**: User description: "create a new spec to address F33"

Phase 8 (`specs/254-claude-code-driver/`) delivered a working Claude Code harness driver: every
attempt installs `highway` with 16 skills, every Bash request is refused before run, and the suite
and harness unit tests pass. Live confirmation was usable but not clean: smoke twice at 13/16 and
highway-codify at 18/28 on `claude-haiku-5-5` with judge Cursor/Luna.

Evidence and open finding:

| Source | What it shows |
| --- | --- |
| `specs/254-claude-code-driver/harness/smoke-1.log` | 13/16; every attempt installed 16 skills |
| `specs/254-claude-code-driver/harness/smoke-2.log` | 13/16; same pattern |
| `specs/254-claude-code-driver/harness/codify.log` | 18/28 |
| **F33** | Claude explores with `Bash` (`ls` / `cat` / `find` / `grep` pipelines) even though Read,
  Write, Edit, Glob, and Grep are available; the harness denies Bash before run; the storage
  invariant then fails the attempt as `rejected-request` |

Secondary failure modes on those runs (not separate open findings): assertion template misses
(profile / setup / some codify scenarios); intermittent experience-order and unmatched-question on
codify.

This spec improves Claude harness **pass outcomes** by steering the agent away from Bash without
weakening Local-mode rules: every Bash request still fails the attempt when requested; outside
paths and memory still fail; in-project Read / Write / Edit (and Glob / Grep) remain the allowed
file path. Unlike Codex Phase 9 recovery, this phase does **not** make a refused Bash request
non-fatal — the goal is fewer Bash requests, not softer enforcement.

Out of scope: allowing any Bash under Local mode for Claude; Codex-style in-project build/test
through shell; Cursor cloud (Phase 20); public marketplace (Phase 14); promoting fixtures from
Claude runs; F30–F32; skill, template, fixture, or scenario edits; changing Copilot, Cursor, or
Codex drivers except shared harness config this work already uses.

## Clarifications

### Session 2026-11-18

- Q: If Claude asks to run Bash and the harness refuses it before it runs, should that attempt
  still fail storage, or may it continue? → A: Refused Bash still fails the attempt
  (`rejected-request`), same as Phase 8 (not Codex-style continue-after-refuse).
- Q: What smoke pass count must each of the two confirming Claude smokes meet before F33 can
  close? → A: ≥14 of 16 on each smoke (one better than Phase 8’s 13/16).
- Q: Must this phase change the Bash denial message to name file tools, or is throwaway-home
  Local-mode / no-Bash guidance enough on its own? → A: Guidance is required; clearer denial
  feedback that names file tools is optional (not an exit gate).

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Claude stops failing smoke on avoidable Bash (Priority: P1)

A maintainer runs `--agent claude --smoke`. Attempts still install Highway with 16 skills. Claude
requests Bash less often for ordinary listing and reading because each attempt’s throwaway home
carries short Local-mode guidance: use the agent’s file tools; do not use Bash. When Bash is still
requested, the harness still denies it before run and the attempt still fails storage as today.

**Why this priority**: F33 is the dominant open finding after Phase 8. Without fewer Bash-driven
`rejected-request` fails, Claude remains installable but noisy as a confirmation agent.

**Independent Test**: After the change, run two `--agent claude --smoke` runs; compare Bash denial
counts and Bash-driven storage fails against the Phase 8 baseline logs; update F33.

**Acceptance Scenarios**:

1. **Given** the locked deny-all-Bash rule, **When** Claude requests Bash, **Then** the request is
   refused before run and the attempt fails storage (`rejected-request`) as in Phase 8 — this phase
   does not make a refused Bash non-fatal.
2. **Given** each attempt’s throwaway home, **When** the attempt starts, **Then** it includes short
   Local-mode guidance that tells Claude to use Read / Write / Edit / Glob / Grep (not Bash) for
   in-project work, and that guidance is not the operator’s personal Claude config.
3. **Given** that required throwaway-home guidance (and optional clearer denial feedback if
   added), **When** smoke runs, **Then** Bash-driven `rejected-request` fails are fewer than in
   the Phase 8 baseline smoke logs, or findings record why guidance could not be applied and F33
   stays open.
4. **Given** an attempt that only needs in-project file tools, **When** Claude stays on that path,
   **Then** the attempt is not failed for shell use.

---

### User Story 2 - Confirmation, findings, and pass bar (Priority: P1)

After suite and harness tests pass, a maintainer re-runs Claude confirmation, commits logs under
this spec, updates `harness-model-findings.md`, and closes or updates F33 (and any new findings
this work opens) from the evidence.

**Why this priority**: Pass-rate goals and finding hygiene are how later phases know Claude is
improving without pretending Phase 8’s Bash-driven fails were finished.

**Independent Test**: Read committed logs under `specs/255-claude-bash-failures/harness/` and the
updated F33 section.

**Acceptance Scenarios**:

1. **Given** green suite and harness unit tests, **When** confirmation completes, **Then** two
   `--agent claude --smoke` logs and one `--agent claude --skills highway-codify` log are saved
   under this spec’s `harness/` folder without secrets or raw temporary absolute paths; the
   codify log has no numeric pass floor this phase (failures map to findings).
2. **Given** the smoke success bar (≥14 of 16 on each of two smokes — one scenario better than
   Phase 8’s 13/16; clarify), **When** smoke results are read, **Then** both smokes meet that bar,
   or findings document why the bar was not met and which follow-up remains.
3. **Given** F33, **When** findings are updated, **Then** F33 is closed only if both confirming
   smokes meet ≥14/16 and Bash-driven `rejected-request` fails are fewer than the Phase 8
   baseline; otherwise Runs / Basis / Proposed resolution are updated and F33 stays open.
4. **Given** a new failure kind that no open finding explains, **When** findings are updated,
   **Then** a new finding is added.
5. **Given** secondary assertion / experience-order / unmatched-question fails, **When** findings
   are updated, **Then** they gain Runs lines or stay as recorded skill-behavior noise — they are
   not fixed by skill edits in this spec.

---

### User Story 3 - Guidance is documented for maintainers (Priority: P3)

A maintainer reading `harness/README.md` learns that Claude attempts ship Local-mode / no-Bash
guidance in the throwaway home and that Bash remains always refused.

**Why this priority**: Later driver work and anyone debugging F33-class fails need the lever
written once.

**Independent Test**: Read the Claude section of `harness/README.md` for the guidance note.

**Acceptance Scenarios**:

1. **Given** `harness/README.md`, **When** a maintainer looks up Claude policy, **Then** it names
   that throwaway-home Local-mode guidance steers away from Bash and that every Bash request is
   still refused.

---

### Edge Cases

- Deny-all-Bash stays; this phase MUST NOT allow in-project Bash for Claude (unlike Codex
  shell-as-file-tool).
- A refused Bash request still fails the attempt via the storage invariant (clarify); do not adopt
  Codex’s “pre-refuse and continue” rule for Claude Bash.
- Throwaway-home guidance MUST NOT leak personal operator `CLAUDE.md`, settings, or memory into
  the attempt.
- Clearer denial feedback that names file tools is optional; if present it MUST NOT soften the
  refuse. Exit does not require changing denial wording.
- Assertion template misses and experience-order / unmatched-question are out of skill-edit scope;
  record them in findings only.
- Parallel attempt count stays as configured unless research proves Claude must run serially.
- F30–F32 and Codex Phase 9 recovery are untouched.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: This work MUST NOT weaken Local-mode bans for Claude: every Bash request is still
  refused before run when the permission callback can refuse it; memory and outside-project writes
  still fail; in-project Read / Write / Edit / Glob / Grep remain allowed. In-project Bash MUST
  NOT be allowed. A **successful refuse of Bash MUST still fail the attempt** as
  `rejected-request` (clarify); Codex-style continue-after-refuse does **not** apply to Claude
  Bash.
- **FR-002**: Planning and implementation MUST ship **throwaway-home Local-mode / no-Bash
  guidance** as the required primary lever so Claude prefers file tools over Bash. Guidance MUST
  NOT replace FR-001 bans and MUST NOT load the operator’s personal Claude config. Clearer denial
  feedback that names file tools is **optional** (clarify) and MUST NOT be treated as an exit
  gate; making refused Bash non-fatal is forbidden.
- **FR-003**: Confirming live runs MUST use the pinned Claude Haiku model (`models.claude`) and
  the configured Cursor Luna judge unless research documents a required remap.
- **FR-004**: Each of two confirming `--agent claude --smoke` runs MUST pass at least **14 of 16**
  scenarios (clarify), or F33 (and findings) stay open with evidence why that bar was missed.
- **FR-005**: Confirmation MUST include two `--agent claude --smoke` runs **and** one
  `--agent claude --skills highway-codify` run, with logs under this spec’s `harness/` folder.
  The codify run has **no numeric pass floor** this phase: outcomes MUST be mapped into findings
  (F33 and any new findings). Exit still hinges on FR-004’s smoke bar.
- **FR-006**: Unit tests MUST cover the required throwaway-home guidance behavior that can be
  tested without a live key; if optional denial-feedback wording is added, cover that too. Suite
  and harness tests MUST stay green.
- **FR-007**: `harness-model-findings.md` MUST be updated from confirming runs; F33 closed only
  when FR-004’s ≥14/16 bar holds on both smokes and Bash-driven `rejected-request` fails are fewer
  than the Phase 8 baseline; new unexplained failure kinds get new findings.
- **FR-008**: Committed logs under `specs/255-claude-bash-failures/harness/` MUST contain no
  secrets and no raw temporary absolute paths.
- **FR-009**: `harness/README.md` MUST note Claude throwaway-home no-Bash guidance beside the
  existing deny-all-Bash policy.

### Key Entities

- **F33**: Open finding that Claude fails attempts by requesting Bash for exploration despite
  file tools and correct pre-refuse.
- **Phase 8 baseline logs**: Smoke and codify logs under `specs/254-claude-code-driver/harness/`
  used as the comparison baseline.
- **Throwaway Claude home**: Per-attempt isolated home where plugin install and Local-mode /
  no-Bash guidance live without personal config.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Every confirming Claude smoke attempt still installs the Highway plugin with all 16
  skills.
- **SC-002**: Bash-driven `rejected-request` attempt failures on confirming Claude smoke are fewer
  than on the Phase 8 baseline smokes, or F33 remains open with a written reason that guidance
  could not be applied.
- **SC-003**: Each of two confirming Claude smokes passes at least 14 of 16 scenarios (clarify), or
  findings explicitly record the miss and remaining work.
- **SC-003a**: The required highway-codify log is saved and every failure class in it is matched
  to F33 or another named finding; no numeric codify pass count is required this phase.
- **SC-004**: A maintainer can open the new committed smoke (and codify) logs and the updated
  findings section and match each failure class to F33 or another named finding.
- **SC-005**: Full suite and harness unit tests pass after the change.
- **SC-006**: Deny-all-Bash remains in force: no confirming Claude attempt completes a Bash
  request without that request being refused before run (or recorded and failed under the existing
  Phase 8 effects backup).

## Assumptions

- Phase 8 Claude driver, deny-all-Bash clarify lock, and Haiku pin stay in force.
- Haiku (`claude-haiku-5-5` or the pinned equivalent) remains the confirmation model; judge
  remains Cursor with Luna.
- No commit is created unless a person asks.
- Improving model skill-following via Highway skill text edits is out of scope; required
  throwaway-home Local-mode guidance is the lever; clearer denial-feedback wording is optional.
- Parallelism stays at the configured harness value unless research proves otherwise.
- Constraints: secrets redacted; `rollout-plan.md` stays gitignored / distribution-excluded;
  MINOR bumps only if a constitution or skill change is forced (none planned); `mv`, not `git mv`.
