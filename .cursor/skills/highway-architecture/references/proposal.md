# Proposal

### start

Build the proposed architecture from the accepted ADR. Keep it conceptual. Do not authorize implementation. Do not name a platform, product, vendor, or specific technology. Derive the title with the rules in `identifier`. Follow `capability title` in `highway-implementation` for each capability, then return to `start`.

**Here is a proposed starting point for your architecture:**

**Title:** [Purpose title.]

**Summary:** [What this architecture is, in conceptual terms.]

**Applies:** [When this architecture applies.]

**Leaves open:** [What it leaves open.]

**Style:** [The conceptual style.]

**Why:** [Why this style was chosen.]

**Components:**
- **[Component]:** [Its responsibility.] Interface: [What other components rely on, or `None`.]

**Information:** [What it handles, who owns it, and what crosses a trust boundary, or `None`.]

**Must keep:** [What every implementation must keep.]

**May choose:** [What an implementation may choose, or `None`. A variation names no product.]

**Responsibilities:**
- [A responsibility a realization covers or marks not applicable.]

**Interactions:** [How the components communicate, without naming a product or platform.]

**Trust boundaries:** [Ownership and responsibility boundaries, or `None`.]

**Deployment:** [The conceptual deployment approach, or `None`.]

**Constraints:** [ADR, Control, and NFR constraints, or `None`.]

**Risks:** [Architecture risks, or `None`.]

**Capabilities:** [The component that offers each one, or `None`. No capability identifier.]

**What would you add, correct, or remove?**

If this is accurate, just say so.

- `edit`: follow `capability title` in `highway-implementation` for each capability the edit adds or corrects, then return here. Emit one consequence sentence, or the one `capability title` gave. When the edit names a platform, product, vendor, or specific technology, say that it belongs on the Reference Implementation and leave it out of this architecture. A new title is a supplied title. Re-emit this block with the edit applied. Stay on `start`.
- `accept`: go to `identifier`.
- `unknown`: re-emit this block. Stay on `start`.
- `question`: answer, then re-emit this block. Stay on `start`.
- `decline`: stop. Write nothing.

## Verification

- The architecture title is the decision's purpose, without "Adopt" and without a product. The proposal shows it before acceptance. An empty purpose asks for a title and writes nothing.
