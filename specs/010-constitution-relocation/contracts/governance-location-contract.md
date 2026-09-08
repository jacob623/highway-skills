# Contract: Governance Document Location

**Supersedes**: the constitution location implied by feature 003 (constitution enforcement), for
the resolution fallback only. Every other element of that feature's validation-output contract —
finding format, coverage-summary groups, verdict tokens, tier semantics — carries forward
unchanged.

## Canonical location

The Highway Skills Constitution resides at `.highway/governance/constitution.md`.

`.highway/governance/` is a sibling of `.highway/library/`, never a child. Library content is
validated *against* the constitution; a document cannot be both the yardstick and the thing
measured.

## Resolution

| Step | Condition | Result |
|---|---|---|
| 1 | `CONSTITUTION_FILE` is set and non-empty | That value, verbatim |
| 2 | Otherwise | `<framework root>/governance/constitution.md` |

Exactly one branch applies to any input.

The fallback is anchored at the **framework root** — the `.highway/` directory — not the
repository root. This is the property that makes the document resolvable from a tree containing
only `.highway/`.

The override mechanism is unchanged from feature 003. Only the fallback value changes.

## Guarantees

1. Resolution succeeds in a tree from which all development directories have been removed.
2. Rule text, rule IDs, Observables, and tier tags are byte-identical to the pre-move document.
3. The constitution's own version is not incremented. Its versioning policy reserves PATCH for
   wording repair with no change to any Observable; relocation changes no Observable, and the only
   text edited is a comment that states no rule.
4. No consumer needs to set `CONSTITUTION_FILE` to reach the document at its canonical location.

## Content constraint on the relocated document

The constitution becomes a distributed artifact on relocation, and is therefore subject to the
shipped-tree independence contract. Its Sync Impact Report cites design records by name, not by
path.

This applies to the whole file, including comments. A governance document that fails its own
framework's checks is not a defensible artifact.

## The vacated location

`.specify/memory/constitution.md` holds a placeholder.

| Property | Requirement |
|---|---|
| States a rule | MUST NOT |
| Defines a rule ID | MUST NOT |
| Records the new location | MUST |
| Records what will replace it | MUST |
| Classification | Development artifact |

The placeholder exists because ten development workflow commands read this path. It is replaced,
not amended, when the development constitution is ratified.

Because it is a development artifact, it may reference development locations. It is outside the
scope of the shipped-tree independence check by construction, not by exemption.

## Non-goals

- This contract does not change any rule, rule ID, Observable, or tier in the constitution.
- It does not define what the development constitution will contain.
- It does not make the constitution a published contract for end users. Whether the distribution
  includes the governance document and the authoring toolchain is settled by a later feature.
