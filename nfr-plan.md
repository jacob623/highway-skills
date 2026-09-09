/speckit.specify I want to create a skill named `/highway-nfrs` that manages repository-wide Non-Functional Requirements (NFRs).

The purpose of this skill is to maintain the global NFR baseline used by the Highway framework. NFRs define desired quality attributes, operational characteristics, and outcomes that solutions described within the repository are expected to achieve.

This is the second half of Phase 7 of the governance model. `/highway-controls` now exists and
manages the Control baseline, so Controls are no longer hypothetical. What remains deferred is the
**relationship** between the two: an NFR reserves a `controls` field and nothing populates it yet.

The skill shall be designed with the assumption that a future version of Highway will associate
NFRs with Controls, and that every NFR will eventually be expected to have one or more associated
Controls. For now the two baselines are independent artifacts with reciprocal reserved fields.

**Decisions already settled by `/highway-controls`, which this skill inherits rather than
revisits:**

| Question | Settled answer |
|---|---|
| Where files live | `library/governance/` at the **project root**, a sibling of `.highway/`, never inside it |
| File format | YAML frontmatter and a Markdown body, in `.md` |
| Catalog format | A generated prose index, carrying no timestamp |
| Identifier allocation | A `next_id` recorded in the catalog, so removal cannot free an identifier |
| Per-item versioning | **None.** The baseline carries the only version |
| Destructive actions | Confirm first, naming every item that would be lost |

Deviating from any of these would leave two governance skills behaving differently for no reason a
user could predict.

## Managed Files

The skill shall maintain, at the **project root** — a sibling of `.highway/`, never inside it:

```text
library/governance/
├── nfrs.md
└── nfrs/
    ├── NFR000001.md
    ├── NFR000002.md
    └── ...
```

This location is what keeps a user's own governance out of reach of Highway's authoring rules.
Content under `.highway/library/governance/` is judged against the Highway Skills Constitution;
content at the project root is not.

### nfrs.md

The NFR catalog shall:

- State that it defines the repository-wide NFR baseline.
- Explain that NFRs apply globally unless explicitly superseded by consuming artifacts.
- Instruct users to manage NFRs using `/highway-nfrs`.
- Warn users not to edit generated files directly.
- Contain the current semantic version of the baseline.
- Record the next identifier to allocate.
- Provide an index of all NFRs.

The catalog shall carry **no timestamp**, so an unchanged baseline regenerates to an identical
file and staleness is detectable rather than invisible.

### Individual NFR Files

Each NFR shall be stored in its own file:

```text
library/governance/nfrs/NFRXXXXXX.md
```

Each NFR file shall carry YAML frontmatter and a Markdown body.

Frontmatter:

- NFR ID
- Title
- Status
- A reserved `controls` field for future Control relationships

Body:

- The NFR statement
- Its rationale

An NFR shall **not** carry a version of its own. The baseline holds the only version, for the same
reason it does in the Control baseline: two counters over one set of content can disagree, with
nothing to say which is authoritative.

Example:

```text
---
id: NFR000001
title: Availability
controls: []
status: active
---

Systems must remain available to their users during a single availability-zone failure.

Unplanned downtime costs more than the redundancy that avoids it, and the loss falls on the
service owner rather than on the team that chose the topology.
```

The `controls` field shall exist even though Control relationship management is not yet
implemented. It mirrors the `nfrs` field already reserved on every Control.

## Supported Actions

The skill shall support the following actions.

### Set

Replace the entire NFR baseline.

When a user performs a Set action:

- Every NFR that would be lost shall be named, by identifier and title, before anything is written.
- Confirmation shall be obtained. A count is not sufficient notice: a user cannot decide from "this
  removes 14 NFRs" which fourteen they are.
- Where confirmation is withheld, no file shall change.
- NFRs not present in the new baseline shall then be removed.
- The NFR catalog shall be regenerated.
- The baseline version shall increment by a MAJOR step.

Example:

```text
Set the global NFRs to:
...
```

### Add

Add a new NFR.

When adding an NFR:

- Take the next identifier recorded in the catalog, then advance it.
- Create a new NFR file.
- Initialize the Control relationship field as empty.
- Update the NFR catalog.
- Increment the baseline version by a MINOR step.

Example:

```text
Add an NFR requiring systems to be highly available.
```

### Update

Modify an existing NFR.

When updating an NFR:

- Preserve the existing NFR ID.
- Preserve any metadata the change does not touch.
- Update the NFR definition.
- Increment the baseline version by a PATCH step where the obligation is unchanged.

Example:

```text
Update NFR000012 to require 99.95% availability.
```

### Remove

Remove an existing NFR.

When removing an NFR:

