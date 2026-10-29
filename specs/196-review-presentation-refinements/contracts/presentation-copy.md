# Contract: Review Presentation Copy

## Captured objectives

```markdown
**Here's what I've captured as your objectives:**

1. **[Title]:** [Statement]

   **Success looks like:**
   - [Success measure]

   **Why it matters:** [Rationale]

---
```

Controls and NFRs use the same numbered form without **Success looks like:**.

## AI-Assisted Engineering and Planning

```markdown
1. **AI-Assisted Engineering and Planning:**

   Using AI systems to assist with research, planning, and implementation of technology solutions.
```

## Listed finding

```markdown
1. **[Finding title]:**

   [One-sentence summary of the finding.]

   **Solution Complexity:**

   [Low, Medium, or High.]
```

After **Would you like to explore any of these findings in more detail?**, emit one of these:

- No more findings remain than are shown: `If you'd like to dismiss any of these, just say so.`
- More findings remain: `If you'd like to dismiss any of these or see additional findings, just say so.`

## Finding details closing

```markdown
**Would you like to explore a solution now?**

If you'd like to dismiss this finding or go back to the list of findings, just say so.
```

## Request proposal

```markdown
**Here is a proposed starting point for your request:**

# [Title]

## Problem
[Problem.]

## Actors
...

## Solution Constraints
- **Allowed Solution Classes:** [Classes, or None.]
- **Existing Platforms Required:** [Platforms, or None.]
- **Existing Platforms Preferred:** [Platforms, or None.]
- **Known Systems:** [Systems, or None.]
- **Hosting Restrictions:** [Restriction, or None.]
- **Vendor Restrictions:** [Restriction, or None.]
- **Procurement Constraints:** [Restriction, or None.]
- **Regulatory Restrictions:** [Restriction, or None.]

**What would you add, correct, or remove?**

If this is accurate, just say so. If you don't know, say "I don't know" and we'll work through it together.
```

## Removed copy

- Using AI systems to assist with research, architecture, planning, governance, or implementation activities.
- The literal **Finding:** and **Complexity:** labels in the list
- If you'd like to see additional findings, just say so.
- If you'd like to go back to the list of findings, just say so.
- **Here's what I've captured as your request:**
- Snake-case Solution Constraints names and `unknown` in what the person sees
