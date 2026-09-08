# Contract: Shipped-Tree Independence

Defines which files are distributed, what they may not contain, and how that is checked.

**Supersedes**: nothing. This contract is new.

## Distributed path set

Declared in exactly one place and consumed by the check.

| Pattern | Holds |
|---|---|
| `.highway/` | Skills, library, catalog, governance, tooling, tests |
| `.github/skills/highway-*` | GitHub Copilot adapters |
| `.claude/skills/highway-*` | Claude Code adapters |
| `.cursor/rules/highway-*` | Cursor adapters |

A path not matching this set is a development artifact and is out of scope.

The adapter patterns carry the `highway-` prefix deliberately. Adapter directories for external
tooling used to build this repository are not Highway's product;
`generate-agent-adapters.sh` already refuses to read or write them, and this check honours the
same boundary.

**Failure direction**: the set lists what ships rather than what does not. A newly added directory
is therefore out of scope until deliberately included. This is the safer default — an
under-inclusive list produces a visible gap when someone adds a distributed directory, whereas an
over-inclusive scan produces noise that invites exemptions.

## Prohibited content

A distributed file MUST NOT contain either token.

| Token | Names |
|---|---|
| `.specify/` | The development workflow directory |
| `specs/` | The specification record |

**Scope is textual, not semantic.** Document links, source comments, prose, and string literals
are all in scope. The check matches text and never infers intent. A check that must decide whether
a match "really counts" is a check that will eventually be argued with.

## Provenance citation form

Where a distributed file previously cited a design record by path, it cites it by name.

| Property | Requirement |
|---|---|
| Form | `feature NNN (short-name)` |
| Contains a path | MUST NOT |
| Contains a link | MUST NOT |
| Consistent across all distributed files | MUST |

Example: `per feature 003 (constitution enforcement)`.

The record itself is not moved, copied, or altered. A reader holding the development tree can
locate it from the feature number; a reader without it could not have followed a path either.

## Check behaviour

| Property | Requirement |
|---|---|
| Scope | Every file in the distributed path set |
| Fixture handling | Fixtures are scanned; no exemption |
| Self-exclusion | The check excludes its own file by name |
| Exit on violation | Non-zero |
| Failure output | Offending file, line number, matched text — one line per violation |
| Self-test | Seeds a violation, confirms detection, removes it |
| Exit when clean | Zero |

**The self-test is not optional.** A check that has never been observed to fail proves nothing
about the tree it scans. This follows the precedent already set by the path-integrity check, whose
own header records that narrowing scope to an enumerated file list allowed stale paths to persist
in fixtures across two features.

## Relationship to the path-integrity check

Both scan for path defects; they answer different questions and remain separate.

| | Path integrity | Shipped-tree independence |
|---|---|---|
| Question | Would this path mislead a reader into opening something at the repository root? | Does this file reference something the user will not have? |
| Scope | `.highway/` only | The distributed path set, including three adapter trees outside `.highway/` |
| Concern | Correctness of relative references | Shippability |

Shared shape: whole-tree scanning, filename self-exclusion, and a seeded probe.

## Guarantees

1. Zero occurrences of either prohibited token across the distributed path set.
2. Every cross-reference in a distributed file resolves within the distributed tree.
3. Introducing one prohibited reference into any distributed file fails the suite and names the
   file.
4. A development artifact containing a prohibited token is not flagged.
5. Generated adapters are corrected by regeneration, never by hand-editing — the generator refuses
   to overwrite a target that drifted from what it last produced.

## Non-goals

- This contract does not produce a distribution. It establishes the independence that a packaging
  tool will later verify continuously.
- It does not decide whether the authoring toolchain is distributed. That decision belongs to the
  packaging feature; this contract holds either way.
- It does not govern the content of a distributed file beyond the prohibition above.
