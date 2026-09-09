<!--
Sync Impact Report
Version change: none → 1.0.0 (initial ratification); amended 1.0.0 → 1.1.0, 1.1.0 → 1.2.0,
  and 1.2.0 → 1.3.0 on 2026-09-08
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
  - IV. Generated Artifact Integrity (D4.1-D4.7)
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

Follow-up TODOs closed by amendment 1.1.0:
  - D_AUTO_TIER_ENFORCEMENT: satisfied. See the 1.1.0 entry below for the evidence.

Follow-up TODOs: none.

--- Amendment 1.2.0 → 1.3.0 (MINOR), 2026-09-08 ---
Bump rationale: four completion-integrity rules are added without invalidating conforming work.
The new rules govern development records only and do not change shipped artifacts.
Added rules: D3.6 and D7.1-D7.3. D3.6 extends verification discipline to claimed tests; D7.1
requires semantic task-to-artifact correspondence; D7.2 requires exact requirement coverage; and
D7.3 separates check results from coverage in completion reports.
Added principle: VII. Completion Integrity.
Tier counts: [auto] 6 → 7; [agent-checkable] 18 → 21; [human-review] 1, unchanged.
Verified before enabling: the coverage check was evaluated against every existing completed feature;
features without historical coverage were recorded as missing rather than backfilled. A valid
coverage fixture failed when one requirement id was removed and passed again after restoration.
No existing completed spec directory was edited. D3.6, D7.1, and D7.3 remain agent-checkable;
no proxy check was added for their semantic judgements.
Self-application review: D1.3, D1.4, and D5.3 PASS; the amendment cites rule IDs and names each
added rule and changed tier count.

--- Amendment 1.1.0 → 1.2.0 (MINOR), 2026-09-08 ---
Bump rationale: three rules are added and no conforming work is invalidated. MINOR covers a rule
  added without invalidating conforming work; the tree was verified conformant to all three
  before they were enabled, so the strengthening clause that would make this MAJOR does not
  apply. See "Verified before enabling" below, which is load-bearing rather than ceremonial.
Why this was needed: nothing stated or detected that the catalog and the generated agent adapters
  could fall out of correspondence with the skills actually present. A skill could be added and
  left unlisted, changed and left stale, or removed and leave orphans that still ship. D4.1 looks
  as though it covers the stale case and does not: its rule text is about hand-editing, and its
  Enforcement Map row names a test asserting hand-edit refusal for adapters that never
  regenerates the catalog. generate-catalog.test.sh looks as though it covers it and does not: it
  runs the generator twice against unchanged inputs, which is D4.2's determinism.
Added rules (3):
  - D4.5: every skill in the source has its generated artifacts. Catches the added skill.
  - D4.6: no generated artifact names a skill absent from the source. Catches the orphan left by
    a removed skill — the most severe case, because those orphans are marked include in the
    distribution manifest and therefore ship.
  - D4.7: a change to a generator's input is followed by regeneration. Catches the stale entry
    left by a changed skill.
Added sections:
  - Declared generators and Declared agent trees, both under Principle IV, so D4.5 through D4.7
    name their scope explicitly rather than leaving a reader to infer it.
  - Correspondence Gate, in Quality Gates. The Generator Gate triggers on a change to a
    generate-*.sh script, which is the wrong trigger for these three: they are violated by
    changing a generator's *input*, not the generator. Without a new gate the rules would be
    unreachable through the gate mechanism.
Removed sections: none. Removed rules: none. Rule count: 25 → 28.
Tier counts: [auto] 6 → 9, [agent-checkable] 18 unchanged, [human-review] 1 unchanged.
Modified rules: none. No existing rule text, Observable, or tier is changed.
Non-restatement review, per D1.3, D1.4 and the Self-Application clause:
  - D4.7 against D4.1: D4.1 prohibits editing a generated artifact; D4.7 requires refreshing one
    after its source changes. The two share a detection mechanism — a diff — but the rules turn
    on rule text, and these texts state different obligations. A reader asking "must I regenerate
    after changing a description?" finds an answer in D4.7 and none in D4.1.
  - D4.7 against D4.4: D4.4 covers a changed generator, D4.7 a changed input. Siblings; neither
    subsumes the other.
  - D4.5 against D4.6: directional halves of one correspondence, stated separately because they
    fail differently and produce different damage.
  - None of the three restates any P-namespace rule; they constrain build outputs, not skill text.
