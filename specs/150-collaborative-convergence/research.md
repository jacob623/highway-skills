# Research: Collaborative Convergence

**Feature**: 150 | **Date**: 2026-10-07

The Technical Context raised no `NEEDS CLARIFICATION` markers. Every item below is a decision the
plan had to make before design could proceed, together with the evidence read from the repository.

## 1. Where the new normative rules live

**Decision**: Every new normative rule is added to the `X2 - Interaction` table of
`.highway/governance/experience-standard.md`. No normative rule is added to
`.highway/skills/highway-profile/SKILL.md`.

**Rationale**: The Profile skill contains zero `MUST`-level rules today — it is written entirely as
declarative contract prose. P7.3 forbids a skill restating a requirement owned outside it, and
P10.1 requires the skill to reference the Experience Standard rather than reproduce its interaction
rules. Putting the rules in the Standard also satisfies FR-036, which requires them to bind every
skill without an exemption clause.

**Alternatives considered**: Adding `MUST` rules to Profile. Rejected — it would restate Standard
material, and P7.4 caps a skill at 12 MUST-level rules, a budget that would be consumed immediately.

## 2. FR-024's "tier" clause does not apply here

**Decision**: New Standard rules carry a Rule and an Observable. They carry no tier tag.

**Rationale**: The Experience Standard has no tier column, and three tests
(`experience-standard-amendment`, `constitution-experience-alignment`, `highway-ux-alignment`)
assert that the literal tokens `[auto]`, `[agent-checkable]`, and `[human-review]` are **absent**
from it. The Highway Skills Constitution contains no `X`-namespace rows, so no tier exists for an
X rule anywhere. FR-024's tier clause is satisfied vacuously: this feature adds no constitution
rule. The one-keyword, one-obligation, 25-word, and observable limits are applied in full.

## 3. The factual convergence condition preserves the short path by construction

**Decision**: X2.41 is restated as "the person has made no Substantive Contribution to the active
subject", and X2.37 states the same condition as the trigger for a Contribution Opportunity.
X2.22 is left byte-unchanged.

**Rationale**: This was the main risk in the clarification answer — that a mandatory Contribution
Opportunity would force exploratory turns on a domain-ready person, contradicting FR-023 and the
`Mature contribution` row of the Interaction Boundaries table. It does not. A person who supplies a
domain-complete description has, by the Standard's own definition, made a Substantive Contribution:
they supplied information that changes active understanding. The condition is therefore already
satisfied at the moment they speak, no opportunity is owed, and convergence is permitted on the
next turn. The short path survives without needing an exemption clause.

X2.22's existing phrase "no useful grounded development remains under X2.41" continues to read
correctly against the new X2.41 and is not amended. Leaving it unamended also means FR-024 does not
attach to it.

**Alternatives considered**: Adding an explicit short-path exemption to X2.37. Rejected — an
exemption clause is the mechanism that neutralized the rule in the first place, and it is not
needed.

## 4. X2.41's judgement bar is preserved rather than deleted

**Decision**: The current X2.41 text — "MUST NOT present a complete candidate as a Converged
Proposal while grounded non-redundant reasoning could materially improve the relevant Working
Idea" — is moved to a new rule X2.42 with its Observable intact. X2.41 then carries the factual
condition.

**Rationale**: FR-006 requires X2.41 to become a factual condition. It does not require the
judgement bar to be removed, and removing it would be a behavioral regression: nothing else in the
rule tables stops Highway converging while a useful connection is still unexplored. D3.5 forbids
weakening an assertion without a recorded reason naming the superseded behavior, and the honest
reason here is that there is none — the behavior is retained under a new identifier. The two rules
are independent: X2.42 cannot be used to escape X2.41, because both must hold.

**Alternatives considered**: Folding the judgement bar into X2.41's Observable. Rejected — an
Observable describes what is visible, not a second obligation, and burying a MUST there is how the
original behavior became invisible.

## 5. X2.7 must be amended or FR-019 is unreachable

**Decision**: X2.7's Observable gains the clause that an ungrounded option is marked speculative
where it appears. X2.7's rule text is unchanged.

