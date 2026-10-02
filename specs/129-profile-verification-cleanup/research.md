# Research: Profile Verification Cleanup

## Decision 1: Limit the source change to Verification and the duplicate final section

**Decision**: Update only the Verification assertions in `.highway/skills/highway-profile/SKILL.md` and remove the duplicate final `### Experience` section.

**Rationale**: The requested collaborative behavior is already present in Profile and its shared authorities. Verification is the stale layer; changing Acquisition, Enrichment, Operations, or shared governance would exceed scope and increase regression risk.

**Alternatives considered**:
- Redesign the full Profile interaction model: rejected because Feature 128 already established it.
- Amend the Experience Standard or Constitution: rejected because this cleanup consumes their existing contracts.
- Add a new Profile lifecycle artifact: rejected because Working Ideas and Active Reasoning Context are transient.

## Decision 2: Use Working Idea and Converged Proposal as Verification vocabulary

**Decision**: Replace paragraph-only and immediate-acceptance checks with checks for transient Working Ideas, complete Converged Proposals, adaptive convergence, artifact-level validation, and acceptance-before-persistence.

**Rationale**: The shared lifecycle distinguishes developing reasoning from accepted organizational knowledge without changing the retained Profile schema or readiness states.

**Alternatives considered**:
- Keep paragraph wording and reinterpret it informally: rejected because it preserves a contradictory test contract.
- Add maturity or collaboration fields to the Profile record: rejected because the schema is protected.

## Decision 3: Verify contextual re-evaluation without requiring acknowledgment

**Decision**: Verification will require accepted knowledge to be reconsidered with relevant accumulated Profile context, allow useful interpretation or advisory contribution, and allow a natural transition when nothing useful emerges.

**Rationale**: The current Experience Standard defines contextual re-evaluation as the governing behavior; a prescribed acknowledgment stage is obsolete.

**Alternatives considered**:
- Require an acknowledgment bridge after every accepted domain: rejected because it conflicts with the shared interaction model.
- Require commentary after every acceptance: rejected because Highway must not manufacture useful-looking output.

## Decision 4: Preserve protected Profile ownership and correspondence

**Decision**: Keep `profile-record.md`, schema `3.0.0`, four domains, three readiness states, website scope, persistence ordering, and all non-Verification behavior unchanged. Regenerate declared Profile correspondence after the source edit.

**Rationale**: This is a contract-alignment cleanup, not a data-model or runtime change. Generated artifacts must remain synchronized with the source skill.

**Alternatives considered**:
- Hand-edit generated adapters or catalogs: rejected because repository generators own those outputs.
- Modify shared governance or unrelated skills: rejected because the source Profile contract already aligns with them.

## Decision 5: No external contract artifact

**Decision**: Do not create a `contracts/` directory.

**Rationale**: The feature changes a Markdown governance skill and its executable checks; it introduces no API, command schema, protocol, or persisted data interface.

**Alternatives considered**:
- Add a Profile schema contract: rejected because the schema is explicitly unchanged.
- Add a behavioral API contract: rejected because the user-visible behavior is covered by the skill and existing checks.
