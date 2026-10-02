# Data Model: Profile Contribution-First Synchronization

This feature introduces no persisted data model, schema field, readiness state, or migration.

## Conceptual entities

### Converged Proposal

- **Meaning**: A complete Profile-domain candidate that answers the active domain's purpose coherently without unsupported facts.
- **Lifecycle**: Working Idea development -> complete candidate -> existing owner acceptance -> Profile mutation.
- **Persistence**: Only after acceptance, using the existing Profile record structure.

### Working Idea

- **Meaning**: A transient grounded direction, distinction, implication, alternative, tradeoff, connection, provisional recommendation, or explanation that advances the active Profile domain.
- **Lifecycle**: Seed -> interpret/sharpen/develop -> correct, replace, abandon, or converge.
- **Persistence**: Never persisted as a separate state or field; agreement with it does not establish `discussed`.

### Focused Canonical Question

- **Meaning**: The existing domain-specific question used when neither contribution form is responsibly supported or when the person's information is genuinely required.
- **Persistence**: None.

### Accumulated Accepted Profile Context

- **Contents**: Accepted Identity, Vision, Competitive Path, Guiding Principles, accepted discoveries, and other existing accepted Profile evidence.
- **Relationships**: Grounds later-domain evaluation without changing retained schema or readiness semantics.

## Existing retained model unchanged

- Schema version: `3.0.0`
- Domains: `identity`, `vision`, `competitive_path`, `guiding_principles`
- Domain states: `not_discussed`, `discussed`, `bounded`
- Existing Profile mutation, readiness, website, organization-name, and error boundaries remain authoritative.
