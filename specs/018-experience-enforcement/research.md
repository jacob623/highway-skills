# Research: Enforce the Experience Standard

**Feature**: 018-experience-enforcement | **Date**: 2026-09-08

Four questions were open after the spec. The fourth found a collision with the spec's own scope
line and needs a decision before implementation.

---

## R1 — How should the loader read more than one document?

**Decision**: widen the namespace pattern in `con_rules()` and have the *caller* iterate over a
list of documents. Do not change the function's signature.

**Rationale**: `con_rules()` already takes the document as an argument —
`con_rules "$constitution"` — so it is not single-document by design, only single-*namespace* by
its matching pattern, which hardcodes `P[0-9]+\.[0-9]+`. The minimal change is therefore:

| Change | Where | Why |
|---|---|---|
| Pattern accepts `P` or `X` | `lib/constitution.sh` | Removes the namespace binding |
| Caller loops over a document list | `validate-skill.sh` | Merges the inventory without changing the loader's contract |

This satisfies FR-003 without special-casing: every existing caller passes one file and keeps
working, because the signature is untouched.

**Alternatives rejected**:

- *Make `CONSTITUTION_FILE` a list.* It is an exported override used by tests to point at a
  fixture; turning a path into a list changes a shipped contract for every caller to serve one.
- *Add a `con_rules_multi()`.* A second entry point for the same job, which is the parallel
  mechanism this feature exists to avoid.

---

## R2 — `validate-library.sh` must not load the Experience Standard

**Decision**: only `validate-skill.sh` reads the standard. The library validator's document list
stays as it is.

**Rationale**: verified 2026-09-08 that `validate-library.sh:131` runs the same
`con_rules "$constitution"` loop and shares the rule registry. If the standard were added to its
document list, library content would be judged against rules governing skill emissions — a
questionnaire template has no Outputs section and emits nothing.

This is the same hazard feature 011 hit, and it was solved there with `rc_library_exempt_ids`
rather than by narrowing a rule. Here the cleaner fix is upstream: never load the document for
that caller, so no exemption list has to be maintained.

**Consequence worth stating**: widening the pattern means `con_rules()` *would* return `X` rules if
pointed at the standard. Scoping therefore lives in which documents each caller passes, and that
must be explicit rather than incidental.

---

## R3 — Which `X` rules are actually decidable by a script?

**Decision**: one, plus one partial. The rest stay `[agent-checkable]`.

Assessed against what `validate-skill.sh` can see — a `SKILL.md` file, and now its `## Example`
section as a specimen:

| Rule | Decidable? | Why |
|---|---|---|
| X1.1 declare the shape emitted | **No** | "States the fields, sections, or structure" is satisfiable by prose. Any mechanical proxy either passes everything or flags correct documents. |
| X1.2 emitted content follows declared shape | **Partial** | Where the Outputs section declares labelled fields, the specimen can be checked for those labels in that order. Where it declares a file shape, `N/A`. |
| X1.3 empty result has a declared form | **No** | Deciding whether a skill *has* an empty case is semantic. |
| X2.1 confirmation states what is lost | **No** | Runtime prompt content. |
| X4.1 declare the written path | **No** | The trigger — does this skill write a file? — is semantic. |
| X5.1 message names something actionable | **No** | Runtime message content, and the judgement is about the reader. |
| X5.2 conflict report names the item | **No** | Runtime. |
| X6.1 artifact contains only derived content | **No** | Runtime artifact content. |

**So the honest count is one and a half.** That is the expected outcome recorded in the spec's
Assumptions, not a shortfall — and it is why User Story 1, the inventory, is the durable part of
this feature rather than User Story 2.

**The pressure to overstate this is the main risk.** The feature is named "enforce", which creates
an incentive to tag rules `[auto]` and write proxies that pass everything. FR-010 prohibits it and
SC-002 requires the count to be reported as measured.

---

## R4 — The specimen-currency check has no rule to enforce, and the spec says not to add one

**This needs a decision before implementation.**

The strongest mechanically decidable property found is FR-019: a value the specimen shares with the
skill's metadata must agree with it. It already fails — `highway-help`'s Example shows
`Version: 3.0.1` against a frontmatter of `3.0.2`.

But **no existing `X` rule covers it**:

| Candidate | Why it does not fit |
|---|---|
| X1.2 — emitted content follows its declared shape | A version *value* is not shape. Stretching X1.2 to cover it would make the rule mean whatever the check happens to do, which is the defect this project has twice removed. |
| X6.1 — artifact contains only derived content | About an emitted artifact, not about an Example in a skill file. |

And the spec's Out of Scope says: *"Adding or removing `X` rules. Only tiers change."* That line
was written before the defect was found.

**Three options**:

| Option | Consequence |
|---|---|
| **A. Add one rule** — `X1.4`, that a specimen agrees with the metadata it repeats — as a MINOR amendment | Honest. Small scope extension beyond the spec's Out of Scope line, which needs approval. Gives the check a stated rule, per feature 011's lesson. |
| **B. Enforce as a test only**, with no rule | Contradicts feature 011 directly: a test without a written rule is discoverable only by failing the suite. |
| **C. Stretch `X1.2`** to cover values as well as shape | Makes the rule text mean whatever the check does. This is the defect features 013, 014 and 016 each removed. |

**Recommendation: A.** The alternative is either an unstated obligation or a rule that has been
quietly redefined to fit its implementation. Adding one rule is a MINOR amendment to a document
ratified hours ago, and the repair it demands is a one-line edit to an Example.

**Decided 2026-09-08: A.** One rule is added to the Experience Standard as a MINOR amendment,
taking it to 1.1.0. The rule belongs to the `X1` family, because a specimen that contradicts the
skill it illustrates is an output-structure defect. Its tier is `[auto]`, which is honest here
because a registered check decides it — making it the only `X` rule that earns that tag in this
feature.

Recorded here rather than decided unilaterally, because it widens the scope the spec set.

---

## R5 — What does the coverage machinery already do with `X` rules?

**Finding**: nothing needs to change for `[agent-checkable]` rules to be grouped correctly.
Verified by reading `validate-skill.sh:100–145`:

```text
tier != auto                  -> DEFERRED
tier == auto, no check fn     -> UNCHECKED
tier == auto, check exit 2    -> N/A
tier == auto, check exit 1    -> CHECKED + FAILED
tier == auto, otherwise       -> CHECKED
```

So once the loader returns `X` rules, the seven that stay `[agent-checkable]` land in `DEFERRED`
automatically, and `UNCHECKED` stays empty. No change to the five-group format is needed, which is
what FR-008 requires.

This also means **the inventory works before any check is written** — User Story 1 is deliverable
on its own, and User Story 2 can be as small as the evidence supports.
