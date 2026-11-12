# Feature Specification: Standard Alignment Progressive Disclosure

**Feature Branch**: `feature/std-alignment-phase14`

**Created**: 2026-11-12

**Status**: Draft

**Input**: User description: "create a new spec to implement phase 14". Phase 14 (Progressive Disclosure) of `standard-alignment.md` carries out the resolutions Phase 13 records. Twelve skills follow the cross-skill pattern: `SKILL.md` is the router, and each flow (the run of steps between two points where the person answers or a record is written) moves whole into a flow file in `references/`. A flow file holds every step and rule its flow needs, so a model must read it to do the work; no example or edge case moves on its own. `SKILL.md` and each flow file stay within the Agent Skills specification's ceiling of 500 lines and about 5,000 tokens. The validator judges a flow file as the skill's own instructions, everything that reads a skill's text reads its flow files, and a new bash test checks the eleven boundaries Phase 13 lists on every skill, so no skill needs a change when Phase 15 makes those boundaries rules of the Highway Skills Constitution.

## Clarifications

### Session 2026-11-12

- Q: Where should the rule for keeping or removing a product's Features entry (step 3 of highway-codify's `index`) live after the split? → A: In `SKILL.md`. Both `index` (in `record.md`) and `code` (in `code.md`) apply it from there, following the pattern's rule that a rule two flows apply stays in `SKILL.md`.
- Q: For Phase 14 to count as done, must the twelve split skills pass a live harness run, or are the harness's own tests and resolving `covers:` hashes enough? → A: Live runs. Before any harness run, the harness model is switched to GPT-5.6 Luna. A live smoke run happens before the changes and again after them; if the run before the changes fails, work stops and the maintainer decides how to proceed. Both smoke runs' transcripts are captured in the spec 242 folder. After the changes, a live run of every scenario the change affects (`--changed-since main`) must pass.
- Q: The live smoke run before the changes failed on GPT-5.6 Luna: 6 of 16 passed, with no skill
  changed. How does the phase proceed? → A: The run (`20261112-162017Z-smoke-49ab958`) is the
  baseline, and its failures are recorded for later work in `harness-model-findings.md` at the
  repository root. After the changes, the work must do no worse:
  - every smoke scenario that passed in the baseline passes, flaky included;
  - a scenario that failed there fails only by a finding that document lists.
  - In the run of affected scenarios, a failure is accepted only when its transcript shows a
    finding that document lists, not a regression from the split.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - A model following a large skill reads every instruction for its flow (Priority: P1)

A person runs one of the twelve large skills. The agent loads `SKILL.md`, which tells it which file holds each step. When the work reaches a step in a flow file, the agent reads that file and finds every step and rule the flow needs in it. It has nothing to improvise from: `SKILL.md` names the file and its steps, never a summary of the flow. The person sees the same conversation, the same proposals, and the same records as before the split.

**Why this priority**: This is the phase. The split exists to bring the skills within the specification's size guidance without fragmenting what the model reads. A split that loses an instruction, rewords one, or lets the model skip a flow file changes what the person gets.

**Independent Test**: For each of the twelve skills, compare every step's text before and after the split, and confirm each step sits in exactly one file. Read `SKILL.md` and confirm it names each flow file only in its flows table. Run the harness scenarios for the skill.

**Acceptance Scenarios**:

