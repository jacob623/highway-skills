---
name: highway-nfrs
description: "Manages the repository-wide Non-Functional Requirement baseline; use it to add, update, remove, replace, or inspect NFRs."
usage: "Invoke as `/highway-nfrs` and state the NFR baseline change in plain language."
compatibility: all
metadata:
  version: 9.0.0
---

# highway-nfrs

## Purpose

Maintains the repository-wide Non-Functional Requirement baseline as identified files the user owns.

## Interactive Workflow UX Contract

NFR candidate review follows the Interactive Workflow UX Contract in the Highway Experience
Standard. Present one candidate decision at a time, put the `Next Action` first, and omit
implementation details unless requested. When candidates are being reviewed, report `Candidate Position`,
`Remaining Candidates`, and `Current Activity`.

`User Exits` are `pause`, `cancel`, or `stop responding`; `Owner Outcomes` are `declined`,
`aborted`, or `blocked`. `Resume Applicability`: `Persisted owner evidence`. NFR ownership
remains authoritative for candidate decisions, artifacts, identifiers, catalogs, and completion
claims.

## When to use

Use this skill when a user wants to add, update, remove, replace, or inspect a repository-wide NFR.

Use it when a user wants to state a desired quality attribute, operational characteristic,
constraint, or business outcome for solutions in the repository.

Use `readiness` for a read-only assessment of candidate-generation and accepted-NFR state. NFRs
own this classification and readiness never accepts a proposal or writes a baseline.

## When not to use

Do not use this skill to record a specific, testable, auditable, or enforceable implementation
requirement; offer `/highway-controls` instead.

Do not use direct NFR authoring to populate NFR-to-Control relationships. Direct authoring starts with
an empty `controls` list; accepted candidates from the Control-derived workflow may populate the
identifier-only `controls` relationship, while the originating Control owner updates its `nfrs` list.
The Control-derived workflow remains the sole authorized path for those relationship updates.

Do not use it to edit an NFR file or generated catalog directly; use the workflow below.

## Inputs

A plain-language request describing the action and NFR content.

The project root, identified by locating `.highway/`. If `.highway/` cannot be located, the project
root is unknown and no governance path may be guessed.

The user-owned baseline at `library/governance/`, sibling to `.highway/` and never inside it.

The catalog at `library/governance/nfrs.md`, when the baseline has existing NFR files.

The NFR records at `library/governance/nfrs/NFRXXXXXX.md`, when they exist.

The NFR-owner candidate state at `.highway/catalog/nfr-candidate-state.md`. This framework-owned state
is distinct from the user-owned NFR records and `library/governance/nfrs.md` catalog; it is the retained
recovery source for candidate classification, deferred review, and readiness.

The repository's Highway Skills Constitution, Highway Experience Standard, and `/highway-controls`
routing contract for this skill's own behavior.

The owner-internal `candidate-generation` action invoked by `/highway-controls` after a verified new
Control is persisted. Its request contains these fields in this order:

```text
Action: candidate-generation
Originating Control ID: CTLXXXXXX
Derived Candidate Input: <deterministic candidate payload derived from the normalized Control title and statement>
```

The derived input contains zero or more candidate entries, each with Candidate Title, Candidate Statement,
Candidate Rationale, Originating Control Identifier, Originating Control Title, and stable derivation order.
NFRs validate the originating `CTLXXXXXX`, durably record the generation state, and return the canonical
candidate-generation result. Controls owns deterministic derivation; NFRs own this request boundary,
durable state and result, candidate classification/review, and NFR completion claims. This action is
owner-internal and is not a user-facing NFR authoring action.

The retained candidate-state file contains one immutable-ID-keyed record for every persistence-verified
new Control, in ascending originating Control ID order, with this structure:

```text
Originating Control ID: CTLXXXXXX
Generation Attempt: 1
Candidate Classification Result: Zero Candidates|Candidates Available|Blocked
Candidate Generation Result: Succeeded|Blocked
Candidate Count: <non-negative integer>
Candidate Entries: [<stable ordered candidate payloads or empty list>]
Review Status: Pending|In Progress|Complete|Cancelled
Blocking Reason: <reason or None>
```

Each retained Candidate Entry contains its stable candidate payload plus these owner-state fields:

```text
Decision: Pending|Accept|Modify|Replace|Reject|Cancel
Approved Title: <approved title or None>
Approved Statement: <approved statement or None>
Approved Rationale: <approved rationale or None>
```

