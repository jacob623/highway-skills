# Highway Governance Implementation Plan

Sequenced plan for establishing Highway's governance layers. This document is durable working
context: it is written to survive across sessions so the sequence, rationale, and exact command
invocations do not have to be reconstructed from conversation history.

**Status**: Phases 1, 2 and 2b complete. Next action is Phase 3 or Phase 4 — they are independent.

**Last reviewed**: 2026-09-08

---

## 1. Why this document exists

Highway is developed with Spec Kit and packaged separately for users, with Spec Kit stripped from
the distribution. That creates three distinct governance concerns that are currently entangled in
a single document at `.specify/memory/constitution.md`.

Two defects follow from the entanglement, both of which this plan resolves:

1. **The shipping validators depend on a development-only directory.** Eight files under
   `.highway/` resolve `.specify/memory/constitution.md`. That path does not exist in the packaged
   distribution, so the packaged validator toolchain is broken while the development tree stays
   green. The failure is invisible locally.
2. **`/speckit.constitution` overwrites the shipping governance document.** That command writes to
   `.specify/memory/constitution.md`, which currently holds the Highway Skills Constitution. A
   single invocation destroys it. Because Spec Kit remains in the development tree for the life of
   the project, this hazard is permanent rather than transitional.

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

| Phase | Name | Type | Layer | Gate to start |
|---|---|---|---|---|
| 1 | Relocate constitution and sever development coupling | Spec | 1 | ✅ Complete (feature 010) |
| 2 | Ratify the Development Constitution | Command | 0 | ✅ Complete (v1.0.0, 2026-09-08) |
| 2b | Close the authoring-rule gap and the constitution backlog | Spec | 1 | ✅ Complete (feature 011) |
| 3 | Packaging contract and verification | Spec | 0/1 | Phase 2b complete |
| 4 | Automate the constitution's `[auto]` tier | Spec | 1 | Phase 2b complete |
| — | **Gate**: a second skill exists | — | — | Blocks Phase 5 |
| 5 | Author the Experience Standard | Spec | 2 | Gate passed |
| 6 | Enforce the Experience Standard | Spec | 2 | Phase 5 complete |
| 7 | Build the `nfrs` and `controls` skills | Spec | 2 governs; 3 is the subject | Phase 6 complete |

Phases 3 and 4 are independent of each other and may run in either order.

### Why this order

- Phase 1 precedes everything because it removes the two defects in §1, and because every later
  phase reads or writes the constitution path it establishes.
- Phase 2 precedes Phases 3–6 so that all subsequent work is governed by a ratified Layer 0. The
  alternative — building the largest chunk of work with the Constitution Check switched off or
  reporting against a relocated document — forfeits the gate over exactly the work most likely to
  need it.
- Ratifying Layer 0 before Layer 2 exists costs at most one MINOR amendment later, which its own
  versioning policy explicitly accommodates. Deferring it has no cheap mitigation.
- Phase 2b precedes Phases 3 and 4 because it settles *where* a rule about shipped content lives.
  Feature 010 enforced the no-upward-reference boundary with a test but wrote the rule nowhere an
  author reads, so the constraint is currently discoverable only by failing the suite.
- Phase 5 is gated on a second skill because an experience standard generalised from
  `highway-help` alone would be built on a sample size of one. That skill prints a fixed six-field
  block with no user interaction, no destructive operations, and no generated file output, so most
  candidate `X` rules would have nothing to constrain.

---

## 4. Phase detail

### Phase 1 — Relocate constitution and sever development coupling

**Layer**: 1 **Type**: Spec (`specs/010-constitution-relocation`)

**Status**: ✅ **Complete**, 2026-09-08. 32 tasks; 14 tests passing. The constitution now resolves
from a `.highway/`-only tree, 34 development-path references were removed across 20 files, and
`shipped-tree-independence.test.sh` keeps them out. Two findings fed back into this plan: the
authoring-rule gap now owned by Phase 2b, and the D4.2 timestamp exception now resolved in
Appendix A.

**Goal**: The Highway Skills Constitution lives inside `.highway/`, and no shipped artifact
references a development-only path.

**Why now**: Resolves both defects in §1. Every later phase depends on the new path.

