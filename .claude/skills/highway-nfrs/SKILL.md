---
name: highway-nfrs
description: "Manages the repository-wide Non-Functional Requirement baseline; use it to add, update, remove, replace, or inspect NFRs."
usage: "Invoke as `/highway-nfrs` and state the NFR baseline change in plain language."
compatibility: all
metadata:
  version: 10.0.0
---

# highway-nfrs

## Purpose

Maintains the repository-wide Non-Functional Requirement baseline as identified files the user owns.

## Experience

NFR candidate review follows the Highway Experience Standard. Present one candidate decision at a time, put the `Next Action` first, and omit
implementation details unless requested. When candidates are being reviewed, report secondary
user-relevant progress as `Recommendation <position> of <total>` before the contextual recommendation.

`User Exits` are `pause`, `cancel`, or `stop responding`; `Owner Outcomes` are `declined`,
`aborted`, or `blocked`. `Resume Applicability`: `Persisted owner evidence`. NFR ownership
remains authoritative for candidate decisions, artifacts, identifiers, catalogs, and completion
claims.

Active `setup` and `configure` collection uses the separate NFR Collection Result contract. It is
distinct from the four-field readiness result and contains exactly:

```text
Action Status: Succeeded|Declined|Aborted|Blocked
Collection Result: Continue|Finished
Next Action: <owner route or None>
Blocking Reason: <reason or None>
```

## When to use

Use this skill when a user wants to add, update, remove, replace, or inspect a repository-wide NFR.

Use it when a user wants to state a desired quality attribute, operational characteristic,
constraint, or business outcome for solutions in the repository.

Use `setup` or `configure` to collect derived recommendations and additional user-authored NFRs in
an active conversation. Direct invocation does not emit Setup-owned transition or conclusion text.

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

Optional Repository Context may influence discovery and suggestions only when the document is present
and valid. The declared sources and roles are:

- `.highway/library/knowledge/highway-identity.md`: Highway identity and purpose used to keep
  acknowledgments and relevance framing consistent.
- `.highway/library/knowledge/highway-vision.md`: repository direction used to ground follow-up
  questions and suggestion relevance.
- `.highway/library/knowledge/highway-platform-objectives.md`: platform objectives used to relate
  operational expectations to accepted repository direction.
- `.highway/library/knowledge/profile.md`: user-owned organizational context used for applicable
  acknowledgments, rationale, and suggestions.
- Accepted Business Objectives: outcome context used for relevance and overlap guidance.
- Accepted Controls: safeguard context used for recommendation relevance and Control/NFR distinction.
- Existing NFRs: retained expectation context used for duplicate and overlap guidance.

These sources are not interchangeable: each is used only for the role it declares. Active user
evidence remains authoritative when it conflicts with repository context. Missing or malformed
optional context is recorded and excluded; NFRs never invents substitute facts.

When accepted context or active user evidence materially changes a recommendation, interpretation,
rationale, overlap decision, or next workflow action, provide one concise user-relevant acknowledgment
before the affected question, recommendation, proposal, or decision. The acknowledgment does not create
an additional response-demanding question.

The owner-internal `candidate-generation` action invoked by `/highway-controls` after a verified new
Control is persisted. Its request contains these fields in this order:

```text
Action: candidate-generation
Originating Control ID: CTLXXXXXX
Derived Candidate Input: <deterministic candidate payload derived from the normalized Control title and statement>
```

The derived input contains zero or more candidate entries, each with internal Candidate Title, Candidate Statement,
Candidate Rationale, Originating Control Identifier, Originating Control Title, and stable derivation order.
NFRs validate the originating `CTLXXXXXX`, durably record the classification state, and return the
Candidate-Generation Action Result. Controls owns deterministic derivation; NFRs own this request boundary,
durable state and result, candidate classification/review, and NFR completion claims. This action is
owner-internal and is not a user-facing NFR authoring action.

The retained candidate-state file contains one immutable-ID-keyed record for every persistence-verified
new Control, in ascending originating Control ID order, with this structure:

