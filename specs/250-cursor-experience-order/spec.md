# Feature Specification: Cursor Experience Order

**Feature Branch**: `250-cursor-experience-order`

**Created**: 2026-11-16

**Status**: Draft

**Input**: User description: "create a new spec for resolving F29 in harness-model-findings.md"

Finding F29 (Harness / agent): Cursor local runs almost always fail the experience-order check with `actual no skill`, even though every attempt installs Highway named `highway` with all 16 skills. Spec 249’s smoke and highway-codify logs show this pattern. The proposed resolution is a harness change: confirm how Cursor reports skill use (invocation signal, system tool list, or a read of highway-experience’s skill file), tighten install or event mapping if needed, and re-run live checks. Skills must not change for this finding.

Out of scope: any skill, template, fixture, or scenario change; Copilot driver behavior; Cursor cloud/remote runtime (Phase 20); marketplace install; promoting fixtures from Cursor runs.

## Clarifications

### Session 2026-11-16

- Q: After the harness fix, how strong must the Cursor smoke results be before F29 is marked resolved? → A: Resolve F29 once research proves activation is mapped correctly (systemic `actual no skill` is gone), even if smoke still often fails experience-order for model-skip reasons; record those under F27. One confirmation cycle of live runs; do not keep this spec open chasing full Copilot pass parity.
- Q: If research finds no usable activation signal and skills still cannot be proven loaded, stop for a person decision or close F29 as blocked? → A: Stop for a person decision; leave F29 open with research evidence. Do not mark F29 resolved or won’t-fix without a workable path.
- Q: In the confirmation smokes, how many attempts may still report experience-order `actual no skill` before F29 counts as fixed? → A: Zero — no attempt in either smoke run may still show `actual no skill`.
- Q: Must the confirmation `highway-codify` run also show zero `actual no skill`, or is the zero bar only for the two smoke runs? → A: Same zero bar — the confirmation codify run must also have zero `actual no skill`.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Cursor records highway-experience before output (Priority: P1)

A maintainer runs the Cursor smoke set after the harness fix. Attempts that reach a normal conversation activate highway-experience before the first person-visible output, the same way Copilot runs do, so experience-order is no longer the dominant failure.

**Why this priority**: F29 blocks treating Cursor as a usable agent for Highway. Without a reliable experience-order signal, smoke results cannot be compared to Copilot and later driver phases inherit a broken baseline.

**Independent Test**: Run two `--agent cursor --smoke` runs and one `--agent cursor --skills highway-codify` run, save the logs under this spec’s folder, and confirm zero attempts fail experience-order with `actual no skill`; remaining experience-order failures name a skill other than “none” (model skip → F27).

**Acceptance Scenarios**:

1. **Given** research has identified how Cursor surfaces skill activation for an installed plugin, **When** the Cursor driver maps that signal, **Then** an approved read of highway-experience’s skill file, or an explicit skill invocation of highway-experience, before first output, satisfies the shared experience-order check.
2. **Given** a completed Cursor smoke attempt that installs `highway` with 16 skills and activates highway-experience before first output, **When** the run log and result are read, **Then** that attempt does not fail experience-order with `actual no skill`.
3. **Given** the confirmation cycle’s two smoke runs and one codify run after the fix, **When** their results are read, **Then** no attempt in any of those three runs fails experience-order with `actual no skill`; any remaining experience-order failures are classified under F27 (model skip), and F29 is resolved without requiring Copilot-matching pass counts.

---

### User Story 2 - Install still proves skills are present (Priority: P1)

A developer confirms the fix does not weaken install checks. Each attempt still installs Highway as `highway` with 16 skills. If research finds skills were never loadable despite a passing install count, the install or load path is corrected in this spec until load is proven.

**Why this priority**: F29’s basis separates “install reported 16 skills” from “activation never recorded.” A mapping-only fix that leaves skills unloadable would hide a real load failure.

**Independent Test**: Unit or live evidence shows the plugin is installed with 16 skills and that highway-experience is reachable under the attempt’s read roots; a load failure blocks completion.

**Acceptance Scenarios**:

