---
name: highway-controls
description: "Manages the repository-wide Control baseline, adding, updating, removing and replacing the Controls that govern the repository."
usage: "Invoke as `/highway-controls` and state what to change, for example `/highway-controls add a control requiring administrative access to use MFA`."
compatibility: all
metadata:
  version: 1.0.1
---

# highway-controls

## Purpose

Maintains the repository-wide Control baseline as a set of identified, versioned files the user owns.

## When to use

Use this skill to add, update, remove, or replace a Control.

Use it when a policy needs an identifier something else can cite — a design document, an audit
finding, or a later requirement.

After a valid new Control is created, use this skill to propose related NFRs for author review.
Controls are authoritative for initial derivation; the proposal is not an NFR until the author
decides what to accept.

Use it to ask what the current baseline contains, or what version it is at.

## When not to use

Do not use it to author non-functional requirements directly. Direct NFR authoring belongs to
`/highway-nfrs`; this skill owns only the deterministic proposal and review workflow that may
follow a newly added Control.

If a proposed statement describes an outcome, quality attribute, operational characteristic,
constraint, or business outcome rather than an enforceable implementation requirement, identify it
as an NFR and offer `/highway-nfrs`. After a Control is accepted, its derived proposal may populate
the reserved relationship fields only through the review workflow below.

Do not use it to record an intention or an aspiration. A Control states an obligation something can
be measured against.

Do not use it to edit a Control file by hand. Hand edits break the identifier record and the
baseline version together.

## Inputs

A statement of what to change, in the user's own words.

The Control baseline, read from `library/governance/` at the root of the project — a sibling of the
`.highway` directory, never inside it.

Where the `.highway` directory cannot be located, the project root cannot be determined and the
Controls directory cannot be placed. Abort and ask.

## Outputs

Satisfies `X1.1`, `X1.2`, `X2.1`, `X4.1`, `X5.1`, `X5.2` and `X6.1` of the Highway Experience
Standard.

Two artifacts, plus a statement of what changed.

**A Control file** at `library/governance/controls/CTLXXXXXX.md` following the complete structure
in `.highway/library/templates/output/control-record.md`, including frontmatter and body. The
template's placeholders remain user-owned values. A Control carries no version of its own; the
baseline holds the only version.

**A catalog** at `library/governance/controls.md`, listing every Control by identifier and title,
stating the baseline version, recording the next identifier to allocate, and stating that Controls
are managed through this skill rather than by hand.

The catalog is a function of the Controls and the recorded next identifier. No timestamp is
written, so an unchanged baseline produces an unchanged file.

Content under `library/governance/` belongs to the user. This skill writes there and judges
nothing about what a Control says.

## Control-Derived NFR Proposals

This section is the Control-derived NFR proposals contract.

The following workflow applies only after a valid new Control has been created. It is one-way:
the Control can propose an NFR, but an NFR never generates a Control in this phase. Existing NFR
records are not synchronized and relationship changes do not remove records.

### Deterministic candidate generation

- Normalize the new Control's title and statement for matching. The normalized title and statement
  are the only inputs; do not use a timestamp, randomness, environment value, existing catalog
  order, or unrelated baseline content.
- Evaluate the fixed rules in this order: availability, security, performance. A rule matches when
  its keyword appears in the normalized title or statement, and each match emits one candidate:
  `Availability and resilience`, `Access protection`, or `Performance budget` respectively.
- Render every candidate with the originating Control ID and title, candidate title, candidate statement,
  candidate rationale, and stable candidate order. A valid Control with no matching rule
  reports zero candidates and remains valid.

### Review barrier

- Present the complete ordered proposal before allocating an NFR ID or writing an NFR record,
  catalog entry, or relationship.
- For each candidate, ask the author to Accept, Modify, Replace, or Reject it. Modify and Replace
  require the complete author-approved title, statement, and rationale. A Cancel ends the review.
- Treat incomplete or ambiguous decisions as Cancel and write nothing. Rejected candidates write
  nothing. Only approved wording may proceed to the accepted-write workflow.

### Accepted derived write

For accepted candidates, validate the NFR baseline and catalog before writing anything. Read the
authoritative `next_id`, reject missing or malformed state and unsafe reuse, then process accepted
candidates in stable order:

