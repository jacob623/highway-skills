---
name: highway-objectives
description: "Manages the repository-wide Business Objective baseline and its stable traceability references."
usage: "Invoke as `/highway-objectives` and state whether to inspect, add, update, remove, or reset Business Objectives."
compatibility: all
metadata:
  version: 3.0.0
---

# highway-objectives

## Purpose

Maintains the repository-wide Business Objective baseline as user-owned, identified Markdown records
that explain the business direction later Highway artifacts may reference.

## Experience

User-visible interaction follows the Highway Experience Standard.

## When to use

Use this skill to set up, configure, inspect, add, create, update, remove, or reset Business
Objectives. The supported actions are exactly `setup`, `configure`, `view`, `show`, `describe`,
`readiness`, `add`, `new`, `update`, `remove`, and `reset`.

Use it when a user wants a durable objective with measurable success measures, a user-approved
rationale, or a stable `OBJ` reference for future Capability relationships.

Use `readiness` for a read-only assessment of whether the Objective baseline is usable. This
action owns Objective completeness and does not start setup or mutation.

## When not to use

Do not use this skill to author Controls, Non-Functional Requirements, Capabilities, or other
Highway governance baselines. Route those requests to their owning skill.

Do not edit an objective record or `library/governance/objectives.md` directly. Direct edits break
the permanent identifier, catalog, and baseline version together.

## Inputs

A plain-language request naming one supported action and, for a mutation, the desired objective
change.
The project root, identified by locating `.highway/`. If `.highway/` cannot be located, the
project root is unknown and no objective path may be guessed.

The user-owned objective records at `library/objectives/OBJXXXXXX.md`, never beneath `.highway`.

The user-owned catalog at `library/governance/objectives.md`, when a baseline exists. The catalog
is authoritative for `next_id` and the semantic baseline version.

The complete retained-record structure in `.highway/library/templates/output/objective-record.md`.
The template defines the required frontmatter and body ordering; its values remain user-owned.

The complete catalog structure in `.highway/library/templates/output/objective-catalog.md`.

Objectives is a Repository Context Participating Skill. Its declared Repository Context Documents
are Identity, Highway Vision, Highway Platform Objectives, and Profile. Identity supplies behavioral
framing only; Highway Vision supplies downstream traceability framing only; Highway Platform
Objectives evaluates Highway assistance only; Profile is the only declared source that may supply
accepted organizational evidence for Objective interpretation, recommendations, Highway Relevance, or
Rationale. Existing Objective records are accepted context for exact duplicate and semantic overlap
guidance, not a declared context document or a source of new organizational facts.

A Profile-owned Blocked result blocks Objective behavior that depends on accepted Profile evidence. An unavailable Profile remains distinct from a Profile-owned Blocked result and is not a source of organizational facts. An exact duplicate names the existing Objective and asks whether
to change it or create a distinct outcome; semantic overlap is advisory and never silently merges,
deletes, or rewrites an Objective.

## Outputs

A read-only status response, or a mutation report containing exactly these fields. Objective ownership remains authoritative for identifiers, records, catalogs, and completion claims. Confirmed
objective records follow the complete structure in `.highway/library/templates/output/objective-record.md`.

The `readiness` action emits exactly these four lines in this order:

```text
Status: <Complete, Missing, or Blocked>
Summary: <objective baseline explanation>
Next Action: <owner route or None>
Blocking Reason: <reason or None>
```

At least one valid Objective with a consistent catalog and `next_id` is `Complete`. No valid
records is `Missing`; a malformed record, catalog, or allocation state is `Blocked`. A blocked
response has a non-empty reason; every other response uses `Blocking Reason: None`. Readiness
does not write records, catalogs, or identifiers.

Mutation reports contain these fields in this order:

```text
Action: <action>
File: <changed file>
Summary: <change summary>
Affected Entries: <affected identifiers or None>
Confirmation Status: <Confirmed or non-write state>
Resulting Version: <version or unchanged>
```

Readiness does not write records, catalogs, or identifiers. The readiness state names are exact:
`Status: Missing` routes to `/highway-objectives setup`, `Status: Complete` has `Next Action: None`,
and `Status: Blocked` has `Next Action: None` plus a non-empty `Blocking Reason`.

Confirmed mutations write objective records beneath `library/objectives/` and regenerate the
catalog at `library/governance/objectives.md`. No objective record is ever written beneath
`.highway`.

The catalog contains the baseline version, `next_id`, an objective index ordered by permanent
identifier, each title and status, an ownership statement, and a warning not to edit the catalog
directly. No timestamp, random identifier, or environment-derived value is emitted.

## Action selection

Accept exactly these actions: `setup`, `configure`, `view`, `show`, `describe`, `readiness`, `add`, `new`,
`update`, `remove`, and `reset`. `view`, `show`, and `describe` are equivalent read-only actions.
`setup`, `configure`, `add`, and `new` are the guided creation workflow.