`Generation Attempt: 1` is written only after the verified Control exists and is never repeated for the
same originating Control ID. `Candidate Classification Result` is durable even when review is deferred,
interrupted, paused, aborted, or the Controls collection later starts a New interaction. Candidate entries
retain their originating Control ID, title, statement, rationale, stable derivation order, decision, and
approved values; every decision is persisted before the next candidate is presented. A resumed review loads
this state and continues from the first Candidate Entry whose `Decision` is `Pending`; it never reconstructs
decisions from `Created Control IDs`, an unanswered prompt, or a restored conversation.

## Outputs

A changed baseline report naming the action and resulting semantic version.

An NFR file at `library/governance/nfrs/NFRXXXXXX.md` following the complete structure in
`.highway/library/templates/output/nfr-record.md`, including frontmatter and body. The template's
placeholders remain user-owned values.

The catalog at `library/governance/nfrs.md` follows the complete structure in
`.highway/library/templates/output/nfr-catalog.md`; that shared template is the structural
authority and its placeholders remain user-owned values.

The `readiness` action emits exactly these four lines in this order:

```text
Status: <Complete, In Progress, Blocked, or Not Applicable>
Summary: <NFR readiness explanation>
Next Action: <owner route or None>
Blocking Reason: <reason or None>
```

Unavailable or malformed candidate generation is `Blocked`; successful zero candidates with no
accepted artifacts is `Not Applicable`; candidates with none accepted are always `In Progress`;
accepted valid artifacts are `Complete`. A zero candidate count with candidate entries is
contradictory and `Blocked`, as is any other malformed candidate result. A blocked response has a
non-empty reason; every other response uses `Blocking Reason: None`. Readiness does not write
records, catalogs, IDs, or relationships.

For `readiness`, read candidate-generation state and accepted NFR artifacts, apply the outcome
rules above, and return the four-field response without mutation.

Immediately after the owner-internal `candidate-generation` action, NFRs returns this separate
candidate-generation result to Controls, with fields in this order:

```text
Candidate Generation Result: Succeeded|Blocked
Originating Control ID: CTLXXXXXX
Candidate Count: <non-negative integer>
Candidates: [<validated candidate entries or empty list>]
Blocking Reason: <reason or None>
```

`Succeeded` with `Candidate Count: 0` and `Candidates: []` represents zero candidates. `Succeeded` with
one or more validated candidate entries represents available candidates and uses `Blocking Reason: None`.
`Blocked` represents unavailable, malformed, contradictory, or failed generation, requires a non-empty
`Blocking Reason`, and preserves the verified Control and catalog transaction without a partial NFR
relationship. This immediate result is not the deferred NFR Review output and is not the four-field
Readiness result; Controls consumes it before collection completion, while durable candidate-generation
state remains authoritative for later review and readiness.

## Control-Derived Candidate Onboarding

Candidate-generation state is durable NFR owner state. Controls invokes deterministic derivation exactly
once immediately after each verified new Control persistence and submits the resulting candidate-generation
request to the NFR owner. User-visible candidate review
is deferred until the Controls collection returns `Collection Result: Finished`; it does not depend
on transient `Created Control IDs` or restored conversation state.

Readiness outcomes are `Not Applicable` for zero candidates with no accepted artifacts, `In Progress`
for candidates with none accepted, `Complete` for accepted valid artifacts, and `Blocked` for
malformed or unavailable generation. A blocked result has a non-empty reason, preserves the valid
Control and catalog transaction, and writes no partial NFR relationship. Controls owns deterministic
derivation; NFRs own candidate-generation state and result, candidate classification, review, accepted
persistence, identifiers, catalogs, readiness, and completion claims.

The durable state at `.highway/catalog/nfr-candidate-state.md` is the authoritative recovery projection.
For each verified new Control it retains the single classification result and candidate entries before
any user-visible review. Readiness and deferred review read this state by originating `CTLXXXXXX`; they
do not require transient Controls provenance, a restored conversation, or a second derivation attempt.

### Candidate-Generation Result Contract

For a valid `candidate-generation` request, return and durably record exactly one result state:

```text
Candidate Generation Result: Not Applicable|In Progress|Complete|Blocked
Originating Control ID: CTLXXXXXX
Candidate Count: <non-negative integer>
Blocking Reason: <reason or None>
```

`Not Applicable` means the submitted derived candidate input is valid and contains zero candidates with
no accepted artifacts. `In Progress` means valid candidates exist and none have been accepted. `Complete`
means accepted valid NFR artifacts exist for the originating Control. `Blocked` means the request, source
Control, candidate input, or durable generation state is malformed or unavailable; it requires a non-empty
`Blocking Reason`. `Candidate Count` must equal the submitted candidate-entry count; zero candidates with
candidate entries is contradictory and `Blocked`. `Not Applicable`, `In Progress`, and `Complete` use
`Blocking Reason: None`. Controls consumes this result for downstream behavior; it does not recompute the
result from transient input or candidate count.

