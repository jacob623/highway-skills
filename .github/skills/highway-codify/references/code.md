# Code

For a code project, these rules apply in this flow:

- Setup Instructions say how to build, configure, and run the product. User Guide says how to use its interfaces.
- The close says `The code was not run.` in place of `The automation was not run.`

### tasks

Emit this sentence once: Highway is now building out this solution. We can review, discuss, and revise it afterward, and continue refining it as requirements evolve.

Write `codify-tasks.md` beside the plan from `assets/codify-tasks.md`.

1. Order the lines by story, then by each proposal task that delivers no story. Under each heading, state how it is tested on its own.
2. Each task names its file. Keep the line shape, the Provider, and `Tests: required`.
3. Place each proposal task under the story whose title is that task's action, in proposal order. When no story has that title, give the task a heading from that task. When a story title is not a proposal task's action, add a task for it. Leave out a line that names work the proposal does not list.
4. When a question remains that changes a story and nothing accepted decides it, ask it. Write nothing further until it is answered.
5. On success, go to `code` without asking a question.

A failed write leaves the plan and says what failed. Stay on `tasks`. Do not emit the sentence again.

### code

Open the feature's `codify-tasks.md`. Start at the first open task. For each open task, in list order:

1. Read every standard the task names, in order, including its File and Folder Structure, and each file the task names that already exists. Read each Control and NFR the record lists whose catalog row is active. Skip a removed one. Read no other file in the product folder.
2. Write the task's files at their relative paths in `code/<folder>/` so they follow every one of them and abide by each Control and NFR read. When two disagree, the earlier one wins. The accepted proposal, architecture, and implementation decide what is built. The standards decide how it is written.
3. Mark the task `[X]`.
4. Go to the next open task.

Write only the paths the task names. Do not run any file.

The README task writes two parts, in this order. Head the first part `## Setup Instructions` and the second part `## User Guide`. Setup Instructions says what is put in place, where it goes, and how to enable it, including the preparation this automation needs. User Guide says how a non-technical person starts this one automation, what they provide, and what they receive, using the interface of the Provider. User Guide does not ask that person to edit the generated files or read the implementation record.

For a code project, the code project rules at the start of this flow decide both parts.

When a task cannot be finished, stop at that task. Leave it and every later task open. Start no later task. Keep the files that finished tasks wrote. Go to `close`.

When every task is done, apply the Features rule to this feature's entry, then go to `close`.

### close

First emit the coding standards notices that apply, then one close.

For a code project, the code project rules at the start of this flow decide the not-run line.

[No coding standards catalog was found. A standard named by the catalog was not found at [path]. Include only the sentences that apply.]

When every task is done, emit this message exactly, as rendered markdown, with the product folder in place of `<folder>`:

```markdown
### The codify stage is complete.

This code is now part of your Highway knowledge base. Like your architectures, implementations, and other accepted knowledge, it remains available for future context. Highway can help you understand, configure, extend, troubleshoot, and use any code it has helped you create.

The automation was not run.

**The files can be found here:**

`code/<folder>/`

If you'd like to review the files together, just say so.

**Setup and Usage Instructions** can be found here:

`code/<folder>/README.md`

If you'd like to review the instructions together, just say so.

**Questions?**

To revisit this in the future, just ask Highway to show your Code Catalog. We can review, discuss, and revise any of your solutions, and continue refining them as requirements evolve.

**Where would you like to go next?**

Run highway-help to explore what Highway can help you do.
```

When a task could not be finished, emit:

**Automation recorded**

- **Automation record:** `code/<folder>/.highway/features/<number>-<action>/codify.md`
- **Task list:** `code/<folder>/.highway/features/<number>-<action>/codify-tasks.md`
- **Title:** [Title]
- **Implementation:** [Implementation title]

Task [T###] could not be finished because [reason]. The next run starts there.

The automation was not run.

## Verification

- The README is headed `## Setup Instructions`, then `## User Guide`.
- A finished run closes with the completion message, both paths, and the sentence that the automation was not run. A stopped run names the stopped task and does not say the codify stage is complete.
- Continuing emits the building sentence once, then writes the task list ordered by story, each heading with its independent test.
- The task list follows `codify-tasks.md`. A story's test line comes first only when its first standard says `Tests: required`.
- Coding starts with no question after the task list is written. Every standard a task names, and each existing file it names, is read before its files are written, and no other automation file is read, the earlier one winning a disagreement, and each task is marked `[X]` before the next begins.
- A task that cannot be finished stops the run with that task and every later task open. The next run starts at the first open task, redoes no finished task, and runs no check.
