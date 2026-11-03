# Contract: Completion Close

Emitted by `highway-codify` `close` only when every task is done. Coding-standard notices that apply come before it.

```markdown
### The codify stage is complete.

This code is now part of your Highway knowledge base. Like your architectures, implementations, and other accepted knowledge, it remains available for future context. Highway can help you understand, configure, extend, troubleshoot, and use any code it has helped you create.

The automation was not run.

**The files can be found here:**

`code/[ID]/`

If you'd like to review the files together, just say so.

**Setup and Usage Instructions** can be found here:

`code/[ID]/README.md`

If you'd like to review the instructions together, just say so.

**Questions?**

If you have questions in the future, just ask highway to show your code catalog. You can always discuss any of the code highway helps you build.

**Where would you like to go next?**

Run /highway-help to explore what Highway can help you do.
```

## Stopped-task close

Emitted when a task could not be finished. Unchanged except that it no longer offers the "Every task is done." alternative.

```markdown
**Automation recorded**

- **Automation record:** `code/[ID]/codify.md`
- **Task list:** `code/[ID]/codify-tasks.md`
- **Title:** [Title]
- **Implementation:** [Implementation title]

Task [T###] could not be finished because [reason]. The next run starts there.

The automation was not run.
```

## Rules

- "The codify stage is complete." appears only in the completion close.
- "The automation was not run." appears once in either close.
- Paths are relative to the repository root.