1. **Given** each of the twelve skills, **When** its folder is read, **Then** `references/` holds exactly the flow files its Phase 13 resolution names, and each holds exactly the steps that resolution assigns it.
2. **Given** a step moved into a flow file, **When** its text is compared with the text before the split, **Then** its heading and wording are unchanged.
3. **Given** a skill with flow files, **When** its `SKILL.md` is read, **Then** its Procedure introduction holds the sentence "Before a step in this table, read its file and follow it to the end." followed by a table with the columns File and Steps, one row per flow file, listing that file's steps in file order, and no other line of `SKILL.md` names a file in `references/`.
4. **Given** a rule in a skill's Procedure introduction, **When** the split is done, **Then** it sits in the file of the step that applies it, or stays in `SKILL.md` when steps in more than one file apply it.
5. **Given** any flow file, **When** it is read, **Then** it names no other file in `references/`, and every step it hands off to resolves by name through the flows table.
6. **Given** any flow file, **When** its content is read, **Then** it holds steps, not examples or edge cases separated from the steps they belong to.
7. **Given** the baseline live smoke run before the split, **When** the same smoke run repeats after it with the same model, **Then** it does no worse: every scenario that passed passes, and every scenario that failed fails only by a finding `harness-model-findings.md` lists.
8. **Given** every harness scenario the change affects, **When** it runs live after the split, **Then** it passes, or it fails only by a finding `harness-model-findings.md` lists.

---

### User Story 2 - Every skill fits within the specification's size ceiling (Priority: P1)

An agent that follows the Agent Skills specification loads a Highway skill. `SKILL.md` is within the specification's guidance of 500 lines and about 5,000 tokens, and each flow file the agent reads later is too, so the skill's instructions do not crowd the agent's context when it activates.

**Why this priority**: The specification recommends the ceiling so agents load skills efficiently. Today highway-codify is 770 lines and about 13,900 tokens, and seven more skills exceed 5,000 tokens.

**Independent Test**: Count the lines and characters of every `SKILL.md` and every flow file.

**Acceptance Scenarios**:

1. **Given** any Highway skill, **When** its `SKILL.md` is measured, **Then** it has at most 500 lines and 20,000 characters.
2. **Given** any flow file, **When** it is measured, **Then** it has at most 500 lines and 20,000 characters, and at least 25 lines.
3. **Given** any skill, **When** its flow files are counted, **Then** there are at most six.

---

### User Story 3 - Moved instructions stay governed and tested (Priority: P1)

A maintainer edits a step that now lives in a flow file. The validator judges that file by the same rules it applies to the instructions in `SKILL.md`, the harness counts its steps and Verification bullets, and every test that asserted the step's text before the split still asserts it in its new file.

**Why this priority**: Today the validator judges any file in `references/` as a reference document and exempts it from the rule-shape rules and P2.6, which were written for documents such as the Experience Standard that state rules for others. If moved text took those exemptions, the split would quietly weaken the checks on two thirds of the skills' instructions.

**Independent Test**: Seed a violation of each rule that judges `SKILL.md`'s instructions into a flow file and run the validator. Run the harness inventory on a split skill. Run the full suite.

**Acceptance Scenarios**:

1. **Given** a flow file, **When** the validator runs, **Then** it judges the file by every automatic rule that judges `SKILL.md`, except P7.1, P7.2, and P8.7, which judge `SKILL.md`'s Purpose and version and the links a bundled file may hold.
2. **Given** a reference document that no flows table names, such as highway-experience's, **When** the validator runs, **Then** it keeps today's reference exemptions.
3. **Given** a seeded violation of a rule-shape rule or P2.6 in a flow file, **When** the validator runs, **Then** it fails and names the rule and the file.
4. **Given** a split skill, **When** the harness inventory is taken, **Then** it lists the steps and Verification bullets in its flow files as well as in `SKILL.md`, and every harness `covers:` hash resolves.
5. **Given** a test that asserted a skill's text before the split, **When** the suite runs after it, **Then** the test finds that text in the skill folder, and no assertion is removed or loosened.
6. **Given** a flow file, **When** it is read, **Then** it ends with `## Verification` holding the checks for its steps, and `SKILL.md`'s `## Verification` keeps the checks for its own steps and is not empty.

---

### User Story 4 - The suite holds every skill to the pattern (Priority: P2)

A maintainer adds a step, moves a rule, or grows a skill. A bash test checks the eleven boundaries in Phase 13, and boundary 12, on every skill and fails, naming the boundary, the skill, and the file, when one breaks.

**Why this priority**: A pattern that is not enforced drifts back to one large file, or to many small ones. The checks ship before Phase 15 makes them constitution rules, so the skills are held to them from the moment they are split.

