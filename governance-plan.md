# Highway Governance Implementation Plan

Sequenced plan for establishing Highway's governance layers. This document is durable working
context: it is written to survive across sessions so the sequence, rationale, and exact command
invocations do not have to be reconstructed from conversation history.

**Status**: Phases 1, 2, 2b, 3, 4, 4b, 4c, 5, 6 and 11 complete. Phase 7 is delivered with
recorded gaps — both skills ship; five of `highway-nfrs`'s functional requirements are
unimplemented. Phases 8 and 9 remain deferred and independent. Phase 10 is complete through
Feature 021 and owns the rule defects that let those gaps pass every gate. Phases 12 and 13 are
proposed; together they own the defects found reviewing Features 022–038, with 13 gated on 12.

**Last reviewed**: 2026-09-10 (Features 022–038 reviewed; Phases 12 and 13 opened)

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
| 3 | Packaging contract and verification | Spec | 0/1 | ✅ Complete (feature 012) |
| 4 | Make the Skills Constitution's `[auto]` tier honest | Spec | 1 | ✅ Complete (feature 013) |
| 4b | Make the Development Constitution's `[auto]` tier honest | Spec | 0 | ✅ Complete (feature 014) |
| 4c | Keep the catalog and adapters true to the skills on disk | Spec | 0/1 | ✅ Complete (016) |
| — | **Gate**: a second skill exists | — | — | ✅ Cleared (feature 015) |
| 5 | Author the Experience Standard | Spec | 2 | ✅ Complete (017) |
| 6 | Enforce the Experience Standard | Spec | 2 | ✅ Complete (018) |
| 7 | Build the `nfrs` and `controls` skills | Spec | 2 governs; 3 is the subject | 🔶 Delivered with recorded gaps — `highway-controls` (019) and `highway-nfrs` (020) both ship; five FRs unimplemented |
| 8 | Make a skill's help detail answerable for itself | Spec | 1 | Deferred — independent of all other phases |
| 9 | Make artifact versions accountable | Spec | 1, and a cross-layer question | Deferred — independent of all other phases |
| 10 | Make a completion claim accountable | Spec | 0 | ✅ Complete (feature 021) |
| 11 | Require shared templates for a skill's emitted output | Spec | 1 states the obligation; 0 states the drift guard | ✅ Complete (feature 022) |
| 12 | Make the completion record enforceable | Spec | 0 | Proposed — independent of all other phases |
| 13 | Reconstruct the pre-`021` completion record | Spec | 0 | Proposed — gated on Phase 12 |

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
(`specs/012-distribution-packaging`)

**Status**: ✅ **Complete**, 2026-09-08. 26 tasks; 15 tests passing.
`generate-distribution.sh` produces the distribution from `.distribution-manifest`, verifies it
with three checks, and refuses to overwrite a target it did not produce. Two runs are
byte-identical.

**Two findings worth carrying forward**: the packaging tooling had to be excluded from the
distribution it produces, because `generate-distribution.sh` necessarily contains the literal
development-path tokens its own verification searches for — including it would make every
distribution fail its own check. That in turn forced classification to be evaluated per file
rather than per directory, since the excluded tooling sits inside an included directory. The same
problem then appeared in the new test, resolved by assembling the token at runtime rather than
exempting the file, so no check lost coverage.

**Goal**: Producing the user-facing distribution is a repeatable, verified build step rather than a
manual strip.

**Why now**: Phase 1 fixes today's coupling; this phase prevents tomorrow's. Without it, every
future feature can silently reintroduce a development-tree dependency.

**Prerequisite**: Phase 2 complete.

**Command**:

```text
/speckit.specify "I want a repeatable packaging step that produces the user-facing Highway distribution from this repository, because I develop Highway with Spec Kit but ship it without Spec Kit, and today that strip is manual and unverified. Every path in the repository must be declared as either shipped or development-only, with no ambiguity, and the packaging tool must read that declaration rather than hard-coding a list. After packaging, the tool must verify the result is self-contained: no file in the package references .specify/ or specs/, every documentation cross-reference in the package resolves to a path inside the package, and the skill validator runs successfully against the packaged tree with the development directories absent. Packaging the same commit twice must produce byte-identical output. Follow the same drift-refusal and hash-manifest pattern that generate-agent-adapters.sh already uses. Add tests so that a packaging regression fails in the test suite rather than at a user. I also need to decide and record whether the package includes the authoring toolchain under .highway/tools/ and the Layer 1 constitution, or only the runtime skills, catalog, library, and agent adapters."
```

**Decision recorded 2026-09-08**: **runtime plus toolchain, minus tests**. The distribution
carries skills, catalog, library, agent adapters, `.highway/tools/` and `.highway/governance/`.
It excludes `.highway/tools/tests/`, whose fixtures are deliberately non-conformant and which
nothing outside that directory references. The distribution also gets its own front page, because
the repository's addresses a contributor and references a development-only location.

Runtime-only was recorded first and reversed the same day. Three findings drove the reversal:

1. **The rule-id contract cost was already borne.** The constitution already states that rule IDs
   are stable across amendments and a retired ID is never reused. Shipping the toolchain makes an
   existing commitment visible rather than creating a new one.
2. **It repairs D1.2.** Under runtime-only, D1.2's Observable described a tree containing the
   validator, which the distribution was not — logged as amendment debt. With the toolchain
   included the rule is literally true again and no amendment is needed.
3. **Self-containment becomes provable.** The validator resolves its governing document relative
   to its own location, so under runtime-only, running it against the distribution proved only
   that skill content was conformant. Run from *inside* the distribution it proves the toolchain
   is self-contained, which was the original intent.

Shipping the validator alone was considered and rejected: the generators write to the directory
above the framework root, so without them a recipient could validate a skill they had no way to
deploy.

**Done when**:

- Every repository path is declared shipped or development-only.
- The packaging tool produces a self-contained tree, verified by the four checks above.
- Two consecutive runs from the same commit produce no diff.
- Packaging regressions fail in `run-all.sh`.

---

### Phase 4 — Make the Skills Constitution's `[auto]` tier honest

**Layer**: 1 **Type**: Spec (`specs/013-auto-tier-honesty`)

**Status**: ✅ **Complete**, 2026-09-08. 26 tasks; 15 tests passing. Constitution 2.2.0 (MINOR).
`P6.4` is decided by `rc_check_P6_4` against a token list declared in the constitution; `P2.3` is
retagged `[agent-checkable]`. The `UNCHECKED` group is empty for every skill and the inventory
test fails if that ceases to be true. `AUTO_TIER_ENFORCEMENT` removed; the follow-up list is
empty.

**Two findings worth carrying forward**: the first pre-evaluation run reported every fixture as
passing, and every one of those results was false — `awk -v` rejects an embedded newline and
fails the whole program, so the check never ran. D3.4's "evaluate before enabling" caught it
exactly as intended. Second, the guard is scoped to this document and says so in its failure
message; an unscoped guard would have reported all-clear while the development constitution
carried the same defect.

**Goal**: Every rule tagged `[auto]` is actually checked by a script, so the tier tag stops
promising enforcement that does not exist.

**The gap is two rules, not fourteen.** Verified 2026-09-08: fifteen `P` rules carry `[auto]`,
thirteen have registered checks, and the validator names the exceptions itself in every run —
`UNCHECKED: P2.3 P6.4`. An earlier draft of the command below said fourteen; that figure was
wrong and is corrected here. The thirty-four rules shown as `DEFERRED` are `[agent-checkable]` and
`[human-review]`, correctly not automated.

**This is a prior decision arriving late.** Feature 003 analysed both rules and deferred them to
"amendment 2.0.2", which never happened — the constitution went `2.0.1 → 2.1.0` during feature
011, skipping it. Its tasks T046 and T047 are still unchecked. Feature 013 is that amendment.

**Resolution**: P6.4 gets a real check, backed by a token list declared in the constitution
(matching the Prohibited Vagueness List precedent). P2.3 is retagged `[agent-checkable]`, because
deciding whether an example is technology-specific is semantic and every mechanical proxy
under-detects.

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
- The guard states which governing document it covers.

---

### Phase 4b — Make the Development Constitution's `[auto]` tier honest

**Layer**: 0 **Type**: Spec (`specs/014-dev-tier-honesty`)

**Status**: ✅ **Complete**, 2026-09-08. 24 tasks; 16 tests passing. Development constitution 1.1.0
(MINOR). Tier counts `[auto]` 10 → 6, `[agent-checkable]` 14 → 18. `D_AUTO_TIER_ENFORCEMENT`
closed; the follow-up list is empty. The guard now covers both constitutions and names the
offending document in every failure.

**The decision worth remembering**: `[auto]` means something *different* in the two documents, and
the Development Constitution now says so. There it means a test in `run-all.sh` decides the rule
and an **Enforcement Map** names which one. It does **not** require reporting under the rule id,
because that is Layer 1 machinery — no validator runs against a `tasks.md` or a working tree. The
same tag is used in both because it answers the same reader question: will something catch me.

**Three findings worth carrying forward**:

1. **`lib/constitution.sh` is P-namespace-bound.** `con_rules()` matches `P[0-9]+\.[0-9]+` and
   returns nothing for a `D` rule. The first version of the extended guard therefore passed
   without ever iterating. Generalising the shared parser was rejected — it is distributed to
   users, and teaching shipped code to read a document that never ships is the same category
   error as shipping the packaging tooling. The guard carries its own minimal reader, plus an
   assertion that the reader matched something, so the vacuity cannot recur silently.
2. **The guard's own file tripped `shipped-tree-independence`**, because it must name the
   development constitution's path. Resolved by assembling the token at runtime, the precedent
   feature 012 set, rather than exempting the file from a check that should cover it.
