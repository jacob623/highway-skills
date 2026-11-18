# Feature Specification: Codex Smoke Failures

**Feature Branch**: `253-codex-smoke-failures`

**Created**: 2026-11-18

**Status**: Draft

**Input**: User description: "create a new spec to address the failures."

Phase 9 (`specs/252-codex-driver/`) delivered a working Codex harness driver: every attempt installs
`highway` with 16 skills under effects-based shell enforcement, and the suite and harness unit
tests pass. Live confirmation did not: smoke twice at 0/16 and highway-codify at 0/28 on
`gpt-5.6-luna` with judge Cursor/Luna.

Evidence and open finding:

| Source | What it shows |
| --- | --- |
| `specs/252-codex-driver/harness/smoke-1.log` | 0/16; every attempt installed 16 skills |
| `specs/252-codex-driver/harness/smoke-2.log` | 0/16; same pattern |
| `specs/252-codex-driver/harness/codify.log` | 0/28 |
| **F31** | Codex explores with `/bin/zsh -lc '… git …'`; enforcement correctly fails the attempt |

Secondary failure modes on those runs (not separate open findings yet): experience-order when
highway-experience is not activated before first agent text; unmatched-question when Codex does
not treat `/highway-*` as loaded skills; some outside-path shell denials and outside-writes after
wrong exploration.

This spec improves Codex harness **pass outcomes** without weakening Local-mode rules: the person
still owns every git step; outside paths and network-facing installs still fail the attempt;
in-project read/write and in-project build/test through the shell remain allowed.

Out of scope: allowing `git` under Local mode; Cursor cloud (Phase 20); public marketplace install
(Phase 14); promoting fixtures from Codex runs; F30 (Cursor plugin asset path); reopening closed
findings; changing Copilot or Cursor drivers except shared harness config this work already uses;
weakening storage-contract bans on git / outside paths / arbitrary scripts.

## Clarifications

### Session 2026-11-18

- Q: Primary approach to reduce git-driven fails (F31)? → A: Pre-refuse `git` when the agent can
  deny before run; keep effects-based failure as backup. Session guidance alone is not the primary
  lever (may still be used as support).
- Q: Confirming smoke success bar? → A: Majority (≥9/16) passing on each of two `--agent codex
  --smoke` runs.
- Q: highway-codify confirmation this phase? → A: Required — two smokes plus one
  `--agent codex --skills highway-codify` run.
- Q: When the required highway-codify confirmation finishes, what counts as good enough? → A: No
  numeric pass floor; save the log, map failures to findings (F31 / new), and proceed if both
  smokes met ≥9/16.
- Q: Should pre-refuse cover only `git`, or every shell class Local mode already forbids? → A:
  Pre-refuse `git` only; outside paths and network-facing installs still fail after effects.
- Q: If Codex asks to run `git` and the harness refuses it before it runs, should that attempt
  still fail, or may it continue? → A: Pre-refused `git` is logged; the attempt may continue; a
  `git` command that still completes fails the attempt fatally.
- Q: Should this phase also put Local-mode “no `git`” guidance in each throwaway home, or rely on
  pre-refuse alone? → A: Pre-refuse plus required short Local-mode / no-`git` guidance in the
  throwaway home (not a substitute for the bans).

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Codex stops failing smoke on forbidden `git` (Priority: P1)

A maintainer runs `--agent codex --smoke`. Attempts still install Highway with 16 skills. Codex no
longer routinely fails solely because it asked to run `git` and was refused before run. Enforcement
still fails any attempt where `git` actually completes.

**Why this priority**: F31 dominates the 0/16 smoke tables. Without fewer git-driven fails, Codex
is installed but not useful as a confirmation agent.

**Independent Test**: After the change, run two `--agent codex --smoke` runs; compare git-denial /
git-driven storage fails against the Phase 9 baseline logs; update F31.

**Acceptance Scenarios**:

1. **Given** the locked Local-mode rule, **When** a `git` command still runs to completion,
   **Then** the attempt fails (effects backup).
2. **Given** pre-refuse of `git`, **When** Codex requests `git` and the harness refuses it before
   run, **Then** the denial is logged and the attempt may continue; that refusal alone MUST NOT
   fail the attempt as a fatal storage violation.