1. **Given** each Cursor attempt, **When** the shared install checks run, **Then** they still require name `highway`, 16 skills, no warning, and enabled.
2. **Given** research finds the install copy or settings source did not make skills available to the agent, **When** the fix lands, **Then** skills are available to the agent before the first send, and that proof is recorded in research and the live logs.

---

### User Story 3 - Findings and live records close F29 (Priority: P2)

After the suite and harness tests pass, a maintainer runs the required Cursor live checks, updates `harness-model-findings.md`, and marks F29 resolved when all three confirmation runs show zero `actual no skill`.

**Why this priority**: F29 stays open until confirming runs and the findings document say so. Spec 249 already committed the failing baseline logs.

**Independent Test**: Read this spec’s committed run logs and the F29 section; F29 is resolved or its remaining scope is explicitly narrowed with evidence.

**Acceptance Scenarios**:

1. **Given** the harness tests and the full bash suite pass, **When** two `--agent cursor --smoke` runs and one `--agent cursor --skills highway-codify` run complete, **Then** their standard-output logs are saved under `specs/250-cursor-experience-order/harness/` as `smoke-1.log`, `smoke-2.log`, and `codify.log`.
2. **Given** both smoke logs and the codify log show zero attempts with `actual no skill`, **When** findings are updated, **Then** F29 is resolved and removed from the open Harness Failures list; remaining experience-order cases gain Runs lines on F27.
3. **Given** failures that still match Copilot findings, or Cursor remains much worse than Copilot on model-skip experience-order after that one cycle, **When** findings are updated, **Then** those findings gain Runs lines or a new residual finding is opened; this spec does not start another fix cycle for pass-table parity.

---

### Edge Cases

- Research finds Cursor never emits a skill-invocation event, but an approved read of highway-experience’s skill file under the install read root is visible. The driver counts that read toward experience-order (same rule Copilot already uses).
- Research finds no usable activation signal and skills still cannot be proven loaded. Stop for a person decision; keep F29 open with evidence; do not close F29 as won’t-fix or weaken shared checks.
- Research finds skills are not loaded despite a passing install count, but a load/install fix is still feasible. Treat that as a load/install defect in this spec; do not weaken the experience-order check to pass.
- After the mapping/install fix, many attempts still fail experience-order but report that some skill ran (or highway-experience was skipped after other activity). Treat as F27 model-skip; resolve F29 only if all three confirmation runs also have zero `actual no skill`; do not keep this spec open for Copilot pass parity.
- Any confirmation-cycle attempt (smoke or codify) still fails experience-order with `actual no skill`. Leave F29 open; do not resolve after that cycle.
- A single attempt still skips highway-experience after other skill activity (F27-style, not `actual no skill`). Record it under F27; do not keep F29 open for that alone.
- Copilot’s experience-order behavior must stay unchanged.
- No skill, template, fixture, or scenario text changes to “fix” F29.

## Requirements *(mandatory)*

### Functional Requirements

**Research**

- **FR-001**: Planning MUST begin only after `research.md` answers how local Cursor reports skill use for an installed Highway plugin: at least one of (a) a stream or tool event that names a skill, (b) a system/init tool list that includes skills, (c) a readable path to a skill file under the install root that the agent actually opens. If research finds no usable activation signal and skills still cannot be proven loaded, the work MUST stop for a person decision: leave F29 open with the research evidence; do not mark F29 resolved or won’t-fix, and do not invent a workaround that weakens shared checks.
- **FR-002**: Research MUST record whether the current install path (copy into the throwaway home under the plugins local folder, with plugins settings enabled) makes skills available to the agent before the first send, with evidence from a probe or a live attempt.

**Harness fix**

- **FR-003**: The Cursor driver MUST map the confirmed activation signal(s) into the shared skills-before-output / skills-invoked records so the existing experience-order check can pass when highway-experience is activated before first output.
- **FR-004**: The fix MUST NOT weaken the shared experience-order check, the shared install checks, or Copilot’s driver behavior.
- **FR-005**: If research shows skills are unavailable after a “successful” install, this spec MUST fix the install or load path until skills are available, and MUST keep install failures as blocking `plugin-install` (or an equivalent load failure) outcomes.
- **FR-006**: No skill, template, fixture, or scenario MUST change.