**Independent Test**: Run the test on every skill. Seed one breach of each boundary into a copy of a split skill, and of a skill with no flow files where the boundary applies, and run the test on each copy.

**Acceptance Scenarios**:

1. **Given** every Highway skill, **When** the boundary test runs, **Then** it passes, including the four skills Phase 13 did not split.
2. **Given** a skill copy with one boundary broken, **When** the test runs, **Then** it fails and names the boundary, the skill, and the file.
3. **Given** the full suite, **When** it runs, **Then** each boundary is proven able to fail by a seeded breach, and the test was run against every skill before it was wired into the suite.

---

### User Story 5 - A maintainer writes a new skill in the pattern (Priority: P3)

A maintainer writing or growing a skill reads the authoring standard. It describes `references/<flow>.md`, the flows table, the shape of a flow file, and when a skill splits, so the next skill follows the pattern without reading Phase 13.

**Why this priority**: The test catches a skill that breaks the pattern; the authoring standard prevents the break. It ranks last because enforcement (User Story 4) already catches the result.

**Independent Test**: Read the authoring standard's directory layout and compare it with the twelve boundaries.

**Acceptance Scenarios**:

1. **Given** the authoring standard, **When** a maintainer reads it, **Then** it describes the router, flow files, the flows table and its sentence, the flow file shape, and the rule that a rule lives with the step that applies it.
2. **Given** the authoring standard and the boundary test, **When** they are compared, **Then** they state the same limits.

---

### Edge Cases

- highway-experience already has `references/` holding three reference documents, not flows, and the Experience Standard is about 6,600 tokens. It has no flows table, so its files are not flow files and are not held to the flow file limits. Each is named by a line of `SKILL.md` that begins "Read `references/<file>`".
- highway-profile, highway-setup, highway-help, and highway-experience are not split. The boundary test still runs on them; boundaries about flow files pass because they have none, and the size boundary applies to their `SKILL.md`.
- A step another skill names, such as `capability title` and `execution` in highway-implementation, or `onboarding` in highway-adr, highway-architecture, and highway-implementation, moves into a flow file. The handoff "follow `<step>` in `highway-<name>`" still resolves, because the named skill's flows table maps the step to its file.
- A level-3 heading inside a fenced block, such as the completion message in highway-codify's `close` or the menu heading in highway-codify-config, is template text, not a step. It moves with its step and is not counted as one.
- A Verification bullet that checks steps in more than one file stays in `SKILL.md`. A bullet that checks steps in one flow file moves to that file.
- highway-codify's `resume` step, in `proposal.md`, routes to `menu`, `code`, or `close` in other flow files. It hands off by step name, as every flow does.
- highway-codify after the split still exceeds 5,000 tokens unless the Verification checks for its flows move with them. They move, per User Story 3.
- The live smoke run before the changes fails. Work stops before any skill changes, and the maintainer decides how to proceed, because a failure there would make the run after the changes impossible to read. It did fail, on the model's behavior with unchanged skills. The maintainer made that run the baseline and recorded its failures in `harness-model-findings.md`.
- highway-request is under 4,000 tokens before the split. It is split anyway, per its Phase 13 resolution, so every skill that writes a record follows the same pattern.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Each of the twelve skills MUST be split as its Phase 13 resolution in `standard-alignment.md` says: the flow files it names, the steps that move into each, and the steps that stay in `SKILL.md`. The flow files are:

  | Skill | Flow files in `references/` |
  | --- | --- |
  | highway-codify | `catalog.md`, `suggest.md`, `proposal.md`, `record.md`, `plan.md`, `code.md` |
  | highway-implementation | `proposal.md`, `record.md`, `amend.md` |
  | highway-adr | `proposal.md`, `record.md` |
  | highway-codify-config | `platforms.md`, `standards.md`, `conflicts.md` |
  | highway-discovery | `analysis.md`, `record.md`, `explore.md` |
  | highway-nfrs | `proposal.md`, `record.md` |
  | highway-onboarding | `proposal.md`, `orchestrate.md` |
  | highway-architecture | `proposal.md`, `record.md` |
  | highway-assessment | `findings.md`, `ready-records.md` |
  | highway-controls | `proposal.md`, `record.md` |
  | highway-objectives | `proposal.md`, `record.md` |
  | highway-request | `proposal.md`, `record.md` |

