# Research: Repository Controls

**Feature**: 019-repository-controls | **Date**: 2026-09-08

Four questions were open after the spec. Two of them change the plan.

---

## R1 — Does `FR-003` break the library tests?

**Decision**: scope the validator to its **framework root**, not to `.highway/library/`. The
obvious implementation would break every library test.

**Rationale**: library fixtures do not live where a first guess would put them. Verified
2026-09-08:

| Path | Under `.highway/`? | Under `.highway/library/`? |
|---|---|---|
| `.highway/tools/tests/fixtures/library/governance/valid/policy.md` | **Yes** | No |
| `<project>/library/governance/controls.md` (user Controls) | **No** | No |

An implementation requiring files to sit under `.highway/library/` would decline every fixture and
break `validate-library.test.sh`. Requiring them to sit under `.highway/` accepts the fixtures and
declines the user's Controls, which is exactly the boundary `FR-003` is for.

The spec's wording — *"outside its own framework root"* — is already correct. This note exists so
the implementation is not written against the narrower reading.

**Alternatives rejected**:

- *Move the fixtures under `.highway/library/`.* They are deliberately non-conformant test data;
  putting them in the shipped library directory would place them in the library catalog and the
  distribution.
- *Exempt the fixtures by path.* An exemption list that grows with every test, which is the shape
  feature 016 removed from the distribution manifest.

---

## R2 — Does the skill fit inside `P7.4`'s twelve-rule cap?

**Finding: probably not as one skill, but the budget is larger than a naive count suggests.**

`rc_check_P7_4` counts **normative lines** containing `MUST`, not every line containing the word.
For comparison, `highway-inquiry` — a skill with a comparable amount of behaviour — sits at 7.

The obligations this skill genuinely needs on the agent, drawn from the spec:

| Source | Obligation |
|---|---|
| FR-018/019/020 | Confirm before loss, naming each Control; a count is not enough; write nothing if withheld |
| FR-010/011/015 | Never reuse an identifier; never change one; preserve it on update |
| FR-025/026/027 | Offer an alternative; do not refuse; name the resembling Control |
| FR-028/029 | Ask when the action or target is not decidable; abort when the target is absent |

That is around a dozen before counting the artifact-shape obligations, so the cap is a real
constraint rather than a theoretical one.

**The budget is bigger than it looks**, because not every requirement in the spec is an obligation
*on the agent*. Several describe the artifact and belong in Outputs as description rather than as
`MUST` rules — that the catalog records the next identifier, that a Control carries a relationship
field, that the catalog is a function of its inputs. `highway-help` states zero `MUST` rules and is
a perfectly well-specified skill.

**Decision**: attempt one skill, and treat splitting as a recorded decision point rather than a
surprise. If the count exceeds twelve after the artifact-shape obligations have been moved to
description, split along the **Set** seam: Set is the only wholesale, irreversible action, it
carries the heaviest confirmation obligations, and it is the least used while a baseline is being
built.

**Not decided in advance**, because deciding to split before writing the skill would be guessing at
a number that has not been measured.

---

## R3 — How does an agent-run skill find the project root?

**Decision**: the skill writes to `library/governance/` **relative to the project root**, which it
determines from the location of the framework directory it was distributed into.

**Rationale**: a skill is instructions for an agent, not a script with a resolvable
`$SCRIPT_DIR`. The one landmark it can rely on is that `.highway/` sits at the project root — the
distribution's own front page states this, and the generated adapters land alongside it.

So the rule the skill states is: Controls live in `library/governance/`, a sibling of `.highway/`.
That is stable, checkable by a person, and does not require the agent to guess.

**Worth stating in the skill** rather than assuming: if `.highway/` is not found, the skill cannot
determine where Controls belong, and that is an abort-and-ask condition rather than a guess.

---

## R4 — Determinism of the generated catalog

**Decision**: the catalog carries **no timestamp**.

**Rationale**: `X6.1` requires an emitted artifact to contain only content derived from its
declared inputs. Highway's own catalogs write `generated_at`, which is why `D4.2` and `D4.7` both
carry a timestamp exception — an exception the Controls catalog does not need and should not
inherit.

`highway-inquiry` already set this precedent for a generated user-facing artifact: *"No timestamp
is written, so an unchanged question set produces an unchanged file."* Following it means a
baseline that has not changed produces a byte-identical catalog, which makes a stale catalog
detectable by regeneration rather than by inspection.

---

## R5 — What the new skill owes the framework

A new skill is not just a `SKILL.md`. Verified against `D4.5`, which feature 016 added precisely
because feature 015 missed part of this list:

| Obligation | Source |
|---|---|
| A catalog entry | `D4.5` |
| An adapter in each of the three declared agent trees | `D4.5` |
| An adapter manifest row per adapter | `D4.5` |
| A distribution manifest row per adapter, classified `include` | `D4.5` |
| Regeneration in the same change | `D4.7` |
| Citations of the `X` rules it satisfies | Feature 017's precedent |
| A Verification section naming the `X` rules its self-check exercises | Feature 018's precedent |

The distribution manifest rows are the ones that were missed last time: a skill added without them
still ships its source while its adapters are silently dropped, and packaging reports success.
`adapter-coverage.test.sh` now fails in that case, so the omission is caught — but it is cheaper to
do it deliberately than to be told.