**Prerequisite**: None.

**Command**:

```text
/speckit.specify "I want the Highway Skills Constitution to live inside the .highway/ framework directory instead of .specify/memory/, because .specify/ is a development-only directory that is stripped when Highway is packaged for users, while the validators under .highway/tools/ that read the constitution do ship. Today that means the packaged toolchain is broken and nothing detects it, and it also means the /speckit.constitution command can overwrite Highway's shipping governance document. Move the constitution to .highway/governance/constitution.md and update every reference to it, including validate-skill.sh, validate-library.sh, lib/constitution.sh, the tools README, the skills authoring standard, and the three tests that resolve the path. The path lib/constitution.sh resolves should be configurable rather than hard-coded so a caller can point at a different location. Separately, no file under .highway/ or under the generated agent adapter trees may reference specs/ or .specify/ at all: the highway-help skill's Outputs and Verification sections currently link into specs/009-skill-id-namespace-alignment, and those links are copied verbatim into every generated adapter, so they are dangling references in every shipped copy. Replace those with references that resolve inside the shipped tree, bump the skill's version accordingly, and regenerate the catalog and all adapters. Add a test that fails if any shipped file references a development-only path."
```

**Done when**:

- `.highway/governance/constitution.md` exists; `.specify/memory/constitution.md` no longer holds
  Highway skill-authoring rules.
- No file under `.highway/`, `.github/skills/highway-*`, `.claude/skills/highway-*`, or
  `.cursor/rules/highway-*` contains the string `.specify/` or `specs/`.
- `.highway/tools/tests/run-all.sh` exits 0.
- A test exists that fails when a shipped file references a development-only path.

---

### Phase 2 — Ratify the Development Constitution

**Layer**: 0 **Type**: Command — not a spec

**Goal**: `.specify/memory/constitution.md` holds rules about how this repository is built.

**Why now**: The slot is vacated by Phase 1 and must be re-tenanted — all ten `speckit-*` skills
read that path, so leaving it empty degrades every Spec Kit command. Ratifying here means Phases
3–6 are governed.

**Prerequisite**: Phase 1 complete. Running this before Phase 1 destroys the Highway constitution.

**Before running**: nothing to fill in. Appendix A was completed and verified against the
repository on 2026-09-08 — the D2.2 toolchain list is derived, D2.3 is reworded, D4.2 carries its
exception, and every rule was checked against the current tree. Paste it verbatim.

**What to paste**: everything from the heading `### Highway Development Constitution (Layer 0)`
down to the end of Appendix A (ending with the Self-Application paragraph, immediately before
`## Appendix B`). Do not include the "Resolved before ratification" notes above that heading —
those record *why* the draft is worded as it is and are not part of the document being ratified.

**Command**:

```text
/speckit.constitution "Create a development constitution that governs how the Highway project is built, not what it ships. Use the D namespace for rule IDs so they never collide with the P namespace of the Highway Skills Constitution at .highway/governance/constitution.md. Every rule carries a stable ID, exactly one keyword, an Observable, and a Tier tag, matching the format of the Highway Skills Constitution. This document must not restate any rule text defined in that document; where the same discipline is wanted, cite the rule ID instead. Ratify the draft below exactly as written: its rule text, Observables, tier tags, declared toolchain list, precedence ordering, and gate triggers have all been verified against the repository and must not be reworded, summarised, or expanded. Record a Sync Impact Report at the top of the file, and add one follow-up entry, TODO(D_AUTO_TIER_ENFORCEMENT), noting that ten of the twenty-five rules are tagged [auto] with no enforcing script yet. Here is the draft: <paste from '### Highway Development Constitution (Layer 0)' to the end of Appendix A>"
```

**Done when**:

- `.specify/memory/constitution.md` contains the 25 `D`-namespace rules and no `P`-namespace rule
  text, replacing the placeholder left by Phase 1.
- The Declared Toolchain list is present and lists no version-control dependency.
- A Sync Impact Report is present, carrying `TODO(D_AUTO_TIER_ENFORCEMENT)` and no TODO for D4.2.
- The next `/speckit.plan` produces a Constitution Check with both a process-gate part and a
  skill-content-gate part.

