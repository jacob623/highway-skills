# Research: Request Solution Constraints

## Decision: Extend the existing Request intake and shared record contract

**Rationale**: Feature 053 changes the Request evidence model only. The existing `highway-new`
workflow, shared Request record template, focused test, catalog transaction, privacy screening,
and generated adapter process already own the relevant behavior. Extending those surfaces keeps
Request ownership intact and avoids a parallel intake or persistence mechanism.

**Alternatives considered**:

- Add a separate constraint artifact: rejected because constraints are business evidence owned by
  the Request and must remain available with the Request record.
- Add solution evaluation to Request intake: rejected because Discovery owns candidate generation,
  comparison, scoring, recommendation, and architecture analysis.
- Add architecture or solution decisions to the Request record: rejected because ADR owns those
  decisions and Feature 053 explicitly excludes them.

## Decision: Represent solution classes as an extensible user-owned list

**Rationale**: `allowed_solution_classes` supports multiple classes and future classes without
schema changes or boolean-field expansion. The list records eligibility evidence without ranking
or recommending a class.

**Alternatives considered**:

- Fixed boolean fields for SaaS, COTS, and custom development: rejected because the model cannot
  represent future or hybrid classes cleanly.
- A single selected solution class: rejected because Request captures constraints, not decisions.

## Decision: Preserve required, preferred, absent, and unknown states separately

**Rationale**: Required platforms, preferred platforms, empty arrays, and `unknown` communicate
different business meanings. Keeping them distinct prevents downstream Discovery consumers from
mistaking missing knowledge or a preference for a hard requirement.

**Alternatives considered**:

- Treat all absent and unknown values as empty lists: rejected because no known values and unknown
  applicability are materially different evidence states.
- Treat preferred platforms as required platforms: rejected because preference must not eliminate
  otherwise eligible candidates.

## Decision: Keep procurement and known systems as Request evidence

**Rationale**: Procurement constraints limit acquisition choices, while known systems describe the
business process context. Neither field selects an architecture or implements integration logic.

**Alternatives considered**:

- Encode procurement restrictions as vendor restrictions: rejected because an organization may
  prohibit new purchases while allowing existing products or custom development.
- Infer integrations or architecture from known systems: rejected because such evaluation belongs
  to Discovery and ADR.

## Decision: Validate through existing repository tooling and focused scenarios

**Rationale**: The change must preserve source-skill validation, shared-template validation,
privacy, transaction, generated-adapter correspondence, and existing Request behavior. Focused
scenarios will add populated, empty-array, unknown, preferred-platform, procurement, and known-
system cases without creating runtime fixtures in the framework tree.

**Alternatives considered**:

- Add a new test framework or runtime dependency: rejected because the repository's Bash 3.2-
  compatible static and behavioral test conventions are sufficient.
- Modify Discovery or ADR tests: rejected because Feature 053 has no implementation scope in those
  workflows.
