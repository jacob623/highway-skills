# Feature Specification: Codex Driver

**Feature Branch**: `252-codex-driver`

**Created**: 2026-11-18

**Status**: Draft

**Input**: User description: "create a new spec for implementing Phase 9 of rollout-plan.md. Use the same luna model for any harness runs."

Phase 9 of `rollout-plan.md`: the behavioral test harness drives Codex through the Codex SDK (`@openai/codex-sdk`), from the Highway plugin built in Phases 4 and 6. Each attempt uses a throwaway Codex home and a temporary project so personal config, `AGENTS.md`, and history never reach a run. The shared runner, install checks, and report from Phase 5 stay unchanged; this spec adds one Codex driver and one registry entry.

Codex reads files and applies many edits through shell commands. Today's storage invariant fails any shell request, so every Codex attempt would fail unless this phase chooses an enforcement that fits Codex while still protecting the project. Phase 7 recorded an effects-based gap for this phase; this spec decides the Codex-specific rule (and whether the storage contract needs wording for agents whose file tool is the shell) before planning proceeds.

Live confirmation runs use the same Luna model family already pinned for Copilot and Cursor (`gpt-5.6-luna` or the Codex-listed equivalent research selects under that name). The configured judge for harness runs is Cursor with that Luna model.

Out of scope: public marketplace install (Phase 14); promoting fixtures from Codex runs; any other agent's driver; skill changes other than the storage-contract MINOR wording required by the clarify session.

## Clarifications

### Session 2026-11-18

- Q: Which Codex storage enforcement approach should this phase lock before planning? → A: Effects-based: sandbox; allow shell only when effect is in-project read/write; fail outside write, `git`, and scripts
- Q: Should this phase update the storage contract for agents whose file tool is the shell? → A: Yes — MINOR wording in `storage-contract.md` + regenerate
- Q: Should this phase also wire Codex so it can act as the judge agent later (a one-shot ask with no tools), even though the configured judge stays Copilot for now? → A: Yes — add Codex one-shot ask for future judge/fallback; and change the configured harness judge to Cursor with Luna for any harness runs in this phase
- Q: Should Codex’s live smoke and highway-codify runs use the same parallel attempt count as other agents, or run one attempt at a time? → A: Same parallel count as configured for Copilot/Cursor; serial only if research proves it is unsafe
- Q: When Codex uses the shell inside the project, which commands should still fail the attempt as a “script run”? → A: Allow in-project read/write and in-project build/test commands; fail `git`, outside paths, and network-facing installs
- Q: If Codex’s model list does not include an exact `gpt-5.6-luna` id, what should research pin as `models.codex`? → A: Pin the closest listed Luna-family / GPT-5.6 equivalent; document the mapping in research

## User Scenarios & Testing *(mandatory)*

### User Story 1 - A maintainer runs the smoke set on Codex (Priority: P1)

A maintainer runs the harness with `--agent codex --smoke` after the suite and harness tests pass. Every attempt installs Highway named `highway` with all 16 skills, the chosen storage enforcement holds, and the run finishes with a log the maintainer can commit.

**Why this priority**: This is the exit of Phase 9. Without a live Codex smoke that installs and drives Highway under the chosen enforcement, Codex is not a supported harness agent.

**Independent Test**: Run two `--agent codex --smoke` runs, commit each log, and confirm every attempt installed `highway` with 16 skills and every failure is classified in `harness-model-findings.md`.

**Acceptance Scenarios**:

1. **Given** `codex` is registered and a Codex model is pinned, **When** a run starts with `--agent codex --smoke`, **Then** every attempt uses that model, a throwaway Codex home, and its own temporary project.
2. **Given** each attempt, **When** the plugin is installed from the local build, **Then** the shared install checks pass: name `highway`, skill count 16, no warning, enabled, and Codex accepts the generated `.codex-plugin/plugin.json` interface block.
3. **Given** the chosen enforcement, **When** an attempt tries an outside-path access, a `git` command, or a network-facing install, **Then** the attempt fails; in-project reads/writes and in-project build/test commands are allowed.
4. **Given** two completed smoke runs, **When** their logs are read at `specs/252-codex-driver/harness/smoke-1.log` and `smoke-2.log`, **Then** every attempt installed `highway` with 16 skills, no secret or temporary path appears, and each failure is matched to a finding in `harness-model-findings.md`.
5. **Given** those live runs, **When** they execute, **Then** they use the same configured parallel attempt count as other agents unless research recorded a serial override.