```text
Originating Control ID: CTLXXXXXX
Generation Attempt: 1
Candidate Classification / Readiness State: Not Applicable|In Progress|Complete|Blocked
Candidate-Generation Action Result: Succeeded|Blocked
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
same originating Control ID. `Candidate Classification / Readiness State` is durable even when review is deferred,
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

For active `setup` or `configure`, return the separate collection result in this exact order:

```text
Action Status: Succeeded|Declined|Aborted|Blocked
Collection Result: Continue|Finished
Next Action: <owner route or None>
Blocking Reason: <reason or None>
```

`Continue` means active collection remains open. `Finished` requires explicit user intent to finish,
including when zero candidates exist and no user-authored NFR has been accepted. `Declined`, `Aborted`,
and `Blocked` do not represent successful collection completion; `Blocked` requires a non-empty reason.
This result does not include a created-NFR-ID list and does not replace the four-field readiness result.

Immediately after the owner-internal `candidate-generation` action, NFRs returns this separate
Candidate-Generation Action Result to Controls, with fields in this order:

```text
Candidate-Generation Action Result: Succeeded|Blocked
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

### Candidate Classification / Readiness State

The durable state later interpreted by NFR readiness is not the immediate action result. It uses exactly
one classification state:

```text
Candidate Classification / Readiness State: Not Applicable|In Progress|Complete|Blocked
Originating Control ID: CTLXXXXXX
Candidate Count: <non-negative integer>
Blocking Reason: <reason or None>
```

`Not Applicable` means durable classification is valid and contains zero candidates with
no accepted artifacts. `In Progress` means valid candidates exist and none have been accepted. `Complete`
means accepted valid NFR artifacts exist for the originating Control. `Blocked` means the request, source
Control, candidate input, or durable classification state is malformed or unavailable; it requires a non-empty
`Blocking Reason`. `Candidate Count` must equal the submitted candidate-entry count; zero candidates with
candidate entries is contradictory and `Blocked`. `Not Applicable`, `In Progress`, and `Complete` use
`Blocking Reason: None`. Controls consumes this result for downstream behavior; it does not recompute the
state from transient input or candidate count.

`review` and `onboarding` are aliases for the Control-derived NFR candidate review workflow.
Present one unresolved candidate at a time as:

```text
Based on your [Control subject] [descriptor], Highway recommends:

[NFR statement]

Why it matters:
[user-relevant rationale]

Would you like to accept, change, replace, or skip it?
```

The transient descriptor is selected from `requirements`, `safeguards`, `obligations`, `constraints`,
or `conditions` based on accepted Control evidence, with `requirements` as the fallback. The subject
is derived from that evidence for presentation only. Routine output omits Candidate Title, Control
identifiers and titles, candidate-generation terminology, and internal candidate-state terminology.
User-facing `accept`, `change`, `replace`, and `skip` map to existing durable acceptance,
modification, replacement, and final non-acceptance decisions. Candidates remain ordered by persisted
originating Control identifier and then by availability, security, performance derivation order.

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

This is the Contextual NFR Review Output Contract. NFR Review emits one entry per candidate.

Candidate review emits secondary progress followed by one contextual recommendation:

```text
Recommendation <position> of <total>

Based on your [Control subject] [descriptor], Highway recommends:

[NFR statement]

Why it matters:
[user-relevant rationale]

Would you like to accept, change, replace, or skip it?
```

`Recommendation <position> of <total>` is the user-relevant progress indicator. It replaces routine
exposure of Candidate Position, Remaining Candidates, and Current Activity labels while preserving
their meaning without exposing workflow mechanics. Candidate titles, Control identifiers and titles,
durable decisions, candidate-generation language, and candidate-state machinery remain internal except
when needed for explicit error or recovery explanation. Identical candidate inputs produce identical
ordering based on persisted originating Control identifier followed by availability, security,
performance derivation order; output does not depend on timestamps, randomness, environment values,
filesystem ordering, or user-session state.

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
| Explicitly says `setup` or `configure` for active NFR collection | Setup Collection |
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

### User-authored proposal shape

The transient proposal uses this shape:

```text
Here's the expectation I've captured:

[Title, when required for approval]
[NFR statement]

Why it matters:
[user-approved or evidence-grounded rationale]

Does this reflect what you need?
```