---

### Phase 2b — Close the authoring-rule gap and the constitution backlog

**Layer**: 1 **Type**: Spec (`specs/011-skill-path-resolvability`)

**Status**: ✅ **Complete**, 2026-09-08. 22 tasks; 14 tests passing. `P8.7` added (constitution
2.1.0, MINOR), decided automatically by `rc_check_P8_7` and reported under its own id, cited from
the authoring standard, and reachable from the front page. All three stale follow-up entries
removed with evidence; only `AUTO_TIER_ENFORCEMENT` remains.

**One finding worth carrying forward**: the rule is a prohibition rather than a resolution test,
because a `SKILL.md` is copied byte-for-byte into three further trees and no sibling file travels
with it — so no relative link target can resolve anywhere but the source tree. A second finding:
`validate-library.sh` shares the rule registry, so `rc_library_exempt_ids` was added to keep a
rule about skills from judging library content, which is never copied and whose relative links do
resolve.

**Goal**: The no-upward-reference boundary is a stated rule an author can read, not only a test
they can fail. The constitution's follow-up backlog is emptied of everything except the tooling
work Phase 4 owns.

**Why now**: Feature 010 removed 34 development-path references and added
`shipped-tree-independence.test.sh` to keep them out. It did not write the rule into
`.highway/skills/_authoring-standard.md`, so the constraint is currently discoverable only by
failing the suite. Every skill authored before this phase inherits that gap.

**Prerequisite**: Phase 2 complete.

**Where the rule belongs — settle this first**: not a copy of `D1.1` into the authoring standard.
`D1.1` is Layer 0 and does not ship, while `_authoring-standard.md` does. For an end user,
`.specify/` and `specs/` do not exist, so a rule phrased in those terms is meaningless to them and
leaks development concerns into their documentation. The routing test in §2 resolves it: a rule
constraining a `SKILL.md` is **Layer 1**. So this is a new `P` rule in the Highway Skills
Constitution, phrased generally, cited by id from the authoring standard per P7.3. Adding a rule
is a MINOR amendment to that document.

**Command**:

```text
/speckit.specify "I want the rule that a skill must not reference a path a user will not have to be written down where a skill author reads it, not only enforced by a test they discover by failing. Feature 010 removed every development-path reference from the shipped tree and added shipped-tree-independence.test.sh to keep them out, but wrote no rule, so the constraint is invisible until the suite goes red. Add a new rule to the Highway Skills Constitution at .highway/governance/constitution.md requiring that every path a skill references resolves within the tree distributed alongside it, with an Observable naming the resolvable-path check, and phrase it generally rather than naming the development directories, because those directories do not exist for an end user. Increment the constitution's version as a MINOR amendment and record the addition in its Sync Impact Report. Cite the new rule by id from .highway/skills/_authoring-standard.md rather than restating its text, per P7.3. Add a governance section to the root README.md pointing at .highway/governance/constitution.md and the authoring standard, because the README currently documents how to author a skill without mentioning the rules a skill is validated against. Finally, clear the stale entries from the constitution's follow-up TODO list: PURPOSE_SECTION_ENFORCEMENT is already satisfied because schema-validate.sh lists Purpose among the required body sections, BUMP_TYPE_REVIEW is resolvable because highway-help exists and declares a Purpose section so no reclassification is needed, and AUTHORING_STANDARD_REALIGNMENT should be completed by rewriting the Constitution Compliance Checklist to cite rule ids instead of restating principle text."
```

**Done when**:

- The constitution carries a new rule on path resolvability, with an Observable and a tier, and a
  MINOR version increment recorded in its Sync Impact Report.
- A check decides that rule automatically for every skill and is demonstrably capable of failing.
- `_authoring-standard.md` cites that rule by id and restates no rule text.
- The root `README.md` points at the governance documents.
- All three stale follow-up TODOs are removed; only `AUTO_TIER_ENFORCEMENT` remains, owned by
  Phase 4. All three were verified already satisfied on 2026-09-08 — none required implementation
  work, only removal with the evidence recorded.

---

### Phase 3 — Packaging contract and verification