3. **D6.2 was retagged rather than widened.** Measured: 145 link targets repository-wide, 8
   unresolvable, none a genuine defect. Two were in `.highway/DISTRIBUTION.md`, which is authored
   for the distributed tree where it lands at the root and where those targets do resolve. A
   whole-tree check would need four exemption classes and would flag a correct document.

**Goal**: The `D` namespace stops claiming automation it does not have.

**Why this is a separate phase rather than a TODO**: it was going to be a `TODO(...)` entry. The
evidence in this repository says that mechanism decays. Feature 011 found three of four `TODO`
entries already satisfied but never removed; feature 003's two deferred tasks sat unnoticed for
the life of the project and were found only by grep. Numbered phases in this document have
actually been executed. So this is a phase.

**The verified gap** (2026-09-08): ten of twenty-five `D` rules are tagged `[auto]`. Three `D`
ids appear anywhere under `.highway/tools/` — `D1.6`, `D3.5`, `D4.3` — and all three are comment
citations, not checks. In practice no `D` rule is decided by a script. The constitution records
this as `TODO(D_AUTO_TIER_ENFORCEMENT)`.

**Why it is genuinely harder than Phase 4**, and must not be assumed to be the same shape:

- There is no validator to extend. `validate-skill.sh` runs against a `SKILL.md`; nothing runs
  against a `tasks.md`, a `plan.md`, or a working tree.
- Several `D` rules are about *process over time*, not about a file. D3.1 and D3.2 require a
  passing suite before and after a change — that is a claim about two moments, which a static
  check cannot observe.
- Some are already enforced in substance by named tests rather than by rule id. D1.1 is decided by
  `shipped-tree-independence.test.sh`; D1.2 and D4.3 by `distribution-packaging.test.sh`. The
  honest question for those is whether "a test enforces it" counts as `[auto]`, or whether `[auto]`
  requires reporting under the rule id as the `P` side does.

That last question should be settled first. It may resolve most of the gap without writing a
single new check.

**Prerequisite**: Phase 4 complete, so the `P`-side pattern and the guard exist to follow.

**Command**:

```text
/speckit.specify "I want the Highway Development Constitution's [auto] tier to be honest, the same way feature 013 made the Skills Constitution's tier honest. Ten of its twenty-five D rules are tagged [auto], but no script decides any of them by rule id: only D1.6, D3.5 and D4.3 appear anywhere under .highway/tools/, and all three are comment citations rather than checks. Before writing anything, settle what [auto] means for a Layer 0 rule, because there is no validator that runs against a tasks.md or a plan.md the way validate-skill.sh runs against a SKILL.md. Several D rules are already enforced in substance by named tests — D1.1 by shipped-tree-independence.test.sh, D1.2 and D4.3 by distribution-packaging.test.sh — so decide first whether an enforcing test counts as [auto] or whether [auto] requires reporting under the rule id, and record that decision. Then either enforce each remaining [auto] rule under that definition or retag it, recording each retag as an amendment. Rules that constrain process across time rather than the content of a file, such as D3.1 and D3.2 requiring a passing suite before and after a change, are the hardest cases and may not be automatable at all. Extend the tier-honesty guard added by feature 013 to cover this document too, so both constitutions are checked rather than one. Remove TODO(D_AUTO_TIER_ENFORCEMENT) once the tier is honest."
```

**Done when**:

- What `[auto]` means for a Layer 0 rule is written down, not assumed.
- Every `D` rule tagged `[auto]` meets that definition, or has been retagged with a recorded
  reason.
- The tier-honesty guard covers both constitutions.
- `TODO(D_AUTO_TIER_ENFORCEMENT)` is removed, leaving the follow-up list empty.

---

### Phase 4c — Keep the catalog and adapters true to the skills on disk

**Layer**: 0 governs the build step; Layer 1 artifacts are its subject **Type**: Spec
(`specs/016-artifact-correspondence`)

**Status**: ✅ **Complete**, 2026-09-08. 37 tasks; 17 tests passing. Development constitution 1.2.0
(MINOR). `D4.5`, `D4.6` and `D4.7` added, all `[auto]`, all decided by `adapter-coverage.test.sh`,
each with an Enforcement Map row. A Correspondence Gate was added because the Generator Gate
triggers on a change to a generator, which is the wrong trigger for rules violated by changing a
generator's *input*.

**Two live violations were found, both committed, both passing a green suite**:

1. **The library catalog was stale.** Feature 015 added the requirements questionnaire and never
   regenerated `library-index.json`, which recorded `"entries": []`. The artifact that feature
   exists to deliver was absent from the library index. Found by the D4.7 prototype on its first
   run, before it was written as a test.
2. **Four orphan rows in `.adapter-manifest`** — three naming `sample-echo`, a fixture skill that
   no longer exists, and one naming `help` at version 2.0.0, the pre-rename id left over from
   feature 009. None of the four files existed on disk.

Both were repaired before the rules were enabled. That ordering is what kept the amendment MINOR:
enabling a rule against a tree that violates it is a strengthening, which the versioning policy
classifies MAJOR. Repairing a defect is not the same as redefining a rule.

**Three findings worth carrying forward**:

1. **The pre-evaluation required by D3.4 changed the design twice.** It found that
   `.github/skills/` holds ten `speckit-*` directories that this repository does not generate — a
   naive orphan scan over the agent trees would have flagged every one. The manifests, not the
   directories, are the authority on which adapters are ours.
2. **A failure proof found a gap the spec had not.** Removing a skill's adapter manifest rows
   produced *no* failure, because D4.5's Observable listed the catalog, the adapters, and the
   distribution rows but not the adapter manifest. The Observable was widened and the check added.
   The task deliberately said to record the verdict rather than assume it, which is why it was
   caught.
3. **Currency is checked by regenerating into a temp tree, never in place.** The generators
   resolve every path from their own location, so a copy is self-contained. Regenerate-and-restore
   would leave the repository modified whenever the check exited between the two steps.

**Goal**: Adding, changing, or removing a skill leaves the catalog, the adapters, and the
distribution manifest agreeing with what is actually in `.highway/skills/`.

**Why this exists**: `highway-help` answers from `.highway/catalog/index.json`, and an agent sees
a skill through its generated adapters. Both are produced from the skills directory and neither is
checked against it. A skill can therefore be present and unlisted, or listed and absent, with
every gate passing.

**The verified gap** (2026-09-08). No rule in any of the three governance documents requires a
skill to be registered. The nearest obligation is D4.1 — re-running a generator must produce no
diff — which does cover a stale catalog in substance, but arrives sideways through
generated-artifact integrity rather than as a stated rule an author would find. Nothing enforces
it: `generate-catalog.test.sh` checks the catalog's structure, never its contents against the
skills on disk.

**Three cases, and only one of them is the obvious one**:

| Case | What breaks | Severity |
|---|---|---|
| **Added** | Skill exists, catalog has no entry. `highway-help` cannot see it. Feature 015 also found the adapters are silently excluded from the distribution unless manifest rows are added by hand. | Invisible skill |
| **Changed** | Description, usage, or version moves in the source and the catalog still reports the old value. `highway-help` answers confidently and wrongly. No rule states the obligation and no test detects the violation — see below. | Silent misinformation |
| **Removed** | **Worst.** Neither generator prunes — verified. A deleted skill leaves a catalog entry, three orphaned adapters, rows in `.adapter-manifest`, and rows in `.distribution-manifest`. Because those rows say `include`, **the orphaned adapters still ship**. A recipient gets a skill with no source, listed by `highway-help`, that nobody can maintain. | Ships a ghost |

**Decided: this becomes a stated rule, not a check alone.** Feature 011 settled the general
question — a test without a written rule leaves the constraint discoverable only by failing the
suite — and the routing test in §2 places it: the obligation constrains generated artifacts of the
build, so it is **Layer 0** and takes `D` ids.

**Why the existing rules do not already cover this.** Two of them look as though they might, and
neither does. Verified 2026-09-08:

| Rule | What it actually says | Why it falls short |
|---|---|---|
| D4.1 | *"A generated artifact MUST NOT be hand-edited."* Observable: re-running its generator produces no diff. | The **rule** is about hand-editing. Someone asking "must I regenerate after changing a skill's description?" finds no answer in it. Its Observable happens to detect staleness, but an obligation that exists only as a side-effect of an Observable is exactly what a stated rule is for. Worse, its Enforcement Map row names `generate-agent-adapters.test.sh`, which asserts hand-edit refusal for adapters and never regenerates the catalog at all. |
| D4.4 | A change to a **generator** must be followed by regeneration. | The generator is unchanged when a skill's description moves. This is the sibling case, not this one. |

`generate-catalog.test.sh` looks like it closes the gap and does not: it runs the generator twice
against **unchanged** inputs, which is D4.2's determinism, never comparing the committed catalog
against the current skills.

So three obligations are missing, in three different directions:

| ID | Rule | Observable | Tier |
|---|---|---|---|
| D4.5 | Every skill in the source MUST have its generated artifacts. | Each directory under `.highway/skills/` has a catalog entry, an adapter in each agent tree, and a distribution manifest row for each adapter. | [auto] |
| D4.6 | A generated artifact MUST NOT name a skill absent from the source. | No catalog entry, adapter file, adapter manifest row, or distribution manifest row names a skill with no directory under `.highway/skills/`. | [auto] |
| D4.7 | A change to a generator's input MUST be followed by regeneration. | Re-running every generator leaves no diff against the committed artifacts, aside from a recorded generation timestamp. | [auto] |