**Tests**

- **FR-007**: Unit tests with a fake Cursor surface MUST cover: activation via the confirmed signal(s); a turn that outputs before activation still fails experience-order; install success with 16 skills unchanged.
- **FR-008**: Each new or changed test MUST be observed failing for the behavior it covers before that behavior is marked complete. A changed assertion MUST record what it supersedes.

**Live runs and findings**

- **FR-009**: After the full suite and the harness tests pass, exactly one confirmation cycle MUST run: two `--agent cursor --smoke` runs, then one `--agent cursor --skills highway-codify` run, using the configured Cursor model (same as Copilot today) and the shared parallel setting. Logs MUST be saved as `specs/250-cursor-experience-order/harness/smoke-1.log`, `smoke-2.log`, and `codify.log`. No secret, token, or temporary path MUST appear in a committed log. This spec MUST NOT add further live-run cycles to chase Copilot pass-table parity.
- **FR-010**: `harness-model-findings.md` MUST update the Cursor smoke context with this spec’s confirming runs. F29 MUST be resolved only when both confirmation smoke runs and the confirmation codify run show zero attempts with experience-order `actual no skill` (activation mapping/load proven). Remaining experience-order failures MUST be recorded under F27 (or a new residual finding if Cursor’s model-skip rate is still much worse than Copilot’s). If any confirmation-cycle attempt still shows `actual no skill`, F29 MUST stay open. New Cursor-specific failures MUST open new findings.
- **FR-011**: When F29 is resolved, `rollout-plan.md` MUST note the follow-up under Phase 7’s Status (or an adjacent Status note), without reopening Phase 7 as incomplete unless the person decides otherwise.

### Key Entities

- **F29**: the open finding that Cursor rarely records highway-experience before output despite a full plugin install.
- **Experience-order check**: the shared rule that highway-experience must appear in skills-before-output before the first person-visible output.
- **Activation signal**: the Cursor-specific evidence (invocation, tool list, or skill-file read) that the driver maps into that shared record.
- **Committed run log**: standard-output record of a live Cursor run under this spec’s folder.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In both Cursor smoke runs and the confirmation codify run after the fix, zero attempts fail experience-order with `actual no skill` (spec 249 was nearly 100% of scenarios); failures that still cite experience-order name recorded skill activity or are classified as model-skip (F27), not “no skill.”
- **SC-002**: Unit tests (and at least one live attempt) show that when highway-experience activation is present on the Cursor signal path, the shared experience-order check passes.
- **SC-003**: Every attempt in the three live Cursor runs still installs Highway named `highway` with 16 skills.
- **SC-004**: The full bash suite and the harness unit tests pass after the change, including the new Cursor activation cases; Copilot’s existing harness tests still pass.
- **SC-005**: F29 is resolved in `harness-model-findings.md` after the one confirmation cycle only when SC-001 holds; remaining experience-order issues are on F27 or an explicit residual finding — not left as open F29. If any confirmation-cycle attempt still shows `actual no skill`, F29 stays open.
- **SC-006**: Each committed run log holds no secret, token, or temporary path.
- **SC-007**: This spec completes after that single confirmation cycle; it does not require Cursor smoke pass counts to match Copilot before closing.

## Assumptions

- Spec 249 (Cursor driver) is complete enough to run `--agent cursor`; this spec only fixes activation visibility / load for F29.
- Full Copilot smoke pass parity is a goal for later comparison, not an exit gate for this finding-resolution spec.
- The configured Cursor model stays the same as Copilot (`gpt-5.6-luna` today) unless research proves that model cannot load skills and a person chooses otherwise.
- Shared parallel count stays as configured; no Cursor-specific serial override.
- Judge configuration stays Copilot.
- Constraints carried from earlier work: do not commit unless asked; secrets redacted; `rollout-plan.md` stays gitignored and distribution-excluded; MINOR bumps only if the constitution must change (not expected); no skill change; use `mv`, not `git mv`.
