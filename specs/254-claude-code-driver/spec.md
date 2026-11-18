# Feature Specification: Claude Code Driver

**Feature Branch**: `254-claude-code-driver`

**Created**: 2026-11-18

**Status**: Draft

**Input**: User description: "create a new spec to implement Phase 8 of rollout-plan.md" (corrected from an initial Phase 9 request)

Phase 8 of `rollout-plan.md`: the behavioral test harness drives Claude Code through the Claude
Agent SDK (`@anthropic-ai/claude-agent-sdk`), from the Highway plugin built in Phases 4 and 6.
Each attempt uses a throwaway config/home so personal `CLAUDE.md`, settings, and memory never
reach a run. The shared runner, permission policy, install checks, and report from Phase 5 stay
unchanged; this spec adds one Claude driver and one registry entry for `--agent claude`.

Claude Code exposes tools such as Read, Write, Edit, Glob, Grep, Bash, and WebFetch. Each tool
request is mapped through the SDK’s per-tool permission callback to the harness’s neutral request
shape so the shared storage rules apply. A tool with no path is `other`.

Live confirmation uses a pinned Claude **Haiku** model as `models.claude` (research records the
exact id the key can use). The configured judge for harness runs stays Cursor with Luna (already
set for Codex phases) so verdicts stay comparable; Claude also gets a one-shot ask so it can be
used as judge or reply fallback later without another driver change.

Out of scope: public marketplace listing (Phase 14); promoting fixtures from Claude runs; any
skill, template, fixture, or scenario change; Cursor cloud (Phase 20); Antigravity / Gemini;
reopening completed Codex Phase 9 except as findings background.

## Clarifications

### Session 2026-11-18

- Q: Should every Claude Code Bash tool request fail the attempt under Local mode, or may
  in-project build/test through Bash still be allowed? → A: Reject every Bash request (fail
  before run when possible; effects backup otherwise).
- Q: Which Claude model should research pin as `models.claude` for live harness runs? → A:
  Current Haiku (research pins the current Haiku id the key can use).
- Q: Must each confirming Claude smoke meet a minimum pass count, or is Phase 8 done when every
  attempt installs 16 skills and every failure is classified? → A: No numeric smoke floor —
  install 16 skills every attempt; classify all failures; suite green.
- Q: Does the required highway-codify confirmation run need a minimum pass count this phase? → A:
  No numeric floor — save log; map every failure class to findings.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - A maintainer runs the smoke set on Claude Code (Priority: P1)

A maintainer runs the harness with `--agent claude --smoke` after the suite and harness tests
pass. Every attempt installs Highway named `highway` with all 16 skills, the storage rules are
enforced through Claude’s permission callback (with effects backup if a request cannot be refused
before run), and the run finishes with a log the maintainer can commit.

**Why this priority**: This is the exit of Phase 8. Without a live Claude smoke that installs and
drives Highway under the storage rules, Claude Code is not a supported harness agent.

**Independent Test**: Run two `--agent claude --smoke` runs, save each log under this spec’s
`harness/` folder, and confirm every attempt installed `highway` with 16 skills and every failure
is classified in `harness-model-findings.md`. There is no minimum pass count for smoke this phase.

**Acceptance Scenarios**:

1. **Given** `claude` is registered and a current Haiku model is pinned as `models.claude`,
   **When** a run starts with `--agent claude --smoke`, **Then** every attempt uses that model, a
   throwaway Claude config/home, and its own temporary project.
2. **Given** each attempt, **When** the plugin is installed from the local build, **Then** the
   shared install checks pass: name `highway`, skill count 16, no warning, enabled, and Claude
   Code accepts the generated `.claude-plugin/plugin.json`.
3. **Given** a tool request from Claude Code, **When** the permission callback runs, **Then**
   reads inside the project and the installed plugin are allowed, writes inside the project are
   allowed, and **every Bash request**, memory, and outside writes are rejected before they run
   when the SDK allows it; when it does not, those requests are recorded and the attempt fails
   afterward. In-project build/test through Bash is not allowed (Claude has Read/Write/Edit).
