# Feature Specification: Harness Failure Resolutions

**Feature Branch**: `main`

**Created**: 2026-11-12

**Status**: Draft

**Input**: User description: "create a spec to include your proposed resolutions for F1-F2, F4-F6, F8-F14." The findings and their proposed resolutions are recorded under `# Harness Failures` in `harness-model-findings.md` at the repository root. They come from five live runs on GPT-5.6 Luna: the baseline smoke `20261112-162017Z-smoke-49ab958`, the post-change smoke `20261112-170628Z-smoke-49ab958`, the Option B affected run `20261112-171321Z-targeted-49ab958`, and the S1 reruns `20261112-181837Z-targeted-49ab958` and `20261112-182131Z-targeted-49ab958`. F3, F7, and F15 are not in this spec.

## Clarifications

### Session 2026-11-12

- Q: Should this spec move highway-objectives' records from `library/objectives/` to `library/governance/objectives/`, to match controls and NFRs? → A: No. The layout stays as it is; the storage-contract change resolves F10.
- Q: Should GitHub Copilot join Cursor, VS Code, Claude, and Codex as an agent-platform name highway-onboarding's session may identify? → A: Yes.
- Q: When highway-codify-config was opened for one named platform, should declining coding standards end the run? → A: No. The skill keeps its path through the platform list and the menu, and codify-config-smoke answers both.
- Q: Does this spec need a harness run before the changes? → A: No. Spec 242's last captured runs are the baseline. The harness runs only after the changes, as the final step.
- Q: When the final harness runs show a scenario failing for a reason outside F3, F7, or F15, does that block finishing the spec? → A: No. A pass on either attempt counts, flaky included. Any other failure is recorded as a new finding in `harness-model-findings.md`, and the maintainer decides whether it blocks.
- Q: Which scenarios should the final affected run include, besides the smoke run? → A: Every scenario the harness selects with `--changed-since main`, plus any listed scenario that selection leaves out.
- Q: Should the line that marks a reply-class list as an instruction go only into highway-implementation, or into every skill that has such lists? → A: highway-implementation only. Other skills follow if a run shows the same leak.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - A person who names a record or supplies material is not asked again (Priority: P1)

A person opens a skill with the title of the record they want, such as `/highway-adr Restock alerts`, and the skill selects that record instead of listing every record (F1). A person setting up the Profile pastes a description of the organization that includes a website link the agent cannot reach, and the skill builds the Profile from the pasted text instead of asking what the organization does (F2).

**Why this priority**: Both failures make the person repeat something they already said. F1 failed adr, architecture, discovery, and implementation smoke runs in four of five runs. F2 failed profile-smoke and setup-smoke in every run, and it shifts every later reply in those scripts, so the F4 script fixes cannot pass until it is fixed.

**Independent Test**: Run adr-smoke, architecture-smoke, discovery-smoke, implementation-smoke, profile-smoke, and setup-smoke live, and read each transcript.

**Acceptance Scenarios**:

1. **Given** a skill named in F1 and an opening that holds the exact title of one record in the state the skill needs, compared without regard to case, **When** the skill starts, **Then** it selects that record and does not show the list.
2. **Given** an opening whose title matches no record, or matches more than one, **When** the skill starts, **Then** it shows the list as it does today.
3. **Given** highway-profile at `offer` and a reply holding pasted text with a link that cannot be retrieved, **When** the skill continues, **Then** it says once that the link could not be read, and builds the Identity proposal from the text without asking what the organization does.
4. **Given** highway-profile at `offer` and a reply that supplies nothing usable, **When** the skill continues, **Then** it asks what the organization does, as it does today.

---

### User Story 2 - The skill trusts the file it reads, not a search (Priority: P1)

A person runs a skill in a repository where setup is complete. The skill checks its seeded files by reading each one at its exact path, and so it never says "Oops... we need to setup your repository" when the files are there (F6). highway-objectives, highway-controls, and highway-nfrs read each record their catalog indexes at its path, and so never report a present record as missing (F10). No skill runs a shell command to list or create a folder (F12).

**Why this priority**: A false "Oops" stops the person before the first question and tells them to redo setup. The transcripts show Copilot's `glob` tool reporting "No files matched" for files that exist, in both F6 and F10. One change to the storage contract in highway-experience covers every skill that reads through it.