---

### User Story 2 - Codex plugs into the harness without changing the runner (Priority: P1)

A developer adds one Codex driver and one registry entry. The runner, shared install checks, key/error handling, and report take what they need from the registry.

**Why this priority**: Phase 5 established that each driver phase adds one driver file. Changing the runner here would force every later driver to repeat that work and risk breaking Copilot and Cursor.

**Independent Test**: Register Codex, run harness unit tests with a fake Codex SDK, and confirm the runner needed no change beyond accepting the new registry entry.

**Acceptance Scenarios**:

1. **Given** the registry, **When** `--agent codex` is selected, **Then** the runner takes Codex’s driver, key variable(s), install, error classifier, read roots, versions, and one-shot ask from that entry, and does not import the Codex SDK itself.
2. **Given** Codex command runs and file-change events, **When** the driver maps them, **Then** they become the neutral request shape, transcript entries, skills-invoked / skills-before-output (including a read of highway-experience’s `SKILL.md`), and usage totals.
3. **Given** Codex’s install result, **When** the shared checks run, **Then** success, a short skill count, a warning, and a disabled plugin each produce the same `plugin-install` outcomes as other agents.
4. **Given** a missing or refused API key, **When** the run starts, **Then** `missing-token` or `no-access` names the Codex key variable(s) and Codex.
5. **Given** Codex’s registry entry, **When** a run sets the judge agent to `codex` (or uses Codex for the reply fallback), **Then** the one-shot ask works with no tools and no plugin, in its own throwaway home.
6. **Given** harness configuration for this phase, **When** any harness run uses the judge, **Then** the configured judge is Cursor with Luna (not Copilot).

---

### User Story 3 - Storage enforcement fits Codex’s shell-based file tools (Priority: P1)

A maintainer can trust that Codex may use the shell for in-project reads, writes, and build/test when that is how Codex works, while outside paths, `git`, and network-facing installs still fail the attempt.

**Why this priority**: Without this decision, either every Codex attempt fails on shell (today’s rule) or the storage invariant is silently weakened.

**Independent Test**: Unit tests cover an allowed project read, an allowed project write, an allowed in-project build/test command, an outside write, a `git` command, and a network-facing install under the chosen enforcement.

**Acceptance Scenarios**:

1. **Given** the clarify decision for enforcement, **When** planning and implementation complete, **Then** unit tests prove: allowed project read; allowed project write; allowed in-project build/test; outside write fails; `git` fails; network-facing install fails.
2. **Given** research on sandbox and approval modes, **When** a mode can refuse a request before it runs, **Then** the driver uses it for forbidden operations; when it cannot, effects-based enforcement still fails the attempt afterward.
3. **Given** the locked clarify decision, **When** the skill change lands, **Then** `highway-experience`’s storage contract gains MINOR wording for agents whose file tool is the shell, highway-experience’s version bumps MINOR, and adapters/plugin are regenerated.

---

### User Story 4 - Questions, turns, and the gated skill are covered (Priority: P2)

Scenarios that ask questions still get scripted replies. After two smokes, a maintainer runs Codex on highway-codify. Findings map Codex failures.

**Why this priority**: Highway skills ask questions; codify is the gated path smoke alone does not fully exercise.

**Independent Test**: Fake-SDK unit tests for question handling; live `--agent codex --skills highway-codify` log and findings section.

**Acceptance Scenarios**:

1. **Given** Codex asks through a tool or ends the turn, **When** the scenario has a reply, **Then** the driver or the existing reply loop answers and the attempt continues.
2. **Given** each scripted reply, **When** it is sent, **Then** it is one send on the same agent for that attempt, then wait for that run to finish.
3. **Given** the two smoke runs completed, **When** `--agent codex --skills highway-codify` runs, **Then** every attempt installs `highway` with 16 skills and the log is saved as `specs/252-codex-driver/harness/codify.log`.
4. **Given** failures from the live runs, **When** findings are updated, **Then** matching findings gain Runs lines and Codex-specific failures open new findings.

---

### User Story 5 - Codex is documented and governed (Priority: P3)