D4.5 catches the added skill, D4.6 the orphan left by a removed one, and D4.7 the stale entry left
by a changed one. D4.7 is the sibling of D4.4 — that one covers a changed generator, this one a
changed input — and its Observable deliberately carries the same timestamp exception D4.2 needs,
because `generate-catalog.sh` writes one.

**D4.7 is not a restatement of D4.1.** D4.1 prohibits touching the output; D4.7 requires
refreshing it after touching the input. Different obligations, and the non-restatement rules turn
on rule text rather than on Observables, which the two necessarily share.

All three are `[auto]`, so all three need Enforcement Map rows naming the test that decides them,
per the definition feature 014 wrote. Adding three rules is a MINOR amendment: `1.1.0 → 1.2.0`.

**D4.7 passes today** — verified 2026-09-08 by regenerating the catalog and diffing against the
committed copy, ignoring `generated_at`: no difference. So enabling it invalidates no conforming
work and the amendment stays MINOR rather than MAJOR. Confirm that again before enabling, because
the classification depends on it.

**Both existing skills already conform** — verified 2026-09-08:

| Skill | Catalog | Adapters | Distribution rows | Adapter manifest rows |
|---|---|---|---|---|
| `highway-help` | present | 3 of 3 | 3 | 4 |
| `highway-inquiry` | present | 3 of 3 | 3 | 4 |

No orphan exists in either direction. That is not a reason to skip this phase — it is the reason
to do it now. `highway-inquiry` conforms only because feature 015 added its manifest rows by hand
after planning happened to notice they were missing. Nothing would have caught the omission, and
nothing catches the next one.

**Use `highway-inquiry` as the subject of the failure proofs.** Because it conforms, each of the
four correspondences can be broken for it and then restored — remove its catalog entry, an adapter,
an adapter manifest row, a distribution manifest row — confirming the check fails each time and
passes again once restored. A round trip proves more than watching a check pass: it shows the
check is reading the thing it claims to read.

The check must be written over the set of skills present, not over an enumeration of the two that
exist today. An enumerated list is the defect this phase exists to remove.

**Prerequisite**: The Gate is cleared, which matters more than it sounds. With one skill this
defect was unobservable; the manifest's per-skill rows looked like a complete list rather than an
enumeration waiting to fall behind.

**Command**:

```text
/speckit.specify "I want the catalog and the generated agent adapters to stay true to the skills actually present in .highway/skills/, across adding, changing, and removing a skill, and I want that written as rules rather than left as tests somebody discovers by failing. Add three rules to the Highway Development Constitution at .specify/memory/constitution.md, under Principle IV, as a MINOR amendment taking it from 1.1.0 to 1.2.0. D4.5: every skill in the source MUST have its generated artifacts, observable as each directory under .highway/skills/ having a catalog entry, an adapter in each agent tree, and a distribution manifest row for each adapter. D4.6: a generated artifact MUST NOT name a skill absent from the source, observable as no catalog entry, adapter file, adapter manifest row, or distribution manifest row naming a skill with no directory under .highway/skills/. D4.7: a change to a generator's input MUST be followed by regeneration, observable as re-running every generator leaving no diff against the committed artifacts aside from a recorded generation timestamp. Tag all three [auto] and give each a row in the Enforcement Map naming the test that decides it, per the definition feature 014 recorded. D4.7 is needed because nothing today states or detects that a skill's description, usage, or version going stale in the catalog is a violation: D4.1's rule text is about hand-editing rather than currency, its Enforcement Map row names generate-agent-adapters.test.sh which never regenerates the catalog, and generate-catalog.test.sh only runs the generator twice against unchanged inputs, which is determinism rather than currency. D4.7 is not a restatement of D4.1 -- D4.1 prohibits touching the output, D4.7 requires refreshing it after touching the input -- and the non-restatement rules turn on rule text rather than on Observables, which these two necessarily share. Verify before enabling D4.7 that the committed catalog already matches the current skills, because if it does not this becomes a MAJOR amendment rather than a MINOR one; it did match on 2026-09-08. Enforce all three by extending the existing adapter-coverage.test.sh rather than adding a second mechanism that asserts an overlapping property, and write the checks over the set of skills present rather than over a list of the ones that exist today, because an enumerated list is the defect being removed. Both existing skills conform as of 2026-09-08, so use highway-inquiry as the subject of the failure proofs: break each correspondence for it in turn -- remove its catalog entry, then an adapter, then an adapter manifest row, then a distribution manifest row, then change its description without regenerating -- confirming the check fails each time and passes again once restored. A round trip proves the check is reading what it claims to read, where watching it pass proves nothing. Take care that a currency check does not leave regenerated files behind when it finishes. At the end, confirm every skill present conforms, naming highway-help and highway-inquiry explicitly. Decide separately whether the generators should prune what they no longer produce, or whether pruning stays a deliberate manual step that the check reports -- pruning is a delete, and a generator that deletes needs more care than one that writes."
```

**Done when**:

- D4.5, D4.6 and D4.7 are in the Development Constitution, tagged `[auto]`, each with an
  Enforcement Map row naming the test that decides it.
- The amendment is recorded as MINOR, `1.1.0 → 1.2.0`, with its reasoning, including confirmation
  that the committed catalog matched the current skills before D4.7 was enabled.
- The checks are written over the set of skills present, not over an enumerated list.
- The checks fail when a skill has no catalog entry, when an entry names no skill, when an adapter
  exists for no skill, when a manifest row names a skill that is gone, and when a skill's
  description changes without regeneration.
- Each of those five failures has been observed and then restored, using `highway-inquiry` as the
  subject, so the checks are shown to read what they claim to read.
- The currency check leaves no regenerated file behind when it finishes.
- Every skill present conforms — `highway-help` and `highway-inquiry` both named and confirmed.
- Whether generators prune is decided and recorded.
- No orphaned adapter can reach a distribution.

---

### Gate — A second skill exists

**Blocked**: Phase 5, until cleared.

**Status**: ✅ **Cleared**, 2026-09-08 by `highway-inquiry` (`specs/015-requirements-inquiry`).
26 tasks; 17 tests passing. It maintains the requirements discovery questionnaire at
`.highway/library/templates/requirements-inquiry.md`, so it asks the user questions, writes a file
they own, and produces derived content — the three behaviours the standard needs to generalise
from.

**Authored before the standard it will be held to**, as this gate anticipated. Phase 5 should
expect to revise it, the same relationship `highway-help` had to Layer 1.

**Two findings worth carrying forward**:

1. **A new skill's adapters were silently excluded from the distribution.** The manifest
   classifies adapters by exact path, and only `highway-help` had rows. A second skill's adapters
   matched the parent `exclude`, so packaging succeeded and the recipient's agent could not see
   the skill. Fixed with three rows and `adapter-coverage.test.sh`, which fails for any skill
   whose adapters are not included. The Skill Content Gate does not catch this — it asks whether
   skill content conforms, not whether the skill reaches anyone.
2. **P8.1 forced the questionnaire's rendering.** It requires every ordered list to restart at 1,
   reading each as a sequence of workflow steps. Questions numbered globally across sections —
   which is what makes "question 12" unambiguous — failed it. The questions are written as a bold
   number and text rather than as a Markdown ordered list, because they are not steps. Worth
   revisiting if a library exemption for P8.1 is ever wanted.

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

**Layer**: 2 **Type**: Spec (`specs/017-experience-standard`)

**Status**: ✅ **Complete**, 2026-09-08. 38 tasks; 17 tests passing. Experience Standard 1.0.0 with
8 `X` rules, all `[agent-checkable]`, plus 2 recorded candidates. Both skills cite the rules they
satisfy; `highway-help` 3.0.1 → 3.0.2 and `highway-inquiry` 1.0.0 → 1.0.1, both PATCH.

**The finding that shaped the document**: checking candidate rules against the 49 `P` rules found a
near-exact collision. The obvious first rule — *a skill must ask rather than guess when the
intended action is ambiguous* — **is `P1.7`**. Two more sat close: `P5.2` and `P4.6`. The boundary
that resolved it, and that the standard now rests on:

> `P` owns whether a behaviour must exist. `X` owns what that behaviour must look like.

`P1.7` requires a skill to ask; it says nothing about what the asking contains. `highway-inquiry`
already goes further than `P1.7` requires, aborting *"naming every candidate question"*, and that
surplus is Layer 2 material. A third collision surfaced during implementation: `P6.6` is a
determinism rule, but about which *action* is selected rather than what an artifact *contains*.

**Three findings worth carrying forward**:

1. **The best-evidenced rule came from a disagreement, not agreement.** `highway-help` prints an
   exact error string; `highway-inquiry` deliberately omits rule identifiers for framework-owned
   parts — *"Loud about their content, quiet about the framework's."* Mandating either style makes
   one skill wrong. `X5.1` is what both satisfy: a message must name something its reader can act
   on. Two skills agreeing may be one author's habit; two differing with a stated reason is a real
   distinction.
2. **Five of eight rules rest on a single skill**, not three as first drafted. The Sync Impact
   Report initially undercounted, and the discrepancy surfaced only when the Sample column was
   read back mechanically. `X1.3` rests on `highway-help` alone for the opposite reason to the
   others — `highway-inquiry` has no empty-result case.
3. **The restatement review restated.** The first draft paraphrased `P1.7` as "requires
   clarification when an input is absent or self-contradictory", which is that rule's text minus
   one word. Rewritten to state the *distinction* and cite the ID. A review that reproduces what it
   is distinguishing from defeats itself.

**`D4.7`'s first outing on another feature**: editing both skills left the catalog and four
adapters stale, `adapter-coverage.test.sh` named all six, and regeneration cleared it. The rule
written in Phase 4c did the job it was written for.

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

