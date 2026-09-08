# Research: Skill Path Resolvability Rule

Phase 0 output. Each item records a decision, the reasoning, and the alternatives rejected.

## R1: Which principle does the new rule join, and what is its identifier?

**Decision**: `P8.7`, joining Principle VIII, Reliability and Repeatability.

**Reasoning**: The rule concerns whether a skill works as delivered. That is Principle VIII's
subject — its rationale is that repeatability allows a skill to be reused without re-verifying it.
`P8.6` already prohibits relying on an unstated environment default; a rule prohibiting a reference
to something the recipient does not have sits naturally beside it, and both fail the same way: the
skill looks fine where it was written and breaks where it is used.

Every principle's highest identifier was checked so the new one extends a sequence rather than
reusing a retired number: P1.7, P2.5, P3.5, P4.6, P5.6, P6.6, P7.7, P8.6. `P8.7` is free.

**Alternatives rejected**:

- *Principle II, Technology-Agnostic Portability.* Its rules govern naming a model, vendor, or
  tool. A filesystem path is none of those, and the principle's rationale is about a skill
  outliving an incidental technology choice, not about references resolving.
- *Principle I, Unambiguous Directives.* `P1.5` requires naming every dependency in Inputs, which
  is adjacent but different: it governs whether a dependency is *declared*, not whether a reference
  *resolves*.
- *Principle VII, Long-Term Maintainability.* That principle governs cost over time. A broken
  reference is wrong immediately, not expensive later.

## R2: A skill cannot use a relative link at all

**Decision**: The rule prohibits a relative filesystem link target outright, rather than attempting
to resolve one against each tree a skill is distributed into.

**Reasoning**: This is the finding that most shapes the feature, and it is stronger than the
feature description assumed.

A `SKILL.md` does not live in one place. The adapter generator copies it byte-for-byte into three
further locations:

| Location | Shape |
|---|---|
| `.highway/skills/<id>/SKILL.md` | Source |
| `.github/skills/<id>/SKILL.md` | Byte-identical copy |
| `.claude/skills/<id>/SKILL.md` | Byte-identical copy |
| `.cursor/rules/<id>.mdc` | Re-encoded, and a **flat file**, not a directory |

A relative target is resolved against the directory holding the file that contains it. Verified:
the generator copies only `SKILL.md`, never a sibling file, so nothing else is present in any
adapter directory. A target of `../governance/constitution.md` resolves in the source tree and
resolves to nothing in the other three. A target of `./helper.md` fails everywhere but the source,
because `helper.md` is never copied. The Cursor target is not even in a directory of its own.

Therefore no relative filesystem target can resolve in every location a skill is delivered to, and
the general rule collapses to a prohibition. That is a better outcome than the per-tree resolution
originally contemplated: the check becomes a property of the text alone, needing no filesystem
access and no knowledge of how many trees exist today.

An absolute URL is unaffected and remains permitted; it resolves identically from every location.

**Alternatives rejected**:

- *Resolve each target against every distributed tree.* Requires the check to know the distributed
  path set, couples a Layer 1 rule to a Layer 0 declaration, and reaches the same verdict by a
  longer route, since no relative target can pass.
- *Permit a target inside the skill's own directory.* Would be sound only if the generator copied
  the whole directory. It copies one file, so this permits references that break in three of four
  locations.
- *Permit relative targets and require the author to verify them.* Reintroduces exactly the
  learn-by-failure problem the feature exists to remove.

## R3: Where does the check live?

**Decision**: A `rc_check_P8_7` function in `.highway/tools/lib/rule-checks.sh`, registered in
`rc_registry` so `validate-skill.sh` dispatches it and reports the verdict under `P8.7`.

**Reasoning**: The registry is a tab-separated table of rule identifier, check function, and
not-applicable condition. Adding a row is the established way to make a rule decided, and it is
what puts the rule into the existing five-group coverage summary rather than into a separate
report a reader has to know to look at.

The alternative shape — a standalone test file, as feature 010 used for the shipped-tree check —
is wrong here. That check answers a question about the tree as a whole; this one answers a question
about one skill and belongs in the per-skill verdict. A rule enforced by a test but absent from the
validator's own report would be enforced yet invisible, which is the exact defect this feature
exists to remove.

The not-applicable condition is `-`: the rule applies to every skill unconditionally. A skill with
no links satisfies it rather than being exempt from it.

**Alternatives rejected**:

- *A standalone test.* Enforces the rule while leaving it out of the per-skill verdict.
- *A check inside `schema-validate.sh`.* That library holds schema-level checks tagged `[SCHEMA]`,
  which are not tied to a rule identifier. This rule has one and should report under it.

## R4: What counts as a reference?

**Decision**: A Markdown link target — the text inside the parentheses of `](…)`. Nothing else.

**Reasoning**: A skill body contains two kinds of path-shaped text, and only one is a reference:

- A **cross-reference** points at another document and carries an implicit promise that following
  it leads somewhere. `[the standard](../governance/constitution.md)`.
- A **command example** shows something to run. `` `.highway/tools/validate-skill.sh <skill-dir>` ``.
  It is instruction text, correct as written, and resolving it would be a category error.

