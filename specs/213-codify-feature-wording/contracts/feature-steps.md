# Contract: Feature Steps

The skill body does not use the keywords MUST or SHOULD. A step does not say should, consider, prefer, usually, or where appropriate. No step exceeds 400 words, excluding its heading.

## Order

`suggest`, with `codified`, when no action is named; then `start`, `standards`, `align`, `govern`, `project`, `layout`, `propose`, `revise`, `identifier`, `title` when needed, `write`, `index`, `plan`, `check`, `menu`, `tasks`, `code`, and `close`.

## `govern`

Insert after `align`. `align` goes to `govern`.

```markdown
### govern

Read `library/governance/controls.md` and `library/governance/nfrs.md` when present. Read each active record. Skip a removed row. Read the selected implementation's Security Control Realization and NFR Realization. Write nothing.

1. When both catalogs are absent, hold `No Control or NFR applies.` Go to `project`.
2. A Control or NFR applies when its statement covers something a task does, touches, or stores.
3. Correct the draft so each task abides by each one that applies. When the task touches this implementation, use the mechanism that realization names.
4. When a coding standard disagrees, the Control or NFR wins. Hold the standard title that gave way.
5. When two Controls disagree, or two NFRs disagree, apply the earlier catalog row. When a Control and an NFR disagree, apply the Control. Hold the title that gave way.
6. When no correction meets one for this action, emit `[Title] cannot be met for **[Action title]**.` Show no proposal. Return to `suggest`. When the invocation named the action, ask for a different action.
7. Hold the applied titles, or `No Control or NFR applies.` Hold each conflict as `[Applied title] is applied. [Other title] disagrees.`

Before the proposal, emit one line for each standard that gave way: `[Standard title] gives way to [Control or NFR title].` Go to `project`.
```

## `propose`

The heading is `**Here is a proposed starting point for your codify feature:**`.

After `If this is accurate, just say so.` add:

```markdown
Highway will use this specification to build out the solution.
```

Before **Proposed project:** add:

```markdown
**Controls and NFRs:**

- [Applied title. Or: No Control or NFR applies.]

**Conflicts:**

- [Applied title] is applied. [Other title] disagrees. [Omit this section when nothing disagrees.]
```

## `revise`

Add this line with the other edits:

```markdown
An edit that would break a listed Control or NFR is not applied. Say: [Title] stays in effect. To change a Control, run /highway-controls. To change an NFR, run /highway-nfrs.
```

## `write` and `index`

`write` does not write `codify-tasks.md`. The saved record includes Controls and NFRs after Tasks.

`index` treats a feature with no task list as open. On success, go to `plan`.

Entry: when the open feature has a plan and no task list, go to `menu`. When its task list has an open task, go to `code`.

## `plan`

```markdown
### plan

Write `code/<folder>/.highway/features/<number>-<action>/plan.md` from `.highway/library/templates/output/codify-plan.md`. The accepted proposal is not copied. The plan holds every outcome, so a review of it is the whole plan.

1. A story states one outcome a person can see and the condition that shows it is done. Each proposal task's outcome is a story, including when that outcome is the task. Copy no scope, method, standards, or files.
2. An edge case names a situation the proposal's acceptance criteria do not.
3. A functional requirement comes from the accepted proposal, an applied Control or NFR, or a coding standard on a task. Leave out any other. Each applied Control or NFR names the story that carries it.
4. Record a decision only when the proposal, the standards, and the Controls leave a choice. State what was chosen, why, and what was rejected.
5. Add a data shape only when the feature has state. Add an interface shape only when the proposal names an endpoint, a file format, or a command.

Go to `check`.
```

## `check`

```markdown
### check

Compare the plan with the accepted proposal, the standards, the Controls, the NFRs, and the implementation record.

1. When the plan contradicts the accepted proposal, or a proposal task's outcome has no story, correct the plan.
2. When accepted material answers a question, record the answer as a decision. Ask nothing.
3. Ask the person only when the answer changes a story and nothing accepted decides it. Ask one question. Write the answer into the plan. Then ask the next.
4. Ask at most five. When more qualify, ask the five that change the most stories. Record each remaining one as an assumption.
5. When none qualify, go to `menu`. Do not say the check ran.
```

## `menu`

```markdown
### menu

Emit:

The plan is complete for feature <number>-<action>. **Would you like to:**

1. Review the plan?
2. Continue to code the solution?

- `1`: read every section of `plan.md` with the person. Write nothing. Answer, then emit this menu.
- A stated edit: regenerate the plan. Go to `check`.
- `2`: go to `tasks`.
- `decline`: stop. Write nothing.
```

## `tasks`

```markdown
### tasks

Emit this sentence once: Highway is now building out this solution. We can review, discuss, and revise it afterward, and continue refining it as requirements evolve.

Write `codify-tasks.md` beside the record from `.highway/library/templates/output/codify-tasks.md`.

1. Order the lines by story, then by each proposal task that delivers no story. Under each heading, state how it is tested on its own.
2. Each task names its file. Keep the line shape, the Provider, and `Tests: required`.
3. Place each proposal task under the story it delivers, in proposal order. A proposal task that delivers no story gets a heading from that task and its line under it, after the stories. When a story has no proposal task, add a task for it. Leave out a line that names work the proposal does not list.
4. When a question remains that changes a story and nothing accepted decides it, ask it. Write nothing further until it is answered.
5. On success, go to `code` without asking a question.

A failed write leaves the plan and says what failed. Stay on `tasks`. Do not emit the sentence again.
```

## `code` and `close`

Before writing a task's files, read each listed Control and NFR whose catalog row is active. Skip a removed one. The files abide by each one read.

Under **Questions?** in the completion message, replace the two sentences with:

```markdown
To revisit this in the future, just ask Highway to show your Code Catalog. We can review, discuss, and revise any of your solutions, and continue refining them as requirements evolve.
```

The stopped close is unchanged.

## Templates

`codify-record.md` 9.0.0 adds **Controls and NFRs:** after Tasks.

`codify-tasks.md` 6.0.0 groups lines under a story. The story states how it is tested. The line shape stays.

`codify-plan.md` 1.0.0 sections: Stories, Edge cases, Functional requirements, Decisions. Data and Interface are included only when `plan` step 5 says so.
