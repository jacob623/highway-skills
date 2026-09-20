# Request Solution Constraints Intake Contract

## Invocation

`highway-new` receives a business request and collects evidence in the existing deterministic
order. Feature 053 adds `Solution Constraints` after `Business Constraints` and before durable
Request creation.

## Intake Questions

The workflow asks one natural-language question at a time and keeps examples separate from
requester evidence. The Solution Constraints questions cover:

1. Allowed solution classes as a user-owned, extensible list.
2. Existing enterprise platforms required.
3. Existing enterprise platforms preferred.
4. Known business systems involved in, affected by, referenced by, or participating in the process.
5. Hosting restrictions.
6. Vendor restrictions.
7. Procurement constraints.
8. Regulatory or data-handling restrictions.

The workflow may group related prompts across turns only according to the existing one-question
per-turn behavior. It must not ask the requester to choose an architecture or recommendation.

## Value Rules

- Preserve multiple allowed solution classes without ranking.
- Preserve required and preferred platforms separately.
- Preserve known systems as descriptive context only.
- Record empty arrays when the requester knows no list values apply.
- Record `unknown` when the requester cannot determine whether values apply.
- Treat absent constraints as neutral, never as preferences or recommendations.
- Apply existing privacy screening to secrets and regulated personal data.

## Boundary Rules

Request owns intake and evidence. Discovery owns future candidate generation, classification,
comparison, scoring, recommendation, and architecture analysis. ADR owns solution and architecture
decisions. This contract defines no Discovery consumption behavior beyond the documented eligibility
meaning and creates no ADR decision.

## Acceptance Cases

- Multiple allowed solution classes are retained in user-provided order or the established stable
  normalization order without ranking them.
- Required and preferred platform entries remain distinguishable.
- Explicitly empty list fields serialize as empty arrays.
- Unknown fields serialize as `unknown` and do not block completeness.
- A procurement rule such as `No Net New Purchases` is retained without removing custom-development
  eligibility.
- Known systems such as Salesforce, SAP, SharePoint, Workday, or ServiceNow are retained without
  inferred integration or architecture.
- A preferred product or platform is retained as business context, not as a decision.
