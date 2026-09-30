---
name: highway-controls
description: "Manages the repository-wide Control baseline, adding, updating, removing and replacing the Controls that govern the repository."
usage: "Invoke as `/highway-controls` and state what to change, for example `/highway-controls add a control requiring administrative access to use MFA`."
compatibility: all
metadata:
  version: 4.0.0
---

# highway-controls

## Purpose

Maintains the repository-wide Control baseline and owns adaptive conversational discovery of enforceable safeguards.

## When to use

Use this skill to configure or add a Control, inspect readiness, or update, remove, or replace an existing Control.
Use it to invoke deterministic Control-based NFR candidate generation after a successfully created new Control.

## When not to use

Do not use it to author non-functional requirements, including an outcome, quality attribute, operational characteristic, constraint, or business outcome, as a Control; offer `/highway-nfrs`.

This skill MUST NOT refuse a Control the user still wants after classification advice; preserve the
user-owned wording and continue through the explicit proposal route. [AS-6: .highway/governance/experience-standard.md#Non-goals]

Do not use it to edit a Control file or catalog by hand.

## Experience

User-visible interaction follows the Highway Experience Standard.

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
- declared external security, industry, regulatory, or governance expertise when available;
- `/highway-relationships` impact analysis for Remove or Set, including its named impact report and
  explicit empty-impact result; Controls consumes that report as authoritative relationship state
  and retains the existing confirmation and mutation safeguards.

Load only relevant accepted grounding before context-dependent output. Active user evidence remains
authoritative. accepted existing Controls and accepted Business Objectives provide governance and
outcome context; Identity, Vision, and Platform Objectives provide declared framing roles. Profile-owned `Blocked` remains distinct from unavailable optional context, and other unavailable optional context is excluded. External expertise grounds recommendations but does not establish policy, applicability, certification, or compliance.

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

Readiness reads only persisted Control state. At least one valid Control with a consistent baseline is
`Complete`; no valid Control is `Missing`; malformed or inconsistent state is `Blocked` with a
non-empty reason. Readiness writes no files, versions, IDs, relationships, or NFR artifacts.

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
mutations preserve the prior baseline and do not claim a new identifier or version. These fields
do not expose identifiers, versions, or transaction mechanics in a pre-persistence proposal. Controls does
not introduce a second mutation format.

Materially interpreted user-authored Controls use this review:

```markdown
**Here's what I've captured as your Control:**

**Title:**  
[Title]

**Statement:**  
[Statement]

**Why it matters:**  
[Rationale]

**Would you like to accept this Control?**
```

Selected recommendations are captured directly. The review contains no allocated identifier, catalog
mutation, version, or transaction mechanics.

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
Next Action: <owner route or None>
Blocking Reason: <reason or None>
```

`Succeeded` means the current Controls owner step succeeded. `Continue` means the Controls collection
remains active. `Finished` means the user explicitly ended the Controls collection. `Declined` means the
user declined the applicable owner action. `Aborted` means the current interaction ended without completing
the applicable owner action. `Blocked` requires a non-empty `Blocking Reason`; every other result uses
`Blocking Reason: None` except the explicit zero-Control finish below. `Finished` is Controls-specific
collection state, not a shared Owner Outcome, and `Continue` is non-terminal. `Declined` and `Aborted`
perform no Control write and do not permit Setup completion. This collection result remains separate
from the four-field Controls Readiness Result.

When the user explicitly finishes before accepting any Control, the terminal zero-Control result is exactly:

```text
Action Status: Succeeded
Collection Result: Finished
Next Action: /highway-controls setup
Blocking Reason: None
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
and terminates after its mutation result. `new` is not added by this contract. `view`, `show`,
`describe`, and `inspect` are equivalent read-only inspection requests. Update, Remove, and Set retain
their existing action contracts and do not enter Concern -> Condition -> Obligation discovery.

## Adaptive Control Discovery

`setup` and `configure` are aliases that open multi-Control conversational collection. Direct `add` creates one Control and returns its existing mutation result. `readiness`, inspection, update, remove, and set use their existing action contracts and do not enter discovery.

Ask for missing information, not missing phrasing. Concern, Condition, and Obligation are evidence
categories rather than questions that must each be asked.

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

When a Highway recommendation materially influences an accepted Control, preserve only the sources
that influenced that recommendation in the optional `## Recommendation Grounding` body section
governed by `control-record.md`; never place Recommendation Grounding in frontmatter. Recommendation
Grounding is lineage, not organizational policy, framework applicability, certification, or compliance,
and directly authored Controls omit it when no Highway recommendation materially influenced them.

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

After a successfully created Control in setup/configure, ask exactly:

**Are there any other concerns or safeguards you'd like to establish?**

If you'd like additional suggestions or help working through them, just let me know.

A direct Concern, Condition, or Obligation is evaluated immediately. An affirmative response without
new evidence asks one broad Concern question. A suggestion request invokes the existing suggestion
behavior, and `I don't know` or equivalent uncertainty begins guided discovery. Explicit finish returns
`Collection Result: Finished`. Pause, cancellation, or interruption ends the interaction using `New
interaction` resume semantics. Direct `add` does not display this prompt and terminates after its one
Control result.

Before presenting a user-override proposal, explain that the wording is not clear enough to check
whether it is being followed and offer one concrete refinement opportunity. If the user adopts the
refinement, re-evaluate normally. If the user explicitly retains the original wording after that advice,
enter the transient user-override route, preserve the exact user-approved Statement, and do not describe
it as measurable or Control-ready. Do not add a persisted classification or override field, and do not
let Rationale imply normal Control-quality sufficiency. Persist only after explicit acceptance of the
complete proposal.

## Proposal and Persistence

### Control Review Output Contract

Controls presents one complete materially interpreted user-authored proposal using the captured-Control
review above. Natural acceptance authorizes one existing Add transaction. Selected recommendations are
captured directly. Rejection, cancellation, abandonment, interruption, malformed input, and failed
validation write nothing. A user override preserves the exact approved Statement without adding a
classification field.

Revalidate the authoritative baseline, catalog, allocation state, and final-proposal overlap before
persistence. Name exact duplicates and decision-changing overlaps, invalidate prior acceptance, and
obtain renewed acceptance of the resulting complete proposal. Preserve permanent identifiers,
deterministic catalogs, identifier non-reuse, identifier-only `nfrs`, existing version semantics,
destructive impact analysis, and explicit confirmation for Remove and Set. Each accepted new Control is
one Add MINOR increment and one transaction. Reuse writes no record, relationship, identifier,
candidate, or version.

## Control-Derived NFR Candidates

Controls owns only the trigger after a successfully created new Control, deterministic initial
candidate derivation from that Control, the immutable originating `CTLXXXXXX` supplied to
`/highway-nfrs`, and consumption of the NFR owner's candidate-generation result. Derivation uses the
normalized title and statement in fixed availability, security, performance rule order and excludes
timestamp, randomness, environment, filesystem order, and session state.

Every successfully created new Control receives exactly one candidate-generation result.
Pause, cancellation, abortion, interruption, or a New interaction does not discard or duplicate that
result. Derivation begins only after Control creation succeeds; it does not run for
reuse, update, rejected proposals, failed creation, pre-existing Controls, or simply because a later
interaction begins.

The canonical `/highway-nfrs` contract owns candidate state, classification and review decisions,
accepted NFR persistence, identifiers, catalog, readiness, and completion claims. Controls does not
allocate NFR identifiers, create NFR records, mutate the NFR catalog or accepted relationships, or
declare NFR review outputs. Candidate review remains deferred until setup/configure returns
`Collection Result: Finished`. Controls consumes the owner result indicating zero candidates,
available candidates, or `Blocked` generation; a blocked result retains the created Control and writes
no partial NFR relationship. No candidate store or durable recovery state is created in Controls.

## Workflow

### Step 1: Classify action and baseline

Locate the authoritative Control baseline, classify the requested action, and preserve Missing,
Complete, and Blocked readiness semantics.

### Step 2: Load accepted grounding

Load relevant accepted Profile, Business Objective, existing Control, Highway framing, and declared
external expertise before context-dependent output.

### Step 3: Recommend or reuse

For setup/configure/add, reuse existing Controls and offer grounded recommendations when available.

### Step 4: Process user-authored evidence

Evaluate Concern, Condition, and Obligation as transient evidence, classify Control versus NFR, and
ask only for missing information.

### Step 5: Route or capture

Route NFR-shaped evidence to NFRs, capture selected recommendations directly, and review materially
interpreted user-authored Controls.

### Step 6: Revalidate and persist

Revalidate duplicates and overlap, then persist the accepted Control transaction atomically while
preserving identifier, catalog, and destructive-action safeguards.

### Step 7: Invoke NFR owner

After a successfully created new Control, invoke the NFR-owner candidate-generation action once and
consume only its declared result.

### Step 8: Continue or finish

For setup/configure, continue until explicit finish; direct add terminates after one Control.

### Step 9: Preserve ownership

Keep Control readiness and persistence with Controls and all NFR candidate lifecycle responsibilities
with `/highway-nfrs`.

## Verification

Confirm retained Controls follow the shared record and catalog templates, including optional body-only
Recommendation Grounding and unchanged frontmatter. Confirm readiness preserves Missing, Complete,
and Blocked semantics and remains separate from collection completion.

Confirm discovery asks for missing information rather than missing phrasing, stops when accepted
evidence supports a Control, preserves Control-versus-NFR classification, and keeps Concern,
Condition, and Obligation transient. Confirm recommendations use accepted context or declared
external expertise, do not imply applicability or compliance, preserve Recommendation Grounding only
when retained recommendation lineage materially influenced the Control, and selected recommendations
are captured directly.

Confirm materially interpreted user-authored Controls use the captured-Control review, Rationale is
synthesized, setup/configure uses the exact continuation wording, explicit finish ends collection,
and direct add remains single-Control. Confirm duplicate/overlap handling, identifiers, deterministic
catalogs, atomic persistence, and destructive safeguards remain intact.

Confirm post-write persistence verification and generic Constitution/Experience Standard restatements
are absent. Confirm a successfully created new Control invokes only the declared NFR-owner
candidate-generation boundary and that Controls does not duplicate NFR internals.

The verification checks are limited to the Control-specific contracts above. Generic Constitution,
Experience Standard, and development-governance checks remain owned by those documents.

## Error Handling

Use the Constitution's common failure model. Control-specific exceptions are:

- malformed Control record, catalog, or allocation state → Blocked without mutation;
- unresolved update or remove target → stop and identify the target;
- unresolved Control-versus-NFR classification → ask the bounded classification question;
- destructive Remove or Set → use the Experience Standard's confirmation behavior;
- NFR candidate-generation Blocked → preserve the successfully created Control, create no partial
  NFR relationship, and consume the NFR-owner result.

## Example

`/highway-controls configure`