Verified before enabling, 2026-09-08:
  - D4.7 did NOT pass when this amendment was drafted. .highway/catalog/library-index.json
    recorded "entries": [] while .highway/library/templates/requirements-inquiry.md existed —
    feature 015 added the questionnaire and never regenerated the library catalog. The full suite
    passed at 17/17 with that defect committed, which is precisely the gap D4.7 names.
  - The violation was repaired by regeneration before D4.7 was enabled. Repairing a defect is not
    the same as redefining a rule, so the amendment stays MINOR; enabling D4.7 against the stale
    catalog would have made it MAJOR.
  - After repair, all four generated catalog files and every declared adapter were confirmed to
    match a fresh regeneration, ignoring the recorded timestamp.
  - D4.5 and D4.6: both skills present, highway-help and highway-inquiry, were confirmed to have
    a catalog entry, three adapters, and included distribution manifest rows, with no orphan in
    either direction.
Enforcement: all three are decided by adapter-coverage.test.sh, each with an Enforcement Map row.
  The currency check regenerates into a temporary tree rather than in place, so the working tree
  is never written to and the check cannot leave residue on a failure path.
Follow-up TODOs: none.

--- Amendment 1.0.0 → 1.1.0 (MINOR), 2026-09-08 ---
Bump rationale: two sections are added — Tier Definitions and the Enforcement Map. Classified
  against this document's Versioning Policy rather than by analogy: MINOR covers a principle or
  rule added without invalidating conforming work, and a section is added. The four retags are
  neither MAJOR (nothing removed, redefined, or strengthened) nor PATCH (a tier tag is not
  wording repair), and the higher classification governs.
Why this was needed: ten rules were tagged [auto] while no script decided any of them by name.
  The tag had been borrowed from the Highway Skills Constitution, where it means a registered
  check reports under the rule ID in a coverage summary. This layer has no registry, no coverage
  summary, and no artifact a validator runs against, so the tag was applied by an analogy that
  does not hold.
Added sections:
  - Tier Definitions: states what each tier obliges in this document, and states explicitly that
    [auto] here means less than [auto] in the Highway Skills Constitution — a test decides the
    rule, without the additional obligation to report under its rule ID.
  - Enforcement Map: binds every [auto] rule to the test that decides it. constitution-inventory
    .test.sh asserts both that every [auto] rule appears and that every named test exists, so the
    table cannot silently go stale.
Removed sections: none. Added rules: none. Removed rules: none. Rule count: 25, unchanged.
Modified rules — tier only; every rule text and Observable is unchanged:
  - D3.1, D3.2 retagged [auto] → [agent-checkable]. Each is a claim about the suite state at a
    moment relative to an edit. No check run at one moment can observe two moments and the work
    between them; an agent can.
  - D4.4 retagged [auto] → [agent-checkable]. It constrains what a person did after changing a
    generator, which is not a property of any file.
  - D6.2 retagged [auto] → [agent-checkable]. This one is a judgement and is recorded as such.
    Cross-references are decided automatically inside the packaged tree by
    distribution-packaging.test.sh, but the Observable says "the tree that contains the
    document", and no check covers repository-only documents. Measured 2026-09-08: 145 link
    targets across the repository, 8 unresolvable, and none a genuine defect — four are
    deliberate illustrations in spec records and a fixture, two were an extraction artifact, and
    two are in .highway/DISTRIBUTION.md, which is authored for the distributed tree where it
    lands at the root and where those targets do resolve. Widening the check would require
    exempting fenced code, deliberate illustrations, fixtures, and relocated documents, and would
    flag a correct document. Partial automation tagged [auto] is the dishonesty this amendment
    exists to remove, so the tier now says judgement.
Newly enforced:
  - D5.4 gains spec-record.test.sh, asserting feature directory numbers are contiguous from 001
    with no gap and no duplicate. It was the only rule that was both unenforced and trivially
    checkable, so it was enforced rather than retagged.
  - D4.1 gains assertions in generate-agent-adapters.test.sh that a hand-edited adapter is
    refused rather than silently overwritten. The generator already refused; nothing asserted it.
Tier counts: [auto] 10 → 6; [agent-checkable] 14 → 18; [human-review] 1, unchanged.
Conformance impact: none. Enabling D5.4's check invalidates no conforming work — verified before
  it was enabled that specs/ holds 001 through 014 contiguously. Had a gap existed, this would
  have been a MAJOR amendment under the "previously conforming work now fails" clause.