**Layer**: 2 **Type**: Spec (`specs/018-experience-enforcement`)

**Status**: ✅ **Complete**, 2026-09-08. 42 tasks; 17 tests passing. Experience Standard 1.1.0
(MINOR). All nine `X` rules are inventoried and appear in exactly one coverage group; `UNCHECKED`
is empty for both skills. `highway-help` 3.0.2 → 3.0.3, `highway-inquiry` 1.0.1 → 1.0.2.

**The measured outcome, reported rather than targeted**: of nine `X` rules, **one** is decided by
a script and **eight** remain `[agent-checkable]`. Seven govern runtime output — prompt wording,
message content, artifact contents — that no static check reading a `SKILL.md` can observe. The
inventory, not the automation, is what this phase delivered.

**The one automated rule was derived from a defect, not reasoned toward.** `X1.4` — a specimen
agrees with the metadata it repeats — was added because the drift was found first: `highway-help`'s
Example showed `Version: 3.0.1` against a frontmatter of `3.0.2`, introduced by feature 017 and
copied into three agent trees. Rules found this way come with their own failing case; rules reasoned
toward tend to arrive with a proxy that cannot fail.

**It caught its own author within seconds.** Bumping `highway-help` to 3.0.3 during this feature
left the Example at 3.0.2, and the newly enabled check reported it immediately. The same defect,
by the same hand, twice in one day — which is the argument for the rule better than any reasoning.

**Four findings worth carrying forward**:

1. **The P-namespace binding appeared a third time.** `con_rules()` matched `P[0-9]+\.[0-9]+`
   (feature 014 found this), and so did the N/A-entry assertion in `rule-checks.test.sh`. Widening
   the shared pattern is not enough — every consumer that re-derives a namespace needs checking.
2. **Two existing tests caught the change before any new test did.** `coverage-summary.test.sh`
   failed because the validator reported 57 ids against an expectation built from one document, and
   `rule-checks.test.sh` refused a rule registered without a seeded violation case. Both were
   strengthened rather than weakened, per `D3.5`.
3. **A planned check was abandoned on evidence.** Comparing an Example against the field list its
   Outputs section declares looked feasible and is not: extracting `highway-help`'s six declared
   labels returns eight, because two recur in prose describing another mode. Recorded as a
   candidate in the standard rather than shipped as a proxy that would pass by luck.
4. **Scoping is now a stated contract.** Once the pattern accepts `X`, only the caller's document
   list keeps experience rules away from library content. `validate-library.sh` loads the
   constitution alone, and says why at the call site.

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

**Status**: 🔶 **Delivered with recorded gaps**, 2026-09-08. `highway-controls` complete
(`specs/019-repository-controls`): 47 tasks; 18 tests passing. `highway-nfrs` shipped
(`specs/020-highway-nfrs`): 54 tasks; 20 tests passing; registered, generated and validated. Five
functional requirements are unimplemented — FR-002, FR-020, FR-024, FR-027 and FR-032 — and
several tasks were marked complete without the work they describe. Both baselines are usable and
the containment boundary holds; the shortfall is in advice wording, ambiguity branches and test
depth. Phase 10 owns the rule defects that let it through; the residual FR work belongs to a new
numbered spec under D5.2, not to an edit of 020.

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

### Phase 8 — Make a skill's help detail answerable for itself

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

### Phase 10 — Make a completion claim accountable

**Layer**: 0 **Type**: Spec

**Status**: Complete with one unmet criterion, 2026-09-08; the exception recorded 2026-09-10. The
Development Constitution is 1.3.0 with D3.6 and D7.1-D7.3; D7.2 is enforced by
`completion-coverage.test.sh`. Historical features without coverage are reported as missing rather
than rewritten, and Feature 020's five residual requirements remain deferred. **The Done-when
below requiring Feature 020's coverage record to exist was never met** — verified 2026-09-10,
`specs/020-highway-nfrs/` holds no coverage record under any name and the check reports
`PRE_ENABLE: 020-highway-nfrs MISSING_COVERAGE`. Phase 12 owns the correction; it is listed there
rather than resolved here, because D5.1 and D5.2 forbid amending a completed phase's record in
place.

**Goal**: A task marked complete, and a report saying a feature is done, are required to be *true*.
Today both are self-asserted and nothing objects.

**The verified gap** (2026-09-08, from feature 020). Every gate passed: `run-all.sh` reported
`20 passed, 0 failed`, `adapter-coverage.test.sh` passed, both skill validators returned valid, the
requirements checklist read 16 of 16, and all 54 tasks were marked `[X]`. The feature was reported
complete. It was not:

| Claim | Reality | What should have caught it |
|---|---|---|
| T052 — quickstart scenarios run against isolated fixtures | Never run; scenarios 2 and 4–6 are interactive and 1 and 3 were not executed | Nothing requires a completed task's described work to exist |
| T011, T012, T021–T023, T028, T029, T039–T041 — behavioral assertions added to `nfr-management.test.sh` | The file contains no Add, `next_id`, Remove, Set, high-water, Update, PATCH, or ambiguity assertion; it greps skill prose for fifteen fixed strings | Nothing requires a test to be capable of failing for the behavior it claims |
| T009 — shared fixtures added | Fixtures created under `tools/tests/fixtures/nfr/`; no test references them | Same as above |
| T017, T018, T036, T039 — skill content added | Generator-exclusion assertions, the prose-rule exemption, the improved-alternative obligation, and the update-versus-replace branch are all absent | Nothing traces a requirement to the artifact satisfying it |
| FR-002, FR-020, FR-024, FR-027, FR-032 satisfied | Unimplemented | Same as above |

**Why the existing rules do not cover this.** Each of the four nearest rules is satisfied by the
work as delivered, which is the point:

| Rule | Says | Why it passed anyway |
|---|---|---|
| `D3.1`/`D3.2` | Begin and end from a passing suite | The suite passed at both ends. A suite of prose greps passes easily |
| `D3.3` | A behavioral change MUST add or amend at least one test | Two test files were added. The rule counts edits, not assertions |
| `D3.5` | A test MUST NOT be weakened | Nothing was weakened. The tests were born weak |
| `D4.5`/`D4.7` | Generated artifacts correspond to source | They do. Correspondence says nothing about whether the source satisfies its spec |

The shape is the one Phase 8 records at Layer 1: a field that exists, looks maintained, and is
accountable to nothing. Here the field is a checkbox.

**This is Layer 0, all four rules.** The routing test in §2 places them without argument: they
constrain a `tasks.md`, a `spec.md`, a test file, and a maintainer's report — artifacts that exist
only to build Highway and never ship. No part of this phase touches a `SKILL.md`, so no `P` rule
is involved and no amendment to the shipping constitution is needed.

**Four rules, tiered by what can honestly be decided mechanically**:

| ID | Rule | Observable | Tier |
|---|---|---|---|
| D3.6 | A test MUST be observed failing for the behavior it claims to cover before that behavior is marked complete. | The failing run and its message are recorded before the implementation that makes it pass. | [agent-checkable] |
| D7.1 | A task MUST NOT be marked complete unless the artifact it names contains the change it describes. | Each `[X]` task's named path exists and contains the described change. | [agent-checkable] |
| D7.2 | A completed feature MUST record a requirement-coverage mapping. | Every requirement id in `spec.md` appears exactly once in the feature's coverage record, against a satisfying artifact or a stated deferral. | [auto] |
| D7.3 | A completion report MUST state requirement coverage separately from check results. | The report makes the suite result and the requirement coverage two distinct claims. | [agent-checkable] |

D7.1 and D7.3 are `[agent-checkable]` because deciding whether a file *contains the change a
sentence describes* is semantic, and every mechanical proxy under-detects. Tagging either `[auto]`
would reintroduce exactly the dishonesty Phases 4 and 4b removed. D7.2 is the mechanical partner
and is genuinely decidable — comparing two sets of ids needs no judgment — and it is the rule that
would have caught FR-002, FR-020, FR-024, FR-027 and FR-032 before the feature was reported
complete.

**D3.6 is the generalisation of an existing precedent, not a new idea.** `D3.4` already requires a
new validation check to be evaluated before it is enabled, and Phase 8's Done-when already requires
a check to be *observed failing and then passing again*. D3.6 states for tests what `D3.4` states
for checks. Placing it in Principle III keeps the verification rules together; D7.x opens a new
principle because completion integrity is about the record rather than the run.

**What deliberately stays out.** No rule here says a test must be behavioral rather than static.
A prose-contract test is the correct instrument when the artifact under test is agent instructions
rather than executable code, which is exactly what a `SKILL.md` is. The defect in feature 020 was
not that the tests were static; it was that the tasks claimed assertions the tests did not contain.
D3.6 and D7.1 address the claim, not the technique.

**Prerequisite**: None. Independent of Phases 5, 6, 7, 8 and 9.

**Command**:

