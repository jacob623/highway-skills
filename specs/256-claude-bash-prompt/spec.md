# Feature Specification: Claude Bash Prompt

**Feature Branch**: `256-claude-bash-prompt`

**Created**: 2026-11-18

**Status**: Draft

**Input**: User description: "create a new spec to address F33"

Spec 255 (`specs/255-claude-bash-failures/`) shipped throwaway-home Local-mode / no-Bash guidance
and optional clearer Bash denial wording. Deny-all-Bash and fatal refuse stayed locked. Live
confirmation did not close F33: smoke 12/16 and 11/16 (bar was ≥14/16), codify 18/28, and Bash
denial counts rose vs Phase 8 (8 and 10 vs 5 and 5). Some turns showed the model acknowledging
Bash was unavailable and switching to file tools, but overall Bash-driven `rejected-request`
fails did not drop.

Evidence:

| Source | What it shows |
| --- | --- |
| `specs/254-claude-code-driver/harness/smoke-*.log` | Phase 8 baseline: 13/16 twice; Bash denials 5 / 5 |
| `specs/255-claude-bash-failures/harness/smoke-*.log` | After throwaway-home guidance: 12/16 and 11/16; Bash denials 8 / 10 |
| `specs/255-claude-bash-failures/harness/codify.log` | 18/28; Bash-driven fails remain |
| **F33** | Open: Claude still explores with Bash; refuse still fails the attempt; home-file
  guidance alone did not meet the smoke bar or reduce Bash-driven fails vs Phase 8 |

F33’s proposed next lever: make Local-mode / no-Bash guidance **reliably reach the model at
session start** (confirm whether the throwaway home file is actually injected; if not—or even if
it is—add the same guidance as session-start instructions that always apply), without weakening
deny-all-Bash or adopting Codex continue-after-refuse.

This spec improves Claude harness **pass outcomes** by ensuring that guidance is present in every
confirming attempt’s session instructions, not only as a home file that may never load. Every
Bash request still fails the attempt when requested; outside paths and memory still fail;
in-project file tools remain the allowed path.

Out of scope: allowing any Bash under Local mode for Claude; Codex-style continue-after-refuse;
Cursor cloud (Phase 20); public marketplace (Phase 14); promoting fixtures from Claude runs;
F30–F32; skill, template, fixture, or scenario edits; changing Copilot, Cursor, or Codex drivers
except shared harness config this work already uses; reopening Phase 8 install/registry work.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Session-start guidance steers Claude off Bash (Priority: P1)

A maintainer runs `--agent claude --smoke`. Attempts still install Highway with 16 skills. Each
attempt carries short Local-mode / no-Bash guidance that the model receives at session start
(prefer file tools; do not use Bash). When Bash is still requested, the harness still denies it
before run and the attempt still fails storage as today.

**Why this priority**: Spec 255’s home-file lever did not close F33. Without guidance that
actually reaches the session, Claude stays noisy as a confirmation agent.

**Independent Test**: After the change, run two `--agent claude --smoke` runs; compare Bash
denial counts and Bash-driven storage fails against Phase 8 and Spec 255 logs; update F33.

**Acceptance Scenarios**:

1. **Given** the locked deny-all-Bash rule, **When** Claude requests Bash, **Then** the request is
   refused before run and the attempt fails storage (`rejected-request`) — this phase does not make
   a refused Bash non-fatal.
2. **Given** each confirming Claude attempt, **When** the session starts, **Then** short
   Local-mode / no-Bash guidance (prefer Read / Write / Edit / Glob / Grep; do not use Bash) is
   present in the attempt’s session instructions, not only as an unloaded home file, and is not
   the operator’s personal Claude config.
3. **Given** that session-start guidance, **When** smoke runs, **Then** Bash-driven
   `rejected-request` fails are fewer than on the Phase 8 baseline smoke logs, or findings record
   why the lever could not be applied and F33 stays open.
