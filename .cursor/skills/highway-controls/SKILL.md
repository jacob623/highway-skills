---
name: highway-controls
description: "Manages the repository-wide Control baseline, adding, updating, removing and replacing the Controls that govern the repository."
usage: "Invoke as `/highway-controls` and state what to change, for example `/highway-controls add a control requiring administrative access to use MFA`."
compatibility: all
metadata:
  version: 3.0.0
---

# highway-controls

## Purpose

Maintains the repository-wide Control baseline and owns adaptive conversational discovery of enforceable safeguards.

## When to use

Use this skill to configure or add a Control, inspect readiness, or update, remove, or replace an existing Control.
Use it to derive deterministic Control-based NFR candidates after a verified new Control is persisted.

## When not to use

Do not use it to author non-functional requirements, including an outcome, quality attribute, operational characteristic, constraint, or business outcome, as a Control; offer `/highway-nfrs`.

This skill MUST NOT refuse a Control the user still wants after classification advice; preserve the
user-owned wording and continue through the explicit proposal route. [AS-6: .highway/governance/experience-standard.md#Non-goals]

Do not use it to edit a Control file or catalog by hand.

## Interactive Workflow UX Contract

Controls follows the Interactive Workflow UX Contract in the Highway Experience Standard. Put
`Next Action` first and omit implementation details unless requested. User Exits are `pause`,
`cancel`, and `stop responding`; Owner Outcomes are `declined`, `aborted`, and `blocked`.
`Resume Applicability` is `New interaction`. Controls retains ownership of Control artifacts,
proposals, catalogs, identifiers, persistence, readiness, and completion claims.

## Inputs

Controls consumes these dependencies:

- the user request and active interaction evidence;
- the project root located from `.highway/`;
- Control records under `library/governance/controls/`;
- the Control catalog at `library/governance/controls.md`;
- `.highway/library/templates/output/control-record.md`;
- `.highway/library/templates/output/control-catalog.md`;
- `.highway/library/knowledge/highway-identity.md`;
- `.highway/library/knowledge/highway-vision.md`;
- `.highway/library/knowledge/highway-platform-objectives.md`;
- `.highway/library/knowledge/profile.md`;
- accepted Business Objective records and catalog used as context;
- existing accepted Control records and catalog used for reuse, duplicate detection, and overlap;
- `.highway/governance/experience-standard.md`;
- the canonical `/highway-nfrs` owner contract, including its durable candidate-generation state,
  candidate-generation result (`Not Applicable`, `In Progress`, `Complete`, or `Blocked` with a
  non-empty reason), and the originating `CTLXXXXXX` supplied to that owner;
- `/highway-relationships` impact analysis for Remove or Set, including its named impact report and
  explicit empty-impact result; Controls consumes that report as authoritative relationship state
  and retains the existing confirmation and mutation safeguards.

Locate `.highway/` and the user-owned baseline at `library/governance/` before consuming these
dependencies. Context precedence is:

1. active user evidence;
2. accepted existing Controls;
3. accepted Profile;
4. accepted Business Objectives;
5. Identity, Vision, and Platform Objectives according to their declared framing roles.

Active user evidence remains authoritative for the active Control interaction.

Before producing context-dependent output, consult the available declared Repository Context Documents:
Identity, Vision, Platform Objectives, and Profile. Accepted Business Objectives and existing Controls may
also guide the conversation as accepted repository artifacts. Record each unavailable or malformed context
document, exclude it from interpretation, and continue only with remaining valid evidence.

Use context priority in this order: active user input, accepted existing Controls, accepted Profile, accepted Business Objectives, then Identity, Vision, and Platform Objectives framing. A malformed Profile is consumed as Profile-owned `Blocked`; other unavailable optional context is excluded.

## Outputs

Successful Control mutations retain Control records at `library/governance/controls/CTLXXXXXX.md` and the
Control catalog at `library/governance/controls.md`.

Retained Control records follow `.highway/library/templates/output/control-record.md` and the
catalog follows `.highway/library/templates/output/control-catalog.md`. No timestamp is written;
an unchanged baseline produces an identical catalog.

Controls Readiness Result emits exactly four lines:

```text
Status: Complete|Missing|Blocked
Summary: <Control baseline explanation>
Next Action: <owner route or None>
Blocking Reason: <reason or None>
```

Readiness reads only verified persisted Control state. At least one valid Control with a consistent baseline is `Complete`; no valid Control is `Missing`; malformed or inconsistent state is `Blocked` with a non-empty reason. Readiness writes no files, versions, IDs, relationships, or NFR artifacts.

Direct `add`, `update`, `remove`, and `set` emit the existing direct mutation result in this order:

```text
Action: Add|Update|Remove|Set
Outcome: Succeeded|Declined|Aborted|Blocked
Control ID: <allocated identifier or None>
Version: <resulting semantic Version or unchanged>
Blocking Reason: <reason or None>
```

`Control ID` is populated only when the existing mutation contract allocates one, and `Version` reports
the resulting semantic version after successful persistence. Declined, aborted, blocked, and failed
mutations preserve the prior verified baseline and do not claim a new identifier or version. These fields
do not expose identifiers, versions, or transaction mechanics in a pre-persistence proposal. Controls does
not introduce a second mutation format.

Control proposals emit these fields in this order:

```text
**Next Action:** Review this proposed Control and accept, correct, replace, or reject it.

**Title:**
<proposed user-approved title>

**Statement:**
<proposed Control statement>

**Rationale:**
<evidence-grounded rationale>
```

Labels are visually distinct from their values. `Next Action` is interaction framing and is not retained.
The proposal contains no allocated Control identifier, resulting version, catalog mutation, or transaction
mechanics.

Read-only inspection with no valid Control baseline emits:

```text
Status: Empty
Summary: No Control baseline exists.
Next Action: /highway-controls setup
Blocking Reason: None
```

This empty inspection result writes nothing, allocates no identifier, and changes no readiness state.

Delegated `setup` and `configure` collection returns this owner-only result in this exact order:

```text
Action Status: Succeeded|Declined|Aborted|Blocked
Collection Result: Continue|Finished
Created Control IDs: [CTLXXXXXX, ...]
Next Action: <owner route or None>
Blocking Reason: <reason or None>
```

`Succeeded` means the current Controls owner step succeeded. `Continue` means the Controls collection
remains active. `Finished` means the user explicitly ended the Controls collection. `Declined` means the
user declined the applicable owner action. `Aborted` means the current interaction ended without completing
the applicable owner action. `Blocked` requires a non-empty `Blocking Reason`; every other result uses
`Blocking Reason: None` except the explicit zero-Control finish below. `Finished` is Controls-specific
collection state, not a shared Owner Outcome, and `Continue` is non-terminal. `Declined` and `Aborted`
perform no Control write and do not permit Setup completion. `Created Control IDs` is the cumulative ordered
list of all persistence-verified new Control
IDs created in the active setup/configure interaction through the current result. After Control 1 it is
`[CTL000001]`; after Control 2 it is `[CTL000001, CTL000002]`; explicit finish reports the same cumulative
list, and zero creation reports `[]`. Reused, updated, rejected, failed, and pre-existing Controls are
excluded. This cumulative list remains transient, is never persisted or restored in a New interaction,
and is not durable NFR candidate recovery state. This collection result remains separate from the
four-field Controls Readiness Result.

When the user explicitly finishes before accepting any Control, the terminal zero-Control result is exactly:

```text
Action Status: Succeeded
Collection Result: Finished
Created Control IDs: []
Next Action: /highway-controls setup
Blocking Reason: No accepted Control exists.
```

The separate fresh Controls Readiness Result remains `Missing`; this result does not claim Controls or Setup
completion and does not advance to NFR review.

### Action selection

Controls selects exactly one supported action using this ordered table:

| Request evidence | Action |
|---|---|
| Explicit `readiness`, or asks whether the Control baseline is ready | `readiness` |
| Explicit `view`, `show`, `describe`, or `inspect` | inspection |
| Explicit `update` with an existing Control target | `update` |
| Explicit `remove` or `delete` with an existing Control target | `remove` |
| Explicit `set` or whole-baseline replacement | `set` |
| Explicit `setup` or `configure` | multi-Control conversational discovery |
| Explicit `add`, or a new Control obligation with no other action | one-Control conversational creation |
| Otherwise | abort and ask which supported action is intended |

`setup` and `configure` are aliases for multi-Control conversational discovery. `add` creates one Control
and terminates after its verified mutation result. `new` is not added by this contract. `view`, `show`,
`describe`, and `inspect` are equivalent read-only inspection requests. Update, Remove, and Set retain
their existing action contracts and do not enter Concern -> Condition -> Obligation discovery.

## Adaptive Control Discovery

`setup` and `configure` are aliases that open multi-Control conversational collection. Direct `add` creates one Control and returns its existing verified mutation result. `readiness`, inspection, update, remove, and set use their existing action contracts and do not enter discovery.

For direct `setup`, `configure`, or bare `add` with no usable Control evidence, emit exactly:

Controls helps define enforceable safeguards for future technology decisions.

Follow that sentence with the Controls-owned opening above. If direct invocation already contains usable
evidence, evaluate it first. A complete direct Obligation skips both the generic purpose sentence and the
generic opening. Direct invocation never claims that Setup introduced the purpose and never repeats the
Setup-owned transition.

After Setup has introduced the Controls purpose, and when no usable active Control evidence exists, Controls
opens with exactly:

**What concerns should future technology decisions take into account?**

For example, you might care about protecting information, controlling access, managing changes, keeping important services available, or meeting an existing obligation.

If you'd like some suggestions based on what Highway already knows, just let me know. **If you're not sure, just say "I don't know," and we'll work through it together.**

Evaluate directly supplied evidence before emitting this opening. If supplied evidence already contains a
Control-ready Obligation, skip the opening and proceed toward proposal. Do not repeat the Setup-owned
transition.

Controls evaluates all active evidence before selecting one next action. Concern, Condition, Obligation, classification, suggestions, proposal wording, continuation, and collection provenance are transient interaction state and are not retained or restored. `Resume Applicability: New interaction`.

Apply this ordered discovery model:

1. Resolve unclear grouping of multiple obligations with one grouping decision.
2. Classify clearly NFR-shaped versus Control-shaped intent.
3. If classification is genuinely ambiguous, ask one bounded classification question.
4. Evaluate the entire active response across Concern, Condition, and Obligation.
5. If an Obligation is already Control-ready, present the normal Control proposal.
6. Otherwise, if Concern is unresolved, ask one Concern question.
7. Otherwise, if resolving Condition can establish or narrow the Obligation, ask one Condition question.
8. Otherwise, ask directly for the Obligation.
9. After classification or refinement guidance, support explicit retention of vague wording as a transient
  user-override route.

A Control-ready Obligation is one the user states, adopts, or reuses that is clear enough to check whether
it is being followed. Do not infer Concern or Condition merely to populate the internal model when the
Obligation is already Control-ready.

Clearly NFR-shaped intent routes to `/highway-nfrs`. This includes intent that remains an outcome, quality
attribute, operational characteristic, constraint, or business outcome rather than an enforceable
implementation requirement. When evidence could reasonably represent either an NFR or a Control, ask one
bounded classification question rather than choosing silently. Conversational use of the word `constraint`
alone is not sufficient to classify intent automatically. Do not reject a user-owned Control solely because
Highway recommends clearer wording; preserve the explicit user-override route.

Condition, Safeguard, Requirement, and Constraint are conversational terms only. They do not create
persisted `type` fields, enums, new state machines, or additional required discovery dimensions. Only
Concern, Condition, and Obligation are internal discovery dimensions, and they remain transient. The
retained Control structure remains the structure governed by `control-record.md`: identifier,
user-approved title, status, `nfrs`, statement, and rationale.

Before single-Control discovery, inspect the active response for multiple distinct obligations. Preserve
explicit user grouping. When obligations are explicitly separate, process them sequentially in user-provided
order. When grouping is unclear, ask exactly one grouping question and do not partially refine one
obligation before resolving that decision.

Never expose discovery dimensions as progress labels. Ask at most one unresolved response-demanding question or decision. Formal language is accepted at its supplied level; ordinary business language and technically mature language receive evidence-appropriate guidance without persona inference, unnecessary jargon, or simplification. Suggestions are transient, grounded in accepted context, limited to one through three possibilities, and labeled as possibilities. When a recommendation or suggestion is grounded in Repository Context, its user-visible explanation identifies the applicable source at the user-relevant level, such as the accepted Profile, an accepted Business Objective, an existing Control, or Highway Vision when it directly supplies the framing. Do not expose repository paths, loading or retrieval mechanics, evaluation order, or internal source-selection logic, and do not cite unrelated context. If no relevant Repository Context grounds the recommendation, do not fabricate a source. With no grounded suggestions emit exactly `Highway does not have enough accepted context to make a useful suggestion.` and ask one exploratory question. Do not ask a ceremonial question solely to acknowledge or load context.

When active evidence conflicts with context, active user input wins. Context may identify, prioritize, explain,
suggest, surface relevant connections, or identify overlap; it cannot choose policy or create a persisted
relationship. Existing Controls are surfaced for reuse before redundant governance is proposed. When context
has Material Influence because it changes a recommendation, governance interpretation, decision support,
relevant-connection guidance, workflow action, or generated artifact outcome, provide one concise
Contextual Acknowledgment before the affected question, decision, or proposal. Do not add an
acknowledgment-only question when active evidence already satisfies the decision criteria.

When an answer affects a downstream recommendation, governance interpretation, proposal, relevant connection,
or workflow action, provide concise Decision Context explaining why the answer matters, unless that implication
was established immediately before the prompt. Provide one concise Relevant Example when it clarifies the
kind of response sought; adapt it to active evidence and present it as illustrative rather than as required
policy. Do not expose unrelated context or turn examples into mandatory categories.

When Profile is owner-Blocked, the active Profile-dependent action returns `Action Status: Blocked`
with the owner-provided reason. Other unavailable optional context is excluded. A complete direct obligation is not blocked by absent optional context. Applying context does not create an additional
question when active evidence already supports the decision.

After a successful verified creation in setup/configure, ask exactly:

**Would you like to define another Control, ask for suggestions, or finish?**

A direct Concern, Condition, or Obligation is evaluated immediately. An affirmative response without
new evidence asks one broad Concern question. A suggestion request invokes the existing suggestion
behavior, and `I don't know` or equivalent uncertainty begins guided discovery. Explicit finish returns
`Collection Result: Finished`. Pause, cancellation, or interruption ends the interaction using `New
interaction` resume semantics. Direct `add` does not display this prompt and terminates after its one
verified Control result.

Before presenting a user-override proposal, explain that the wording is not clear enough to check
whether it is being followed and offer one concrete refinement opportunity. If the user adopts the
refinement, re-evaluate normally. If the user explicitly retains the original wording after that advice,
enter the transient user-override route, preserve the exact user-approved Statement, and do not describe
it as measurable or Control-ready. Do not add a persisted classification or override field, and do not
let Rationale imply normal Control-quality sufficiency. Persist only after explicit acceptance of the
complete proposal.

## Proposal and Persistence

### Control Review Output Contract

Controls presents one complete Control proposal at a time with Title, Statement, and Rationale.
Proposal decisions are Accept, Correct, Replace, Reject, or Cancel. Natural acceptance authorizes
one existing Add transaction. That Control is persisted and verified independently; setup/configure
then continues to another Control or explicit finish. Direct `add` terminates after the one verified
Control result. Rejection, cancellation, abandonment, interruption, malformed input, and failed
validation write nothing.

Present a normal proposal with this interaction framing first:

```text
**Next Action:** Review this proposed Control and accept, correct, replace, or reject it.

**Title:**
[title]

**Statement:**
[statement]

**Rationale:**
[rationale]
```

Presentation labels are visually distinct from their values. `Next Action` remains interaction framing,
not a retained Control field. Do not expose identifiers, catalog changes, versions, or transaction mechanics before acceptance. A user
override preserves the exact approved Statement but is never described as measurable and adds no
classification field. Generated transient Control titles do not depend on timestamps, randomness,
environment values, filesystem order, or session state. The generated title remains transient until the
user accepts the proposal.

Before allocation, revalidate the authoritative baseline, catalog, allocation state, and final-proposal overlap. Name exact duplicates and decision-changing overlaps, invalidate prior confirmation, and require renewed validation; unrelated overlap does not invalidate confirmation. Preserve permanent `CTLXXXXXX` identifiers, deterministic catalogs, identifier non-reuse, identifier-only `nfrs`, existing version semantics, destructive impact analysis, and explicit confirmation for Remove and Set.

Verify every retained output before claiming creation. A failure preserves the prior verified baseline byte-for-byte and names the unverified output. Each accepted new Control is one Add MINOR increment and one transaction. Reuse writes no record, relationship, identifier, candidate, or version.

## Control-Derived NFR Candidates

Controls owns only the trigger after a new Control is persistence-verified, deterministic initial
candidate derivation from that verified Control, the immutable originating `CTLXXXXXX` supplied to
`/highway-nfrs`, and consumption of the NFR owner's candidate-generation result. Derivation uses the
normalized title and statement in fixed availability, security, performance rule order and excludes
timestamp, randomness, environment, filesystem order, and session state.

Every persistence-verified new Control receives exactly one durable candidate-classification result.
Pause, cancellation, abortion, interruption, or a New interaction does not discard or duplicate that
result. Derivation begins only after Control persistence verification succeeds; it does not run for
reuse, update, rejected proposals, failed creation, pre-existing Controls, or simply because a later
interaction begins.

The canonical `/highway-nfrs` contract owns candidate state, classification and review decisions,
accepted NFR persistence, identifiers, catalog, readiness, and completion claims. Controls does not
allocate NFR identifiers, create NFR records, mutate the NFR catalog or accepted relationships, or
declare NFR review outputs. Candidate review remains deferred until setup/configure returns
`Collection Result: Finished`. Controls consumes the owner result indicating zero candidates,
available candidates, or `Blocked` generation; a blocked result retains the verified Control and writes
no partial NFR relationship. No candidate store or durable recovery state is created in Controls, and
transient `Created Control IDs` are not used as recovery state.

## Workflow

### Step 1: Locate and classify

Locate `.highway/`, the authoritative Control records and catalog, the requested action, and required
owner state. An absent Control baseline is a valid `Missing` state: readiness emits `Status: Missing`,
inspection emits the declared empty inspection result, and setup/configure/add continues through the
appropriate creation flow without creating a placeholder Control.

### Step 2: Select action

After Step 1, evaluate the ordered Action Selection table and select exactly one supported action.

### Step 3: Consult declared context

For setup/configure/add discovery, after Step 2 consult available declared context before producing
context-dependent output. Record unavailable optional context and exclude it.

### Step 4: Classify and collect

After Step 3, resolve obligation grouping and Control-vs-NFR classification, then evaluate Concern,
Condition, and Obligation evidence with at most one unresolved question or decision.

### Step 5: Build and present proposal

After Step 4 reaches normal Control-ready evidence or an explicit override route, present one complete
Control proposal.

### Step 6: Revalidate, persist, and verify

After Step 5 acceptance, revalidate authoritative state and overlap, perform one Add transaction, and
verify every covered retained Control output.

### Step 7: Derive NFR candidates

After Step 6 succeeds for a new Control, invoke deterministic candidate derivation and consume the
canonical `/highway-nfrs` owner candidate-generation result.

### Step 8: Continue or finish

After Step 7, setup/configure asks the exact continuation question. Direct Add terminates instead of
opening multi-Control continuation.

### Step 9: Preserve ownership

After Steps 1 through 8, preserve Controls ownership and defer NFR-owned responsibilities to
`/highway-nfrs`.

## Verification

Confirm every Control is under `library/governance/`, catalog identifiers match records, the next identifier
is safe, an unchanged baseline produces an identical catalog, and a transaction failure preserves all
affected bytes. Record absent or malformed declared context in the verification result and confirm it was
excluded without substituted content. Confirm setup/configure emits the Controls Action Result according
to its declared contract and that readiness remains a separate persisted-baseline result. Confirm Controls
does not infer collection completion from readiness `Complete`, and that explicit finish ends collection.

Verify the exact purpose sentence, exact Controls opening, supplied Obligation bypass, Concern-only and
Concern-plus-Condition discovery, complete Obligation direct-to-proposal, ambiguous and clearly NFR-shaped
routing, multiple-obligation grouping, one unresolved question or decision, no discovery progress labels,
the exact zero-suggestion fallback, suggestion adoption boundary, and active-user context precedence.
Verify reuse without mutation, exact duplicate and semantic overlap handling, the user-override advice,
refinement, retention, and acceptance path, the exact continuation prompt, direct Add termination,
non-terminal `Continue`, explicit `Finished`, and New interaction reset.

Verify one Add MINOR increment per accepted Control, persistence verification before creation completion,
candidate derivation only after verification, no derivation for reuse/update/rejection/failure/pre-existing
Controls, durable candidate survival without duplicate derivation, blocked generation retaining the Control
without a partial NFR relationship, and NFR-owned review/persistence. Verify successful Control mutations
write only `library/governance/controls/CTLXXXXXX.md` and `library/governance/controls.md`. Verify the
declared direct mutation result fields and order for Add, Update, Remove, and Set, and verify the declared
proposal fields and order. Verify the Controls Action Result, Readiness Result, unchanged mutation results,
empty inspection result, and exact zero-Control terminal result. Preserve deterministic catalog bytes and
absent or malformed context handling.

The Feature 094 compliance review evaluates these phases separately: adaptive discovery, proposal
validation, Control persistence, destructive actions, read-only readiness/inspection, Control-derived NFR
candidate generation, and the deferred NFR review boundary. The review explicitly includes, according to
applicability, P11.1-P11.5, P12.1-P12.5, X1.6, and X2.2-X2.10. For every applicable P or X rule, record
exactly `PASS`, `FAIL`, or `N/A` with the evidence required by the Constitution and permitted N/A
conditions. List human-review items separately in `DEFERRED`. Release requires zero `FAIL` and no
unresolved required `DEFERRED` entry. Use the authoritative Constitution Compliance Review Protocol
without duplicating that full normative protocol here.

Because Controls handles authentication, authorization, input handling, and retained file writes, the
Security Gate applies. Security-affecting guidance is grounded by [AS-2: A03:2021 Injection], does not
disable verification or bypass input validation, and requires suspected vulnerabilities to be reported
rather than silently altered. The Maintainability Gate also applies: when implementation work modifies
retained source/code files and comments are applicable, require a comment only when it states intent not
already expressed by adjacent content. Never insert comments into user-owned Control statements or
rationales merely to satisfy the gate, and keep retained structure governed by the shared Control template.

### Security Gate check

`Security Gate Check: verify the skill contains [AS-2: A03:2021 Injection], contains no instruction to disable verification or bypass input validation, and maps suspected-vulnerability handling to Error Handling.`

### Maintainability Gate check

`Maintainability Gate Check: verify retained-source/code comment guidance requires comments only for intent not expressed by adjacent content and never requires comments that merely restate adjacent content.`

## Error Handling

Every Workflow step has one mapped action. `fall back` destinations are named workflow steps or owner
identifiers.

| Step | Failure detection condition | Action | Destination or result |
|---|---|---|---|
| 1 | The required project root cannot be resolved from the declared input | escalate | Obtain the project root before continuing |
| 1 | A required declared input other than the project root is absent or self-contradictory | escalate | Obtain clarification before continuing |
| 1 | A supplied project root has been resolved and does not contain the required `.highway/` structure | abort | Report the actionable path and context |
| 2 | Action is unsupported or ambiguous | abort | Action selection |
| 3 | Profile owner is `Blocked` for a Profile-dependent action | abort | Controls Blocked result using the Profile-owner reason, without reclassifying Profile |
| 3 | A declared owner result is malformed | abort | Blocked owner result with the concrete reason |
| 4 | The user's discovery input is malformed and an additional attempt remains | retry | Step 4; maximum 1 additional attempt |
| 4 | The user's discovery input is malformed and the retry limit is exhausted | abort | Non-success result; preserve retained state |
| 4 | A declared owner result is malformed | abort | Blocked owner result with the concrete reason; do not retry as user discovery |
| 4 | Control-vs-NFR classification remains unresolved after evaluating the supplied evidence | fall back | Step 4 bounded user classification question; NFR choice routes to `/highway-nfrs`, Control choice continues discovery, and malformed ambiguity uses the Step 4 retry path |
| 5 | Proposal requires invented facts | abort | Step 4 |
| 5 | User rejects, cancels, abandons, or interrupts | abort | New interaction with no write |
| 6 | Pre-write revalidation discovers an exact duplicate or semantic overlap that changes the proposal decision | fall back | Step 5 for renewed user validation; name the overlapping Control, invalidate prior confirmation, re-evaluate changed evidence, present the complete proposal again when required, and require renewed acceptance |
| 6 | Persistence fails | abort | Prior verified baseline, no write claim |
| 6 | Persistence verification fails | abort | Prior verified baseline and named unverified output |
| 3 | An optional declared Repository Context source is unavailable or malformed | fall back | Step 4 with that source recorded as unavailable and excluded from interpretation |
| 7 | The canonical NFR owner returns `Blocked` for candidate generation after the new Control has been persistence-verified | abort | For setup/configure, return the exact five-field result: `Action Status: Blocked`; `Collection Result: Continue` because `Finished` requires explicit user intent; `Created Control IDs: <cumulative active-interaction list including the verified Control>`; `Next Action: None`; `Blocking Reason: <non-empty NFR-owner reason>`. Preserve the verified Control and catalog transaction, write no partial NFR relationship, and claim no downstream NFR completion. For direct `add`, preserve the verified Add result while surfacing the blocked downstream NFR condition according to the direct mutation contract |
| 8 | Continuation input is malformed and an additional attempt remains | retry | Step 8; maximum 1 additional attempt |
| 8 | Continuation input is malformed and the retry limit is exhausted | abort | Abort the active interaction under New interaction semantics |
| 9 | Unsupported ownership transfer is requested | abort | `/highway-nfrs` owner boundary |
| 6 | A suspected vulnerability is discovered during Control processing | abort | Report the suspected vulnerability, do not silently alter it, and preserve affected retained state until the owning workflow or user resolves it |

## Example

`/highway-controls configure`
