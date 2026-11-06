# Feature Specification: Single Rule Shape

**Feature Branch**: `221-single-rule-shape`

**Created**: 2026-11-06

**Status**: Draft

**Input**: User description: "Expand the proposed coding-standard limit to 15. Enforce a single rule per item. Limit each rule to 8 words. Include **Why it matters:** under each rule, the same way When to use and When not to use show it."

## Clarifications

### Session 2026-11-06

- Q: When an existing coding standard is updated, what happens to a saved rule that is longer than eight words or states two outcomes? → A: A standard holds as many rules as the person wants. The model suggests at most fifteen. A rule the person provides that lacks must, is over eight words, or combines rules is rewritten to conform, and that rewrite is stated in the consequence sentence before the updated proposal is presented.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - A proposal offers one rule at a time (Priority: P1)

A person adds or updates a coding standard. Each rule contains must once, names one condition and one outcome, and stays within eight words. A path, a hyphenated word, and a placeholder each count as one word. A second outcome joined by and, or, or a comma is written as its own rule. The model suggests at most fifteen rules. Rules the person provides are kept beyond that.

**Why this priority**: The rule the person accepts becomes the limit the standard enforces. A paragraph that hides several musts accepts all of them at once.

**Independent Test**: Propose a platform standard whose documentation describes several constraints in one sentence. The proposal lists one rule per constraint. Each rule has must once and eight words or fewer. The model suggests at most fifteen.

**Acceptance Scenarios**:

1. **Given** an add, **When** the proposal is first shown, **Then** every rule contains must once, names one condition and one outcome, and has eight words or fewer, and the model has suggested at most fifteen.
2. **Given** a documented sentence with two outcomes joined by and, or, or a comma, **When** the proposal is first shown, **Then** those outcomes are two rules.
3. **Given** a rule that names a path, a hyphenated word, or a placeholder, **When** its words are counted, **Then** each of those counts as one word.
4. **Given** a saved standard with more than fifteen rules the person provided, **When** it is updated, **Then** every one of those rules is still on the proposal, and the model suggests at most fifteen further rules.

---

### User Story 2 - Why it matters states the consequence of the rule (Priority: P1)

Under each rule on an add or an update, the person reads a blank line, then **Why it matters:** and one sentence stating the consequence of that rule. The saved standard and the catalog keep the rule line only.

**Why this priority**: The consequence belongs next to the rule the person is accepting. The stored rule still has to stand once that sentence is gone.

**Independent Test**: Read an add proposal and the standard file written from it. The proposal has a blank line and one consequence sentence under each rule. The file and the catalog cell have the rule only.

**Acceptance Scenarios**:

1. **Given** an add or an update proposal, **When** its shape is read, **Then** each rule is followed by a blank line, then **Why it matters:** and one sentence, indented under the rule.
2. **Given** that sentence, **When** it is read, **Then** it states the consequence of that rule, and it names no customer, product, or decision of this organization.
3. **Given** a catalog view, a conflict quote, or the saved standard file, **When** it is read, **Then** it holds the rule only and has no **Why it matters:** line.

---

### User Story 3 - A provided rule that breaks the limit is rewritten before the proposal (Priority: P1)

A person provides a rule that lacks must, runs past eight words, or combines rules. The model rewrites it so it conforms, states that rewrite in the consequence sentence that opens the proposal, and then presents the updated proposal. A saved rule that already conforms is kept. A saved rule that does not conform is rewritten the same way.

**Why this priority**: The proposal the person reads already conforms. The opening sentence tells them what was rewritten before they read the rules.

**Independent Test**: Edit onto a proposal a rule with no must, a rule of nine words, and a rule that joins two outcomes. The next proposal shows the rewritten rules, and the sentence before it states each rewrite. The non-conforming wording is not on the proposal.

**Acceptance Scenarios**:

1. **Given** a saved rule within eight words and one must, **When** the standard is updated, **Then** the proposal keeps that rule.
2. **Given** a rule the person provides that lacks must, has more than eight words, or combines rules, **When** the proposal is presented, **Then** the rule has been rewritten to conform, and the consequence sentence before the proposal states the rewrite.
3. **Given** a saved rule that lacks must, has more than eight words, or combines rules, **When** the standard is updated, **Then** it is rewritten the same way, and the opening consequence sentence states the rewrite.
4. **Given** a remove, **When** its proposal is shown, **Then** the saved rules appear as stored, and `rule shape` does not run.

---

### User Story 4 - The rule limits are ordered steps (Priority: P1)

A maintainer reads the instructions that write rules. The shape lives in `rule shape`. `standard rules` follows it, suggests at most fifteen rules, and still requires the credentials rule.

**Why this priority**: The word limit, the one-outcome split, and the consequence line do not fit in `standard rules` beside the rules it already has.

**Independent Test**: Read `rule shape` and `standard rules`. `rule shape` stands immediately after `standard rules` and immediately before `standard proposal`. Each of those two steps has 250 words or fewer.

