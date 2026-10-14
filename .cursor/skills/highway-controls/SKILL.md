---
name: highway-controls
description: "Manages the repository-wide Control baseline, adding, updating, removing and replacing the Controls that govern the repository."
usage: "Invoke as `/highway-controls` and state what to change, for example `/highway-controls add a control requiring administrative access to use MFA`."
compatibility: all
metadata:
  version: 5.0.0
---

# highway-controls

## Purpose

Maintains the repository-wide Control baseline as user-owned, identified Markdown records that define
 enforceable safeguards later Highway artifacts may reference.

## Experience

User-visible interaction follows the Highway Experience Standard.

## Response Support Text

Use the support text that matches the active interaction. Keep the Validation Question as the only
emphasized element in a Control review.

**Validation Question**

**What would you add, correct, or remove?**

A sharper question may replace it when it still invites correction rather than agreement.

**Acceptance Reassurance**

If this is accurate, just say so.

Use when reviewing a Control proposal.

**Discovery Reassurance**

If you're not sure, just say "I don't know," and we'll work through it together.

Use when the person is originating unresolved safeguard information without a grounded recommendation,
interpretation, or Working Idea.

**Combined Reassurance**

If this is accurate, just say so. If you're not sure, just say "I don't know," and we'll work through it together.

Use when either confirming a grounded proposal or not knowing is reasonable.

**Recommendation Reassurance**

If none of these fit, feel free to suggest your own safeguard.

Use whenever recommendations are presented. The user-authored path remains available and a
recommendation never requires adoption.

**Additional Suggestions Reassurance**

If you'd like additional suggestions, just let me know.

Use after recommendations, captured Controls, portfolio assessments, or other active collection
steps when future recommendation support remains available.

## Recommendation Development

Recommendations are grounded primarily in accepted Profile evidence, accepted Objectives, existing
Controls, and declared external expertise. When useful accepted context supports a recommendation,
offer a grounded safeguard recommendation before asking an unnecessary question:

- explain why it is relevant;
- keep the user-authored path available.

Recommendations remain Working Ideas until accepted.

## Control Coverage Areas

Control recommendations are currently derived primarily from accepted Profile and Objective evidence.

Expand recommendation generation to use two complementary recommendation sources:

1. Accepted Profile and Objective evidence.
2. Control Coverage Areas.

Context-derived recommendations remain the preferred source when accepted evidence clearly supports
specific safeguards.

Control Coverage Areas exist to improve recommendation coverage.

Control Coverage Areas:
- do not create organizational facts;
- do not establish organizational intent;
- do not imply organizational problems exist;
- do not replace context-grounded recommendations;
- remain recommendation-generation guidance only.

### Coverage Principle

Accepted Profile and Objective evidence may reveal safeguards tied to the organization's mission,
operations, technology use, or known constraints. Many useful safeguards are not visible in the accepted
context alone. Control Coverage Areas exist to surface commonly useful safeguard areas when accepted
evidence would not naturally reveal them.

### Coverage Areas

Use five recommendation areas.

##### Identity & Access

Safeguards governing identity, authentication, authorization, administrative access, and privilege.

##### Information Protection

Safeguards governing sensitive information, confidentiality, integrity, handling, and disclosure.

##### Change & Operations

Safeguards governing change control, maintenance, deployment, operational procedures, and continuity of work.

##### Resilience

Safeguards governing availability, recovery, fault tolerance, and response to disruption.

##### Monitoring & Accountability

Safeguards governing logging, monitoring, review, evidence, and accountability.

### Recommendation Generation

When possible, adapt coverage-derived recommendations to accepted Profile evidence, accepted Objectives,
and accepted Controls rather than presenting generic labels.

When generating recommendations:

1. Generate context-derived recommendations first.
2. Evaluate recommendation coverage across the five Control Coverage Areas.
3. Determine whether meaningful coverage gaps exist.
4. When useful coverage gaps exist, generate one or more coverage-derived recommendations.
5. Present context-derived and coverage-derived recommendations together as a single recommendation set.

Do not expose Coverage Areas to the user.

Do not ask the user to choose Coverage Areas.

Do not present Coverage Areas as categories or workflow concepts.

Users should only see recommended Controls.

### Coverage Evaluation