**Independent Test**: Run codify-smoke, codify-code-project, discovery-smoke, implementation-smoke, request-smoke, chain-implementation, objectives-smoke, controls-smoke, nfrs-smoke, codify-integration, codify-plan-review, and profile-smoke live. Search each transcript for the setup-needed message, a missing-record claim, and a rejected shell request.

**Acceptance Scenarios**:

1. **Given** a fixture holding every seeded file a skill checks, **When** the skill starts, **Then** it does not emit the setup-needed message.
2. **Given** the storage contract, **When** it is read, **Then** it says that checking whether a file exists means reading or checking that exact path, that a search or pattern tool does not decide it, and that a file is absent only when that operation reports it absent.
3. **Given** a governance catalog that indexes a record present at its path, **When** highway-objectives, highway-controls, or highway-nfrs reads it, **Then** the skill does not report the record as missing.
4. **Given** the storage contract's list of what a skill does not do, **When** it is read, **Then** it includes running a shell command, and it says a folder is created by writing a file in it.

---

### User Story 3 - Reviews advance the way the skill text says (Priority: P1)

A person moving through onboarding says "I don't know" about a capability's provider, and the skill helps them move on instead of re-showing the same block (F4, highway-onboarding). A person who accepts a codify proposal sees the plan menu, not an unrequested plan review (F4, highway-codify). A complete implementation record with Language `None` goes straight to codify's proposal (F4, highway-codify). The person sees questions, never the list of reply classes the skill uses to read their answer (F9). Each skill picks the same branch for the same repository state every time (F5).

**Why this priority**: In each case the person is stuck or shown something the skill did not mean to show. Onboarding cannot finish while `map` re-emits its block on `unknown` and on `accept`.

**Independent Test**: Run onboarding-smoke, chain-implementation, chain-codify, codify-no-governance, codify-not-running, implementation-smoke, codify-needed-language, implementation-onboards-platform, and every scenario F5 lists, live.

**Acceptance Scenarios**:

1. **Given** highway-onboarding at `map` with a provider of `Unknown`, **When** the person says they do not know, **Then** the skill asks a question that can move the capability forward, or offers to mark the provider `Does not exist`, and does not re-emit the same block unchanged.
2. **Given** highway-onboarding running in a GitHub Copilot session that identifies itself, **When** `map` reaches AI-Augmented Technology Development, **Then** the provider is GitHub Copilot, not `Unknown`.
3. **Given** highway-codify after `check` finds no gap, **When** it continues, **Then** it emits the `menu` and does not show the plan until the person selects 1.
4. **Given** an implementation record whose Deployed by and Managed by name a platform with a row and whose Language is `None`, **When** highway-codify runs `record check`, **Then** it judges the record complete.
5. **Given** a reply-class list in highway-implementation, **When** the skill runs, **Then** the list is introduced as an instruction and its text does not appear in the agent's reply.
6. **Given** a skill F5 names and a fixture state, **When** the skill selects its first branch, **Then** the text allows only one branch for that state, and the scenario's script expects that branch.

---

### User Story 4 - The harness reports service and model behavior for what it is (Priority: P2)

A maintainer reads a harness report. A Copilot service error is retried once and, if it persists, reported as blocked by the service rather than as a skill failure (F8). An agent that loads highway-experience by reading its `SKILL.md` before the first output passes the activation check (F11). A message the skill gives exactly passes when its words match, whether or not the agent kept the bold (F13).

**Why this priority**: Each of these makes a report show a skill failure that is not one, so maintainers chase changes the skills do not need. The skill text stays unchanged for all three.

**Independent Test**: Run the harness unit tests. Run controls-smoke, nfrs-smoke, objectives-smoke, chain-request, codify-not-running, and request-setup-needed live.

**Acceptance Scenarios**:

1. **Given** a turn that ends with session error code -32603, **When** the harness drives it, **Then** it retries that turn once.
2. **Given** a retried turn that fails again with code -32603, **When** the attempt ends, **Then** the report shows it as blocked by the service, named separately from skill failures.
3. **Given** an agent that reads `highway-experience/SKILL.md` before its first output and does not invoke the skill tool, **When** the experience check runs, **Then** it passes.
4. **Given** an agent that shows neither the skill nor that file before its first output, **When** the experience check runs, **Then** it fails as it does today.
5. **Given** a `shows:` line with Markdown emphasis and agent output with the same words without it, **When** the check runs, **Then** it passes. Output with different words still fails.

---

### User Story 5 - Each scenario script follows its skill's text (Priority: P2)