**Layer**: 0 governs it; Layer 1 artifacts are its subject **Type**: Spec

**Goal**: Producing the user-facing distribution is a repeatable, verified build step rather than a
manual strip.

**Why now**: Phase 1 fixes today's coupling; this phase prevents tomorrow's. Without it, every
future feature can silently reintroduce a development-tree dependency.

**Prerequisite**: Phase 2 complete.

**Command**:

```text
/speckit.specify "I want a repeatable packaging step that produces the user-facing Highway distribution from this repository, because I develop Highway with Spec Kit but ship it without Spec Kit, and today that strip is manual and unverified. Every path in the repository must be declared as either shipped or development-only, with no ambiguity, and the packaging tool must read that declaration rather than hard-coding a list. After packaging, the tool must verify the result is self-contained: no file in the package references .specify/ or specs/, every documentation cross-reference in the package resolves to a path inside the package, and the skill validator runs successfully against the packaged tree with the development directories absent. Packaging the same commit twice must produce byte-identical output. Follow the same drift-refusal and hash-manifest pattern that generate-agent-adapters.sh already uses. Add tests so that a packaging regression fails in the test suite rather than at a user. I also need to decide and record whether the package includes the authoring toolchain under .highway/tools/ and the Layer 1 constitution, or only the runtime skills, catalog, library, and agent adapters."
```

**Decision to make during this phase**: runtime-only package versus full package. The full package
makes `.highway/governance/constitution.md` a published contract, which means `P`-rule IDs become
part of the public API and must be versioned accordingly. Designing for the full package now costs
little; retrofitting a public rule-ID contract later is expensive. Shipping runtime-only first
while designing for full is a reasonable middle.

**Done when**:

- Every repository path is declared shipped or development-only.
- The packaging tool produces a self-contained tree, verified by the four checks above.
- Two consecutive runs from the same commit produce no diff.
- Packaging regressions fail in `run-all.sh`.

---

### Phase 4 — Automate the constitution's `[auto]` tier

**Layer**: 1 **Type**: Spec

**Goal**: Every rule tagged `[auto]` is actually checked by a script, so the tier tag stops
promising enforcement that does not exist.

**Why now**: Independent of Phases 3, 5, 6, and 7. Can run whenever convenient after Phase 2b.

**Prerequisite**: Phase 2b complete, which removes the three non-tooling TODOs so this phase has a
single concern.

**Note on scope**: Layer 1 is otherwise already built — the constitution, `validate-skill.sh`,
`validate-library.sh`, the rule-check library, the fixtures, and the coverage-summary contract all
exist. This phase is the remainder, not the whole layer.

**Verified state of the constitution's follow-up TODOs** (checked 2026-09-08):

| TODO | State | Owner |
|---|---|---|
| `PURPOSE_SECTION_ENFORCEMENT` | Already satisfied — `SV_REQUIRED_SECTIONS` includes `Purpose` | Phase 2b removes the entry |
| `BUMP_TYPE_REVIEW` | Resolvable — `highway-help` exists and declares `## Purpose`, so the reclassification condition never triggered | Phase 2b removes the entry |
| `AUTHORING_STANDARD_REALIGNMENT` | Already satisfied — the standard cites 28 distinct rule ids, restates no rule text, and has no section by that name; `authoring-standard.test.sh` enforces both and passes | Phase 2b removes the entry |
| `AUTO_TIER_ENFORCEMENT` | Open | **This phase** |

**Command**:

```text
/speckit.specify "I want the Highway Skills Constitution's [auto] tier to be honest: fourteen rules are tagged [auto] but are not enforced by any script, which the constitution itself records as TODO(AUTO_TIER_ENFORCEMENT). Extend validate-skill.sh and the rule-check library so that every rule tagged [auto] is actually checked automatically, each reported by its own rule id in the existing coverage summary format. Any rule that cannot be given a mechanical check must be retagged to [agent-checkable] rather than left falsely tagged, and the retag recorded as an amendment. When a new check is added, evaluate it against every existing fixture before enabling it, so that a fixture expected to produce exactly one failure does not silently start producing two — this is the specific mistake that nearly shipped during feature 009. Remove TODO(AUTO_TIER_ENFORCEMENT) from the Sync Impact Report once the tier is honest."
```

