# Research: Objectives Structural Refinement

## Decision 1: Refine the authored skill rather than introduce runtime structures

- **Decision**: Treat Feature 160 as a source-guidance and static-contract refinement. Change the
  authored `.highway/skills/highway-objectives/SKILL.md`, regenerate declared adapters, and add
  focused document checks.
- **Rationale**: The feature explicitly preserves ownership, queueing, persistence, identifiers,
  catalog behavior, and setup orchestration. No new runtime state, interface, or storage is needed.
- **Alternatives considered**: Adding a runtime recommendation model or persisted guidance record
  was rejected because it would violate the feature's presentation-only scope.

## Decision 2: Use the existing Profile section pattern

- **Decision**: Make the six named Objective guidance sections peer sections in the requested order,
  while leaving Creation Workflow responsible for sequencing, discovery dimensions, review,
  continuation, and persistence boundaries.
- **Rationale**: The requested structural pattern is the change's primary acceptance signal and
  improves discoverability without duplicating the existing behavioral contract.
- **Alternatives considered**: Keeping advisory guidance nested in Creation Workflow was rejected
  because it is the source of the salience problem. Creating a new parent abstraction was rejected
  because it would add hierarchy without improving peer visibility.

## Decision 3: Enforce the clarified prose budget

- **Decision**: Permit only the six required peer headings and one concise recommendation exemplar
  as new authored behavioral prose; relocate or compress all other content.
- **Rationale**: This directly records the accepted clarification and makes size control testable.
- **Alternatives considered**: A numeric line budget was rejected because relocation and formatting
  changes make raw line counts less meaningful than the bounded-content rule.

## Decision 4: Keep contracts and external interfaces unchanged

- **Decision**: Do not create a `contracts/` artifact for Feature 160.
- **Rationale**: The repository's relevant interfaces are existing skill output and mutation
  contracts, all explicitly protected by the spec. This feature does not add or change an external
  API, command schema, or persisted record shape.
- **Alternatives considered**: Re-documenting existing mutation output as a new Feature 160
  contract was rejected because it would duplicate the owning skill contract and risk drift.