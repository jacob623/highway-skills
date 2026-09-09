# Data Model: Highway Experience Standard

**Feature**: 017-experience-standard | **Date**: 2026-09-08

No runtime data. The entities below are the document's structure and the relationships that keep
it distinct from the two constitutions.

## Entities

### Experience Standard

The Layer 2 governing document at `.highway/governance/experience-standard.md`. Ships.

| Element | Obligation |
|---|---|
| Scope statement | What the document governs, and what it does not |
| Precedence | Skills Constitution outranks it; security-affecting rules outrank everything |
| Non-goal | Governs form of generated content only; states nothing about a user's own governance content |
| Tier definitions | What each tier obliges **in this document** |
| Rules | Grouped by family, each with id, text, Observable, tier |
| Candidates | Behaviours worth governing with no writable Observable today |
| Versioning policy | MAJOR / MINOR / PATCH, matching the precedent of the two constitutions |
| Sync Impact Report | Version, rationale, what was added |

### X rule

| Field | Constraint |
|---|---|
| `id` | `X<family>.<n>`, stable, never reused once retired |
| Rule text | Exactly one obligation, exactly one keyword |
| Observable | Applicable by hand today against an existing skill |
| Tier | `[auto]`, `[agent-checkable]`, or `[human-review]` |
| Sample basis | Whether it generalises from one skill or two |

### Candidate

A behaviour recorded but not admitted. Carries what it would govern and why no Observable can be
written yet. Has no id, because an id implies an obligation.

### Skill citation

A line in a skill's Outputs section naming the `X` ids that skill satisfies. Restates no rule text,
per `P7.3`.

## The layer boundary

The relationship that makes the document possible:

```text
        ┌──────────────────────────────┐
        │  Layer 1 — Skills Constitution│   governs: the SKILL.md text
        │  "a skill MUST require        │   P1.7: must ask when ambiguous
        │   clarification when ..."      │
        └───────────────┬───────────────┘
                        │ outranks
                        ▼
        ┌──────────────────────────────┐
        │  Layer 2 — Experience Standard │   governs: what the skill emits
        │  "when it asks, the request    │   X: the asking must name candidates
        │   MUST name the candidates"    │
        └──────────────────────────────┘

   P owns whether the behaviour must exist.
   X owns what the behaviour must look like.
```

Applied to the three near-collisions found in Phase 0:

| `P` rule owns | `X` may own |
|---|---|
| `P1.7` — that clarification is required | What a clarification request must contain |
| `P5.2` — that a failure names one of four next actions | What the message accompanying that action must name |
| `P4.6` — that a vulnerability is reported not altered | Nothing further; no existing skill exhibits more |

## Rule families

| Family | Governs | Admitted | Sample |
|---|---|---|---|
| X1 | Output structure — declared shape, field order, the form of an empty result | Yes | Two skills |
| X2 | Interaction — what a confirmation must state before an irreversible act | Yes | One skill |
| X3 | Terminology — one term per concept | **No, candidate** | — |
| X4 | Artifact placement — the declared write path | Yes | One skill |
| X5 | Provenance — a message names what its reader can act on | Yes | Two skills, via disagreement |
| X6 | Determinism — unchanged inputs produce an unchanged artifact | Yes | One skill |

## Validation rules

| # | Constraint | Source |
|---|---|---|
| V1 | No `X` id collides with a `P` or `D` id | FR-003 |
| V2 | No rule text restates a constitution rule | `D1.4`, FR-005 |
| V3 | Every rule has an Observable applicable today | FR-002, FR-011 |
| V4 | No rule is tagged `[auto]` in this phase | FR-014 |
| V5 | Every single-sample rule is marked | FR-010 |
| V6 | Every cited id exists in the standard | FR-017 |
| V7 | Both existing skills satisfy every admitted rule, or an exception is recorded | SC-004 |
| V8 | The document names no development-only path | `D1.1`, FR-007 |

## State transitions

A candidate becomes a rule when an Observable can be written for it. That is a MINOR amendment. The
reverse — a rule demoted to a candidate — breaks every skill citing it and is MAJOR, which is why
FR-011 keeps unobservable behaviours out in the first place.
