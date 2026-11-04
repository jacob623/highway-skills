# Contract: Edit Lines

Replace the single `edit` line in `### propose` with these lines. Change no other line in the step.

```markdown
- `edit`: emit one consequence sentence. Re-emit this block with the diagram and tasks still matching. Stay on `propose`.
An edit that names a different Provider sets it on every task and in the diagram, then goes to `standards`.
An edit that changes a method goes to `standards`, then `align`, for that task.
An edit that adds, removes, or reorders a task's Standards changes only that list, then goes to `align` for that task.
A Files edit changes only this automation and leaves out a path that is not relative.
A title not in the coding standards catalog is left out, and the rest of the list is kept. Say: [Title] is not a listed coding standard. To add it, run /highway-codify-config.
A second action is removed. Say it waits for another run.
The person can switch to another accepted architecture by title. An architecture that is not accepted is not added.
A preparation-only request stays one self-service action.
Removing the last task or the last acceptance criterion says at least one is needed.
```

No line above exceeds 240 characters. `propose` stays at 392 words.
