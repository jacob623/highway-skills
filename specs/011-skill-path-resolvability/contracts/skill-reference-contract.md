# Contract: Skill Reference

Defines what a skill may reference, and how that is decided.

**Supersedes**: nothing. This contract is new.

## The rule

**`P8.7`** — a skill MUST NOT carry a link whose target is a relative filesystem path.

**Observable**: no Markdown link target in the skill body is a relative filesystem path.

**Tier**: `[auto]`. **Principle**: VIII, Reliability and Repeatability.
**Not-applicable condition**: none; the rule applies to every skill.

The rule names no location that exists only during development. A recipient has never seen those
locations, so a rule phrased in their terms would be uninterpretable to the person it governs.

## Why a prohibition rather than a resolution test

A skill is not read where it is written. The generator copies `SKILL.md` byte-for-byte into three
further locations, one of which is a flat file rather than a directory, and copies no sibling file
alongside it.

A relative target is resolved against the directory holding the file. The same target therefore
resolves to a different location in each of the four places a skill is read, and exists in at most
one of them. No relative target can satisfy every reader.

The obligation is consequently a property of the text alone. The check needs no filesystem access
and no knowledge of how many distribution trees exist, so adding a fourth agent cannot invalidate
it.

## Classification

| Text | Classification | Verdict |
|---|---|---|
| A Markdown link whose target is a relative path | Cross-reference | FAIL |
| A Markdown link whose target is an absolute URL | Cross-reference | PASS |
| A path inside inline code or a fenced block | Command example | Not evaluated |
| A path in prose, unlinked | Prose mention | Not evaluated |

Only a Markdown link target is evaluated. A command example is instruction text, correct as
written; treating it as a reference would force correct content to be mangled to satisfy a rule
that was never about it.

## Check behaviour

| Property | Requirement |
|---|---|
| Location | The rule-check library, registered in the rule registry |
| Dispatch | By the existing skill validator, unchanged |
| Reported as | `P8.7`, in the coverage groups the validator already emits |
| Failure output | Names the skill, the offending target, and its location |
| Exit on violation | Non-zero, via the validator's existing aggregation |
| Filesystem access | None |
| Utilities | Declared Toolchain only |

**Registered, not standalone.** A rule enforced by a separate test but absent from the validator's
own per-skill report would be enforced yet invisible — the defect this contract exists to remove,
reproduced one level down.

## Enabling requirements

1. Every existing fixture's verdict under the check is recorded **before** the check is enabled.
   An unconditional new check silently changes the verdict of every artifact already present, and
   a fixture expected to produce exactly one failure can quietly begin producing two.
2. A fixture exercises the failure path. No existing artifact contains a link, so without one the
   failure path would ship untested.
3. The check is demonstrably capable of failing.

## Guarantees

1. A skill carrying a relative link target fails validation, naming the skill and the target.
2. A skill carrying no link, or only absolute URLs, passes.
3. A command example never causes a failure.
4. No existing fixture's verdict changes when the check is enabled.
5. Adding a distribution tree does not change any verdict.

## Non-goals

- This contract does not govern documents that are not skills. Live documentation in the
  repository is governed separately, by a rule about cross-references resolving within the tree
  that contains them — a different obligation for an artifact class that exists in one place only.
- It does not prohibit naming a path. A skill may name any path in prose or in a command example;
  the prohibition is on linking to one.
- It does not require any existing skill to change. No registered skill carries a link.
