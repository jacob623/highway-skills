# Research: Profile Contribution Opportunity

## Decision 1: Keep Contribution Opportunity transient and Profile-owned

- **Decision**: Represent Contribution Opportunity as guidance within the existing Working Idea lifecycle. Do not add a readiness value, persisted marker, checkpoint, or Profile record field.
- **Rationale**: The Experience Standard defines the behavior as transient collaborative development, while Profile already owns domain completeness, proposal presentation, acceptance, and persistence. A new state would create an unauthorized lifecycle boundary and increase migration risk.
- **Alternatives considered**:
  - Add `contribution_pending` or `completion_pending`: rejected because it would alter the retained Profile lifecycle.
  - Add a shared Setup checkpoint: rejected because Setup does not own Profile discovery or interpretation.

## Decision 2: Prove the behavior in Vision, Competitive Path, and Guiding Principles

- **Decision**: Apply the proving behavior to the three domains where Profile performs substantial synthesis and preserve Identity's primarily accuracy-oriented path.
- **Rationale**: These domains already have Working Idea and Converged Proposal behavior that can demonstrate the substance-versus-representation distinction. Complete discovered Identity can continue directly to accuracy validation without a ceremonial opportunity.
- **Alternatives considered**:
  - Require the opportunity for all four domains: rejected because complete Identity evidence has a distinct validation path and the feature explicitly preserves adaptive depth.
  - Apply the behavior only to Guiding Principles: rejected because it would not prove the shared behavior across the requested Profile domain patterns.

## Decision 3: Use provisional substantive pieces before final synthesis

- **Decision**: Profile may expose themes, short statements, distinctions, directions, tradeoffs, or principles before synthesizing the cohesive domain narrative.
- **Rationale**: The person should review substantive completeness once and final representation once. Decomposed Working Idea content avoids repeating substantially identical final-form prose.
- **Alternatives considered**:
  - Present the complete final narrative before the opportunity: rejected because it collapses substantive contribution and artifact acceptance.
  - Require fixed wording: rejected because the shared standard governs behavior, not a literal script.

## Decision 4: Preserve one-question and acceptance boundaries

- **Decision**: The Contribution Opportunity is the only response-demanding question in its turn. Domain acceptance remains a separate later turn after the Converged Proposal.
- **Rationale**: This preserves X2.21 and existing Profile persistence semantics while preventing a single response from being misread as both substantive completion and artifact acceptance.
- **Alternatives considered**:
  - Ask for contribution and acceptance together: rejected because it combines two distinct decisions and violates the shared one-question discipline.
  - Treat "nothing else" as acceptance: rejected because it authorizes no persistence and only completes substantive contribution.

## Decision 5: Add focused static contract coverage and regenerate dependents

- **Decision**: Add a Profile-specific document contract under `.highway/tools/tests/`, retain existing Profile behavior/lifecycle/UX contracts, and regenerate all declared dependent artifacts.
- **Rationale**: This is a user-visible skill contract change. Static assertions can verify required guidance and protected boundaries, while existing mixed contracts continue to cover executable Profile lifecycle behavior. Generator refresh satisfies correspondence and shared-artifact review obligations.
- **Alternatives considered**:
  - Modify only the skill without a test: rejected by D3.3.
  - Add a new runtime implementation: rejected because Profile behavior is governed by the skill contract and existing owner tools.

## Resolved Technical Unknowns

- No external API, storage migration, protocol, or runtime dependency is required.
- No contracts directory is needed because the repository exposes no new external interface for this feature.
- No unresolved technical clarification remains from the approved Feature 134 specification.
