# Research: Revise the Runtime Skills Constitution

## 1. Which file changes

**Decision**: Edit `.highway/governance/constitution.md` only. Version 3.0.1 becomes 4.0.0. Prepend a sync impact report. Keep the existing reports in the file.

**Rationale**: The spec and the 2026-09-29 clarification limit the amendment to the Skills Constitution. Skill text and development governance are a later change.

**Alternatives considered**: Trim every shipped skill in this change. Write the removed gates into the development constitution in this change. Both were rejected by the clarification.

## 2. Suite and documentation exceptions

**Decision**: Accept a red `constitution-inventory.test.sh` after the edit. Do not edit tests, validators, skill files, or other docs in this change.

**Rationale**: That test requires the current P12.1–P12.5 rows, the N6 sentence, the precedence label `XII. Persistence and Completion Integrity`, the footer `**Version**: 3.0.1`, `**Last Amended**: 2026-09-25`, and a Compliance Review Protocol evidence line. A real 4.0.0 amendment removes or rewrites each of those. Updating the test would be the deferred tooling change. D3.2, D3.3, and D6.1 are recorded exceptions in [plan.md](./plan.md).

**Alternatives considered**: Keep the old footer and old principle title so the inventory test stays green. Rejected because that would preserve a historical test result by misstating the amendment, which FR-032 forbids.

## 3. Identifier assignment

**Decision**: A removed rule's identifier is retired and is not reused. A rule that stays with a new meaning keeps its identifier. New obligations receive the next unused identifier in that principle.

**Rationale**: The constitution already says a retired identifier is never reused. The spec keeps P5.6 and P12.5, and it replaces the surrounding rules.

**Alternatives considered**: Renumber the remaining rules so each principle starts at `.1`. Rejected because that reuses retired identifiers.

## 4. Failure model and completion

**Decision**: Retire P5.1 through P5.5. Keep P5.6. Add P5.7 through P5.13 for the six common situations and for documenting only a domain-specific difference. Redefine P1.7 so an absent or self-contradictory declared input is handled by that model, without a second copy of the model. Retire P12.1 through P12.4, Persistence Verification, Verified Completion Claim, and N6. Redefine P12.5. Add P12.6 through P12.12 for the owner and orchestrator obligations that P12.5 does not already state. Rename Principle XII to owner-controlled completion and orchestration. Leave its precedence rank at 5 and replace the rank's reason.

**Rationale**: Each new row has to satisfy one keyword, one obligation, and 25 words. The spec's six failure situations and six orchestration clauses split anywhere "and" or "or" would state a second obligation. "A failed mutation is not success" lives once, in the failure model, so Principle XII does not restate it.

**Alternatives considered**: Keep one rule per spec bullet even where the bullet contains two obligations. Rejected because the constitution's own clarity rules would fail the amendment's self-application review.

## 5. Authority, gates, and security

**Decision**: Retire P3.1. Redefine P3.3 so an external citation is required only for an external assertion. Leave the approved-source list closed. State that a later amendment may add an entry that names its provenance, and that unrelated rules still do not cite one. Retire P4.1 and P4.3. Keep P4.2, P4.4, P4.5, and P4.6. Remove the Code Generation, Testing, Maintainability, and Performance gates. Keep the Security Gate, narrowed to an action the skill performs, without a mandatory external citation unless the skill asserts an external security requirement.

**Rationale**: FR-004 through FR-009. Adding an empty seventh source now would invent an authority the spec does not name.

**Alternatives considered**: Add AS-7 for "framework and industry expertise" immediately. Rejected because the spec asks the model to allow a future entry, not to name one.

## 6. Verification, context, templates, experience, and maintainability

**Decision**: Retire P8.1. Redefine P8.2 and P8.4 in place. Keep P8.3, P8.5, P8.6, and P8.7. Redefine P11.1 through P11.4 to the four runtime context obligations and retire P11.5. Do not add a rule that records every missing optional source. Redefine P7.3 and P9.1 in place. Keep P7.1, P7.2, P7.4, P7.5, P7.6, and P7.7. Keep Principle X as a reference to the Experience Standard. Remove the sentence that records experience compliance through the Compliance Review Protocol.

**Rationale**: These are the spec's in-place changes. P11.5 is the obligation to record absent context, which FR-023 removes. The four replacements fit the four retained identifiers.

**Alternatives considered**: Retire P11.1 through P11.5 and allocate P11.6 through P11.9. Rejected because the four new obligations can redefine the first four identifiers without reuse.

## 7. Development-only sections

**Decision**: Remove the Compliance Review Protocol, including its review output shape and merge decision. Remove the Skill Authoring Workflow. Remove N5 through N9 with that protocol and with N6's removed rules. Keep N1 through N4 only where a remaining gate or rule still needs them. Keep tier tags on remaining rules and define them in Definitions, not as a review procedure. Remove or rewrite examples and definitions that teach a removed obligation. Remove the governance sentence that requires the protocol before merge.

**Rationale**: FR-027. The protocol exists to validate a skill before release. The spec classifies that as development governance and removes it from the runtime document.

**Alternatives considered**: Leave the protocol in place and mark it non-normative. Rejected because the spec says it is absent from the runtime constitution.

## 8. Shipped-file tokens

**Decision**: The amendment describes development material as the development constitution, feature specifications, tests, fixtures, merge procedures, compliance tooling, and development-only scripts. It does not use the character sequences `.specify/` or `specs/`.

**Rationale**: The file ships. Those two sequences are the packaging prohibition.

**Alternatives considered**: Name the development constitution by its repository path. Rejected because that path contains a prohibited sequence.