4. **Given** an attempt that only needs in-project file tools, **When** Claude stays on that path,
   **Then** the attempt is not failed for shell use.

---

### User Story 2 - Confirmation, findings, and pass bar (Priority: P1)

After suite and harness tests pass, a maintainer re-runs Claude confirmation, saves logs under
this spec, updates `harness-model-findings.md`, and closes or updates F33 from the evidence.

**Why this priority**: Pass-rate goals and finding hygiene show whether session-start guidance
moved the needle after Spec 255.

**Independent Test**: Read committed logs under `specs/256-claude-bash-prompt/harness/` and the
updated F33 section.

**Acceptance Scenarios**:

1. **Given** green suite and harness unit tests, **When** confirmation completes, **Then** two
   `--agent claude --smoke` logs and one `--agent claude --skills highway-codify` log are saved
   under this spec’s `harness/` folder without secrets or raw temporary absolute paths; the
   codify log has no numeric pass floor this phase (failures map to findings).
2. **Given** the smoke success bar (≥14 of 16 on each of two smokes — same bar Spec 255 locked),
   **When** smoke results are read, **Then** both smokes meet that bar, or findings document why
   the bar was not met and which follow-up remains.
3. **Given** F33, **When** findings are updated, **Then** F33 is closed only if both confirming
   smokes meet ≥14/16 and Bash-driven `rejected-request` fails are fewer than the Phase 8
   baseline; otherwise Runs / Basis / Proposed resolution are updated and F33 stays open.
4. **Given** a new failure kind that no open finding explains, **When** findings are updated,
   **Then** a new finding is added.
5. **Given** secondary assertion / experience-order / unmatched-question fails, **When** findings
   are updated, **Then** they gain Runs lines or stay as recorded skill-behavior noise — they are
   not fixed by skill edits in this spec.

---

### User Story 3 - Guidance path is documented for maintainers (Priority: P3)

A maintainer reading `harness/README.md` learns that Claude attempts receive Local-mode / no-Bash
guidance at session start (and how that relates to any throwaway-home file), and that Bash remains
always refused.

**Why this priority**: Later driver work needs one place that names the lever that Spec 255’s
home file alone did not prove.

**Independent Test**: Read the Claude section of `harness/README.md` for the session-start
guidance note.

**Acceptance Scenarios**:

1. **Given** `harness/README.md`, **When** a maintainer looks up Claude policy, **Then** it names
   that session-start Local-mode / no-Bash guidance steers away from Bash, notes any throwaway-home
   file still written, and that every Bash request is still refused.

---

### Edge Cases

- Deny-all-Bash stays; this phase MUST NOT allow in-project Bash for Claude.
- A refused Bash request still fails the attempt via the storage invariant; do not adopt Codex’s
  “pre-refuse and continue” rule for Claude Bash.
- Session-start guidance MUST NOT load the operator’s personal Claude config, project settings, or
  memory into the attempt.
- If a throwaway-home guidance file remains, it MUST NOT be treated as sufficient on its own unless
  planning proves it is actually injected into the session.
- Clearer denial feedback that names file tools may stay; it MUST NOT soften the refuse and is not
  an exit gate.
- Assertion template misses and experience-order / unmatched-question stay out of skill-edit
  scope; record them in findings only.
- Parallel attempt count stays as configured unless research proves Claude must run serially.
- F30–F32 and Codex recovery are untouched.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: This work MUST NOT weaken Local-mode bans for Claude: every Bash request is still
  refused before run when the permission callback can refuse it; memory and outside-project writes
  still fail; in-project Read / Write / Edit / Glob / Grep remain allowed. In-project Bash MUST
  NOT be allowed. A successful refuse of Bash MUST still fail the attempt as `rejected-request`.
- **FR-002**: Planning and implementation MUST ensure short Local-mode / no-Bash guidance
  **reaches the model at session start** on every confirming Claude drive attempt (prefer file
  tools; do not use Bash). Relying only on a throwaway-home file that may not be loaded is not
  enough. Guidance MUST NOT replace FR-001 bans and MUST NOT load the operator’s personal Claude
  config. Clearer denial feedback remains optional and not an exit gate.