Before presenting recommendations, evaluate whether accepted recommendations are concentrated in one
safeguard area. The purpose is recommendation coverage rather than recommendation volume. Do not
manufacture recommendations simply to satisfy every area. Only surface coverage-derived recommendations
when they may reasonably benefit the organization.

### Recommendation Presentation

Coverage-derived recommendations must follow the same presentation contract as context-derived
recommendations. Do not distinguish recommendations by origin or reveal recommendation source,
coverage area, or internal coverage evaluation.

### Additional Suggestions

When a person requests additional suggestions, evaluate both:

- accepted Profile evidence;
- accepted Objective portfolio;
- accepted Control portfolio.

Additional suggestions may come from unaddressed accepted context, recommendation coverage gaps
identified through Control Coverage Areas, or meaningful gaps within the accepted Control portfolio.

Example:

Accepted Controls:
- Administrative access
- Sensitive information
- Audit logging

Reasonable additional suggestion:

- Validate Backups Regularly

The recommendation remains a Working Idea until adopted.

### Recommendation Boundaries

Control Coverage Areas:
- recommend;
- illuminate coverage gaps;
- expand recommendation diversity.

Control Coverage Areas do not:
- establish accepted Controls;
- establish organizational facts;
- establish organizational deficiencies;
- create readiness requirements;
- create lifecycle stages;
- change Control ownership, persistence, or acceptance behavior.

All recommended Controls remain Working Ideas until the person selects, modifies, or provides their
own Control and the normal Control Development Lifecycle continues unchanged.

## Control Development Lifecycle

Every Control follows the same development lifecycle:

Recommendation Selected or User Provided Control
↓
Present Converged Control proposal
↓
User Acceptance
↓
Capture
↓
Next Control

A Converged Control proposal contains:

- Control title;
- enforceable safeguard statement;
- synthesized Rationale.

The Control owner is expected to develop a complete first-pass Control proposal whenever accepted
Profile or Objective evidence reasonably supports one.

The person may:

- approve it;
- correct it;
- replace it;
- reject it.

The owner does not require the person to create the complete Control from scratch when accepted
evidence already supports a responsible proposal.

Control development should normally begin from a proposal rather than a question.

Conversational discovery remains available but is the exception path.

Use discovery when:

- accepted evidence cannot support a responsible Converged Control proposal;
- consequential ambiguity remains unresolved;
- safeguard ambiguity cannot be resolved responsibly.

Do not ask a discovery question when a grounded Converged Control proposal can reasonably be presented first.

When presenting the Converged Control proposal:

**Here's what I've captured as your Control:**

**Title:**
[Control Title]

**Statement:**
[Statement]

**Why it matters:**
[Rationale]

**What would you add, correct, or remove?**

## Control Queue and Acceptance Boundaries

Selection does not capture a Control. Selection identifies which Control should be developed next, and a
selected recommendation enters the active Control queue. Queue membership determines development order
only; Queue membership is not Control capture.

A Control is not captured until:

- the Converged Control proposal defined in the Control Development Lifecycle has been presented;
- the person has explicitly accepted it;
- the Control owner performs capture.

The owner MUST NOT transition directly from recommendation selection to Control capture.

Selected recommendations enter the active development queue and are never captured directly. Queue
membership determines development order only. Material revision invalidates prior acceptance and
requires a new correction or acceptance opportunity.

Illustrative queue interaction:

```text
User:
Capture all four.

Owner:
The four safeguards become the active Control queue in the selected order.

Selection does not capture them.

Each safeguard proceeds through the Control Development Lifecycle before capture.
```

## Interpretation Confidence

Prefer a grounded safeguard interpretation that can be corrected over a missing interpretation that
forces the person to create it from scratch. When accepted Profile or Objective evidence supports a
useful recommendation, implication, relationship, distinction, or Working Idea, do not ask a question
that merely seeks permission to express it.

## Control Contribution Guidance

When accepted Profile evidence, accepted Objectives, and accepted Controls support a useful contribution,
reveal one grounded observation at a time before asking an unnecessary exploratory question. The observation
may identify relationships, overlap, duplication, meaningful gaps, tensions, reinforcement, implications,
or focus observations. Do not manufacture one when accepted evidence does not support it. Keep
recommendations provisional and the user-authored path available.

## Control Portfolio Assessment Guidance

