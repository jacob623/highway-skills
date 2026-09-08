<!--
Sync Impact Report
Version change: none → 1.0.0 (initial ratification)
Bump rationale: this is the first version of a new document. It is not an amendment to any
  existing constitution. The `D` namespace is introduced here and has no prior version.

Relationship to the file previously at this path: the Highway Skills Constitution occupied
  `.specify/memory/constitution.md` until feature 010 (constitution relocation) moved it to
  `.highway/governance/constitution.md`, because the validators that read it are distributed to
  users while this directory is not. A placeholder held this path in the interval; this document
  replaces that placeholder. No rule, Observable, or tier from the Highway Skills Constitution is
  carried over, restated, or superseded here. The two documents govern different artifacts.

Added principles (6, all new):
  - I. Layer Separation and Shippability (D1.1-D1.6)
  - II. Environment and Dependency Discipline (D2.1-D2.4)
  - III. Verification Before and After (D3.1-D3.5)
  - IV. Generated Artifact Integrity (D4.1-D4.4)
  - V. Specification Record Integrity (D5.1-D5.4)
  - VI. Documentation Currency (D6.1-D6.2)
Rule count: 25. Tier counts: [auto] 10, [agent-checkable] 14, [human-review] 1.

Added sections: Definitions, Core Principles, Declared Toolchain, Principle Precedence,
  Quality Gates and Binary Trigger Tests, Constitution Check Output Shape, Governance,
  Versioning Policy, Self-Application.
Removed sections: none.
Modified principles: none renamed or restructured; no prior version exists.

Verification performed before ratification (2026-09-08). Every rule was checked against the
  repository so that no rule fails on the day it is adopted:
  - D1.1: 0 occurrences of a prohibited token across the distributed path set.
  - D1.2: validate-skill.sh exits 0 against a tree containing only .highway/.
  - D2.1: no associative array, mapfile, readarray, ${var^^}, or &>> found.
  - D2.2: the Declared Toolchain list was derived by scanning every script under .highway/tools/
    rather than estimated. Version control is deliberately absent; zero invocations were found,
    and the packaged tree is not a repository.
  - D2.3: `sort -V` is the only non-POSIX flag in use. It is accepted by both GNU coreutils and
    Apple's sort (verified on macOS 26.5.2, sort 2.3-Apple (199)), so it satisfies the rule as
    worded. An earlier draft phrased this rule as "no GNU-only flag", which would have failed on
    a usage that is in fact portable; the Observable now tests both target platforms instead.
  - D3.1 / D3.2: .highway/tools/tests/run-all.sh reports 14 passed, 0 failed.
  - D4.2: generate-catalog.sh writes a generation timestamp, so consecutive runs differ in that
    field alone; catalog content is stable and all three agent adapters are byte-identical across
    runs. The Observable excludes a recorded generation timestamp for this reason, rather than
    deferring the conflict to a TODO.
  - D5.4: feature directories 001-010 are contiguous.

Self-application review (required by the Self-Application section):
  - D1.3: PASS. No rule sentence from the Highway Skills Constitution appears here.
  - D1.4: PASS. Where the same discipline is wanted, the other document is cited by name and its
    rules by ID.
  - D5.3: N/A. This document supersedes no document; it is an initial ratification.

Templates and dependent artifacts:
  - The plan template's Constitution Check section is satisfied by the Constitution Check Output
    Shape defined below; no template edit is required.
  - The Highway Skills Constitution is unaffected. It keeps its own version, its own namespace,
    and its own amendment history.

Follow-up TODOs:
  - TODO(D_AUTO_TIER_ENFORCEMENT): ten of the twenty-five rules are tagged [auto] but no script
    enforces them yet. Until one exists, an [auto] tag records that a rule is mechanically
    decidable, not that it is mechanically decided. This mirrors the precedent already set by the
    Highway Skills Constitution, which carries the same class of follow-up.
-->

# Highway Development Constitution (Layer 0)

**Scope**: This document governs how the Highway project is *built*. It states no obligation about
the content of any shipped artifact.

Rule IDs use the `D` (Development) namespace and never collide with the `P` namespace of the
Highway Skills Constitution.

## Definitions

