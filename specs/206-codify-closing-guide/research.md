# Research: Codify Closing Guide

## R1. Two closes, chosen by task progress

- **Decision**: `close` has two variants. When every task is done, emit the completion message. When a task could not be finished, emit the current stopped-task block: the record and task-list paths, title, implementation, the stopped task and reason, and "The automation was not run." Applicable coding-standard notices come first in either variant.
- **Rationale**: The person's text says the stage is complete, which is false for a stopped run. The stopped block already names where the next run starts.
- **Alternatives considered**: One close with conditional lines. Rejected because the completion message is fixed text, and mixing in stopped-task lines would break it.

## R2. Completion message text

- **Decision**: Emit the person's text exactly, with one added line, "The automation was not run.", between the knowledge-base paragraph and **The files can be found here:**. `[relative path to files]` is `` `code/[ID]/` `` and `[relative path to README.md]` is `` `code/[ID]/README.md` ``. "ask highway" stays lowercase as written.
- **Rationale**: The clarification chose this position. Showing paths as code matches how codify shows every other path.
- **Alternatives considered**: Normalizing "highway" to "Highway". Rejected because the person supplied exact wording.

## R3. Catalog entry position

- **Decision**: Entry step 3 is the catalog request: the invocation is the word `catalog`, or asks to show the code catalog. It follows the `configure` step and comes before resuming a task list or selecting an implementation.
- **Rationale**: "Show my code catalog" must not be read as a description that triggers `choose`, and `catalog` must not match an automation title for resume.
- **Usage line**: The frontmatter `usage` stays "Invoke as /highway-codify with one implementation name." The frontmatter lexicon rejects `catalog` and `configure`, and `When to use` already names both invocations.

## R2a. Completion message placement in the skill

- **Decision**: The completion message sits in a fenced `markdown` block inside `close`, emitted exactly as rendered markdown.
- **Rationale**: Its first line is a `###` heading. Written bare, it would read as a new procedure step.
- **Catalog progress wording**: The catalog line reads "[Task [T###] is next. Or, when no task is open: Every task is done.]" so it does not repeat the removed close alternative "[Every task is done. Or: Task".

## R4. Recency and the catalog view

- **Decision**: `code/code.md` rows are in acceptance order. `write` appends a new row last, and a row whose status changes keeps its position. The view reads accepted rows only, takes the last five, and numbers them from 1, newest first. Each line shows the automation title, the implementation title from `implementations/implementations.md`, and "Every task is done." or "Task [T###] is next." from that automation's task list. When more than five accepted rows exist, add "[N] more automations are not shown.", or "1 more automation is not shown." when N is 1. The question is **Which automation would you like to discuss?** When some are not shown, add "You can name or describe any automation."
- **Rationale**: Acceptance order gives recency with no new column and no timestamp. Codify already emits no timestamp.
- **Alternatives considered**: An `Accepted` date column. Rejected in clarification. Keeping ID order. Rejected because the last rows would not be the most recent.

## R5. Discussing one automation

- **Decision**: A number, an exact title compared without regard to case, or a description selects an accepted automation. A description matching several lists those matches, newest first, at most five, and asks again. A description matching none says so and asks again. A selection shows the title, `**Files:**` `code/[ID]/`, and `**Setup and Usage Instructions:**` `code/[ID]/README.md`, or "The instructions are not written yet." when the README task is open. It then asks **What would you like to know about it?** `decline` stops.
- **Rationale**: The completion message offers to review files and instructions together. The selection gives the same two paths, and the conversation continues from there. No step writes.

## R6. README template sentence

- **Decision**: In `codify-record.md`, the Readme block headings become `## Setup Instructions` and `## User Guide`. The sentence after it becomes "Setup Instructions is for the person who accepted the proposal. User Guide follows the interface of the Provider." The skill's README task uses the same names.
- **Rationale**: The template still says Use follows the interface of the accepted architecture, while the skill says the Provider after spec 205. One wording removes the mismatch.

## R7. Replaced assertions (D3.5)

- **Decision**:
  - `highway-codify.test.sh`: `'## Implement'` becomes `'## Setup Instructions'`, and `'## Use'` becomes `'## User Guide'`. Reason: the feature renames the README parts. The checks still require both headings in the same files.
  - `codify-platform-catalog.test.sh`: the `highway-codify` pin `version: 5.0.0` becomes `version: 6.0.0`, and the `codify-record.md` pin `version: 4.0.0` becomes `version: 5.0.0`. Reason: both sources take a MAJOR bump for this feature. The Provider and diagram checks in that file are unchanged.
- **Rationale**: Each replacement checks the same thing at the same strength.
