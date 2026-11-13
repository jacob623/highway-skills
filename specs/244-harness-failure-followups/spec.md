# Feature Specification: Harness Failure Follow-ups

**Feature Branch**: `feature/harness-spec243`

**Created**: 2026-11-13

**Status**: Draft

**Input**: User description: "create a new spec with the proposed resolutions for Harness Failures in harness-model-findings.md. After the full suite passes, run the harness against the last commit. Add any failure scenarios that failed in spec 243 but were not covered by the last commit run. Use the runs from spec 243 as the baseline. Capture the transcripts to the new spec folder. Add the transcripts folder to .gitignore. Update harness-model-findings.md as follows: If the Failure is resolved, remove it. If the Failure is not resolved, update it, including the Proposed resolution. If there's a new failure and the proposal does not require investigation, add it to Harness Failures. If it requires further investigation, add it to Research Harness Failures."

The proposed resolutions are under `# Harness Failures` in `harness-model-findings.md` at the repository root: F3, F5, F7, F15, F16, F17, F18, and F21. The findings under `# Research Harness Failures` (F1, F19, F20, and F22) are not resolved here, but the final runs update them. The baseline is spec 243's three final runs on GPT-5.6 Luna, at commit `fe522b4`: smoke `20261113-051531Z-smoke-fe522b4`, affected `20261113-052407Z-targeted-fe522b4`, and request `20261113-054508Z-targeted-fe522b4`. Their transcripts are in `specs/243-harness-failure-resolutions/harness/`. The last commit is `42a0569`, which holds spec 243.

## Clarifications

### Session 2026-11-13

- Q: When a research finding (F1, F19, F20, F22) appears in no final-run attempt, is it removed as resolved? → A: No. It stays, with a line saying it was not seen in spec 244's final runs.
- Q: Does the final step also run the full smoke set? → A: No. It runs the changed-since-`42a0569` selection plus the spec 243 failures, and compares scenario by scenario with the baseline.
- Q: When no unused key matches the agent's question, which replies may the fallback choose from? → A: Only the earliest unused reply in file order, and the fallback judge must confirm it is the same question.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - A finished review always ends with a reply (Priority: P1)

A person runs highway-objectives, highway-controls, or highway-nfrs on its own, and accepts the final review with "Looks good." The skill confirms with one closing line, such as "Your NFRs are recorded.", instead of an empty reply. A person who declines highway-codify-config's offer gets a closing line as well. When highway-setup runs a governance skill, setup's flow continues as it does today, with no extra line (F7).

**Why this priority**: An empty turn is the most frequent failure in spec 243's final runs. All nine -32603 errors came on a turn the skill leaves empty, and two attempts were reported as blocked by the service. To the person, an empty reply looks like a crash.

**Independent Test**: Run controls-smoke, nfrs-smoke, objectives-smoke, codify-config-smoke, and setup-smoke live, and read the last turn of each transcript.

**Acceptance Scenarios**:

1. **Given** a governance skill run on its own at `review`, **When** the person accepts, **Then** the skill emits one closing line and no question, and the turn is not empty.
2. **Given** a governance skill run on its own whose first question the person declines, **When** the skill writes the empty catalog, **Then** it emits one closing line.
3. **Given** a governance skill run by highway-setup, **When** the person accepts the review, **Then** the skill returns to setup and emits nothing else, as it does today.
4. **Given** highway-codify-config with no return step held, **When** the person declines, **Then** the skill writes nothing and emits one closing line.

---

### User Story 2 - Records keep every section their template requires (Priority: P1)

A person writes a Discovery, or an ADR through highway-adr or onboarding. Every heading and table header row in the template appears in the record. A section with no content says `None` under its heading, rather than disappearing (F18).

**Why this priority**: A record without a required section fails the template check and breaks later skills that read it. F18 failed discovery-smoke, chain-discovery, and onboarding-smoke in both attempts.

**Independent Test**: Run discovery-smoke, chain-discovery, and onboarding-smoke live, and check each written Discovery and ADR against its template.

**Acceptance Scenarios**:

1. **Given** a Discovery that eliminates no candidates, **When** it is written, **Then** the record keeps the eliminated-candidates heading and table header row, and says `None` under them.
2. **Given** an onboarding ADR whose Discovery Confidence is `None`, **When** it is written, **Then** it keeps `## Decision Confidence`.
3. **Given** a Discovery with scored options, **When** it is written, **Then** it keeps the Candidate Solution Comparison Matrix and Example tables.

---

### User Story 3 - highway-codify follows its own text at the edges (Priority: P2)

A person who asks codify for an edit that would break a Control is told the Control stays in effect, and sees the proposal again so they can continue (F15). A person who types a bare `/highway-codify` is asked which implementation to serve, not shown the code catalog (F5). A person who asks highway-codify to configure is pointed to highway-codify-config (F5).

