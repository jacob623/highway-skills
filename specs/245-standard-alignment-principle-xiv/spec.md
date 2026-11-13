# Feature Specification: Standard Alignment Principle XIV

**Feature Branch**: `main` (no branch created; the maintainer creates one)

**Created**: 2026-11-13

**Status**: Draft

**Input**: User description: "create a new spec for implementing Phase 15 in standard-alignment.md". Phase 15 (Principle XIV: Agent Skills Alignment) adds Principle XIV to the Highway Skills Constitution (`framework/constitution.md`). It holds every rule that narrows the Agent Skills specification, and the bash suite enforces it. Four `[auto]` rules, one per group of the twelve Phase 13 boundaries, make the flow pattern a constitution rule: Size (boundary 1), Layout (boundaries 2 to 4), Routing (boundaries 5 to 8), and Handoff integrity (boundaries 9 to 12). P5.15 moves into Principle XIV without changing its obligation. Each new rule gets a check in `framework/lib/rule-checks.sh`, evaluated against every skill before it is wired in and failed by a seeded defect. The four checks take over from `tests/skill-flow-pattern.test.sh`, which Phase 14 added. The constitution takes a MINOR version, and its rule count goes from 76 to 80. Phase 14 already brought every skill into the pattern, so Phase 15 changes the constitution and its checks, not the skills.

## Clarifications

### Session 2026-11-13

- Q: Should spec 245 include the validator cache fix (User Story 5 and FR-013), or should that go in its own spec? → A: Keep both in spec 245. The key widens to cover the other skills a handoff reads, and the validator validates in full, recording and replaying nothing, whenever hashing fails or produces no output. The cache is used by 14 of the 16 test calls and by the catalog and agent adapter generators, which stop on a failing skill. So a replayed verdict can let a failing skill through when they run in a sandboxed shell.
- Q: Should finishing spec 245 require a live harness run on `gpt-5.6-luna`, even though no skill text changes? → A: No. The exit is the full suite, the validator on all 16 skills with the cache off, and the seeded cases. The harness reads skills only through `framework/lib/flows.sh`, which this phase does not change.
- Q: Once the four rule checks cover all twelve boundaries, should `tests/skill-flow-pattern.test.sh` be deleted, or kept? → A: Delete it. Its seeded breaches move into the rule-check tests, and the suite goes from 87 to 86 tests.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - The validator enforces the flow pattern as constitution rules (Priority: P1)

A maintainer validates a skill with `framework/validate-skill.sh`. Besides the existing rules, the validator now decides Principle XIV's four rules for the whole skill folder: `SKILL.md`, its flow files, and the steps they hand off to. A breach is reported as a finding tagged with the rule's id, naming the file and the condition broken. A skill that follows the pattern passes, as every skill does today.

**Why this priority**: This is the phase's purpose. Today the pattern is held only by one bash test, outside the constitution. A rule with an `[auto]` tier and a registered check is what makes the pattern part of what a valid skill means, reported where every other rule is reported.

**Independent Test**: Run the validator on every skill with the cache off and confirm each passes with the four new rules among those checked. Then break one boundary in a copy of a skill and confirm the validator fails it with the matching rule id.

**Acceptance Scenarios**:

1. **Given** any of the 16 skills as they are after Phase 14, **When** the validator runs on it, **Then** it passes, and the four Principle XIV rules are listed as checked.
2. **Given** a skill whose `SKILL.md` or a flow file exceeds 500 lines or 20,000 characters, **When** the validator runs, **Then** it fails with the Size rule's id and names the file and its measure.
3. **Given** a skill that breaks a Layout, Routing, or Handoff integrity boundary, **When** the validator runs, **Then** it fails with that rule's id and a finding that names the file and the broken condition.
4. **Given** a skill that breaks boundaries in two groups, **When** the validator runs, **Then** each breached rule is reported once per finding, and no rule reports another rule's breach.
5. **Given** a skill with flow files, **When** the validator runs, **Then** each Principle XIV rule is decided once for the skill, not again for each flow file or reference.

---

### User Story 2 - The constitution states Principle XIV and cites the specification it narrows (Priority: P1)

A maintainer reads the Highway Skills Constitution to learn what a skill's files must look like. Principle XIV collects every rule that narrows the Agent Skills specification. Each rule says what it requires in one sentence, has an Observable that a script decides, and names the specification clause it narrows, or "None (Highway pattern)" when it narrows none. The principle cites the specification and does not restate it. The terms the rules use (flow file, flows table, step, step reference, reply line) are defined once.

