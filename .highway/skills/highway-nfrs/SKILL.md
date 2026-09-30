---
name: highway-nfrs
description: "Manages the repository-wide Non-Functional Requirement baseline; use it to add, update, remove, replace, or inspect NFRs."
usage: "Invoke as `/highway-nfrs` and state the NFR baseline change in plain language."
compatibility: all
metadata:
  version: 11.0.0
---

# highway-nfrs

## Purpose

Maintains the repository-wide Non-Functional Requirement baseline as user-owned records.

## Experience

User-visible interaction follows the Highway Experience Standard.

## When to use

Use this skill to add, update, remove, replace, inspect, or assess the repository-wide NFR baseline.
Use `setup` or `configure` to collect NFRs until the user explicitly finishes. Direct `add` is a
single-NFR operation. Use `readiness` for a read-only owner assessment.

## When not to use

Do not use this skill for a specific enforceable, auditable, or checkable safeguard; route it to
`/highway-controls`. Do not edit records or generated catalogs directly.

## Inputs

Load the authoritative baseline and relevant accepted context before acting:

- accepted Profile, Business Objectives, and Controls;
- existing NFR records and catalog;
- Highway Identity, Vision, and Platform Objectives only for their declared framing roles;
- NFR-owned durable Control-derived candidate state;
- the Controls candidate-generation input/result contract;
- relationship impact analysis for destructive mutations.

Active user evidence is authoritative under the Constitution. Do not duplicate Constitution
precedence or generic missing-context and interaction rules here. A Control-derived NFR is grounded
by its originating immutable `CTLXXXXXX` relationship. Additional recommendations may use accepted
Profile, Objectives, Controls, and existing NFRs. Do not infer benchmark applicability from a Control
or create external applicability, certification, compliance, or policy claims.

## Ownership boundary

Controls owns deterministic initial derivation, the originating Control identifier, and invoking
candidate generation once after a successfully created new Control. NFRs owns candidate state,
classification, ordered review, NFR records and identifiers, the catalog, Control relationships,
readiness, and collection completion. This skill consumes only the declared candidate-generation
input/result contract and does not duplicate Controls derivation rules. It does not depend on
transient Controls collection identifiers or post-write verification state.

## Durable candidate state

`.highway/catalog/nfr-candidate-state.md` is the single authoritative schema for NFR-owned recovery
state. It preserves the originating Control, ordered candidate content, candidate decisions, pending
review, and readiness. Generation is exactly once per successfully created `CTLXXXXXX`; zero valid
candidates are a successful empty result. Persist each decision before advancing and resume from the
first unresolved candidate without restoring prompts or conversation state. The schema defines
`Generation Attempt`, `Candidate Entries`, and `Review Status`; this skill references those fields
without redefining their record shape.

When unresolved Control-derived candidates exist, present them before broad discovery. A user may
accept, modify, replace, reject, or skip a candidate, and an explicitly presented recommendation is
accepted without a redundant proposal-confirmation cycle. If candidate generation is blocked, keep
the successfully created Control, create no partial NFR relationship, and consume the owner result;
the blocked result includes a non-empty reason. A valid zero candidates result is successful and
does not create a relationship.

## Discovery and recommendations

After pending Control-derived candidates are resolved, offer small grounded NFR recommendation sets
when useful context supports them and keep the user-authored alternative available. Do not begin
broad discovery while pending candidates exist. If no useful grounded recommendations exist, ask:

**Are there any qualities or operational expectations you'd like future solutions to meet?**

Use concise examples such as availability, performance, recoverability, scalability, maintainability,
or operability only when they improve clarity. Do not require the user to ask for suggestions first,
and do not generate generic recommendations merely to keep a loop active.

Treat a direct NFR statement as direct capture when no material transformation is needed. For a
materially interpreted, classified, normalized, or synthesized user-authored NFR, use:

**Here's what I've captured as your NFR:**

**Title:**  
[Title]

**Statement:**  
[Statement]

**Why it matters:**  
[Rationale]

**Would you like to accept this NFR?**

