# Phase 0 Research: Development Tier Honesty

**Feature**: `014-dev-tier-honesty` | **Date**: 2026-09-08

---

## R1. What `[auto]` means for a Layer 0 rule

**This is the decision the whole feature turns on.** Six of the ten rules move together on it.

**Decision**: For a rule in the Highway Development Constitution, `[auto]` means **a test in
`run-all.sh` decides the rule, and the binding between rule and test is recorded in the document**.
Reporting under the rule id is *not* required.

The binding is recorded in a new **Enforcement Map** section: one row per `[auto]` rule, naming
the test file that decides it.

**Rationale**: The `P`-side meaning — a registered check reporting under its id in a coverage
summary — is not a definition of `[auto]`, it is a description of the machinery Layer 1 happens
to have. Layer 0 has no registry, no coverage summary, and no artifact a validator runs against.
Importing that machinery would mean building a validator for `tasks.md` and `plan.md` files, which
is a large amount of tooling to make a tier tag literally true.

What the tag is *for* is the same in both documents: telling a reader whether something will catch
them if they break the rule, or whether they must check it themselves. Layer 0 has an enforcement
surface that answers that question — the test suite. A test that fails is a decision.

The traceability objection is real and is what the map answers. Today `shipped-tree-independence`
failing tells you a boundary broke but not which rule you violated, and the constitution gives no
way to find the enforcer. The map closes that in one place, in the document, where a reader
already is.

**Why a map rather than amending each Observable**: six Observables would need rewording, and
changing an Observable is not a PATCH under this document's own policy while not clearly being
MAJOR either — an awkward classification for a bookkeeping change. Adding a section is
unambiguously MINOR, matches the precedent feature 013 set on the `P` side, and keeps the
rule/enforcer binding in exactly one place per D1.6.

**On FR-004 — do the two meanings differ materially?** Yes, and the difference is stated rather
than glossed. Layer 1 requires per-rule reporting; Layer 0 requires only that a named test decide
the rule. **The same tag is nonetheless retained**, because the tag answers the same reader
question in both documents and the Enforcement Map makes the Layer 0 obligation explicit where it
applies. A distinct name such as `[test-enforced]` was considered and rejected: it would imply the
Layer 1 tier is something other than test-enforced, which it is not — `validate-skill.sh` is run
by the suite too.

**Alternatives considered**:

- *Require reporting under the rule id, as Layer 1 does.* Rejected: it demands a Layer 0 validator
  that does not exist and would have no artifact to run against for at least three rules.
- *Accept "a test enforces it" with no recorded binding.* Rejected: that is the current state, and
  it is why nobody could tell whether the tier was honest without reading every test.
- *Retag all ten to `[agent-checkable]`.* Rejected: it is accurate but throws away the fact that
  six rules genuinely are enforced, leaving the document less informative than the truth.

---

## R2. Rule-by-rule disposition

Verified against the repository on 2026-09-08. Each mapping must be re-verified during
implementation rather than trusted from this table.

| Rule | Finding | Disposition |
|---|---|---|
| D1.1 | `shipped-tree-independence.test.sh` decides exactly this, with a seeded probe | Stays `[auto]`, mapped |
| D1.2 | `distribution-packaging.test.sh` runs the distribution's own validator | Stays `[auto]`, mapped |
| D4.2 | `generate-catalog.test.sh` asserts re-running produces no difference **aside from `generated_at`** — the Observable's exception, already encoded | Stays `[auto]`, mapped |
| D4.3 | `distribution-packaging.test.sh` asserts refusal to overwrite | Stays `[auto]`, mapped; verify adapter coverage too |
| D4.1 | Generator tests assert no-diff on regeneration; needs confirming this covers hand-editing | Verify, then map or retag |
| D6.2 | **Partially enforced.** Cross-references are checked *inside the distribution*; nothing checks resolution across the repository tree, which is what its Observable says | Decide in implementation: widen the check, or narrow the Observable |
| D5.4 | **Nothing checks it.** Mechanically trivial | Enforce, per FR-007 |
| D3.1 | A claim about the suite state *before* the first edit | Retag |
| D3.2 | A claim about the suite state *after* the final edit | Retag |
| D4.4 | A claim about what a person did after changing a generator | Verify; likely retag |

**Retag target**: `[agent-checkable]`. D3.1 and D3.2 are not unverifiable — an agent can run
`run-all.sh` and report the result. What no static check can do is observe *two moments* and the
work between them. `[agent-checkable]` describes that exactly: a person or agent performs the
check, at the right time, and reports it.

**D6.2 is the one genuinely open question**, and it is deliberately left to implementation because
it needs evidence this plan does not have: how many repository documents would fail a
whole-tree cross-reference check today. If the answer is "none", widen the check. If it is
"dozens", narrowing the Observable to the packaged tree is the honest move, and is a rule change
requiring its own justification.