| Term | Definition |
|---|---|
| **Shipped artifact** | Any file included in the packaged distribution: `.highway/skills/`, `.highway/library/`, `.highway/catalog/`, `.highway/governance/`, and the generated agent adapter trees. |
| **Development artifact** | Any file excluded from the packaged distribution: `.specify/`, `specs/`, and the `speckit-*` agent skills. |
| **Generated artifact** | A file produced by a script under `.highway/tools/` and recorded in a manifest. |
| **Live documentation** | A document that describes current behavior: tool READMEs, the authoring standard, the root README. |
| **Completed spec** | A spec directory whose feature has been implemented and whose tasks are all marked complete. |
| **Behavioral change** | A change that alters the output, exit code, or accepted input of any script or skill. |
| **Verdict** | One of exactly three tokens: PASS, FAIL, N/A. |

## Core Principles

### I. Layer Separation and Shippability

| ID | Rule | Observable | Tier |
|---|---|---|---|
| D1.1 | A shipped artifact MUST NOT reference a development artifact. | No file in the declared distributed path set contains the string `.specify/` or `specs/`. | [auto] |
| D1.2 | The packaged tree MUST validate with development artifacts absent. | `validate-skill.sh` exits 0 against a copy of the tree from which `.specify/` and `specs/` have been removed. | [auto] |
| D1.3 | This document MUST NOT restate rule text defined in the Highway Skills Constitution. | Rules are cited by ID; no rule sentence is duplicated. | [agent-checkable] |
| D1.4 | A document in this repository MUST NOT restate rule text defined in a constitution. | The document cites rule IDs in place of rule text. | [agent-checkable] |
| D1.5 | A plan that creates or modifies a skill or library file MUST record a Constitution Check against the Highway Skills Constitution. | The plan names rule IDs drawn from that document. | [agent-checkable] |
| D1.6 | The distributed path set MUST be declared in exactly one place. | Each check that needs the set reads that one declaration. | [agent-checkable] |

Rationale: A defect that crosses this boundary is invisible in the development tree and visible
only to users.

### II. Environment and Dependency Discipline

| ID | Rule | Observable | Tier |
|---|---|---|---|
| D2.1 | A script MUST run under Bash 3.2.57. | The script uses no associative array, `mapfile`, `readarray`, `${var^^}`, or `&>>`. | [agent-checkable] |
| D2.2 | A script MUST NOT invoke a utility outside the declared toolchain. | Each external command invoked appears in the Declared Toolchain list below. | [agent-checkable] |
| D2.3 | A utility flag MUST work on both target platforms. | The flag is accepted by both GNU coreutils and the Apple/BSD variant of that utility. | [agent-checkable] |
| D2.4 | A change MUST NOT add a runtime dependency. | The change introduces no package manager, interpreter, or binary absent from the declared toolchain. | [agent-checkable] |

**Declared Toolchain** (referenced by D2.2 and D2.4). External utilities only; shell builtins are
excluded:

> `awk`, `basename`, `cat`, `comm`, `cp`, `cut`, `date`, `diff`, `dirname`, `find`, `grep`,
> `head`, `mkdir`, `mktemp`, `mv`, `rm`, `sed`, `sha256sum`, `shasum`, `sort`, `tail`, `tr`,
> `uniq`, `wc`, `xargs`

Version control is not on this list. The toolchain must run in a distributed tree, which is not a
repository.

Rationale: The toolchain must run unmodified on the default shell and utilities of the target
platform. D2.3 tests portability across the two platforms actually targeted rather than
conformance to POSIX, because a flag can be non-POSIX and still universally available — `sort -V`
is the worked example.

### III. Verification Before and After

| ID | Rule | Observable | Tier |
|---|---|---|---|
| D3.1 | A change MUST begin from a passing test suite. | `.highway/tools/tests/run-all.sh` exits 0 before the first edit. | [auto] |
| D3.2 | A change MUST end with a passing test suite. | `.highway/tools/tests/run-all.sh` exits 0 after the final edit. | [auto] |
| D3.3 | A behavioral change MUST add or amend at least one test. | The change includes an edit to a file under `.highway/tools/tests/`. | [agent-checkable] |
| D3.4 | A new validation check MUST be evaluated against every existing fixture before it is enabled. | Each fixture's expected verdict under the new check is recorded before the check is wired in. | [agent-checkable] |
| D3.5 | A test MUST NOT be weakened to accommodate a change. | No assertion is removed or loosened without a recorded reason naming the superseded behavior. | [human-review] |

Rationale: D3.4 exists because an unconditional new check silently changes the verdict of every
artifact already in the repository.

### IV. Generated Artifact Integrity