README, constitution Harness Toolchain, rollout Status, and standard-alignment record Codex setup and Phase 9 completion.

**Why this priority**: Later phases and maintainers need the setup written once; the toolchain declaration keeps the dependency explicit.

**Independent Test**: Read README, constitution, rollout-plan, and standard-alignment for Codex / Phase 9 Status.

**Acceptance Scenarios**:

1. **Given** `harness/README.md`, **When** a maintainer looks up Codex, **Then** it names the key, model, install, enforcement notes, and likely-cause rows.
2. **Given** the development constitution, **When** its Harness Toolchain is read, **Then** it names the Codex SDK, with a MINOR bump.
3. **Given** the work is done, **When** `rollout-plan.md` is read, **Then** Phase 9 is marked complete with a Status paragraph, and `standard-alignment.md` records the outcome where that document tracks agent rollout.

---

### Edge Cases

- Codex cannot refuse a forbidden operation before it runs. Effects-based enforcement still fails the attempt afterward.
- A field in `.codex-plugin/plugin.json` is rejected. The fix is in `framework/plugin/` and the generator, never hand-editing the generated file.
- Personal Codex config, `AGENTS.md`, or history would otherwise reach the run. Throwaway `CODEX_HOME` (or equivalent) prevents that; if research finds that is impossible, the spec stops for a person to decide.
- Promoting fixtures from Codex runs is refused until Phase 16.
- The configured judge for harness runs in this phase is Cursor with Luna. Codex also gains a one-shot ask (no tools, throwaway home) so a later change can set the judge to Codex without another driver change.
- Install or load failures block completion and are fixed in this spec; skill-behavior failures are recorded in findings, not fixed (except the storage-contract wording required by FR-002).

## Requirements *(mandatory)*

### Functional Requirements

**Clarify-first decisions (before planning continues)**

- **FR-001**: Codex storage enforcement MUST be effects-based: run sandboxed with network off and writes limited to the project (and attempt home as needed for install). A shell request MUST pass when its effect is an in-project read or write, or an in-project build/test command under the project root. An outside-path read/write, a `git` command, or a network-facing install MUST fail the attempt (before run when the SDK can refuse, otherwise recorded and failed afterward).
- **FR-002**: `skills/highway-experience/references/storage-contract.md` MUST gain MINOR wording that Local mode may use the agent’s shell when that is how the agent reads and writes project files, without weakening outside-project, `git`, or arbitrary-script bans. highway-experience MUST take a MINOR version bump; adapters and the plugin MUST be regenerated.

**Spike / research**

- **FR-003**: Planning MUST record answers for: throwaway `CODEX_HOME` (or equivalent) isolation; local plugin install from `.codex-plugin/plugin.json` and acceptance of its `interface` block; sandbox and approval modes and whether any request can be refused before it runs; thread events for messages, command runs, file changes, and usage; how questions are asked (tool vs end of turn); model listing and auth key (`OPENAI_API_KEY` or the SDK’s variable). A question with no workable answer MUST stop the spec for a person to decide.
- **FR-004**: Research MUST pin `models.codex` to the Luna model already used for Copilot/Cursor confirmation. Prefer the exact `gpt-5.6-luna` id when the key’s Codex model list includes it; otherwise pin the closest listed Luna-family / GPT-5.6 equivalent and document that mapping in `research.md`. Do not leave the model unpinned to an SDK default.

**Driver**

- **FR-005**: The harness MUST gain one Codex driver (`codex`) and one registry entry, including a one-shot ask with no tools (throwaway home) for judging and the reply fallback. The runner MUST NOT import the Codex SDK directly.
- **FR-005a**: For any harness runs in this phase (including Codex confirmation and the judge), the configured judge MUST be Cursor with the Luna model (`judge.agent` = `cursor`, judge model = the Luna id already used as `models.cursor` / Copilot Luna). Default scenario agent for confirmation remains `codex` with Luna per FR-004.
- **FR-006**: Each attempt MUST use a throwaway Codex home and temporary project, install `highway-agent-plugin/` locally, and pass shared install checks (name `highway`, 16 skills, no warning, enabled).
- **FR-007**: The driver MUST map command runs and file changes to the neutral request, transcript, experience-order skill activation (including highway-experience `SKILL.md` reads), and usage.
- **FR-008**: Enforcement MUST match FR-001. Unit tests MUST cover allowed project read, allowed project write, allowed in-project build/test, outside write, `git`, and network-facing install.
- **FR-009**: Auth MUST use the key research selects. Missing or refused keys MUST produce existing `missing-token` / `no-access` outcomes naming that key and Codex.
- **FR-010**: Each scripted reply MUST be one send on the same agent, then wait; the agent MUST be disposed after the attempt.

