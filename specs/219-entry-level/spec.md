# Feature Specification: Entry Level

**Feature Branch**: `219-entry-level`

**Created**: 2026-11-06

**Status**: Draft

**Input**: User description: "When highway-codify-config proposes When to use and When not to use, the entries are too granular for a proposal a person accepts and is then limited by. The person can add that granularity. The proposal stays at the level of the examples: for an agent, Agentic automation, Local machine execution, Human in the loop, MCP integration, Sensitive data handling, Autonomous automation; for a pipeline, Continuous integration, Continuous delivery, File-based triggers, Workflow orchestration."

## Clarifications

### Session 2026-11-06

- Q: On a coding standard proposal, should the high-level classes, the blank line, and **Why it matters:** as the consequence apply only to When to use and When not to use? → A: Yes. The coding rules stay as they are.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - A proposal names classes of automation (Priority: P1)

A person adds a platform or a coding standard. Each When to use and When not to use entry names a class of automation that type is for, or is not for. An agent proposal draws from classes such as Agentic automation, Local machine execution, Human in the loop, MCP integration, Sensitive data handling, and Autonomous automation. A pipeline proposal draws from classes such as Continuous integration, Continuous delivery, File-based triggers, and Workflow orchestration. Any other type, including a language standard, uses that same level.

**Why this priority**: The proposal the person accepts becomes the limit on later use. A list of jobs, such as code change proposals or bug investigation, makes that limit narrower than the person asked for.

**Independent Test**: Add an agent platform, a pipeline platform, and a coding standard. Every When to use and When not to use entry is a class at the example level. None of the entries is Code change proposals, Pull request review, Bug investigation, or Test authoring.

**Acceptance Scenarios**:

1. **Given** an agent add, **When** the proposal is first shown, **Then** each When to use and When not to use entry is a class at the agent example level, and a class appears only when `current` describes it for that agent.
2. **Given** a pipeline add, **When** the proposal is first shown, **Then** each entry is a class at the pipeline example level, and a class appears only when `current` describes it for that pipeline.
3. **Given** a coding standard add, **When** the proposal is first shown, **Then** each When to use and When not to use entry is a class at the same level, a class appears only when `current` describes it for that language or platform, each list has at most four entries, a blank line then **Why it matters:** states the consequence of that entry, and the proposal has no **Consequences:** section.
4. **Given** any other type, **When** the proposal is first shown, **Then** each entry is a class at the same level as the agent and pipeline examples.
5. **Given** any add, including a coding standard, **When** the proposal is first shown, **Then** no entry is a task. Code change proposals, Pull request review, Bug investigation, and Test authoring do not appear.
6. **Given** any add, including a coding standard, **When** the entries are counted, **Then** When to use has at most four and When not to use has at most four, and each list has at least one.

---

### User Story 2 - The person can add a specific entry (Priority: P2)

A person wants a narrower entry than the proposal offered. They add it. A later update of that platform or standard keeps it.

**Why this priority**: The proposal stays broad. The accepted catalog can still hold the specific limit the person writes.

**Independent Test**: On an agent proposal, add Bug investigation. Accept it. Update that platform. Bug investigation is still an entry. Do the same on a coding standard. The added entry is still there.

**Acceptance Scenarios**:

1. **Given** an add proposal, **When** the person adds a task as an entry, **Then** the re-shown proposal includes that entry.
2. **Given** a saved entry the person added, **When** the platform or standard is updated, **Then** the proposal keeps that entry and does not replace it with a class.
3. **Given** a saved entry longer than five words, or one that joins two things, **When** the platform or standard is updated, **Then** that entry is rewritten and its **Why it matters:** sentence states the rewrite.
4. **Given** a remove, **When** its proposal is shown, **Then** the saved entries appear as stored, and `entry level` does not run.

---

### User Story 3 - Why it matters states the consequence of the entry (Priority: P1)

Under each entry, the person reads **Why it matters:** and one sentence stating the consequence of that entry. The platform proposal and the standard proposal have no **Consequences:** section.

**Why this priority**: The consequence belongs to the entry the person is accepting. A separate Consequences section repeats it away from that entry.

**Independent Test**: Read a platform proposal and a standard proposal. Each entry has a blank line, then **Why it matters:** and one consequence sentence. Neither proposal has a **Consequences:** section.

**Acceptance Scenarios**:

1. **Given** a platform proposal or a standard proposal, **When** its shape is read, **Then** each entry is followed by a blank line, then **Why it matters:** and one sentence, indented under the entry.
2. **Given** that sentence, **When** it is read, **Then** it states the consequence of that entry for the work Highway proposes, and it names no customer, product, or decision of this organization.
3. **Given** either proposal shape, **When** it is read, **Then** it has no **Consequences:** section. **Conflicts:** follows the fields that remain.
4. **Given** a catalog view, a conflict quote, or a saved cell, **When** it is read, **Then** it holds the entry only.