After multiple Controls are accepted, provide a concise advisory assessment when useful. It may
describe overlap, duplication, coverage, concentration, meaningful gaps, tensions, or reinforcement.
It does not reject Controls, force completion, block additional Controls, mutate the baseline, or
replace the person's authority. When no useful grounded non-duplicate recommendation remains, explain
coverage or overlap when useful and stop manufacturing recommendations.

After a Control is captured, the owner may provide a brief synthesis of the accepted Control set. The
synthesis should describe current coverage, explain how the newly accepted Control fits within the
portfolio, remain concise, and avoid repeating the full contents of accepted Controls. When processing
an active Control queue, it may also identify the next Control being developed.

The synthesis is advisory. It is not a second review, a second proposal, a recommendation set, or a
detailed portfolio assessment. It occurs only after capture, creates no lifecycle state or durable
portfolio artifact, and does not imply acceptance of a transient proposal.

#### Illustrative Post-Capture Continuity Examples

Queue transition:

```text
Your accepted Controls now provide strong protection for administrative access.

Next we'll develop Protect Sensitive Information.
```

Collection transition:

```text
Your accepted Controls now provide coverage across access control, information protection, and accountability.

If you'd like additional suggestions, just let me know.

Is there another safeguard you'd like to establish?
```

Setup transition:

```text
Your accepted Controls now provide coverage across access control, information protection, and operational accountability.

Now let's consider the operational expectations future solutions should meet.
```

## Control Recommendation Presentation

Keep the **Control** as the primary conversational anchor. When multiple recommendations are presented,
use visually distinct bullets with concise Control titles, short safeguard-oriented descriptions, and
obvious distinctions rather than a narrative paragraph. Explicitly support selecting one, several, or
all recommendations, modifying recommendations before adoption, providing a user-authored safeguard,
and requesting additional suggestions.

### Illustrative Recommendation Presentation Example

Based on your accepted context, these safeguards appear most relevant:

- **Require MFA For Administrative Access** Administrative access requires multi-factor authentication.
- **Protect Sensitive Information** Sensitive information must be protected from unauthorized access.
- **Maintain Audit Logging** Administrative and security-sensitive activity must be logged.
- **Validate Backups Regularly** Backup recovery procedures must be validated periodically.

Would you like to select one, several, or all of these safeguards, modify any of them, or provide your
own safeguard? If none fit, feel free to suggest your own safeguard. If you'd like additional
suggestions, just let me know.

## When to use

Use this skill to set up, configure, inspect, add, create, update, remove, or reset Controls. The
supported actions are exactly `setup`, `configure`, `view`, `show`, `describe`, `readiness`, `add`,
`new`, `update`, `remove`, and `reset`.

Use it when a user wants a durable enforceable safeguard or a user-approved Control statement. The
shared record `nfrs` field remains available for accepted relationships; Controls do not generate NFRs.

Use `readiness` for a read-only assessment of whether the Control baseline is usable. This action owns
Control completeness and does not start setup or mutation.

## When not to use

Do not use this skill to author Non-Functional Requirements, Business Objectives, Capabilities, or other
Highway governance baselines. Route those requests to their owning skill.
Do not use it to author non-functional requirements; route them to `/highway-nfrs`.

This skill MUST NOT refuse a Control the user still wants. It may explain overlap, safeguard ambiguity, or
quality concerns, but user authority remains the final acceptance boundary.

Do not edit a Control record or `library/governance/controls.md` directly. Direct edits break the permanent
identifier, catalog, and baseline version together.

## Inputs

A plain-language request naming one supported action and, for a mutation, the desired Control change.
The project root, identified by locating `.highway/`. If `.highway/` cannot be located, the project root
is unknown and no Control path may be guessed.

The user-owned Control records at `library/governance/controls/CTLXXXXXX.md`, never beneath `.highway`.

The user-owned catalog at `library/governance/controls.md`, when a baseline exists. The catalog is
authoritative for `next_id` and the semantic baseline version.

The complete retained-record structure in `.highway/library/templates/output/control-record.md`. The
template defines the required frontmatter and body ordering; its values remain user-owned.

The complete catalog structure in `.highway/library/templates/output/control-catalog.md`.

Controls is a Repository Context Participating Skill. Its declared Repository Context Documents are
Identity, Highway Vision, Highway Platform Objectives, Profile, and accepted Business Objectives.
Identity supplies behavioral framing only; Highway Vision supplies downstream traceability framing only;
Highway Platform Objectives evaluates Highway assistance only; Profile and accepted Business Objectives
supply accepted organizational context for Control interpretation and recommendations. Accepted Objectives
also provide operational context. Existing Controls are accepted context for exact duplicate and semantic
overlap guidance, not a source of new organizational facts.