A maintainer runs a scenario whose script was written before the skill's current text. After this change, each script answers every question the skill asks, in the order the text asks it (F4, F9, F14).

**Why this priority**: These scripts fail on skills that behave correctly, which hides real regressions. They depend on User Stories 1 and 3, because F2 and the onboarding change alter what the scripts must answer.

**Independent Test**: Run profile-smoke, setup-smoke, codify-config-smoke, onboarding-smoke, chain-implementation, implementation-smoke, codify-needed-language, implementation-onboards-platform, and codify-platform-no-row live.

**Acceptance Scenarios**:

1. **Given** profile-smoke and setup-smoke, **When** they run, **Then** each accepts the Identity, Vision, Competitive Path, and Guiding Principles reviews, and `library/knowledge/profile.md` is written. setup-smoke then declines at Objectives' first question.
2. **Given** codify-config-smoke, **When** it declines coding standards, **Then** it answers the platform list and the menu that `platform written` and `platforms` lead to.
3. **Given** onboarding-smoke and chain-implementation, **When** they reach the first capability list, **Then** they remove AI-Augmented Technology Development, and every later reply matches a question the skill asks.
4. **Given** each scenario F9 lists, **When** the skill names a Needed field and stays on `start`, **Then** the script answers that question, not "Would you like to return and provide these details now?".
5. **Given** codify-platform-no-row, **When** the skill asks "Would you like to return and provide these details now?", **Then** the script declines.

---

### Edge Cases

- An opening that names both a title and an id selects by id, as `Entry` does today. The title step runs only when no id is named.
- Two records share a title in different states. Only records in the state the skill needs count toward the match, so a single match among them is selected.
- Pasted text with no link at all, and a link that loads, both continue as `offer` does today.
- A read of an exact path fails for a reason other than absence, such as a permission error. The skill reports that failure as the storage contract's operation does, not as a missing file.
- A Copilot service error at a turn that has already written a file. The retry resends that turn, and the harness's existing write checks judge the result.
- A `shows:` line that holds no emphasis compares as it does today.
- F5 diagnosis shows that the text already selects only one branch for a fixture state, and the model picked another. That case is a model finding. The skill text is tightened only when the plan names a wording that removes the choice. The finding records the outcome either way, and a remaining failure follows FR-027.
- F7, an empty reply after accepting, may disappear once F8 and F10 are fixed. It is not in scope, and a run where it appears fails as it does today.

## Requirements *(mandatory)*

### Functional Requirements

**Skill text**

- **FR-001** (F1): The `Entry` step of highway-adr, highway-architecture, highway-discovery, and highway-implementation MUST select a record when the opening names no id and holds the exact title of exactly one record in the state that skill needs, compared without regard to case. Otherwise `Entry` MUST continue as it does today. The step MUST follow the shape of highway-codify's `Entry` step 6.
- **FR-002** (F2): highway-profile's `offer` MUST treat pasted text as supplied material for every domain. When a link in it cannot be retrieved, the skill MUST say so once and continue with the text. It MUST go to `identity.ask` only when nothing usable was supplied.
- **FR-003** (F6, F10): highway-experience's storage contract MUST state that "Check a file exists" and "Read a file" act on the exact path, that a search or pattern tool does not decide whether a file exists, and that a file is absent only when one of those operations reports it absent.
- **FR-004** (F10): highway-objectives, highway-controls, and highway-nfrs MUST read each record their catalog indexes at that record's path, with "Read a file". highway-objectives' records MUST stay in `library/objectives/`.
- **FR-005** (F12): The storage contract's "What a skill does not do" MUST list running a shell command, and the contract MUST say that a folder is created by writing a file in it.
- **FR-006** (F4, onboarding): In highway-onboarding's `map`, the `unknown` reply on a block whose provider is `Unknown` MUST lead forward: the skill asks who builds or runs the capability today, or offers to mark the provider `Does not exist`. It MUST NOT re-emit the same block unchanged. GitHub Copilot MUST join Cursor, VS Code, Claude, and Codex as an agent-platform name the session may identify.
- **FR-007** (F4, codify): highway-codify's `check` step 5 MUST say to go to `menu` and not to show the plan until the person selects 1. `record check` rule 2 MUST say that Language `None` names no standard and is complete.
- **FR-008** (F4, codify-config): highway-codify-config's `platform written`, `platforms`, and `menu` MUST NOT change. A declined coding-standards question still leads to the platform list, then the menu.
- **FR-009** (F5): For each skill F5 names (highway-architecture, highway-codify, highway-discovery, highway-nfrs, and highway-objectives through highway-setup), the work MUST compare each failing scenario's fixture state with the text that selects the first branch, and record the diagnosis in `harness-model-findings.md`, as F4's is. Where one state can select more than one branch, that text MUST be rewritten as a list from state to branch. The diagnosis found one such case: in highway-objectives, highway-controls, and highway-nfrs, `queue` asks the empty-queue question while the queue holds titles, so `queue` MUST ask the question `recommend` gives for a queue that already has titles. Each scenario whose F5 diagnosis is Scenario MUST be aligned with the branch its fixture selects: discovery-smoke, chain-discovery, and chain-architecture.
- **FR-010** (F9): Each reply-class list in highway-implementation MUST be introduced by a line that marks it as an instruction for reading the reply, such as "Classify the reply:". In highway-implementation's `field`, the sentence the skill emits MUST stand apart from the handoff instruction after it, because implementation-onboards-platform showed that instruction to the person. Other skills' reply-class lists MUST NOT change in this spec. A leak seen in another skill in the final runs is recorded under FR-027.

