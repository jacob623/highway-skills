# Data Model: Controls Alignment Recommendation

This feature adds no retained fields to Control records. The entities below describe transient interaction state and existing retained records only.

## Control Recommendation

A provisional safeguard suggestion presented for selection or discussion.

- **Fields**: title, concise description, grounding source, source kind (`context-derived` or `coverage-derived`), duplicate/coverage assessment.
- **Relationships**: may enter a Control Queue; may produce one Converged Control Proposal.
- **Validation**: must be grounded in accepted context or permitted declared expertise; coverage-derived suggestions supplement context-derived suggestions; unsupported generic suggestions are omitted.
- **Persistence**: transient; selection does not capture or persist a Control.

## Control Queue

The ordered set of selected recommendations awaiting one-at-a-time development.

- **Fields**: ordered recommendation references, active item, remaining items.
- **Relationships**: each item develops into a Converged Control Proposal or is removed/replaced before capture.
- **Validation**: queue order controls development order only; queue membership is not acceptance and does not allocate an identifier.
- **Persistence**: transient for the active interaction.

## Converged Control Proposal

The complete provisional candidate shown before capture.

- **Fields**: title, statement, synthesized rationale, correction/revision state, acceptance state.
- **Relationships**: created from a selected recommendation or user-authored safeguard; accepted proposal is passed to the Control owner for capture.
- **Validation**: must contain title, statement, and rationale when a responsible complete proposal can be formed; material revision requires another correction or acceptance opportunity.
- **State transitions**: proposed -> corrected/replaced/rejected or accepted; accepted -> capture requested; capture failure leaves the retained baseline unchanged.
- **Persistence**: transient until the owner performs capture.

## Accepted Control

The existing retained Control entity after the proposal crosses the acceptance boundary and the owner captures it.

- **Fields**: existing identifier, user-approved title, status, `nfrs`, statement, rationale, and optional recommendation grounding as governed by the existing template.
- **Relationships**: may relate to accepted NFR identifiers and existing relationship analysis.
- **Validation**: preserve existing classification, ownership, persistence, relationship, and Control-derived NFR rules.
- **Persistence**: `library/governance/controls/CTLXXXXXX.md` and `library/governance/controls.md` through the existing owner mutation path.

## Control Coverage Area

Internal recommendation-generation guidance for coverage evaluation.

- **Fields**: area name, example safeguards, current coverage signal, meaningful-gap signal.
- **Relationships**: influences additional Control Recommendations only.
- **Validation**: must not establish policy, obligation, deficiency, readiness, lifecycle, accepted Control state, or changes to ownership, persistence, classification, or acceptance.
- **Persistence**: transient guidance; never user-selectable or user-visible as a category.

The five areas are Identity & Access, Information Protection, Change & Operations, Resilience, and Monitoring & Accountability.

## Control Portfolio Assessment

An optional advisory synthesis after multiple Controls are accepted.

- **Fields**: concise observations about overlap, duplication, concentration, meaningful coverage, or meaningful gaps.
- **Relationships**: reads the accepted Control portfolio; may trigger additional recommendation evaluation.
- **Validation**: must not reject, block, mutate, or replace accepted Controls.
- **Persistence**: transient advisory output.

## Boundary Summary

```text
Recommendation -> Selection -> Queue -> Converged Proposal -> Acceptance -> Owner Capture -> Accepted Control
       |              |                                      |
       |              +-- no persistence                       +-- downstream NFR behavior remains existing
       +-- Coverage Areas may supplement, never replace, context grounding
```
