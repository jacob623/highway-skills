# Contract: Platform Proposal

```markdown
[One consequence sentence.]

**Platform:** [Platform]
**Implementation ID:** [RI id]
**When to use:**
1. [Entry]
**When not to use:**
1. [Entry]

**Consequences:**
- **[Consequence]:** [Description]

**Conflicts:**
1. **[Conflict]:** [Description quoting both entries]. Recommendation: [Change].

[When conflicts exist: You can accept this proposal with these conflicts and resolve them afterward.]

**What would you add or correct?**

If you'd like to cancel, just say so.
```

- An add requires an accepted implementation. Otherwise emit "[Platform] is not in the implementation catalog." and ask "**Would you like to onboard [Platform]?**"
- An update starts from the current values.
- Entries are grounded in the implementation and the catalog.
- `accept` writes only that row. With conflicts, ask "**Would you like help resolving these conflicts?**" A yes opens `conflicts`. When the platform works with code or configuration files, ask "**Would you like to configure coding standards for [Platform]?**" A yes opens `standards`.
- A remove drops the row after the same proposal shape.
