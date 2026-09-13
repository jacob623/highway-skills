# Highway Governance Implementation Plan

Sequenced plan for establishing Highway's governance layers. This document is durable working
context: it is written to survive across sessions so the sequence, rationale, and exact command
invocations do not have to be reconstructed from conversation history.

**The goal the remaining work serves**: mechanical coverage of what ships — the files under
`.highway/`. A phase is active only if it raises the share of those files decided by a check that
has been proved able to fail. Every other phase is deferred, which means postponed with its
reasoning intact, not abandoned.

**Status**: Phases 1–6, 10, 11 and 17 are complete and their detail has been removed from this
document. Phases 12, 13, 15 and 16 were removed on 2026-09-11: their subject is the `specs/` tree,
which Feature 044 takes out of governance entirely. Active: Phases 8 and 14. Deferred: Phases 7
and 9.

**Last reviewed**: 2026-09-11 (Phase 17 complete via feature 045; re-centred on `.highway`
coverage; completed phase detail and the two appendices that fed completed phases removed; the
four specification-record phases removed in favour of Feature 044)

---

## 1. Why this document exists

Highway is developed with Spec Kit and packaged separately for users, with Spec Kit stripped from
the distribution. That creates three distinct governance concerns, once entangled in a single
document at `.specify/memory/constitution.md`. Phase 1 separated them into the layers in §2, and
this document now sequences what remains.

Two defects drove that separation and were both closed by Phase 1: the shipping validators resolved
a development-only constitution path absent from the distribution, and `/speckit.constitution`
would overwrite the shipping governance document. They are named here because they explain the
layer boundaries, not because they are open.

---

## 2. The four-layer model

| # | Layer | Governs | Owner | Ships? | ID namespace | Home |
|---|---|---|---|---|---|---|
| 0 | **Development** | How the Highway project is built | Maintainer | No (persists in dev tree) | `D1.1`–`Dn.n` | `.specify/memory/constitution.md` |
| 1 | **Authoring** | The text inside a `SKILL.md` | Maintainer | Yes | `P1.1`–`P8.6` | `.highway/governance/constitution.md` |
| 2 | **Experience** | What a skill emits at runtime, and how it interacts | Maintainer | Yes | `X1.1`–`Xn.n` | `.highway/governance/experience-standard.md` |
| 3 | **Architecture** | The systems the user designs | End user | Skills ship; content does not | User-defined (`NFR-001`, `CTL-001`) | User's own workspace |

### Routing test

One question assigns any candidate rule to exactly one layer. Exactly one branch applies.

> **What artifact does this rule constrain?**
>
> 1. A document that exists only to build Highway → **Layer 0**
> 2. A `SKILL.md` file in this repository → **Layer 1**
> 3. Something a Highway skill produces or displays when a user runs it → **Layer 2**
> 4. Something in the user's own system or repository → **Layer 3**

Worked examples:

