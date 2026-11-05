# Data Model: Codify Feature Wording, Governance, and Plan

## Applied Controls and NFRs

Held on the draft, shown on the proposal, and saved in `codify.md`.

| Field | Rule |
|---|---|
| Titles | Each active Control or NFR whose statement covers something a task does, touches, or stores. Or the sentence `No Control or NFR applies.` |
| Mechanism | When the task touches the selected implementation, the task uses the mechanism named in Security Control Realization or NFR Realization |
| Precedence | A Control or NFR wins over a coding standard. Two Controls, or two NFRs, use the earlier catalog row. A Control wins over an NFR. The proposal names the title applied and the title that gave way |
| Later change | A Control or NFR accepted after this proposal applies to the next proposal. Coding skips a saved title whose catalog row is removed |

A missing Controls catalog and a missing NFRs catalog produce `No Control or NFR applies.` The run continues.

## Feature plan

`code/<folder>/.highway/features/<number>-<action>/plan.md`. Written after the accepted proposal. The proposal is not copied.

| Section | Rule |
|---|---|
| Stories | One outcome a person can see, plus the condition that shows it is done. Each proposal task's outcome is a story, including when that outcome is the task. Scope, method, standards, and files are absent |
| Edge cases | A situation the proposal's acceptance criteria do not name |
| Functional requirements | From the accepted proposal, an applied Control or NFR, or a coding standard on a task. Each applied title names its story |
| Decisions | Present only when a choice remained. What was chosen, why, and what was rejected. An assumption from an unasked question is a decision |
| Data | Present only when the feature has state |
| Interface | Present only when the proposal names an endpoint, a file format, or a command |

## Task list

`codify-tasks.md` beside the plan. Absent until the person continues.

| Rule | Holds |
|---|---|
| Order | Story order. Under each story, the line that says how it is tested, then that story's tasks |
| Line | The current line shape. Each task names its file. `Tests: required` still places a test first |
| Check | Before the first file, a story with no proposal task gains one. Every proposal task has a line, under the story it delivers or under a heading taken from that task. A line that names work the proposal does not list is left out |

## Resume

| Feature state | Next step |
|---|---|
| Plan, no task list | `menu` |
| Task list with an open task | `code` at that task |
| Every task done | `close` |
| Declined | Nothing written |