| ID | Rule | Observable | Tier |
|---|---|---|---|
| D4.1 | A generated artifact MUST NOT be hand-edited. | Re-running its generator produces no diff. | [auto] |
| D4.2 | A generator MUST produce identical output from unchanged inputs. | Two consecutive runs differ in no byte other than a recorded generation timestamp. | [auto] |
| D4.3 | A generator MUST refuse to overwrite a target it did not produce. | The run exits non-zero and names the file. | [auto] |
| D4.4 | A change to a generator MUST be followed by regeneration of every artifact it produces. | No diff remains after running the generator. | [auto] |

Rationale: Generated artifacts are the product surface; drift between source and output ships
directly to users.

### V. Specification Record Integrity

| ID | Rule | Observable | Tier |
|---|---|---|---|
| D5.1 | A completed spec directory MUST NOT be edited. | No diff appears under a completed spec directory. | [agent-checkable] |
| D5.2 | A correction to a completed spec MUST ship as a new spec. | The new spec exists under its own numbered directory. | [agent-checkable] |
| D5.3 | A superseding document MUST name every element it changes. | Each changed field is listed; unlisted elements carry forward unchanged. | [agent-checkable] |
| D5.4 | A feature directory number MUST be sequential. | The number is one greater than the highest existing directory number. | [auto] |

Rationale: The spec record is an append-only history; editing it destroys the ability to
reconstruct why a decision was made.

### VI. Documentation Currency

| ID | Rule | Observable | Tier |
|---|---|---|---|
| D6.1 | Live documentation MUST be updated in the change that invalidates it. | Each document naming the changed behavior is edited in the same change. | [agent-checkable] |
| D6.2 | A documentation cross-reference MUST resolve. | Each referenced path exists in the tree that contains the document. | [auto] |

Rationale: D6.2 is scoped to the containing tree so that a reference valid in development but
dangling in the package is a FAIL.

## Principle Precedence

When two rules conflict, the higher-ranked principle prevails. The ordering is total.

| Rank | Principle | Reason for rank |
|---|---|---|
| 1 | I. Layer Separation and Shippability | A violation reaches users and is invisible in development. |
| 2 | II. Environment and Dependency Discipline | A violation prevents execution on the target platform. |
| 3 | III. Verification Before and After | Detects violations of every other principle. |
| 4 | IV. Generated Artifact Integrity | Affects the product surface but is detectable by regeneration. |
| 5 | V. Specification Record Integrity | Affects history rather than current correctness. |
| 6 | VI. Documentation Currency | Affects comprehension rather than behavior. |

**Tie-break within one principle**: a MUST NOT rule prevails over a MUST rule; if unresolved, the
lower rule number prevails.

## Quality Gates and Binary Trigger Tests

A gate applies only when its trigger evaluates true. A gate whose trigger is false is recorded N/A.

| Gate | Trigger | Rules evaluated |
|---|---|---|
| **Packaging Gate** | The change touches a shipped path. | D1.1, D1.2, D6.2 |
| **Toolchain Gate** | The change touches a file under `.highway/tools/`. | D2.1–D2.4 |
| **Generator Gate** | The change touches a `generate-*.sh` script. | D4.1–D4.4 |
| **Validation Gate** | The change adds or modifies a validation check. | D3.4, D3.5 |
| **Spec Record Gate** | The change touches a directory under `specs/`. | D5.1–D5.4 |
| **Skill Content Gate** | The change creates or modifies a file under `.highway/skills/` or `.highway/library/`. | Delegated to the Highway Skills Constitution per D1.5 |

## Constitution Check Output Shape

A plan records two parts:

1. **Process gates** — a verdict for every gate whose trigger evaluates true, by rule ID.
2. **Skill content gates** — when the Skill Content Gate triggers, a verdict against the Highway
   Skills Constitution by rule ID; otherwise `N/A: Skill Content Gate not triggered`.

A plan with any FAIL does not proceed to tasks.

## Governance

This document governs development activity only. Where it and the Highway Skills Constitution both
apply, they apply to different artifacts and cannot conflict; if an apparent conflict arises, the
Highway Skills Constitution prevails for artifact content and this document prevails for process.

### Versioning Policy

- **MAJOR**: a principle is removed or redefined, or an obligation is strengthened so that
  previously conforming work now fails.
- **MINOR**: a principle or rule is added without invalidating conforming work.
- **PATCH**: wording repair with no change to any Observable.

### Self-Application

This document is subject to D1.3, D1.4, and D5.3. Every amendment records a review against those
rule IDs.

**Version**: 1.0.0 | **Ratified**: 2026-09-08 | **Last Amended**: 2026-09-08