---

### User Story 4 - The class rules are one ordered step (Priority: P1)

A maintainer reads the instructions that choose entries. They are numbered conditions and actions in `entry level`, and `use entries` follows that step on an add.

**Why this priority**: The class lists, the task examples, and the limit of four do not fit in `use entries`, which is already near its 250-word limit.

**Independent Test**: Read `entry level` and `use entries`. `entry level` holds the nine steps, stands immediately before `use entries`, and has 250 words or fewer. `use entries` has 250 words or fewer.

**Acceptance Scenarios**:

1. **Given** the procedure headings, **When** they are read in order, **Then** `entry level` stands immediately after `current` and immediately before `use entries`.
2. **Given** an add, **When** `use entries` builds the lists, **Then** it follows `entry level` and writes the entries that step returned.
3. **Given** an update, **When** `use entries` builds the lists, **Then** it starts from the saved entries and does not follow `entry level`.
4. **Given** `entry level` and the changed `use entries` steps, **When** they are read, **Then** each is a numbered condition and action, and none contains so that, because, in order to, should, consider, prefer, usually, or where appropriate.

---

### Edge Cases

- When `current` describes no class, or reports that the documentation could not be read, the proposal still has one When to use class and one When not to use class, at the level of the agent and pipeline examples. Neither class comes from this organization's customers, products, data, or decisions.
- A class `current` does not describe is left out, including an example class. The example lists set the level. They are not a list to copy in full.
- A hyphenated term counts as one word, as it does today.
- A question or an unknown re-shows the same proposal. It does not build the entries again.
- An edit that adds a specific entry stays on the re-shown proposal. A later update keeps that saved entry.
- A standard add follows `entry level` through `use entries`, same as a platform add. That applies to When to use and When not to use.
- A coding rule stays a rule. It does not gain a blank line or **Why it matters:**.
- A remove does not run `use entries`, so it does not run `entry level`.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: `highway-codify-config` MUST add `entry level` immediately after `current` and immediately before `use entries`, with these steps:

  1. Propose each entry as a class of automation for the type `use entries` took. A class names what the type is for.
  2. Propose a class only when `current` describes it for this type. When `current` describes none, or could not read the documentation, propose one When to use class and one When not to use class at the level of steps 3 and 4.
  3. For an agent, propose from classes such as Agentic automation, Local machine execution, Human in the loop, MCP integration, Sensitive data handling, and Autonomous automation.
  4. For a pipeline, propose from classes such as Continuous integration, Continuous delivery, File-based triggers, and Workflow orchestration.
  5. For a coding standard, and for any other type, propose classes at the level of steps 3 and 4.
  6. A task is not an entry. Code change proposals, Pull request review, Bug investigation, and Test authoring are tasks.
  7. Propose at most four When to use entries and at most four When not to use entries.
  8. Take no class from this organization's customers, products, data, or decisions.
  9. Return to `use entries`.

- **FR-002**: On a platform add and on a coding standard add, `use entries` MUST follow `entry level` and write the entries it returned. On an update of either, `use entries` MUST start from the saved entries and MUST NOT follow `entry level`. The standard proposal's When to use and When not to use follow FR-001 and FR-004 through FR-007 and FR-013 the same way the platform proposal does.
- **FR-003**: `use entries` step 4 MUST stay "one condition or one outcome, in five words or fewer," and MUST keep counting a hyphenated term as one word. The example list in that step MUST be removed. Those examples now live in `entry level` steps 3 and 4.
- **FR-004**: On an update, a saved entry MUST be kept. A saved entry that breaks the five-word limit or joins two things with "and", "or", a comma, or a slash MUST be rewritten, and that entry's **Why it matters:** sentence MUST state the rewrite.
- **FR-005**: Each proposed entry MUST remain one condition or one outcome, five words or fewer, and one thing. A class MAY be a condition or an outcome.
- **FR-006**: When to use and When not to use MUST each hold at least one entry and at most four on an add.
- **FR-007**: The `platform proposal` shape and the `standard proposal` shape MUST show each When to use entry and each When not to use entry in this form, blank line included:

  ```markdown
  1. [Entry]

     **Why it matters:** [One sentence stating the consequence of this entry.]
  ```

  The sentence states the consequence of that entry for the work Highway proposes. It names no customer, product, or decision of this organization. `use entries` step 9 names **Why it matters:** and does not state this line break. The catalog view, a conflict quote, and the saved cell keep the entry only.
