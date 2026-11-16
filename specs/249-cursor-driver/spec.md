# Feature Specification: Cursor Driver

**Feature Branch**: `249-cursor-driver`

**Created**: 2026-11-15

**Status**: Draft

**Input**: User description: "create a new spec to implement phase 7 of rollout-plan.md"

Phase 7 of `rollout-plan.md`: the behavioral test harness drives Cursor, the first agent after Copilot. A maintainer runs every scenario on Cursor through Cursor's own SDK, against a local runtime, with Highway installed from the plugin built in Phases 4 and 6. Each attempt uses a throwaway agent home and a temporary project, so personal rules, memories, and approvals never reach a run. The shared runner, permission policy, install checks, and report from Phase 5 stay unchanged; this spec adds one Cursor driver and one registry entry.

Out of scope: installing Highway from a public marketplace or team listing (Phase 14); promoting fixtures from Cursor runs (Phase 16); any cloud or remote Cursor agent runtime; any skill change; any other agent's driver.

## Clarifications

### Session 2026-11-15

- Q: If research finds Cursor cannot reject a shell command or an outside write before it runs, which path should this phase take? → A: Prefer effects-based enforcement: only the project and agent home are writable; a shell or outside-write request is recorded and fails the attempt afterward. Record the gap for Phase 9.
- Q: Should this phase also wire Cursor so it can be used as the judge agent later (a one-shot ask with no tools), even though the configured judge stays Copilot for now? → A: Yes — also add Cursor’s one-shot ask so `judge.agent` can be set to cursor without another driver change.
- Q: Should Cursor’s live smoke and highway-codify runs use the same parallel attempt count as Copilot, or run one attempt at a time? → A: Same as Copilot — use the configured parallel count (today 4).
- Q: Should this spec lock the three committed log filenames now, or leave naming open until Phase 18? → A: Lock `smoke-1.log`, `smoke-2.log`, and `codify.log` for this spec; Phase 18 can still set a cross-spec rule later.
- Q: If research finds Cursor also supports a cloud or remote agent runtime, should this phase still require the local runtime only? → A: Local only — cloud/remote is out of scope for this phase. If research shows cloud or remote support, add it as another Phase in `rollout-plan.md`.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - A maintainer runs the smoke set on Cursor (Priority: P1)

A maintainer runs the harness with `--agent cursor --smoke` after the suite and the harness tests pass. Every attempt installs Highway named `highway` with all 16 skills, the storage rules are enforced for each tool request, and the run finishes with a log the maintainer can commit.

**Why this priority**: This is the exit of Phase 7. Without a live Cursor smoke run that installs and drives Highway under the storage rules, later phases cannot treat Cursor as a supported agent.

**Independent Test**: Run two `--agent cursor --smoke` runs, commit each log, and confirm every attempt installed `highway` with 16 skills and every failure is classified in `harness-model-findings.md`.

**Acceptance Scenarios**:

1. **Given** a configuration with `cursor` registered and a Cursor model set, **When** a run starts with `--agent cursor --smoke`, **Then** every attempt uses Cursor’s local runtime, that model, and the attempt's own agent home and project.
2. **Given** each attempt, **When** the plugin is installed, **Then** the install checks pass: the plugin is named `highway`, its skill count is 16, it reports no warning, and it is enabled.
3. **Given** a tool request from Cursor, **When** the policy decides it, **Then** reads inside the project and the installed plugin are allowed, writes inside the project are allowed, and shell, memory, and outside writes are rejected before they run when the SDK allows it; when it does not, those requests are recorded and the attempt fails afterward under effects-based enforcement (FR-010).
4. **Given** two completed smoke runs, **When** their logs are read at `specs/249-cursor-driver/harness/smoke-1.log` and `smoke-2.log`, **Then** every attempt installed `highway` with 16 skills, no secret or temporary path appears, and each failure is matched to a finding in `harness-model-findings.md`.

---

### User Story 2 - Cursor plugs into the harness without changing the runner (Priority: P1)

A developer adds one Cursor driver and one registry entry. The runner, the shared permission policy, the install checks, the key and error handling, and the report take what they need from the registry, as the fake second driver in Phase 5 already proved.

**Why this priority**: The point of Phase 5 was that each driver phase adds one driver file. Changing the runner here would force every later driver to repeat that work and risk breaking Copilot.

**Independent Test**: Register Cursor, run the harness unit tests with a fake Cursor SDK, and confirm the runner and shared checks needed no change beyond accepting the new registry entry.

**Acceptance Scenarios**:

