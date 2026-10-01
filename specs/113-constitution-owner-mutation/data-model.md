# Data Model: Constitution Owner Mutation Boundary

This feature has no runtime data store. Its model is the governed document structure that must
remain internally synchronized.

## Principle XII rule row

- **Entity**: Principle XII rule
- **Fields**: stable rule ID, rule text, observable, tier
- **Identity**: rule ID (`P12.5` through `P12.15`) is unique within Principle XII.
- **Validation**:
  - P12.5–P12.12 retain their existing values.
  - P12.13–P12.15 each contain one obligation, one observable, and `[agent-checkable]`.
  - The new rules state mutation-before-result, acceptance/result separation, and terminal-result
    completion ordering respectively.

## Principle XII metadata

- **Entity**: Principle XII metadata
- **Fields**: rationale, precedence rank, precedence reason
- **Identity**: the Principle XII heading and its rank-5 precedence row.
- **Validation**:
  - The rationale mentions owner-controlled mutation and reported owner outcome.
  - The precedence reason mentions owner mutation, readiness, results, and orchestrator advancement.
  - The rank remains 5.

## Constitution document metadata

- **Entity**: Constitution amendment metadata
- **Fields**: Sync Impact Report, version, last amended date, self-application review
- **Identity**: the top-level report and footer version.
- **Validation**:
  - Version changes from 5.0.0 to 6.0.0.
  - The report classifies the amendment as MAJOR and names P12.13–P12.15.
  - The self-application review covers P1.1–P1.4, P6.4, P6.6, and P7.3.

## Lifecycle boundary

The amendment documents the ordered lifecycle `acceptance → owner mutation → owner result →
orchestration`. Acceptance authorizes an applicable mutation; it is not the mutation result, and
orchestration cannot claim completion before all required owners return terminal results.