3. **Given** pre-refuse of `git` (with effects fail as backup), **When** smoke runs, **Then**
   attempts that fail only because Codex invoked `git` are fewer than in the Phase 9 baseline
   smoke logs (or research records why pre-refuse was impossible and F31 stays open with that
   evidence).
4. **Given** an attempt that only needs in-project file reads/writes (and allowed build/test),
   **When** Codex stays on that path, **Then** the attempt is not failed for shell-as-file-tool
   use alone.
5. **Given** each attempt’s throwaway home, **When** the attempt starts, **Then** it includes
   short Local-mode / no-`git` guidance that is not the operator’s personal config.

---

### User Story 2 - Highway skills are usable in the Codex attempt (Priority: P1)

A maintainer runs smoke or a single skill scenario on Codex. The installed plugin’s skills are
available for the attempt so slash (or equivalent) skill invocations and highway-experience
activation can succeed before first person-visible output when the scenario requires it.

**Why this priority**: Secondary fails (unmatched-question, experience-order) show install checks
passing while Codex still does not effectively use Highway skills.

**Independent Test**: Research or harness change proves skills are discoverable in the throwaway
home; live smoke or a targeted skill scenario shows experience-order / unmatched-question rates
improved versus Phase 9 baseline, or findings explain remaining gaps.

**Acceptance Scenarios**:

1. **Given** a successful shared install (name `highway`, 16 skills, enabled), **When** an attempt
   starts, **Then** research or implementation records how Codex is expected to see those skills
   in the throwaway home (and fixes the gap if staging alone is insufficient).
2. **Given** confirming Codex smoke (or a named targeted skill set this spec chooses), **When**
   experience-order and unmatched-question outcomes are compared to Phase 9 baseline, **Then**
   those failure kinds are fewer, or each remaining kind has an updated finding with evidence.
3. **Given** highway-experience must activate before first output, **When** Codex reads the skill
   through an allowed path (including shell-as-file-tool under the install read root), **Then**
   the harness records that activation the same way as for other agents.

---

### User Story 3 - Confirmation, findings, and pass bar (Priority: P2)

After suite and harness tests pass, a maintainer re-runs Codex confirmation, commits logs under
this spec, updates `harness-model-findings.md`, and closes or updates F31 (and any new findings
this work opens) from the evidence.

**Why this priority**: Pass-rate goals and finding hygiene are how later phases know Codex is
improving without pretending Phase 9’s 0/16 was success.

**Independent Test**: Read committed logs under `specs/253-codex-smoke-failures/harness/` and the
Harness Failures section.

**Acceptance Scenarios**:

1. **Given** green suite and harness unit tests, **When** confirmation completes, **Then** two
   `--agent codex --smoke` logs and one `--agent codex --skills highway-codify` log are saved
   under this spec’s `harness/` folder without secrets or raw temporary absolute paths; the
   codify log has no numeric pass floor this phase (failures map to findings).
2. **Given** the smoke success bar (≥9/16 on each of two smokes), **When** smoke results are
   read, **Then** both smokes meet that bar, or findings document why the bar was not met and
   which follow-up remains.
3. **Given** F31, **When** findings are updated, **Then** F31 is removed only if both confirming
   smokes meet ≥9/16 and git-driven fails are fewer than the Phase 9 baseline; otherwise
   Runs/Basis/Proposed resolution are updated and F31 stays open.
4. **Given** a new failure kind that no open finding explains, **When** findings are updated,
   **Then** a new finding is added.

---

### Edge Cases

- Pre-refuse this phase targets `git` only; guidance and effects MUST NOT allow `git`,
  outside-project access, or network-facing installs.
- A pre-refused `git` request is not a fatal storage fail by itself; a completed `git` still is.
- Throwaway-home Local-mode / no-`git` guidance is required this phase; it MUST NOT leak personal
  operator `AGENTS.md` or personal Codex config into the attempt.
- Plugin/skill loading fixes MUST keep shared install checks (name, 16 skills, enabled) and must
  not hand-edit generated plugin files.
- Skill content changes are out of scope unless clarify explicitly includes them; default is
  harness/session guidance and install/load fixes only.