1. **Given** the registry, **When** `--agent cursor` is selected, **Then** the runner takes Cursor's driver, key variable, install, error classifier, read roots, versions, and one-shot ask from that entry, and does not import Cursor's SDK itself.
2. **Given** a native Cursor tool request, **When** the driver maps it to the neutral request shape, **Then** the shared policy decides it and the driver maps the decision back through Cursor's mechanism.
3. **Given** Cursor's install result, **When** the shared checks run, **Then** success, a short skill count, a warning, and a disabled plugin each produce the same `plugin-install` outcomes as Copilot.
4. **Given** a missing `CURSOR_API_KEY`, or a key the service refuses, **When** the run starts, **Then** the `missing-token` or `no-access` message names `CURSOR_API_KEY` and Cursor.
5. **Given** a thrown start error or a finished run with status `error`, **When** it is classified, **Then** Cursor's classifier maps it to the existing retry and stop rules, including rate-limit cases the SDK marks as retryable.
6. **Given** Cursor's registry entry, **When** a run sets the judge agent to `cursor` (or uses Cursor for the reply fallback), **Then** the one-shot ask works with no tools and no plugin, in its own throwaway home. The default judge configuration stays Copilot.

---

### User Story 3 - Questions and turns work under Cursor (Priority: P2)

A scenario that asks the person a question still gets its scripted reply. If Cursor has an ask-the-user tool, the driver answers it; otherwise the turn ends and the existing reply loop answers, as it does for Copilot.

**Why this priority**: Highway skills ask questions. A driver that cannot answer them cannot run the smoke set past the first interactive skill.

**Independent Test**: Unit tests with a fake SDK cover a question answered through Cursor's mechanism and a question left for the reply loop; the live smoke runs exercise real questions.

**Acceptance Scenarios**:

1. **Given** research finds an ask-the-user tool, **When** Cursor asks a question the scenario has a reply for, **Then** the driver answers it on the same agent and the attempt continues.
2. **Given** research finds no ask-the-user tool, or the tool is unused, **When** the turn ends with an unanswered question, **Then** the existing reply loop answers it on the next send, as for Copilot.
3. **Given** each scripted reply, **When** it is sent, **Then** it is one send on the same agent for that attempt, followed by waiting for that run to finish.

---

### User Story 4 - The gated skill and the findings are covered (Priority: P2)

After the two smoke runs, a maintainer runs Cursor once on highway-codify, the gated skill. Failures that match a Copilot finding gain a Runs line; failures specific to Cursor's model or tools become new findings. A section for this spec's runs maps each scenario to its findings.

**Why this priority**: Smoke alone does not exercise highway-codify's gated path. Without findings mapped, later work cannot tell Cursor-specific failures from shared ones.

**Independent Test**: Run `--agent cursor --skills highway-codify`, read the committed log, and check `harness-model-findings.md` for the new section and the Runs lines or new findings.

**Acceptance Scenarios**:

1. **Given** the two smoke runs have completed, **When** `--agent cursor --skills highway-codify` runs, **Then** every attempt installs `highway` with 16 skills, and its log is saved as `specs/249-cursor-driver/harness/codify.log`.
2. **Given** a failure that matches an existing Copilot finding, **When** findings are updated, **Then** that finding gains a Runs line naming this Cursor run.
3. **Given** a failure specific to Cursor's model or tools, **When** findings are updated, **Then** a new finding is opened in the established format, with a Proposed resolution.
4. **Given** an install or load failure, **When** it appears, **Then** it blocks completion and is fixed in this spec. A skill-behavior failure is recorded, not fixed.

---

### User Story 5 - Cursor is documented and governed (Priority: P3)

A maintainer reading `harness/README.md` learns how to set Cursor's key and model, how the plugin is installed, and how the permission policy applies. The development constitution's Harness Toolchain names Cursor's SDK. The rollout plan marks Phase 7 complete.

**Why this priority**: The next driver phases and anyone running Cursor need the setup written once, and the toolchain declaration keeps the harness dependency explicit.

**Independent Test**: Read the README, the constitution, and the rollout plan, and confirm each names Cursor's setup or Phase 7 status as required.

**Acceptance Scenarios**:

1. **Given** `harness/README.md`, **When** a maintainer looks up Cursor, **Then** it names the key variable, the model, the install, the policy notes, and the likely-cause rows for Cursor.
2. **Given** the development constitution, **When** its Harness Toolchain is read, **Then** it names Cursor's SDK, and its version has a MINOR bump.
3. **Given** the work is done, **When** `rollout-plan.md` is read, **Then** Phase 7 is marked complete with a Status paragraph, and `standard-alignment.md` records the phase outcome where that document tracks agent rollout.

---

### Edge Cases

