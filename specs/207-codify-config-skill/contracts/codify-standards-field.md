# Contract: Codify Standards Field

Each proposal task:

```markdown
1. **[Task title]**
   - **Scope:** ...
   - **Provider:** ...
   - **Method:** ...
   - **Standards:**
     1. [Standard Title]
   - **Assumptions:** ...
```

Or `- **Standards:** No coding standard applies.`

- Proposed from File Patterns, Technology, When to use, When not to use, and Inherits From (R8).
- A correction re-emits with one consequence sentence. An unlisted title: "[Title] is not a listed coding standard. To add it, run /highway-codify-config." The rest is kept.
- `codify-record.md` saves the list per task. The `codify-tasks.md` line names the paths in order: `Standards: \`library/coding-standards/<a>.md\`, \`library/coding-standards/<b>.md\`.`
- Provider: named, then fit, then this implementation's row, then the first row.