4. **Given** two completed smoke runs, **When** their logs are read at
   `specs/254-claude-code-driver/harness/smoke-1.log` and `smoke-2.log`, **Then** every attempt
   installed `highway` with 16 skills, no secret or temporary path appears, and each failure is
   matched to a finding in `harness-model-findings.md` (pass count is recorded, not gated).
5. **Given** those live runs, **When** they execute, **Then** they use the same configured
   parallel attempt count as other agents unless research recorded a serial override.

---

### User Story 2 - Claude plugs into the harness without changing the runner (Priority: P1)

A developer adds one Claude driver and one registry entry. The runner, shared permission policy,
install checks, key/error handling, and report take what they need from the registry.

**Why this priority**: Phase 5 established that each driver phase adds one driver file. Changing
the runner here would force every later driver to repeat that work and risk breaking Copilot,
Cursor, and Codex.

**Independent Test**: Register Claude, run harness unit tests with a fake Claude Agent SDK, and
confirm the runner needed no change beyond accepting the new registry entry.

**Acceptance Scenarios**:

1. **Given** the registry, **When** `--agent claude` is selected, **Then** the runner takes
   Claude’s driver, key variable, install, error classifier, read roots, versions, and one-shot
   ask from that entry, and does not import the Claude Agent SDK itself.
2. **Given** Claude tool uses (Read, Write, Edit, Glob, Grep, Bash, WebFetch, and others),
   **When** the driver maps them, **Then** they become the neutral request shape (a tool with no
   path is `other`), transcript entries, skills-invoked / skills-before-output (including a Skill
   tool or a read of highway-experience’s `SKILL.md`), and usage totals from the result message.
3. **Given** Claude’s install result, **When** the shared checks run, **Then** success, a short
   skill count, a warning, and a disabled plugin each produce the same `plugin-install` outcomes
   as other agents.
4. **Given** a missing or refused `ANTHROPIC_API_KEY`, **When** the run starts, **Then**
   `missing-token` or `no-access` names that variable and Claude.
5. **Given** Claude’s registry entry, **When** a run sets the judge agent to `claude` (or uses
   Claude for the reply fallback), **Then** the one-shot ask works with no tools and no plugin,
   in its own throwaway home. The configured judge stays Cursor with Luna.
6. **Given** overload or rate-limit errors from Claude, **When** they are classified, **Then**
   they map onto the existing retry and stop rules.

---

### User Story 3 - Questions and turns work under Claude Code (Priority: P2)

A scenario that asks the person a question still gets its scripted reply. If Claude has an
ask-the-user tool, the driver answers it; otherwise the turn ends and the existing reply loop
answers.

**Why this priority**: Highway skills ask questions. A driver that cannot answer them cannot run
smoke past the first interactive skill.

**Independent Test**: Fake-SDK unit tests cover a question answered through Claude’s mechanism and
a question left for the reply loop; live smoke exercises real questions.

**Acceptance Scenarios**:

1. **Given** research finds an ask-the-user tool, **When** Claude asks a question the scenario
   has a reply for, **Then** the driver answers it on the same session and the attempt continues.
2. **Given** research finds no ask-the-user tool, or the tool is unused, **When** the turn ends
   with an unanswered question, **Then** the existing reply loop answers on the next send.
3. **Given** each scripted reply, **When** it is sent, **Then** it is one send on the same
   session for that attempt (multi-turn stream or resume — research picks one), then wait for
   that turn to finish.

---

### User Story 4 - The gated skill and findings are covered (Priority: P2)

After the two smoke runs, a maintainer runs Claude once on highway-codify. Failures that match an
existing finding gain a Runs line; Claude-specific failures become new findings.

**Why this priority**: Smoke alone does not exercise highway-codify’s gated path.

**Independent Test**: Run `--agent claude --skills highway-codify`, read the committed log, and
check `harness-model-findings.md`.