**Done when**:

- Every `[auto]`-tagged rule has a mechanical check, or has been retagged with a recorded reason.
- `AUTO_TIER_ENFORCEMENT` is removed from the constitution's Sync Impact Report, leaving it empty.
- Every existing fixture's verdict is unchanged except where deliberately updated.

---

### Gate — A second skill exists

**Blocks**: Phase 5.

Phase 5 must not begin while `highway-help` is the only skill in the catalog. The Experience
Standard needs at least one skill that exercises the behaviours it intends to govern: user
interaction, writing a file into the user's workspace, or generating derived content.

**Owner**: this gate is cleared by Phase 7's first skill, or by any earlier skill you choose to
build. It is not self-clearing, and Phases 5 and 6 stay blocked until it is deliberately
addressed — do not treat it as something that resolves on its own.

**Recommended clearing move**: build `highway-nfrs` first, ahead of its Phase 7 slot. It writes an
artifact into the user's workspace, asks the user questions, and produces derived content, so it
exercises `X2`, `X4`, `X5`, and `X6` simultaneously — more coverage than any other candidate. The
cost is that it is authored before the standard it will be held to, which is acceptable for one
skill and is exactly how `highway-help` informed Layer 1.

---

### Phase 5 — Author the Experience Standard

**Layer**: 2 **Type**: Spec

**Goal**: A ratified Layer 2 document defining what Highway skills emit and how they interact.

**Why now**: Only once there are at least two skills to generalise from.

**Prerequisite**: Gate passed.

**Design constraint**: start thin. Include only rules for which a concrete Observable can be
written today. A rule added later is a MINOR amendment; a rule removed later breaks every skill
that cites it.

**Command**:

```text
/speckit.specify "I want a Highway Experience Standard at .highway/governance/experience-standard.md that governs what Highway skills produce at runtime and how they interact with the user, so that the content generated across the whole suite is consistent. It uses the X namespace for rule ids so they never collide with the P namespace of the Highway Skills Constitution or the D namespace of the development constitution, and it follows the same format: every rule carries a stable id, exactly one keyword, an Observable, and a Tier tag. It governs output structure, interaction protocol, terminology, artifact placement, provenance of generated content, and determinism of regenerated artifacts. It must not restate any rule from the Highway Skills Constitution; the Highway Skills Constitution outranks it wherever both could apply, and security-affecting rules outrank everything. It must state explicitly as a non-goal that it governs only the form of generated content and states no obligation about the content of a user's own governance artifacts, so that future nfrs and controls skills never judge a user's NFR text against Highway's rules. Start with only the rules I can write a concrete Observable for today. Each existing skill's Outputs section should cite the X rules it satisfies, the same way it cites P rules."
```

**Done when**:

- `.highway/governance/experience-standard.md` exists with `X`-namespace rules, each carrying an
  Observable and a Tier.
- The precedence and non-goal statements are present.
- Every existing skill cites the `X` rules it satisfies.

---

### Phase 6 — Enforce the Experience Standard

**Layer**: 2 **Type**: Spec

**Goal**: `X` rules are checked by the same machinery that checks `P` rules.

**Prerequisite**: Phase 5 complete.

**Known difficulty**: many `X` rules constrain runtime output, which a static validator cannot
observe. Expect the tier mix to skew `[agent-checkable]`. Two mitigations: golden-output fixtures
per skill checked by the existing harness, and requiring each skill's Verification section to name
the `X` rules its own self-check exercises.

**Command**:

```text
/speckit.specify "I want the Highway Experience Standard's X rules enforced by the same tooling that already enforces the constitution's P rules, rather than by a second parallel mechanism. Extend lib/constitution.sh so it can load more than one governance document and return a merged rule inventory, register the automatically checkable X rules in the rule-check library alongside the P rules, and keep the existing five-group coverage summary format unchanged so every rule id still appears in exactly one group. Extend the constitution inventory test so it asserts every X rule appears in exactly one coverage group, the same way it does for P rules today. Where an X rule constrains runtime output that a static validator cannot see, use a golden-output fixture per skill instead, and require the skill's Verification section to name the X rules its self-check exercises."
```