- **FR-003**: Confirming live runs MUST use the pinned Claude Haiku model (`models.claude`) and
  the configured Cursor Luna judge unless research documents a required remap.
- **FR-004**: Each of two confirming `--agent claude --smoke` runs MUST pass at least **14 of 16**
  scenarios, or F33 (and findings) stay open with evidence why that bar was missed.
- **FR-005**: Confirmation MUST include two `--agent claude --smoke` runs **and** one
  `--agent claude --skills highway-codify` run, with logs under this spec’s `harness/` folder.
  The codify run has **no numeric pass floor** this phase: outcomes MUST be mapped into findings.
  Exit still hinges on FR-004’s smoke bar.
- **FR-006**: Unit tests MUST cover the session-start guidance behavior that can be tested without
  a live key; suite and harness tests MUST stay green.
- **FR-007**: `harness-model-findings.md` MUST be updated from confirming runs; F33 closed only
  when FR-004’s ≥14/16 bar holds on both smokes and Bash-driven `rejected-request` fails are fewer
  than the Phase 8 baseline; new unexplained failure kinds get new findings.
- **FR-008**: Committed logs under `specs/256-claude-bash-prompt/harness/` MUST contain no
  secrets and no raw temporary absolute paths.
- **FR-009**: `harness/README.md` MUST note Claude session-start no-Bash guidance (and any
  remaining throwaway-home file) beside the deny-all-Bash policy.

### Key Entities

- **F33**: Open finding that Claude fails attempts by requesting Bash for exploration despite
  file tools and correct pre-refuse; Spec 255 home-file guidance did not close it.
- **Phase 8 baseline logs**: Smoke logs under `specs/254-claude-code-driver/harness/` used as the
  Bash-fail comparison baseline for closing F33.
- **Spec 255 logs**: Prior recovery attempt under `specs/255-claude-bash-failures/harness/`
  (home-file guidance; missed ≥14/16).
- **Session-start guidance**: Short Local-mode / no-Bash instructions that the confirming Claude
  attempt is guaranteed to receive when the session begins.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Every confirming Claude smoke attempt still installs the Highway plugin with all 16
  skills.
- **SC-002**: Bash-driven `rejected-request` attempt failures on confirming Claude smoke are fewer
  than on the Phase 8 baseline smokes, or F33 remains open with a written reason that
  session-start guidance could not be applied.
- **SC-003**: Each of two confirming Claude smokes passes at least 14 of 16 scenarios, or findings
  explicitly record the miss and remaining work.
- **SC-003a**: The required highway-codify log is saved and every failure class in it is matched
  to F33 or another named finding; no numeric codify pass count is required this phase.
- **SC-004**: A maintainer can open the new committed smoke (and codify) logs and the updated
  findings section and match each failure class to F33 or another named finding.
- **SC-005**: Full suite and harness unit tests pass after the change.
- **SC-006**: Deny-all-Bash remains in force: no confirming Claude attempt completes a Bash
  request without that request being refused before run (or recorded and failed under the existing
  effects backup).

## Assumptions

- Phase 8 deny-all-Bash clarify lock, Spec 255 fatal-refuse and ≥14/16 smoke bar, and Haiku pin
  stay in force.
- Spec 255 throwaway-home guidance may remain as a supporting artifact; session-start delivery is
  the required lever for this phase.
- Haiku (`claude-haiku-5-5` or the pinned equivalent) remains the confirmation model; judge
  remains Cursor with Luna.
- No commit is created unless a person asks.
- Improving model skill-following via Highway skill text edits is out of scope.
- Parallelism stays at the configured harness value unless research proves otherwise.
- Constraints: secrets redacted; `rollout-plan.md` stays gitignored / distribution-excluded;
  MINOR bumps only if a constitution or skill change is forced (none planned); `mv`, not `git mv`.