Evidence closing the D_AUTO_TIER_ENFORCEMENT follow-up: every rule tagged [auto] now appears in the
  Enforcement Map naming a test that exists; the four rules no test decides carry a tier that
  says so; and constitution-inventory.test.sh fails if either constitution drifts, naming the
  offending rule and its document.
A policy gap, recorded not fixed: the Versioning Policy below does not name a tier change. It
  fell to MINOR here only because sections were added for another reason. The Highway Skills
  Constitution has the identical gap. Both would benefit from a clause naming tier changes, which
  is a separate PATCH amendment to each.
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

## Tier Definitions

A tier tag states how a rule is decided, so a reader knows whether something will catch a
violation or whether they must check it themselves.

| Tier | What it obliges in this document |
|---|---|
| `[auto]` | A test run by `.highway/tools/tests/run-all.sh` decides the rule, and the Enforcement Map below names that test. |
| `[agent-checkable]` | An agent or person performs the check and reports the result. No test decides it. |
| `[human-review]` | A human judgement is required; neither a test nor an agent can decide it. |

**This differs from the Highway Skills Constitution, deliberately.** There, `[auto]` additionally
requires that the rule be decided by a registered check reporting under its own rule ID in a
coverage summary. That is not a definition of the tier; it is a description of machinery Layer 1
has and this layer does not. No validator runs against a `tasks.md`, a `plan.md`, or a working
tree, and building one to make a tag literally true would be a large amount of tooling for no
gain in what a reader learns.

The same tag is nonetheless used in both documents, because it answers the same reader question in
both: will something catch me. A distinct name such as `[test-enforced]` was considered and
rejected — it would imply the Layer 1 tier is something other than test-enforced, which it is not,
since `validate-skill.sh` is run by the same suite.

### Enforcement Map

Every rule tagged `[auto]` appears here exactly once, naming the test that decides it. A test
named here must exist. Both properties are asserted by `constitution-inventory.test.sh`, so this
table cannot silently go stale.

| Rule | Enforced by | Note |
|---|---|---|
| D1.1 | shipped-tree-independence.test.sh | Scans the distributed path set for the prohibited tokens; seeds a probe to prove it can fail |
| D1.2 | distribution-packaging.test.sh | Runs the distribution's own validator against a tree with the development directories absent |
| D4.1 | generate-agent-adapters.test.sh | Asserts the generator refuses to overwrite a target that was hand-edited after it was produced |
| D4.2 | generate-catalog.test.sh | Asserts re-running with unchanged inputs produces no difference aside from the recorded timestamp the Observable excepts |
| D4.3 | distribution-packaging.test.sh | Asserts refusal to overwrite an untracked directory and a modified file, naming each |
| D4.5 | adapter-coverage.test.sh | Asserts every skill present has a catalog entry, an adapter in each declared agent tree, an adapter manifest row for each adapter, and an included distribution manifest row for each adapter |
| D4.6 | adapter-coverage.test.sh | Asserts no catalog entry, adapter file, adapter manifest row, or distribution manifest row names a skill with no source directory |
| D4.7 | adapter-coverage.test.sh | Regenerates into a temporary tree and asserts no diff against the committed artifacts, excepting the recorded generation timestamp |
| D5.4 | spec-record.test.sh | Asserts feature directory numbers are contiguous from 001 with no gap and no duplicate |
| D7.2 | completion-coverage.test.sh | Compares every requirement id in a completed feature spec with exactly one coverage entry |

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
| D3.1 | A change MUST begin from a passing test suite. | `.highway/tools/tests/run-all.sh` exits 0 before the first edit. | [agent-checkable] |
| D3.2 | A change MUST end with a passing test suite. | `.highway/tools/tests/run-all.sh` exits 0 after the final edit. | [agent-checkable] |
| D3.3 | A behavioral change MUST add or amend at least one test. | The change includes an edit to a file under `.highway/tools/tests/`. | [agent-checkable] |
| D3.4 | A new validation check MUST be evaluated against every existing fixture before it is enabled. | Each fixture's expected verdict under the new check is recorded before the check is wired in. | [agent-checkable] |
| D3.5 | A test MUST NOT be weakened to accommodate a change. | No assertion is removed or loosened without a recorded reason naming the superseded behavior. | [human-review] |
| D3.6 | A test MUST be observed failing for the behavior it claims to cover before that behavior is marked complete. | The failing run and its message are recorded before the implementation that makes it pass. | [agent-checkable] |

Rationale: D3.4 exists because an unconditional new check silently changes the verdict of every
artifact already in the repository.