Do not expose an unallocated identifier, catalog mutation, baseline version, or persistence mechanics.
Natural acceptance authorizes the existing Add behavior; correction, replacement, rejection,
cancellation, abandonment, or interruption keeps the proposal transient and writes nothing.

1. Read the Inputs and identify the project root, baseline path, catalog path, records path, candidate-state path, optional Repository Context Documents, and requested action.
2. After Step 1, apply Action selection and Statement classification in their stated order; active user evidence is authoritative over optional repository context.
3. After Step 2, before any context-dependent recommendation, suggestion, acknowledgment, follow-up, rationale, or proposal, consult each available declared Repository Context source that can influence the active decision. Record unavailable or malformed optional sources and exclude them without substitution.
4. After Step 3, for direct Add, read `next_id` from the catalog when it exists, prepare the transient proposal, and retain it without persistence until natural confirmation.
5. After Step 4, if a request could mean either Update or Set, stop and ask whether one existing NFR or the entire baseline should change.
6. After Step 5 resolves action ambiguity, for Update, Remove, or Set, resolve every referenced NFR by identifier and title before writing.
7. After Step 6 resolves all targets, for Remove or Set, invoke `/highway-relationships Impact`, list every lost relationship and affected artifact by immutable identifier and title, then request confirmation before changing any file.
8. After Step 7 obtains confirmation or identifies a non-destructive direct action, apply the requested mutation, preserving identifiers and untouched metadata.
9. After Step 8 verifies a new Control, validate the owner-internal `candidate-generation` request, persist one durable Candidate Classification / Readiness State record, and return the separate Candidate-Generation Action Result to Controls. Do not write an accepted NFR, catalog entry, or relationship merely because generation succeeded.
10. After Step 9, for `Review`, require Controls `Collection Result: Finished`; for `Setup Collection`, load `.highway/catalog/nfr-candidate-state.md` by originating `CTLXXXXXX`. Use only durable candidate entries, classification state, and stable order; do not regenerate or reclassify candidates.
11. After Step 10 loads review state, load the first durable `Decision: Pending` candidate. If one exists, derive its transient Control subject and descriptor, render the contextual recommendation with `Recommendation <position> of <total>`, and present only accept, change, replace, or skip. Preserve durable candidate ordering. If none exists, continue to Step 15.
12. After Step 11 receives a decision, persist it before presenting another candidate: `accept` maps to `Accept`, `change` to `Modify`, `replace` to `Replace`, and `skip` to `Reject`. Cancel, pause, and interruption are workflow exits and do not map to `skip`.
13. After Step 12 finds every candidate has one final decision, perform `Review Complete` and persist approved NFR records, catalog changes, and authorized identifier-only relationships in one validated transaction. For Setup Collection, continue to Step 15 only after this boundary succeeds.
14. After Step 13 receives `Cancel Review`, preserve candidate state, NFR records, catalog, identifiers, and relationships and return without an accepted-NFR write.
15. After Step 10 finds no unresolved candidates, or Step 13 succeeds for Setup Collection, enter or continue open NFR discovery and ask this exact broad question: Are there any qualities or operational expectations you'd like future solutions to meet?
16. After Step 15 begins open discovery, evaluate all supplied evidence before selecting another question and expose at most one unresolved response-demanding question or decision. When an answer can affect a downstream recommendation, proposal, governance interpretation, retained NFR, or workflow action, provide concise Decision Context unless that implication was established immediately before the question. When an example clarifies the expected response form, provide one concise illustrative example without constraining user-owned content. Treat `I don't know` as guided discovery and offer one to three transient suggestions only from relevant available declared context. When repository context grounds a suggestion, identify the applicable source at a user-relevant level, such as the accepted Profile, an accepted Business Objective, an existing Control, an existing NFR, or applicable Highway repository context; do not expose repository paths, loading mechanics, source-selection logic, or unrelated context. Require adoption or restatement before acceptance.
17. After Step 16 identifies supported user-authored evidence, present the transient user-authored proposal shape above. Do not expose persistence mechanics; correction, replacement, rejection, cancellation, abandonment, or interruption keeps the proposal transient and writes nothing.
18. After Step 17 verifies Add persistence with `controls: []`, ask whether to define another NFR, request suggestions, or finish. Return `Action Status: Succeeded` with `Collection Result: Continue` while collection remains active. Return `Action Status: Succeeded` with `Collection Result: Finished` only after explicit user intent to finish. Explicit finish is valid with zero candidates or zero accepted user-authored NFRs and does not establish readiness. For `Finished`, Setup requests fresh `/highway-nfrs readiness`; fresh readiness independently determines persisted-state terminality.
19. After Step 18 permits completion of the active operation, increment the applicable baseline version for a successful direct or review mutation, regenerate `nfrs.md`, verify every retained output covered by the completion claim, and report the result. Add is MINOR; an obligation-preserving Update is PATCH; Remove or Set is MAJOR. Before destructive confirmation, list every NFR that would be lost by identifier and title.

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
  Candidate-Generation Action Result without treating Controls' transient input as durable state.