If the request contains an unsupported or ambiguous action, stop and ask the user to clarify. Do
not infer an action and do not write any file. If no objective baseline exists during a read-only
action, report its absence without creating an artifact.

For direct invocation, `/highway-objectives setup` and bare `/highway-objectives add` provide concise
direct invocation context explaining that the interaction identifies a Business Objective worth pursuing; they
do not claim Setup introduced the purpose or emit Setup's transition language. `/highway-objectives
add <evidence>` evaluates supplied evidence before selecting a question and skips the opening Business
Objective question when Business Objective evidence is already supported.

## Read-only workflow

For `readiness`, read and validate the complete baseline, classify it using the Objective rules,
and emit the exact four-field response without mutation. For `view`, `show`, or `describe`, read and validate the complete baseline, then report the
current version, objective count, and every objective identifier, title, and status in stable
identifier order. Do not modify objective files, the catalog, or any other file. The same bytes
must remain before and after the response.

## Creation and update workflow

For `setup`, `configure`, `add`, and `new`, begin with concise direct-invocation context when Setup
has not introduced the purpose. Use this opening only when no Objective evidence was supplied and no useful grounded recommendation is available:

**What's an important outcome you'd like to achieve?**

**If you're not sure, just say "I don't know," and we'll work through it together.**

When Success evidence is missing, ask **How would you measure success in [stated objective]?** When Highway Relevance is missing and an Organization Name has been accepted, ask **What role should technology play in helping [Organization Name] achieve this objective?** When Organization Name is absent and a Repository Name has been accepted, use that name where it reads naturally. When neither name has been accepted, ask the question without an inserted name. Evaluate each answer across Business Objective, Success, and Highway Relevance before asking another question.

Business Objective is what the organization wants to accomplish. Success is how the organization will know it succeeded. Highway Relevance is the context needed to connect the Objective to technology, governance, architecture, implementation, automation, or operations. Highway Relevance is not stored. The retained record uses ## Statement, ## Success Measures, and ## Rationale. Do not ask why an Objective is meaningful or important. Skip a Highway Relevance question when accepted Profile evidence and the active Objective evidence already establish useful downstream relevance.

Process supplied `/highway-objectives add` evidence before choosing a question. Evaluate all active
evidence across Business Objective, Success, and Highway Relevance, then select exactly one next action in this
order:

1. If Business Objective is unresolved, ask one conversational question about what the organization wants to accomplish.
2. Otherwise, if Success is unresolved, ask one Success question.
3. Otherwise, if unresolved Highway Relevance would improve downstream Highway use, ask one Highway Relevance question.
4. Otherwise, synthesize Rationale and present the Objective review.

Accept ordinary business language, uncertainty, activity descriptions, natural correction,
replacement, rejection, cancellation, abandonment, and multiple
dimensions in one answer. When multiple meaningful outcomes are present without explicit grouping,
ask whether to represent them together or separately. Preserve explicitly grouped outcomes and
retain explicitly separate outcomes in user-provided order for sequential processing. `I don't know` starts guided discovery and does not manufacture a
recommendation. When accepted Profile evidence supports a useful Objective, offer a Profile-grounded recommendation before asking an unnecessary question. Do not wait for a suggestion request. Prefer the accepted Organization Name. The user-authored path stays available. A selection of one, several, or all displayed recommendations is captured directly, without a second confirmation. Identity, Highway Vision, and Highway Platform Objectives stay framing sources and are not organizational facts. Existing Objectives are used for duplicate and overlap detection. Asking for more information about a
suggestion is not adoption. If Profile evidence cannot support a meaningful suggestion, ask `**What's an important outcome you'd like to achieve?**` and do not manufacture a recommendation.

Selected recommendations create Statement, Success Measures, and synthesized Rationale only from
the recommendation and its grounding evidence. Do not ask a separate Rationale question. If a
selected recommendation lacks enough accepted evidence for a required Success Measure, ask only the
unresolved Success question. The user-authored alternative remains available.
After a correction, re-evaluate staged Business Objective, Success, and Highway Relevance evidence and discard staged interpretations that no longer support the revised intent.

When Business Objective evidence supports a Statement and Success evidence supports at least one Success Measure, present the Objective review. Ask one Highway Relevance question only when unresolved
information would improve downstream Highway use. Otherwise synthesize Rationale from accepted evidence
and proceed to review. Business Objective and Success are sufficient for review. Highway Relevance does not independently block Objective creation.

**Here's what I've captured as your objective:**

[Objective Title]

[Statement]

**Success looks like:**
- [Success Measure]

**Why it matters:**  
[Rationale]

**Does this objective look right?**

Do not use this review for an Objective selected from displayed recommendations.