Synthesize Rationale from accepted evidence and grounding; do not ask a separate rationale question.
Do not review a selected Highway recommendation a second time. If classification remains ambiguous
after evaluating evidence, ask one bounded question distinguishing a desired quality or operational
outcome (NFR) from an enforceable, auditable, or checkable safeguard (Control). Classification is
transient and does not become a persisted field.

The catalog at `library/governance/nfrs.md` and records at
`library/governance/nfrs/NFRXXXXXX.md` are user-owned. Their structure is governed by
`.highway/library/templates/output/nfr-record.md` and `.highway/library/templates/output/nfr-catalog.md`.

## Outputs

NFR readiness is owner-controlled and separate from collection completion:

```text
Status: Complete|In Progress|Blocked|Not Applicable
Summary: <NFR readiness explanation>
Next Action: <owner route or None>
Blocking Reason: <reason or None>
```

- `Not Applicable`: valid zero Control-derived candidates and no accepted NFRs.
- `In Progress`: unresolved Control-derived candidates remain.
- `Complete`: accepted valid NFR artifacts exist.
- `Blocked`: required NFR state is malformed, unavailable, or inconsistent.

Setup/configure separately returns exactly:

```text
Action Status: Succeeded|Declined|Aborted|Blocked
Collection Result: Continue|Finished
Next Action: <owner route or None>
Blocking Reason: <reason or None>
```

`Continue` means collection remains active; `Finished` requires explicit user finish intent. The
finished result is `Collection Result: Finished`; it does not include a created-NFR-ID list.
Readiness must not depend on Setup inspecting candidate counts.

## Persistence and relationships

Before mutation, validate the authoritative baseline, allocation state, duplicate/overlap state, and
relationship impact. Allocate permanent non-reused identifiers, update record/catalog/relationships
atomically as one transaction, generate deterministic catalog output, preserve semantic version behavior, and apply
destructive safeguards. Direct NFR creation uses `controls: []`; accepted Control-derived NFRs use
immutable `CTLXXXXXX` identifiers. Relationship updates are atomic with accepted NFR persistence and
remain within the existing Control/NFR ownership boundary. No post-write persistence verification is
required.

## Workflow

1. Classify the action and authoritative NFR baseline.
2. Load accepted grounding and NFR-owned candidate state.
3. For setup/configure, resolve pending Control-derived recommendations first.
4. Offer additional grounded recommendations when available.
5. Otherwise process user-authored NFR evidence or route Control-shaped evidence to Controls.
6. Capture explicit recommendation selections directly; review materially interpreted user-authored NFRs.
7. Revalidate duplicates and relationships, then persist accepted mutations atomically.
8. For setup/configure, continue until explicit finish; direct add terminates after one NFR.
9. Report readiness separately from collection completion.

## Verification

Verify that NFR records and the catalog follow their shared templates; readiness preserves Complete,
In Progress, Blocked, and Not Applicable; collection completion remains separate; candidate state is
NFR-owned, durable, ordered, exactly-once, and resumable; pending candidates precede open discovery;
selected recommendations are captured without redundant confirmation; grounded recommendations are
offered before unnecessary questions; materially interpreted user-authored NFRs use the captured-NFR
review; classification remains transient; direct NFRs use `controls: []`; Control-derived NFRs retain
immutable relationships; duplicate handling, identifiers, deterministic catalogs, atomic persistence,
and destructive safeguards remain intact; no post-write verification or duplicated Constitution,
Experience Standard, or development-governance rules remain.

## Error Handling

Rely on the Constitution common failure model. NFR-specific exceptions are:

- malformed NFR record, catalog, or allocation state: `Blocked` without mutation;
- malformed candidate state: `Blocked` without accepted-NFR mutation;
- invalid originating Control or generation request: candidate-generation `Blocked` with no partial relationship;
- unresolved update/remove target: stop and identify the target;
- unresolved NFR-versus-Control classification: ask the bounded classification question;
- destructive Remove/Set: use Experience Standard confirmation;
- unavailable relationship impact for a destructive action: stop without mutation and write nothing.

## Example

For `setup`, resolve pending Control-derived candidates, offer grounded recommendations, or ask the
fallback question when no useful grounding exists. Persist each accepted decision before proceeding,
then return the separate collection result and owner readiness result.

