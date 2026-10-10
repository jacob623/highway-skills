# Research: Profile and Setup Advisory Hardening

**Feature**: 154 | **Date**: 2026-10-09

## Decision: Keep ownership split across three source documents

**Decision**: Put Profile delivery wording and workflow constraints in `.highway/skills/highway-profile/SKILL.md`, the proposed-starting-point heading in X2.72 of `.highway/governance/experience-standard.md`, and fresh Setup welcome ordering in `.highway/skills/highway-setup/SKILL.md`.

**Rationale**: The current repository already assigns these behaviors to those owners. The Experience Standard owns generic user-visible interaction, while Profile and Setup own their domain workflow and welcome contracts. This avoids restating generic rules in Profile and avoids changing unrelated owner skills.

**Alternatives considered**:
- Put all changes in Profile: rejected because the proposed-starting-point heading is a generic interaction contract and the welcome is Setup-owned.
- Add a new generic advisory rule: rejected for this feature because the request scopes advisory scaffolding to Profile-owned exploratory questions and the existing Standard already requires grounded reasoning before questions.

## Decision: Treat this as a static document-contract feature

**Decision**: Add focused source-document assertions and run the existing full suite; do not claim that static checks prove conversational behavior.

**Rationale**: The repository constitution's D3.8 separates static document-contract evidence from runtime behavior evidence. The spec explicitly defers human conversational evaluation.

**Alternatives considered**:
- Add host-specific conversation fixtures: deferred to a later evaluation feature because recorded host behavior is evidence for motivation, not acceptance here.
- Add only prose verification: rejected because changed literals, exclusions, ordering, and countable delivery sites need automated regression protection.

## Decision: Use the existing acceptance and contribution vocabulary

**Decision**: Keep `Substantive Contribution`, `Working Idea`, `Converged Proposal`, and the existing acceptance boundary unchanged. Model the conditional reassurance as per-active-domain delivery guidance, not as a new state or persisted field.

**Rationale**: These meanings already exist in the Profile and Experience Standard contracts. A new schema or state machine would duplicate ownership and increase the change surface.

**Alternatives considered**:
- Add a persisted per-domain reassurance flag: rejected because the reassurance is interaction guidance derived from the active domain's contribution state, not durable Profile content.

## Decision: Make the advisory addition exactly one grounded move

**Decision**: Before an applicable non-canonical exploratory question, present at most one distinction, implication, tension, connection, possibility, tradeoff, or decision criterion, attributed as workflow reasoning and kept outside the candidate until adopted.

**Rationale**: This matches X2.68/X2.69 and the feature's requirement to clarify the dilemma without turning the question into a recommendation set or a second candidate.

**Alternatives considered**:
- Present multiple possibilities before every question: rejected because it can manufacture a recommendation set and conflicts with the one-addition bound.

## Decision: Resolve the requested Setup path to the current owner contract

**Decision**: Implement the requested `highway-setup/setup.md` change in `.highway/skills/highway-setup/SKILL.md`, because no `setup.md` source file exists.

**Rationale**: The repository's current Setup skill contains the authoritative `## Welcome` contract and is the source for generated adapters. The assumption is recorded in the spec for traceability.

**Alternatives considered**:
- Create a new `setup.md`: rejected because it would create a competing source document and bypass the existing generator path.

## Validation baseline

The existing repository uses Bash 3.2.57-compatible shell tests under `.highway/tools/tests/`, generated agent adapters, catalogs, and `AGENTS.md`. Before implementation, run the focused test in seeded-failure mode if available, then the full `.highway/tools/tests/run-all.sh` suite. After source edits, regenerate all declared outputs before the full suite.

## Implementation baseline and probe

The pre-feature suite baseline was recorded after Feature 153 as **77 passed, 0 failed, 228s**.
The Feature 154 focused test observed its seeded source-document defect with exit 1 and its
neutralised probe with exit 0 before source delivery edits. The unseeded focused test now exits 0.

## Final implementation validation

The focused delivery-site test passes after implementing all five user stories. All four declared
generators then completed successfully.

The full suite passes with **78 passed, 0 failed, 194s**. Feature 153's delivery test had three
assertions for contracts superseded by this feature: the retired X2.72 reaction heading, the old
Vision boundary cue, and the old unconditional uncertainty reassurance. Those assertions were
updated to the current shared contracts; the Feature 153 test still passes independently.

The cross-cutting audit passes: the Profile skill contains zero MUST-, SHOULD-, or SHALL-level
keywords; the shared acceptance question occurs once; the retired reaction heading and old Vision
boundary cue are absent; the new X2.72 and four Profile proposed-starting-point sites are present;
the fresh Setup welcome remains present; and no generated shipped artifact contains `specs/` or
`.specify/`.

Contract coverage is split between the focused test and human/deferred review. C1 through C3 and C5
have direct literal, count, absence, and ordering assertions. C4 has direct assertions for the
advisory addition, attribution, Working Idea boundary, emphasis, and excluded question classes.
Runtime conversational quality remains deferred; static checks establish document delivery only.
