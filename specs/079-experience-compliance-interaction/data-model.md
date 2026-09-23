# Feature 079 Data Model

This feature adds no persistent runtime data model. Its entities are versioned governance records
and review-output values.

## Entities

### Constitution Amendment

- **Source**: `.highway/governance/constitution.md`
- **Identity**: document path plus stable rule IDs `P10.1` and `P10.2`
- **Attributes**: Experience Standard definition, Principle X placement, rule text, Observable,
  tier, precedence rank, Compliance Review Protocol obligations, Sync Impact Report
- **Lifecycle**: proposed in Feature 079 spec, planned, applied as an additive amendment, then
  validated against the constitutional inventory and review-output tests
- **Validation**: no duplicated X2 rule text; version increment follows the authoritative
  Constitution Versioning Policy; every changed element is named in the impact report

### Experience Standard Amendment

- **Source**: `.highway/governance/experience-standard.md`
- **Identity**: X rule IDs `X2.2` through `X2.6`
- **Attributes**: rule text, Observable, tier `[agent-checkable]`, sample count, rationale,
  non-normative examples, N/A condition behavior
- **Lifecycle**: proposed, added to the X2 Interaction section, reviewed, and versioned under the
  Experience Standard Versioning Policy
- **Validation**: stable X namespace, exact rule-row fields, explicit N/A behavior for X2.5 and
  X2.6, and at least one N/A example

### Review Result

- **Identity**: governance rule ID, including P or X namespace
- **Attributes**: one of `PASS`, `FAIL`, or `N/A`; evidence; optional N/A condition token
- **Relationship**: one result per applicable rule in the existing five coverage groups
- **Validation**: X results use the same verdict vocabulary, evidence form, and N/A condition
  requirements as constitutional results; no additional verdict types are introduced

### Applicability Condition

- **Identity**: named trigger or N/A condition
- **Attributes**: rule ID, trigger state, condition token when N/A, evidence
- **Relationships**: X2.2-X2.4 apply to workflows meeting the Interactive Workflow definition;
  X2.5 and X2.6 are N/A when no Long-running activity exists
- **Validation**: definitions, assumptions, requirements, examples, and review output agree on
  the same trigger and N/A semantics

## Relationships

- The Constitution Amendment establishes that applicable Experience Standard rules govern amended
  or newly created skills.
- The Experience Standard Amendment defines the X2 interaction obligations referenced by that
  constitutional amendment.
- Each Review Result references exactly one rule ID and belongs to exactly one existing coverage
  group.
- Applicability Conditions determine whether a Review Result is PASS/FAIL or N/A; they do not
  alter the rule ID or create a new verdict type.