- Confirm `.highway/catalog/nfr-candidate-state.md` contains exactly one retained record per verified new
  `CTLXXXXXX`, with `Generation Attempt: 1`, a durable classification result, stable candidate entries,
  review status, and blocking reason, and that interrupted or New interactions recover from this file
  without `Created Control IDs` or repeated derivation.
- Confirm every retained Candidate Entry persists `Decision` and approved title/statement/rationale values,
  decisions are written before the next candidate is presented, and an interrupted or resumed review starts
  at the first `Decision: Pending` entry rather than restoring a prompt or conversation.
- Confirm the immediate Candidate-Generation Action Result is emitted separately from deferred NFR Review and the
  four-field Readiness result, with zero candidates represented by `Succeeded` plus `Candidates: []`,
  available candidates represented by validated entries, and `Blocked` requiring a non-empty reason.
- Confirm Candidate Classification / Readiness State distinguishes `Not Applicable`, `In Progress`, `Complete`, and
  `Blocked`, with candidate count consistency and a non-empty blocking reason only for `Blocked`.
- Confirm the Action Selection table selects `Review` for both `review` and `onboarding`, and that the
  selected candidate-review workflow cannot begin until Controls returns `Collection Result: Finished`.
- Confirm the Action Selection table selects active `Setup Collection` for `setup` and `configure`, and
  that its separate collection result uses `Continue` and explicit `Finished` without changing readiness.
- Confirm the exact broad discovery question is used after candidate review and when zero candidates
  exist, that `I don't know` starts guided discovery, suggestions remain transient, and accepted direct
  NFRs persist with `controls: []` before collection continues.
- Confirm each available declared Repository Context source is consulted before output it can influence,
  only relevant context is consumed, and active user evidence remains authoritative on conflict.
- Confirm every unavailable or malformed declared Repository Context Document is recorded and excluded
  without fabricated or substituted context.
- Confirm repository-grounded recommendations and suggestions identify the applicable source at a
  user-relevant level without exposing repository paths or retrieval mechanics.
- Confirm materially influential context or user evidence receives one concise Contextual Acknowledgment
  before the affected continuation, and Decision Context and Relevant Examples do not create a second
  unresolved question.
- Confirm Workflow Steps 8 through 19 cover candidate-generation action results, durable classification-state
  loading, one-candidate-at-a-time contextual review, decisions, Review Complete, open discovery, proposal
  handling, explicit collection completion, versioning, catalog regeneration, and fresh readiness, with each
  step mapped to a declared error path.
- Confirm the NFR Collection Result fields appear in exact order with only the declared values; `Succeeded +
  Continue` remains with NFRs without fresh readiness, `Succeeded + Finished` triggers fresh readiness,
  and collection `Finished` alone never establishes Setup completion.
- Confirm zero-candidate readiness can still lead to active NFR collection when the owner provides that route,
  Setup does not inspect candidate existence or count to select a route, and both pending-candidate review and
  zero-candidate discovery receive the Setup transition when they are the first NFR-owned interaction.
- Confirm user-authored NFR creation does not end collection, and fresh readiness after `Finished` is consumed
  according to the NFR owner contract rather than independently reclassified by Setup.
