# Clarification Status Consumption Contract

## Purpose

Define how `highway-discovery` consumes a validated Clarification artifact after Feature 069
catalog resolution. This contract is advisory-only and does not change Discovery output schema,
scoring, recommendation logic, Clarification ownership, or ADR ownership.

## Status Consumption Rules

Clarification status influences advisory analysis only.

- `not-started`: no Clarification evidence is available; Discovery proceeds normally.
- `in-progress`: open findings may contribute to Assumptions, Unknowns, Risks, and confidence rationale; responses may contribute to Research Findings.
- `complete`: responses may contribute to Research Findings; no open-finding uncertainty is introduced.
- `blocked`: Discovery may record advisory risk evidence when appropriate; Discovery continues normally and blocked status does not prevent analysis, recommendation generation, or ADR handoff.

Status MUST NOT affect candidate generation, candidate filtering, candidate scores, candidate ordering,
recommendation selection, or ADR ownership.

## Evidence Precedence

Request evidence remains authoritative.

Clarification responses may supplement, explain, or clarify Request evidence. They MUST NOT overwrite,
replace, or modify Request evidence. When Request evidence and Clarification responses disagree, Request
evidence remains authoritative, disagreement contributes advisory risk evidence, and Discovery does not
modify the Request.

## Finding Consumption Rules

Open findings may contribute to Assumptions, Unknowns, Risks, and confidence rationale. Resolved findings
may contribute to Research Findings through accepted responses and do not contribute uncertainty,
Unknowns, or unresolved-risk evidence. Finding state does not affect candidate generation, scoring,
ranking, recommendation totals, or recommendation selection.

## Validity and Fallback

Unreadable, malformed, path-mismatched, state-invalid, or count-invalid Clarification artifacts are
unavailable to Discovery as a whole. Discovery preserves all bytes, continues normally, and may record
advisory risk evidence without mutating Clarification.

## Determinism

For identical Request, Clarification, Profile, Objective, Control, NFR, Reference Architecture, and
Reference Implementation inputs, Clarification resolution, Research Findings, Assumptions, Risks,
Unknowns, confidence rationale, candidate evaluation, recommendation totals, recommendation selection,
and ADR ownership are identical.

## Verification

- Confirm status affects advisory analysis only.
- Confirm status never affects candidate generation, scores, or recommendation selection.
- Confirm Request evidence remains authoritative when responses disagree.
- Confirm responses supplement but do not replace Request evidence.
- Confirm open findings contribute advisory uncertainty only.
- Confirm resolved findings contribute accepted-response evidence only.
- Confirm blocked status does not block Discovery execution.
- Confirm invalid records are ignored without Clarification mutation.
- Confirm repeated identical inputs produce identical outputs.
