# Phase 1 Data Model: Conversation Delivery Hardening

**Feature**: 153 | **Date**: 2026-10-09

This feature has no runtime data. Its entities are units of delivered text, and its "fields" are
the properties a static document contract can decide. The model below exists so that every
requirement has one named place to live and one checkable property, and so that the boundary
between what is checked and what is merely hoped for stays visible.

## Entity: Standard Rule

A normative line in `.highway/governance/experience-standard.md`.

| Field | Constraint | Source |
|---|---|---|
| `id` | `X<section>.<n>`, never reused after retirement | Standard provenance |
| `text` | exactly one of MUST / MUST NOT / SHOULD | `P1.1` |
| `text` | 25 words or fewer | `P1.3` |
| `text` | exactly one obligation | `P1.2` |
| `text` | an explicit when / if / unless clause where conditional | `P3.4` |
| `observable` | non-empty; carries the countable condition for any vague term | `P1.4` |

**Instances added**: X2.68, X2.69, X2.70, X2.71, X2.72.
**Instance amended**: X2.56 — Observable only; rule text unchanged.

**State**: a rule is *drafted* (recorded in research.md), then *evaluated against every citing
skill* (`D3.4`, `D8.1`), then *enabled*. A rule enabled before evaluation would silently change
the verdict of artifacts already in the tree, which is the failure `D3.4` names.

## Entity: Emitted Literal

Text reproduced verbatim to the person. Two exist in scope; one is added.

| Instance | Owner | Status |
|---|---|---|
| `**What would you add, correct, or remove?**` | `highway-profile`, governed by `X2.21` / `X2.49` | existing; **count must remain 1** per R6 |
| the reaction invitation for an uncaptured subject | the Standard, via X2.72 | **added**; wording signed off — `**Here's a direction worth considering — what's missing from it?**` |
| the unemphasized "I don't know" reassurance | `highway-profile` | **added**; must not be the emphasized element (`X2.67`) |
| the domain-boundary cue for the future-oriented domain | `highway-profile` | **added** |

**Invariant**: an emitted literal is checked by exact string match, which is why its wording is a
decision and not an implementation detail. Changing one later breaks a test by design.

## Entity: Delivery Site

The place where a Standard rule reaches the agent. Exactly three forms exist, and FR-014 permits
no fourth.

| Form | Where it appears | Measured conformance in the assessment |
|---|---|---|
| Emitted literal | reproduced verbatim in the skill body | 22 of 24 |
| Skill-owned procedure | prose instruction in a procedure section | 2 of 6 |
| Verification entry | a checkable outcome in `## Verification` | — |
| *rule-only (no site)* | the Standard alone | 2 of 6 |

**Constraint**: a delivery site must not restate the rule it delivers (`P7.3`, FR-014), and in
`highway-profile` it must contain no MUST-level keyword (FR-015). These two together are the whole
difficulty of this feature: the site must carry the obligation's force without carrying its words
or its keyword.

## Entity: Domain Handoff

A transition between two of Profile's four domains. Exactly three exist.

| From | To | Receives |
|---|---|---|
| Identity | Vision | continuity text naming accepted substance |
| Vision | Competitive Path | continuity text naming accepted substance |
| Competitive Path | Guiding Principles | continuity text naming accepted substance |

**Out of scope, by clarification**: Profile → Objectives. It receives the question restriction and
nothing else — no continuity text, and no heading change now that FR-005 is withdrawn. This
residual is recorded in the spec's Assumptions.

## Entity: Exemplar

A worked demonstration of X2.68's behavior. Exactly three, each a different move.

| # | Move | Closes on |
|---|---|---|
| 1 | a distinction drawn out of a single word the person used | an open question in that domain's content |
| 2 | latent structure named as an organizing principle | an open question in that domain's content |
| 3 | a stated preference reframed as a decision criterion | an open question in that domain's content |

| Field | Constraint | Source |
|---|---|---|
| content | concrete domain material, not placeholder structure | FR-011 |
| closing | invites contribution, not approval | FR-011, `X2.49` |
| closing | **must not reproduce the emphasized acceptance literal** | R6 |
| provenance | must not cite a development path | `D1.1` |

## Requirement-to-site map

Every functional requirement, its artifact, and the property a test can decide.

| FR | Artifact | Site | Checkable property |
|---|---|---|---|
| FR-001 | `highway-profile` | procedure, 4 domains | candidate-before-retention text present per domain |
| FR-002 | `highway-profile` + Standard X2.72 | procedure + literal | restriction present; new literal present; old literal still counts 1 |
| FR-003 | `highway-profile` | procedure | delivery names persistence, progression, domain state |
| FR-004 | `highway-profile` | emitted literal | cue excludes approach and sequencing, names the owning domain |
| FR-005 | *withdrawn* | — | no artifact; the heading level is not changed |
| FR-006 | `highway-profile` | emitted literal | reassurance present and unemphasized |
| FR-007 | Standard X2.56 | Observable | names the inline form |
| FR-008 | `.highway/instructions/highway-agent-context.md` | prose | names the moment the Standard is read |
| FR-009 | Standard X2.68 | rule | present, one keyword, 25 words or fewer |
| FR-010 | Standard X2.69 | rule + Observable | bound present; exclusion list in Observable |
| FR-011 | `highway-profile` | new `#### Contribution in practice` | exactly 3; 3 distinct moves; 3 open closings |
| FR-012 | Standard X2.70, X2.71 | rules | present; the nothing-accepted case defined |
| FR-013 | `highway-profile` | procedure, 3 handoffs | continuity text at each; not a generic transition sentence |
| FR-014 | all changed skills | — | no Standard rule sentence appears in a skill |
| FR-015 | `highway-profile` | — | MUST-level keyword count is 0 |
| FR-016 | 4 agent trees + catalogs | — | regeneration leaves no diff |
| FR-017 | completion report | — | post-change section size recorded |
| FR-018 | completion report | — | no requirement claimed as runtime evidence |
| FR-019 | completion report | — | coverage stated separately from check results (`D7.3`) |
| FR-020 | completion report | — | deferral of conversational evaluation recorded |

**Coverage**: FR-005 is withdrawn. Of the 19 live requirements, 19 have a named artifact. 14 have
an automatable property; 5 (FR-014, FR-017, FR-018, FR-019, FR-020) are agent-checkable and are
reported, not tested.

## What this model deliberately does not contain

There is no entity for a conversation, a run, or an observed behavior. That is the consequence of
the clarification decision, and it is the reason every property above is a string match or a count.
A complete pass over this model establishes that the text exists. It establishes nothing about what
an agent does with it.