**Why this priority**: Each case leaves the person at a dead end, but each appeared in one or two attempts only, and each passed on retry.

**Independent Test**: Run codify-controls-conflict, chain-codify, and codify-configure live.

**Acceptance Scenarios**:

1. **Given** highway-codify at `revise` and an edit that would break a listed Control or NFR, **When** the edit is refused, **Then** the skill re-emits the proposal and stays on `revise`.
2. **Given** an invocation of `/highway-codify` that names nothing, **When** `Entry` runs, **Then** it does not go to `catalog`, and it reaches `choose`.
3. **Given** codify-configure's opening, **When** the scenario runs, **Then** highway-codify is the skill loaded, and it points the person to highway-codify-config.

---

### User Story 4 - Every scenario reply answers the question it was written for (Priority: P2)

A maintainer reads a scenario script and can see which question each reply answers. No reply is a catch-all that answers any question (F3). Assertions check the record the skill wrote, not the fixture's records (F16). Onboarding scenarios answer the provider questions the skill asks for an `Unknown` provider (F21).

**Why this priority**: A catch-all or a wrong assertion fails on a skill that behaves correctly, which hides real regressions.

**Independent Test**: Run every changed scenario live. Search the scenario folder for a catch-all key.

**Acceptance Scenarios**:

1. **Given** the 10 scenarios that hold `ask-pattern: \?`, **When** they are rewritten, **Then** each reply is keyed to the text of the question it answers, and no catch-all remains.
2. **Given** a fixture that already holds one governance record, **When** a scenario checks that the person's addition was written, **Then** the check passes when any record matching the pattern holds the text.
3. **Given** an existing `contains` assertion, **When** it runs, **Then** it still requires every matching file to hold the text.
4. **Given** onboarding-smoke, implementation-onboards-platform, or chain-implementation at `map` with an `Unknown` provider, **When** the skill says it was unable to infer a platform, **Then** the script answers "I don't know.", and then answers **Who builds or runs [Capability title] today?** with "No one.", so the provider becomes `Does not exist`.

---

### User Story 5 - The harness judges each question once, and only the question asked (Priority: P2)

A maintainer reads a harness report. A question the agent asked through the input tool and the harness answered within a turn is not judged again at the end of that turn (F17). When no key matches, the harness never spends a reply written for a later question (F3). A question the agent repeats after its reply was spent is reported as its own failure kind, naming the question (F3).

**Why this priority**: Each of these makes a report show a failure the skill did not cause, or hides the question that caused it.

**Independent Test**: Run the harness unit tests. Run setup-smoke and adr-smoke live.

**Acceptance Scenarios**:

1. **Given** a turn in which the agent asked a question through the input tool and the harness answered it, **When** the turn ends, **Then** only the text after that answer is judged for a question.
2. **Given** a message whose question no unused key matches, **When** the harness falls back, **Then** the only reply it may spend is the earliest unused reply in file order, and only when the fallback judge finds it answers the same question.
3. **Given** an agent that asks again a question whose reply was already spent, and no unused reply matches, **When** the attempt ends, **Then** the failure kind is distinct from `unmatched-question`, and it names the question and the reply that was spent.

---

### User Story 6 - The findings document matches the latest runs (Priority: P3)

A maintainer opens `harness-model-findings.md` after this spec. Resolved failures are gone. Each failure still open says what the final runs showed and what to try next. Each new failure is filed by whether its fix is known or needs investigation.

**Why this priority**: The document is the input to the next spec. It follows the final runs, so it comes last.

**Independent Test**: Compare every attempt in the final runs with the findings document.

**Acceptance Scenarios**:

1. **Given** a finding whose resolution was applied and which no final-run attempt shows, **When** the document is updated, **Then** the finding is removed, and the removal note names it.
2. **Given** a finding a final-run attempt still shows, **When** the document is updated, **Then** its Runs, Basis, and Proposed resolution reflect the final runs.
3. **Given** a failure no finding explains, **When** the document is updated, **Then** it is added as a new finding under `# Harness Failures` when its proposed resolution is a concrete change, or under `# Research Harness Failures` when it needs investigation or more runs.

---

### Edge Cases