- The SDK cannot reject a shell command or an outside write before it runs. This phase uses effects-based enforcement: only the project and the agent home are writable; such a request is recorded and the attempt fails afterward. The gap and the decision are recorded so Phase 9 (Codex) can reuse them.
- Cursor rejects or ignores a field in `.cursor-plugin/plugin.json`. The fix is in `framework/plugin/` and the generator, never in the generated file.
- Both `.cursor-plugin/plugin.json` and the root `plugin.json` are present. Research records which one Cursor reads; the smoke runs prove Highway still installs as `highway` with 16 skills.
- A personal Cursor setting, memory, rule, or saved approval would otherwise reach the run. The attempt uses inline config only and a throwaway home, so none of them do. If research finds that is impossible, the spec stops for the person to decide.
- Research finds a cloud or remote Cursor agent runtime. This phase still uses the local runtime only. Research records the finding and adds a new Phase to `rollout-plan.md` for that runtime; this driver does not implement it.
- A thrown error means the run never started; a finished run with status `error` is an error outcome. Rate-limit cases the SDK marks as retryable follow the existing retry rules.
- Promoting fixtures from a Cursor run is refused until Phase 16, as Phase 5 already requires.
- The judge stays on the configured judge agent and model (Copilot today), so verdicts stay comparable with Copilot runs. Cursor also offers a one-shot ask so a later change can set the judge to Cursor without another driver change.
- `cursor_` key redaction was added in Phase 5; this spec confirms it still covers the live key format and does not weaken it.

## Requirements *(mandatory)*

### Functional Requirements

**Spike (before planning continues)**

- **FR-001**: Planning MUST begin only after `research.md` answers every driver question for Cursor: throwaway home and isolation from personal settings; local plugin install and which manifest is read; permission control before each tool runs; ask-the-user questions; streamed text, tool paths, skill invocations, and usage; model pinning and listing; and whether a cloud or remote agent runtime exists. A question with no workable answer MUST stop the spec for the person to decide. If research finds cloud or remote support, it MUST add a new Phase to `rollout-plan.md` for that runtime and MUST NOT implement it in this phase.
- **FR-002**: Research MUST record which manifest Cursor reads when both `.cursor-plugin/plugin.json` and the root `plugin.json` are present, how installed skills are named, and where their files sit (the read root).
- **FR-003**: Research MUST choose the harness model from the models Cursor lists for the key, and record that choice for `models.cursor` in the harness configuration.

**Driver**

- **FR-004**: The harness MUST gain one Cursor driver and one registry entry for `cursor`, including a one-shot ask with no tools for judging and the reply fallback. The default judge configuration MUST stay Copilot. The runner MUST NOT import Cursor's SDK directly.
- **FR-005**: Each attempt MUST create one Cursor agent on the local runtime only, with the temporary project as its working directory, the pinned model, and inline configuration only, so personal rules, memories, and approvals stay out. Cloud and remote runtimes MUST NOT be used.
- **FR-006**: Each attempt MUST install `highway-agent-plugin/` from the local path into that attempt's agent home, then run the shared install checks (name `highway`, skill count matches the build, no warning, enabled).
- **FR-007**: The driver MUST map Cursor's events and tool calls to the shared transcript entries, the neutral permission request, the skills-invoked and skills-before-output records, and usage totals.
- **FR-008**: Each scripted reply MUST be one send on the same agent for that attempt, followed by waiting for that run to finish. The agent MUST always be disposed after the attempt.
- **FR-009**: Auth MUST use `CURSOR_API_KEY` from `harness/.env`. Missing or refused keys MUST produce the existing `missing-token` and `no-access` outcomes, naming that variable and Cursor.
- **FR-010**: If research finds the SDK cannot reject a shell command or an outside write before it runs, this phase MUST use effects-based enforcement: only the project and the agent home are writable; such a request MUST be recorded and the attempt MUST fail afterward. The gap and this decision MUST be recorded for Phase 9.
- **FR-011**: A thrown start error MUST be mapped through Cursor's retryable and rate-limit signals onto the existing retry and stop rules. A finished run with status `error` MUST be an `error` outcome.

**Configuration and registry**

- **FR-012**: `harness.config.json` MUST gain a `models.cursor` entry for the chosen model. The judge block MUST stay as configured.
- **FR-013**: `--agent cursor` MUST be accepted once the driver is registered. An unregistered agent MUST still exit 2 as today.

**Manifests and skills**

- **FR-014**: No new manifest MUST be added. If Cursor rejects or ignores a field in the generated Cursor manifest, the fix MUST be in the Phase 6 source and generator, never in the generated file.
- **FR-015**: No skill, template, fixture, or scenario MUST change. A skill-behavior failure MUST be recorded in findings, not fixed. An install or load failure MUST block completion and MUST be fixed in this spec.

**Tests**