**Manifests and skills**

- **FR-011**: No new manifest MUST be added. A rejected Codex manifest field MUST be fixed in the Phase 6 source/generator.
- **FR-012**: No skill, template, fixture, or scenario MUST change except the storage-contract wording and highway-experience MINOR bump required by FR-002 (plus regenerate). Other skill-behavior failures MUST be recorded in findings, not fixed. Install/load failures MUST block completion and MUST be fixed here.

**Tests, live runs, findings**

- **FR-013**: Unit tests with a fake Codex SDK MUST cover event mapping, each enforcement outcome in FR-008, install checks, question handling, the one-shot ask (no tools, throwaway home), and error classification. New tests MUST be observed failing before the behavior is marked complete. Existing Copilot/Cursor tests MUST keep passing.
- **FR-014**: After the full bash suite and harness unit tests pass, two `--agent codex --smoke` runs and one `--agent codex --skills highway-codify` run MUST complete using the pinned Luna model (FR-004) and the configured parallel attempt count (same as Copilot/Cursor). A Codex-specific serial override is allowed only when research proves parallel isolation is unsafe, and that override MUST be recorded in `research.md`. Logs MUST be saved as `specs/252-codex-driver/harness/smoke-1.log`, `smoke-2.log`, and `codify.log`. No secret, token, or temporary path MUST appear in a committed log. Judge for those runs MUST be Cursor/Luna per FR-005a.
- **FR-015**: `harness-model-findings.md` MUST gain a Codex driver section for this spec’s runs; Codex-specific failures open new findings; matching failures gain Runs lines.

**Docs and governance**

- **FR-016**: `harness/README.md` MUST describe Codex key, model, install, enforcement, and likely-cause rows.
- **FR-017**: The development constitution’s Harness Toolchain MUST name the Codex SDK, with a MINOR bump.
- **FR-018**: When done, `rollout-plan.md` MUST mark Phase 9 complete with a Status paragraph, and `standard-alignment.md` MUST record the outcome where that document tracks agent rollout.

### Key Entities

- **Codex driver**: maps the Codex SDK to shared harness shapes under the chosen enforcement.
- **Registry entry**: agent id `codex`, key(s), driver, classifier, read roots, versions, and one-shot ask.
- **Attempt isolation**: throwaway Codex home and temporary project.
- **Enforcement rule**: the FR-001 decision applied to shell and file-change effects.
- **Committed run log**: standard-output record under `specs/252-codex-driver/harness/`.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In both confirmation smoke runs, every attempt that reaches install reports Highway installed with 16 skills.
- **SC-002**: Unit tests prove outside write, `git`, and network-facing install each fail under the chosen enforcement, while in-project read, write, and build/test succeed.
- **SC-003**: Two smoke logs and one codify log exist under this spec’s harness folder with no secrets or temporary absolute paths.
- **SC-004**: Every failed scenario in those runs is mapped in `harness-model-findings.md` (Runs line or new finding).
- **SC-005**: The full bash suite and harness unit tests pass after the changes.
- **SC-006**: A maintainer can start a Codex smoke using only README instructions for key and model (Luna).

## Assumptions

- Standing constraints: no commit unless asked; secrets redacted; `rollout-plan.md` stays gitignored / distribution-excluded; `mv` not `git mv`; MINOR bumps only; no backward compatibility.
- Confirmation scenario agent is Codex with Luna (FR-004). Configured judge for harness runs is Cursor with Luna (FR-005a). Codex one-shot ask is implemented now for a future judge switch.
- Shared parallel count and redaction rules stay as configured; serial only if research proves Codex parallel isolation is unsafe (FR-014).
- Phase 7’s Cursor effects-based decision informed FR-001; Codex adapts it so shell may perform in-project reads/writes.
- Public Codex marketplace install remains Phase 14.