**Acceptance Scenarios**:

1. **Given** the procedure headings, **When** they are read in order, **Then** `rule shape` stands immediately after `standard rules` and immediately before `standard proposal`.
2. **Given** an add or an update, **When** `standard rules` writes the rules, **Then** it follows `rule shape` and writes the rules that step returned.
3. **Given** `rule shape` and the changed `standard rules` steps, **When** they are read, **Then** each is a numbered condition and action, and none contains so that, because, in order to, should, consider, prefer, usually, or where appropriate.
4. **Given** either step, **When** its words are counted, **Then** the count is 250 or fewer, excluding the heading.

---

### Edge Cases

- A rule of exactly eight words is kept. A rule of nine words is rewritten before the proposal is presented.
- A rule the person provides with no must is rewritten to contain must once before the proposal is presented.
- A slash inside a path is part of that one word. A slash is not a join between two outcomes.
- Rules the person provides do not count toward the fifteen suggestions. A standard can hold more than fifteen rules. A suggestion beyond the fifteen is left out. A rule the person provided is not left out to make room.
- When the suggestions exceed fifteen, the credentials rule stays among the suggestions, the later suggestions are left out, and each left-out suggestion is named in the consequence sentence that opens the proposal.
- When fifteen suggestions lack the credentials rule, the last suggestion is left out, or the last suggestion the documentation no longer describes, and that suggestion is named in the same opening sentence. The credentials rule is then included. A rule the person provided is not the one left out.
- When the documentation names a supported way to store credentials, that way is its own suggestion and follows `rule shape`. When it names none, the credentials rule names no product.
- A question or an unknown re-shows the same proposal. It does not build the rules again.
- A remove shows the saved rules as stored and does not run `standard rules` or `rule shape`.
- When to use and When not to use stay as they are. This spec does not change their five-word limit, their classes, or their **Why it matters:** line.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: `highway-codify-config` MUST add `rule shape` immediately after `standard rules` and immediately before `standard proposal`, with these steps:

  1. Write one rule with must once, one condition, and one outcome, in eight words or fewer. Count a path, a hyphenated word, and a placeholder as one word.
  2. A second outcome joined by and, or, or a comma is a separate rule. A slash that is part of a path stays inside that one word.
  3. When a rule the person provides, or a saved rule, lacks must, has more than eight words, or combines rules, rewrite it to conform before the proposal is presented. State that rewrite in the consequence sentence that opens the proposal. Keep a saved rule that conforms.
  4. Under each rule, emit **Why it matters:** and one sentence stating the consequence of that rule. Name no customer, product, or decision of this organization. The catalog view, a conflict quote, and the saved cell keep the rule only.
  5. Return to `standard rules`.

- **FR-002**: `standard rules` MUST keep its current step numbers and change these steps:

  1. When no standard file exists, suggest at most fifteen rules from the documentation `current` read. Use the file and folder structure that documentation recommends.
  3. Follow `rule shape`, then write the rules it returned. When the suggestions exceed fifteen, keep the credentials rule, leave out the later suggestions, and name each left-out suggestion in the consequence sentence that opens the proposal. Do not leave out a rule the person provided.
  5. Include one rule, once, that keeps encoded or encrypted credentials outside this standard's files. When the documentation names a supported way to encrypt or store them, require that way in its own rule. Both follow `rule shape`. When it names none, name no product.
  6. When fifteen suggestions lack the credentials rule, leave out the last suggestion the documentation no longer describes, or the last suggestion when all are still described. Name it in the consequence sentence that opens the proposal. Do not leave out a rule the person provided.

  Steps 2, 4, 7, 8, and 9 stay as they are.

- **FR-003**: The `standard proposal` shape MUST show each rule in this form, blank line included:

  ```markdown
  1. [Rule]

     **Why it matters:** [One sentence stating the consequence of this rule.]
  ```

  `rule shape` step 4 names **Why it matters:** and does not state this line break. The sentence under the rule states the consequence of that rule. It names no customer, product, or decision of this organization. The consequence sentence that opens the proposal states each rewrite and each suggestion left out by the fifteen-suggestion cap.

