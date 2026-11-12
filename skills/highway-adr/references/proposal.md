# Proposal

Read evidence in this order: Discovery, Clarification for that Discovery, the Request, Clarification for that Request, Profile, Objectives, Controls, NFRs. A missing Clarification continues without it. An open finding can inform a risk. It cannot select or reject an option. Do not change Clarification.

### start

Build the proposed decision from the selected option and the Discovery. Copy the comparison and the matches. When the selected option is not the recommended option, include the override.

Match an architecture only by explicit identifier, exact title, capability id, Objective id, Control id, or NFR id. Do not match by wording resemblance. A current decision is accepted, not superseded, and not removed. A current implementation is an accepted implementation of that architecture.

An option already has an implementation only when a current decision for the matched architecture selected an option with the same title, character for character, and that architecture has a current implementation. Say this uses that implementation and that architecture. Do not ask whether the decision replaces or runs beside another. A different option title is not yet implemented.

When the span applies, go to `span` instead of emitting this block.

When the selected option title is different, and exactly one matched architecture already has a current decision, ask once, inside this proposal, whether this decision replaces that decision or runs beside it. When more than one architecture matches and the span does not apply, list only those architectures. After one is picked, show this proposal again with that architecture named and one consequence sentence. When nothing matches, say this decision stands on its own and a new architecture will follow.

A change to the relationship or the architecture shows this proposal again with one consequence sentence. Accepting the decision is the only confirmation.

**Here is a proposed starting point for your decision:**

**Decision:** [Selected option title]

**Why:** [Decision rationale grounded in the Discovery and accepted Objectives, Controls, and NFRs.]

**Architecture:** [This uses [implementation] and [architecture]. | This decision stands on its own and a new architecture will follow. | This decision replaces [decision]. [decision] will be marked superseded when this one is accepted. Its architecture [architecture] is kept, and this decision will use it. | This decision runs beside [decision]. Both decisions stay in force. This decision will use [architecture].]

When more than one architecture matches and none is picked yet, list only those architectures and ask **Which architecture should this decision use?** When the replace-or-beside choice is still open, ask **Does this decision replace [decision], or run beside it?** Do not ask that question in any other case.

**Alternatives:**
- **[Other option title]:** [Evaluated when it remains viable. Rejected when the Discovery excluded it.]

**Consequences:**
- **Positive:** [What improves.]
- **Negative:** [What is given up.]
- **Operational:** [How operation changes.]
- **Governance:** [Which accepted Controls or NFRs this decision carries.]

**What would you add, correct, or remove?**

If this is accurate, just say so.

- `edit`: emit one consequence sentence. Re-emit this block with the edit applied. Stay on `start`. The selected option stays the option the person named.
- `replace` or `beside`: emit one consequence sentence. Re-emit this block with that relationship. Stay on `start`.
- A picked architecture: emit one consequence sentence. Re-emit this block with that architecture named. Stay on `start`.
- `accept`: when a required architecture pick or replace-or-beside choice is still open, stay on `start` and ask that one question. Otherwise go to `identifier`.
- `unknown`: re-emit this block. Stay on `start`.
- `question`: answer, then re-emit this block. Stay on `start`.
- `decline`: stop. Write nothing.

### span

The span applies when more than one architecture matches, every match reason is the same Control id or every match reason is the same NFR id, the selected option's Control or NFR alignment names that id, and the selected option title names none of the matched architectures. A match by identifier, exact title, or capability id is not a span. The set is the matched architectures, in id order.

Build the proposal as `start` does, with this Architecture line. Name every architecture in the set, one per line. Do not ask **Which architecture should this decision use?** Do not ask whether this decision replaces another.

**Here is a proposed starting point for your decision:**

**Decision:** [Selected option title]

**Why:** [Decision rationale grounded in the Discovery and accepted Objectives, Controls, and NFRs.]

**Architecture:** This decision runs beside the current decision of each of these architectures. None of those decisions is replaced, and no new architecture will follow.
- [Architecture title]

**Alternatives:**
- **[Other option title]:** [Evaluated when it remains viable. Rejected when the Discovery excluded it.]

**Consequences:**
- **Positive:** [What improves.]
- **Negative:** [What is given up.]
- **Operational:** [How operation changes.]
- **Governance:** [Which accepted Controls or NFRs this decision carries.]

If you'd like to leave out any of these architectures, just say so.

**What would you add, correct, or remove?**

If this is accurate, just say so.

- Leaves out architectures: emit one consequence sentence. When two or more remain, re-emit this block with that set. Stay on `span`. When one remains, go to `start` with that architecture picked, and ask **Does this decision replace [decision], or run beside it?**
- Names an architecture that is not in the set: say it did not match. An architecture that did not match is not added. Re-emit this block.
- `edit`: emit one consequence sentence. Re-emit this block with the edit applied. Stay on `span`.
- `accept`: go to `identifier`.
- `unknown`: re-emit this block. Stay on `span`.
- `question`: answer, then re-emit this block. Stay on `span`.
- `decline`: stop. Write nothing.

## Verification

- The comparison and matches are copied from the Discovery.
- The same exact option title uses the existing implementation and does not ask replace or beside. A different option title that matches one architecture asks that question once, inside the proposal.
- A span names every architecture in the set and does not ask which architecture to use. Leaving out architectures narrows the set. One remaining architecture asks replace or beside.
