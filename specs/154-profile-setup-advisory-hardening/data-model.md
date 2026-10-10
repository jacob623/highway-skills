# Data Model: Profile and Setup Advisory Hardening

This feature adds no persisted entity, schema, or artifact type. The entities below are interaction
concepts already owned by the Profile and Experience Standard contracts.

| Entity | Meaning | Lifecycle / validation |
|---|---|---|
| Working Idea | Non-authoritative material developed during interaction, including an advisory addition. | Remains outside a candidate until the person adopts it; may be reshaped by the person's response. |
| Substantive Contribution | A person-supplied addition, change, correction, removal, redirection, or qualification affecting the active subject. | The first contribution controls the conditional reassurance for that active domain; imported evidence alone does not count. |
| Converged Proposal | A complete Profile candidate presented under the existing capture heading. | Approval is the owner's acceptance boundary; an unambiguous approval proceeds directly to candidate presentation, while ambiguity or new substance triggers existing re-evaluation. |
| Advisory Addition | One grounded distinction, implication, tension, connection, possibility, tradeoff, or decision criterion shown before an applicable exploratory question. | At most one addition per contribution; attributed as workflow reasoning and excluded from the candidate unless adopted. |
| Fresh Setup | Initial Setup interaction before any resumed owner state exists. | Must begin with the existing Highway welcome and no procedural preamble. |
| Resumed Setup | Setup interaction continuing from existing owner readiness or interaction state. | Retains the current no-repeat welcome behavior. |

## Relationships

- A Working Idea may become part of a Converged Proposal only after the person adopts it.
- A Substantive Contribution can reshape the active Working Idea and can trigger one grounded Advisory Addition.
- A Converged Proposal crosses the Profile owner's acceptance boundary only after the person's response.
- Fresh Setup delegates its first owner action after the welcome; Resumed Setup does not repeat the fresh welcome.

## Validation constraints

- No new persisted fields are introduced.
- Domain-specific state remains owned by Profile; generic interaction behavior remains owned by the Experience Standard.
- Setup orchestration consumes the existing owner contract and does not expose internal state as preamble.