Identity, Vision, and Platform Objectives provide shared, non-normative context only. Use accepted
Profile, accepted Business Objectives, accepted existing Controls, relevant connections, and active user
input as available context; active user input wins when context conflicts. Other unavailable optional
context is excluded. Context can inform interpretation, but cannot choose policy. A complete user-provided safeguard remains authoritative for its requested safeguard.

When a Highway recommendation materially influences an accepted Control, preserve only the sources
that influenced it in the optional `## Recommendation Grounding` body section governed by
`control-record.md`; never place Recommendation Grounding in frontmatter. Directly authored Controls
omit it when no Highway recommendation materially influenced them.

A Profile-owned `Blocked` result blocks Control behavior that depends on accepted Profile evidence. An
unavailable Profile remains distinct from a Profile-owned Blocked result and is not a source of
organizational facts. An exact duplicate names the existing Control and asks whether to change it or
create a distinct safeguard; semantic overlap is advisory and never silently merges, deletes, or rewrites
a Control.

## Outputs

A read-only status response, or a mutation report containing exactly these fields. Control ownership
remains authoritative for identifiers, records, catalogs, and completion claims. Confirmed Control records
follow the complete structure in `.highway/library/templates/output/control-record.md`.

The `readiness` action emits exactly these four lines in this order:

```text
Status: <Complete, Missing, or Blocked>
Summary: <Control baseline explanation>
Next Action: <owner route or None>
Blocking Reason: <reason or None>
```

At least one valid Control with a consistent catalog and `next_id` is `Complete`. No valid records is
`Missing`; a malformed record, catalog, or allocation state is `Blocked`. A blocked response has a
non-empty reason; every other response uses `Blocking Reason: None`. Readiness does not write records,
catalogs, identifiers, relationships, or NFR artifacts.

Mutation reports contain these fields in this order:

```text
Action: <action>
File: <changed file>
Summary: <change summary>
Affected Entries: <affected identifiers or None>
Confirmation Status: <Confirmed or non-write state>
Resulting Version: <version or unchanged>
```

### Control Review Output Contract

The review is shown before mutation for every materially interpreted user-authored proposal. It uses
the captured Title, Statement, Why it matters, and explicit acceptance prompt; it never claims that
review presentation allocated an identifier or changed the baseline.

Readiness state names and mutation fields are Control-specific. They do not expose an unallocated or
newly allocated identifier, catalog change, or version in normal pre-persistence review.

Controls Readiness Result is the four-field readiness response above. A read-only inspection with no
valid Control baseline emits:

```text
Status: Empty
Summary: No Control baseline exists.
Next Action: /highway-controls setup
Blocking Reason: None
```

Delegated `setup` and `configure` collection returns:

```text
Action Status: Succeeded|Declined|Aborted|Blocked
Collection Result: Continue|Finished
Next Action: <owner route or None>
Blocking Reason: <reason or None>
```

`Declined` and `Aborted` perform no Control write and do not permit Setup completion. `Finished`
requires explicit user finish intent and remains separate from readiness.
`Action Status: Blocked` is returned when required accepted context or baseline state prevents collection.

Confirmed mutations write Control records beneath `library/governance/controls/` and regenerate the
catalog at `library/governance/controls.md`. No Control record is ever written beneath `.highway`.

The catalog contains the baseline version, `next_id`, a Control index ordered by permanent identifier,
each title and status, an ownership statement, and a warning not to edit the catalog directly. No timestamp,
random identifier, or environment-derived value is emitted. An unchanged baseline produces
an unchanged catalog.

## Action selection

Accept exactly these actions: `setup`, `configure`, `view`, `show`, `describe`, `readiness`, `add`, `new`,
`update`, `remove`, and `reset`. `view`, `show`, and `describe` are equivalent read-only actions.
`setup`, `configure`, `add`, and `new` are the guided creation workflow.
`setup` and `configure` are aliases for the same guided Control collection behavior.

If the request contains an unsupported or ambiguous action, stop and ask the user to clarify. Do not
infer an action and do not write any file. If no Control baseline exists during a read-only action,
report its absence without creating an artifact.

