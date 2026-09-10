---
name: highway-objectives
description: "Manages the repository-wide Business Objective baseline and its stable traceability references."
usage: "Invoke as `/highway-objectives` and state whether to inspect, add, update, remove, or reset Business Objectives."
compatibility: all
metadata:
  version: 1.0.0
---

# highway-objectives

## Purpose

Maintains the repository-wide Business Objective baseline as user-owned, identified Markdown records
that explain the business direction later Highway artifacts may reference.

## When to use

Use this skill to set up, configure, inspect, add, create, update, remove, or reset Business
Objectives. The supported actions are exactly `setup`, `configure`, `view`, `show`, `describe`,
`add`, `new`, `update`, `remove`, and `reset`.

Use it when a user wants a durable objective with measurable success measures, a user-approved
rationale, or a stable `OBJ` reference for future Capability relationships.

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

## Outputs

A read-only status response, or a mutation report containing exactly these fields. Confirmed
objective records follow the complete structure in `.highway/library/templates/output/objective-record.md`.

```text
Action
File
Summary
Affected Entries
Confirmation Status
Resulting Version
```

Confirmed mutations write objective records beneath `library/objectives/` and regenerate the
catalog at `library/governance/objectives.md`. No objective record is ever written beneath
`.highway`.

The catalog contains the baseline version, `next_id`, an objective index ordered by permanent
identifier, each title and status, an ownership statement, and a warning not to edit the catalog
directly. No timestamp, random identifier, or environment-derived value is emitted.

## Action selection

Accept exactly these actions: `setup`, `configure`, `view`, `show`, `describe`, `add`, `new`,
`update`, `remove`, and `reset`. `view`, `show`, and `describe` are equivalent read-only actions.
`setup`, `configure`, `add`, and `new` are the guided creation workflow.

If the request contains an unsupported or ambiguous action, stop and ask the user to clarify. Do
not infer an action and do not write any file. If no objective baseline exists during a read-only
action, report its absence without creating an artifact.

## Read-only workflow

For `view`, `show`, or `describe`, read and validate the complete baseline, then report the
current version, objective count, and every objective identifier, title, and status in stable
identifier order. Do not modify objective files, the catalog, or any other file. The same bytes
must remain before and after the response.

## Creation and update workflow

For `setup`, `configure`, `add`, and `new`, ask exactly three separate prompts:

- `Describe the objective.` Record the answer as the statement and derive the proposed title
   deterministically from that answer.
- `What are the success measures?` Record the answer as success measures.
- Show the proposed rationale and ask: `Accept, modify, or replace?` Preserve the user's accepted,
   edited, or replaced rationale exactly as user-owned content.

For a new objective, read `next_id` from the catalog, allocate it once, and propose an `OBJ`
identifier followed by six digits. New records default to `status: active`, include
`capabilities: []`, and follow the complete structure in
`.highway/library/templates/output/objective-record.md`. Show the proposed identifier, title,
record content, catalog change, and resulting version before confirmation.

After a confirmed creation, ask whether another objective should be created. An affirmative answer
starts the same three-prompt workflow; a negative answer ends without another record. A declined or
aborted proposal writes nothing.

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
including identifiers whose records were removed. An identifier is permanent and is never changed
or reused, including after `reset`. Stable `OBJ` identifiers are reserved for future Capability
relationships.

Stage every mutation as a transaction: read and validate the complete baseline, construct proposed
records/catalog/version, show the proposal and confirmation state, then write only after explicit
confirmation. Write the records and catalog as one successful operation; if validation or writing
fails, preserve the original affected bytes. Regenerate identical catalog bytes from identical
objective inputs, with stable identifier ordering and no timestamp, random value, or environment
value.

Increment the baseline exactly once per confirmed action: Add/New is MINOR, Update is PATCH, and
Remove/Reset is MAJOR. Failed or declined actions do not change the version. A confirmed mutation
report names the action, changed file, summary, affected entries, `Confirmation Status: Confirmed`,
and resulting version. A declined or failed report names the reason and the applicable non-write
confirmation state.

## Verification

- Confirm objective records are under `library/objectives/`, never `.highway`, and the catalog is
  under `library/governance/objectives.md`.
- Confirm the ten supported actions route exactly as specified and unsupported or ambiguous input
  asks for clarification without a write.
- Confirm read-only actions report version, count, identifiers, titles, and statuses without byte
  changes, including when the baseline is absent.
- Confirm every record identifier is unique, permanent, six digits, and never reused; confirm
  catalog `next_id` is greater than every allocated identifier.
- Confirm every catalog entry resolves to one record and malformed baselines are rejected without
  overwriting user content.
- Confirm add/new/setup/configure use three separate prompts, preserve the user's final rationale,
  and create the complete retained record with `capabilities: []`.
- Confirm add/new, update, and remove/reset increment MINOR, PATCH, and MAJOR exactly once only
  after a confirmed successful mutation.
- Confirm declined, ambiguous, malformed, or aborted operations leave all affected bytes
  byte-for-byte unchanged.
- Confirm identical inputs regenerate identical catalog bytes and emitted artifacts contain no
  timestamp, random identifier, or environment-derived value.

## Error Handling

- The project root cannot be located: abort and ask where `.highway/` is located.
- An action is unsupported or ambiguous: abort, ask for clarification, and write nothing.
- The catalog is absent while objective records exist: abort and ask for catalog repair.
- A record, catalog entry, identifier, or `next_id` is malformed or inconsistent: abort, name the
  inconsistency, and leave all user-owned content untouched.
- A referenced objective does not exist: abort and name what was searched for.
- A destructive action lacks explicit confirmation: abort after the impact preview and write
  nothing.
- A mutation cannot complete as one staged transaction: abort and preserve the original bytes.

## Example

`/highway-objectives add Improve delivery reliability by reducing escaped defects.`

The skill asks for the objective statement, success measures, and rationale review, proposes a
deterministic title and the next permanent `OBJ` identifier, shows the record and catalog change,
then writes only after confirmation. It reports the confirmed action and resulting MINOR version.
