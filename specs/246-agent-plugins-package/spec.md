# Feature Specification: Agent Plugins Package

**Feature Branch**: `246-agent-plugins-package`

**Created**: 2026-11-13

**Status**: Draft

**Input**: User description: "create a new spec to implement Phase 16. Step 3 will be addressed in a later spec. Update the harness model to Gemini 3.8 Flash and run the smoke test after the full suite passes. Capture the transcripts to the new spec folder and add that folder to .gitignore. For any failures, add them to standard-alignment.md and include a Proposed resolution. Follow the format and the placement in either Harness Failures or Research Harness Failures."

Phase 16 of `standard-alignment.md`: the repository builds `highway-agent-plugin/`, one plugin that conforms to the Agent Plugins 1.0 specification (https://agent-plugins.org), from the source skill folders in `skills/`. The plugin is checked by the bash suite and tested as installed. The per-agent skill copies and the distribution stay in place and keep working; Phase 17 retires them once this plugin is proved. Publishing is manual until Phase 18.

Phase 16 step 3, client-specific extras (always-on instructions and rules, a Claude Code manifest), is out of scope and is addressed in a later spec.

## Clarifications

### Session 2026-11-13

- Q: What public repository URL does `plugin.json` use for `repository` and `homepage`? → A: `https://github.com/jacob623/highway-skills` for now; Phase 18 revisits it.
- Q: The Harness Failures and Research Harness Failures sections are in `harness-model-findings.md`, not `standard-alignment.md`. Where do smoke findings go? → A: `harness-model-findings.md`, in those existing sections.
- Q: When the harness switches to Gemini 3.8 Flash, does the judge (and the reply fallback) switch too? → A: No. Scenario sessions use Gemini 3.8 Flash; the judge and the reply fallback stay on GPT-5.6 Luna. (Superseded by the model answer below.)
- Q: Where does the harness install the plugin for each attempt? → A: Through the client's normal plugin install, into a separate, throwaway agent home for each attempt; the user's own agent setup is never touched.
- Q: What version does the first `plugin.json` carry? → A: 0.1.0; Phase 18 decides when to reach 1.0.0.
- Q: Does a smoke failure caused by the installed plugin not loading block this spec? → A: Yes. Load or install failures block completion and are fixed in this spec; skill-behavior failures are recorded as findings and do not block.
- Q: Gemini 3.8 Flash is not in the model list for the harness token (planning found `auto`, Claude, GPT, Grok, MAI, and Kimi models only). Which model does the harness use? → A: Leave it on GPT-5.6 Luna for now. The harness model does not change in this spec; scenario sessions, the judge, and the reply fallback all stay on `gpt-5.6-luna`.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - The repository builds the plugin from the source skills (Priority: P1)

A maintainer runs the build and gets `highway-agent-plugin/`: a plugin manifest, every Highway skill copied byte for byte from `skills/`, and the public repository's README and license, and nothing else. Running it again with no source change produces the same bytes.

**Why this priority**: The plugin is Highway's delivery model. Every later phase (retiring the adapters, publishing) depends on this folder existing and being exactly the shipped set.

**Independent Test**: Run the build, list the folder, and compare each skill file with its source. Run the build again and confirm no byte changed.

**Acceptance Scenarios**:

1. **Given** the 16 source skills, **When** the build runs, **Then** `highway-agent-plugin/` holds `plugin.json`, `skills/<name>/` for each of the 16 skills including highway-experience, `README.md`, and `LICENSE`, and nothing else.
2. **Given** a built plugin, **When** any skill file in it is compared with its source, **Then** the two are identical byte for byte, including `references/` and `assets/`.
3. **Given** unchanged sources, **When** the build runs twice, **Then** the second run changes no byte.
4. **Given** the built `plugin.json`, **When** it is read, **Then** it names the Agent Plugins 1.0.0 schema, the name `highway`, a description, the version `0.1.0`, the license `Apache-2.0`, and the public repository as `repository` and `homepage`.

---

### User Story 2 - The suite guards the plugin (Priority: P1)

A maintainer who edits a skill, or hand-edits the plugin folder, is stopped by the bash suite if the plugin no longer matches the specification, a fresh build, or the shipped set.

**Why this priority**: A committed build artifact drifts unless something fails when it does. Without these checks the plugin could ship a stale or invalid skill.

**Independent Test**: Run the new checks on the committed plugin (pass), then on copies seeded with each defect (each fails, naming the defect).

**Acceptance Scenarios**:

1. **Given** the committed plugin, **When** the suite runs, **Then** the manifest and layout pass the Agent Plugins 1.0 checks, and every skill in `skills/` passes the Agent Skills validation from Phase 12.
2. **Given** a skill edited in `skills/` without rebuilding, **When** the suite runs, **Then** it fails and names the file that differs from a fresh build.
3. **Given** a file added to the plugin folder outside the shipped set, **When** the suite runs, **Then** it fails and names the file.
4. **Given** a `plugin.json` missing a required field or with a wrong schema, **When** the suite runs, **Then** it fails and names the field.

---

### User Story 3 - The harness runs from the installed plugin (Priority: P2)

A maintainer running the behavioral harness tests Highway the way a person gets it: the built plugin installed into the test project the way an Agent Plugins client installs a plugin.

**Why this priority**: Phase 17 removes the per-agent copies only once the plugin is proved to work as installed. This story is that proof.

**Independent Test**: Start one scenario and confirm the test project holds the installed plugin, not a copy of `skills/` in `.github/skills/`, and that the agent lists the 16 Highway skills from the plugin.

**Acceptance Scenarios**:

1. **Given** a harness run, **When** a test project is built, **Then** Highway's skills reach the agent only through `highway-agent-plugin/`, installed by the client's plugin install into an agent home made for that attempt.
2. **Given** a harness run of four parallel attempts, **When** it ends, **Then** the user's own agent home is unchanged and each attempt had its own agent home.
3. **Given** a harness run with no `--model`, **When** the run header is read, **Then** it names `gpt-5.6-luna` for the scenario sessions and the judge, as before this spec.
4. **Given** a stale plugin folder, **When** the harness starts, **Then** it refuses to run and says to rebuild, rather than testing skills that differ from the source.

---

### User Story 4 - A smoke run from the installed plugin is recorded and every failure has a proposed resolution (Priority: P2)

After the full suite passes, the maintainer runs the harness smoke set on GPT-5.6 Luna from the installed plugin. The transcripts are kept in this spec's folder, out of version control, and every failure is written up where the existing findings are, with a proposed resolution.

**Why this priority**: The smoke run is the evidence that the plugin works as installed. A failure to load the plugin blocks this spec; a skill-behavior failure is a finding for a later spec, recorded so nothing is lost.

**Independent Test**: Confirm the smoke run's folder sits in this spec's folder and is ignored by git, and that each failing scenario in it is matched to a finding with a Proposed resolution.

**Acceptance Scenarios**:

1. **Given** the full suite has passed, **When** the smoke set runs, **Then** its 16 scenarios run on GPT-5.6 Luna from the installed plugin, and the transcripts are written under this spec's folder.
2. **Given** the transcripts folder, **When** `git status` runs, **Then** nothing in it is listed.
3. **Given** a scenario where the agent cannot find or open a Highway skill from the installed plugin, **When** the smoke run ends, **Then** the spec is not complete until the cause is fixed and the smoke run is repeated.
4. **Given** a scenario that fails on skill behavior, **When** the findings are read, **Then** it is matched to a finding, new or existing, in the established format (Skill, Runs, Category, Confirmed, Basis, Proposed resolution), placed under Harness Failures when its cause is confirmed or under Research Harness Failures when it needs more evidence.

---

### User Story 5 - Today's delivery keeps working (Priority: P3)

Until Phase 17, a person still gets Highway from the per-agent skill copies and the distribution, and the public repository is updated by hand from `highway-agent-plugin/`.

**Why this priority**: The point of splitting Phase 16 from Phase 17 is that nothing is removed before the plugin is proved.

**Independent Test**: Run the existing adapter and distribution generators and tests and confirm they pass unchanged.

**Acceptance Scenarios**:

1. **Given** the plugin build exists, **When** the per-agent adapter and distribution generators run, **Then** they produce the same output as before this spec.
2. **Given** the plugin folder, **When** the distribution is built, **Then** the distribution does not include `highway-agent-plugin/`.

---

### Edge Cases

- A skill folder holds a file that does not belong in a plugin, such as an editor backup. The build copies only what the source skill folder holds, so the source must not hold it; the Agent Skills validation and the shipped-set check decide.
- A new skill is added to `skills/`. The build includes it with no change to the build, and the drift check fails until the plugin is rebuilt.
- highway-help's `assets/index.json` is generated into its source folder. The plugin copies it like any other file, so the catalog generator runs before the plugin build.
- The test project's fixture already holds an agent skill folder (`.github/skills/` and the like). The existing fixture check still rejects it, so a fixture cannot shadow the installed plugin.
- The plugin install reports a warning about the manifest, or installs fewer skills than `skills/` holds. The attempt fails as a load failure rather than running with a partial plugin.
- The agent reads a skill.s `references/` or `assets/` file from the installed plugin, which sits in the attempt.s agent home rather than in the project. The harness allows reads there and still rejects any write there.
- A smoke failure matches an existing finding. Its run id is added to that finding's Runs list rather than a new finding being opened.

## Requirements *(mandatory)*

### Functional Requirements

**Build**

- **FR-001**: A generator MUST build `highway-agent-plugin/` from `skills/`, holding exactly `plugin.json`, `skills/<name>/` for every source skill, `README.md`, and `LICENSE`.
- **FR-002**: Each skill folder in the plugin MUST be byte-identical to its source folder, with every file it bundles.
- **FR-003**: `plugin.json` MUST name the Agent Plugins 1.0.0 `$schema`, the name `highway`, a description, the version `0.1.0`, the license `Apache-2.0`, and the public repository as `repository` and `homepage`. Until Phase 18 settles the public repository, both are `https://github.com/jacob623/highway-skills`.
- **FR-004**: The plugin's `README.md` and `LICENSE` MUST be copied from source files kept in `framework/plugin/`. The README says what Highway is, how to install the plugin, and which skills it holds; the license is the full text of the license every skill declares.
- **FR-005**: The build MUST be reproducible: unchanged sources produce identical bytes, and no output depends on time, the machine, or the order files are found.
- **FR-006**: Nothing outside the shipped set MUST reach the plugin: no specs, tests, harness, framework tooling, development constitution, or path into this repository.
- **FR-007**: `highway-agent-plugin/` MUST be committed and regenerated, never edited by hand. Regenerating the catalog and the adapters MUST leave it unchanged when no skill changed.

**Checks**

- **FR-008**: The suite MUST validate `plugin.json` and the plugin layout against the Agent Plugins 1.0 specification.
- **FR-009**: The suite MUST run the Agent Skills validation from Phase 12 on every skill in the plugin's `skills/`.
- **FR-010**: The suite MUST fail when the plugin folder differs from a fresh build, naming each differing file.
- **FR-011**: The suite MUST fail when the plugin folder holds anything outside the shipped set, naming each extra file.
- **FR-012**: Each new check MUST be evaluated against the current plugin before it is wired in, and MUST be seen to fail on a seeded defect of each kind it checks (Development Constitution D3.4, D3.6, D3.7).

**Harness**

- **FR-013**: The harness MUST install the plugin for each attempt through the client's normal plugin install, into a separate, throwaway agent home for that attempt, and MUST NOT also copy `skills/` into an agent skill folder. The user's own agent home MUST NOT be read or changed, and no two attempts share an agent home. The agent home is removed with the attempt's test project.
- **FR-014**: The harness MUST refuse to run when `highway-agent-plugin/` differs from a fresh build.
- **FR-015**: The harness model MUST stay `gpt-5.6-luna` for scenario sessions, the judge, and the reply fallback. The Gemini 3.8 Flash change is deferred until that model is available to the harness token.
- **FR-016**: The harness README MUST describe the plugin install: where the plugin comes from, where it is installed, the stale-plugin refusal, and the reads the permission policy allows inside the installed plugin.

**Smoke run and findings**

- **FR-017**: After the full suite passes, the harness smoke set MUST run on GPT-5.6 Luna from the installed plugin, with transcripts written to `specs/246-agent-plugins-package/harness/`.
- **FR-018**: `.gitignore` MUST ignore `specs/246-agent-plugins-package/harness/*`, so no transcript is committed. Secrets and tokens MUST NOT appear in any captured transcript.
- **FR-019**: Every skill-behavior failure in the smoke run MUST be recorded as a finding in `harness-model-findings.md`, in the established format: Skill, Runs (with run id and scenario), Category, Confirmed, Basis, and Proposed resolution. A confirmed cause goes under Harness Failures; one that needs more evidence goes under Research Harness Failures. A failure that matches an existing finding adds its run to that finding.
- **FR-020**: New findings MUST take the next unused id (F26 onward) and their run lines MUST say the run is from the plugin install, since the existing findings were recorded from the per-agent skill copy.
- **FR-021**: A load or install failure (the plugin install fails, or the agent cannot find or open a Highway skill from the installed plugin) MUST block completion of this spec and MUST be fixed in it. A skill-behavior failure (the skill loads but the scenario's expectations are not met) MUST NOT block completion; it is recorded per FR-019. The spec's exit is met by the suite, the plugin checks, and a smoke run with no load or install failure.

**Unchanged delivery**

- **FR-022**: The per-agent adapter generator, the distribution generator, their manifests, and their tests MUST keep working unchanged. The distribution MUST NOT include `highway-agent-plugin/`.
- **FR-023**: No skill's text or version changes in this spec.
- **FR-024**: When the work is done, `standard-alignment.md` MUST mark Phase 16 complete in its phase table, naming this spec's folder, and add a Status paragraph recording what was done beyond its steps, including that step 3 was deferred.

### Key Entities

- **Plugin folder**: `highway-agent-plugin/`. The shipped set: `plugin.json`, `skills/`, `README.md`, `LICENSE`.
- **Plugin manifest**: `plugin.json`: schema, name, description, version, license, repository, homepage.
- **Plugin sources**: `skills/` for the skills, `framework/plugin/` for `plugin.json`, the README, and the LICENSE.
- **Attempt agent home**: the agent client's configuration folder made for one attempt, holding only the installed plugin and the harness's settings; removed with the attempt.
- **Smoke run**: one harness run of the 16 smoke scenarios, with its run id, model, and transcripts.
- **Finding**: an id, title, skill, runs, category (Skill, Scenario, Harness, Model, Service), whether it is confirmed, its basis, and a proposed resolution.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: The plugin holds all 16 skills, each identical to its source, and exactly four top-level entries.
- **SC-002**: Two consecutive builds with no source change differ in 0 bytes.
- **SC-003**: Each seeded defect (a stale skill, an extra file, an invalid manifest field, an invalid skill) fails the suite and names what is wrong; the unseeded plugin passes.
- **SC-004**: The full suite passes, with the new plugin checks counted in it.
- **SC-005**: A smoke run of 16 scenarios completes on GPT-5.6 Luna from the installed plugin, its transcripts are in this spec's folder, and `git status` lists none of them.
- **SC-006**: The final smoke run has 0 load or install failures, and every skill-behavior failure in it is matched to exactly one finding with a Proposed resolution.
- **SC-007**: The adapter and distribution generators produce the same output as before this spec.

## Assumptions

- Phases 11 to 15 are complete on `main` (spec 245 merged in pull request #122), so every skill is self-contained and passes Principle XIV, and the suite passes 86 of 86 before this work.
- The plugin's `version` starts at 0.1.0. Phase 18 bumps it per release and decides when to reach 1.0.0.
- The license is Apache-2.0, which every skill declares.
- The catalog generator runs before the plugin build, so highway-help's generated `assets/index.json` is current when copied.
- The plugin build is part of the existing generator set and follows the Development Constitution's generator rules (D4.1 to D4.7).
- Gemini 3.8 Flash is not offered to the harness token, so the model change is deferred (Clarifications). It returns as a one-line change to `harness/harness.config.json` once the model is available.
- The plan confirms how the harness's agent runtime installs an Agent Plugins plugin and how its agent home is redirected per attempt. If the runtime cannot install one, or cannot install it into a separate agent home, the work stops and the user is asked, rather than the harness falling back to copying `skills/` or touching the user's agent home.
- Only the smoke set runs. A targeted or full harness run is not part of the exit.
- Phase 16 step 3 (client-specific extras) and Phases 17 and 18 are out of scope.
- Constraints carried from earlier work: do not commit unless asked; secrets and tokens are redacted; `rollout-plan.md` stays gitignored and excluded from the distribution; MINOR version bumps only; no backward compatibility; use `mv`, not `git mv`; skill source is edited only in `skills/`, and the generators update the agent folders.