**Acceptance Scenarios**:

1. **Given** the two smoke runs completed, **When** `--agent claude --skills highway-codify`
   runs, **Then** every attempt installs `highway` with 16 skills and the log is saved as
   `specs/254-claude-code-driver/harness/codify.log` (no numeric pass floor this phase).
2. **Given** a failure that matches an existing finding, **When** findings are updated, **Then**
   that finding gains a Runs line naming this Claude run.
3. **Given** a failure specific to Claude’s model or tools, **When** findings are updated,
   **Then** a new finding is opened in the established format, with a Proposed resolution.
4. **Given** an install or load failure, **When** it appears, **Then** it blocks completion and
   is fixed in this spec. A skill-behavior failure is recorded, not fixed.

---

### User Story 5 - Claude Code is documented and governed (Priority: P3)

A maintainer reading `harness/README.md` learns how to set Claude’s key and model, how the plugin
is installed, and how the permission policy applies. The development constitution’s Harness
Toolchain names the Claude Agent SDK. The rollout plan marks Phase 8 complete.

**Why this priority**: Later driver phases and anyone running Claude need the setup written once.

**Independent Test**: Read the README, constitution, and rollout plan for Claude / Phase 8 Status.

**Acceptance Scenarios**:

1. **Given** `harness/README.md`, **When** a maintainer looks up Claude, **Then** it names the
   key variable, the model, the install, the policy notes, and the likely-cause rows for Claude.
2. **Given** the development constitution, **When** its Harness Toolchain is read, **Then** it
   names the Claude Agent SDK, and its version has a MINOR bump.
3. **Given** the work is done, **When** `rollout-plan.md` is read, **Then** Phase 8 is marked
   complete with a Status paragraph, and `standard-alignment.md` records the phase outcome where
   that document tracks agent rollout.

---

### Edge Cases

- Every Bash request fails the attempt (clarify). The SDK may still fail to refuse before run; this
  phase prefers the permission callback, with effects-based recording and attempt failure afterward
  as backup. Local-mode bans on outside paths stay; Claude does not get Codex-style in-project
  build/test-through-shell allowances.
- Claude rejects or ignores a field in `.claude-plugin/plugin.json`. The fix is in
  `framework/plugin/` and the generator, never in the generated file.
- Both `.claude-plugin/plugin.json` and the root `plugin.json` are present. Research records which
  Claude Code reads; smoke proves Highway still installs as `highway` with 16 skills.
- Personal `CLAUDE.md`, settings, or memory would otherwise reach the run. The attempt uses an
  empty setting-source list and a config folder in the agent home (for example `CLAUDE_CONFIG_DIR`)
  so none of them do. If research finds that is impossible, the spec stops for the person to decide.
- A tool with no path maps to `other` and follows the shared policy for that kind.
- `sk-ant-` keys are already covered by the existing `sk-` redaction pattern; live logs MUST still
  show no secrets.
- Promoting fixtures from a Claude run is refused until Phase 16.
- Codex Phase 9 and F32 remain background; this phase does not reopen them except as findings
  context when Claude hits a shared failure class.

## Requirements *(mandatory)*

### Functional Requirements

**Spike (before planning continues)**

- **FR-001**: Planning MUST begin only after `research.md` answers every driver question for
  Claude Code: throwaway home / `CLAUDE_CONFIG_DIR` (or equivalent) and empty setting sources;
  local plugin install by path and which manifest is read; per-tool permission callback mapping
  for Read, Write, Edit, Glob, Grep, Bash, WebFetch, and others; ask-the-user questions; stream
  events for assistant text, tool use, Skill invocations, and result usage/cost; multi-turn vs
  resume; error and rate-limit mapping; model pinning and listing. A question with no workable
  answer MUST stop the spec for the person to decide.
- **FR-002**: Research MUST record how installed skills are named and where their files sit (the
  read root) under the throwaway home.
