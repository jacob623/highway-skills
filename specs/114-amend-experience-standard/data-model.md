# Data Model: Amend Experience Standard

## Experience Standard

The shipped interaction authority at `.highway/governance/experience-standard.md`.

| Field | Rule |
|---|---|
| Version | `5.0.0` |
| Ratified | `2026-09-08`, unchanged |
| Last Amended | `2026-10-01` |
| Classification | Major, because X1.7, X2.9, and X2.13 no longer accept 4.0.0 presentation |
| Sync Impact Report | Exactly one current report. The 4.0.0 report is replaced. |
| Rule count | 35 before, 39 after |
| Shipped references | Must not contain `.specify/` or `specs/` |

**Relationships**: Owns rule rows, the interaction model, contextual guidance, and non-normative examples. Does not own skill files, output templates, or repository review checks.

## Rule row

| Field | Rule |
|---|---|
| ID | Stable. X1.7, X2.9, and X2.13 stay. New IDs are only X2.32, X2.33, X2.34, and X2.35. |
| Rule | One obligation. X2.13 and X2.25 sentences stay. X1.7 and X2.9 sentences are replaced. |
| Observable | The reviewer-visible condition. Replaced for X1.7, X2.9, X2.13, and X2.25. |
| Tier | `[agent-checkable]` for every added or redefined row in this amendment. |

**Preserved rows**: X2.3, X2.7, X2.16, X2.17, X2.18, X2.19, X2.20, X2.21, X2.22, X2.27, X2.28, X2.29, X2.30, and X2.31 stay byte-stable.

**Transition**: A row moves from the 4.0.0 contract to the 5.0.0 contract. No row is valid under both contracts when its wording changed.

## Decision Context presentation

Shown only when Decision Context applies.

| Order | Content |
|---|---|
| 1 | One unresolved question |
| 2 | Literal label `**Why it matters:**` |
| 3 | One concise user-relevant explanation |

The label is absent when Decision Context is not needed, including when the relevance was just established. Captured-content review does not use this order. Its proposal stays first and its one acceptance request stays last.

Setup's final interaction block contains one response-demanding question or decision. Decision Context may follow that question.

## Recommendation set

| Field | Rule |
|---|---|
| Grounding | Tied to what Highway already knows, including newly accepted discovery |
| Count | One or more, at most five. Do not pad one into several, and do not collapse several useful alternatives into one. |
| Choice wording | Singular accept, change, or alternative wording for one. One, several, all, or a user-authored alternative for several. |
| Acceptance | Selecting a shown recommendation follows X2.18. Explanation is not acceptance. |
| Evaluation point | Before each unresolved guided-collection question, not only at workflow entry. |

Accepted discovered or imported information becomes grounding immediately. It does not have a separate website state.

## Domain completion synthesis

Optional closing statement for one completed guided Setup domain.

| Field | Rule |
|---|---|
| Count | One when accepted context can be meaningfully summarized. Zero otherwise. |
| Position | Before the orchestrator enters the next active domain and before the X2.28 horizontal rule. |
| Content | What Highway learned or established. No machine status, owner result, implementation detail, or new question. |
| Confirmation | Not a second acceptance step. The orchestrator does not repeat it. |

## Machine-consumable owner result

A readiness, mutation, action, or collection result used to orchestrate work.

| Field | Rule |
|---|---|
| Examples | Status, Summary, Next Action, Blocking Reason, Action Status, Collection Result, and orchestrator-only mutation results |
| Normal output | Absent unless the person requested the result or needs it to act |
| Orchestrator | May still receive the result |
| Direct request | May show the declared user-facing result |
| After final guided decision | Only user-relevant closure, synthesis, or the next-domain transition is visible |

## Repository review check

A development assertion of Experience Standard behavior, version, inventory, or amendment text.

| Field | Rule |
|---|---|
| In scope | A check that encodes changed Experience Standard behavior or asserts Experience Standard version 4.0.0 |
| Out of scope | A skill version, a skill-contract assertion, a profile schema fixture, and Skills Constitution history |
| Passing baseline | The 5.0.0 contract. The superseded X1.7, X2.9, and X2.13 wording is not also accepted. |
| Runtime | Not required to use a shipped skill, and not referenced by the Experience Standard |

**State**: A check either requires the superseded contract, or requires the amended contract. This feature ends with the second state for every in-scope check.