**Scenarios**

- **FR-011** (F4): profile-smoke and setup-smoke MUST accept all four Profile reviews. profile-smoke MAY keep one edit at Vision, followed by an accept of the revised Vision, and MUST drop its trailing `[unknown]` reply. setup-smoke MUST then decline at Objectives' first question. chain-setup MUST also accept all four Profile reviews.
- **FR-012** (F4): After declining coding standards, codify-config-smoke MUST decline the platform list's question, then decline the menu.
- **FR-013** (F4): onboarding-smoke and chain-implementation MUST remove AI-Augmented Technology Development at the first capability list, and their review count MUST match the skill from there. implementation-onboards-platform, which onboards Jenkins, MUST do the same. chain-implementation MUST also decline codify-config's platform list and menu, as FR-012 does.
- **FR-014** (F9): A scenario MUST NOT expect "Would you like to return and provide these details now?" after `start`'s `accept` names a Needed field, because that path stays on `start`. implementation-smoke MUST use the `implementation` stage fixture, whose platform row fills Deployed by and Managed by, so its accept reaches the write; the `architecture` fixture has no platform row, so no implementation can be written there without onboarding. codify-needed-language MUST answer the delivery-platforms question with a decline, then decline the return question. highway-implementation's `start` `accept` on a Needed field MUST re-emit the block, so the person is asked again.
- **FR-015** (F14): codify-platform-no-row MUST answer "Would you like to return and provide these details now?" with a decline.
- **FR-016** (F1, F2, F6): The scenarios MUST keep titles in their openings and the unreachable link in their pasted material, because a person does both.

**Harness**

- **FR-017** (F8): The harness MUST retry a turn once when the session ends it with error code -32603. When the retry fails the same way, the attempt MUST be reported as blocked by the service, with its own failure kind and a hint that names the service, separate from skill failures.
- **FR-018** (F11): The experience check MUST pass when the agent invokes highway-experience, or reads its `SKILL.md`, before the first output. The skills' activation line MUST NOT change.
- **FR-019** (F13): The `shows:` check MUST compare text with Markdown emphasis markers removed from both the expected line and the output. Per D3.5, the change MUST record that it supersedes the exact comparison of emphasis. Skills MUST keep the bold on their exact messages.

**Process**