`highway-help`'s body contains several command examples and, after feature 010, no links at all.
A check that resolved every path-shaped string would flag those examples and force them to be
mangled to satisfy a rule that was never about them.

Restricting the check to link targets makes it mechanically simple and gives it the same subject as
the word "cross-reference" already used in the development constitution's D6.2.

**Alternatives rejected**:

- *Every path-shaped string.* Flags legitimate command examples; unfixable without damaging content.
- *Link targets plus inline code that looks like a path.* Reintroduces the judgement call that
  makes a check arguable, and command examples are precisely the case it would get wrong.

## R5: Is the amendment MINOR?

**Decision**: MINOR. The constitution's version increments by one minor step.

**Reasoning**: Checked against that document's own versioning policy rather than by analogy. MINOR
covers a rule added without invalidating a conforming artifact; MAJOR covers an obligation
strengthened so that a previously conforming artifact now fails.

The sole registered skill, `highway-help`, contains no Markdown link at all — verified by scanning
every link target across `.highway/skills/` and the fixtures, which found exactly one, in
`_authoring-standard.md`, which is not a skill. No registered skill fails the new rule, so nothing
conforming is invalidated.

This is verified during implementation rather than assumed. Were a skill to fail, the
classification would change and the skill would need amending first.

**Alternatives rejected**:

- *PATCH.* Reserved for wording repair with no change to any Observable. A rule is added.
- *MAJOR.* Requires a conforming artifact to start failing. None does.

## R6: Does the new rule restate D6.2?

**Decision**: No, and the two are worded so their subjects are distinguishable.

**Reasoning**: The development constitution's D6.2 requires a documentation cross-reference to
resolve, with its Observable scoped to "the tree that contains the document". It governs live
documentation in this repository — tool READMEs, the authoring standard, the front page — which
exist in exactly one place and are read from that place.

`P8.7` governs a skill, which exists in four places and is read from any of them. The obligation
differs in kind: D6.2 asks whether a reference resolves *here*; `P8.7` asks whether a reference can
resolve *anywhere it might be read*, and answers that a relative one cannot.

The non-restatement rules are satisfied because neither document reproduces the other's rule
sentence, and each governs an artifact class the other does not.

**Alternatives rejected**:

- *Extend D6.2 to cover skills.* Puts a rule about shipped content in the document that does not
  ship, so an author of a skill could not read the rule they are held to — the original defect,
  relocated.
- *Drop D6.2 and keep only the new rule.* D6.2 covers documents that are not skills and would go
  ungoverned.

## R7: Every fixture's verdict under the new check, recorded before enabling it

**Decision**: Enabling the check changes no existing fixture's verdict. Recorded here in advance,
as D3.4 requires.

**Reasoning**: D3.4 exists because an unconditional new check silently changes the verdict of every
artifact already present, and a fixture expected to produce exactly one failure can quietly begin
producing two. Every link target under `.highway/skills/` and
`.highway/tools/tests/fixtures/` was scanned; exactly one exists, and it is not in a fixture or a
skill.

| Fixture | Links in body | Verdict under P8.7 | Existing verdict changes? |
|---|---|---|---|
| `valid-skill` | none | PASS | No |
| `invalid-skill-long-description` | none | PASS | No |
| `invalid-skill-missing-example` | none | PASS | No |
| `invalid-skill-missing-usage` | none | PASS | No |
| `invalid-skill-missing-version` | none | PASS | No |
| `invalid-skill-name-mismatch` | none | PASS | No |
| `invalid_skill_bad_id` | none | PASS | No |
| `highway-help` (real skill) | none | PASS | No |

Every fixture that must produce exactly one failure continues to produce exactly one.

A new fixture is therefore required, because no existing artifact exercises the failure path. This
is the same reasoning that gave the shipped-tree check a seeded probe: a check never observed to
fail proves nothing.

**Alternatives rejected**:

- *Rely on an existing fixture.* None contains a link, so the failure path would be untested.
- *Add the failure case only to the rule-check test.* Reasonable and also done, but a fixture
  additionally proves the rule is reported correctly through the full validator, in the right
  coverage group, alongside the other rules.

## R8: The rule is preventive, not corrective

**Decision**: Ship it anyway, and record that it currently has nothing to correct.

**Reasoning**: Worth stating plainly so a later reader does not mistake a passing check for a
check that did something. Feature 010 removed the only two links that existed in a skill body, so
the repository already satisfies `P8.7` before it is written. The rule's value is entirely in what
it prevents.

That value is concrete and near. Phase 7's planned `nfrs` and `controls` skills will describe
artifacts, templates, and locations, and are the most likely skills yet to reach for a link. The
rule and its check land before those skills are authored rather than after.

**Alternatives rejected**:

- *Defer until a skill needs it.* The first skill to need it would be the one that violates it,
  and the rule would be written in response to a defect instead of preventing one.

## R9: Out of scope, recorded for later

The adapter manifest carries four rows whose target files do not exist: three for a `sample-echo`
skill that is no longer present, and two under a mock agent directory created by a test. They are
harmless — the manifest is consulted by path, so a row for an absent file is never read — but they
are drift.

This feature does not touch the manifest, and no rule requires it to. Recorded so the observation
is not lost; the packaging feature is where a manifest hygiene check would belong.