`review` and `onboarding` are aliases for the Control-derived NFR candidate review workflow.
Display each candidate's title, statement, rationale, originating Control identifier, and
originating Control title. Candidates are ordered by persisted originating Control identifier and
then by availability, security, performance derivation order.

Per-candidate decisions are Accept, Modify, Replace, Reject, or Cancel. `Review Complete` is the
only successful NFR write boundary: every candidate must have exactly one final decision before it
succeeds. If any candidate remains undecided, Review Complete fails and creates no NFR artifact.
Accepted candidates are persisted in one all-or-nothing transaction with approved title, statement,
rationale, and originating Control relationship.

`Cancel Review` terminates NFR Review without requiring candidate decisions and preserves all
candidate, NFR, catalog, and relationship bytes. Existing NFR duplication is detected before NFR
creation and before identifier allocation; duplicate acceptance fails safely with no partial writes.
Direct NFR authoring remains independent and starts with `controls: []`.

`Review Complete` remains the only successful accepted-NFR write boundary. The NFR record follows
`.highway/library/templates/output/nfr-record.md`; its `controls` list is identifier-only and no
relationship store or reverse generation is introduced.

### NFR Review Output Contract

NFR Review emits one entry per candidate. Each entry contains Candidate Title, Candidate Statement,
Candidate Rationale, Originating Control Identifier, Originating Control Title, and Available Decisions: Accept, Modify, Replace, Reject. Candidate order remains stable through review and
re-rendering: identical candidate inputs produce identical ordering based on persisted originating
Control identifier followed by availability, security, performance derivation order.

Review output and ordering do not depend on timestamps, randomness, environment values, filesystem
ordering, or user-session state.

When no NFR candidates exist, NFR Review emits exactly:

- `Status: Empty`
- `Entry Count: 0`

The empty review result creates no placeholder governance artifact. successful NFR `Review Complete` outcomes are reflected by subsequent readiness evaluation. Cancellation, rejection, validation failure, allocation failure, duplicate detection failure, and write failure do not change readiness-consumed accepted artifact state. Duplicate detection runs before NFR creation and identifier allocation; a
duplicate detection failure preserves candidate, NFR, catalog, and relationship state and performs no
partial NFR write.

A generated prose catalog at `library/governance/nfrs.md`. The catalog contains no timestamp.

## Decision tables

Evaluate these tables in order. If no row matches, use the final otherwise row.

### Action selection

| Request evidence | Action |
|---|---|
| Explicitly says add or introduces a new NFR | Add |
| Explicitly says update or changes named fields on an existing ID | Update |
| Explicitly says remove or delete one existing ID | Remove |
| Explicitly says set, replace, or provides a complete replacement baseline | Set |
| Explicitly says readiness or asks whether the NFR state is ready | Readiness |
| Explicitly says `review` or `onboarding` for Control-derived candidates | Review |
| Asks only for the baseline or version | Inspect |
| Otherwise | Abort and ask which action is intended |

### Statement classification

| Statement evidence | Classification and response |
|---|---|
| Desired outcome, quality attribute, operational characteristic, business outcome, or constraint | NFR candidate |
| Specific, testable, auditable, or enforceable implementation requirement | Control; offer `/highway-controls` |
| Both or neither | NFR candidate; give advice and ask whether to continue |

Classification never writes a relationship. If the user keeps a vague NFR, record it after advice.
If it resembles an existing NFR, name that NFR by identifier and title.

For a vague NFR, explain the missing quality, scope, or observable outcome and offer at least one
concrete alternative. For example, replace `the system should be secure` with `administrative
access must require multi-factor authentication` or `all data at rest must be encrypted`. The
author may keep the original wording after hearing the advice.

## Workflow