**Why this priority**: The rules are only as useful as their text. A rule without a decidable Observable cannot be checked, and a rule that restates the specification drifts from it.

**Independent Test**: Read Principle XIV and confirm it has five rules (the four new ones and P5.15), each with one keyword, at most 25 words, an `[auto]` tier, and a named clause or "None (Highway pattern)". Confirm the version, the rule count, and the Sync Impact Report.

**Acceptance Scenarios**:

1. **Given** the amended constitution, **When** Principle XIV is read, **Then** it holds rules for Size, Layout, Routing, and Handoff integrity, each `[auto]`, and P5.15 with its id, obligation, Observable, and tier unchanged.
2. **Given** each Principle XIV rule, **When** its narrowed clause is read, **Then** Size names the specification's progressive disclosure guidance on `SKILL.md` size; Layout names the `references/` directory and its focused reference files; Routing names "None (Highway pattern)"; Handoff integrity names the guidance to keep file references one level deep for boundary 9 and "None (Highway pattern)" for boundaries 10 to 12; and P5.15 names the guidance that a description says what the skill does and when to use it.
3. **Given** each new rule's Observable, **When** it is read, **Then** it lists the Phase 13 boundaries the rule checks, in terms the constitution defines.
4. **Given** Principle V, **When** it is read, **Then** P5.15 is gone from it and P5.16 stays.
5. **Given** the version line and the Sync Impact Report, **When** they are read, **Then** the version is 10.5.0, a MINOR change from 10.4.0. The report states the rule count going from 76 to 80, the tier counts, the relocation of P5.15, and the self-application review.
6. **Given** Principle Precedence, **When** it is read, **Then** Principle XIV has a rank, so the ordering stays total.

---

### User Story 3 - A seeded violation of each boundary fails its rule (Priority: P2)

A maintainer changing a rule check needs proof that it still catches what it is meant to. For each of the twelve boundaries, a seeded breach in a copy of a known-good skill makes the matching rule fail and no other. Each rule is also failed by a seed in a skill with `references/` and by one in a skill without, so a check cannot pass only because a folder is absent.

**Why this priority**: A check that never fails proves nothing. Phase 14's test already proves each boundary with a seeded breach; moving enforcement into the constitution must keep that proof.

**Independent Test**: Run the rule-check tests and confirm a seeded breach of each boundary fails exactly its rule, and that the unseeded copy passes.

**Acceptance Scenarios**:

1. **Given** a known-good skill with flow files, **When** one boundary from 1 to 12 is breached in a copy, **Then** the validator fails only the rule that holds that boundary.
2. **Given** a known-good skill without `references/`, **When** a breach of each rule is seeded in a copy, **Then** the validator fails that rule.
3. **Given** the same copy with nothing seeded, **When** the validator runs, **Then** it passes.

---

### User Story 4 - One place enforces the pattern (Priority: P2)

A maintainer looking for where the flow pattern is enforced finds the constitution's rules and their checks, not a second test that repeats them. `tests/skill-flow-pattern.test.sh` retires once the rule checks cover all twelve boundaries. Its seeded breaches move into the rule-check tests. Every document that pointed at the test points at the rule ids instead.

**Why this priority**: Two enforcers of one rule drift. The Development Constitution's no-weakening rule (D3.5) is met because every breach the test caught is still caught, with a seeded proof.

**Independent Test**: Confirm the test file is gone, the suite passes with one fewer test, and every breach the old test checked has a seeded failing case in the rule-check tests.

**Acceptance Scenarios**:

1. **Given** the suite after the change, **When** it runs, **Then** it passes with 86 tests, `tests/skill-flow-pattern.test.sh` is gone, and no test or document names it.
2. **Given** each breach message the retired test could print, **When** the rule-check tests are read, **Then** a seeded case fails the matching Principle XIV rule.
3. **Given** the authoring standard, **When** it describes the flow file limits and pattern, **Then** it cites the Principle XIV rule ids and does not restate them.
4. **Given** every test that counts the constitution's rules or tiers, **When** it runs, **Then** it expects 80 rules and the new tier counts.

---

### User Story 5 - A cached verdict is never another skill's or a stale one (Priority: P3)

A maintainer runs the validator many times while editing. The validator replays a recorded verdict only for the exact inputs that produced it. The Handoff integrity rule reads other skills' folders, so a cached verdict must change when any skill a handoff names changes. When the inputs cannot be hashed, the validator validates in full rather than replaying a record.