- **FR-003**: Research MUST pin a **current Haiku** model id the `ANTHROPIC_API_KEY` can use as
  `models.claude`, and record the exact id (and any remap if the listed name differs) in
  `research.md`.

**Driver**

- **FR-004**: The harness MUST gain one Claude driver and one registry entry for `claude`,
  including a one-shot ask with no tools for judging and the reply fallback. The configured judge
  MUST stay Cursor with Luna. The runner MUST NOT import the Claude Agent SDK directly.
- **FR-005**: Each attempt MUST create one Claude Code session against the temporary project as
  working directory, with the pinned model and isolation so personal Claude settings and memory
  stay out.
- **FR-006**: Each attempt MUST install `highway-agent-plugin/` from the local path into that
  attempt’s agent home (Claude’s local plugin-by-path mechanism), then run the shared install
  checks (name `highway`, skill count matches the build, no warning, enabled).
- **FR-007**: The driver MUST map Claude’s stream events and tool uses to the shared transcript
  entries, the neutral permission request (no-path tools → `other`), the skills-invoked and
  skills-before-output records, and usage totals.
- **FR-008**: Each scripted reply MUST be one send on the same session for that attempt, followed
  by waiting for that turn to finish. The session MUST be disposed after the attempt.
- **FR-009**: Auth MUST use `ANTHROPIC_API_KEY` from `harness/.env`. Missing or refused keys MUST
  produce the existing `missing-token` and `no-access` outcomes, naming that variable and Claude.
- **FR-010**: Storage enforcement MUST prefer the SDK per-tool permission callback. **Every Bash
  tool request MUST be rejected** (fail before run when possible). If research finds Bash or
  another forbidden tool cannot be refused before run, the driver MUST record it and fail the
  attempt afterward (effects backup). In-project build/test through Bash MUST NOT be allowed.
  Outside paths and other Local-mode bans MUST NOT be weakened.
- **FR-011**: Overload and rate-limit errors MUST map onto the existing retry and stop rules.

**Configuration and registry**

- **FR-012**: `harness.config.json` MUST gain a `models.claude` entry for the chosen model. The
  judge block MUST stay Cursor with Luna unless a later clarify changes it.
- **FR-013**: `--agent claude` MUST be accepted once the driver is registered. An unregistered
  agent MUST still exit 2 as today.

**Manifests and skills**

- **FR-014**: No new manifest MUST be added. If Claude rejects or ignores a field in the
  generated `.claude-plugin/plugin.json`, the fix MUST be in the Phase 6 source and generator,
  never in the generated file. `marketplace.json` waits for Phase 14.
- **FR-015**: No skill, template, fixture, or scenario MUST change. A skill-behavior failure MUST
  be recorded in findings, not fixed. An install or load failure MUST block completion and MUST
  be fixed in this spec.

**Tests**

- **FR-016**: Unit tests with a fake Claude Agent SDK MUST cover: event mapping; each policy
  decision through the permission callback (including that Bash is always rejected); install
  checks (success, short count, warning, disabled); a question answered or left to the reply
  loop; the one-shot ask (no tools, throwaway home); and error mapping, including rate-limit /
  overload cases.
- **FR-017**: The registry tests MUST accept `claude`. Existing Copilot, Cursor, and Codex tests
  MUST keep passing.
- **FR-018**: Each new test MUST be observed failing for the behavior it covers before that
  behavior is marked complete.

**Live runs and findings**

- **FR-019**: After the full suite and the harness tests pass, two `--agent claude --smoke` runs
  MUST complete, then one `--agent claude --skills highway-codify` run. Those live runs MUST use
  the same configured parallel attempt count as other agents unless research proves unsafe. Their
  standard-output logs MUST be saved as `specs/254-claude-code-driver/harness/smoke-1.log`,
  `smoke-2.log`, and `codify.log`. No secret, token, or temporary path MUST appear in a committed
  log.   Confirming smokes and the highway-codify run have **no numeric pass floor** this phase: Phase 8
  exit is met when every attempt installs 16 skills, storage rules are enforced, the suite and
  harness tests are green, and every failure is classified in findings.
