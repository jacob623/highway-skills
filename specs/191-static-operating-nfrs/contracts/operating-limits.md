# Contract: Operating limits and Request fields

## NFR review

A new-set review includes these two limits with the queued NFRs. Accepted material replaces the matching default. Silence keeps the default. Neither limit is replaced by a question.

**No system hosting:** Solutions are delivered as managed services the organization does not host or operate.

**Why it matters:** The owner runs the business and its technology.

**Direct purchase:** The owner buys the service directly from the vendor that operates it.

**Why it matters:** No proposal, approval board, or mandated vendor stands between the owner and the service.

The person accepts, corrects, or removes each limit with the set. A stored-record review does not insert a missing limit.

## Request proposal

| Accepted title | Fields filled from its statement |
|---|---|
| **No system hosting** | `hosting_restrictions`. `allowed_solution_classes` is `managed service` when the statement says the organization does not host, and `hosted system` when the statement says the organization hosts. |
| **Direct purchase** | `procurement_constraints` and `vendor_restrictions`. |

A corrected statement under the same title is copied. A removed or retitled limit is not copied. Another NFR does not fill these fields. Request material that states the limit is shown for that field instead.

## Discovery

Discovery is unchanged. A filled hosting, procurement, or vendor restriction excludes a violating option. A known `allowed_solution_classes` value filters by class.