- **FR-020**: Every behavioral change MUST add or amend a test (D3.3), and each new or amended test MUST be observed failing before the change that makes it pass (D3.6). Skill text changes are asserted by bash tests, and harness changes by the harness unit tests.
- **FR-021**: Every changed skill MUST take one MINOR version bump. Every generated file MUST be regenerated, and a second regeneration MUST change nothing.
- **FR-022**: Before any harness run, the harness model MUST be GPT-5.6 Luna. No harness run happens before the changes. The baseline is spec 242's last captured runs: the post-change smoke `20261112-170628Z-smoke-49ab958` and S1 rerun 2 `20261112-182131Z-targeted-49ab958`, whose transcripts are in the spec 242 folder.
- **FR-023**: The harness MUST run as the final step, after every change is made, the full suite and the harness unit tests pass, and regeneration is done. The final step MUST run a live smoke run and a live run of every scenario the harness selects with `--changed-since main`, plus any scenario the in-scope findings list that this selection leaves out, such as request-setup-needed and chain-request. If a change follows a final run, the final runs MUST be repeated.
- **FR-024**: The transcripts of every final run MUST be captured in the spec 243 folder under `specs/243-harness-failure-resolutions/harness/`, with one folder per run, as in spec 242. Tokens and secrets MUST be redacted, and the Copilot token MUST NOT appear in any captured file.
- **FR-025**: `.gitignore` MUST ignore the transcript folder with the line `specs/243-harness-failure-resolutions/harness/*`, matching spec 242's line, so no transcript is committed.
- **FR-026**: Each in-scope finding's entry in `harness-model-findings.md` MUST record the resolution applied and the final run that confirms it. This update follows the final runs, because it names their run ids. F3, F7, and F15 MUST stay as they are.
- **FR-027**: In the final runs, a scenario that passes on either attempt passes, flaky included. A failure that F3, F7, F15, or a service block does not explain MUST be recorded as a new finding in `harness-model-findings.md`, with its Skill, Runs, Category, Confirmed, and Basis. The spec MAY finish with such a failure, and the maintainer decides whether it blocks. This includes an F5 case diagnosed as model behavior with no wording that removes the choice.

### Key Entities

- **Finding**: One harness failure in `harness-model-findings.md`, with its Skill, Runs, Category, Confirmed, Basis, and Proposed resolution. This spec covers F1, F2, F4, F5, F6, F8, F9, F10, F11, F12, F13, and F14.
- **Storage contract**: The rules in highway-experience for how every skill reads and writes the repository. It defines the four operations, including "Check a file exists" and "Read a file", and the list of what a skill does not do.
- **Scenario script**: A harness `.scenario` file. Its `ask:` and `ask-pattern:` lines match the skill's questions, and its `say:` lines give the person's replies.
- **Failure kind**: The label the harness gives a failed attempt, such as `unmatched-question`, `assertion`, `experience-order`, or `rejected-request`. This spec adds one for a service error that persists after a retry.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In the final live smoke run, every smoke scenario passes on either attempt, flaky included, except where the failure is one of the following. The baseline smoke run, `20261112-170628Z-smoke-49ab958`, passed 6 of 16.
  - Its transcript shows only F3, F7, or F15.
  - The attempt is blocked by the service.
  - The failure is recorded as a new finding under FR-027.
- **SC-002**: In the final affected run that FR-023 defines, the same holds for each scenario.
- **SC-003**: Across all live runs after the changes, 0 attempts emit the setup-needed message in a fixture that holds every seeded file, and 0 attempts report a present governance record as missing.
- **SC-004**: Across all live runs after the changes, 0 attempts are rejected for a shell request, and 0 fail the experience check after reading highway-experience's `SKILL.md` before their first output.
- **SC-005**: Each requirement that changes behavior has a test that was observed failing before the change and passing after it. The full suite and the harness unit tests pass, and a second regeneration changes nothing.
- **SC-006**: 12 findings in `harness-model-findings.md` each record a resolution applied and a confirming run id, and F3, F7, and F15 are unchanged.
- **SC-007**: The final runs' transcripts are in `specs/243-harness-failure-resolutions/harness/`, `git check-ignore` reports that folder ignored, `git status` lists no file under it, and 0 captured files contain the Copilot token.

## Assumptions

- The proposed resolutions under `# Harness Failures` in `harness-model-findings.md`, including the per-skill diagnosis of F4, are accepted as written, except where a clarification above decides otherwise.
- The F6 and F10 cause is Copilot's `glob` reporting present files as missing. Reporting that to Copilot is outside this repository. One live run with `glob` excluded from the harness session may be used to confirm the cause, but it is not required.
- F9's reply-class leak was seen only in highway-implementation, so FR-010 covers that skill. Other skills follow if a run shows the same leak.
- The issue seen in profile-smoke Option B attempt 2, where Competitive Path opened with "To advance toward Nothing has been accepted for Vision yet", is out of scope and is recorded for later work.
- F3, F7, and F15 are out of scope. F3's loops mostly start from F1, F4, and F5, and are expected to drop once those are fixed.
- X2.67 of the Experience Standard requires bold on a question that needs a response. The setup-needed message is not a question, so FR-019 does not conflict with the Experience Standard.
- Live runs need a Copilot token in `harness/.env`, and no token is printed or kept in a transcript.
- Skill versions take MINOR bumps, never MAJOR, and there is no backward compatibility to preserve, because Highway is unreleased.
- Nothing is committed unless the maintainer asks.