**Done when**:

- Every `X` rule appears in exactly one coverage group.
- The inventory test covers `X` rules.
- No second enforcement mechanism was introduced.

---

### Phase 7 — Build the `nfrs` and `controls` skills

**Layer**: 2 governs them; Layer 3 is their subject matter **Type**: Spec

**Goal**: Ship the governance skills that let a user author NFRs and controls over their own
architecture.

**Why last**: These skills sit on the Layer 2 / Layer 3 boundary, and that boundary leaks unless
the containment guards are already enforced. Building them after Phase 6 means the rules they must
follow exist and are checked before they are written.

**Prerequisite**: Phase 6 complete. Note the ordering tension: the Gate above recommends building
`highway-nfrs` *early* to unblock Phase 5. If you take that route, this phase hardens and
re-validates a skill that already exists rather than creating it from nothing.

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

## 5. Explicitly not in this plan

- **Layer 3 content.** User-authored NFRs and controls are user data with a user lifecycle. They
  live in the user's workspace, never under `.highway/`. Phase 7 builds the skills that produce
  them; it does not author their content.
- **Layer 0 rules for Spec Kit's own templates.** Out of scope until there is a reason.
- **Further Highway skills beyond `nfrs` and `controls`.** Product scope, sequenced separately.

---

## Appendix A — Development Constitution draft (input to Phase 2)

Paste from "### Highway Development Constitution" to the end of the appendix as the argument to
`/speckit.constitution`.

**This draft is complete and paste-ready.** Every open item has been resolved and verified against
the repository on 2026-09-08; the notes below record what was checked and why each rule is worded
as it is.

### Resolved before ratification

**1. D2.2 declared toolchain — derived empirically, not estimated.** Every external utility
invoked anywhere under `.highway/tools/`, by usage count:

> `grep` (75), `awk` (45), `rm` (38), `sed` (36), `tr` (31), `dirname` (23), `cp` (17), `cat` (17),
> `mkdir` (13), `basename` (11), `sort` (10), `wc` (9), `mktemp` (8), `cut` (7), `shasum` (4),
> `sha256sum` (4), `head` (4), `mv` (3), `diff` (3), `date` (3), `uniq` (2), `tail` (2),
> `xargs` (1), `find` (1), `comm` (1)

Shell builtins (`echo`, `printf`, `test`, `read`, `pwd`, `command`, `cd`) are not external
utilities and are not declared.

**`git` is deliberately absent.** An earlier draft of this list included it; verification found
zero invocations under `.highway/tools/`. Declaring it would make the toolchain look like it has a
version-control dependency it does not have, which matters because the packaged tree must run
without one.

**2. D2.3 reworded — "GNU-only" was the wrong test.** `sort -V` is used in both
`validate-skill.sh` and `validate-library.sh`. It is not POSIX, so a naive "no GNU-only flag" rule
would flag it — but it is supported by both GNU coreutils and Apple's `sort` (verified: macOS
26.5.2, `sort 2.3-Apple (199)`), so it is portable across both target platforms. The Observable
now asks whether a flag works on *both target platforms*, not whether it is POSIX. Ratifying the
earlier wording would have created a violation on day one for a usage that is actually fine.

**3. D4.2 given an exception — it would otherwise fail immediately.** `generate-catalog.sh` writes
a `generated_at` timestamp, so two consecutive runs differ in bytes even with unchanged inputs.
Verified during feature 010: the *only* difference between runs is that field, catalog content is
stable, and all three agent adapters are byte-identical across runs. The Observable now excludes a
recorded generation timestamp. The alternative — changing the generator to preserve `generated_at`
when nothing else changes — is a reasonable future improvement, not a precondition for ratifying.

**4. D1.1 and D1.2 now cite concrete artifacts.** Feature 010 created the declared distributed
path set and `shipped-tree-independence.test.sh`. Both Observables reference them rather than
restating a path list that would immediately drift.

**5. Compliance verified before ratification.** The repository passes every rule as drafted:

