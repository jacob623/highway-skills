# Research: Highway Onboarding

## Decision 1: Add a canonical onboarding skill and preserve owner boundaries

**Decision**: Create `.highway/skills/highway-onboarding/SKILL.md` as the owner of capability discovery, mapping evidence, proposal review, direct ADR record creation, and downstream sequencing. It delegates Reference Architecture generation to `highway-architecture` and Reference Implementation generation to `highway-implementation`.

**Rationale**: The specification requires onboarding to create a standard ADR directly while forbidding substitute artifacts. A dedicated owner gives onboarding a stable entry point and keeps the Discovery-based ADR workflow isolated.

**Rejected**: Extending `highway-new`, `highway-discovery`, or `highway-adr`. Those workflows own different artifacts or the separate Discovery-based ADR path and would cross the requested ownership boundary.

## Decision 2: Create onboarding ADRs directly from shared templates

**Decision**: `highway-onboarding` directly creates a normal ADR from the shared record and catalog templates after proposal acceptance. It owns validation, identifier allocation, provenance, and atomic persistence for this path. `highway-adr` remains Discovery-based and unchanged.

**Rationale**: This directly satisfies FR-017 and FR-022 while keeping the existing Discovery-based ADR contract isolated and preventing synthetic Discovery records.

**Rejected**: Extending `highway-adr`, creating a synthetic Discovery, or creating a second onboarding ADR template. These would cross the requested ownership boundary or create parallel artifacts.

## Decision 3: Use one-to-one scalar provenance

**Decision**: The direct onboarding path writes exactly one scalar `request: onboarding` value and one scalar `discovery: highway` value. The onboarding contract rejects list-shaped provenance.

**Rationale**: Request provenance and discovery source are one-to-one for an onboarding ADR, so list-shaped provenance is unsupported.

**Rejected**: Supporting lists or delimited strings, which would contradict the one-to-one provenance relationship.

## Decision 4: Keep mappings as onboarding evidence, not inventory entities

**Decision**: Store capability mappings in the transient onboarding state and pass the accepted mapping set to the ADR proposal. A mapping has capability, provider label, provider kind, optional primary flag, evidence, and validation status. Grouping by provider is a review projection only; it does not create a provider catalog or standalone platform record.

**Rationale**: The many-to-many requirement needs an explicit relationship model, while the inventory prohibition requires the model to remain bounded to the onboarding workflow and eventual ADR context.

**Rejected**: Normalizing platforms into a new catalog, which would violate FR-012 and create a second organizational knowledge model.

## Decision 5: Bound retries and make resume idempotent at owner boundaries

**Decision**: Treat ADR, Architecture, and Implementation as ordered owner mutations. After a successful mutation, persist its durable identifier/result before invoking the next owner. Retry a failed Architecture or Implementation mutation at most three times. If all attempts fail, stop orchestration and expose a resume action naming the failed owner and the last successful owner. Resume begins at the failed owner and never repeats successful mutations.

**Rationale**: This matches FR-021 through FR-025 and prevents duplicate durable records after downstream failures.

**Rejected**: Retrying the entire cycle, which could duplicate ADRs or architectures, and silently continuing after a failed owner, which would make completion claims false.

## Decision 6: Treat external material as optional, manually supplied evidence

**Decision**: Accept repository context, conversation, manually supplied website content/links, and imported materials as evidence inputs. Mark unavailable, contradictory, and incomplete material explicitly; do not fetch or synchronize enterprise systems in v1.

**Rationale**: The source boundary is explicit in FR-027 and avoids introducing network, authentication, or synchronization behavior into a governance skill.

**Rejected**: Live enterprise connectors or an automatic web crawler, which are out of scope and would introduce new security and persistence contracts.

## Validation implications

- Seed focused tests for direct template-based ADR creation, no synthetic identifiers, scalar/list provenance, many-to-many preservation, proposal validation, owner ordering, retry ceiling, and resume boundary.
- Preserve and rerun existing ADR tests to prove the Discovery-based path is unchanged.
- Regenerate adapters and catalogs from canonical sources; never hand-edit derived files.
