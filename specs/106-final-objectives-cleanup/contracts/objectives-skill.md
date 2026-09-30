# Contract: highway-objectives cleanup

**Source**: `.highway/skills/highway-objectives/SKILL.md`

**Version**: 3.0.0.

## Profile result wording

The skill states:

`A Profile-owned Blocked result blocks Objective behavior that depends on accepted Profile evidence.`

Unavailable Profile remains distinct from Profile-owned Blocked. The Profile context description uses recommendations, Highway Relevance, and Rationale.

## Discovery and review readiness

Discovery dimensions are Business Objective, Success, and Highway Relevance. Outcome and Significance are not discovery dimensions.

Action selection and direct invocation use Business Objective evidence. Pre-write overlap revalidation uses Business Objective, Success, and Highway Relevance.

When Business Objective supports a Statement and Success supports at least one Success Measure, present the Objective review. Ask Highway Relevance only when unresolved information would improve downstream Highway use. Highway Relevance does not independently block creation.

## Rationale

Rationale is synthesized from accepted Business Objective, Success, Highway Relevance, and applicable accepted Profile evidence. It does not use Highway Identity, Highway Vision, or Highway Platform Objectives as organizational facts. A concise supported rationale is used without another question.

`Why it matters` presents the synthesized Rationale and is not a fourth discovery dimension.

## User-authored review

Materially interpreted user-authored Objectives use exactly:

`**Here's what I've captured as your objective:**`

`[Objective Title]`

`[Statement]`

`**Success looks like:**`

`- [Success Measure]`

`**Why it matters:**`

`[Rationale]`

`**Does this objective look right?**`

The malformed `**Why it matters:**[` form is absent.

## Recommendation-created Objectives

Selected recommendations create Statement, Success Measures, and Rationale only from the recommendation and its grounding evidence. Selection does not receive redundant confirmation or a separate Rationale question. If required Success evidence is missing, ask only for unresolved Success information. The user-authored alternative remains available.

## Retained record

`.highway/library/templates/output/objective-record.md` remains unchanged. It continues to own Statement, Success Measures, and Rationale. Highway Relevance is not persisted.
