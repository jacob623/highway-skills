# Contract: Standard Proposal

```markdown
[One consequence sentence.]

**Standard Title:** [Title]
**Technology:** [Technology]
**File Patterns:** [Patterns]
**Coding Standards:**
1. [Rule]
**Tests:** [required. One sentence on how tests are written. Or: not required.]
**When to use:**
1. [Entry]
**When not to use:**
1. [Entry]
**Inherits From:**
1. [Standard Title]

**Consequences:**
- **[Consequence]:** [Description]

**Conflicts:**
1. **[Conflict]:** [Description]. Recommendation: [Change].

**What would you add or correct?**

If you'd like to cancel, just say so.
```

- When there is no standard: at most 10 rules from best practices. Otherwise the current rules. A re-add reuses the existing file.
- `accept` writes the standard file from `coding-standard.md`, then the catalog row.
- A remove deletes the row only. Its Consequences say the file remains and is no longer used. Its Conflicts list the standards that inherit from it.