- **FR-016**: Unit tests with a fake Cursor SDK MUST cover: event mapping; each policy decision through Cursor's mechanism; install checks (success, short count, warning, disabled); a question answered or left to the reply loop; the one-shot ask (no tools, throwaway home); and error mapping, including retryable and rate-limit cases.
- **FR-017**: The registry tests MUST accept `cursor`. Existing Copilot tests MUST keep passing.
- **FR-018**: Each new test MUST be observed failing for the behavior it covers before that behavior is marked complete. A changed assertion MUST record what it supersedes.

**Live runs and findings**

- **FR-019**: After the full suite and the harness tests pass, two `--agent cursor --smoke` runs MUST complete, then one `--agent cursor --skills highway-codify` run. Those live runs MUST use the same configured parallel attempt count as Copilot (no Cursor-specific serial override). Their standard-output logs MUST be saved as `specs/249-cursor-driver/harness/smoke-1.log`, `smoke-2.log`, and `codify.log` respectively, to be committed. No secret, token, or temporary path MUST appear in a committed log.
- **FR-020**: `--transcripts` MUST be used only outside the repository for a deep dive, not as the committed record. The committed record is the run log.
- **FR-021**: `harness-model-findings.md` MUST gain a "Cursor driver smoke for spec 249" section mapping each scenario to its findings. Failures specific to Cursor MUST open new findings; failures that match a Copilot finding MUST gain a Runs line.

**Docs and governance**

- **FR-022**: `harness/README.md` MUST describe Cursor's setup, key, model, install, policy notes, and likely-cause rows.
- **FR-023**: The development constitution's Harness Toolchain MUST name Cursor's SDK, with a MINOR version bump.
- **FR-024**: When the work is done, `rollout-plan.md` MUST mark Phase 7 complete with a Status paragraph, and `standard-alignment.md` MUST record the phase outcome where that document tracks agent rollout. If research already added a cloud/remote Phase under FR-001, that Phase MUST remain in `rollout-plan.md` when Phase 7 is marked complete.

### Key Entities

- **Cursor driver**: the one new driver that maps Cursor's SDK to the shared harness shapes.
- **Registry entry**: the `cursor` agent id, its key variable, driver, classifier, read roots, versions, and one-shot ask.
- **Attempt isolation**: each attempt's throwaway agent home and temporary project, with inline config only.
- **Installed plugin read root**: the folder under the agent home where Cursor places Highway's skills after install, used for allowed reads.
- **Committed run log**: the standard-output record of a live Cursor run, saved under this spec's folder.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Every attempt in both Cursor smoke runs and the highway-codify run installs Highway named `highway` with 16 skills.
- **SC-002**: No Cursor attempt performs a rejected shell command, memory use, or outside write without that request being rejected before it runs, or recorded with the attempt failed afterward under effects-based enforcement (FR-010).
- **SC-003**: The full bash suite and the harness unit tests pass after the change, including the new Cursor cases.
- **SC-004**: Every failure in the three live Cursor runs is classified in `harness-model-findings.md`, with no unclassified failure left.
- **SC-005**: Each committed run log is under 100 KB and holds no secret, token, or temporary path.
- **SC-006**: A maintainer can select Cursor with `--agent cursor` and get the configured Cursor model without editing the Copilot model or the judge.
- **SC-007**: Copilot's existing harness behavior is unchanged: its unit tests pass, and `--agent copilot` remains the default.

## Assumptions

- Phases 5 and 6 are complete. The harness already selects agents, maps a neutral permission request, redacts `cursor_` keys, and refuses fixture promotion from non-Copilot runs. The plugin already holds `.cursor-plugin/plugin.json`.
- The spike in FR-001 happens during `/speckit-plan` Phase 0 (`research.md`) before design artifacts are finalized. Unworkable answers stop planning for a person decision, not this specification. This phase is local-runtime only; a discovered cloud or remote runtime becomes a new rollout-plan Phase, not part of this driver.
- The Cursor model is chosen from the models the key can list during research; `composer-2.5` is the Phase 7 example, not a final choice.
- The judge remains Copilot on its configured model so verdicts stay comparable across agents. Cursor’s one-shot ask is wired so the judge can be switched to Cursor later without another driver change.
- Cursor live runs use the shared parallel setting; this phase does not add a Cursor-specific parallel override. Maintainers may lower the shared setting if a live run shows rate-limit pressure.
- The three committed run logs for this spec are named `smoke-1.log`, `smoke-2.log`, and `codify.log` under `specs/249-cursor-driver/harness/`. Phase 18 may set a cross-spec naming rule later.
- Cursor's SDK is added only under `harness/`, which stays out of the distribution, so it is a harness dependency and not a shipped runtime dependency.
- Constraints carried from earlier work: do not commit unless asked; secrets and tokens are redacted; `rollout-plan.md` stays gitignored and excluded from the distribution; MINOR version bumps only; no backward compatibility; use `mv`, not `git mv`; templates are fixed; no skill change.