- Parallel attempt count stays as configured unless research proves Codex must run serially.
- F30 (Cursor assets) is untouched.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: This work MUST NOT weaken Local-mode bans: `git`, outside-project paths, and
  network-facing installs still fail the attempt; in-project read/write and in-project build/test
  through the shell remain allowed under the Phase 9 effects rule.
- **FR-002**: Planning and implementation MUST make **pre-refuse of `git` only** the primary lever
  when the agent can deny a command before it runs, and MUST keep effects-based failure as backup
  when a forbidden `git` still completes. A **successful pre-refuse of `git` MUST be logged and
  MUST NOT by itself fail the attempt** as a fatal storage violation; the attempt may continue.
  Outside-project paths and network-facing installs MUST continue to fail via effects (not
  required in the pre-refuse set this phase). Each attempt’s throwaway home MUST also receive
  **short Local-mode / no-`git` guidance** as required support (MUST NOT replace FR-001 bans; MUST
  NOT load the operator’s personal `AGENTS.md`). If research finds pre-refuse impossible, record
  that and leave F31 open; guidance still ships.
- **FR-003**: Research MUST verify whether the current throwaway-home plugin staging is enough for
  Codex to load and use Highway skills mid-attempt; if not, the harness MUST fix install/load so
  shared checks still pass and skills are usable.
- **FR-004**: Confirming live runs MUST use the pinned Codex Luna model and the configured Cursor
  Luna judge (same family as Phase 9) unless research documents a required remap.
- **FR-005**: Each of two confirming `--agent codex --smoke` runs MUST pass at least **9 of 16**
  scenarios, or F31 (and findings) stay open with evidence why that bar was missed.
- **FR-006**: Confirmation MUST include two `--agent codex --smoke` runs **and** one
  `--agent codex --skills highway-codify` run, with logs under this spec’s `harness/` folder.
  The codify run has **no numeric pass floor** this phase: outcomes MUST be mapped into
  findings (F31 and any new findings). Exit still hinges on FR-005’s smoke bar.
- **FR-007**: Unit tests MUST cover any new refuse/guidance/load behavior that can be tested
  without a live key; suite and harness tests MUST stay green.
- **FR-008**: `harness-model-findings.md` MUST be updated from confirming runs; F31 closed only
  when FR-005’s ≥9/16 bar holds on both smokes and git-driven fails are fewer than the Phase 9
  baseline; new unexplained failure kinds get new findings.
- **FR-009**: Committed logs under `specs/253-codex-smoke-failures/harness/` MUST contain no
  secrets and no raw temporary absolute paths.

### Key Entities

- **F31**: Open finding that Codex fails attempts by running `git` via shell despite correct
  enforcement.
- **Phase 9 baseline logs**: Smoke and codify logs under `specs/252-codex-driver/harness/` used as
  the comparison baseline.
- **Throwaway Codex home**: Per-attempt isolated home where plugin install and any session
  guidance live without personal config.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Every confirming Codex smoke attempt still installs the Highway plugin with all 16
  skills.
- **SC-002**: Git-driven attempt failures on confirming Codex smoke are fewer than on the Phase 9
  baseline smokes, or F31 remains open with a written reason that pre-refuse was impossible.
- **SC-003**: Each of two confirming Codex smokes passes at least 9 of 16 scenarios, or findings
  explicitly record the miss and remaining work.
- **SC-003a**: The required highway-codify log is saved and every failure class in it is matched
  to F31 or another named finding; no numeric codify pass count is required this phase.
- **SC-004**: A maintainer can open the new committed smoke (and codify) logs and the updated
  findings section and match each failure class to F31 or another named finding.
- **SC-005**: Full suite and harness unit tests pass after the change.

## Assumptions

- Phase 9 effects-based enforcement and storage-contract MINOR 1.3.0 stay in force.
- Luna (`gpt-5.6-luna` or the pinned Codex equivalent) remains the confirmation model; judge
  remains Cursor with Luna.
- No commit is created unless a person asks.
- Improving model skill-following via Highway skill text edits is out of scope; throwaway-home
  Local-mode guidance plus harness refuse/load fixes are the levers.
- Parallelism stays at the configured harness value unless research proves otherwise.