- A governance skill reaches `review` through highway-setup. It returns to setup and emits nothing else, so setup's next question follows without a closing line in between.
- A closing line does not stop -32603. F7 stays open, and its Proposed resolution moves to the harness: how an empty final turn is retried and reported.
- A Discovery template placeholder reads "<empty when no candidates are excluded>". The skill's write step governs: the heading and header row stay, and `None` goes under them. The template is not changed.
- codify-choose's `[unknown] I'm not sure.` is keyed to "Which implementation should this automation serve?" and tests the re-ask. It is not a catch-all, and it stays. F3's list of 11 is corrected to 10 when the findings document is updated.
- codify-configure, opened in prose, is still routed by Copilot to highway-codify-config. F5 stays open for that case, with a proposal to retire the scenario.
- A scenario that passed in spec 243's baseline fails both attempts in the final runs. It is a regression until its transcript shows a finding already listed. A regression this spec caused is fixed before the spec finishes.
- A research finding (F1, F19, F20, or F22) that no final-run attempt shows has had no fix applied, so it is not resolved. It stays, and its entry says it was not seen in the final runs.
- A failure that the full suite or a harness unit test catches after a change is fixed before any final run.

## Requirements *(mandatory)*

### Functional Requirements

**Skill text**

- **FR-001** (F7): In highway-objectives, highway-controls, and highway-nfrs, `review` `accept`, the first question's `decline`, and a successful guided `write` MUST emit one closing line that names what was recorded, when highway-setup did not delegate the skill. When highway-setup delegated it, they MUST return `Finished` and emit nothing else, as today.
- **FR-002** (F7): highway-codify-config's `decline` with no return step held MUST write nothing and emit one closing line.
- **FR-003** (F15): highway-codify's refusal line in `references/proposal.md` MUST end by saying to re-emit the proposal and stay on `revise`.
- **FR-004** (F5): highway-codify's `Entry` step 2 MUST say that an invocation naming nothing is not a catalog request.
- **FR-005** (F18): The write step of highway-discovery and highway-adr MUST say to keep every template heading and table header row, and to write `None` under one that has no content. Templates MUST NOT change.

**Scenarios**

- **FR-006** (F3): adr-smoke, architecture-smoke, assessment-smoke, chain-request, codify-control-unmet, codify-standard-unmet, controls-smoke, nfrs-smoke, objectives-smoke, and request-smoke MUST replace each `ask-pattern: \?` with a key taken from the question the reply answers. No scenario MAY keep a key that matches any question.
- **FR-007** (F16): controls-smoke, nfrs-smoke, and objectives-smoke MUST check the person's addition with the assertion FR-012 adds.
- **FR-008** (F21): onboarding-smoke, implementation-onboards-platform, and chain-implementation MUST answer, before their generic accepts, the unable-to-infer prompt with `[unknown] I don't know.`, then **Who builds or runs [Capability title] today?** with "No one.". No scenario MAY script a provider name it has no basis for.
- **FR-009** (F5): codify-configure MUST open with prose that names highway-codify and the word `configure`, so Copilot loads highway-codify.

**Harness**

- **FR-010** (F17): At the end of a turn, the harness MUST judge only the agent text after the last question it answered through the input tool in that turn.
- **FR-011** (F3): When no unused key matches, the fallback MUST be offered only the earliest unused reply in file order, and MUST spend it only when the fallback judge finds it answers the same question. Otherwise the attempt fails as `unmatched-question`. When the agent asks a question whose reply was already spent and no unused reply matches, the attempt MUST fail with its own failure kind, which names the question and the spent reply.
- **FR-012** (F16): The harness MUST add an assertion that passes when any file matching the pattern holds the text. `contains` MUST keep requiring every matching file, so no existing check is weakened (D3.5).
- **FR-013**: `harness/README.md` MUST document the new assertion, the new failure kind, and the end-of-turn rule.

**Process**

- **FR-014**: Every behavioral change MUST add or amend a test (D3.3), observed failing before the change that makes it pass (D3.6). Skill text is asserted by bash tests, and harness changes by the harness unit tests.
- **FR-015**: Every changed skill MUST take one MINOR version bump. Skill source is edited only under `skills/`. Generated files MUST be regenerated, and a second regeneration MUST change nothing.
- **FR-016**: No harness run happens before the changes. The baseline is spec 243's three final runs.
- **FR-017**: The harness MUST run on GPT-5.6 Luna as the final step, after every change is made, the full suite and the harness unit tests pass, and regeneration is done. The final step MUST run every scenario the harness selects for files changed since the last commit, `42a0569`, plus every scenario that had a failed attempt in spec 243's final runs and is not in that selection. If a change follows a final run, the final runs MUST be repeated.
- **FR-018**: The transcripts of every final run MUST be captured under `specs/244-harness-failure-followups/harness/`, one folder per run. Tokens and secrets MUST be redacted, and the Copilot token MUST NOT appear in any captured file.
- **FR-019**: `.gitignore` MUST ignore the transcript folder with the line `specs/244-harness-failure-followups/harness/*`, matching specs 242 and 243.
- **FR-020**: After the final runs, `harness-model-findings.md` MUST be updated:
  - A finding whose resolution was applied, and which no final-run attempt shows, MUST be removed, and the note at the top of `# Harness Failures` MUST name it.
  - A finding a final-run attempt still shows MUST be updated: its Runs, Basis, and Proposed resolution.
  - A new failure MUST be added with its Skill, Runs, Category, Confirmed, Basis, and Proposed resolution: under `# Harness Failures` when the proposal is a concrete change, or under `# Research Harness Failures` when it needs investigation or more runs.
  - A research finding that no final-run attempt shows MUST stay, with a line saying it was not seen.
  - A section for spec 244's final runs MUST record their run ids, results, and the finding behind every failing attempt, as spec 243's section does.