- **FR-020**: `--transcripts` MUST be used only outside the repository for a deep dive. The
  committed record is the run log.
- **FR-021**: `harness-model-findings.md` MUST gain a Claude Code driver section for this spec
  mapping each scenario to its findings. Claude-specific failures MUST open new findings;
  failures that match an existing finding MUST gain a Runs line.

**Docs and governance**

- **FR-022**: `harness/README.md` MUST describe Claude’s setup, key, model, install, policy
  notes, and likely-cause rows.
- **FR-023**: The development constitution’s Harness Toolchain MUST name the Claude Agent SDK,
  with a MINOR version bump.
- **FR-024**: When the work is done, `rollout-plan.md` MUST mark Phase 8 complete with a Status
  paragraph, and `standard-alignment.md` MUST record the phase outcome where that document tracks
  agent rollout.

### Key Entities

- **Claude driver**: the one new driver that maps the Claude Agent SDK to the shared harness shapes.
- **Registry entry**: the `claude` agent id, `ANTHROPIC_API_KEY`, driver, classifier, read roots,
  versions, and one-shot ask.
- **Attempt isolation**: each attempt’s throwaway Claude config/home and temporary project.
- **Installed plugin read root**: the folder under the agent home where Claude places Highway’s
  skills after install.
- **Committed run log**: the standard-output record of a live Claude run under this spec’s folder.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Every attempt in both Claude smoke runs and the highway-codify run installs Highway
  named `highway` with 16 skills.
- **SC-002**: No Claude attempt completes a Bash request, memory use, or outside write without
  that request being rejected before it runs, or recorded with the attempt failed afterward under
  effects backup (FR-010).
- **SC-003**: The full bash suite and the harness unit tests pass after the change, including the
  new Claude cases.
- **SC-004**: Every failure in the three live Claude runs is classified in
  `harness-model-findings.md`, with no unclassified failure left. A low smoke pass count alone
  MUST NOT block Phase 8 exit when SC-001, SC-002, SC-003, and this classification hold.
- **SC-005**: Each committed run log is under 100 KB and holds no secret, token, or temporary
  path.
- **SC-006**: A maintainer can select Claude with `--agent claude` and get the configured Claude
  model without editing other agents’ models or the judge.
- **SC-007**: Copilot, Cursor, and Codex existing harness behavior is unchanged: their unit tests
  pass, and `--agent copilot` remains the default.

## Assumptions

- Phases 5 and 6 are complete. The plugin already holds `.claude-plugin/plugin.json`. Phases 7 and
  9 (Cursor and Codex) are complete; this phase adds Claude alongside them.
- The spike in FR-001 happens during `/speckit-plan` Phase 0 (`research.md`) before design
  artifacts are finalized.
- `models.claude` is a current Haiku id chosen during research from models the
  `ANTHROPIC_API_KEY` can use (not Luna — Luna remains the Cursor judge model). Haiku may raise
  skill-follow fails relative to Sonnet; those are recorded in findings, not fixed as skill edits.
- The configured judge stays Cursor with Luna so verdicts stay comparable with recent Codex runs.
  Claude’s one-shot ask is wired for later judge/fallback use.
- Claude live runs use the shared parallel setting unless research proves serial is required.
- Confirming smokes and highway-codify have no numeric pass floor this phase (install + classify +
  suite green).
- The three committed run logs for this spec are named `smoke-1.log`, `smoke-2.log`, and
  `codify.log` under `specs/254-claude-code-driver/harness/`.
- The Claude Agent SDK is added only under `harness/`, which stays out of the distribution.
- Constraints: do not commit unless asked; secrets redacted; `rollout-plan.md` stays gitignored /
  distribution-excluded; MINOR bumps only; no backward compatibility; use `mv`, not `git mv`; no
  skill change.