| Candidate rule | Layer | Why |
|---|---|---|
| "A skill MUST declare exactly one Purpose." | 1 | Constrains a `SKILL.md` (this is today's P7.1) |
| "Every script MUST run under Bash 3.2.57." | 0 | Constrains the build toolchain, never shipped content |
| "Generated output MUST cite the input artifact it derives from." | 2 | Constrains emitted content |
| "A generated design MUST state its availability target." | 3 | Constrains the user's system |
| "Every task MUST name its exact file path." | 0 | Constrains a `tasks.md` |

### Structural rules that hold across all phases

- **Dependency direction**: Layer 0 may reference Layers 1–3. Layers 1–3 MUST NOT reference
  Layer 0. A spec may cite the constitution; the constitution may never cite a spec.
- **Precedence**: Layer 1 outranks Layer 2 (correctness before presentation). Security-affecting
  rules outrank everything. Layer 3 never outranks Layers 1–2, and Layers 1–2 never modify
  Layer 3 content.
- **No restatement**: rule text lives in exactly one document. Other documents cite rule IDs.
- **Layer 3 containment**: no Layer 3 content is ever written under `.highway/`. Writing user NFRs
  into `.highway/library/governance/` would cause `validate-library.sh` to judge user content
  against Highway's constitution. Highway governs the container; the user governs the contents.

---

## 3. Phase overview

Phases 1, 2, 2b, 3, 4, 4b, 4c, 5, 6, 10, 11 and 17 are complete and the second-skill Gate is
cleared. Their detail has been removed from this document; each one's record lives in its own
spec directory — features 010–018, 021, 022 and 045.

| Phase | Name | Type | Layer | State |
|---|---|---|---|---|
| 7 | Build the `nfrs` and `controls` skills | Spec | 2 governs; 3 is the subject | ⏸ Deferred — both skills ship; five FRs unimplemented. The residual work is advice wording and ambiguity branches, which no check decides either way |
| 8 | Make a skill's help detail answerable for itself | Spec | 1 | ▶ Active — `P7.9` adds a registered `[auto]` check over every shipped `SKILL.md` |
| 9 | Make artifact versions accountable | Spec | 1, and a cross-layer question | ⏸ Deferred — its own analysis concludes the rule cannot honestly be `[auto]`, so it adds no mechanical coverage |
| 14 | Recover the probe runtime the integrity work spent | Spec | 0 | ▶ Active — two files hold 135.5s of a ~200s run; runtime pressure is what erodes probe coverage |

Phases 12, 13, 15 and 16 were removed on 2026-09-11. All four governed the `specs/` tree, and all
four had already been deferred on that ground. Feature `044` removes that tree from governance
altogether — eight development rules, four Enforcement Map rows and three test files — which
dissolves each of the four rather than deferring it further. Their reasoning is preserved in
Feature 044's spec and in git history; nothing under `specs/` is deleted.

### What makes a phase active

A phase is active if it raises the share of files under `.highway/` decided by a check that has
been **proved able to fail** — by removal and observation, or by mutating the artifact and
requiring the check to notice. A check that merely runs proves nothing, which is the lesson
Feature 041 and Feature 042 were both spent learning.

Deferred does not mean wrong. Phases 7 and 9 each rest on a verified finding, and those findings
stay recorded below.

### The gap no phase currently owns

Measured 2026-09-11 across all eight skills: `validate-skill.sh` decides 93 of 480 rule-to-skill
pairs — 19.4%, with 44 of 60 rules deferred on every skill by tier and `UNCHECKED` empty
everywhere. The ceiling under the present tiering is roughly 27%.

Phase 17 now owns the frontmatter half of that surface. What remains unowned is the body: no check
anywhere compares a **produced record** against the output template that declares its structure,
and `rc_check_P9_1` verifies only that a skill cites a template path, never that the citation is
honoured. A skill may cite `nfr-record.md` and describe a wholly different shape with nothing
objecting. That is the same declared-structure design Phase 17 applies to frontmatter, applied to
body output instead, and it should follow Phase 17 rather than precede it — frontmatter is the
smaller surface to prove the pattern on.

---

## 4. Phase detail

The text below cites completed phases by number — Phase 4c, Phase 10 and others. Their detail is
no longer in this document; §3 names the feature directory that holds each one's record.

### Phase 7 — Build the `nfrs` and `controls` skills

**Coverage verdict, 2026-09-11**: ⏸ **Deferred.** The five outstanding FRs are advice wording,
ambiguity branches and test depth inside two skills that already ship and already validate. No
check decides advice wording either before or after the work, so completing it moves no coverage
number. Reopen when the skills' behaviour is wrong, not to close the FR list.

**Layer**: 2 governs them; Layer 3 is their subject matter **Type**: Spec

**Status**: 🔶 **Delivered with recorded gaps**, 2026-09-08. `highway-controls` complete
(`specs/019-repository-controls`): 47 tasks; 18 tests passing. `highway-nfrs` shipped
(`specs/020-highway-nfrs`): 54 tasks; 20 tests passing; registered, generated and validated. Five
functional requirements are unimplemented — FR-002, FR-020, FR-024, FR-027 and FR-032 — and
several tasks were marked complete without the work they describe. Both baselines are usable and
the containment boundary holds; the shortfall is in advice wording, ambiguity branches and test
depth. Phase 10 owns the rule defects that let it through; the residual FR work belongs to a new
numbered spec, not to an edit of 020. That was `D5.2` when written; after Feature 044 it is
convention rather than rule, and the reasoning is unchanged either way.

**The containment guard is now structural rather than intended.** `validate-library.sh` declines
any file outside the framework root, so a user's Control is never judged by Highway's authoring
rules. Before this, the same file was judged when named by an absolute path and declined when named
by a relative one — containment that depended on how someone typed a path. Measured beforehand:
thirteen Controls written with an uppercase keyword fail `P7.4`, and a Control over twenty-five
words fails `P1.3`, reported as though the user's policy were a skill.

**Four findings worth carrying forward**:

1. **The scope had to be the framework root, not its library directory.** Fixtures live under
   `tools/tests/fixtures/library/`, so the narrower reading would have declined every one and
   bought containment by breaking the tests that prove it.
2. **`P7.4` was never close to binding — 4 of 12.** The plan treated a split as likely and made it
   a measured decision rather than a guess. What kept the count low was putting artifact shape in
   Outputs as *description*: the budget is for obligations on the agent, not for structure.
   `highway-help` states zero and is fully specified.
3. **`P6.4` rejected the word "preference"** in a sentence saying what a Control is *not*. The
   nondeterministic-token check reads lines, not intent. Reworded rather than exempted.
4. **Test residue cost time twice before being fixed.** Two tests seed probes into the live tree
   and clean up only on a normal exit, so a killed run leaves artifacts named with a dead PID that
   no later run claims. Worse, tests run in name order, so the residue fails whichever test sorts
   first — an orphaned adapter row failed `adapter-coverage`, and an abandoned link probe failed
   `distribution-packaging`, each naming a defect that did not exist. Fixed with a sweep in
   `run-all.sh`, at the suite level, because sweeping in the owning test is too late.

**Decisions recorded during specification**, each resolving a contradiction in the original draft:
Controls live at the project root rather than under `.highway/`; files carry YAML frontmatter with
a Markdown body; the catalog is prose; the next identifier is recorded rather than computed, so
removal cannot free an identifier for reuse; and **a Control carries no version of its own**, since
two counters over one baseline can disagree with nothing saying which is authoritative.

**Goal**: Ship the governance skills that let a user author NFRs and controls over their own
architecture.

**Why last**: These skills sit on the Layer 2 / Layer 3 boundary, and that boundary leaks unless
the containment guards are already enforced. Building them after Phase 6 means the rules they must
follow exist and are checked before they are written.

**Prerequisite**: Phase 6 complete, which it is. Both skills were in fact built ahead of this
phase's slot to clear the second-skill Gate, so what remains here hardens and re-validates skills
that already exist rather than creating them from nothing.

**The three containment guards** these skills must satisfy:

1. No Layer 3 content is written under `.highway/`. Writing user NFRs into
   `.highway/library/governance/` would cause `validate-library.sh` to judge user content against
   Highway's constitution, failing users for prose style in their own policies.
2. `P`, `D`, and `X` rule-id namespaces are reserved for Highway and must not appear as user
   control ids; user ids must not be resolvable by Highway's validators.
3. The skills govern the *form* of a generated governance artifact and state no obligation about
   its content. Requiring a user's NFR to carry a measurable threshold is form; requiring that
   threshold to be 99.9% is content, and is the user's to decide.

**Command**:

```text
/speckit.specify "I want highway-nfrs and highway-controls skills that help a user author non-functional requirements and controls governing the architectures my other Highway skills design. These are Highway skills, so their SKILL.md obeys the Highway Skills Constitution and their output obeys the Experience Standard, but their subject matter is the user's own system and belongs to the user. They must write their output into a path the user owns in the user's workspace, never under .highway/, because anything under .highway/library/ is validated against Highway's own constitution and would fail a user for the prose style of their own policy. The P, D, and X rule-id namespaces are reserved for Highway and must never be used as user control ids, and a user's ids must never be resolvable by Highway's validators. Each skill governs only the form of the artifact it generates and states no obligation about its content: it may require an NFR to carry a measurable threshold, but never what that threshold should be. Each skill cites the X rules it satisfies in its Outputs section."
```

**Done when**:

- Both skills validate against the constitution and cite the `X` rules they satisfy.
- No skill writes Layer 3 content under `.highway/`.
- A test confirms a user-authored artifact is never validated against Highway's governance.

---

### Phase 8 — Make a skill's help detail answerable for itself

**Coverage verdict, 2026-09-11**: ▶ **Active, and the strongest candidate in this table.** `P7.9`
is a registered `[auto]` check over a field in every shipped `SKILL.md`, so it raises mechanical
coverage of shipped markdown directly. `P7.8` does not and should not be counted toward that —
it is `[agent-checkable]` by design, as its own analysis argues.

**Layer**: 1 **Type**: Spec

**Status**: Deferred by decision, 2026-09-08. Independent of every other phase; can run whenever.

**Goal**: A skill's `description` and `usage` are required to be *true*, not merely present and
well-formed.

**Why this is not covered by Phase 4c.** `highway-help` answers from the catalog, and the catalog
is generated from each skill's frontmatter. `D4.7` guarantees the catalog faithfully mirrors the
`SKILL.md`. It guarantees nothing about whether the `SKILL.md` is accurate. Change a skill's
behaviour, update its body, leave the frontmatter alone, and every gate passes while `highway-help`
describes a skill that no longer exists. Phase 4c closed catalog-vs-source drift; this closes
source-vs-reality drift.

**The verified gap** (2026-09-08). `highway-inquiry`'s description was set to *"Generates
architecture diagrams from a running Kubernetes cluster and exports them as SVG"* and the validator
returned `OK: skill 'highway-inquiry' is valid (13 rules checked, 35 deferred, 0 unchecked)`,
exit 0. Nothing objected, and `D4.7` would then have propagated it into the catalog faithfully.

What exists today, and what each stops short of:

| Mechanism | Covers | Does not cover |
|---|---|---|
| `schema-validate.sh` | `description` and `usage` must be **present** | Whether either says anything true |
| `P7.2` | Version **format** is `MAJOR.MINOR.PATCH` | Whether it was bumped |
| `P7.7` | A breaking contract change increments MAJOR | Description and usage accuracy |
| `D6.1` | Live documentation updated when invalidated | **Defined** as tool READMEs, the authoring standard, the root README — a `SKILL.md`'s frontmatter is not in that list |
| `D4.7` | The catalog matches the source | Whether the source is right |

**This is Layer 1, not Layer 0.** The routing test in §2 places it: the obligation constrains a
`SKILL.md`, so it takes `P` ids and lives in the shipping constitution, phrased for a skill author
rather than a maintainer. Same reasoning as Phase 2b.

**Two rules, deliberately split by what can honestly be automated**:

| ID | Rule | Observable | Tier |
|---|---|---|---|
| P7.8 | A change to a skill's behaviour MUST be accompanied by a review of its description and usage. | The change either edits both fields or records that neither needed editing. | [agent-checkable] |
| P7.9 | A skill's usage MUST name its own invocation. | The `usage` field contains the skill id. | [auto] |

P7.8 is `[agent-checkable]` because accuracy is semantic and every mechanical proxy under-detects.
Tagging it `[auto]` would reintroduce exactly the dishonesty Phases 4 and 4b removed. P7.9 is the
weaker mechanical partner, and it catches the real copy-paste-a-sibling-skill error.

**P7.9 passes today** — verified 2026-09-08: both `highway-help` and `highway-inquiry` name their
own id in `usage`. So it would enable without invalidating conforming work, keeping the amendment
MINOR. Re-verify before enabling, as Phase 4c showed that assumption can be wrong.

**Prerequisite**: None. Independent of Phases 5, 6 and 7.

**Command**:

```text
/speckit.specify "I want a skill's help detail to be answerable for itself, because highway-help reads each skill's frontmatter and nothing requires that frontmatter to be true. Verified 2026-09-08: setting highway-inquiry's description to 'Generates architecture diagrams from a running Kubernetes cluster and exports them as SVG' produced OK: skill 'highway-inquiry' is valid, exit 0, and D4.7 would then propagate that faithfully into the catalog. D4.7 closed catalog-versus-source drift; this closes source-versus-reality drift, which is a different gap. Add two rules to the Highway Skills Constitution at .highway/governance/constitution.md as a MINOR amendment. P7.8: a change to a skill's behaviour MUST be accompanied by a review of its description and usage, observable as the change either editing both fields or recording that neither needed editing, tagged [agent-checkable] because accuracy is semantic and every mechanical proxy under-detects -- tagging it [auto] would reintroduce the dishonesty features 013 and 014 removed. P7.9: a skill's usage MUST name its own invocation, observable as the usage field containing the skill id, tagged [auto] and decided by a registered check reporting under its own rule id in the existing coverage summary, the way every other [auto] P rule is. Place these in Layer 1 rather than Layer 0: the routing test says a rule constraining a SKILL.md is Layer 1, and the rule must be phrased for a skill author rather than a maintainer, the same decision feature 011 made. Verify before enabling P7.9 that both existing skills already name their own id in usage -- they did on 2026-09-08 -- because if that is not true the amendment is MAJOR rather than MINOR. Evaluate the new check against every existing fixture before enabling it, per D3.4, and prove it can fail by changing a skill's usage so it no longer names its id, confirming the check fails and passes again once restored. Cite both rules by id from .highway/skills/_authoring-standard.md rather than restating their text, per P7.3. Consider separately whether the frontmatter should be named in the definition of live documentation, or whether that definition should stay Layer 0 and this obligation stay Layer 1 -- do not do both, because that would restate one rule in two documents."
```

**Done when**:

- `P7.8` and `P7.9` are in the Highway Skills Constitution with Observables and tiers, recorded as
  a MINOR amendment in its Sync Impact Report.
- `P7.9` is decided by a registered check reporting under its own rule id, and the `UNCHECKED`
  group stays empty.
- The check has been observed failing and then passing again after restoration.
- `_authoring-standard.md` cites both rules by id and restates neither.
- Confirmation is recorded that both existing skills satisfied `P7.9` before it was enabled.

---

### Phase 9 — Make artifact versions accountable

**Coverage verdict, 2026-09-11**: ⏸ **Deferred.** The phase's own Note on automation settles it:
detecting that content changed requires comparing against a previous state, and version control is
deliberately absent from the Declared Toolchain. The rule lands `[agent-checkable]`, so the phase
adds no mechanical coverage. Its finding stands and its reasoning is worth keeping intact.

**Layer**: 1 for the library rule; the shared-semantics part does not route cleanly and that is the
first thing to settle **Type**: Spec

**Status**: Deferred by decision, 2026-09-08. Independent of every other phase.

**Goal**: A version number on any artifact means something, and something requires it to move.

**The verified gap** (2026-09-08). Two findings, and only the first is straightforward:

1. **Nothing governs when a library file's version changes.** `P7.2` validates that
   `metadata.version` matches `MAJOR.MINOR.PATCH`; no rule requires it to move when the content
   does. Measured: zero `P` rules mention library versioning at all.
   `library/templates/requirements-inquiry.md` sits at 1.0.0 and could be rewritten entirely with
   nothing objecting. This is the same shape as the defect Phase 8 records — a field that exists,
   looks maintained, and is accountable to nothing.
2. **Four MAJOR clauses exist across the governance documents**, sharing a shape but not a
   subject:

| Document | What MAJOR is about |
|---|---|
| Skills Constitution, document policy | A principle or governance rule removed or redefined |
| Skills Constitution, Skill Versioning Policy | A breaking change to the skill contract |
| Experience Standard | A rule removed or redefined |
| Development Constitution | A principle removed or redefined |

These are **not** a `D1.4` violation — they constrain different artifacts. But the repetition is
real, and a fifth is about to appear when `highway-controls` versions a Control baseline.

**Why this is not one universal scheme.** "Breaking" is defined relative to a consumer, and the
consumers differ: a skill's consumer is an agent invoking it, a library file's is a skill reading
it, a control baseline's is an auditor or a design citing a `CTL` identifier. A single definition
covering all three would have to be abstract enough to decide nothing — which is the defect
Phases 4, 4b and 6 each removed.

**The routing problem, to settle first.** A shared versioning vocabulary constrains every artifact
and fits none of the four layers cleanly. That question is the whole difficulty of this phase and
should not be answered under time pressure inside a feature about something else. It is why the
library rule below is separable and the semantics work is not.

**Note on automation.** The library-currency rule cannot be `[auto]`. Detecting that content
changed requires comparing against a previous state, and version control is deliberately absent
from the Declared Toolchain because the packaged tree is not a repository. It lands
`[agent-checkable]`, like `P7.7`, and that is honest rather than a shortfall.

**Prerequisite**: None. Independent of Phases 5, 6, 7 and 8.

**Command**:

```text
/speckit.specify "I want a version number on a Highway artifact to mean something and to be required to move. Two findings, verified 2026-09-08. First, nothing governs when a library file's version changes: P7.2 validates that metadata.version matches MAJOR.MINOR.PATCH, but no rule requires it to move when the content does, and zero P rules mention library versioning at all -- library/templates/requirements-inquiry.md sits at 1.0.0 and could be rewritten entirely with nothing objecting. Add a rule to the Highway Skills Constitution requiring that a library file's version change when its content changes, tagged [agent-checkable] because detecting a content change requires comparing against a previous state and version control is deliberately absent from the Declared Toolchain. Do not tag it [auto] and do not write a proxy check that cannot fail. Second, and separately, four MAJOR clauses exist across the governance documents -- the Skills Constitution's own policy, its Skill Versioning Policy, the Experience Standard, and the Development Constitution -- sharing a shape but constraining different artifacts, and a fifth arrives when highway-controls versions a Control baseline. Before factoring anything, settle where a shared versioning vocabulary belongs, because it constrains every artifact and fits none of the four layers cleanly under the routing test. Decide that question first and record the answer; only then decide whether to state the shared semantics once and have each artifact type define what constitutes a breaking change for it, citing rather than restating. Do not produce a single universal definition of breaking: the consumers differ -- a skill's consumer is an agent invoking it, a library file's is a skill reading it, a control baseline's is an auditor citing an identifier -- and one definition covering all three would be abstract enough to decide nothing, which is the defect features 013, 014 and 018 each removed."
```

**Done when**:

- A rule requires a library file's version to change when its content changes, tagged honestly.
- Where a shared versioning vocabulary belongs is decided and recorded, or recorded as deliberately
  not factored, with the reason.
- No universal definition of "breaking" is introduced that covers artifacts with different
  consumers.
- No rule is tagged `[auto]` without a check that decides it.

---

### Phase 14 — Recover the probe runtime the integrity work spent

**Coverage verdict, 2026-09-11**: ▶ **Active, on a narrower argument than the one written below.**
It adds no coverage itself. It protects coverage: a suite over its budget is the standing pressure
to declare fewer artifact classes, which is precisely how `D4.3` became unprovable. The phase's
refusal to trade scope for speed is the part that earns its place here — if that refusal is ever
relaxed, this phase becomes a coverage loss and should be stopped.

**Layer**: 0 **Type**: Spec (number to be assigned)

**Status**: Proposed, 2026-09-10. Gated on Feature `044`, which removes four Enforcement Map rows
and so changes this phase's largest cost centre before it is scoped.

**Goal**: The test suite finishes inside the 180 second target with every probe Feature 041 and
Feature 042 added still executing, so the target is met by making the probes cheaper rather than by
running fewer of them.

**Why this phase exists.** Feature 041 gave every registered `[auto]` check an executed probe. That
is the mechanism this project needed and it has already earned its cost — it caught two test files
declaring three artifact classes while implementing one, and it caught Feature 041's own coverage
record. It also made the suite slow. Measured across six runs on 2026-09-10: 206, 190, 176, 175,
175 and 185 seconds, with stable CPU time near 200 seconds and variable wall clock. The target is
180. The suite straddles it.

Feature 041's task record marked the budget met against the single 176.39 second sample. That was
the wrong claim to make from that data, and Feature 042 records it as such rather than revising the
target. Feature 042 then adds probe work whose total is deliberately left open until it is
measured. One part is already measured, 2026-09-10: closing `D4.3`'s probe gap costs roughly
sixteen seconds — a neutralised leg that is a full distribution build at 7.86s, and a seeded leg
that must itself build a tracked target at 7.82s before it can modify a file inside it, the two
refusals themselves costing 0.06s and 0.07s. Feature 042 then widened to two further tests, whose
classes are not yet costed, so the figure must be re-measured rather than scaled. Feature 042 keeps
180 as the target, records it as knowingly unmet, and sets an interim ceiling of 240 seconds so that
further drift stays distinguishable from the deviation it introduces deliberately. So the honest
position entering this phase is that the suite exceeds its target by a known margin, for a known
reason, with the deficit recorded rather than hidden.

**The trade this phase refuses.** The cheap way to meet the target is to declare fewer artifact
classes. That is what narrowing `distribution-packaging.test.sh` from three classes to two
achieved, and it is how `D4.3` came to be unprovable in the first place — a timing decision that
silently became a coverage decision. Reducing declared scope to meet a timing target is the same
move as marking a task complete because the suite is green: it makes a number look right by
shrinking what the number is about. This phase may make a probe cheaper. It may not make a probe
prove less.

**Where the time is.** Not yet apportioned beyond one measurement: `adapter-coverage.test.sh`'s
`source-document` probe costs roughly 16 seconds, performing a real tree copy and three generator
runs. Whether that work is necessary to what the probe proves is the question this phase answers
first. The apportionment across every probed class must be measured before anything is optimised,
because optimising the wrong probe is how a suite gets slower and less trustworthy at the same
time. The declared-class count is not final until Feature 042 lands: eleven classes are declared
across the eight mapped test files today, and that feature's plan adds two — a `generated-artifact`
class on `distribution-packaging` and a `disposable-fixture` class on `completion-coverage` — while
broadening `spec-record`'s existing class rather than adding one. An earlier note here said the
count was thirteen and that at least three more were coming; thirteen is the number of Enforcement
Map rows, not of classes, and the figure is corrected by this note rather than left standing.

**Prerequisite**: Feature `042` complete. This phase cannot start earlier, because the full set of
probes whose cost it apportions is not final until `D4.3`'s class exists.

**Appended 2026-09-10, after Feature 042 measured what it spent.** The open figure above is now
closed. Two samples of five consecutive runs with every class in place: 208, 210, 211, 245, 277s
(taken while the machine was still loaded from Feature 042's forty-minute removal campaign) and
204, 209, 210, 210, 211s (settled). The settled range is **204–211s**, median **210s**, against a
pre-change median of **174s** — a rise of **+36s**. Two runs breached the 240s interim ceiling under
load; neither did when the machine was idle. The ceiling is therefore recorded as held under normal
conditions and breached under load, which is what the measurement supports rather than what would
have been convenient to claim.

Of the +36s, **23.35s** is measured per leg: 7.67s and 15.48s for `distribution-packaging`'s
`generated-artifact` legs, and 0.20s for all four of the `completion-coverage` and `spec-record`
legs combined. So the entire measured cost of Feature 042's added classes is two distribution
builds; the cheap legs are genuinely cheap. The remaining ~13s is attributable to Feature 042's
`adapter-coverage` rewrite — which seeds eight defects separately where it seeded four at once — and
to four normal-mode `harness_probe_pair` invocations added to `constitution-inventory`, but neither
was timed in isolation. That gap is recorded as unexplained rather than attributed, and apportioning
it is work for this phase.

Feature 042's scope also grew: its first exhaustive removal pass found three further unreached rules
(`D4.5`, `D4.6`, `D3.7`) beyond the four it was opened for, and corrected all three. The class count
above is unchanged by that work — the corrections rewrote existing legs rather than declaring new
classes — so eleven classes across eight mapped files becomes thirteen once Feature 042 lands.

The distance to target is now **30s**, not the ~0s the straddle above suggested. That makes this
phase more necessary, not less, and the largest single candidate remains unchanged: two full
distribution builds in `distribution-packaging`'s `generated-artifact` legs, one of which exists
only so the neutralised leg can run a build of its own.

**Where the time actually is, measured per file on 2026-09-11.** The suite was timed test by test
rather than in aggregate, which had not been done before:

| Test | Time |
|---|---|
| `constitution-inventory.test.sh` | **97.2s** |
| `distribution-packaging.test.sh` | **38.3s** |
| `generate-catalog.test.sh` | 9.1s |
| `adapter-coverage.test.sh` | 7.8s |
| `generate-agent-adapters.test.sh` | 6.2s |
| `rule-checks.test.sh` | 6.0s |
| every other test | 1.25s or less |

Two files hold **135.5 seconds** of a roughly 200 second run. Everything else together is under 35.
That changes what this phase is: not a broad efficiency exercise but two files, one of which —
`constitution-inventory` — is expensive precisely because it executes every mapped test's probe, so
its cost is a function of the Enforcement Map rather than of its own code.

Feature 044 removes four Enforcement Map rows and the two test files they name. That should reduce
`constitution-inventory`'s workload without any edit to it. **The size of that reduction is not
predicted here.** It must be measured after Feature 044 lands, and this phase must be re-scoped
around whatever remains rather than around the 97.2s figure above.

The three tests Feature 044 deletes total **11.8 seconds**, or 5.9% of the run. Feature 044 is not a
runtime fix and must not be recorded as one.

**Appended 2026-09-12, after Feature 046 measured the frontmatter lexicon.** Feature 045 added a
closed-word-list check over free-form frontmatter prose and implemented it by running a matcher
once per word. Measured on the target shell (Bash 3.2.57), that cost **0.3126 seconds per
`validate-skill.sh` invocation** (median of three, 160 invocations per run). Feature 046 answers
membership from an in-memory blob instead, bringing the same check to **0.0109 seconds** — a 96.5%
reduction — with validator output and exit status byte-identical across all 21 validated targets.

Suite runtime moved from **272 seconds** to a **median of 203 seconds** (199s / 203s / 204s), which
is inside the 240-second interim ceiling but still outside the 180-second target. That remaining gap
is this phase's, and Feature 046 must not be recorded as having closed it: the two expensive files
identified above are untouched. What Feature 046 does settle is that the lexicon is no longer a
contributor worth measuring — any further work belongs to `constitution-inventory` and
`rule-checks`.

**Done when**:

- The per-class cost of every probed artifact class is measured and recorded, before any change is
  made, and re-measured after Feature 044 rather than carried over from 2026-09-11.
- The suite completes inside 180 seconds across at least five consecutive runs, reported as a range
  rather than as a best sample.
- Every artifact class declared at the start of the phase is still declared at the end, and every
  probe still fails when its behavior is removed.
- No assertion is removed or loosened; any change to what a probe does is recorded against the
  behavior it still proves.
- The recorded runtime in the probe-mode contract is updated to the measured range, and the
  deviation Feature 042 recorded is closed rather than left standing.
- The 240-second interim ceiling Feature 042 set is removed once 180 is met again, rather than
  surviving as a second target.
- No constitution rule is added or amended, and neither Layer 1 nor Layer 2 is touched.
- `.highway/tools/tests/run-all.sh` exits 0.

---

## 5. Explicitly not in this plan


- **Layer 3 content.** User-authored NFRs and controls are user data with a user lifecycle. They
  live in the user's workspace, never under `.highway/`. Phase 7 builds the skills that produce
  them; it does not author their content.
- **Layer 0 rules for Spec Kit's own templates.** Out of scope until there is a reason.
- **Further Highway skills beyond `nfrs` and `controls`.** Product scope, sequenced separately.
