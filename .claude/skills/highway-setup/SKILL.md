---
name: highway-setup
description: "Orchestrates initial Highway setup through the owning governance skills."
usage: "Invoke as `/highway-setup` to assess readiness and complete missing foundational setup in order."
compatibility: all
metadata:
  version: 4.0.0
---

## highway-setup

## Purpose

Routes setup through Profile, Objectives, Controls, and NFR owners while preserving owner boundaries; orchestration only.

## When to use

Use this skill to assess readiness, continue initial setup, or resume at the first incomplete owner.

## When not to use

Do not use this skill to directly create, update, remove, replace, or repair an owner artifact.

## Inputs

- Project root found by locating `.highway/`.
- `/highway-profile readiness` and its four-line response contract.
- `/highway-objectives readiness`, `/highway-controls readiness`, and `/highway-nfrs readiness`.
- Owner-provided next questions, summaries, next actions, and blocking reasons.

## Outputs

When input is required, emit a welcome or resume greeting, the active owner introduction, and exactly
one owner question. Preserve owner output and ordering. On completion emit the existing Highway Setup
completion dashboard. On blocked, declined, aborted, or explicit status requests emit actionable owner
context without fabricating completion.

## Workflow

1. Locate `.highway/`; stop if it cannot be found.
2. Request Profile readiness from `/highway-profile readiness`.
3. If Profile is not `Complete`, enter Profile Guided Setup and forward one response at a time.
4. After Profile terminal success, request Objectives readiness.
5. After Objectives terminal success, request Controls readiness.
6. After Controls terminal success, request NFR readiness.
7. Advance only on `Complete`; NFR `Not Applicable` is also terminal success.
8. Stop at the first non-terminal or malformed owner response and present its owner-provided next action or blocking reason.
9. On a new invocation, re-read persisted readiness and resume at the first incomplete owner. Never restore an unanswered question, draft response, cancellation marker, or Setup checkpoint.
10. Emit `Highway Setup Complete` only after all required owners return terminal success.

## Profile routing

- **No authoritative Profile**: invoke Profile Setup, which starts with Identity's canonical question and keeps collection transient until acceptance.
- **Valid incomplete Profile**: invoke Profile Setup/Configure at the first `not_discussed` domain using accepted evidence.
- **Valid Complete Profile**: skip Profile collection and request Objectives readiness.
- **Malformed Profile**: report Blocked and do not overwrite it.

Setup consumes the Profile owner's readiness contract and does not inspect Profile metadata, recompute
five-domain readiness, or use the retired identity field. It does not recompute owner readiness or
does not write owner artifacts. It owns ordered routing, continuation, status, and the dashboard only. Profile owns
organizational evidence, domain outcomes, readiness, and its artifact.

## Guided Setup interaction contract

During routine collection, do not expose readiness evaluation, owner selection, forwarding, routing,
artifact inspection, or implementation details. Use one unresolved owner question at a time. User Exits
are `pause`, `cancel`, and `stop responding`; Owner Outcomes are `declined`, `aborted`, and `blocked`.
never restore an unanswered question. Neither category advances Setup or creates persisted wizard state.

## Verification

- Confirm Profile readiness is consumed verbatim and Setup never recomputes it.
- Confirm Setup advances Profile -> Objectives -> Controls -> NFRs only after terminal owner results.
- Confirm Complete Profile advances to Objectives and no Profile artifact is written by Setup.
- Confirm interruption preserves owner artifacts and creates no Setup checkpoint.
- Confirm malformed and unknown owner responses produce Blocked without invoking later owners.
- Confirm owner mutations originate from the owning workflow.

## Error Handling

- If `.highway/` cannot be located, abort and request the project root.
- If an owner response is malformed or unknown, abort with Blocked and do not invoke later owners.
- If an owner declines, aborts, or remains incomplete, abort Setup and preserve owner bytes.

## Example

`/highway-setup`
