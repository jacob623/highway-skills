# Contract: The highway-nfrs Skill

**Feature**: 020-highway-nfrs | **Date**: 2026-09-08

The skill exposes a plain-language authoring interface and produces a user-owned NFR baseline.

## Invocation

```text
/highway-nfrs <what you want to do, in plain language>
```

The skill identifies the action from the request. When the action, target, or update-versus-replace
meaning is not decidable, it asks before writing.

## Artifact contract

| Artifact | Location | Required content |
|---|---|---|
| Catalog | `library/governance/nfrs.md` | Baseline statement, global scope, skill instruction, direct-edit warning, version, `next_id`, and every NFR index entry |
| NFR record | `library/governance/nfrs/NFRXXXXXX.md` | YAML frontmatter for ID, title, status, and `controls: []`; Markdown statement and rationale |
| Skill | `.highway/skills/highway-nfrs/SKILL.md` | Authoritative workflow, routing, error handling, and verification |

The catalog is generated prose with no timestamp. An unchanged baseline regenerates byte-identically.
NFR records do not carry an individual version.

## Action contract

| Action | Effect | Version | Confirmation |
|---|---|---|---|
| **Add** | Allocates recorded `next_id`, writes an NFR record, advances `next_id`, regenerates catalog | MINOR | None; no existing NFR is lost |
| **Update** | Changes requested fields while preserving ID and untouched metadata, regenerates catalog | PATCH when obligation is unchanged | None unless the request is destructive or ambiguous |
| **Remove** | Deletes one NFR record and catalog entry while leaving `next_id` unchanged | MAJOR | Required; names ID and title |
| **Set** | Replaces the baseline and removes records absent from the replacement | MAJOR | Required; names every removed ID and title |

Exactly one version increment occurs per successful action. A failed or refused action increments
nothing.

## Confirmation contract

Before Set or Remove writes:

| ID | Requirement |
|---|---|
| C1 | Name every NFR that would be lost by identifier and title |
| C2 | Do not substitute a count for the named loss list |
| C3 | Obtain the user's confirmation before changing any file |
| C4 | Leave the tree, catalog, version, and `next_id` unchanged when confirmation is withheld |

## Classification and advice contract

| Statement shape | Response |
|---|---|
| Desired outcome, quality attribute, operational characteristic, business outcome, or constraint | Treat as an NFR candidate |
| Specific, testable, auditable, or enforceable implementation requirement | Identify it as a Control and offer `/highway-controls` |
| Vague NFR | Explain the weakness, offer at least one improved alternative, and accept it if the user keeps it |
| Similar existing NFR | Name the matching NFR by ID and title; do not silently reject it |
| Outcome-shaped input to `/highway-controls` | Identify it as an NFR and name `/highway-nfrs` |

Classification routing does not populate either reserved relationship field.

## Ambiguity contract

| Condition | Response |
|---|---|
| Intended action or target is ambiguous | Abort, ask which interpretation is intended, write nothing |
| Update versus replacement is ambiguous | Abort, name both interpretations, write nothing |
| Referenced NFR does not exist | Abort, name what was searched for; do not create one |
| Catalog is absent while NFR files exist | Abort; do not derive `next_id` from present files |
| `.highway/` cannot be located | Abort; do not create governance files elsewhere |
| Catalog or records are internally inconsistent | Abort and report the inconsistency before mutation |

## Acceptance checks

| ID | Check | Expected result |
|---|---|---|
| A1 | Add to empty baseline | First NFR, catalog, empty `controls`, and MINOR version increment exist |
| A2 | Add after removal | New ID is above the retired ID |
| A3 | Decline Set or Remove | Every loss was named and the tree is unchanged |
| A4 | Update an NFR | ID and untouched metadata remain; PATCH occurs once when obligation is unchanged |
| A5 | Offer Control-shaped statement | `/highway-controls` is named as the destination |
| A6 | Offer vague statement and keep it | Advice is shown and the requested NFR is still written |
| A7 | Route outcome-shaped Control input | `/highway-nfrs` is named as the destination |
| A8 | Regenerate unchanged catalog | Output is identical and timestamp-free |
| A9 | Run the suite | Containment, registration, routing, and existing fixtures pass |
