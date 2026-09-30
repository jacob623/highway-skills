# Data Model: Simplify the Objectives Skill

## Business Objective

What the organization wants to accomplish.

**Retained as**: Statement, under the existing Objective record.

**Discovery**: Evaluated with Success and Highway Relevance before another question is chosen.

## Success

How the organization will know the Objective succeeded.

**Retained as**: Success Measures.

**Missing-evidence question**: `**How would you measure success in [stated objective]?**`

## Highway Relevance

Context Highway needs to connect the Objective to technology, governance, architecture, implementation, automation, or operations.

**Retained as**: Nothing. This is not a record field.

**Asked when**: Accepted Profile evidence and the active Objective evidence do not already establish useful downstream relevance.

**Question when an Organization Name is accepted**: `**What role should technology play in helping [Organization Name] achieve this objective?**`

**Name fallback**: An accepted Repository Name is used where it reads naturally. When neither name is accepted, the question inserts no name.

## Rationale

The retained explanation of the Objective.

**Shown in review as**: `**Why it matters:**`

**Filled from**: Accepted user evidence, accepted Profile evidence, or material interpretation. It is not collected by asking why the Objective is meaningful.

## Objective recommendation

A proposed Objective grounded in accepted Profile evidence.

**Selection**: One, several, or all displayed recommendations are accepted and captured directly. The captured-content review is not used.

**Multi-selection during setup or configure**: Every selected Objective is captured, then the continuation question is asked once.

**Multi-selection during add or new**: Every selected Objective is captured, then the operation ends.

**Unavailable grounding**: No recommendation is invented. The broad opening is asked.

## Captured-content review

Used only when Highway materially interprets or synthesizes user-authored input.

**Content**: `Here's what I've captured as your objective:`, the title, the Statement, `**Success looks like:**`, each Success Measure, `**Why it matters:**`, the Rationale, and `**Does this objective look right?**`

## Continuation

The setup and configure question `**Is there another objective you'd like to capture?**`

| Reply | Next step |
|---|---|
| Another Objective | Process it immediately |
| Yes, without an Objective | Ask `**What's another important outcome you'd like to achieve?**` |
| Suggestion request | Present grounded recommendations |
| Explicit finish | End collection and return the terminal owner result |
| Anything else | Ask the continuation question again |

Readiness becoming Complete does not end setup or configure.

## Readiness result

| Condition | Status | Next Action | Blocking Reason |
|---|---|---|---|
| No valid Objective | Missing | `/highway-objectives setup` | None |
| At least one valid Objective with consistent catalog and allocation state | Complete | None | None |
| Malformed record, catalog, or allocation state | Blocked | None | The blocking reason |

Collection completion is separate from this result.

## Context sources

| Source | Role |
|---|---|
| Accepted Profile | Primary organizational grounding for recommendations. Uses Identity, Vision, Competitive Path, Guiding Principles, and optional accepted context. |
| Existing Objectives | Duplicate and overlap detection. Not a source of new organizational facts. |
| Identity | Highway behavioral framing only. |
| Highway Vision | Highway strategic framing only. |
| Highway Platform Objectives | Highway evaluation framing only. |

A Blocked Profile stops Objective behavior that depends on accepted Profile evidence. It does not, by itself, block a user-authored Objective that does not need that evidence.