| Rule | Check | Result |
|---|---|---|
| D1.1 | Prohibited tokens across the distributed path set | 0 occurrences |
| D1.2 | Validator run against a `.highway/`-only tree | exit 0 |
| D2.1 | `declare -A`, `mapfile`, `readarray`, `${var^^}`, `&>>` | none found |
| D2.3 | Non-portable flags | only `sort -V`, verified portable |
| D3.1 / D3.2 | `run-all.sh` | 14 passed, 0 failed |
| D5.4 | Feature directory numbering | 001–010, contiguous |

**6. Follow-up TODOs to record.** Add one to the Sync Impact Report:
`TODO(D_AUTO_TIER_ENFORCEMENT)` — ten of the twenty-five rules are tagged `[auto]` with no
enforcing script yet. This matches the precedent already set by the Highway Skills Constitution.
Do not add a TODO for D4.2; its exception is written into the Observable rather than deferred.

---

### Highway Development Constitution (Layer 0)

**Scope**: This document governs how the Highway project is *built*. It states no obligation about
the content of any shipped artifact.

Rule IDs use the `D` (Development) namespace and never collide with the `P` namespace of the
Highway Skills Constitution.

#### Definitions

| Term | Definition |
|---|---|
| **Shipped artifact** | Any file included in the packaged distribution: `.highway/skills/`, `.highway/library/`, `.highway/catalog/`, `.highway/governance/`, and the generated agent adapter trees. |
| **Development artifact** | Any file excluded from the packaged distribution: `.specify/`, `specs/`, and the `speckit-*` agent skills. |
| **Generated artifact** | A file produced by a script under `.highway/tools/` and recorded in a manifest. |
| **Live documentation** | A document that describes current behavior: tool READMEs, the authoring standard, the root README. |
| **Completed spec** | A spec directory whose feature has been implemented and whose tasks are all marked complete. |
| **Behavioral change** | A change that alters the output, exit code, or accepted input of any script or skill. |
| **Verdict** | One of exactly three tokens: PASS, FAIL, N/A. |

#### Core Principles

##### I. Layer Separation and Shippability

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

##### II. Environment and Dependency Discipline

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

##### III. Verification Before and After

| ID | Rule | Observable | Tier |
|---|---|---|---|
| D3.1 | A change MUST begin from a passing test suite. | `.highway/tools/tests/run-all.sh` exits 0 before the first edit. | [auto] |
| D3.2 | A change MUST end with a passing test suite. | `.highway/tools/tests/run-all.sh` exits 0 after the final edit. | [auto] |
| D3.3 | A behavioral change MUST add or amend at least one test. | The change includes an edit to a file under `.highway/tools/tests/`. | [agent-checkable] |
| D3.4 | A new validation check MUST be evaluated against every existing fixture before it is enabled. | Each fixture's expected verdict under the new check is recorded before the check is wired in. | [agent-checkable] |
| D3.5 | A test MUST NOT be weakened to accommodate a change. | No assertion is removed or loosened without a recorded reason naming the superseded behavior. | [human-review] |

Rationale: D3.4 exists because an unconditional new check silently changes the verdict of every
artifact already in the repository.

##### IV. Generated Artifact Integrity

| ID | Rule | Observable | Tier |
|---|---|---|---|
| D4.1 | A generated artifact MUST NOT be hand-edited. | Re-running its generator produces no diff. | [auto] |
| D4.2 | A generator MUST produce identical output from unchanged inputs. | Two consecutive runs differ in no byte other than a recorded generation timestamp. | [auto] |
| D4.3 | A generator MUST refuse to overwrite a target it did not produce. | The run exits non-zero and names the file. | [auto] |
| D4.4 | A change to a generator MUST be followed by regeneration of every artifact it produces. | No diff remains after running the generator. | [auto] |

Rationale: Generated artifacts are the product surface; drift between source and output ships
directly to users.

##### V. Specification Record Integrity

| ID | Rule | Observable | Tier |
|---|---|---|---|
| D5.1 | A completed spec directory MUST NOT be edited. | No diff appears under a completed spec directory. | [agent-checkable] |
| D5.2 | A correction to a completed spec MUST ship as a new spec. | The new spec exists under its own numbered directory. | [agent-checkable] |
| D5.3 | A superseding document MUST name every element it changes. | Each changed field is listed; unlisted elements carry forward unchanged. | [agent-checkable] |
| D5.4 | A feature directory number MUST be sequential. | The number is one greater than the highest existing directory number. | [auto] |

