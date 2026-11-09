# Feature Specification: Codify Plan Review Question

**Feature Branch**: `231-codify-plan-review-question`

**Created**: 2026-11-09

**Status**: Draft

**Input**: User description: "If the user chooses to review the plan for a highway-codify feature prior to coding the tasks, add the What would you add, correct, or remove question, similar to the other skills. Add the question after the review and before the options to review the plan or write the code."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - A plan review ends by inviting changes (Priority: P1)

A person has accepted a codify proposal, and Highway has written the feature's plan. At the menu, they choose **Review the plan?** Highway walks them through every section of the plan. When the walkthrough ends, Highway asks **What would you add, correct, or remove?**, followed by "If this is accurate, just say so." The menu offering to review the plan or continue to code appears only after the person answers.

**Why this priority**: Today the review goes straight back to the menu. The person is never asked whether anything in the plan is wrong, which other Highway skills ask after every record they show. Without the question, the review reads as a formality, and the natural next step is to continue to code.

**Independent Test**: Run codify through a plan, choose **Review the plan?**, and confirm the question appears after the last plan section and before the menu.

**Acceptance Scenarios**:

1. **Given** the plan menu, **When** the person chooses **Review the plan?**, **Then** Highway walks through every section of the plan, then asks **What would you add, correct, or remove?** followed by "If this is accurate, just say so."
2. **Given** that question, **When** it is shown, **Then** the menu is not shown in the same message.
3. **Given** that question, **When** the person says the plan is accurate, or that nothing needs changing, **Then** Highway shows the menu again, unchanged.
4. **Given** that question, **When** the person names a change, **Then** Highway states the consequence in one sentence, updates the plan, runs the plan check, and shows the menu.
5. **Given** that question, **When** the person asks something about the plan, **Then** Highway answers and asks the question again.
6. **Given** that question, **When** the reply is unclear, **Then** Highway asks the question again.
7. **Given** that question, **When** the person stops the run, **Then** Highway stops and writes nothing more.

---

### User Story 2 - Continuing to code without reviewing is unchanged (Priority: P2)

A person who trusts the plan chooses **Continue to code the solution?** at the menu. They see no extra question and go straight to coding, as today.

**Why this priority**: The question adds a step only for people who chose to review. It must not slow the path for people who didn't.

**Independent Test**: Choose **Continue to code the solution?** at the first menu, and confirm the building sentence follows with no review question.

**Acceptance Scenarios**:

1. **Given** the plan menu, **When** the person chooses **Continue to code the solution?**, **Then** no review question is asked and coding begins as today.
2. **Given** the plan menu, **When** the person states an edit without choosing either option, **Then** Highway updates the plan, runs the plan check, and shows the menu, as today.
3. **Given** a feature with a plan and no task list, **When** codify resumes it, **Then** it resumes at the menu, as today.

---

### Edge Cases

- The person asks questions during the walkthrough, before it finishes: Highway answers and continues. The review question comes once, after the last section.
- The person chooses **Review the plan?** a second time: the walkthrough and the question repeat.
- The person replies "no" or "nothing": this means nothing needs changing, so the menu is shown. It does not stop the run.
- A change the person names would break an applied Control or NFR: the plan check handles it as it does any plan edit today.
- A change the person names belongs to the accepted proposal rather than the plan, such as a new task: the plan check already reconciles the plan with the accepted proposal. This feature does not reopen the proposal.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: When the person chooses **Review the plan?**, highway-codify MUST walk through every section of the feature's plan, then ask **What would you add, correct, or remove?** in bold, followed by "If this is accurate, just say so."
- **FR-002**: The question MUST come after the last plan section and before the menu. The menu MUST NOT appear in the same message as the question.
- **FR-003**: A reply that says the plan is accurate, or that nothing needs changing, MUST show the menu again with its wording unchanged.
- **FR-004**: A reply that names a change MUST produce one consequence sentence, update the plan, run the plan check, and then show the menu.
- **FR-005**: A question about the plan MUST be answered, and the review question MUST be asked again.
- **FR-006**: An unclear reply MUST cause the review question to be asked again.
- **FR-007**: A reply that stops the run MUST stop codify and write nothing more.
- **FR-008**: The review MUST write nothing unless the person names a change.
- **FR-009**: Choosing **Continue to code the solution?**, stating an edit at the menu, and resuming at the menu MUST behave as today. The menu's wording MUST NOT change.
- **FR-010**: highway-codify's Verification MUST state that a plan review ends with **What would you add, correct, or remove?** before the menu returns.
- **FR-011**: A test MUST pin the question, its position between the review and the menu, and each reply path. The full suite MUST pass.

### Key Entities

- **Plan menu**: The two-option choice shown after the plan is written: **Review the plan?** or **Continue to code the solution?**
- **Review question**: **What would you add, correct, or remove?**, followed by "If this is accurate, just say so." It is the same wording other Highway skills use after showing a record.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In 100% of plan reviews, the review question appears exactly once, after the last plan section and before the menu.
- **SC-002**: In 0 runs that go straight to **Continue to code the solution?** does the review question appear.
- **SC-003**: A change named in reply to the question appears in the plan the next time the menu is shown, in 100% of cases.
- **SC-004**: The question's wording matches the wording used by the other Highway skills exactly.
- **SC-005**: The full suite passes with no failures.

## Assumptions

- "Similar to the other skills" means the exact wording and order those skills use: the bold question, then "If this is accurate, just say so." The menu's own wording does not change.
- A reply naming a change follows the path a stated edit at the menu already takes: update the plan, run the plan check, show the menu. The question is not asked a second time after an edit. The person can choose **Review the plan?** again.
- The question is an acceptance request under the Experience Standard (it asks what is wrong), not a Contribution Opportunity, because the plan follows an accepted proposal.
- "No" and "nothing" in reply mean nothing needs changing. Only a clear request to stop ends the run, matching the menu's existing stop behavior.
- highway-codify's version increments under the existing versioning policy, and pins on it move with it.
- No template, catalog, or other skill changes.
