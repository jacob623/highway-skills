# Data Model: Profile Question-Bias Simplification

**Feature**: 168

This feature introduces no durable data model. The entities below describe transient guidance and validation boundaries only.

## Entity: Discovery Contribution Opportunity

A proposal-first interaction surface that gives the person structured, grounded material to add, correct, remove, or extend before convergence.

| Property | Constraint |
|---|---|
| Lifecycle | Existing Profile contribution and convergence flow; no new state |
| Persistence | Transient until existing Profile acceptance boundary |
| Contents | Grounded interpretations, implications, tradeoffs, and possibilities |
| Reaction | Existing shared reaction invitation remains the response path |

## Entity: Structured Starting Point

A provisional, reviewable representation of the active domain's grounded interpretation. It may contain structure, implications, tradeoffs, or possibilities when supported by accepted evidence.

| Property | Constraint |
|---|---|
| Domains | Vision, Competitive Path, Guiding Principles |
| Status | Working Idea, not accepted Profile content |
| Source | Accepted Profile evidence and responsible advisory reasoning |
| Boundary | Must not replace the existing Converged Proposal or acceptance boundary |

## Entity: Advisory Question

A focused question used only when accepted evidence cannot support a responsible starting point or consequential ambiguity remains unresolved.

| Property | Constraint |
|---|---|
| Allowed use | Consequential ambiguity or missing user-owned information |
| Excluded use | Permission-seeking after a responsible interpretation is already available |
| Fallback | Existing canonical Profile questions remain available |

## Entity: Profile Guidance Surface

The authoritative source Markdown plus its generated agent copies and catalog correspondence.

| Property | Constraint |
|---|---|
| Source | `.highway/skills/highway-profile/SKILL.md` |
| Generated copies | `.github`, `.claude`, `.cursor`, and `.agents` Profile adapters |
| Correspondence | Generated copies match source byte-for-byte |
| Schema impact | None |
