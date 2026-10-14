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

Runtime dependencies are:

- the project root located from `.highway/`;
- authoritative NFR artifacts at `library/governance/nfrs/NFRXXXXXX.md` and
  `library/governance/nfrs.md`;
- shared output templates at `.highway/library/templates/output/nfr-record.md` and
  `.highway/library/templates/output/nfr-catalog.md`;
- the Highway Experience Standard at `.highway/governance/experience-standard.md`;
- `.highway/library/knowledge/highway-identity.md` for behavioral framing;
- `.highway/library/knowledge/highway-vision.md` for strategic direction;
- `.highway/library/knowledge/highway-platform-objectives.md` for evaluation criteria;
- `.highway/library/knowledge/profile.md` for accepted organizational context;
- accepted Business Objective records and catalog as recommendation and operational-context inputs;
- accepted Control records and catalog as optional context and relationship inputs;
- existing accepted NFR records and catalog as reuse, duplicate, overlap, and recommendation
  context;
- the `/highway-setup` owner contract at `.highway/skills/highway-setup/SKILL.md` for setup/configure
  collection completion;
- the active user request and active interaction evidence;
- the `/highway-controls` owner contract at `.highway/skills/highway-controls/SKILL.md` for the
  independent Control ownership boundary;
- the `/highway-relationships` owner contract at `.highway/skills/highway-relationships/SKILL.md`,
  its impact analysis, and its authoritative impact result for destructive NFR mutations.

Recommendations may use accepted Profile, Objectives, Controls, and existing NFRs. Control benchmark
grounding does not itself establish benchmark applicability for an NFR.

## Ownership boundary

Controls and NFRs are independent owners. NFRs are independently managed NFRs and own classification, NFR records and identifiers, the
catalog, Control relationships, readiness, and collection completion. NFR work does not require a
Control identifier, Control capture transaction, or upstream lifecycle result.

## Discovery and recommendations

Offer small grounded NFR recommendation sets when useful context supports them and keep the user-authored
alternative available. If no useful grounded recommendations exist, ask:

**Are there any qualities or operational expectations you'd like future solutions to meet?**

Use concise examples such as availability, performance, recoverability, scalability, maintainability,
or operability only when they improve clarity. Do not require the user to ask for suggestions first,
and do not generate generic recommendations merely to keep a loop active.

Treat a direct NFR statement as direct capture when no material transformation is needed. Direct capture skips the inferred-content review; it does not bypass NFR validation, duplicate handling, identifier allocation, relationship handling, or atomic persistence. For a materially interpreted, classified, normalized, or synthesized user-authored NFR, use:

**Here's what I've captured as your NFR:**

**Title:**  
[Title]

**Statement:**  
[Statement]

**Why it matters:**  
[Rationale]

**Would you like to accept this NFR?**

Synthesize Rationale from accepted evidence and grounding; do not ask a separate rationale question.
Explicitly selected recommendations and direct NFR statements do not receive this redundant review.
If classification remains ambiguous after evaluating evidence, ask one bounded question distinguishing
a desired quality or operational outcome (NFR) from an enforceable, auditable, or checkable safeguard
(Control). Classification is transient and does not become a persisted field.

The catalog at `library/governance/nfrs.md` and records at
`library/governance/nfrs/NFRXXXXXX.md` are user-owned. Their structure is governed by
`.highway/library/templates/output/nfr-record.md` and `.highway/library/templates/output/nfr-catalog.md`.

## Outputs

NFR readiness is owner-controlled and separate from collection completion:

```text
Status: Complete|Missing|Blocked
Summary: <NFR readiness explanation>
Next Action: <owner route or None>
Blocking Reason: <reason or None>
```

- `Missing`: no accepted NFRs or valid NFR artifacts exist.
- `Complete`: accepted valid NFR artifacts exist.
- `Blocked`: required NFR records, catalog, or allocation state is malformed, unavailable, or inconsistent.

Setup/configure separately returns exactly:

```text
Action Status: Succeeded|Declined|Aborted|Blocked
Collection Result: Continue|Finished
Next Action: <owner route or None>
Blocking Reason: <reason or None>
```

`Continue` means collection remains active; `Finished` requires explicit user finish intent. The
finished result is `Collection Result: Finished`; it does not include a created-NFR-ID list.
Readiness is independent of Control collection and does not inspect upstream collection state.

## Persistence and relationships

Before mutation, validate the authoritative baseline, allocation state, duplicate/overlap state, and
relationship impact. Allocate permanent non-reused identifiers, update record/catalog/relationships
atomically as one transaction, generate deterministic catalog output, preserve semantic version behavior, and apply
destructive safeguards. Direct NFR creation uses `controls: []`; retained relationships remain unchanged unless
a user-authorized NFR mutation requests a change. Relationship updates are atomic with accepted NFR persistence and
remain within the existing Control/NFR ownership boundary. No post-write persistence verification is
required.

## Workflow

1. Classify the action and authoritative NFR baseline.
2. Load accepted grounding without requiring Control-originated state.
3. Offer grounded recommendations when available.
4. Process user-authored NFR evidence or route Control-shaped evidence to Controls.
5. Capture explicit recommendation selections directly; review materially interpreted user-authored NFRs.
6. Revalidate duplicates and relationships, then persist accepted mutations atomically.
7. For setup/configure, continue until explicit finish; direct add terminates after one NFR.
8. Report readiness separately from collection completion.

## Verification

Verify that NFR records and the catalog follow their shared templates; readiness preserves Missing,
Complete, and Blocked; collection completion remains separate; no Control-originated state is required;
selected recommendations are captured without redundant confirmation; grounded recommendations are
offered before unnecessary questions; materially interpreted user-authored NFRs use the captured-NFR
review; classification remains transient; direct NFRs use `controls: []`; retained relationships remain
unchanged unless user-authorized; duplicate handling, identifiers, deterministic catalogs, atomic persistence,
and destructive safeguards remain intact; no post-write verification or duplicated Constitution,
Experience Standard, or development-governance rules remain.

## Error Handling

Rely on the Constitution common failure model. NFR-specific exceptions are:

- malformed NFR record, catalog, or allocation state: `Blocked` without mutation;
- unavailable upstream Control context does not block independent NFR work;
- unresolved update/remove target: stop and identify the target;
- unresolved NFR-versus-Control classification: ask the bounded classification question;
- destructive Remove/Set: use Experience Standard confirmation;
- unavailable relationship impact for a destructive action: stop without mutation and write nothing.

## Example

For `setup`, offer grounded recommendations or ask the fallback question when no useful grounding exists.
Persist each accepted decision before proceeding, then return the separate collection result and owner
readiness result.

