# Contract: Highway ADR Workflow

## Invocation

The canonical skill is invoked as `/highway-adr <DISC######>`. The invocation must contain exactly
one explicit uppercase Discovery identifier. No implicit newest-file or filesystem-order lookup is
allowed.

## Inputs

The workflow reads exactly one valid Discovery record and its catalog entry, then consumes optional
Request, Clarification, Profile, Objective, Control, and NFR evidence through their authoritative
contracts. Clarification input is limited to `CLAR-REQ######` and `CLAR-DISC######`; `CLAR-ADR######`
is post-generation and excluded.

## Decision contract

Only Discovery options may be recorded. Exactly one is selected. When acceptable options tie, use
Discovery recommendation, higher Discovery score, more recorded Reference Architecture matches,
then lower numeric `OPT` suffix. Every other Discovery option appears in Alternatives Considered.
If the selected option differs from the recommendation, render Recommendation Override immediately
after Decision with recommended option, selected option, and rationale.

Clarification guidance, open findings, and conflicts are advisory only. Resolved evidence may
contribute to rationale, context, constraints, alternatives, or consequences. Open findings may
contribute to assumptions, risks, and follow-up work; conflict guidance appears in Risks and
Decision Rationale. No Clarification artifact is changed.

## Output contract

Successful generation writes exactly one `adrs/ADRXXXXXX.md` with status `accepted` and exactly one
direct catalog entry in `adrs/adrs.md`. The ADR contains the complete required template sections,
Decision Confidence, explicit initial supersession fields, stable relationship ordering, and a
Reference Architecture Handoff. Every handoff field is a valid value or `None`; authorization is
for Reference Architecture work only and never implementation.

## Failure and determinism contract

Resolution, validation, duplicate detection, allocation, and rendering occur before commit. Any
failure preserves all existing bytes. Catalog allocation conflicts retry at most three times.
Discovery is the ADR uniqueness key, so an existing ADR for the same Discovery aborts without
changing the existing ADR or catalog. Identical source bytes and catalog state produce byte-
identical ADR content and ordering. Generated ADR content excludes timestamps, dates, environment
identifiers, random values, and session identifiers.

## Ownership contract

Discovery owns advisory analysis and source relationships. Clarification owns findings, responses,
status, and history. Governance workflows own their baselines. ADR owns selection, decision
authority, rationale, consequences, accepted status on creation, and the handoff. Future ADR
lifecycle workflows own status transitions and supersession updates.