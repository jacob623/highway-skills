# Delivery-Site Contract

**Feature**: 154 | **Evidence class**: static document contract

This feature is satisfied by source text and its generated delivery copies. These contracts do not
establish runtime conversational behavior.

## C1 - Profile reassurance

Source: `.highway/skills/highway-profile/SKILL.md`

- A Converged Proposal contains the unemphasized sentence `If this is accurate, just say so.`.
- Before the first Substantive Contribution in an active domain, the source contains the
  unemphasized conditional sentence `If you don't know, say "I don't know" and we'll work through it together.`.
- The conditional sentence is explicitly scoped to that pre-contribution moment and is absent from
  later post-contribution guidance.
- Imported website evidence is described as not counting as the person's Substantive Contribution.

## C2 - Proposed starting point

Source: `.highway/governance/experience-standard.md` and Profile delivery sites.

- X2.72 uses the exact heading literal `Here is a proposed starting point for your [domain]:`.
- Profile uses the bold domain-specific form for Identity, Vision, Competitive Path, and Guiding
  Principles when no material has been captured.
- No acceptance request follows this pre-candidate invitation.
- The existing capture heading `Here's what I've captured as your [domain]:` remains unchanged.

## C3 - Boundary and approval flow

Source: `.highway/skills/highway-profile/SKILL.md`

- The Vision boundary cue acknowledges value, says the material will be carried forward, and returns
  to Vision.
- The cue does not say that the contribution belongs elsewhere, is not Vision, or is wrong.
- The acceptance path states that unambiguous approval proceeds directly to candidate presentation.
- No second contribution-oriented review question is inserted between approval and candidate presentation.
- Ambiguous approval or approval with new substantive information remains subject to existing
  re-evaluation and convergence handling.

## C4 - Advisory question scaffolding

Source: `.highway/skills/highway-profile/SKILL.md`

- A non-canonical exploratory question has one grounded advisory addition before it when accepted
  evidence supports useful non-redundant reasoning.
- The addition is attributed as workflow reasoning, remains outside the candidate, and is not a
  recommendation set.
- The question is the only emphasized element in the exchange.
- Canonical, validation, acceptance-boundary, and direct consequential-clarification questions are
  excluded from this scaffolding requirement.

## C5 - Fresh Setup welcome

Source: `.highway/skills/highway-setup/SKILL.md`

- Fresh Setup begins with the existing `## Welcome to Highway` block.
- No review, loading, supplied-website, checking, or setup-order preamble precedes it.
- Resumed Setup does not emit the fresh welcome again.

## Generated delivery

After changing a source document, regenerate `.github/`, `.claude/`, `.cursor/`, `.agents/`, and
`AGENTS.md` using the repository generators. Do not hand-edit generated artifacts.
