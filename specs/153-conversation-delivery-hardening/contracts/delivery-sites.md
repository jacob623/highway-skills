# Contract: Delivery Sites

**Feature**: 153 | **Date**: 2026-10-09

Highway's external interface is the text users read and the rules agents read. This document fixes
the contract for every site this feature adds or changes, so an implementer has a target and a
reviewer has something to compare against. Exact literal wording is marked where a test will match
it byte-for-byte.

## C1 — Experience Standard rules

Appended to the `### X2 - Interaction` table in document order after `X2.67`.

| ID | Rule | Observable |
|---|---|---|
| X2.68 | An Interactive Workflow MUST contribute one grounded addition when non-redundant reasoning would materially improve the relevant Working Idea. | The response offers a distinction, implication, tension, connection, alternative, opportunity, recommendation, or redirection traceable to accepted context and absent from the person's own words; optional detail, repetition, unsupported speculation, manufactured alternatives, ceremony, or low-value addition does not satisfy it. |
| X2.69 | A contributed addition MUST NOT exceed one distinction or extension per Substantive Contribution. | One addition appears; a second, an enumerated set of offered options, or a recommendation set does not. |
| X2.70 | Text opening a domain MUST name accepted substance carried forward from the preceding domain. | The opening restates or quotes accepted material and connects it to the question being asked; a transition naming no accepted substance does not satisfy it. |
| X2.71 | Opening text MUST state that nothing has been accepted yet when no accepted substance exists. | The opening says so rather than fabricating a carry-forward. |
| X2.72 | An invitation to react where nothing has been captured MUST use the heading "Here's a direction worth considering — what's missing from it?". | The invitation appears under that heading and no acceptance request follows it. |

**Rule-shape contract**: each rule carries exactly one keyword (`P1.1`), 25 words or fewer
(`P1.3`), one obligation (`P1.2`), and a conditional clause where conditional (`P3.4`).
Word counts as drafted: 18, 13, 14, 15, 22.

**X2.72 names its literal inline**, as `X2.21` does for the capture heading. The earlier draft —
"MUST carry the reaction heading when nothing has been captured" — left the heading undefined, so
nothing bound the wording and no test could match it. Research R2 settled ownership of the literal
on the Standard; naming it in the rule is what makes that ownership real.

**Amendment, Observable only**: `X2.56`'s Observable gains the inline form. Rule text is unchanged
and the identifier is not retired. Precedent: the Standard's own provenance section records
Observable-only amendments to `X2.51` and `X2.4`.

**Provenance**: the `## Version and Amendment Provenance` section records the five added
identifiers and the one amended Observable, and the version becomes `11.1.0`.

## C2 — The reaction literal

**Status: signed off 2026-10-09.** Accepted wording:

```text
**Here's a direction worth considering — what's missing from it?**
```

| Property | Required by |
|---|---|
| Not satisfiable by agreement alone | `X2.49`'s discipline, carried to the uncaptured case |
| Not presented as a candidate for acceptance | `X2.43` |
| Distinguished from a recommendation set | `X2.47` |
| Does not contain the acceptance literal's wording | R6 — the count-of-one assertion |

## C3 — `highway-profile` delivery sites

All sites carry **zero** MUST-level keywords (FR-015). All name the Standard rather than restating
it (FR-014, `P7.3`).

| Site | Section | Content contract |
|---|---|---|
| Candidate before retention | `#### Domain completeness` | States that a domain's substance is kept only after its finished candidate has been presented and accepted. Applies to all four domains |
| Question restriction | `#### Domain completeness` | States the condition under which the acceptance literal applies, and points to the reaction heading otherwise. **Adds no second emphasized copy of the acceptance literal** |
| Narration coverage | `#### Domain completeness` or `#### Cross-domain reasoning` | Names persistence, progression and domain state as the things not described, rather than readiness vocabulary alone |
| Continuity, 3 handoffs | `##### Vision`, `##### Competitive Path`, `##### Guiding Principles` | Each opens by naming accepted substance from the preceding domain. A generic transition sentence does not satisfy this |
| Domain-boundary cue | `##### Vision` | Emitted cue keeping approach and sequencing out of the retained wording and naming `Competitive Path` as the domain that owns them |
| Reassurance | wherever the acceptance literal is emitted | Unemphasized; names "I don't know" as a legitimate answer; the acceptance question stays the only emphasized element |
| Exemplars | new `#### Contribution in practice` | Exactly three, per the data model's exemplar table |

**New Verification entries**: `## Verification` gains an entry for each of candidate-before-
retention, continuity at the three handoffs, and the three exemplars, each naming a checkable
outcome (`P8.4`).

## C4 — `highway-setup`

**No contract.** FR-005 is withdrawn (spec, 2026-10-09): the heading level of the post-Profile
workflow opening is not changed by this feature. `highway-setup` is untouched, so its version is
not incremented and no agent tree copy of it is regenerated.

## C5 — Agent grounding

Edited at the source, `.highway/instructions/highway-agent-context.md`, then regenerated. The four
outputs are generated artifacts; editing them directly violates `D4.1`.

| Property | Contract |
|---|---|
| Trigger named | States the moment the Experience Standard is read, rather than advising it be consulted |
| Outputs identical to source | `.github/copilot-instructions.md`, `.claude/CLAUDE.md`, `AGENTS.md`, and `.cursor/rules/highway-agent-context.mdc` all regenerate with no diff |

## C6 — Test contract

One file: `.highway/tools/tests/feature-153-delivery-sites.test.sh`.

```bash
# Instrument class: static-document-contract
# Artifact classes: source-document
# Seeded failure probe: this test must detect a defect in each declared class and clean its probe.
```

| Assertion group | Decides |
|---|---|
| Rule presence and shape | FR-009, FR-010, FR-012, FR-002's rule half |
| Observable content | FR-007, FR-010's exclusion list |
| Profile site presence | FR-001, FR-003, FR-004, FR-006, FR-013 |
| Exemplar count, distinctness, closing form | FR-011 |
| Keyword count is 0 | FR-015 |
| Acceptance literal count is still 1 | R6 guard |
| Grounding trigger present | FR-008 |

**Not decided by any assertion**: FR-014, FR-017, FR-018, FR-019, FR-020. These are reported in
the completion report under `D7.3`, stated separately from the suite result.

## C7 — The contract's own limit

Every assertion above is a string match or a count over a source document. A full pass proves the
text is present and shaped correctly. It does not prove an agent reads it, acts on it, or produces
a better conversation. FR-018 requires that limit to be stated rather than left for a reader to
discover, and the evaluation that would test it is a separate feature.
