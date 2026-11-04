# Contract: Proposal Files

Each codify proposal task:

```markdown
1. **[Action]:**
   - **Scope:** ...
   - **Provider:** ...
   - **Method:** ...
   - **Standards:**
     1. [Standard Title]
   - **Files:**
     1. `.github/workflows/restart-worker.yml`
   - **Assumptions:** ...
```

- `layout` proposes Files from the task's standards (research R7).
- An edit to Files emits one consequence sentence, changes that task's Files, and leaves the standard unchanged.
- A Files path with an unfilled placeholder keeps the proposal open until the person corrects it.
- A listed standard with no structure: "[Standard Title] has no file and folder structure. To add one, run /highway-codify-config."
- The record saves Files per task.
