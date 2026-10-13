# Data Model: Objective Archetypes

This feature introduces no persisted data model. The following conceptual entities describe the
transient recommendation reasoning and existing accepted context that the skill must preserve.

## Objective Archetype

- **Purpose**: Internal guidance for a commonly useful outcome area.
- **Families**: Growth, Operations, Customer, and Capability.
- **Persistence**: None.
- **Ownership**: Highway recommendation guidance only; it is not organizational knowledge.
- **Validation**: Must not establish organizational facts, intent, problems, readiness, or accepted Objectives.

## Profile-Derived Recommendation

- **Purpose**: A Working Idea grounded in accepted Profile evidence.
- **Source**: Accepted Profile evidence declared by the Objective skill.
- **Ordering**: Evaluated before archetype-derived recommendations.
- **Persistence**: None until the normal Objective Development Lifecycle is accepted and captured.

## Archetype-Derived Recommendation

- **Purpose**: A Working Idea generated when a meaningful coverage gap may benefit the organization.
- **Source**: Internal Objective Archetype guidance plus accepted Profile and Objective context.
- **Presentation**: Indistinguishable from Profile-derived recommendations to the person.
- **Persistence**: None until the normal Objective Development Lifecycle is accepted and captured.

## Recommendation Set

- **Contents**: Profile-derived and, when useful, archetype-derived Objective recommendations.
- **Limit**: At most five distinct actionable choices, preserving the existing Experience Standard contract.
- **User authority**: The person may select, modify, reject, replace, request more information, or provide a user-authored outcome.
- **Duplicate handling**: Existing exact-duplicate and semantic-overlap behavior remains authoritative.

## Coverage Gap

- **Purpose**: A meaningful outcome area not adequately represented by accepted Profile evidence or the accepted Objective portfolio.
- **Use**: Determines whether an archetype-derived recommendation may be useful.
- **Rule**: Coverage gaps do not require one recommendation per family and do not themselves establish an organizational need.

## State and Persistence Constraints

- Archetypes and coverage evaluation have no new lifecycle state.
- Recommendations remain Working Ideas until the existing acceptance boundary is crossed.
- No Objective record, catalog entry, identifier, readiness field, or durable coverage artifact is added.