Rationale is synthesized from accepted evidence. Specifically, it uses accepted Business Objective,
Success, Highway Relevance, and applicable accepted Profile evidence without adding unsupported facts.
Highway Identity, Highway Vision, and Highway Platform Objectives are not organizational facts. Use a
concise rationale when that is all accepted evidence supports; do not ask a separate Rationale question.
Why it matters is not a fourth discovery dimension.

Do not expose an unallocated or newly allocated identifier, catalog change, or version in normal
pre-persistence review. Natural acceptance authorizes non-destructive creation without a second
persistence-confirmation question. Natural correction, replacement, rejection, cancellation,
abandonment, or interruption keeps the proposal transient and writes nothing.

During setup or configure, after a single captured Objective ask **Is there another objective you'd like to capture?** After a selection of several or all displayed recommendations, capture them together and ask that question once after a selection of several. A supplied Objective starts processing immediately. Yes without an Objective asks **What's another important outcome you'd like to achieve?** A suggestion request presents grounded recommendations. An explicit finish ends collection and returns the terminal owner result. Any other reply asks the continuation question again. Readiness becoming Complete does not end setup or configure. Direct add and new capture the selection and do not ask the continuation question.

For `update`, resolve exactly one existing objective by identifier and title before staging a
change. Preserve its identifier and every untouched field. Confirm the complete staged record and
catalog before writing. An update changes the baseline by exactly one PATCH increment.

## Destructive workflow

For `remove`, resolve the target before staging and show its identifier and title. Request explicit
confirmation before deleting the record and regenerating the catalog.

For `reset`, list every objective identifier and title that would be removed. Request explicit
confirmation before replacing the baseline. A count alone is not sufficient review.

A declined, ambiguous, malformed, or aborted remove/reset operation writes nothing. It preserves
every affected file byte-for-byte and leaves the baseline version and `next_id` unchanged.

## Baseline invariants and transactions

Read and validate the complete baseline before proposing any mutation. Every objective record must
be under `library/objectives/`, have a unique valid `OBJ` identifier, and contain `id`, `title`,
`status`, `capabilities: []`, statement, success measures, and rationale. Every catalog entry must
resolve to exactly one record. A catalog with objective files but no catalog, duplicate identifiers,
a missing catalog target, an invalid `next_id`, or a record outside `library/objectives/` is
malformed and must be rejected without overwriting user-owned content.

The catalog owns allocation state. `next_id` must be greater than every allocated identifier,
including identifiers whose records were removed. An identifier is permanent and is never reused, including after `reset`. Stable `OBJ` identifiers are reserved for future Capability
relationships.

Stage every mutation as a transaction: read and validate the complete baseline, re-evaluate the
final proposal and overlap, construct the
proposal, obtain natural user validation, revalidate the authoritative baseline and overlap state,
allocate one permanent identifier, construct record and catalog mutations, and persist both retained outputs as one successful atomic persistence. There is no post-write persistence verification.
Regenerate identical
catalog bytes from identical objective inputs, with stable identifier ordering and no timestamp,
random value, or environment value.

If pre-write revalidation discovers a new overlap, name the overlapping Objective and return to one
user decision. The previous creation confirmation is no longer active; if the proposal changes,
re-evaluate the staged Business Objective, Success, and Highway Relevance evidence, and present the
resulting complete proposal again and obtain renewed acceptance before persistence.

Increment the baseline exactly once per confirmed action: Add/New is MINOR, Update is PATCH, and
Remove/Reset is MAJOR. Failed or declined actions do not change the version. A confirmed mutation
report names the action, changed file, summary, affected entries, `Confirmation Status: Confirmed`,
and resulting version. A declined or failed report names the reason and the applicable non-write
confirmation state.

## Verification

- Retained Objective records follow `.highway/library/templates/output/objective-record.md`.
- Readiness and mutation outputs preserve their declared contracts.
- Business Objective, Success, and Highway Relevance are the current discovery dimensions.
- Recommendations are grounded primarily in accepted Profile evidence.
- Follow-ups are direct and tied to the stated Objective.
- Highway Relevance follow-ups stay relevant to technology, governance, architecture, implementation, automation, or operations.
- Setup and configure continue until explicit finish.
- Add and new remain single-Objective operations.
- Duplicate and overlap handling, permanent identifiers, catalog allocation, deterministic output, and atomic persistence remain intact.
- There is no post-write persistence verification.
- Generic Experience Standard and Constitution requirements are not restated.

## Error Handling

- A malformed Objective record, catalog, or allocation state is Blocked and is not mutated.
- An unresolved Objective target for update or remove stops and identifies the target.
- Destructive Objective removal or reset follows the Highway Experience Standard's destructive-confirmation behavior.

## Example

`/highway-objectives readiness`
