# Contract: Coding Flow

## Order

`start` → `identifier` → `title` when needed → `write` → `code` → `close`.

`write` writes the saved proposal, the task list, and the automation catalog row together, then goes to `code` without asking a question.

## code

For each open task, in list order:

1. Read the standard the task names, when it names one.
2. Write that task's file so it follows the standard. The accepted architecture and implementation decide what is built. The standard decides how it is written.
3. Mark the task `[X]` in `codify-tasks.md`.
4. Go to the next open task.

When every task is done, go to `close`.

## A task that cannot be finished

Stop at that task. Leave it and every later task open. Start no later task. Go to `close` and name the task and what stopped it.

## Resume

| Situation | Result |
|---|---|
| The invocation names a recorded automation by title or id, and its task list has an open task | Go to `code` at the first open task |
| `identifier` finds the same title already recorded, with an open task | Go to `code` at the first open task |
| Every task is done | Go to `close` |

Finished tasks are not redone, and their files are not removed.

## close

Names the automation record and the task list. Says in sentences whether every task is done. Names a task that could not be finished and why. Names a missing catalog, a missing standard file, or a duplicate technology row. Says the automation was not run. Does not use Status, Missing, Complete, or Blocked as labels.