- Because NFRs handles user input and retained file writes, the Security Gate applies. Security-affecting
  guidance is grounded by `[AS-2: A03:2021 Injection]`. Verify that the skill does not disable verification,
  hardcode credentials, or bypass input validation, and that suspected vulnerabilities are reported rather
  than silently altered.
- Maintainability Gate Check: when implementation work modifies retained source/code files and comments are
  applicable, require comments only for intent not already expressed by adjacent content. Never add comments
  to user-owned NFR statements or rationales merely to satisfy the gate.
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
  count, or unavailable durable state. Return the Candidate-Generation Action Result with a non-empty
  blocking reason, preserve the verified Control and catalog transaction, and write no partial NFR relationship.
- An optional Repository Context Document is absent or malformed: record it as unavailable, abort its
  context-dependent use, exclude it from suggestions, follow-up questions, rationale, acknowledgments,
  and relevance guidance, and do not invent replacement context.
- Confirmation is withheld: abort and write nothing.
- A statement is Control-shaped: fall back to `/highway-controls`.
- A suspected vulnerability is discovered during NFR processing: abort, report the suspected
  vulnerability, preserve affected retained state, and do not silently alter it. `[AS-2: A03:2021 Injection]`

Workflow errors map to the numbered steps as follows:

| Step | Failure condition | Action |
|---|---|---|
| 1 | Project root, authoritative path, or required input cannot be resolved | escalate to obtain the missing or contradictory input |
| 2 | Requested action or statement classification is unsupported or ambiguous | abort and request the required user clarification |
| 3 | A declared optional Repository Context source is unavailable or malformed | record and exclude that source, then continue without substitution |
| 4 | Direct Add proposal preparation requires unavailable allocation state or malformed baseline | abort and preserve retained state |
| 5 | Update-versus-Set ambiguity cannot be resolved | abort without writing |
| 6 | An existing mutation target cannot be uniquely resolved | abort and name the unresolved target |
| 7 | Relationship impact analysis is blocked, incomplete, or unavailable | abort and write nothing |
| 8 | A direct mutation cannot preserve identifiers or untouched metadata | abort and preserve retained state |
| 9 | Candidate-generation input, originating Control, durable-state write, or action result is invalid | return Candidate-Generation Action Result `Blocked`, preserve the verified Control and catalog transaction, and write no partial NFR relationship |
| 10 | Controls has not returned `Collection Result: Finished`, or durable candidate state cannot be loaded by `CTLXXXXXX` | abort review without restoring transient state or invoking a second derivation |
| 11 | Candidate state is missing, reordered, or cannot produce one stable current candidate | abort with `Blocked` and preserve candidate state and accepted artifacts |
| 12 | A candidate decision is invalid, ambiguous, or cannot be retained | abort the review action and preserve all pre-review bytes |
| 13 | Review Complete is requested with an undecided candidate or any transaction step fails | abort with no NFR, catalog, identifier, or relationship write |
| 14 | Cancel Review cannot be completed without mutation | abort and preserve candidate, NFR, catalog, identifier, and relationship bytes |
| 15 | Setup Collection cannot begin the exact open-discovery question | return `Blocked` and do not claim collection completion |
| 16 | Evidence, context, suggestion, or unresolved-question handling is malformed or would expose more than one unresolved demand | abort with `Blocked`, preserve transient state, and write nothing |
| 17 | A proposal is unsupported, unconfirmed, or would expose persistence mechanics | discard the transient proposal and write nothing |
| 18 | Add persistence, duplicate detection, verification, or collection result is malformed; blocking reason is missing; or finish is not explicit | preserve the last verified baseline and return `Blocked` without claiming collection completion |
| 19 | Version increment, catalog regeneration, retained-output verification, or result reporting fails | abort with `Blocked`, preserve pre-operation bytes, and do not claim successful completion |

## Example

`/highway-nfrs Add an NFR requiring systems to remain available during a single availability-zone failure.`

The skill classifies the statement as an NFR, proposes a title and rationale for confirmation,
allocates the catalog's `next_id`, writes `controls: []`, increments the baseline MINOR version,
and regenerates the catalog.