```text
/speckit.specify "I want a completion claim to be accountable, because today a task is marked complete by asserting it and nothing objects. Verified 2026-09-08 in feature 020: the suite reported 20 passed 0 failed, adapter coverage passed, both skill validators returned valid, the requirements checklist read 16 of 16, all 54 tasks were marked complete, and the feature was reported done -- while five functional requirements were unimplemented, one task claimed a quickstart run that never happened, ten tasks claimed behavioral assertions that the test file does not contain, and one task created fixtures that no test references. The four nearest existing rules all passed: D3.1 and D3.2 because the suite was green at both ends, D3.3 because it counts test-file edits rather than assertions, D3.5 because nothing was weakened -- the tests were born weak -- and D4.5 and D4.7 because generated artifacts corresponded to a source that did not satisfy its spec. Add four rules to the Highway Development Constitution at .specify/memory/constitution.md as a MINOR amendment, all Layer 0 because they constrain a tasks.md, a spec.md, a test file and a maintainer's report, none of which ship. D3.6 in Principle III: a test MUST be observed failing for the behavior it claims to cover before that behavior is marked complete, observable as the failing run and its message being recorded before the implementation that makes it pass, tagged [agent-checkable]; this generalises D3.4 from validation checks to tests. Open a new Principle VII for completion integrity. D7.1: a task MUST NOT be marked complete unless the artifact it names contains the change it describes, observable as each completed task's named path existing and containing the described change, tagged [agent-checkable] because deciding whether a file contains what a sentence describes is semantic. D7.2: a completed feature MUST record a requirement-coverage mapping, observable as every requirement id in spec.md appearing exactly once in the coverage record against a satisfying artifact or a stated deferral, tagged [auto] and decided by a registered check, because comparing two sets of ids needs no judgment. D7.3: a completion report MUST state requirement coverage separately from check results, tagged [agent-checkable]. Do not tag D7.1 or D7.3 [auto] and do not write a proxy check that cannot fail, because that is the dishonesty features 013 and 014 removed. Add the D7.2 check to the test suite with an Enforcement Map entry naming it, evaluate it against every existing completed feature before enabling it per D3.4, and prove it can fail by removing a requirement id from a coverage record. Do not add any rule requiring a test to be behavioral rather than static: a prose-contract test is correct when the artifact under test is agent instructions, and the defect was the claim, not the technique."
```

**Done when**:

- `D3.6` and `D7.1`–`D7.3` are in the Development Constitution with Observables and tiers, recorded
  as a MINOR amendment in its Sync Impact Report.
- A new Principle VII exists for completion integrity, and Principle III carries `D3.6`.
- `D7.2` is decided by a registered check named in the Enforcement Map, evaluated against every
  completed feature before it was enabled, and observed failing and then passing again.
- `D7.1` and `D7.3` are tagged `[agent-checkable]`, with no proxy check that cannot fail.
- Feature 020's coverage record exists and names FR-002, FR-020, FR-024, FR-027 and FR-032 as
  unsatisfied, so the first artifact the new rule produces is an honest one.
- No rule is added requiring a test to be behavioral rather than static.

---

### Phase 11 — Require shared templates for a skill's emitted output

**Layer**: 1 states the citation obligation; 2 states retained-file frontmatter; 0 states the drift guard **Type**: Spec

**Status**: ✅ **Complete**, 2026-09-09, through `specs/022-shared-output-templates`. `P9.1` is in
the Skills Constitution under Principle IX and is decided by `rc_check_P9_1` under exception `N4`;
`D8.1` is in the Development Constitution under Principle VIII; `X1.5` is in the Experience
Standard. `.highway/library/templates/output/` holds complete skeletons, and every file-emitting
skill authored since — `highway-profile` and `highway-objectives` as well as `highway-nfrs` and
`highway-controls` — cites one. This is the one phase in this plan whose rule was still holding
when Features 023–038 were reviewed.

**Goal**: A skill that emits a file draws that file's full structure — frontmatter *and* body,
not frontmatter alone — from a shared template under `.highway/library/templates/output/`, cited
rather than restated, so two skills emitting the same kind of record cannot silently diverge in
their fields, their section order, or their prose shape.

**The verified state, not yet a defect** (2026-09-09). `highway-nfrs` and `highway-controls`
currently declare near-identical output on both counts. Frontmatter: `id`, `title`, `status`, plus
a cross-reference array (`controls: []` on an NFR, `nfrs: []` on a Control). Body: each Outputs
section describes the same shape — a Markdown statement followed by a rationale. Both alignments
exist only because both skills were authored in the same phase by the same hand. Nothing requires
either to hold, and nothing would catch the next skill, or an edit to either one, drifting from
the other in its fields, its section order, or both. This is the same shape of gap Phase 7 closed
for containment before it was violated rather than after: fix the missing guard while there are
only two skills to check, not after a third makes divergence likely.