**Why this priority**: On 2026-11-13, in a sandboxed shell, `xargs` failed while hashing a skill's files. Every skill then got the same cache key, and the validator replayed `highway-nfrs`'s verdict for every other skill. Once a rule reads other skills, a key built from one skill's folder can also replay a stale verdict.

**Independent Test**: Validate two different skills with the cache on and confirm each verdict names its own skill. Make the hashing step fail and confirm the validator runs in full. Change a step a cross-skill handoff names, and confirm the skill holding the handoff is validated again.

**Acceptance Scenarios**:

1. **Given** two skills validated one after the other with the cache on, **When** each report is read, **Then** each names its own skill.
2. **Given** a hashing step that fails or produces no output, **When** the validator runs, **Then** it records nothing and replays nothing, and the verdict is the full run's.
3. **Given** a skill whose step another skill's handoff names, **When** that step is renamed, **Then** the skill holding the handoff is not answered from the cache and fails the Handoff integrity rule.

### Edge Cases

- highway-experience has `references/` but no flows table. Routing judges it by boundary 8's second branch: each file in `references/` is named by a `SKILL.md` line beginning "Read `references/<file>`". Its references are not flow files, so Size, Layout, and the flow-file parts of Handoff integrity do not apply to them.
- Three skills (highway-help, highway-profile, highway-setup) have no `references/`. Size, Routing, and Handoff integrity still apply to their `SKILL.md`. A seeded Layout breach in such a skill is a flows table that names a flow file not directly in `references/`.
- A fenced code block in `SKILL.md` or a flow file can hold a heading or a backticked name. Steps, step references, and headings inside fenced blocks are ignored, as Phase 14's test ignores them.
- A step reference that contains `/` or `.` or starts with `highway-` is not a step reference, so a file path or a skill name after "go to" is not judged as a missing step.
- A cross-skill handoff that names a skill not in `skills/` fails Handoff integrity, as boundary 11 says.
- A rule check is given only a `SKILL.md`, so it resolves a cross-skill handoff against the skill folders beside the one it validates. In the repository that is `skills/`; in a verification tree it is that tree's `skills/`. A seeded copy in a temporary folder resolves its cross-skill handoffs against what that folder holds.
- P5.15's check keeps deciding P5.15. Its N/A condition for a file that is not `SKILL.md` stays.

## Requirements *(mandatory)*

### Functional Requirements

**Constitution**

