# Research: Codify Feature Wording, Governance, and Plan

## R1. Where each decision lives

- **Decision**: Five new steps, in this order: `govern` after `align`, then the existing path through `index`, then `plan`, `check`, `menu`, and `tasks`. The text is [contracts/feature-steps.md](contracts/feature-steps.md). Drafted sizes are 170, 142, 108, 56, and 142 words.
- **Rationale**: `project` is 395 words and `suggest` is 388. `align` is 269. FR-017 gives a decision that does not fit its own step. The Controls check, the plan, the questions, the menu, and the task list are separate decisions.
- **Alternatives considered**: Put the Controls check inside `align`. Rejected because the two checks name different sources and `align` would cross 400 words once both are stated.

## R2. What stays inside an existing step

- **Decision**: `propose` replaces the heading, adds the specification sentence after `If this is accurate, just say so.`, and lists the applied Controls and NFRs. `revise` gains one line that refuses an edit breaking a listed Control or NFR. `code` reads each listed Control and NFR that is still active. `write` stops writing the task list. `index` goes to `plan` and treats a feature with no task list as open. Entry sends a plan with no task list to `menu`, and an open task to `code`.
`project` step 2 sends a resumed feature with no task list to `menu`. Step 2 is reworded so `project` stays at or under 400 words.

- **Rationale**: `propose` is 175 words. The three additions fit. The refused edit is one condition beside the other edit lines. Moving the task list out of `write` also keeps `write` under the 250-word cap in `codify-write-refactor.test.sh`.
- **Alternatives considered**: A separate step for the heading. Rejected. The heading is one line of the block `propose` already emits.

## R3. The plan file

- **Decision**: `codify-plan.md` 1.0.0 has sections for stories, edge cases, functional requirements, and decisions. Data and interface sections are omitted unless FR-011 includes them. The accepted proposal is not copied into the file.
- **Rationale**: FR-011. The proposal remains the specification.

## R4. The task list

- **Decision**: `codify-tasks.md` 6.0.0 keeps the current line shape, the Provider, and `Tests: required`. Lines are grouped under a story heading. The heading states how that story is tested on its own. `tasks` compares the list with the plan before `code` writes a file.
- **Rationale**: FR-015. The line shape is what existing checks require. The order is the new contract.

## R5. Questions

- **Decision**: `check` asks one question at a time, at most five, and only when the answer changes a story and nothing accepted decides it. Further qualifying questions are assumptions in the plan. When none qualify, `menu` appears and `check` says nothing.
- **Rationale**: FR-012. One question at a time matches the experience standard's single unresolved question.

## R6. Saved Controls and NFRs

- **Decision**: The applied titles are a section of `codify.md`. Coding reads those titles. A title whose catalog row is removed is skipped. A Control or NFR accepted after the proposal is not added to a feature that is already coding.
- **Rationale**: FR-007 and FR-009, and the edge case that a later acceptance waits for the next proposal.

## R7. Replaced assertions (D3.5)

- `codify-file-layout.test.sh`, `codify-config-skill.test.sh`, `codify-platform-catalog.test.sh`, `codify-closing-guide.test.sh`, `codify-write-refactor.test.sh`, `propose-edit-lines.test.sh`, and `codify-products.test.sh`: the `highway-codify` pin moves from `version: 10.0.0` to `version: 11.0.0`. The onboarding pin in `codify-platform-catalog.test.sh` stays. Reason: MAJOR bump of codify only.
- `codify-file-layout.test.sh`, `codify-config-skill.test.sh`, `codify-platform-catalog.test.sh`, `codify-closing-guide.test.sh`, and `codify-products.test.sh`: the record pin moves from `version: 8.0.0` to `version: 9.0.0`. Reason: the record gains the Controls and NFRs section.
- `codify-file-layout.test.sh`, `codify-config-skill.test.sh`, `codify-platform-catalog.test.sh`, and `codify-products.test.sh`: the task-list pin moves from `version: 5.0.0` to `version: 6.0.0`. Reason: lines are grouped by story.
- `codify-write-refactor.test.sh`: unchanged. `write` still names `codify-tasks.md`, in the sentence that it is not written there.
- `highway-codify.test.sh`: `Here is a proposed starting point for your automation:` becomes `Here is a proposed starting point for your codify feature:`. Reason: FR-001.
- `codify-closing-guide.test.sh`: `just ask highway to show your code catalog` becomes `just ask Highway to show your Code Catalog`. Reason: FR-004.