**A near-collision was checked before drafting rule text, per the precedent Phase 5 set.**
`X1.1` already requires a skill to declare the shape of what it emits, and `X1.2` already requires
emitted content to follow that declared shape — and "shape" there already means the whole file,
not only its frontmatter. A cited template is one way of declaring a shape, so neither rule needs
amending — the gap is not "nothing governs output shape", it is "nothing requires the declaration
to route through shared, citable machinery instead of independent prose in each skill". That is a
citation discipline, the same shape as `P7.3` (no restating another skill's rule) and `D1.3`/`D1.4`
(no restating rule text) — so this becomes one `P` rule, not a new `X` rule. Keeping this out of
the `X` namespace is what keeps the amendment small.

**Three rules, in three governance documents**:

| ID | Document | Rule | Observable | Tier |
|---|---|---|---|---|
| P9.1 | Highway Skills Constitution (new Principle IX) | A skill that emits a file MUST cite a template rather than restate the file's structure. | The Outputs section names a path under `.highway/library/templates/output/` in place of describing frontmatter fields or body sections directly. | [auto] |
| D8.1 | Development Constitution (new Principle VIII) | A change to a shared library artifact MUST be followed by re-validation of every skill that cites it. | Each skill naming that artifact is re-checked, and its emitted output still matches, in both frontmatter and body. | [agent-checkable] |
| X1.5 | Experience Standard (X1 — Output structure) | Every retained file artifact emitted by a skill MUST include frontmatter. | Each retained emitted file begins with frontmatter; transient messages and other non-file output are excluded. | [agent-checkable] |

D8.1 is `[agent-checkable]`, not `[auto]`, because deciding whether a skill's *emitted* output —
frame or body — still matches a changed template is a runtime, semantic question — the same
reasoning that keeps `D7.1` and `D3.5` off the `[auto]` tier. Tagging it `[auto]` here would be the
exact dishonesty Phases 4 and 4b removed. Principle VIII is new in the `D` namespace, generalized
to "a shared library artifact" rather than named for templates specifically, because
`requirements-inquiry.md` is already such an artifact and Phase 9's still-open library-versioning
question is the same kinship of problem: multiple things depending on one shared file that nothing
currently tracks the currency of. This phase does not attempt to resolve Phase 9; it should not
contradict whatever Phase 9 eventually decides about library-file versioning.

**Naming**: `.highway/library/templates/` already holds `requirements-inquiry.md`, a
question-content template `highway-inquiry` reads from — a different sense of "template" than an
output-file skeleton. New output templates live under a `templates/output/` subdirectory, and each
file there is a full skeleton — frontmatter block and body sections together — not a fragment
covering only one part, so the two senses of "template" never collide on disk or in a validator's
search path.

**This is a retroactive strengthening, not a green-field rule.** Verified 2026-09-09: neither
`highway-nfrs` nor `highway-controls` cites an external template today — both declare their full
output shape, frontmatter and body alike, inline in prose. Enabling P9.1 against the tree as it
stands fails both immediately. Per `D3.4`'s evaluate-before-enable discipline and the precedent
Phase 4c set, the extraction — writing `templates/output/nfr-record.md` and
`templates/output/control-record.md` as complete skeletons, and pointing each skill's Outputs
section at its template instead of its inline description — must happen in the same change that
turns the rule on, or the amendment is MAJOR rather than MINOR.

**Prerequisite**: None. Independent of Phases 5 through 10.

**Command**:

```text
/speckit.specify "I want every Highway skill that emits a file to cite a shared template covering that file's full structure -- frontmatter and body alike, not frontmatter alone -- rather than restate that structure in its own prose, so two skills emitting the same kind of record cannot silently diverge in either part. Verified 2026-09-09: highway-nfrs and highway-controls currently declare near-identical output on both counts -- frontmatter of id, title, status, plus a cross-reference array, and a body of a statement followed by a rationale -- but only because both were authored together, and nothing requires either alignment to hold. Before writing rule text I checked for a collision with the Experience Standard's X1.1 and X1.2, which already require a skill to declare its output shape, whole-file, and to follow it: a cited template is one way of declaring a shape, so neither needs amending, and this stays a single new P rule about citation discipline rather than a new X rule -- the same shape as P7.3 and D1.3/D1.4, which require citing rather than restating. Add P9.1 to the Highway Skills Constitution at .highway/governance/constitution.md, in a new Principle IX: a skill that emits a file MUST cite a template rather than restate the file's structure, observable as the Outputs section naming a path under .highway/library/templates/output/ in place of describing frontmatter fields or body sections directly, tagged [auto]. Add D8.1 to the Development Constitution at .specify/memory/constitution.md, in a new Principle VIII generalized to shared library artifacts rather than named for templates specifically, because requirements-inquiry.md is already such an artifact: a change to a shared library artifact MUST be followed by re-validation of every skill that cites it, observable as each citing skill being re-checked and its emitted output still matching in both frontmatter and body, tagged [agent-checkable] because deciding whether an emitted output still matches a changed template is semantic, and tagging it [auto] here would be the same dishonesty features 013 and 014 removed. Create .highway/library/templates/output/nfr-record.md and .highway/library/templates/output/control-record.md as complete skeletons -- frontmatter block and body section structure together -- holding exactly what both skills already declare, in a new templates/output/ subdirectory kept separate from requirements-inquiry.md, which is a question-content template rather than an output-file skeleton and must not be confused with one. Update highway-nfrs and highway-controls to cite their template paths from Outputs instead of restating frontmatter or body structure, bump each skill's version as a PATCH since the emitted output does not change, and regenerate the catalog and adapters. Verify before enabling P9.1 that both skills conform once the citation is added, per D3.4, because if either does not this becomes a MAJOR amendment instead of a MINOR one. Record both amendments in each document's Sync Impact Report. Do not write a rule requiring an emitted record's content -- only its declared structure -- since a template governs form and this project's containment principle already settles that a user's own values within that structure are never Highway's to judge."
```

**Done when**:

- `P9.1` is in the Highway Skills Constitution under a new Principle IX, with an Observable and a
  tier, recorded as a MINOR amendment in its Sync Impact Report.
- `D8.1` is in the Development Constitution under a new Principle VIII, with an Observable and a
  tier, recorded as a MINOR amendment in its Sync Impact Report.
- `.highway/library/templates/output/nfr-record.md` and `.highway/library/templates/output/control-record.md`
  exist as complete skeletons covering frontmatter and body together, and `templates/output/` holds
  no question-content template.
- `highway-nfrs` and `highway-controls` cite their templates from Outputs and restate neither a
  field list nor a body structure; both were confirmed conforming before `P9.1` was enabled.
- `X1.5` is added for the separate retained-file frontmatter obligation; the near-collision with
  `X1.1`/`X1.2` is recorded rather than rediscovered later.
- Neither skill's emitted output — frontmatter or body — changed as a result of this phase.

---

### Phase 12 — Make the completion record enforceable

**Layer**: 0 **Type**: Spec

**Status**: Proposed, 2026-09-10, from a review of Features 022–038. Independent of every other
phase.

**Goal**: The completion record that Phase 10 introduced is required to *exist*, to have *one
shape*, and to be decided by a check that can actually fail. Today `D7.2` is tagged `[auto]`, is
named in the Enforcement Map, and has never failed for any feature but the one that created it.

**The verified gap** (2026-09-10, across Features 022–038). Every one of these is reproducible
from the tree as it stands:

| # | Finding | Verification |
|---|---|---|
| 1 | `D7.2`'s registered check cannot fail for a real feature | `completion-coverage.test.sh` hard-asserts coverage for `021` and its fixtures only. Every other feature is *printed* as `PRE_ENABLE: <id> MISSING_COVERAGE` and never reaches `fail`. The script exits 0 with 25 such lines |
| 2 | Nine features completed *after* `D7.2` was ratified have no coverage record | `025`, `026`, `027`, `028`, `029`, `032`, `035`, `036`, `037`. Feature `032` — the feature written to add coverage records to `030` and `031` — has none of its own |
| 3 | Three incompatible coverage schemas are in use | `Requirement \| Outcome \| Evidence` (`021`, `030`, `031`); `Requirement \| Satisfying artifact \| Evidence` (`022`, `023`, `024`, `033`, `034`); a third column meaning in `038`. The six records in the latter two shapes put a file path where the parser reads `satisfied`/`deferred`, so `coverage_check` would reject all of them — if it ever ran on them |
| 4 | The record's filename is not fixed either | `037` uses `requirements-coverage.md`; `032` uses `test-evidence.md`. Both are invisible to a check that opens `coverage.md` |
| 5 | Eight of the seventeen features reviewed exist only to correct the previous one | `025` and `026` correct `024`; `028` corrects `027`; `029` corrects `028`; `032` corrects `030`/`031`; `034` corrects `033`; `036` corrects `035`; `038` corrects `037`. Each was found by an ad-hoc assessment that no rule requires and no artifact retains, and in every case the corrected feature's own record still reads as fully satisfied |
| 6 | A feature directory name need not name the feature | `specs/036-feature-036/` is a placeholder whose own `spec.md` declares `**Feature Branch**: 036-strengthen-035-evidence`. `specs/033-highway-setup/` declares `033-highway-setup-orchestration`. Two more were found on re-verification: `001` and `005` declare their branch with literal brackets, `` `[001-multi-agent-skill-suite]` `` and `` `[005-rename-content-to-library]` ``, so four directories fail `D5.5`, not two |
| 7 | Phase 10's own Done-when was never met | It requires Feature 020's coverage record to exist naming `FR-002`, `FR-020`, `FR-024`, `FR-027` and `FR-032` as unsatisfied. `specs/020-highway-nfrs/` holds no coverage record under any name. The phase that introduced the rule was reported complete against a criterion the rule itself would have caught |

**Why the existing rules do not cover this.** As in Phase 10, each nearest rule is satisfied by the
tree as it stands, which is the point:

| Rule | Says | Why it passed anyway |
|---|---|---|
| `D7.2` | A completed feature MUST record a requirement-coverage mapping | The Observable says "the feature's coverage record" without fixing a path or a column set, so each feature invented one. The registered check reads only `coverage.md` with one schema and reports everything else as a comment |
| `D3.4` | A new check MUST be evaluated against every existing fixture before it is enabled | It was. The `PRE_ENABLE:` lines *are* that evaluation — correctly honest at the time, and never converted into an assertion afterwards |
| `D3.1`/`D3.2` | Begin and end from a passing suite | The suite passes. A check that only prints cannot stop it |
| `D3.3`/`D3.6` | A behavioral change MUST add a test; a test MUST be observed failing | Both were honoured by `033`, `035` and `037`. Their tests failed and passed for what they asserted — which was skill prose. `034`, `036` and `038` then exist to replace those tests with executable ones |
| `D5.1`/`D5.2` | Do not edit a completed spec; ship a correction as a new spec | Followed exactly. That is *why* eight corrective specs exist. Neither rule requires the corrected feature to learn that it was wrong |
| `D5.4` | A feature directory number MUST be sequential | Constrains the number. Says nothing about the name after it |

**Finding 5 falsifies one of Phase 10's deliberate omissions, and the correction is narrow.**
Phase 10 recorded: *"No rule here says a test must be behavioral rather than static. A
prose-contract test is the correct instrument when the artifact under test is agent instructions
rather than executable code."* The premise is still right — a `SKILL.md` is agent instructions, and
prose-contract tests remain the correct instrument for authoring rules. What the evidence
falsifies is the inference that no rule was therefore needed. Features `034`, `036` and `038` each
state the same primary finding in their own words — *"demonstrate orchestration behavior rather
than only checking skill prose"*, *"passing contract text checks cannot mask incorrect
organization identity"*, *"execute real owner fixtures rather than only static contract checks"* —
three independent rediscoveries of one gap. So the rule below does not outlaw the static
instrument. It forbids *counting* it as the evidence for a behavioral requirement, which is the
only thing that went wrong.

**Five rules, all Layer 0.** The routing test in §2 places every one without argument: they
constrain a coverage record, a test file, a `spec.md`, and a feature directory — artifacts that
exist only to build Highway and never ship. No `SKILL.md` is touched, so no `P` amendment and no
`X` amendment are involved, and the Skills Constitution and Experience Standard are untouched.

| ID | Principle | Rule | Observable | Tier |
|---|---|---|---|---|
| D3.7 | III (existing) | A registered `[auto]` check MUST be able to fail for every class of artifact in its declared scope. | The check declares its scope as a set of artifact classes, and a seeded defect in one artifact of each class produces a non-zero exit. | [auto] |
| D3.8 | III (existing) | A static document-contract test MUST NOT be recorded as the evidence satisfying a behavioral requirement. | Each test declares its instrument class; a coverage row for a requirement about runtime behavior names a test of the executed-behavior class. | [agent-checkable] |
| D7.4 | VII (existing) | A coverage record MUST use one declared path and one declared column schema. | Every completed feature directory holds `coverage.md` with columns `Requirement`, `Outcome`, `Evidence`, and every `Outcome` is exactly `satisfied`, `deferred`, or `historical`. | [auto] |
| D7.5 | VII (existing) | A feature that corrects a defect in a completed feature MUST record that defect against the feature that shipped it. | The corrected feature's coverage record carries a superseding entry naming the correcting feature and the requirement it revises. | [agent-checkable] |
| D5.5 | V (existing) | A feature directory name MUST name the feature. | The segment after the number equals the `Feature Branch` value in that directory's `spec.md`, and is not a placeholder restating the number. | [auto] |

Four of the five land in principles that already exist, so no new principle is opened and the
amendment stays MINOR.

**D3.7 is a generalisation of an existing precedent, not a new idea.** `D1.1`'s Enforcement Map
entry already reads *"seeds a probe to prove it can fail"* — one check in this repository already
proves its own failure path. D3.7 states for every `[auto]` check what `D1.1`'s check already does
for itself, and it is genuinely `[auto]`: seeding a defect and requiring a non-zero exit needs no
judgment. It is the rule that would have caught Finding 1 the day `D7.2` was enabled, and it is the
same correction Phases 4 and 4b made one level up — those phases stopped a rule from *claiming* an
enforcement it did not have; this one stops a check from *being registered* for an enforcement it
does not perform.

**D3.8 is `[agent-checkable]` and D7.5 is too, for the reason Phase 10 established.** Deciding
whether a requirement is about runtime behavior or about document content is semantic, and so is
deciding whether one feature's change corrects another's defect. Every mechanical proxy
under-detects, and tagging either `[auto]` would reintroduce exactly the dishonesty Phases 4, 4b
and this phase's own D3.7 exist to remove.

**A collision with `D5.1` was checked before drafting rule text, per the precedent Phase 5 set,
and it is real.** `D5.1` forbids a diff under a completed spec directory. Both the back-fill
required to enable `D7.4` and every `D7.5` superseding entry are, literally, such a diff. Two
resolutions were considered. Exempting corrections wholesale would gut `D5.1` and undo Phase 10's
"reported as missing rather than rewritten" discipline. The narrow resolution is taken instead:
amend `D5.1`'s Observable to except the coverage record specifically — the completion record is an
accounting artifact about a feature, not part of the specification of it, and the exception permits
no edit to any other file in the directory. That is a MINOR loosening of one Observable, recorded
as such, and it leaves `D5.2`'s "ship the correction as a new spec" untouched.

**A second `D5.1` collision, found on review 2026-09-10, needs its own answer.** Renaming
`specs/036-feature-036/` changes the path of every file beneath it, which the coverage-record
exception above does not cover and cannot be stretched to cover. The resolution is to state in
`D5.1`'s Observable that relocating a completed spec directory is not an edit to it: no file's
*content* changes, and `D5.5` is what compels the move. Without this the amendment asks for a
rename that its own rule forbids.

**`D3.7` says "class", and the word is load-bearing.** An earlier draft read "every artifact in its
declared scope". Read literally that is infeasible: `D1.1`'s scope is roughly 180 files under
`.highway/`, and `D4.5`/`D4.6` span every skill times three agent trees plus a catalog and two
manifests. Hundreds of seed-and-restore cycles per suite run is not a check, it is a build. What
the rule is actually after is that no *failure mode* goes unproven, so the check declares its
scope as a set of artifact classes and proves one probe per class.

**`D7.4` admits a third outcome, and the reason is a false dilemma found on review.** With only
`satisfied` and `deferred`, a pre-`021` requirement has no honest home. Take Feature 004's `FR-007`:
completed long ago, never corrected, and not re-verifiable from the record as it stands. Marking it
`satisfied` invents evidence — the manufactured-green defect. Marking it `deferred` asserts work is
owed that is not, and `D7.4`'s companion obligation would demand an owner who does not exist. So
the vocabulary gains `historical`: the requirement was recorded complete at the time, the claim is
carried forward rather than re-litigated, and no owner is implied. To stop it becoming an escape
hatch, `historical` is valid only for Features `001`–`020` — a mechanically decidable bound, so
new work cannot reach for it.

**This is a retroactive strengthening, not a green-field rule.** Verified 2026-09-10: enabling
`D7.4` against the tree as it stands fails every completed feature except `021`, `030` and `031`,
and enabling `D5.5` fails four directories — `001`, `005`, `033` and `036`. Per `D3.4`'s
evaluate-before-enable discipline and the precedent Phases 4c and 11 set, the back-fill — writing
the missing records, normalising the divergent ones onto the declared schema, and renaming
`specs/036-feature-036/` — must happen in the same change that turns the rules on, or the amendment
is MAJOR rather than MINOR. The back-filled records must be honest: where a requirement was in fact
corrected by a later feature, its outcome is `deferred` with the superseding feature named, not
`satisfied`.

**The `001`–`020` back-fill is Phase 13's, and splitting it is a scope decision with a reason.**
This phase enforces `D7.4` from Feature `021` onward — the features whose records are evidenced,
where the honesty problem is small and the work is bounded. Features `001`–`020` are 309 further
requirement rows whose disposition mostly cannot be re-derived; folding them in would make this a
single change touching roughly forty spec directories, twelve test files and the constitution, and
the realistic failure mode of a change that size is partial completion with the checkboxes marked
— precisely the defect this phase exists to eliminate, committed in the act of eliminating it.
The split is not a retreat from full coverage: Phase 13 completes it, both amendments stay MINOR,
and `D5.2`'s "ship the correction as a new spec" is the grain being followed rather than fought.
Feature `020` is the one named exception handled here, because Phase 10 already established exactly
which five of its requirements are unsatisfied, so its record is evidenced and the debt Phase 10
left open is discharged now rather than deferred a second time.

**`D3.7` and `D3.8` were not assessed against the tree when this phase was drafted, and must be
before they are enabled.** The paragraph above measures only `D7.4` and `D5.5`. `D3.7` reaches
every registered `[auto]` check — twelve of them once `D5.5` and `D7.4` are added — and today only
`D1.1`'s check seeds a probe to prove it can fail. `D3.8` reaches every coverage row for a
behavioral requirement, and `030`'s and `031`'s records are 100% `deferred` precisely because those
skills are natural-language workflows with no executable harness, so its true failure surface is
unmeasured. `D3.4` requires both to be measured before the rules turn on; whichever cannot be
brought to conformance in the same change must be enabled later rather than tagged optimistically.

**Prerequisite**: None. Independent of Phases 5 through 11.

**Phase 12 should run before Phases 8 and 9, and this reverses no stated dependency.** Both remain
independent of it — neither reads nor writes anything Phase 12 touches — but both introduce new
rules with registered checks: Phase 8 adds `P7.9` `[auto]`, and Phase 9 adds a library-currency
rule whose tier it must argue. Ratifying `D3.7` first means those checks are born proving their
own failure path, and Phase 8's per-phase Done-when promise — *"observed failing and then passing
again"* — becomes the general rule rather than a promise each phase has to remember to make.
Running either first only adds one more check to Phase 12's back-fill.

**Command**:

```text
/speckit.specify "I want the completion record that Feature 021 introduced to be enforceable, because today D7.2 is tagged [auto], is named in the Enforcement Map, and has never failed for any feature but the one that created it. Verified 2026-09-10 across Features 022 through 038. First: completion-coverage.test.sh hard-asserts coverage only for feature 021 and its checked-in fixtures; for every other feature it prints a PRE_ENABLE MISSING_COVERAGE line that never reaches the fail variable, and the script exits 0 with twenty-five such lines. Second: nine features completed after D7.2 was ratified have no coverage record at all -- 025, 026, 027, 028, 029, 032, 035, 036 and 037 -- and feature 032, which exists to add coverage records to 030 and 031, has none of its own. Third: three incompatible column schemas are in use, Requirement/Outcome/Evidence in 021, 030 and 031, Requirement/Satisfying-artifact/Evidence in 022, 023, 024, 033 and 034, and a third meaning in 038, so six records put a file path where the parser reads satisfied or deferred and would be rejected if the check ever ran on them. Fourth: the filename is not fixed either, 037 uses requirements-coverage.md and 032 uses test-evidence.md. Fifth: eight of the seventeen features reviewed exist only to correct the previous one, 025 and 026 correcting 024, 028 correcting 027, 029 correcting 028, 032 correcting 030 and 031, 034 correcting 033, 036 correcting 035 and 038 correcting 037, and in every case the corrected feature's own record still reads as fully satisfied. Sixth: specs/036-feature-036 is a placeholder directory whose own spec.md declares the branch 036-strengthen-035-evidence, and specs/033-highway-setup declares 033-highway-setup-orchestration. Add five rules to the Highway Development Constitution at .specify/memory/constitution.md as a MINOR amendment, all Layer 0 because they constrain a coverage record, a test file, a spec.md and a feature directory, none of which ship, and open no new principle. D3.7 in the existing Principle III: a registered [auto] check MUST be able to fail for every artifact in its declared scope, observable as the check declaring its scope and a seeded defect in each in-scope artifact producing a non-zero exit, tagged [auto]; this generalises the probe that D1.1's enforcement entry already seeds to prove it can fail. D3.8 in Principle III: a static document-contract test MUST NOT be recorded as the evidence satisfying a behavioral requirement, observable as each test declaring its instrument class and a coverage row for a runtime-behavior requirement naming a test of the executed-behavior class, tagged [agent-checkable]; this does not outlaw static prose-contract tests, which remain the correct instrument for authoring rules against a SKILL.md, it only forbids counting one as evidence for behavior -- the gap that Features 034, 036 and 038 each rediscovered independently. D7.4 in the existing Principle VII: a coverage record MUST use one declared path and one declared column schema, observable as every completed feature directory holding coverage.md with columns Requirement, Outcome and Evidence and every Outcome being exactly satisfied or deferred, tagged [auto]. D7.5 in Principle VII: a feature that corrects a defect in a completed feature MUST record that defect against the feature that shipped it, observable as the corrected feature's coverage record carrying a superseding entry naming the correcting feature and the requirement it revises, tagged [agent-checkable] because deciding whether one change corrects another's defect is semantic. D5.5 in the existing Principle V: a feature directory name MUST name the feature, observable as the segment after the number equalling the Feature Branch value in that directory's spec.md and not being a placeholder restating the number, tagged [auto]. Amend D5.1's Observable to except the coverage record from its no-diff-under-a-completed-spec-directory rule, because both the back-fill and every D7.5 superseding entry are literally such a diff; the exception covers the coverage record only and permits no edit to any other file in the directory, and D5.2 is untouched. Because enabling D7.4 fails fifteen of the seventeen reviewed features and D5.5 fails two directories, do the retroactive conformance work in the same change that enables the rules, per D3.4: write the nine missing coverage records, normalise the six divergent ones onto the declared schema, rename specs/036-feature-036 to match its declared branch, and reconcile specs/033-highway-setup. Back-filled records must be honest -- where a requirement was in fact corrected by a later feature, its outcome is deferred with the superseding feature named, not satisfied. Convert completion-coverage.test.sh's PRE_ENABLE reporting into assertions and prove D3.7 against it by seeding a defect into each in-scope feature. Do not add any rule requiring every test to be executable, do not add any rule mandating an assessment ritual before a feature, and do not amend the Highway Skills Constitution or the Experience Standard -- no rule in this phase constrains a SKILL.md."
```

**Amended after the command was issued** (2026-09-10, from the `/speckit.clarify` and two review
passes on `specs/039-completion-record-enforcement`). The command text above is left as issued, per
this repository's append-only spec-record discipline. Six things changed:

- **`D7.4` is enforced from Feature `021` onward here; Features `001`–`020` move to Phase 13.**
  The clarification first widened the scope to `001` onward. A feasibility review then found the
  309 historical rows carry a false dilemma that no wording fixes, and that folding them in makes
  this change large enough that partial completion becomes the likely outcome. Full coverage is
  still reached — across two features rather than one. Feature `020` is handled here as a named
  exception, because Phase 10 already identified exactly which of its requirements are unsatisfied.
- **The outcome vocabulary gains `historical`**, valid only for Features `001`–`020`.
- **`D3.7` proves one probe per declared artifact *class*,** not per artifact; the literal reading
  was combinatorially infeasible.
- **`D3.7`'s proof obligation covers every registered `[auto]` check**, not only the completion
  check.
- **`D3.8` and `D3.7` require a pre-enable assessment** against the tree, per `D3.4`. `D3.8`'s
  coverage-row obligation applies from Feature `021` onward, for the same reason as `D7.4`.
- **`D5.5` fails four directories, not two**; `001` and `005` carry bracketed branch values.

**Done when**:

- `D3.7`, `D3.8`, `D5.5`, `D7.4` and `D7.5` are in the Development Constitution with Observables and
  tiers, in the existing Principles III, V and VII, recorded as a MINOR amendment in its Sync
  Impact Report. No new principle is opened.
- `D7.4`'s Observable admits `satisfied`, `deferred` and `historical`, and bounds `historical` to
  Features `001`–`020` so new work cannot reach for it.
- `D3.7`'s Observable requires one seeded probe per declared artifact class, and every registered
  `[auto]` check — all twelve once `D5.5` and `D7.4` are added — declares its classes and is proved
  to fail for each, the same failing-then-passing observation `D3.6` requires.
- `D5.5` and `D7.4` each appear in the Enforcement Map naming the test that decides them, so
  `constitution-inventory.test.sh` passes.
- `D5.1`'s Observable carries both the coverage-record exception and the statement that relocating
  a completed spec directory is not an edit to it, and both loosenings are recorded in the same
  Sync Impact Report. `D5.2` is unchanged.
- `completion-coverage.test.sh` no longer emits a `PRE_ENABLE:` line that cannot fail the run: every
  in-scope feature is asserted, and the check declares its scope as Features `021` onward plus
  Feature `020`, naming Phase 13 as the owner of `001`–`019`.
- `D3.7` and `D3.8` were each measured against the tree before being enabled, and any rule that
  could not be brought to conformance in this change is recorded as enabled later rather than
  tagged optimistically.
- Every test in the suite declares its instrument class, satisfying the first clause of `D3.8`'s
  Observable as well as the second.
- Every completed feature directory from `021` onward, plus `020`, holds `coverage.md` in the
  declared schema; no `requirements-coverage.md` or `test-evidence.md` stands in for it.
- Back-filled records name the correcting feature against each requirement a later feature revised,
  rather than reporting it `satisfied`.
- Feature 020's coverage record exists and names `FR-002`, `FR-020`, `FR-024`, `FR-027` and
  `FR-032` as deferred, discharging the Phase 10 Done-when that was reported met and was not.
- `specs/036-feature-036/` no longer exists under a placeholder name, `001` and `005` no longer
  carry bracketed branch values, and every feature directory's name matches the `Feature Branch`
  value in its own `spec.md`.
- No rule is added requiring a test to be executable rather than static, and no `P` or `X` rule is
  added or amended.
- `.highway/tools/tests/run-all.sh` exits 0.

**Note added by Feature 041, 2026-09-10 (append-only; the Done-when above is unchanged).** This
Done-when's "every completed feature directory from `021` onward, plus `020`, holds `coverage.md`
in the declared schema" clause was not met at the time Phase 12 was reported complete:
`specs/038-readiness-verification-corrections/coverage.md` used a non-conforming header and carried
8 rows with no matching requirement id, and `specs/040-historical-coverage-reconstruction/coverage.md`
did not exist. Feature 041 found both gaps by running the registered check against the tree rather
than trusting the record, and corrected both records as part of its own User Story 5. See
`specs/041-auto-check-integrity/research.md` and that feature's `coverage.md` for the evidence.

---

### Phase 13 — Reconstruct the pre-`021` completion record

**Layer**: 0 **Type**: Spec (`specs/040-historical-coverage-reconstruction`)

**Status**: Proposed, 2026-09-10. Gated on Phase 12.

**Goal**: Every completed feature below `021` carries a coverage record too, so `D7.4`'s scope is
the whole project history rather than the part that happened to be built after the rule existed.
Phase 12 supplies the schema, the vocabulary and the check; this phase supplies the 309 rows.

**Why this is a separate phase and not the tail of Phase 12.** Two reasons, and the second is the
one that matters.

The first is size. Features `001`–`019` hold 309 functional requirements — measured, not estimated.
Folding them into Phase 12 makes one change that touches roughly forty spec directories, twelve
test files and the constitution. Phase 10 exists because a 54-task feature was reported complete
while five requirements were unimplemented; asking for a larger one *in the feature that fixes
that* invites the same outcome.

The second is that the two jobs are different work. Phase 12 writes records for features whose
artifacts are still present and whose requirements can be checked against them. This phase writes
records for features whose disposition mostly cannot be re-derived at all. That is not more of the
same task; it is a different task with a different honest answer, and it needs its own vocabulary
and its own review.

**The verified state** (2026-09-10):

| | |
|---|---|
| Completed features below `021` | 19 (`003` is incomplete and out of scope) |
| Functional requirements across them | 309 |
| Coverage records among them | 0 |
| Whose disposition is independently re-derivable today | Feature `020` only, and Phase 12 handles it |

**The false dilemma this phase exists to resolve.** With only `satisfied` and `deferred`, a
pre-`021` requirement has no honest home — the argument is recorded in full under Phase 12's
`D7.4` discussion and is not restated here. Phase 12 adds `historical` to the vocabulary and bounds
it to Features `001`–`020`. This phase is the only consumer of that outcome, and after it there
should never be another: the bound is a closed interval, not a policy.

**No new rule, and that is the point.** Phase 12 ratifies `D3.7`, `D3.8`, `D5.5`, `D7.4`, `D7.5`
and the two `D5.1` exceptions. This phase adds none. It writes records under a schema that already
exists, widens one check's declared scope from "`021` onward plus `020`" to "`001` onward", and
stops. A phase that needed a new rule to finish the previous phase's job would be evidence the
previous phase's rule was wrong.

**The failure mode to design against is a green back-fill.** The temptation is to mark 309 rows
`satisfied` because the features shipped and the suite is green. That would be the manufactured
evidence Phase 10 and Phase 12 both exist to eliminate, committed at the largest scale yet in the
act of completing their work. The rule this phase must hold itself to: a row is `satisfied` only
when a named artifact can be pointed at *now*; otherwise it is `historical`, and `historical`
carries no implication that the work was done well — only that the claim is being carried forward
rather than re-litigated. A predominantly `satisfied` result is a red flag, not a success.

**Prerequisite**: Phase 12 complete. This phase cannot start earlier: the schema, the `historical`
outcome, and the check whose scope it widens are all Phase 12's.

**Command**:

```text
/speckit.specify "I want every completed feature below 021 to carry a coverage record, so that D7.4's scope becomes the whole project history rather than only the features built after the rule existed. Feature 039 enforced D7.4 from Feature 021 onward plus Feature 020, added the coverage.md schema with the Requirement, Outcome and Evidence columns, and added a third outcome, historical, valid only for Features 001 through 020. This feature is the only consumer of that outcome and after it there should never be another. Verified 2026-09-10: nineteen completed features sit below 021, Feature 003 is incomplete and out of scope, they hold 309 functional requirements between them, and not one has a coverage record. Write a coverage.md for each of Features 001, 002, 004 through 019 under its existing spec directory, using the schema Feature 039 established, with one row for every functional requirement id declared in that feature's spec.md, no duplicates and no unknown ids. Mark a requirement satisfied only when a named artifact that satisfies it can be pointed at in the tree as it stands today; mark it deferred only when a later feature demonstrably corrected it, naming that feature; and mark it historical in every other case, with evidence naming the completion record the claim is carried forward from. A predominantly satisfied result is a defect in this feature, not a success: manufacturing green rows is the exact failure that Features 021 and 039 exist to prevent, and doing it at this scale while completing their work would be the worst version of it. Do not mark any row satisfied on the strength of the suite being green or the feature having shipped. Then widen completion-coverage.test.sh's declared scope from Features 021 onward plus 020 to Features 001 onward, keep every assertion Feature 039 added, and add an assertion that the historical outcome appears only in Features 001 through 020 so it cannot become an escape hatch for new work. Add no new constitution rule, open no new principle, amend neither the Highway Skills Constitution nor the Experience Standard, and do not edit any completed spec file other than the coverage record that Feature 039's D5.1 exception already permits. Begin and end from a passing .highway/tools/tests/run-all.sh."
```

**Done when**:

- Every completed feature below `021` holds `coverage.md` in the schema Phase 12 established, with
  one row per declared requirement id, no duplicate and no unknown id.
- Every `satisfied` row names an artifact that exists in the tree today; every `deferred` row names
  the later feature that corrected it; every remaining row is `historical` and names the completion
  record its claim carries forward from.
- The proportion of `historical` rows is reported rather than minimised, and no row is `satisfied`
  on the strength of a green suite or a shipped feature.
- `completion-coverage.test.sh` declares its scope as Features `001` onward, retains every
  assertion Phase 12 added, and asserts that `historical` appears only in Features `001`–`020`.
- No constitution rule is added or amended, no new principle is opened, and neither Layer 1 nor
  Layer 2 is touched.
- No completed spec file other than the permitted coverage record is edited.
- `.highway/tools/tests/run-all.sh` exits 0.

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