- **FR-001**: The Highway Skills Constitution MUST gain Principle XIV, "Agent Skills Alignment". It follows Principle XII; the number XIII stays retired.
- **FR-002**: Principle XIV MUST cite the Agent Skills specification (https://agentskills.io/specification) by link and name the specification clause each rule narrows, or "None (Highway pattern)". It MUST NOT restate the specification's text. The clause MUST be stated without changing the four-element rule row (ID, Rule, Observable, Tier) that the inventory parser reads.
- **FR-003**: Principle XIV MUST hold four new `[auto]` rules, with the next unused ids in its namespace: Size (boundary 1), Layout (boundaries 2 to 4), Routing (boundaries 5 to 8), and Handoff integrity (boundaries 9 to 12). Each rule has one keyword and at most 25 words (P1.1, P1.3). Each Observable lists the boundaries the rule checks, with the same limits and conditions Phase 13 states.
- **FR-004**: The terms the Observables use MUST be defined once in the constitution's Definitions: flow file, flows table, step, step reference, and reply line, with the meanings Phase 13 gives them.
- **FR-005**: P5.15 MUST move from Principle V into Principle XIV with its id, keyword, obligation, Observable, and tier unchanged. `rc_check_P5_15` keeps deciding it. P5.16 stays in Principle V.
- **FR-006**: Principle Precedence MUST rank Principle XIV, keeping the ordering total, without changing the rank of any other principle.
- **FR-007**: The constitution MUST take version 10.5.0, a MINOR change, with the Last Amended date of the change. A new Sync Impact Report at the top records the bump rationale, the changed elements, the rule count from 76 to 80, the tier counts ([auto] from 15 to 19), the relocation of P5.15, and the self-application review against P1.1 to P1.4, P6.4, P6.6, and P7.3. The Self-Application section notes that P5.15 stays individually addressable within Principle XIV.

**Checks and validator**

- **FR-008**: Each new rule MUST have a check in `framework/lib/rule-checks.sh`, registered in `rc_registry`, that decides the rule for the whole skill folder of the `SKILL.md` it is given. The flows table is read only through `framework/lib/flows.sh`.
- **FR-009**: Each finding MUST name the file and the broken condition, and a breach MUST be reported only by the rule that holds its boundary.
- **FR-010**: The four rules MUST be decided once per skill. When the validator judges a flow file, a reference, or a template, they are exempt, so no breach is reported twice.
- **FR-011**: Each check MUST be evaluated against every skill before it is registered (D3.4). Every skill passes all four with no skill file changed. A skill that fails shows a difference between the check and Phase 14's test, and the check is corrected, not the skill.
- **FR-012**: A seeded breach of each of the twelve boundaries, in a copy of a known-good skill with flow files, MUST fail exactly its rule. A seeded breach of each rule in a copy of a known-good skill without `references/` MUST fail that rule. The unseeded copy passes (D3.7).
- **FR-013**: The validation cache key MUST cover every input a verdict depends on, including the other skills' `SKILL.md` and flow files that Handoff integrity reads. When any hashing step fails or produces no output, the validator MUST neither replay nor record a verdict.

**Tests and documents**

- **FR-014**: `tests/skill-flow-pattern.test.sh` MUST retire once FR-012's seeded cases cover every breach it reports. Its seeded breaches move into the rule-check tests. The removal is recorded with its reason (D3.5), and the suite goes from 87 to 86 tests.
- **FR-015**: Every test that counts the constitution's rules or tiers MUST expect 80 rules and the new tier counts.
- **FR-016**: The authoring standard MUST cite the Principle XIV rule ids where it describes the flow file limits and the pattern, in place of the retired test. No test and no live document names the retired test. Records of past work (`specs/` and the phase text in `standard-alignment.md`) keep their mentions.
- **FR-017**: Skill files and skill versions MUST NOT change. Regenerating the catalog and the agent adapters changes nothing.
- **FR-018**: When the work is done, `standard-alignment.md` MUST mark Phase 15 complete in its phase table, naming this spec's folder, and add a Status paragraph under Phase 15 recording what was done beyond its steps.

### Key Entities

- **Principle XIV rule**: an id, one keyword, a rule sentence of at most 25 words, an Observable naming its boundaries, the `[auto]` tier, and the specification clause it narrows or "None (Highway pattern)".
- **Boundary**: one of the twelve conditions Phase 13 lists, judged by a script against one skill folder with no judgment. Each belongs to exactly one rule.
- **Rule check**: a function registered for a rule id. Given a `SKILL.md`, it returns pass, fail, or not applicable, and prints one finding per breach.
- **Seeded case**: a copy of a known-good skill with one boundary breached, and the rule it must fail.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: All 16 skills pass the validator with the cache off, with the four Principle XIV rules among those checked, and no skill file changed.
- **SC-002**: Each of the 12 boundaries has a seeded case that fails exactly its rule. Each of the 4 rules also has a seeded case in a skill without `references/`, and every unseeded copy passes.
- **SC-003**: The constitution has 80 rules, version 10.5.0, and five rules in Principle XIV, each with a named clause or "None (Highway pattern)".
- **SC-004**: The full suite passes with 86 tests, and no test or live document names `tests/skill-flow-pattern.test.sh`.
- **SC-005**: Validating any two different skills with the cache on gives two reports, each naming its own skill. With hashing forced to fail, the report matches a run with the cache off.
- **SC-006**: Running the catalog and agent adapter generators after the change modifies no file.

## Assumptions

- Phase 14 (spec 242) and the harness follow-ups (specs 243 and 244) are merged on `main`, with 87 passing tests and every skill following the flow pattern.
- Principle XIV takes rank 12 in Principle Precedence, below Principle XI. It governs how a skill's files are laid out for an Agent Skills client, and no current rule conflicts with it. P5.15 moving from rank 4 to rank 12 changes no verdict, because it conflicts with no rule.
- The new rule ids are P14.1 to P14.4. No P14 id was ever used, so none is reused.
- The narrowed clauses are named by the specification's section headings, as Phase 15 lists them. The specification is not added to the Approved Authority Sources, which govern what a skill cites.
- No live harness run is part of the exit (see Clarifications). If the work changes `framework/lib/flows.sh` after all, that decision is revisited.
- The cache defect in User Story 5 was observed in a sandboxed shell. It is fixed here because Handoff integrity changes what the key must cover, and the same change makes the key fail closed.
- Constraints carried from earlier work: do not commit unless asked; secrets and tokens are redacted; `rollout-plan.md` stays gitignored and excluded in the distribution manifest; MINOR version bumps only; no backward compatibility; use `mv`, not `git mv`.