---

## R3. Enforcing D5.4

**Decision**: A new test asserts that feature directory numbers under `specs/` are contiguous from
`001` with no gaps and no duplicates.

**Rationale**: FR-007 requires enforcing rather than retagging a rule that is checkable, and this
one is: the numbers are in directory names. The rule's Observable — the number is one greater than
the highest existing — is a statement about the whole set being contiguous.

The check is also self-applying: this feature is `014`, following `013`, and the check will
confirm that on its first run.

**Alternatives considered**:

- *Check only the newest directory.* Rejected: a gap introduced earlier would never be detected,
  and the Observable is about the set.
- *Fold it into an existing test.* Rejected: no existing test concerns the spec record, and
  attaching it to an unrelated file makes the failure confusing.

---

## R4. Generalising the tier-honesty guard

**Decision**: Extend the guard in `constitution-inventory.test.sh` to check both documents, with
the per-document rule differing:

- **Skills Constitution**: every `[auto]` rule has a registered check in `rc_registered_ids`.
- **Development Constitution**: every `[auto]` rule appears in the Enforcement Map, and the test
  file it names exists.

The failure message names the document, per FR-011.

**Rationale**: One guard, two documents, two definitions — because the definitions genuinely
differ and R1 records why. Pretending they are the same would make the guard wrong for one of
them.

Checking that the named test *file exists* is deliberately weak: it cannot confirm the test
actually decides the rule. That is a human judgement made when the map row is written. What the
guard prevents is the failure mode that actually occurred — a tag claiming enforcement with
nothing behind it, and a map row pointing at a test that was renamed or deleted.

**Alternatives considered**:

- *A second, separate guard.* Rejected: two assertions of the same property drift apart, and a
  reader would have to know both exist.
- *Assert the named test cites the rule id.* Rejected for now: it forces a comment convention on
  fifteen test files for a benefit the map already delivers. Worth revisiting if map rows start
  going stale.

---

## R5. Version classification — MINOR

**Decision**: MINOR. The current version is 1.0.0, so `1.0.0 → 1.1.0`.

**Rationale**: Classified against the development constitution's own policy text:

- **MAJOR**: a principle is removed or redefined, or an obligation is strengthened so that
  previously conforming work now fails.
- **MINOR**: a principle or rule is added without invalidating conforming work.
- **PATCH**: wording repair with no change to any Observable.

A section is added — the Enforcement Map — which MINOR covers. The retags are neither MAJOR
(nothing removed, redefined, or strengthened) nor PATCH (a tier tag is not wording repair), and
the higher classification governs.

**One rule may strengthen an obligation**: enforcing D5.4 means a numbering gap now fails the
suite where it previously passed unnoticed. That is only MAJOR if *previously conforming work now
fails* — so implementation must confirm the current numbering is contiguous before enabling the
check. If it is not, the gap must be resolved or the classification revisited. Verified
provisionally: `001` through `014`, contiguous.

**A policy gap, recorded not fixed**: as on the `P` side, this document's policy does not name a
tier change either. It fell to MINOR here only because a section was added for another reason.
Both policies would benefit from a clause naming tier changes explicitly, which is a separate
PATCH amendment to each.

---

## R6. Ordering — the guard extends last

**Decision**: Retags, mappings, and the D5.4 check all land before the guard is extended.

**Rationale**: FR-012. Extending the guard to a document that does not yet satisfy the definition
turns the suite red, and the only ways forward would be tolerating a red suite mid-feature or
weakening the guard to get green — the first violates D3.1 and D3.2, the second violates D3.5.
Sequencing removes the dilemma rather than managing it.

---

## R7. Keeping the new tooling out of the distribution

**Decision**: Every file this feature adds or changes lives under `.highway/tools/tests/` or
`.specify/`. No file under `.highway/tools/lib/` or any other distributed path is modified.

**Rationale**: FR-015. The development constitution does not ship, and tooling that exists to
enforce it has no business in a recipient's tree. The distribution manifest already excludes
`.highway/tools/tests/` and `.specify/`, so this needs no manifest change — provided the work
stays in those directories.

That constraint is what keeps the Packaging Gate untriggered for this feature, and it is worth
stating as a design rule rather than an accident: **if this feature ever needs a change under
`lib/`, the packaging classification must be revisited in the same change.**

**Alternatives considered**:

- *Put shared logic in `lib/` and exclude it in the manifest.* Rejected: the manifest already
  carries three packaging carve-outs, and each one is a place the tree and its declaration can
  disagree. Not adding a fourth is cheaper than declaring one.