1. Read the Inputs and identify the project root, baseline path, catalog path, records path, and requested action.
2. Apply Action selection and Statement classification in their stated order.
3. For Add, read `next_id` from the catalog when it exists, allocate it once, and prepare one new NFR record with an empty `controls` list.
4. If a request could mean either Update or Set, stop and ask whether one existing NFR or the entire baseline should change.
5. For Update, Remove, or Set, resolve every referenced NFR by identifier and title before writing.
6. For Remove or Set, invoke `/highway-relationships Impact` for the proposed NFR removal or baseline replacement, list every lost relationship and affected artifact by immutable identifier and title, then list every NFR that would be lost by identifier and title and request confirmation before changing any file.
7. After confirmation or for a non-destructive direct action, apply the requested mutation, preserving identifiers and untouched metadata.
8. For each persistence-verified new Control, validate the owner-internal `candidate-generation` request, persist one durable candidate-classification record, return the exact Candidate-Generation Result, and write no accepted NFR, catalog entry, or relationship merely because generation succeeded.
9. If the selected action is `Review` from `review` or `onboarding`, require Controls `Collection Result: Finished`, load `.highway/catalog/nfr-candidate-state.md` by originating `CTLXXXXXX`, and use only its durable candidate entries and classification result; otherwise continue to Step 14.
10. Present the first Candidate Entry whose durable `Decision` is `Pending`, with its originating Control details and the available Accept, Modify, Replace, Reject, or Cancel decision, preserving the persisted candidate order; on resume, skip all earlier decided entries.
11. Apply the selected decision to the NFR-owned candidate state and persist it before continuing: retain approved wording for Accept, Modify, or Replace; mark Reject or Cancel; and do not allocate an NFR identifier before review completion.
12. After every candidate has exactly one final non-Cancel decision, `Review Complete` persists all approved NFR records, catalog changes, and identifier-only relationships in one validated transaction; otherwise remain in the review path or return the declared incomplete-review failure.
13. On `Cancel Review`, preserve candidate state, NFR records, catalog, identifiers, and relationships and return without an accepted-NFR write.
14. Increment the baseline exactly once for the applicable successful direct or review action: Add is MINOR; an obligation-preserving Update is PATCH; Remove or Set is MAJOR.
15. Regenerate `nfrs.md` from the records, version, and recorded `next_id`, then report the action, changed identifiers, and resulting version.

The catalog is authoritative for `next_id`; never derive it from the highest file present. An NFR
identifier is `NFR` followed by six digits, never changes, and is never reissued after removal.

Root-level `library/governance/` is user-owned content. This skill judges a proposal only for NFR
versus Control classification and skips Highway prose, structure, or quality validation for the
contents of an accepted NFR record.

## Verification

- Confirm every NFR record is under root `library/governance/nfrs/`, not under `.highway/`.
- Confirm each NFR record conforms to `.highway/library/templates/output/nfr-record.md`.
- Confirm the catalog conforms to `.highway/library/templates/output/nfr-catalog.md`.
- Confirm no NFR record contains a version field and the catalog contains no timestamp.
- Confirm a declined destructive action leaves the records, catalog, version, and `next_id` unchanged.
- Confirm an unchanged baseline regenerates to an identical catalog.
- Confirm `/highway-controls` can invoke the owner-internal `candidate-generation` action with an originating
  `CTLXXXXXX` and derived candidate input, and that NFRs validates, durably records, and returns the exact
  Candidate-Generation Result without treating Controls' transient input as durable state.
- Confirm `.highway/catalog/nfr-candidate-state.md` contains exactly one retained record per verified new
  `CTLXXXXXX`, with `Generation Attempt: 1`, a durable classification result, stable candidate entries,
  review status, and blocking reason, and that interrupted or New interactions recover from this file
  without `Created Control IDs` or repeated derivation.
- Confirm every retained Candidate Entry persists `Decision` and approved title/statement/rationale values,
  decisions are written before the next candidate is presented, and an interrupted or resumed review starts
  at the first `Decision: Pending` entry rather than restoring a prompt or conversation.
- Confirm the immediate Candidate-Generation Result is emitted separately from deferred NFR Review and the
  four-field Readiness result, with zero candidates represented by `Succeeded` plus `Candidates: []`,
  available candidates represented by validated entries, and `Blocked` requiring a non-empty reason.
- Confirm candidate-generation results distinguish `Not Applicable`, `In Progress`, `Complete`, and
  `Blocked`, with candidate count consistency and a non-empty blocking reason only for `Blocked`.
- Confirm the Action Selection table selects `Review` for both `review` and `onboarding`, and that the
  selected candidate-review workflow cannot begin until Controls returns `Collection Result: Finished`.
- Confirm Workflow Steps 8 through 13 cover candidate generation, durable-state loading, one-candidate-at-a-time
  review, decisions, Review Complete, and cancellation, with each step mapped to a declared error path.
- Confirm each accepted NFR record, catalog, and relationship update is one validated transaction
  and a failure leaves every affected byte unchanged.
- Confirm Control-shaped statements name `/highway-controls` and outcome-shaped Control input names
  `/highway-nfrs`.
