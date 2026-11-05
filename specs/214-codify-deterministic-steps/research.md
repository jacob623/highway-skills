# Research: Codify Deterministic Steps

## R1. Step names

- **Decision**: `rank` holds the suggestion order and calls `codified`. `suggest` holds the list and the replies. `draft` then `provider` replace `start`. `resume`, `join`, and `folder` replace `project`. The procedure order names these steps. Routes that said `start` say `draft`. Routes that said `project` say `resume`.
- **Rationale**: The spec splits each long step where the decision changes, and the replies stay on the step the person is answering.
- **Alternatives considered**: Keeping the old names and adding a second step under each. The tests that require one `### project` would pass, and the procedure would still have two names for one decision.

## R2. Entry match

- **Decision**: Split When to use and When not to use on `; ` and trim each entry. An entry appears on its own when a boundary sits on each side: the start or end of the text, or a character that is not a letter or digit. Case is ignored. A blank When to use does not match. A platform row is compared with the action and the method. A coding-standard candidate is compared with the action, the method, and the Provider.
- **Rationale**: This is the spec's "on its own" rule. It stops `run` from matching `runtime`.
- **Alternatives considered**: A substring match. The spec rejected it.

## R3. Provider

- **Decision**: A platform the person named stays the Provider, including when it has no catalog row. The existing notice stays. When none is named, the earliest matching platform row is the Provider. When no row matches, this implementation's row is used, then the first row. When the catalog has no rows and none is named, the Provider stays unset.
- **Rationale**: Clarification on 2026-11-05. The entry match replaces only the fit test.
- **Alternatives considered**: Always taking the earliest matching row. That would replace a platform the person named.

## R4. Coding standards

- **Decision**: A row is a candidate only when its File Patterns match a file the method names, or its Technology names the method or the Provider. The entry match then keeps or drops that candidate. Inheritance order stays. The earlier standard wins a disagreement.
- **Rationale**: Clarification on 2026-11-05. The entry match replaces only When to use and When not to use.
- **Alternatives considered**: Including every row whose entries appear. That would add a standard for a different kind of file.

## R5. Plan story

- **Decision**: One story per proposal task, in task order. The title is that task's action. Done when is the earliest acceptance criterion that contains that action, ignoring case. Otherwise Done when is the Scope sentence. Scope, method, standards, and files are not written. The sentence "The accepted proposal is not copied" is removed from the skill and from `codify-plan.md`. The template moves to 2.0.0.
- **Rationale**: The review reads the plan. The story title is the action, so the task list can place each line by that title.
- **Alternatives considered**: Leaving Done when for the agent to compose. The spec copies an existing sentence.

## R6. Control match

- **Decision**: A Control or NFR applies when its statement contains, ignoring case, the task's target, a file name or path written in the task, or the mechanism that realization names for it. After `layout` places files, the same match runs on those paths and adds a match. It does not drop one already held. The list stays Controls first, in catalog order, then NFRs.
- **Rationale**: The spec replaces "covers" with a shared name, and files exist only after layout.
- **Alternatives considered**: Matching only at `govern`, before files exist. A placed path would never count.

## R7. Check and task placement

- **Decision**: A gap is a story with no Done when, a repeated story title, or an applied Control or NFR that no story names, when nothing accepted answers it. Stories are walked in plan order, then the applied titles in proposal order. The first five are asked, one at a time. The rest are assumptions. Each proposal task's line sits under the story whose title is that action. A story title that is not an action still gets one line. The words "the story it delivers" are removed.
- **Rationale**: The spec replaces "the five that change the most stories."
- **Alternatives considered**: Ranking gaps by how many stories they change. Two runs would ask different questions.

## R8. Version pins

`highway-codify` moves from 11.0.0 to 12.0.0. `codify-plan.md` moves from 1.0.0 to 2.0.0.

Pins that move:

- `codify-feature-wording.test.sh`: skill 11.0.0 to 12.0.0, plan template 1.0.0 to 2.0.0
- `propose-edit-lines.test.sh`, `codify-write-refactor.test.sh`, `codify-products.test.sh`, `codify-config-skill.test.sh`, `codify-platform-catalog.test.sh`, `codify-file-layout.test.sh`, `codify-closing-guide.test.sh`: skill 11.0.0 to 12.0.0

`codify-metadata.md` and `codify-integrations.md` stay at 1.0.0.

## R9. Moved assertions

- `codify-feature-wording.test.sh` stops requiring "The accepted proposal is not copied." Reason: R5 replaces that sentence with the story rule. The test requires the story rule instead.
- `codify-feature-wording.test.sh` stops requiring `### project` in that position. Reason: R1 splits it into `resume`, `join`, and `folder`. The test requires those three, in that order, where `project` stood.
- `codify-products.test.sh` stops requiring `### project` and stops reading the product sentences from `### project`. Reason: R1. Each sentence is required in the step that now holds it: `resume`, `join`, or `folder`. No sentence is dropped.
- `codify-write-refactor.test.sh` stops requiring `### codified` to follow `### suggest`. Reason: R1 places `codified` after `rank` and leaves the replies on `suggest`. The test requires `codified` to follow `rank`.
- `codify-feature-wording.test.sh` stops requiring "Ask one question." and "Ask at most five." in `check`. Reason: R7 asks the first five gaps, one at a time. The test requires "Ask the first five" and "one at a time."
- `codify-feature-wording.test.sh` stops requiring "The plan holds every outcome, so a review of it is the whole plan." and "Each proposal task's outcome is a story, including when that outcome is the task." Reason: R5. The test requires "The plan holds one story per proposal task, so a review of it is the whole plan.", "One story per proposal task, in task order.", and "The title is that task's action."
- `codify-feature-wording.test.sh` stops requiring "A proposal task that delivers no story gets a heading from that task" in `tasks`. Reason: R7 places a line by story title. The test requires "the story whose title is that task's action." The heading-from-the-task sentence stays in `codify-tasks.md`.
- A verification sentence that a step already states is removed from Verification. A test that required it there requires it in the step. Reason: the second copy is the behavior this feature removes.
