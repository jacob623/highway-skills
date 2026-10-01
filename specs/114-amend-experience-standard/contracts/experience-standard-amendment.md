# Contract: Experience Standard 5.0.0

**Source**: `.highway/governance/experience-standard.md`

**Supersedes**: Experience Standard 4.0.0 question-before-rationale reversal, entry-only recommendation evaluation, and the 4.0.0 sync report.

The shipped file must not contain `.specify/` or `specs/`.

## Sync Impact Report

The opening comment contains only this amendment's report.

```text
Sync Impact Report
Version change: 4.0.0 → 5.0.0 (MAJOR), 2026-10-01
Bump rationale: X1.7, X2.9, and X2.13 are redefined, and previously conforming presentation can now fail. Redefining a rule is MAJOR. Strengthening an obligation so previously conforming work fails is MAJOR.
Changed elements:
- Version footer: 4.0.0 → 5.0.0. Ratified stays 2026-09-08. Last Amended becomes 2026-10-01.
- Redefined rule rows: X1.7 and X2.9. X2.13 and X2.25 keep their rule sentences; their observables change.
- Added rule rows: X2.32, X2.33, X2.34, and X2.35. Rule count: 35 → 39.
- Interaction model, contextual guidance, and non-normative examples match the redefined presentation.
- Prior sync impact reports are removed from this document. Repository history keeps them.
Unchanged elements: X2.3, X2.7, X2.16, X2.17, X2.18, X2.19, X2.20, X2.21, X2.22, X2.27, X2.28, X2.29, X2.30, X2.31, and every other current rule not named above.
Self-application review: this amendment cites the Skills Constitution for non-restatement and does not copy a constitution rule sentence.
```

The token `3.0.0 → 4.0.0 (MAJOR)` is absent. The token `Sync Impact Report` appears once.

Footer:

```text
**Version**: 5.0.0 | **Ratified**: 2026-09-08 | **Last Amended**: 2026-10-01
```

## Replaced rows

| ID | Rule | Observable | Tier |
|---|---|---|---|
| X1.7 | Setup presentation MUST keep one response-demanding question or decision in the final interaction block. | The final interaction block contains one response-demanding question or decision; Decision Context governed by X2.9 may follow that question. | [agent-checkable] |
| X2.9 | Decision Context MUST follow the question it explains under the label "**Why it matters:**". | When Decision Context applies, one unresolved question appears first, followed by the literal label **Why it matters:** and one concise user-relevant explanation. No second question, implementation explanation, or repeated rationale appears. | [agent-checkable] |

The former X1.7 sentence `Setup presentation MUST place one decision or question last, after framing, the main content, and any supporting rationale or example.` is absent.

The former X2.9 sentence `Decision Context MUST use the label "**Why it matters:**" and explain why the answer matters to the person without asking a second question.` is absent.

The former X2.9 observable order, label then explanation then question, is absent.

## Observable-only rows

X2.13 rule sentence stays:

`Grounded recommendations MUST be offered before a question when context supports useful choices.`

X2.13 observable becomes:

`Before each unresolved guided-collection question, the workflow evaluates accumulated accepted context; a useful grounded choice is shown instead of the question.`

X2.25 rule sentence stays:

`Profile enrichment, Objectives, Controls, and Non-Functional Requirements MUST use the shared recommendation interaction model.`

X2.25 observable becomes:

`The set shows concise grounding tied to what Highway already knows, one or more distinct actionable recommendations, a choice prompt appropriate to that number, and a user-authored alternative. Selecting a shown recommendation follows X2.18. Numbering is permitted and is not required.`

## Added rows

Insert after X2.31 in the X2 table.

| ID | Rule | Observable | Tier |
|---|---|---|---|
| X2.32 | Recommendation choice wording MUST match the number of recommendations shown. | One recommendation uses singular accept/change/alternative wording; multiple recommendations permit one, several, all, or a user-authored alternative. | [agent-checkable] |
| X2.33 | A completed guided Setup domain MUST close with one concise synthesis when accepted context from that domain can be meaningfully summarized. | Before the orchestrator enters the next active domain, the owner emits at most one concise user-relevant synthesis of what Highway learned or established; it contains no machine status, owner result, implementation detail, or new question. | [agent-checkable] |
| X2.34 | Machine-consumable owner results MUST NOT appear in normal orchestrated user-visible output. | Readiness, mutation, action, and collection result fields consumed only for orchestration are absent unless the person requested them or needs them to act. | [agent-checkable] |
| X2.35 | A delegated guided interaction MUST NOT expose a machine result after its final user-facing acknowledgment or question. | After the user's final guided decision, only user-relevant closure, synthesis, or the orchestrator's next-domain transition is visible. | [agent-checkable] |

## Explanatory prose

After the X2 table, keep the existing X2.1 paragraph. Add prose that names Status, Summary, Next Action, Blocking Reason, Action Status, Collection Result, and mutation-result fields used only by an orchestrator. The prose states that those results may still be returned to the orchestrator, and that a direct readiness, status, inspection, or mutation request may still show its requested result. The prose does not add a rule identifier.

## Interaction model

Replace the numbered list with this sequence. Keep the sentence that the rules are the obligations and the list does not restate them.

1. Understand available accepted context.
2. Reuse existing information when it satisfies the need.
3. Discover or import existing authoritative information when supported.
4. Accept or validate discovered information at the applicable boundary.
5. Re-evaluate accumulated accepted context for grounded recommendations.
6. Offer grounded recommendations when Highway can responsibly help.
7. Ask one clear question only when useful grounded recommendations do not resolve the need.
8. Capture accepted information.
9. Re-evaluate accumulated accepted context before the next guided question.
10. Continue until the person is satisfied or no required work remains.

X2.21 and X2.22 remain the captured-content review rules. Do not move that review ahead of its acceptance request.

## Contextual Guidance

Add these non-normative sentences:

`Accepted information compounds during a guided interaction. Each accepted answer, selection, or validated discovery can expand the grounding available to the next recommendation.`

`A workflow should become more specific as accepted context accumulates rather than return to generic questioning.`

Do not assign them rule identifiers.

## Non-normative examples

Context Awareness contrast:

| Generic | Context-aware |
|---|---|
| What is your vision? | Based on what you've shared about growing your community, here are a few ways that future could take shape. |

The repository-structure pair is removed. The contrast stays explicitly non-normative.

Interaction Examples gain these rows and stay explicitly non-normative:

| Scenario | Non-compliant | Compliant |
|---|---|---|
| Decision Context | `**Why it matters:**` before `**What would success look like?**` | `**What would success look like?**` before `**Why it matters:**` and one concise explanation |
| Owner result | `Status: Complete`, `Summary: One Objective has been captured.`, and `Next Action: None` | `I've captured that objective. We can build on it in the next part of Setup.` |

Recommendation sketch: keep two distinct choices. Replace `Select any of these, or write your own.` with an invitation that permits one, several, all, or something different. That invitation is illustrative, not a required runtime sentence. The string `Select any of these` is absent.

## Preserved text

These sentences remain present and unchanged:

- `Every user-visible response excludes Implementation details unless requested.`
- `Here's what I've captured as your [category]:`
- `A recommendation set MUST contain at most 5 distinct actionable choices.`
- The X2.21 row, including one acceptance request at the bottom.
- The X2.27 and X2.28 rows.
