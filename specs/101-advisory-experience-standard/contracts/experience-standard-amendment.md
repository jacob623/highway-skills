# Contract: Experience Standard Amendment

Target file: `.highway/governance/experience-standard.md`

Version footer after the amendment: `3.0.0`, ratified date unchanged at 2026-09-08, last amended 2026-09-29. Prepend a sync impact report that lists every retired, redefined, and added identifier below, the removed sections, and the seven obligations moved to the Skills Constitution. Keep the existing reports.

The file must not contain `.specify/` or `specs/`. It must not name the development constitution as a runtime dependency. It must not cite, as a current obligation, a constitution rule removed by the 4.0.0 amendment.

A current rule row keeps the columns identifier, rule, observable, and tier. The tier is `[agent-checkable]`. The Sample column and the N/A token table leave. PASS, FAIL, and N/A review instructions leave. Applicability is written in the rule or the observable.

## Retired as current rows

X1.1, X1.2, X1.3, X1.4, X1.5, X4.1, and X6.1. Their obligations move to P9.2 through P9.8. These identifiers are not reused. A historical sync report may still name them.

Also remove, without assigning a replacement in this file: the Interactive Workflow UX Contract and its resume, owner-outcome, and ownership-display subsections.

## Redefined

The identifier stays. The row states the obligation below. X1.6 keeps its current rule sentence. X2.3's observable keeps the sentence "Every user-visible response excludes Implementation details unless requested." and also names identifiers, catalog mutations, generated versions, internal candidate state, and owner-result mechanics.

| ID | Obligation the row must state |
|---|---|
| X1.6 | A structured user-facing field visually distinguishes its presentation label from its value. |
| X2.1 | A confirmation before an irreversible loss states what is lost. |
| X2.2 | Accepted information, available evidence, or a grounded recommendation is used before a question. |
| X2.3 | Implementation details stay hidden unless the person requested them or needs them in order to act. |
| X2.4 | Only one unresolved response-demanding question is asked, and only for information still needed. |
| X2.5 | Progress appears only when remaining work is meaningful to the person. |
| X2.6 | Progress describes the activity rather than an internal stage, validation step, route, or implementation step. |
| X2.7 | A recommendation is grounded in context the owning workflow declares. |
| X2.8 | An acknowledgment appears only when new information changes the recommendation, interpretation, or next user-relevant action. |
| X2.9 | Decision Context explains why the answer matters to the person and is not a second question. |
| X2.10 | An example appears only when it makes the expected answer clearer, and it does not become a required category. |
| X5.1 | A message names something the person can act on. |
| X5.2 | A conflict with existing content names the existing item. |

X2.4's observable also excludes a question that is broader than necessary, already answered by accepted context, responsibly recommendable, ceremonial, or an internal schema, category, route, or stage. X2.7's observable uses accepted organizational or repository context before generic advice, allows an external source only when the owning workflow declares it, and does not present that source as applying, certifying, or setting policy unless that status is separately established. X2.8's observable excludes an acknowledgment-only turn and promotion of an unrelated capability. X2.9's observable is concise, does not explain internal processing, and is not repeated when the implication was just established. X2.10's observable prefers a few short examples specific to the current question.

## Added

| ID | Obligation the row must state |
|---|---|
| X1.7 | Setup presentation places one decision or question last, after framing, the main content, and any supporting rationale or example. |
| X2.11 | Accepted information that already answers the need is reused. |
| X2.12 | Authoritative organizational information is imported or validated when the workflow supports that, rather than recreated conversationally. |
| X2.13 | Grounded recommendations are offered before a question when context supports useful choices. |
| X2.14 | A question is not asked only to satisfy an internal workflow dimension. |
| X2.15 | Organization size, maturity, or operating model is not assigned from organization identity alone. |
| X2.16 | A recommendation set contains at most 5 distinct actionable choices. |
| X2.17 | A user-authored alternative stays available whenever recommendations are shown. |
| X2.18 | Selection of a displayed recommendation is acceptance, with no second confirmation. |
| X2.19 | A request for explanation, comparison, or more information is not acceptance. |
| X2.20 | Further recommendations stop when no useful grounded non-duplicate choice remains, the person is finished, or the person will provide their own information. |
| X2.21 | Material interpretation is reviewed under the heading "Here's what I've captured as your [category]:", with the proposal immediately below and one acceptance request at the bottom. |
| X2.22 | An explicit selection, a direct statement already in the requested category, or clearly presented imported information is captured without that review. |
| X2.23 | An accepted Profile organization name is used in contextual guidance where it improves clarity. |
| X2.24 | An organization name that has not been accepted is not invented. |
| X2.25 | Profile enrichment, Objectives, Controls, and Non-Functional Requirements share one recommendation pattern: a grounding line, a short numbered list of labeled choices, and one closing choice. Domain wording may replace the generic nouns. |
| X2.26 | Recommendation rationale appears only when it helps the person decide. |
| X2.27 | An orchestrator introduces a new domain with one short outcome-oriented transition and does not repeat the owner's opening. |
| X2.28 | A visible move into a new setup domain is separated with a horizontal rule. |
| X2.29 | Discovered or extracted information stays proposed until the user-acceptance boundary is satisfied. |
| X2.30 | Evidence that cannot be recommended or inferred stays unknown. |
| X2.31 | Optional enrichment does not block continuation unless the owning domain requires it for validity. |

X2.20's observable names duplicates, marginal variations, the person finishing, and the person choosing to author the information. X2.21 does not place a Next Action instruction above the proposal and does not ask for confirmation elsewhere in the same response. X2.25 does not require identical wording when domain phrasing is clearer. X2.27 does not preview internal downstream mechanics and does not claim recommendations may exist when the receiving workflow can present them.

## Model and non-goals

Replace the long contract with one short ordered model:

1. Understand available accepted context.
2. Reuse existing information when it satisfies the need.
3. Discover or import existing authoritative information when the organization already has it.
4. Offer grounded recommendations when Highway can responsibly help.
5. Accept selected recommendations directly.
6. Ask one clear question only when information remains unresolved.
7. Present the inferred-content heading only when Highway materially inferred or transformed the input.
8. Put that review's acceptance request at the bottom.
9. Capture accepted information.
10. Offer additional grounded recommendations or let the person continue.
11. Stop when the person is satisfied or no useful recommendations remain.

The model does not restate the rule rows. Definitions remain only where a remaining rule needs them. The non-goal stays: this standard governs Highway's presentation and interaction, and it does not govern the person's strategy, policy, requirements, priorities, or preferred wording. Recommendations stay proposals until accepted. User-owned content is not rejected because Highway would word it differently.

The standard cites Highway identity and platform objectives for the informed-advisor direction and does not restate those documents.

## Out of this contract

The constitution rows are in [constitution-output-relocation.md](./constitution-output-relocation.md). Tests and live citations that name this contract's removed section or retired identifiers are updated with it. Shared templates and the development constitution are not modified. Skill domain workflows are not rewritten.
