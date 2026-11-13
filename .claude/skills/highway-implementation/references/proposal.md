# Proposal

### start

Build the proposed realization from the accepted architecture. Follow `execution`. Follow `capability title` for each capability. Cover every responsibility the architecture states. Mark a row `not applicable` only when that stated responsibility does not apply to this realization. Do not add a responsibility the architecture does not state. For each thing the architecture left free, state the choice this realization made, or `None` when nothing may vary. State the realized interface for each architecture interface, how conformance was shown, and the limitations of this realization, each or `None`. State one technology choice, with its intent, its reason, and its evidence. When evidence does not support a technology, use `Unknown` rather than inventing one. Derive the title with the rules in `identifier`.

When a proposed realization contradicts the architecture, name the requirement, the conflict, and the impact. Offer `Resolve implementation` or `Revisit architecture`. Do not write.

**Here is a proposed starting point for your implementation:**

**Title:** [Product title.]

**Summary:** [What this realization does.]

**Realizations:**
- **[Component]:** [Technology or mechanism, and the responsibility it covers.]

**Deployment:** [Where and how it runs.]

**Data:** [How data is stored and moved, or `None`.]

**Security:** [How accepted Controls are realized, or `None`.]

**Operations:** [How accepted NFRs are met in operation, or `None`.]

**Deployed by:** [Platform. Or: Needed.]

**Why it matters:** [From `why it matters`.]

**Managed by:** [Platform. Or: Needed.]

**Why it matters:** [From `why it matters`.]

**Language:** [Standard Title. Or: None.]

**Why it matters:** [From `why it matters`.]

**Capabilities:**
- **[Business capability]:** Realized by [provider or mechanism]. A capability is a business outcome, not a component name.

**What would you add, correct, or remove?**

If this is accurate, just say so.

Classify the reply:

- `edit`: when the edit names Deployed by, Managed by, or Language, follow `field`. Otherwise follow `capability title` for each capability it adds or corrects, then emit one consequence sentence, or the one `capability title` gave. A new title is a supplied title. Re-emit this block with the edit applied. Stay on `start`.
- `accept`: when Deployed by or Managed by is Needed, name that field and re-emit this block. When a stated responsibility is neither covered nor marked not applicable, name it and re-emit this block. In both cases stay on `start`. Otherwise go to `identifier`.
- `unknown`: re-emit this block. Stay on `start`.
- `question`: answer, then re-emit this block. Stay on `start`.
- `decline`: stop. Write nothing.

## Verification

- Coverage rows are the architecture's stated responsibilities. Conformance is `compatible` when every row is covered or not applicable, and that record has no gap section and no conflict section. An uncovered responsibility is `incomplete` and states the gap.
- The architecture is named once. A technology choice is stated once.
- The implementation title is the decision's product or named mechanism, without "Adopt". The proposal shows it before acceptance. It gains "for" and the purpose only when that title belongs to an implementation of a different architecture.
