# Data Model: Static Operating NFRs

## No system hosting

An NFR in a new-set review. It is stored only when the person accepts it.

| Field | Rule |
|---|---|
| Title | **No system hosting**, unless the person changes it |
| Statement | Accepted hosting material, otherwise "Solutions are delivered as managed services the organization does not host or operate." |
| Rationale | The default rationale when the default statement is used. Accepted material supplies the rationale when the statement comes from that material. |

A removed or retitled record is not this NFR for copying.

## Direct purchase

An NFR in a new-set review. It is stored only when the person accepts it.

| Field | Rule |
|---|---|
| Title | **Direct purchase**, unless the person changes it |
| Statement | A stated buying process or vendor requirement, otherwise "The owner buys the service directly from the vendor that operates it." |
| Rationale | The default rationale when the default statement is used. Accepted material supplies the rationale when the statement comes from that material. |

## Request solution limits

Values on the Request proposal.

| Request field | Source |
|---|---|
| `hosting_restrictions` | Statement of the active NFR titled **No system hosting**, unless the request material states this limit |
| `allowed_solution_classes` | `managed service` when that statement says the organization does not host. `hosted system` when it says the organization hosts. Unknown when that NFR is absent and the request material does not state a class |
| `procurement_constraints` | Statement of the active NFR titled **Direct purchase**, unless the request material states this limit |
| `vendor_restrictions` | The same statement as `procurement_constraints` when **Direct purchase** is the source |

Any other NFR fills none of these four fields.

## State

1. The new-set review shows both limits with the queued NFRs.
2. Acceptance stores the limits that remain, under their titles.
3. A later stored review shows only stored NFRs.
4. A Request proposal copies the active titled NFRs into the four fields.
5. Discovery uses the filled fields and does not read the NFR titles.