- **FR-002**: A moved step MUST keep its heading and wording. The split MUST add only each flow file's level-1 heading, the flows table and its sentence, and the `## Verification` sections that FR-006 creates, and MUST move only the rules FR-003 places.
- **FR-003**: A rule in a skill's Procedure introduction MUST move to the file of the step that applies it, and MUST stay in `SKILL.md` when steps in more than one file apply it. The rules the resolutions name MUST be placed as they say: the evidence reading order to highway-adr's `proposal.md`, the evidence loading order to highway-discovery's `analysis.md`, the seven-domain collection order to highway-request's `proposal.md`, and the finding category and trace-chain rules to highway-assessment's `findings.md`. Items 10 and 11 of highway-codify's `code tasks`, which govern the README and the close, MUST move to `code.md`. The rule in step 3 of highway-codify's `index`, for keeping or removing a product's Features entry, MUST move to `SKILL.md`, because both `index` and `code` apply it; neither flow file holds a copy.
- **FR-004**: An example or edge case MUST NOT move into a flow file apart from the step it belongs to.
- **FR-005**: `SKILL.md` MUST keep the frontmatter, Purpose through Outputs, the Procedure introduction, Entry and Classify when the skill has them, every step its resolution keeps, Error Handling, and Example. In a skill with flow files, the Procedure introduction MUST hold the sentence "Before a step in this table, read its file and follow it to the end." and a table with the columns File and Steps, with one row per flow file listing exactly that file's steps in file order. Any other line of `SKILL.md` MUST NOT name a file in `references/`.
- **FR-006**: Each flow file MUST have no frontmatter, start with one level-1 heading that names the flow, hold its steps as level-3 headings, and end with `## Verification`, its only level-2 heading, holding at least one bullet. Each Verification bullet MUST move to the flow file whose steps it checks; a bullet that checks steps in more than one file, or a step in `SKILL.md`, MUST stay in `SKILL.md`.
- **FR-007**: A flow file MUST NOT name a file in `references/`. Each handoff MUST name a step, and every step a skill names, its own or another skill's ("in `highway-<name>`"), MUST resolve to a step in that skill's `SKILL.md` or flow files.
- **FR-008**: `SKILL.md` and each flow file MUST have at most 500 lines and 20,000 characters. A skill MUST have at most six flow files, and each MUST have at least 25 lines.
- **FR-009**: The validator MUST judge a file the flows table names as the skill's own instructions: by every automatic rule that judges `SKILL.md`, except P7.1, P7.2, and P8.7. A file in `references/` that no flows table names MUST keep today's reference exemptions. A seeded violation of each rule a flow file is newly judged by MUST fail validation.
- **FR-010**: The harness inventory MUST list the steps and the Verification bullets of each flow file, with the same ids it gives them in `SKILL.md`, so every harness `covers:` hash resolves after the split.
- **FR-011**: Every bash test that asserts a skill's text MUST find it in the skill's folder after the split. An assertion MUST NOT be removed or loosened (D3.5).
- **FR-012**: A new bash test MUST check the eleven boundaries in Phase 13, and boundary 12 (a handoff within one turn stays in its file or goes to `SKILL.md`), on every skill and fail on any breach, naming the boundary, the skill, and the file. It MUST be run against every skill, with each result recorded, before it is wired into the suite (D3.4), and a seeded breach MUST fail each boundary (D3.7).
- **FR-013**: The authoring standard MUST describe the router, flow files, the flows table and its sentence, the flow file shape, the placement of rules and Verification bullets, and the limits in FR-008.
- **FR-014**: Every split skill MUST take a MINOR version bump.
- **FR-015**: The help index, the agent trees, and every other generated file MUST be regenerated, each agent tree MUST carry every flow file, and a second regeneration MUST change nothing.
- **FR-016**: Neither constitution changes in this phase. Principle XIV and the move of P5.15 are Phase 15; the boundary test checks the same boundaries those rules will, so no skill needs a change when Phase 15 enforces them.
- **FR-017**: Before any harness run in this phase, the harness's default model MUST be GPT-5.6 Luna. A live smoke run (one scenario per skill) MUST run before the first skill changes; if it fails, work MUST stop and the maintainer decides how to proceed. The same smoke run MUST repeat after the changes and do no worse than the baseline run `20261112-162017Z-smoke-49ab958`. Every scenario that passed there MUST pass, flaky included, and a scenario that failed there MUST fail only by a finding `harness-model-findings.md` lists. The transcripts of both smoke runs MUST be kept in the spec 242 folder. After the changes, a live run of every scenario the change affects since `main` MUST pass, except where a scenario's transcript shows a finding `harness-model-findings.md` lists.