- **FR-013**: The `platform proposal` shape and the `standard proposal` shape MUST NOT contain a **Consequences:** section. **Conflicts:** follows the fields that remain. The opening sentence that states the consequence of the change stays. A rule left out by `standard rules` is named in that opening sentence. On a remove, that opening sentence says `[Standard Path]` remains and is no longer used. `resolve` is unchanged.
- **FR-008**: `entry level` MUST stay at 250 words or fewer, excluding its heading. `use entries` MUST stay at 250 words or fewer, excluding its heading.
- **FR-009**: `entry level` and every changed `use entries` step MUST be numbered conditions and actions, and MUST NOT contain so that, because, in order to, should, consider, prefer, usually, or where appropriate.
- **FR-010**: `highway-codify-config` MUST move from 3.2.1 to 3.2.2.
- **FR-011**: A remove MUST keep its current behavior: show the saved values and do not run `use entries` or `entry level`.
- **FR-012**: An entry the person adds by edit MUST appear on the re-shown proposal. A later update MUST keep that saved entry under FR-004.
- **FR-014**: The Coding Standards rule list MUST stay as it is. A rule still contains the word must and names a condition and the required outcome. At most ten rules are still proposed. A rule MUST NOT gain a blank line or **Why it matters:**. `entry level` does not apply to rules.

### Key Entities

- **Class of automation**: one When to use or When not to use entry at the level of the agent and pipeline examples. It names what the type is for, or is not for. It is one condition or one outcome, five words or fewer.
- **Task**: a job inside a class, such as Code change proposals, Pull request review, Bug investigation, or Test authoring. A proposal does not offer a task. A person can add one.
- **Saved entry**: an entry already stored for a platform or standard, including one the person added. An update keeps it, apart from the five-word and one-thing rewrites.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: On an agent add, every entry is a class at the agent example level, none of the four task names appears, and each list has from one to four entries.
- **SC-002**: On a pipeline add, every entry is a class at the pipeline example level, with the same count limits.
- **SC-003**: On a coding standard add, every When to use and When not to use entry is a class at that same level, each list has from one to four entries, each entry has a blank line then one **Why it matters:** consequence sentence, and the proposal has no **Consequences:** section.
- **SC-004**: Both proposal shapes show a blank line between each entry and its one **Why it matters:** consequence sentence, and neither shape contains a **Consequences:** section.
- **SC-005**: An entry the person adds is present after the edit and still present on the next update of that row.
- **SC-006**: `entry level` and `use entries` each have 250 words or fewer.
- **SC-007**: The existing suite passes with 0 failures after the change.

## Assumptions

- The example lists set the level. A proposal includes a listed class only when `current` describes it for this type. The proposal does not copy either list in full.
- When to use holds classes the type is for. When not to use holds classes at the same level that the type is not for. The examples do not assign a class to one list forever. An agent that `current` describes as keeping a person in the loop places Human in the loop in When to use and Autonomous automation in When not to use.
- When `current` describes nothing, or could not read the documentation, one class on each list is still required. Those two classes use the example level and do not use this organization's customers, products, data, or decisions.
- Spec 217 still holds for the five-word limit, one condition or one outcome, at least one entry on each list, and one **Why it matters:** sentence under the entry. This spec makes that sentence the consequence of the entry. It replaces the example list in `use entries` and the instruction to relate each entry to automation capabilities. A class is the best practice for the type.
- An update does not rebuild the lists from `entry level`. The person may already have narrowed them. The five-word rewrite and the one-thing rewrite still run.
- The catalog, the conflict quote, and the saved cell stay the entry alone. This spec adds no field.
- Adding one step and tightening the entries a proposal offers is a wording change. The version change is PATCH, 3.2.1 to 3.2.2.
- Tests that pin the replaced `use entries` sentences move with reasons recorded in planning. The sentences this spec replaces are the best-practice sentence in step 2, the example list in step 4, the update rewrite in step 7, and the **Why it matters:** sentence in step 9. The check that **Why it matters:** follows `1. [Entry]` on the next line moves with them. The shapes gain a blank line between the entry and **Why it matters:**. Step 9 does not describe the line break. The pin on **Consequences:** in these two shapes moves with them, because that section is removed.
- A coding standard add follows the same entry level, blank line, consequence sentence, four-entry limit, and removal of the **Consequences:** section as a platform add. Both proposals follow `use entries`. This applies to When to use and When not to use. The Coding Standards rules stay must-rules.
- The label stays **Why it matters:**. The sentence under it states the consequence of that entry, which is what the **Consequences:** section stated for the proposal. The opening consequence sentence stays. It carries a dropped rule, and on a remove it says the standard file remains and is no longer used.