**Rationale**: X2.7 today requires every recommendation to be grounded in declared context. FR-019
requires an ungrounded recommendation to be *marked speculative*, which presumes such a
recommendation may be offered at all. Left alone, the two contradict and an agent resolving the
conflict would drop the speculative option entirely — removing exactly the "This one is mine, not
grounded in anything you've said" move the target transcript demonstrates. Amending the Observable
rather than the rule keeps X2.7 at one keyword and one obligation.

## 6. Attribution is one rule, not three

**Decision**: FR-017, FR-031, and FR-032 are satisfied by a single rule whose subject is "domain
vocabulary or a substantive claim Highway introduces", with the paraphrase exemption stated in the
Observable.

**Rationale**: P1.2 requires one obligation per rule, not one subject. The obligation here is
single — attribute it where it is used. Splitting into three rules would produce two near-identical
MUSTs and one MUST NOT whose only content is an exemption, which is the shape that makes rules
skippable. The paraphrase exemption is an Observable because it describes what a compliant turn
looks like rather than imposing a second action.

## 7. Four tests hard-code the Standard's rule count

**Decision**: The count assertion is updated from 33 to 49 in all four tests, in the same change
that adds the rules.

**Rationale**: `experience-standard-amendment`, `experience-standard-convergence`,
`constitution-experience-alignment`, and `highway-ux-alignment` each contain
`-ne 33`. This is not test weakening under D3.5 — the inventory assertion's purpose is to detect
unannounced rule-table drift, and it continues to do so at the new value. The superseded value and
its reason are recorded in each file.

`feature-141-experience-standard-refactor` additionally asserts exactly five Interaction Boundaries
rows. No row is added; the `Contribution Opportunity` row's Compliant cell is amended in place.

## 8. Eight tests hard-code the Profile skill version

**Decision**: Profile moves `9.0.0` → `10.0.0`; the Standard moves `9.1.0` → `10.0.0`.

**Rationale**: P7.7 requires MAJOR for a breaking change to a skill contract. The four mandated
user-visible acceptance sentences are part of Profile's contract and all four are replaced, so the
increment is MAJOR. The Standard narrows X2.37's exemption and restates X2.41's condition, so
interaction that conforms today can fail afterwards — also MAJOR. Eight test files assert
`version: 9.0.0` and four assert the Standard's `9.1.0` or its `Last Amended` date; all are updated
in the same change, per D6.1.

## 9. Profile must not cite the amended rules by identifier

**Decision**: Profile states its behavior declaratively and cites the Experience Standard by name
only.

**Rationale**: `profile-runtime-separation` and `feature-140-profile-convergence-alignment` both
assert that the literal string `X2.41` is **absent** from the Profile skill. P7.3 requires the
cross-reference to name the Standard, not its rule text. This also discharges FR-026 in both
directions: Profile carries user-facing output wording, which is not rule text; the Standard
carries the rule, which Profile does not repeat.

## 10. The Identity permissive hook is removed, not amended

**Decision**: Profile's sentence beginning "When Profile materially assembles Identity from
multiple sources or substantial interpretation... when that helps inspection" is deleted.

**Rationale**: It is the Profile-side instance of the self-assessed trigger that clarification Q2
replaced. The obligation now lives in X2.37 with a factual condition, and leaving a permissive
Profile-side variant beside it would let an agent satisfy the weaker one. No test asserts this
sentence, so deletion costs no coverage.

## 11. Evidence base and what cannot be verified by the suite

**Decision**: SC-001 through SC-007 are not claimed by any check. The evidence offered is the
document-contract suite plus a human reading of a fresh conversation against `setup-model.md`.

**Rationale**: D3.8 forbids recording a static document-contract test as the evidence satisfying a
behavioral requirement, and every test touched by this feature is a document contract. The
preceding attempt at this work was abandoned precisely because mechanical scoring of agent
transcripts could not be made to work. D7.3 requires the completion report to state requirement
coverage separately from check results, which is how the two claims stay distinguishable.

## 12. Follow-up registration for the remaining skills

**Decision**: FR-037 is discharged by a `follow-up.md` contract in this feature directory naming
the skills that have not been verified against the new rules.

**Rationale**: FR-036 makes the rules bind `highway-objectives`, `highway-controls`, `highway-nfrs`,
`highway-new`, `highway-discovery`, `highway-adr`, `highway-clarify`, and `highway-setup`
immediately. FR-038 limits verification to `highway-profile`. The gap is real and must be written
down rather than implied, which is what the registration provides.