### Key Entities

- **Router**: A split skill's `SKILL.md`. It keeps the steps that pick or sequence a flow, and its flows table maps every other step to its file.
- **Flow**: The run of steps between two points where the person answers or a record is written, such as building and revising a proposal, or writing an accepted record.
- **Flow file**: A file in `references/` that the flows table names. It holds one flow's steps, the rules only those steps apply, and the Verification checks for those steps.
- **Flows table**: The File and Steps table in the router's Procedure introduction, after the sentence "Before a step in this table, read its file and follow it to the end."
- **Reference document**: A file in `references/` that no flows table names, such as highway-experience's Experience Standard. It is not a flow file.
- **Boundary**: One of the twelve checks in `standard-alignment.md` that decide, with no judgment, whether a skill follows the pattern.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: All 16 skills have a `SKILL.md` of at most 500 lines and 20,000 characters, and all 27 flow files are within the same limits. Today 1 skill exceeds 500 lines and 8 exceed 20,000 characters.
- **SC-002**: For each of the twelve skills, every step's heading and text after the split match the text before it, except the rules FR-003 places.
- **SC-003**: The boundary test passes on all 16 skills, and one seeded breach of each of the twelve boundaries makes it fail.
- **SC-004**: For each rule a flow file is newly judged by, one seeded violation in a flow file makes the validator fail, naming the rule and the file.
- **SC-005**: Every harness `covers:` hash resolves after the split. On GPT-5.6 Luna, the live smoke run after the changes does no worse than the baseline run before them, scenario by scenario, with both transcripts in the spec 242 folder. Every scenario the change affects passes live after them, or fails only by a finding `harness-model-findings.md` lists.
- **SC-006**: The full suite passes, with no assertion removed or loosened, and a second regeneration of every generated file changes nothing.
- **SC-007**: 0 lines of any router outside its flows table, and 0 lines of any flow file, name a flow file.

## Assumptions

- Phase 13's resolutions in `standard-alignment.md` are accepted as written and are the source of truth for which steps move where. The measurements in Phase 13 are from 2026-11-12, after Phase 12, and are taken again at the start.
- Tokens are counted as characters divided by four, because no tokenizer is on the Declared Toolchain. The 20,000-character limit stands for the specification's "about 5,000 tokens".
- Phase 13's 400 lines and 4,000 tokens chose the skills to split. They are not a limit this phase enforces.
- The adapter generator already copies a skill's `references/` beside its `SKILL.md`, and the validation cache already hashes `references/`, so neither needs a change for flow files to ship and to invalidate the cache.
- An agent that follows the flows table's sentence reads a flow file before following one of its steps. The live harness runs are the evidence that behavior is unchanged; the text checks alone are not (D3.8).
- Live runs need a Copilot token in `harness/.env`. The plan confirms GPT-5.6 Luna's model id in Copilot.
- The four unsplit skills keep their structure. highway-experience's reference documents stay as they are.
- Skill versions take MINOR bumps, never MAJOR, and there is no backward compatibility to preserve, because Highway is unreleased.
- Nothing is committed unless the maintainer asks.
