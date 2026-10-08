# Data Model: Collaborative Convergence

**Feature**: 150 | **Date**: 2026-10-07

This feature changes two governance documents. Its "entities" are the named terms those documents
define and the structures that carry them. No schema, no persisted field, and no readiness
dimension changes. `.highway/library/templates/output/profile-record.md` is untouched.

## Entities defined in the Experience Standard

| Entity | Status | Fields / content | Validation |
|---|---|---|---|
| **Substantive Contribution** | Existing, unchanged text | A response that adds, changes, corrects, removes, distinguishes, qualifies, redirects, or otherwise supplies information that can change active understanding | Approval, rejection, and selection without new information are already excluded by the paragraph following the X2 table |
| **Contribution Opportunity** | Existing, definition amended | A meaningful opportunity to add, correct, remove, or extend a Working Idea before it becomes a Converged Proposal | Amended to state it is not a candidate and carries no acceptance request (FR-002) |
| **Exploratory Move** | New | A development of a Working Idea that extends what the person said toward something a later decision depends on | Must name the prompting words (X2.45) and must not be a question about wording alone (X2.46) |
| **Grounded Possibility** | New | A direction traceable to accepted material, offered for reaction rather than selection | Distinguished from a recommendation set (X2.47); absence stated rather than manufactured (X2.48) |
| **Attribution** | New | An inline statement, at the point of use, that a term or claim originated with Highway rather than the person | Applies to introduced domain vocabulary and unstated substantive claims; ordinary paraphrase is exempt (X2.52) |
| **Converged Proposal** | Existing, unchanged | A complete candidate whose relevant substance is developed enough | Now additionally gated by X2.41's factual condition |

### Relationships

```text
Working Idea
   ├─ developed by ─> Exploratory Move ──┐
   ├─ illustrated by ─> Grounded Possibility ──┤
   │                                           ├─> carried in a Contribution Opportunity
   │                                           │     (no capture heading, no acceptance request)
   │                                           │
   └─ marked by ─> Attribution ────────────────┘
                                                 │
                     person responds ────────────┤
                                                 ▼
                                  Substantive Contribution?
                                      │ no              │ yes
                                      ▼                 ▼
                          X2.41 blocks convergence   Converged Proposal
                                                        │
                                                        ▼
                                             open acceptance request (X2.49)
                                                        │
                                             ┌──────────┴──────────┐
                                        partial (X2.50)        accepted
                                             │                     │
                                             ▼                     ▼
                                   ask which part is wrong   owner persists
```

### State transition: a Profile domain

| From | Event | To | Rule |
|---|---|---|---|
| Unresolved | Highway opens the subject | Under development | Profile domain sections |
| Under development | Person has made no Substantive Contribution | Contribution Opportunity owed | X2.37 |
| Under development | Person makes a Substantive Contribution | Convergence permitted | X2.41 |
| Contribution Opportunity given | Person responds with approval or selection only | Still owed, no second opportunity without new substance | X2.37 + X2.57 |
| Convergence permitted | Candidate presented with open acceptance request | Awaiting acceptance | X2.21, X2.49 |
| Awaiting acceptance | Partial acceptance | Back to under development | X2.50 |
| Awaiting acceptance | Acceptance | Persisted by Profile | Profile Operations, unchanged |
| Persisted | Later addition | Amended, accepted text byte-preserved | X2.55, X2.56 |
| Persisted | Any later turn | Never re-reviewed | X2.51 |

## Entities in the Profile skill

| Entity | Change |
|---|---|
| Identity, Vision, Competitive Path, Guiding Principles | Domain meaning, evidence rules, readiness, and persistence all unchanged |
| Subject openings (`### Where you're going`, `### How you'll get there`, `### What will guide your decisions`) | Retained verbatim; each is now followed by grounded possibilities before the domain question (FR-009) |
| Default acceptance sentence (×4) | Replaced: closed yes/no → open "what's missing or wrong" (FR-016, FR-033) |
| User-authored alternative line (×4) | Retained verbatim — it already satisfies X2.17 |
| Identity permissive hook | Deleted; the obligation moves to X2.37 (research §10) |
| Canonical domain questions (×4) | Unchanged; they remain Profile-owned fallbacks |
| `metadata.version` | `9.0.0` → `10.0.0` |

## Invariants

- The Experience Standard contains exactly **49** rule rows after this change (33 + 16).
- The Interaction Boundaries table contains exactly **5** rows before and after.
- No retired X identifier (X1.7, X2.2, X2.8, X2.14, X2.23, X2.25, X2.26, X2.27, X2.28, X2.33,
  X2.39, X2.40) is reused. New identifiers begin at X2.42.
- Every new rule contains exactly one of `MUST`, `MUST NOT`, `SHOULD`, states one obligation, and
  is 25 words or fewer.
- The Profile skill contains zero `MUST`-level rules before and after.
- The string `X2.41` does not appear in the Profile skill.
