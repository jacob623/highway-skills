# Contract: Highway Experience Standard

**Feature**: 017-experience-standard | **Date**: 2026-09-08

The interface this feature exposes is a document a skill author reads and a skill cites. This is
the contract that document must meet.

## Document contract

`.highway/governance/experience-standard.md` MUST contain, in this order:

| # | Section | Contract |
|---|---|---|
| 1 | Sync Impact Report | Version, ratification date, what was added and why |
| 2 | Scope | What the document governs; the layer it occupies |
| 3 | Non-goals | Explicitly: governs form of generated content only; states no obligation about a user's own governance artifact content |
| 4 | Precedence | Skills Constitution outranks this document; security-affecting rules outrank everything |
| 5 | Tier definitions | What `[auto]`, `[agent-checkable]`, `[human-review]` oblige **in this document** |
| 6 | Rules | Grouped by family; each row: id, rule, Observable, tier |
| 7 | Candidates | Behaviours considered and not admitted, each with the reason |
| 8 | Versioning policy | MAJOR / MINOR / PATCH |

## Rule row contract

Every rule row MUST satisfy all of:

| ID | Requirement |
|---|---|
| R1 | An id matching `X<family>.<n>`, unique, in a family declared in section 6 |
| R2 | Exactly one keyword — `MUST` or `MUST NOT` — in the rule text |
| R3 | Exactly one obligation; no second obligation joined by "and" or "or" |
| R4 | An Observable a reader can apply by hand today, naming a checkable property |
| R5 | Exactly one tier tag |
| R6 | No sentence that restates rule text from either constitution |
| R7 | A marker where the rule generalises from a single skill |

## Prohibited content

Stated so the boundary is checkable rather than remembered:

- **No development-only path.** The document ships (`D1.1`).
- **No relative link target.** It is copied into agent trees alongside skills that cite it.
- **No restatement of `P1.7`, `P5.2`, or `P4.6`.** Phase 0 identified these as the three nearest
  collisions. A rule requiring a skill to *ask when ambiguous*, to *abort rather than proceed*, or
  to *report rather than silently alter* is already owned by Layer 1.
- **No `[auto]` tier.** No check exists until Phase 6.
- **No obligation about the content of a user's governance artifact.** Only its form.

## Citation contract

Each skill's Outputs section MUST:

| ID | Requirement |
|---|---|
| C1 | Name the `X` ids that skill satisfies |
| C2 | Restate no rule text (`P7.3`) |
| C3 | Cite only ids that exist in the standard |
| C4 | Claim only rules the skill actually satisfies |

Each edited skill MUST carry a version increment, and the catalog and all adapters MUST be
regenerated in the same change (`D4.7`).

## Acceptance

The contract is met when all of the following hold. Each is checkable by hand.

| # | Check | How |
|---|---|---|
| A1 | Every rule has id, one keyword, an Observable, and a tier | Read the rule table |
| A2 | No `X` id collides with a `P` or `D` id | Namespace is distinct by construction; confirm no literal collision |
| A3 | No rule restates a constitution rule | Compare each rule text against the `P` and `D` inventories |
| A4 | Both skills satisfy every admitted rule | Walk each rule against each skill |
| A5 | Every single-sample rule is marked | Read the sample column |
| A6 | Every cited id resolves | Grep each cited id in the standard |
| A7 | The document names no development path | `shipped-tree-independence.test.sh` passes |
| A8 | The suite passes and artifacts are current | `run-all.sh`, including `adapter-coverage.test.sh` |

## Anti-guarantees

- **No rule is enforced by a script.** Phase 6 does that. Until then every rule is decided by a
  reader, and the tier tags say so.
- **The standard does not describe every behaviour the skills exhibit.** Only those with a writable
  Observable. The rest are candidates.
- **It states nothing about performance or cost.** `highway-help` declares `O(n)`; that is one
  skill and no check, so it is a candidate.

## The failure this contract exists to prevent

A standard that reads well, restates `P1.7` in different words, tags six rules `[auto]` that
nothing checks, and generalises from one skill without saying so. Each of those has a precedent in
this repository: the restatement risk is live, the false `[auto]` tier took features 013 and 014 to
remove, and the single-sample problem is why the Gate existed at all.
