# Contract: The highway-controls Skill

**Feature**: 019-repository-controls | **Date**: 2026-09-08

Two interfaces: what the skill does when invoked, and what the library validator now declines.

## Invocation

```text
/highway-controls <what you want to do, in plain language>
```

The skill infers the action. Where it cannot, it asks rather than choosing.

## Action contract

| Action | Effect | Version | Confirmation |
|---|---|---|---|
| **Add** | Allocates the recorded next identifier, writes a Control file, updates the catalog | MINOR | None — nothing is lost |
| **Update** | Rewrites a Control, preserving its identifier and untouched metadata | PATCH | None, unless the obligation changes materially |
| **Remove** | Deletes a Control file and its catalog entry | **MAJOR** | **Required** — names the identifier and title |
| **Set** | Replaces the whole baseline | **MAJOR** | **Required** — names every Control that would be lost |

| ID | Guarantee |
|---|---|
| A1 | Exactly one version increment per action, whatever its size |
| A2 | An identifier is allocated once and never reissued, including after removal |
| A3 | An identifier never changes once assigned |
| A4 | Where confirmation is withheld, no file changes |
| A5 | The catalog is rewritten on every action that changes the baseline |
| A6 | An unchanged baseline regenerates to an identical catalog |

## Confirmation contract

Before any action that removes a Control:

| ID | Requirement |
|---|---|
| C1 | Each Control that would be lost is named by identifier **and** title |
| C2 | A count alone is not sufficient notice |
| C3 | The user's decision is taken before any file is written |
| C4 | Withheld confirmation leaves the tree byte-identical |

C2 exists because a user cannot decide from *"this will remove 14 Controls."* The specific
objection is recorded in `highway-inquiry`: *"Are you sure?" is not enough, because the user cannot
decide from it.*

## Advisory contract

| ID | Requirement |
|---|---|
| D1 | Where a Control states an outcome rather than an enforceable requirement, the skill says what is wrong |
| D2 | It offers at least one improved alternative |
| D3 | It **does not refuse** a Control the user still wants |
| D4 | Where a Control resembles an existing one, it names that Control rather than reporting a duplicate abstractly |

D3 is a prohibition on the skill, not a courtesy. A governance tool that overrules its owner gets
bypassed, and the files are then edited by hand — which loses the identifier guarantees, the
versioning, and the catalog together.

## Ambiguity contract

| Condition | Response |
|---|---|
| The intended action is not decidable | Abort, ask which is meant, write nothing |
| The intended Control is not decidable | Abort, naming every candidate |
| The user may mean update or replace | Abort, naming both readings |
| A referenced Control does not exist | Abort, naming what was searched for. **Do not create one** |
| `.highway/` cannot be located | Abort — the Controls directory cannot be placed without it |
| The catalog is absent but Control files exist | Abort. The next identifier cannot be recovered safely from the files alone |

The last two are the ones a first implementation would guess at.

## Containment contract — the library validator

| ID | Guarantee |
|---|---|
| L1 | A file under the framework root is classified and validated as today |
| L2 | A file **outside** the framework root is declined, whatever path form is used |
| L3 | Test fixtures under `.highway/tools/tests/fixtures/library/` keep working |
| L4 | No Highway rule is ever reported against a Control's content |

L3 is the trap. Fixtures live under `.highway/` but **not** under `.highway/library/`, so an
implementation scoped to the latter declines every fixture and breaks the library tests.

## Prohibited outcomes

- **No Control content judged by any Highway rule.** Measured: thirteen Controls with an uppercase
  keyword fail `P7.4`; a Control over twenty-five words fails `P1.3`. Neither may ever be reported.
- **No Control written under `.highway/`.**
- **No identifier reused.**
- **No deletion without each loss named.**
- **No timestamp in the catalog.**
- **No refusal of a Control the user still wants.**

## Decision point during implementation

`P7.4` caps a skill at twelve `MUST`-level rules. This skill has more obligations than either
existing one. **Measure the count as the skill is written.** If it exceeds twelve after
artifact-shape requirements have been moved into Outputs as description:

- split along the **Set** seam — the only wholesale, irreversible action, carrying the heaviest
  confirmation obligations and the least used while a baseline is being built
- record the split and its reason

Do not resolve an overflow by weakening an obligation into a suggestion.

## Acceptance

| # | Check | How |
|---|---|---|
| A1 | A baseline that would fail Highway's rules is accepted | Write 30 Controls with uppercase keywords; suite stays green |
| A2 | Nothing under the user's directory reaches a Highway catalog | Regenerate everything; grep the catalogs |
| A3 | The validator declines a user Control by any path form | Invoke it with relative and absolute paths |
| A4 | Fixtures still validate | Run the library tests |
| A5 | Removing the highest identifier does not free it | Add, remove, add; compare |
| A6 | A withheld confirmation changes nothing | Attempt a Set, decline, diff the tree |
| A7 | An unchanged baseline regenerates identically | Regenerate twice, diff |
| A8 | The skill is registered completely | Catalog entry, three adapters, adapter manifest rows, distribution manifest rows |