For direct invocation, `/highway-controls setup` and bare `/highway-controls add` provide concise
direct-invocation context explaining that the interaction identifies an enforceable safeguard worth
establishing; they do not claim Setup introduced the purpose or emit Setup's transition language.
`/highway-controls add <evidence>` evaluates supplied evidence before selecting a question and skips the
opening Control question when Control evidence is already supported.

## Read-only workflow

For `readiness`, read and validate the complete baseline, classify it using the Control rules, and emit
the exact four-field response without mutation. For `view`, `show`, or `describe`, read and validate the
complete baseline, then report the current version, Control count, and every Control identifier, title,
and status in stable identifier order. Do not modify Control files, the catalog, or any other file. The
same bytes must remain before and after the response.

## Creation Workflow

For `setup`, `configure`, `add`, and `new`, begin with concise direct-invocation context when Setup has
not introduced the purpose. Use this opening only when no Control evidence was supplied and no useful
grounded recommendation is available:

**What concerns should future technology decisions take into account?**

**If you're not sure, just say "I don't know," and we'll work through it together.**

When accepted context supports useful recommendations, present recommendations. When accepted context
cannot support useful recommendations, begin exploratory discussion. Ask for missing information, not missing phrasing.

Evaluate all active evidence supporting the proposed safeguard. Concern, Condition, and Obligation remain
internal reasoning concepts and are not required conversation stages. When accepted evidence supports a
responsible Control proposal, hand off to the Control Development Lifecycle. Otherwise resolve the most
consequential remaining uncertainty.

Control meaning is an enforceable, auditable, or checkable safeguard. The retained record uses the
Control template's title, statement, rationale, and identifier-only `nfrs` relationships. Do not ask
why a Control is meaningful or important. Rationale is synthesized from accepted evidence.

Process supplied `/highway-controls add` evidence before choosing a question. Evaluate whether the
evidence supports a responsible proposal, and select exactly one next action:

1. If a responsible proposal is supported, synthesize Rationale and present the Control review.
2. Otherwise, resolve the most consequential remaining uncertainty with one bounded question.

Accept ordinary business language, uncertainty, activity descriptions, natural correction, replacement,
rejection, cancellation, abandonment, and multiple dimensions in one answer. When multiple meaningful
safeguards are present without explicit grouping, ask whether to represent them together or separately.
Preserve explicitly grouped safeguards and retain explicitly separate safeguards in user-provided order
for sequential processing. `I don't know` starts guided discovery and does not manufacture a recommendation.
Identity, Highway Vision, Highway Platform Objectives, Profile, and accepted Business Objectives remain
framing or accepted context sources and are not organizational facts. Existing Controls are used for
duplicate and overlap detection. If accepted context cannot support a meaningful suggestion, ask
`**What concerns should future technology decisions take into account?**` and do not manufacture a
recommendation.

Selecting several recommendations creates an active Control queue in the selected order. Selection
accepts the recommendation itself but does not constitute User Acceptance of the Control or capture.
When multiple recommendations are selected, process them sequentially through the Control Development
Lifecycle. If evidence is insufficient for Control development, continue the evidence question path
rather than creating a parallel lifecycle. The user-authored alternative remains available.

After a correction, re-evaluate staged safeguard evidence and accepted context. Discard interpretations
that no longer support the revised intent. Re-evaluate before continuing.

When accepted evidence supports a clear enforceable statement, evidence evaluation is complete enough to
hand off to the Control Development Lifecycle for review. Rationale is synthesized from accepted
evidence and applicable accepted context without adding unsupported facts.
Do not ask a separate Rationale question. The transient `user-override` route preserves the exact approved
Statement without adding a persisted routing field.

Do not expose an unallocated or newly allocated identifier, catalog change, or version in normal
pre-persistence review. Natural acceptance authorizes non-destructive creation without a second
confirmation or persistence-confirmation question. Natural correction, replacement, rejection,
cancellation, abandonment, or interruption keeps the proposal transient and writes nothing.

