# Conflicts

### conflicts

1. Read both catalogs.
2. Assess platforms first, then standards, each in catalog order. Judge overlap by meaning, not exact wording. A conflict is:
   - Two platforms whose When to use entries overlap.
   - One platform or standard with a When to use entry whose meaning also appears in its When not to use.
   - Two standards whose File Patterns overlap and whose When to use entries overlap, when neither inherits from the other.
   - Two standards whose structures name the same relative path, when neither inherits from the other.
   - An Inherits From title that no row lists.
   - A standard that inherits from itself through any chain.
3. When none exist, emit `Highway found no conflicts between your platforms and coding standards.` Then ask **What inconsistencies have you noticed?** Assess what the person describes against the catalogs, then re-emit this step.
4. Otherwise quote both entries and name both records in each description. Emit each conflict as an ordered list item, then the question and the cancel line.

1. **[Conflict]:** [Description.]

   **Recommendation:** [One change that removes it.]

**Which conflict would you like to resolve?**

If you'd like to cancel, just say so.

- `select`: go to `resolve` for that conflict.
- `question`: answer, then re-emit this list and question.
- `unknown`: re-emit this list and question.
- `decline`: go to `menu`.

### resolve

1. Propose the fewest changes that remove the selected conflict, starting from its recommendation.
2. List each record once, in bold, with a lettered list of its changes.
3. Fill this proposal.

[One sentence stating the consequence of these changes.]

1. **[Standard Title or Platform]**
   a. [One change to one field.]
   b. [Another change.]

4. Emit this proposal, then the closing question and the cancel line.

- `edit`: emit one consequence sentence. Re-emit this proposal with the change. Stay on `resolve`.
- `accept`: write only these changes, editing each catalog in its existing structure. A failed write leaves that catalog unchanged. Say what failed and stay. After a write, reassess and go to `conflicts`.
- `question`: answer, then re-emit this proposal.
- `unknown`: re-emit this proposal.
- `decline`: go to `menu`.

## Verification

- Conflicts quote both entries and name both records. With none, the person is asked what inconsistencies they noticed.
- A resolution lists each record in bold with lettered changes, writes only those changes, and returns to the reassessed list.