### VII. Completion Integrity

| ID | Rule | Observable | Tier |
|---|---|---|---|
| D7.1 | A task MUST NOT be marked complete unless the artifact it names contains the change it describes. | Each `[X]` task's named path exists and contains the described change. | [agent-checkable] |
| D7.2 | A completed feature MUST record a requirement-coverage mapping. | Every requirement id in `spec.md` appears exactly once in the feature's coverage record, against a satisfying artifact or a stated deferral. | [auto] |
| D7.3 | A completion report MUST state requirement coverage separately from check results. | The report makes the suite result and the requirement coverage two distinct claims. | [agent-checkable] |

Rationale: Completion records are claims about work, not substitutes for the work. D7.2 is
mechanically decidable by comparing requirement-id sets; D7.1 and D7.3 require semantic review.

### IV. Generated Artifact Integrity

| ID | Rule | Observable | Tier |
|---|---|---|---|
| D4.1 | A generated artifact MUST NOT be hand-edited. | Re-running its generator produces no diff. | [auto] |
| D4.2 | A generator MUST produce identical output from unchanged inputs. | Two consecutive runs differ in no byte other than a recorded generation timestamp. | [auto] |
| D4.3 | A generator MUST refuse to overwrite a target it did not produce. | The run exits non-zero and names the file. | [auto] |
| D4.4 | A change to a generator MUST be followed by regeneration of every artifact it produces. | No diff remains after running the generator. | [agent-checkable] |
| D4.5 | Every skill in the source MUST have its generated artifacts. | Each directory under `.highway/skills/` has a catalog entry, an adapter in each declared agent tree, an adapter manifest row for each adapter, and a distribution manifest row for each adapter. | [auto] |
| D4.6 | A generated artifact MUST NOT name a skill absent from the source. | No catalog entry, adapter file, adapter manifest row, or distribution manifest row names a skill with no directory under `.highway/skills/`. | [auto] |
| D4.7 | A change to a generator's input MUST be followed by regeneration. | Re-running every declared generator leaves no diff against the committed artifacts, aside from a recorded generation timestamp. | [auto] |

Rationale: Generated artifacts are the product surface; drift between source and output ships
directly to users.

D4.4 and D4.7 are siblings and neither subsumes the other: D4.4 covers a changed generator, D4.7 a
changed input. D4.7 is also distinct from D4.1, which prohibits editing a generated artifact;
D4.7 requires refreshing one after its source changes. The two share an Observable mechanism
because a diff is how both are detected, but D1.3 and D1.4 turn on rule text rather than on
Observables, and these texts state different obligations.

D4.5 and D4.6 are directional halves of one correspondence and are stated separately because they
fail differently: a missing artifact makes a skill invisible, while an orphaned artifact ships a
skill that has no source and cannot be maintained. Neither is expressible as "no diff on re-run",
because adapters are never pruned and manifest rows are hand-maintained.

**Declared generators** (referenced by D4.7): `generate-catalog.sh`,
`generate-library-catalog.sh`, `generate-agent-adapters.sh`. `generate-distribution.sh` is
excluded — it takes a target directory and writes outside the repository, so it produces no
committed artifact to compare against.

**Declared agent trees** (referenced by D4.5 and D4.6): `github-copilot`, `claude-code`, `cursor`.
Trees created by test fixtures are not declared agent trees.

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
| D6.2 | A documentation cross-reference MUST resolve. | Each referenced path exists in the tree that contains the document. | [agent-checkable] |

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
| 7 | VII. Completion Integrity | Prevents unsupported completion claims from becoming project history. |

**Tie-break within one principle**: a MUST NOT rule prevails over a MUST rule; if unresolved, the
lower rule number prevails.

## Quality Gates and Binary Trigger Tests

A gate applies only when its trigger evaluates true. A gate whose trigger is false is recorded N/A.

| Gate | Trigger | Rules evaluated |
|---|---|---|
| **Packaging Gate** | The change touches a shipped path. | D1.1, D1.2, D6.2 |
| **Toolchain Gate** | The change touches a file under `.highway/tools/`. | D2.1–D2.4 |
| **Generator Gate** | The change touches a `generate-*.sh` script. | D4.1–D4.4 |
| **Correspondence Gate** | The change adds, removes, or modifies a directory under `.highway/skills/`, or any other input to a declared generator. | D4.5–D4.7 |
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

**Version**: 1.2.0 | **Ratified**: 2026-09-08 | **Last Amended**: 2026-09-08