- **FR-021**: In the final runs, a scenario that passes on either attempt passes, flaky included. The spec MAY finish with a failure recorded under FR-020, and the maintainer decides whether it blocks.

### Key Entities

- **Finding**: One harness failure in `harness-model-findings.md`, with its Skill, Runs, Category, Confirmed, Basis, and Proposed resolution. It sits under `# Harness Failures` when its fix is known, or under `# Research Harness Failures` when it needs investigation or more runs.
- **Scenario script**: A harness `.scenario` file. Its `ask:` and `ask-pattern:` lines key the replies its `say:` lines give, and its `expect:` lines check the files written.
- **Catch-all reply**: A reply whose key matches any question, such as `ask-pattern: \?`.
- **Final runs**: The live harness runs after every change. Their transcripts are the evidence for every finding update.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In the final runs, every scenario passes on either attempt, flaky included, except where the failure is recorded as a finding under FR-020. Results are compared with the baseline scenario by scenario, not as totals, because the final runs select a different set.
- **SC-002**: No scenario in the final runs that passed in every baseline run it appeared in fails both attempts, unless its transcript shows a finding already listed.
- **SC-003**: Across the final runs, 0 attempts end with an empty agent turn after a governance accept or a codify-config decline run on its own, and 0 attempts on those turns are reported blocked by the service. If either count is above 0, F7 is updated per FR-020.
- **SC-004**: Across the final runs, 0 written Discoveries or ADRs fail the template check for a missing heading or table header row.
- **SC-005**: 0 scenario files hold a catch-all reply.
- **SC-006**: Each requirement that changes behavior has a test that was observed failing before the change and passing after it. The full suite and the harness unit tests pass, and a second regeneration changes nothing.
- **SC-007**: Every failing attempt in the final runs is matched to a finding in `harness-model-findings.md`, and every finding removed is named in the removal note.
- **SC-008**: The final runs' transcripts are in `specs/244-harness-failure-followups/harness/`, `git check-ignore` reports that folder ignored, `git status` lists no file under it, and 0 captured files contain the Copilot token.

## Assumptions

- The proposed resolutions under `# Harness Failures` are accepted as written, with three refinements:
  - F3's list of 11 scenarios is 10, because codify-choose's `[unknown]` is keyed and intentional.
  - F3's "never spend a reply keyed to another question on the fallback" is read as offering the fallback only the earliest unused reply (see Clarifications). This keeps paraphrase tolerance and stops a later question's reply from being spent early.
  - F7's closing line also covers the governance first-question `decline` and a successful guided `write`, which also emit nothing when the skill runs on its own.
- F5's codify-configure resolution offered retiring the scenario or opening it in prose. Prose is chosen because it keeps the coverage. Retiring the scenario becomes the proposal if Copilot still routes around highway-codify.
- F21's scenario fix covers chain-implementation too, because it reaches the same `map` step with generic accepts.
- "Run the harness against the last commit" means `--changed-since 42a0569`, which compares the working tree with spec 243's commit.
- "Scenarios that failed in spec 243" means every scenario with a failed attempt in its three final runs, including those that passed on retry: adr-smoke, chain-codify, chain-discovery, chain-implementation, codify-config-smoke, codify-configure, codify-controls-conflict, codify-folder-taken, codify-needed-language, codify-no-architecture, codify-no-governance, controls-smoke, discovery-smoke, implementation-onboards-platform, nfrs-smoke, objectives-smoke, onboarding-smoke, and setup-smoke.
- No smoke run is made. The smoke scenarios that failed in the baseline are in the final runs through the list above, and a smoke scenario neither selection includes is not rerun.
- F1, F19, F20, and F22 get no fix in this spec. Their entries are updated from the final runs only.
- Live runs need a Copilot token in `harness/.env`, and no token is printed or kept in a transcript.
- Skill versions take MINOR bumps, never MAJOR. There is no backward compatibility to preserve, because Highway is unreleased.
- Nothing is committed unless the maintainer asks.
