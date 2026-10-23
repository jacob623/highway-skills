# Research: Static Operating NFRs

## Decision: Add both limits to the new-set review

- **Decision**: The guided NFR `capture` includes **No system hosting** and **Direct purchase** in the same review as the queued NFRs. A stored-record `review` does not insert a limit that is absent, including one the person removed. The two limits do not replace the queued NFRs.
- **Rationale**: The person needs to accept the limits before a Request exists. A later opening of stored NFRs must not put a removed limit back.
- **Alternatives considered**: A separate review was rejected. Writing the limits without showing them was rejected.

## Decision: Infer from accepted material, otherwise use the default

- **Decision**: Hosting uses accepted material that names who hosts the systems or that the organization will not host them. Otherwise the statement is "Solutions are delivered as managed services the organization does not host or operate." and the rationale is "The owner runs the business and its technology." Purchase uses a stated buying process or vendor requirement. Otherwise the statement is "The owner buys the service directly from the vendor that operates it." and the rationale is "No proposal, approval board, or mandated vendor stands between the owner and the service." Silence does not omit the limit and does not become a question.
- **Rationale**: The spec requires a proposal in both cases. Contrary material must win over the default.
- **Alternatives considered**: Asking when the material is silent was rejected. Guessing a hosting limit from company size was rejected.

## Decision: Copy by exact title into named Request fields

- **Decision**: An active NFR titled **No system hosting** sets `hosting_restrictions` to its statement. The allowed class is `managed service` when that statement says the organization does not host. The allowed class is `hosted system` when that statement says the organization hosts. An active NFR titled **Direct purchase** sets both `procurement_constraints` and `vendor_restrictions` to its statement. A corrected statement under the same title is copied. A removed or retitled limit is not recreated from another NFR. Request material that states the limit is shown for that field instead. Neither field is left `unknown` when the matching title is accepted and the request material does not state its own limit.
- **Rationale**: A general instruction to use accepted context left these fields unknown. The spec names the titles and the fields.
- **Alternatives considered**: Letting Discovery infer the fields from any NFR was rejected. A third card for solution class or vendor was rejected because those values are copied from these two limits.

## Decision: Leave Discovery unchanged

- **Decision**: `.highway/skills/highway-discovery/SKILL.md` is not edited. Its current rules exclude options that violate filled hosting, procurement, and vendor restrictions, and filter by a known solution class.
- **Rationale**: The spec says Discovery does not infer these fields. Filling the Request is what makes the existing exclusion apply.
- **Alternatives considered**: A second Discovery reading of the NFR catalog was rejected.