Rationale: The spec record is an append-only history; editing it destroys the ability to
reconstruct why a decision was made.

##### VI. Documentation Currency

| ID | Rule | Observable | Tier |
|---|---|---|---|
| D6.1 | Live documentation MUST be updated in the change that invalidates it. | Each document naming the changed behavior is edited in the same change. | [agent-checkable] |
| D6.2 | A documentation cross-reference MUST resolve. | Each referenced path exists in the tree that contains the document. | [auto] |

Rationale: D6.2 is scoped to the containing tree so that a reference valid in development but
dangling in the package is a FAIL.

#### Principle Precedence

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

#### Quality Gates and Binary Trigger Tests

A gate applies only when its trigger evaluates true. A gate whose trigger is false is recorded N/A.

| Gate | Trigger | Rules evaluated |
|---|---|---|
| **Packaging Gate** | The change touches a shipped path. | D1.1, D1.2, D6.2 |
| **Toolchain Gate** | The change touches a file under `.highway/tools/`. | D2.1–D2.4 |
| **Generator Gate** | The change touches a `generate-*.sh` script. | D4.1–D4.4 |
| **Validation Gate** | The change adds or modifies a validation check. | D3.4, D3.5 |
| **Spec Record Gate** | The change touches a directory under `specs/`. | D5.1–D5.4 |
| **Skill Content Gate** | The change creates or modifies a file under `.highway/skills/` or `.highway/library/`. | Delegated to the Highway Skills Constitution per D1.5 |

#### Constitution Check Output Shape

A plan records two parts:

1. **Process gates** — a verdict for every gate whose trigger evaluates true, by rule ID.
2. **Skill content gates** — when the Skill Content Gate triggers, a verdict against the Highway
   Skills Constitution by rule ID; otherwise `N/A: Skill Content Gate not triggered`.

A plan with any FAIL does not proceed to tasks.

#### Governance

This document governs development activity only. Where it and the Highway Skills Constitution both
apply, they apply to different artifacts and cannot conflict; if an apparent conflict arises, the
Highway Skills Constitution prevails for artifact content and this document prevails for process.

##### Versioning Policy

- **MAJOR**: a principle is removed or redefined, or an obligation is strengthened so that
  previously conforming work now fails.
- **MINOR**: a principle or rule is added without invalidating conforming work.
- **PATCH**: wording repair with no change to any Observable.

##### Self-Application

This document is subject to D1.3, D1.4, and D5.3. Every amendment records a review against those
rule IDs.

---

## Appendix B — Candidate `X` rule families (seed for Phase 5)

Not yet rules. These are the families to draw from once a second skill exists. Each candidate must
be given a concrete Observable before it is admitted.

| Family | Governs | Example rule shape |
|---|---|---|
| **X1 Output structure** | Field order, labels, required and optional sections in emitted artifacts | "Emitted registration output MUST present fields in the declared contract order." |
| **X2 Interaction protocol** | When a skill asks rather than proceeds; confirmation before destructive acts; progress reporting | "A skill MUST confirm before overwriting a user file it did not create." |
| **X3 Terminology register** | One term per concept across all skills; a closed vocabulary | "Emitted content MUST NOT use a synonym for a term defined in the Highway glossary." |
| **X4 Artifact placement** | Where generated files land, how they are named, collision behaviour | "A generated artifact MUST be written to the path declared in the skill's Outputs." |
| **X5 Provenance** | Citation of sources in generated content; traceability to inputs | "A generated recommendation MUST cite the input artifact it derives from." |
| **X6 Determinism** | Same inputs produce the same output; regeneration safety | "Regenerating an artifact from unchanged inputs MUST produce a byte-identical file." |

X6 already has a working precedent: the hash-manifest and drift-refusal mechanism in
`.highway/tools/generate-agent-adapters.sh`. Generalise that rather than inventing a second
mechanism.

The per-skill output contracts written under `specs/` become instances of X1 and X5 rather than
standalone documents.
