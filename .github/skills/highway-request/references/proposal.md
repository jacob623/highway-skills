# Proposal

Collect seven domains in this order: Problem, Actors, Current Process, Desired Change, Success Measure, Business Constraints, Solution Constraints. Record `Unknown` when the person says they do not know. Do not invent a value.

### start

Build one starting point from the invocation and accepted repository context. Fill every slot, including Solution Constraints. Use `Unknown` or `No business constraints` only for a slot the evidence cannot support. Do not ask the person to originate a slot that the starting point can propose.

Solution Constraints limit later Discovery. They do not choose an architecture, technology, or candidate.

- `allowed_solution_classes`: one or more classes, or `unknown`. Never an empty list.
- `existing_platforms_required`: platforms that must be used, an empty list, or `unknown`.
- `existing_platforms_preferred`: platforms the person prefers, an empty list, or `unknown`. Keep these distinct from required platforms.
- `known_systems`: systems involved, an empty list, or `unknown`.
- `hosting_restrictions`: a non-empty restriction or `unknown`.
- `vendor_restrictions`: a non-empty restriction or `unknown`.
- `procurement_constraints`: a non-empty restriction or `unknown`.
- `regulatory_restrictions`: a non-empty restriction or `unknown`.

When an active NFR is titled **No system hosting**, set `hosting_restrictions` to its statement. Set `allowed_solution_classes` to `managed service` when that statement says the organization does not host. Set it to `hosted system` when that statement says the organization hosts. Do not leave either field `unknown`.

When an active NFR is titled **Direct purchase**, set `procurement_constraints` and `vendor_restrictions` to its statement. Do not leave either field `unknown`. Copy a corrected statement under the same title.

Do not recreate a removed or retitled limit from another NFR. When the request material states the hosting or buying limit, show that material for the field instead.

Derive a short title from the Problem. Use a title the person already supplied when they supplied one.

Show each Solution Constraints field by its readable name, in the field order above. Show `None` when a value is `unknown` or an empty list. When the person says "none" for a field, hold an empty list for `existing_platforms_required`, `existing_platforms_preferred`, and `known_systems`. Hold `unknown` for `allowed_solution_classes`, `hosting_restrictions`, `vendor_restrictions`, `procurement_constraints`, and `regulatory_restrictions`. The record keeps the field names and values above.

**Here is a proposed starting point for your request:**

Emit this level-1 heading:

[Title]

Emit these level-2 headings, in this order, with the text under each:

Problem
[What is going wrong or missing.]

Actors
[Who is involved.]

Current Process
[How the work happens today.]

Desired Change
[What should be different.]

Success Measure
[What will show the change worked.]

Business Constraints
[Limits on the business change, or `No business constraints`.]

Solution Constraints
- **Allowed Solution Classes:** [One or more classes, or None.]
- **Existing Platforms Required:** [Platforms, or None.]
- **Existing Platforms Preferred:** [Platforms, or None.]
- **Known Systems:** [Systems, or None.]
- **Hosting Restrictions:** [Restriction, or None.]
- **Vendor Restrictions:** [Restriction, or None.]
- **Procurement Constraints:** [Restriction, or None.]
- **Regulatory Restrictions:** [Restriction, or None.]

**What would you add, correct, or remove?**

If this is accurate, just say so. If you don't know, say "I don't know" and we'll work through it together.

- `edit`: emit one consequence sentence. Re-emit this block with the edit applied. Stay on `start`.
- `accept`: hold the title and all seven domains. When `allowed_solution_classes` is empty, restore one or more grounded classes or `unknown` and re-emit this block. Otherwise go to `identifier`.
- `unknown`: re-emit this block. Stay on `start`.
- `question`: answer in one sentence. Re-emit this block. Stay on `start`.
- `decline`: stop. Write nothing.

A malformed Solution Constraints field names that field by its readable name, its accepted shape, and one valid example, then re-emits this block with that field corrected. Update only that field.

## Verification

- The starting point includes Solution Constraints.
- The starting point shows the title as a level-1 heading and each of the seven domains as a level-2 heading.
- `allowed_solution_classes` contains one or more values or `unknown`.
