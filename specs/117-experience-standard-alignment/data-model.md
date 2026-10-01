# Feature 117 Data Model

This feature changes a versioned governance document and its static contract tests. The entities below
are conceptual contract elements, not runtime storage records.

## Experience Standard

- **Identity**: Layer 2 governance artifact at `.highway/governance/experience-standard.md`.
- **Version**: Current `5.0.0`; target `6.0.0` for this MAJOR amendment.
- **Scope**: User-visible output and interaction emitted by Highway skills.
- **Relationships**: Constrained by the Highway Skills Constitution and consumed by Setup, Profile,
  Objectives, Controls, and NFR workflows.
- **Validation**: Exactly one current sync impact report, current footer metadata, no duplicate or
  reused X identifiers, and no Constitution rule-text restatement.

## Experience Rule

- **Identity**: Stable `X` namespace identifier, such as `X2.9` or `X2.35`.
- **Rule**: One observable user-visible obligation.
- **Observable**: The evidence a reviewer or test checks in emitted output or the standard's contract.
- **Tier**: Current enforcement classification, such as `[agent-checkable]`.
- **Lifecycle**: Existing IDs persist across amendments; retired IDs are never reused; new IDs are
  allocated only for genuinely new obligations.

## Interaction Pattern

- **Context inputs**: Accepted information, available evidence, imports or discovery, and owner-declared
  repository context.
- **Action**: Recommendation, one unresolved question, material interpretation review, decision-context
  explanation, transition, synthesis, or direct result response.
- **Acceptance boundary**: The point at which a selection or user-authored information becomes accepted
  context; explanation or comparison alone does not cross it.
- **Visible constraints**: At most five actionable recommendations, one response-demanding question or
  decision in the final Setup block, question-first Decision Context, and hidden orchestration mechanics
  during normal guided conversation.
- **Outcome**: Accepted context, a proposed value, an owner transition, a concise synthesis, or a
  directly requested machine-oriented result.

## Owning Workflow Boundary

- **Owners**: Setup, Profile, Objectives, Controls, and NFRs.
- **Owner responsibilities**: Domain evidence, lifecycle, persistence, readiness, derivation, identifiers,
  and orchestration as applicable.
- **Shared-standard responsibilities**: Presentation order, recommendation interaction, acceptance
  semantics, visible transitions, synthesis constraints, and suppression of machine-only output.
- **Invariant**: The Experience Standard references owner contracts without copying their workflows.

## Amendment Record

- **Version change**: `5.0.0 -> 6.0.0 (MAJOR)`.
- **Date**: 2026-10-01.
- **Changed elements**: Strengthened or redefined shared interaction rules and corrected examples.
- **Unchanged elements**: Any rule, section, or behavior not named in the report remains in force.
- **Self-application**: The report cites the Development Constitution and confirms no rule text is restated.

## State Transitions

```text
unknown
  -> proposed        when discovered or extracted
proposed
  -> accepted        when the owner-defined acceptance boundary is satisfied
accepted
  -> reused          when it grounds later guidance without a duplicate question
recommendation
  -> accepted        when explicitly selected
recommendation
  -> unchanged       when explained, compared, or discussed without selection
completed-domain
  -> synthesized     when accepted context has a concise user-relevant summary
completed-domain
  -> transitioned    when Setup enters the next active owner
owner-result
  -> hidden          during normal orchestrated conversation
owner-result
  -> visible         when the person directly requests the result or needs it to act
```
