---
name: highway-nfrs
description: "Manages the repository-wide Non-Functional Requirement baseline; use it to add, update, remove, replace, or inspect NFRs."
usage: "Invoke as `/highway-nfrs` and state the NFR baseline change in plain language."
compatibility: all
metadata:
  version: 1.0.1
---

# highway-nfrs

## Purpose

Maintains the repository-wide Non-Functional Requirement baseline as identified files the user owns.

## When to use

Use this skill when a user wants to add, update, remove, replace, or inspect a repository-wide NFR.

Use it when a user wants to state a desired quality attribute, operational characteristic,
constraint, or business outcome for solutions in the repository.

Use `readiness` for a read-only assessment of candidate-generation and accepted-NFR state. NFRs
own this classification and readiness never accepts a proposal or writes a baseline.

## When not to use

Do not use this skill to record a specific, testable, auditable, or enforceable implementation
requirement; offer `/highway-controls` instead.

Do not use it to populate NFR-to-Control relationships; that ownership is deferred and both
reserved relationship fields remain empty in this phase.

Do not use it to edit an NFR file or generated catalog directly; use the workflow below.

## Inputs

A plain-language request describing the action and NFR content.

The project root, identified by locating `.highway/`. If `.highway/` cannot be located, the project
root is unknown and no governance path may be guessed.

The user-owned baseline at `library/governance/`, sibling to `.highway/` and never inside it.

The catalog at `library/governance/nfrs.md`, when the baseline has existing NFR files.

The NFR records at `library/governance/nfrs/NFRXXXXXX.md`, when they exist.

The repository's Highway Skills Constitution, Highway Experience Standard, and `/highway-controls`
routing contract for this skill's own behavior.

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

## Control-Derived Candidate Onboarding

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
7. After confirmation or for a non-destructive action, apply the requested mutation, preserving identifiers and untouched metadata.
8. Increment the baseline exactly once: Add is MINOR; an obligation-preserving Update is PATCH; Remove or Set is MAJOR.
9. Regenerate `nfrs.md` from the records, version, and recorded `next_id`, then report the action, changed identifiers, and resulting version.

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
- Confirm each accepted NFR record, catalog, and relationship update is one validated transaction
  and a failure leaves every affected byte unchanged.
- Confirm Control-shaped statements name `/highway-controls` and outcome-shaped Control input names
  `/highway-nfrs`.

## Control-Derived Relationship Boundary

Direct NFR authoring starts with `controls: []` and does not infer or create a Control relationship.
An NFR receives a Control ID only when accepted through the Control-derived workflow
owned by `/highway-controls`; requests to derive or repair that relationship route there.

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
- Confirmation is withheld: abort and write nothing.
- A statement is Control-shaped: fall back to `/highway-controls`.

## Example

`/highway-nfrs Add an NFR requiring systems to remain available during a single availability-zone failure.`

The skill classifies the statement as an NFR, proposes a title and rationale for confirmation,
allocates the catalog's `next_id`, writes `controls: []`, increments the baseline MINOR version,
and regenerates the catalog.
