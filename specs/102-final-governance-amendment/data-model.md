# Data Model: Final Governance Amendment

## Skills Constitution

Runtime authority for what a skill file must contain.

| Field | After this amendment |
|---|---|
| Version | 5.0.0 |
| Ratified | 2026-09-06 |
| Last amended | 2026-09-29 |
| Change class | Major |
| Redefined row | P7.6 |
| Unchanged size limits | P7.4, P7.5 |
| Unchanged anti-bloat rule | P7.3 |
| Row shape | Identifier, rule, observable, tier |
| Tier of P7.6 | `[agent-checkable]` |
| History | The new report is prepended. Older reports remain. |
| Precedence | Unchanged |

## Experience Standard

Runtime authority for what a person sees.

| Field | After this amendment |
|---|---|
| Version | 4.0.0 |
| Ratified | 2026-09-08 |
| Last amended | 2026-09-29 |
| Change class | Major |
| Redefined rows | X2.9, X2.25 |
| Unchanged neighbors | X2.16 through X2.22, X2.27 through X2.31, and every other current row |
| Row shape | Identifier, rule, observable, tier |
| Tier of current rows | `[agent-checkable]` |
| History | Exactly one sync impact report, for 3.0.0 to 4.0.0 |

## Decision Context

The concise reason a requested answer matters to the person.

| Field | Rule |
|---|---|
| Label | `**Why it matters:**` |
| When shown | Only when Decision Context is needed |
| Order | Label, concise user-relevant explanation, one unresolved question |
| Excluded | Implementation explanation, a second question, and a repeat of an implication just established |

## Shared recommendation model

The common meaning of a recommendation set for Profile enrichment, Objectives, Controls, and Non-Functional Requirements.

| Field | Rule |
|---|---|
| Grounding | Concise, from context the owning workflow declares |
| Choices | One or more distinct actionable recommendations, and at most five in one set |
| Selection | A clear path. Selecting a shown recommendation is acceptance under X2.18 |
| Alternative | The person can supply their own information |
| Presentation | One recommendation, bullets, numbering, or another concise domain presentation |
| Layout | Not prescribed. Non-normative guidance demonstrates the meaning only |

## Authoring citation

Live guidance that names the size remedy.

| Field | After this amendment |
|---|---|
| File | `.highway/skills/_authoring-standard.md` |
| Remedy | Reduce the same skill until both limits hold |
| Cited identifiers | P7.4, P7.5, P7.6 |
| Excluded | The P7.6 rule sentence, and any requirement to create additional skills |