- Feature 094 Control-derived NFR reconciliation (FR-037, FR-037a, FR-037b, FR-041f, FR-041h,
  FR-042e, FR-042i, SC-010, SC-019, and SC-025):
  - Confirm deterministic candidate generation runs only after a new Control is atomically persisted
    and all retained Control outputs verify; reused, updated, rejected, failed, and pre-existing
    Controls do not trigger it.
  - Confirm each persistence-verified new Control reaches candidate classification exactly once,
    records `Generation Attempt: 1`, and retains its classification and candidate entries by immutable
    originating Control ID even when the surrounding collection pauses, aborts, or is interrupted.
  - Confirm readiness maps durable state to `Not Applicable` for valid zero candidates, `In Progress`
    for available candidates with none accepted, `Complete` for accepted valid NFR artifacts, and
    `Blocked` for generation failure or malformed state with a non-empty reason; blocked generation
    preserves the verified Control and writes no partial NFR relationship.
  - Confirm NFR candidate review cannot begin until Controls returns `Collection Result: Finished`,
    does not depend on transient `Created Control IDs` or restored conversation state, and resumes from
    durable candidate state after a New interaction.
  - Confirm NFRs own candidate classification/review decisions, accepted NFR persistence, identifiers,
    catalogs, readiness, completion claims, and authorized accepted `controls` relationship writes;
    Controls owns only deterministic initial derivation and invocation.
  - Confirm Setup consumes fresh NFR readiness after deferred review and advances only from the NFR
    owner's declared terminal result, without treating candidate generation or Controls collection
    completion as NFR review completion.

## Control-Derived Relationship Boundary

Direct NFR authoring starts with `controls: []` and does not infer or create a Control relationship.
`/highway-controls` owns deterministic initial candidate derivation and invokes `/highway-nfrs`
with the originating Control and derived input. NFRs own candidate classification and review
decisions, accepted NFR persistence, and the authorized atomic update of each accepted NFR's
identifier-only `controls` relationship. Generation failure writes no partial relationship.

## Error Handling

- The project root cannot be located: abort and ask where `.highway/` is located.
- The catalog is absent while NFR files exist: abort and ask for catalog repair.
- A referenced NFR does not exist: abort and name what was searched for.
- The catalog or a record is malformed or inconsistent: abort and name the file and inconsistency.
- The intended action or target is ambiguous: abort and ask which interpretation is intended.
- The request could mean updating one NFR or replacing the baseline: abort, name both
  interpretations, ask which one is intended, and write nothing.
- A destructive action would remove an NFR: abort until the user confirms after seeing every ID and
  title and the complete `/highway-relationships Impact` result.
- Relationship impact analysis is blocked, incomplete, or unavailable: abort and write nothing;
  `/highway-relationships` analyzes impact only and this skill retains NFR deletion, versioning,
  and catalog ownership.
- A `candidate-generation` request is malformed or unavailable: abort with `Blocked`; this includes a
  missing or reordered request, invalid originating Control, malformed candidate input, contradictory
  count, or unavailable durable state. Return a non-empty reason, preserve the verified Control and
  catalog transaction, and write no partial NFR relationship.
- Confirmation is withheld: abort and write nothing.
- A statement is Control-shaped: fall back to `/highway-controls`.

Candidate-review workflow errors map to the numbered steps as follows:

| Step | Failure condition | Action |
|---|---|---|
| 8 | Candidate-generation input, originating Control, durable-state write, or result is invalid | abort with `Blocked`, preserve the verified Control and catalog transaction, and write no partial NFR relationship |
| 9 | Controls has not returned `Collection Result: Finished`, or durable candidate state cannot be loaded by `CTLXXXXXX` | abort review without restoring transient state or invoking a second derivation |
| 10 | Candidate state is missing, reordered, or cannot produce one stable current candidate | abort with `Blocked` and preserve candidate state and accepted artifacts |
| 11 | A candidate decision is invalid, ambiguous, or cannot be retained | abort the review action and preserve all pre-review bytes |
| 12 | Review Complete is requested with an undecided candidate or any transaction step fails | abort with no NFR, catalog, identifier, or relationship write |
| 13 | Cancel Review cannot be completed without mutation | abort and preserve candidate, NFR, catalog, identifier, and relationship bytes |

## Example

`/highway-nfrs Add an NFR requiring systems to remain available during a single availability-zone failure.`

The skill classifies the statement as an NFR, proposes a title and rationale for confirmation,
allocates the catalog's `next_id`, writes `controls: []`, increments the baseline MINOR version,
and regenerates the catalog.
