# Data Model: Profile Runtime Architecture Alignment

This feature preserves the retained Profile schema. The entities below describe the runtime
ownership and state transitions that the implementation must preserve or clarify.

## Profile Domain

A Profile Domain is one of:

- Identity
- Vision
- Competitive Path
- Guiding Principles

### Attributes

- `meaning`: the domain-specific purpose and boundary.
- `evidence`: organizational information permitted by Profile and relevant to the domain.
- `state`: `not_discussed`, `discussed`, or `bounded`.
- `narrative`: accepted domain representation, rendered only when the retained state permits it.
- `completeness`: Profile's determination that accumulated evidence supports a cohesive domain
  narrative without unsupported organizational facts.

### Relationships

- A domain may be informed by accepted evidence from other Profile domains.
- A domain acceptance question applies to its own Converged Proposal and does not determine
  conversational convergence.
- A domain mutation changes readiness only after persistence succeeds.

## Profile Evidence

Profile Evidence is organizational information supplied, selected, or accepted through Profile's
acquisition and domain acceptance behavior.

### Rules

- Discovered or imported information remains proposed until accepted.
- Highway Identity context is not Profile Evidence and is never retained as organizational fact.
- Working Ideas, recommendations, advisory reasoning, Contribution Opportunities, and
  conversational clarification are not retained Profile Evidence.
- Evidence may be evaluated across every unresolved Profile domain.

## Highway Identity Context

Shared, non-normative context describing what Highway is, why it exists, and what it is trying to
achieve.

### Rules

- It may help Profile interpret its role and connected-knowledge model.
- It is not organizational evidence, behavioral governance, strategic organizational direction, an
evaluation criterion, or a source of organizational facts.
- It is not persisted into the Profile.

## Profile Readiness

Profile Readiness is the owner result based only on the four Profile Domain states.

### State transitions

- Missing Profile -> `Missing` with Profile setup as the next action.
- Present malformed, contradictory, or structurally invalid Profile -> `Blocked` with no mutation.
- Valid Profile with any `not_discussed` domain -> `Missing` with Profile configuration as the next
  action.
- Valid Profile with all four domains `discussed` or `bounded` -> `Complete` with no next action.
- Optional Context, optional enrichment, and Highway Identity context do not add readiness states or
  dimensions.

## Converged Proposal

A complete candidate whose relevant substance is developed enough under the Highway Experience
Standard that further grounded reasoning is unlikely to materially improve it.

### Boundary

- The Experience Standard determines conversational convergence.
- Profile determines domain completeness.
- Profile presents its domain-specific acceptance question only after the Experience Standard
  permits a Converged Proposal.

## Accepted Profile Knowledge

User-owned Profile information that crossed the applicable domain acceptance boundary and can inform
later Profile reasoning.

### Persistence rules

- Acceptance authorizes the declared Profile mutation but does not prove persistence.
- The mutation must succeed before dependent readiness, completion, or owner results use the new
  state.
- A failed mutation leaves the affected domain unpersisted and blocks dependent progression.

## Profile Completion Synthesis

One concise, user-relevant synthesis emitted by Profile after successful final Profile persistence
before returning to Setup.

### Boundary

- Profile owns the synthesis when guided setup or configure completes.
- The synthesis contains no readiness or machine-result fields and adds no question.
- Setup consumes the synthesis without duplicating it.