During setup or configure, after a single captured Control provide a concise coverage-aware synthesis
and ask **Is there another safeguard you'd like to establish?** After each queued Control is captured, continue with the next selected recommendation before
asking the collection continuation question. A supplied Control starts processing immediately. Yes without
new evidence asks **What other safeguard should future technology decisions follow?** A suggestion request
presents grounded recommendations. After recommendations, captured Controls, or a coverage assessment
while collection remains active, include Additional Suggestions Reassurance so future recommendation
support is explicit. Controls explicitly keep future recommendation support available until the person
explicitly finishes collection. An explicit finish ends collection and takes precedence over future
suggestion support. Any other reply asks the continuation question again. Readiness becoming Complete does
not end setup or configure. Direct add and new capture the selection and do not ask the continuation question.

## Update workflow

For `update`, resolve exactly one existing Control by identifier and title before staging a change.
Preserve its identifier and every untouched field. Confirm the complete staged record and catalog before
writing. An update changes the baseline by exactly one PATCH increment.

## Destructive workflow

For `remove`, resolve the target before staging and show its identifier and title. Request explicit
confirmation before deleting the record and regenerating the catalog.

For `reset`, list every Control identifier and title that would be removed. Request explicit confirmation
before replacing the baseline. A count alone is not sufficient review.

A declined, ambiguous, malformed, or aborted remove/reset operation writes nothing. It preserves every
affected file byte-for-byte and leaves the baseline version and `next_id` unchanged.

## Baseline invariants and transactions

Read and validate the complete authoritative baseline before proposing any mutation. Every Control record must be under
`library/governance/controls/`, have a unique valid `CTL` identifier, and contain the required fields
specified by `.highway/library/templates/output/control-record.md`. Every catalog entry must resolve to
exactly one record. A catalog with Control files but no catalog, duplicate identifiers, a missing catalog
target, an invalid `next_id`, or a record outside `library/governance/controls/` is malformed and must be
rejected without overwriting user-owned content.

The catalog owns allocation state. `next_id` must be greater than every allocated identifier, including
identifiers whose records were removed. An identifier is permanent and is never reused. The shared
record `nfrs` field remains available for accepted relationships; Controls do not generate NFRs.

Stage every mutation as a transaction: read and validate the complete baseline, re-evaluate the final
proposal and overlap, construct the proposal, obtain natural user validation, revalidate the authoritative
baseline and overlap state, allocate one permanent identifier, construct record and catalog mutations,
and persist both retained outputs as one successful atomic persistence. There is no post-write persistence
verification. Revalidate the authoritative baseline, catalog, allocation state, and final-proposal overlap before persistence. Regenerate identical catalog bytes from identical Control inputs, with stable identifier
ordering and no timestamp, random value, or environment value.

If pre-write revalidation discovers a new overlap, name the overlapping Control and return to one user
decision. The previous creation confirmation is no longer active; if the proposal changes, re-evaluate
the staged safeguard evidence, present the resulting complete proposal again, and obtain
renewed acceptance before persistence.

Each accepted new Control is one Add MINOR increment. Increment the baseline exactly once per confirmed action: Add/New is MINOR, Update is PATCH, and
Remove/Reset is MAJOR. Failed or declined actions do not change the version. A confirmed mutation report
names the action, changed file, summary, affected entries, `Confirmation Status: Confirmed`, and resulting
version. A declined or failed report names the reason and the applicable non-write confirmation state.

## Verification

- Retained Control records follow `.highway/library/templates/output/control-record.md`.
- Readiness and mutation outputs preserve their declared contracts.
- Recommendation generation and proposal development remain grounded in accepted context and safeguard meaning.
- Recommendations are grounded primarily in accepted Profile and Objective evidence.
- Follow-ups are direct and tied to the stated safeguard.
- Setup and configure continue until explicit finish.
- Add and new remain single-Control operations.
- Duplicate and overlap handling, permanent identifiers, catalog allocation, deterministic output, and atomic persistence remain intact.
- Reuse writes no record, relationship, identifier, or version.
- Identifier non-reuse is mandatory; allocated identifiers are never reused.
- Control capture has no NFR side effect, and independently managed NFRs remain outside Control capture.
- There is no post-write persistence verification.
- Generic Experience Standard and Constitution requirements are not restated.

## Error Handling

- A malformed Control record, catalog, or allocation state is Blocked and is not mutated.
- An unresolved Control target for update or remove stops and identifies the target.
- Destructive Control removal or reset follows the Highway Experience Standard's destructive-confirmation behavior.
- An unresolved safeguard ambiguity asks a bounded question without silently changing the owner.

## Example

`/highway-controls readiness`