- **FR-004**: A rule the person provides that lacks must, has more than eight words, or combines rules MUST be rewritten to conform before the updated proposal is presented. The consequence sentence before that proposal MUST state the rewrite. A saved rule that does not conform MUST be rewritten the same way on an update. A saved rule that conforms MUST be kept. The rewritten wording is what the proposal shows.
- **FR-005**: The model MUST suggest at most fifteen rules. Rules the person provides, including rules kept from the saved standard, do not count toward that fifteen and MUST NOT be left out to make room. On an add, the model suggests at most fifteen from the documentation, and the credentials rule is one of them. On an update, every conforming saved rule is kept, and the model suggests at most fifteen further rules. A storage way the documentation names is a suggestion and counts toward the fifteen.
- **FR-006**: The saved standard file MUST keep each accepted rule, with no cap on how many, and MUST NOT contain a **Why it matters:** line. The catalog cell MUST keep the rule only. The coding-standard skeleton MUST say that one rule contains must once, one condition, and one outcome, in eight words or fewer, and that the model suggests at most fifteen. The skeleton MUST NOT cap the number of rules the file holds. The skeleton MUST keep the statement that the file does not contain a Why it matters line.
- **FR-007**: `rule shape` MUST stay at 250 words or fewer, excluding its heading. `standard rules` MUST stay at 250 words or fewer, excluding its heading.
- **FR-008**: `rule shape` and every changed `standard rules` step MUST be numbered conditions and actions, and MUST NOT contain so that, because, in order to, should, consider, prefer, usually, or where appropriate.
- **FR-009**: `highway-codify-config` MUST move from 3.2.3 to 3.2.4. The coding-standard template MUST move from 3.0.0 to 3.0.1.
- **FR-010**: A remove MUST keep its current behavior: show the saved rules and do not run `standard rules` or `rule shape`.
- **FR-011**: When to use and When not to use MUST stay as they are, including the five-word limit, the class rules, and the **Why it matters:** line under each entry.

### Key Entities

- **Rule**: one condition, the word must once, and one outcome, in eight words or fewer. A path, a hyphenated word, and a placeholder each count as one word.
- **Suggestion**: a rule the model proposes from the documentation. An add has at most fifteen. An update adds at most fifteen further suggestions. A rule the person provides is not a suggestion.
- **Second outcome**: another required result joined to a rule by and, or, or a comma. It is written as its own rule. A slash inside a path is not one.
- **Opening consequence sentence**: the one sentence before the proposal. It states each rewrite and each suggestion left out by the fifteen-suggestion cap.
- **Why it matters**: the one sentence under a rule on the proposal. It states the consequence of that rule. The saved standard and the catalog do not keep it.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: On an add, every rule contains must once, names one condition and one outcome, and has eight words or fewer, and the model suggests at most fifteen rules.
- **SC-002**: A documented sentence with two outcomes joined by and, or, or a comma appears as two rules.
- **SC-003**: On an add or an update, each rule has a blank line and one **Why it matters:** consequence sentence, and the saved standard and the catalog cell contain the rule only.
- **SC-004**: A rule the person provides, or a saved rule, that lacks must, exceeds eight words, or combines rules is rewritten before the proposal is presented. The sentence before that proposal states the rewrite. The proposal shows the rewritten rule.
- **SC-005**: A saved standard with more than fifteen rules the person provided still shows every one of those rules on update. The model suggests at most fifteen further rules. The credentials rule is present once. A storage way the documentation names is a separate suggestion inside those fifteen.
- **SC-006**: `rule shape` and `standard rules` each have 250 words or fewer.
- **SC-007**: The existing suite passes with 0 failures after the change.

## Assumptions

- Eight words is enough for one condition, must, and one outcome. The consequence of the rule, including what fails when the rule is broken, goes in **Why it matters:** and is not part of the eight. A rewrite is reported in the opening consequence sentence, not under the rule.
- A path counts as one word, including the slashes in it. A hyphenated word counts as one word, as an entry already does. A placeholder in angle brackets, such as `<module>`, counts as one word.
- "One rule" means one must, one condition, and one outcome. A sentence that reaches a second outcome with and, or, or a comma combines rules, even when it still has eight words or fewer.
- There is no compatibility obligation to keep a non-conforming saved rule. An update rewrites it before the proposal is presented. A conforming saved rule is kept, and the proposal does not rebuild the person's rules from the documentation.
- The catalog, the conflict quote, and the saved standard stay the rule alone. This spec adds no stored field. The opening consequence sentence stays. It carries each rewrite and each suggestion left out by the fifteen-suggestion cap. On a remove it says the standard file remains and is no longer used.
- The credentials rule remains one rule. The supported storage way, when the documentation names one, is a second suggestion so both can fit in eight words. When the documentation names no way, that second suggestion is absent and the credentials rule names no product.
- Adding `rule shape` and shortening the rules a proposal offers is a wording change. The skill version change is PATCH, 3.2.3 to 3.2.4. The template sentence for a rule changes, so the template version change is PATCH, 3.0.0 to 3.0.1.
- Tests that pin the replaced `standard rules` sentences, the ten-rule skeleton line, and the heading order around `standard proposal` move with reasons recorded in planning. The sentences this spec replaces are the ten-rule sentence in step 1, the must sentence in step 3, the credentials sentence in step 5, and the ten-rule sentence in step 6.
- When to use and When not to use are unchanged. Their blank line and **Why it matters:** line are the pattern this spec copies for the line under a rule. A When to use entry the person adds is still kept as written. A coding rule the person provides is rewritten when it does not conform.