- Name the NFR by identifier and title, and obtain confirmation before deleting anything.
- Remove the NFR from the catalog.
- Remove the associated NFR file.
- Leave the recorded next identifier untouched, so the retired identifier is never reissued.
- Increment the baseline version by a MAJOR step, because something outside this repository may
  cite the identifier.

Example:

```text
Remove NFR000012.
```

## NFR Requirements

An NFR must define a desired quality attribute, operational characteristic, constraint, or business outcome.

NFRs must:

- Describe what must be achieved rather than how it is achieved.
- Be technology agnostic whenever possible.
- Represent qualities that may be satisfied by one or more Controls.
- Apply across the repository unless otherwise stated.

Examples:

```text
Systems must be secure.

Systems must be highly available.

Systems must be reliable.

Systems must be scalable.

Systems must be observable.

Systems must be maintainable.

Systems must be recoverable.

Systems must meet compliance requirements.
```

The following are not NFRs because they prescribe specific implementation requirements:

```text
Administrative access must require MFA.

All data at rest must be encrypted.

Audit logs must be retained for 365 days.

Production workloads must be deployed across at least two availability zones.
```

## Identifier Requirements

NFRs shall use the format:

```text
NFRXXXXXX
```

Where:

- XXXXXX is a repository-wide unique numeric identifier.
- NFR IDs must never be reused.
- NFR IDs must never change after creation.

## Classification Rules

An NFR describes a desired outcome, quality attribute, operational characteristic, business objective, or constraint.

Decision rule:

```text
If the statement describes what a system must achieve,
it is an NFR.

If the statement describes a specific, testable,
auditable, or enforceable implementation requirement,
it is a Control and does not belong in the NFR catalog.
```

Examples:

```text
The system must be secure.
→ NFR

The system must be highly available.
→ NFR

Administrative access must require MFA.
→ Control. Offer to route it to `/highway-controls`.

Audit logs must be retained for 365 days.
→ Control. Offer to route it to `/highway-controls`.
```

## Routing between the two skills

The classification rule above is the mirror image of the one `/highway-controls` applies. That skill
already tells a user their statement is an outcome rather than an enforceable requirement — but it
has nowhere to send them.

The two skills shall route to each other:

- Where `/highway-nfrs` is offered a statement that is really a Control, it shall say so and name
  `/highway-controls`.
- Where `/highway-controls` is offered a statement that is really an NFR, it shall say so and name
  `/highway-nfrs`.

Without this, a user rejected by one skill has been told what their statement is *not*, and left to
guess where it belongs. Adding the reciprocal advice to `/highway-controls` is part of this work
rather than a later tidy-up.

## Ambiguity Handling

If the skill cannot confidently determine the intended action, whether the user intends to update
or replace an NFR, whether a matching NFR already exists, or which NFR is being referenced, it
shall abort, ask, and write nothing.

Where a referenced NFR does not exist, the skill shall abort naming what it searched for, rather
than creating one.

Where the catalog is absent but NFR files exist, the skill shall abort and ask. The next identifier
cannot be recovered from the files, because the highest identifier present may not be the highest
ever issued.

Where `.highway/` cannot be located, the project root cannot be determined and the NFR directory
cannot be placed. The skill shall abort and ask.

## Advice, not refusal

An NFR that is vague is still the user's NFR.

Where a statement would be better expressed differently, the skill shall say what is wrong and
offer at least one improved alternative. It shall **not refuse** an NFR the user still wants after
being advised.

A skill that overrules its user gets bypassed, and the files are then edited by hand — which loses
the identifiers, the baseline version, and the catalog together.

Where a proposed NFR resembles an existing one, the skill shall name that NFR rather than reporting
a duplicate in the abstract.

## Versioning

The NFR baseline shall use Semantic Versioning, `MAJOR.MINOR.PATCH`.

| Change | Increment |
|---|---|
| An NFR added | MINOR |
| An NFR edited without changing its obligation | PATCH |
| An NFR removed, or the baseline replaced | **MAJOR** |

Exactly one increment happens per action, whatever the action's size. Version management shall be
performed automatically by the skill.

## Future Compatibility

The skill shall preserve forward compatibility for NFR-to-Control relationships populated from
either side, relationship validation such as an NFR with no Control satisfying it, and traceability
reporting across both baselines.

The reserved fields are reciprocal and already exist: every Control carries `nfrs`, and every NFR
will carry `controls`. Neither is populated in this phase.

**Not decided here**: which skill owns the relationship once both baselines exist. Writing it from
both sides invites two records that disagree. That belongs to the phase implementing relationships
and should be settled before either skill writes a link.

## Authority

The `/highway-nfrs` skill is the authoritative mechanism for managing global NFRs.

Users shall be instructed not to edit generated NFR files directly. All changes shall be performed
through the skill, to preserve identifiers, version history, and future relationship integrity.

Content under `library/governance/` belongs to the user. This skill writes there and judges nothing
about what an NFR says beyond advising on its form.