- Allocate one immutable `NFRXXXXXX` identifier.
- Create the NFR with the approved title, statement, rationale, and identifier-only
  `controls: [CTLXXXXXX]` relationship.
- Append the new NFR ID to the originating Control's `nfrs` list, preserving existing IDs and
  avoiding duplicates.
- Regenerate the existing NFR catalog and report both relationship updates.

If a catalog, allocation, or relationship update cannot be completed safely, stop before derived
governance writes with zero partial writes. Do not create a relationship store or reverse-generate
Controls from NFRs, repair broken links, reconcile old records, or partially commit one side of a
relationship. Phase 4 may address those deferred concerns. Direct NFR authoring remains owned by
`/highway-nfrs` and starts with `controls: []`.

### The four actions

1. **Add** — allocate the recorded next identifier, write the Control, update the catalog. MINOR.
2. **Update** — rewrite one Control, keeping its identifier and anything not being changed. PATCH.
3. **Remove** — delete one Control and its catalog entry. MAJOR.
4. **Set** — replace the whole baseline, dropping Controls absent from the new one. MAJOR.

Exactly one version increment happens per action, whatever the action's size.

### Identifiers

An identifier is `CTL` followed by six digits. It is allocated once, and it MUST NOT be reused
after the Control carrying it is removed. It MUST NOT change once assigned.

The next identifier is read from the catalog, never computed from the files present. Computing it
would reissue the identifier of the highest-numbered Control after that Control was removed, and
anything citing it would silently come to mean something else.

### Before anything is lost

Remove and Set both destroy work the user may not be able to reconstruct.

Before either, invoke `/highway-relationships Impact` for the proposed Control removal or baseline
replacement. Resolve the relationship graph and name every lost relationship and affected artifact
by immutable identifier and title, including affected NFRs. A count MUST NOT be treated as
sufficient: a user cannot decide from "this removes 14 Controls" which fourteen they are. Then name
every Control that would be lost by identifier and title and get confirmation for the destructive
Control action.

If impact analysis is blocked, incomplete, or unavailable, abort and write nothing. Where destructive
confirmation is withheld, write nothing. `/highway-relationships` analyzes impact only; this skill
retains ownership of Control deletion, baseline versioning, and catalog regeneration.

## Verification

This self-check exercises `X1.1`, `X1.2`, `X2.1`, `X4.1`, `X5.1`, `X5.2` and `X6.1`.

- Confirm every Control file sits under `library/governance/`, and none under `.highway`.
- Confirm the identifiers in the catalog match the files present, with none missing or extra.
- Confirm the next identifier recorded in the catalog is greater than every identifier in use.
- Confirm an unchanged baseline rewrites to an identical catalog.
- Confirm the report names the action taken and the resulting baseline version.

## Error Handling

- The intended action is not decidable: abort, ask which action is meant, and write nothing.
- The Control meant is not decidable: abort, naming every candidate by identifier and title.
- The user may mean update or replace: abort, naming both readings.
- A referenced Control does not exist: abort, naming what was searched for. Do not add one instead.
- A Control would be removed: abort until the user confirms, naming it by identifier and title.
- The baseline would be replaced: abort until the user confirms, naming every Control lost.
- The catalog is absent but Control files exist: abort and ask. The next identifier cannot be
  recovered from the files, because the highest one present may not be the highest ever issued.
- The `.highway` directory cannot be found: abort and ask where the project root is.
- A Control file is malformed: abort, naming the file by path, and leave it untouched. It is the
  user's file.

## Example

A Control that states an outcome rather than an obligation gets advice, not a refusal.

```text
/highway-controls add a control that systems must be secure

"Systems must be secure" states an outcome, so nothing can be measured against it.
Consider instead:
  - Administrative access must require multi-factor authentication.
  - All data at rest must be encrypted.

Add one of these, your own wording, or the original as written?
```

Assessing a Control this way is advice. This skill MUST NOT refuse a Control the user still wants
after being advised. A skill that overrules its user gets bypassed, and the files are then edited
by hand — which loses the identifiers, the versioning, and the catalog together.

Where a proposed Control resembles an existing one, name that Control rather than reporting a
duplicate in the abstract.
