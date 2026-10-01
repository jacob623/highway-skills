# Research: Amend Experience Standard

## Decision: Replace the Experience Standard in place

**Decision**: Edit `.highway/governance/experience-standard.md` from 4.0.0 to 5.0.0. Keep X1.7, X2.9, and X2.13. Add X2.32, X2.33, X2.34, and X2.35 to the X2 table after X2.31. Do not add a website-specific rule.

**Rationale**: The versioning policy classifies a redefined rule, and an obligation strengthened so previously conforming presentation fails, as major. The supplied rule sentences already fit the existing row shape. A separate document would split the interaction authority.

**Alternatives considered**: A minor bump was rejected because X1.7, X2.9, and X2.13 no longer accept the 4.0.0 presentation. A new website rule was rejected because accepted discovery is ordinary accepted context.

## Decision: Keep one current Sync Impact Report

**Decision**: Replace the opening 4.0.0 report with one 5.0.0 report. Keep the ratification date 2026-09-08. Set Last Amended to 2026-10-01. Record the rule count as 35 to 39. Do not name test files, feature numbers, `.specify/`, or `specs/` in the shipped report.

**Rationale**: The current document already keeps one report and says repository history retains older reports. `experience-standard-amendment.test.sh` requires exactly one `Sync Impact Report`. Leaving the 4.0.0 token in place would preserve the superseded contract.

**Alternatives considered**: Appending a second report was rejected because it breaks the one-report convention and the existing count check. Keeping Last Amended at 2026-09-29 was rejected because this amendment is a new date.

## Decision: Change rule text only where the amendment redefines it

**Decision**: Replace the X1.7 and X2.9 rule sentences and observables with the supplied 5.0.0 text. Keep the X2.13 and X2.25 rule sentences. Replace their observables. Leave X2.3, X2.7, X2.16 through X2.22, and X2.27 through X2.31 byte-stable, including the X2.3 observable sentence `Every user-visible response excludes Implementation details unless requested.`

**Rationale**: The specification preserves those rules. X2.34 makes orchestration presentation explicit without rewriting X2.3. X2.16 remains the maximum of five.

**Alternatives considered**: Folding non-duplication into X2.27 was rejected because X2.27 is about the owner's opening, not domain-completion synthesis. X2.35 already limits what is visible after the final guided decision.

## Decision: Replace the interaction sequence and non-normative examples

**Decision**: Replace the numbered interaction model with the specified sequence, including acceptance of discovered information and a re-evaluation before the next guided question. Add the two compounding sentences under Contextual Guidance and keep them non-normative. Replace the repository-structure context-awareness row with the organizational vision contrast. Add Decision Context and owner-result rows to the interaction examples. Revise the recommendation sketch so its invitation matches a multiple-recommendation set, and remove `Select any of these`.

**Rationale**: Those sections currently teach the superseded order or a generic questionnaire. X2.21 and X2.22 still govern captured-content review, so the model does not need to restate that heading. The model introduction already says it does not restate rule rows.

**Alternatives considered**: Leaving `Select any of these` was rejected because the sketch is the non-normative recommendation example and the amendment tells reviewers to revise that invitation. Adding a second confirmation after synthesis was rejected because synthesis is closure, not acceptance.

## Decision: Name machine-only fields in explanatory prose

**Decision**: Keep the supplied X2.34 rule and observable. After the X2 table, add explanatory prose naming Status, Summary, Next Action, Blocking Reason, Action Status, Collection Result, and orchestrator-only mutation results. State that returning them to the orchestrator remains allowed, and that a direct request may still show the requested result.

**Rationale**: The observable states the class. The prose makes the required field class reviewable without a new rule identifier or a second obligation in the row. It matches the existing X2.1 explanatory paragraph.

**Alternatives considered**: Putting every field name in the X2.34 observable was rejected because the supplied observable is the normative check and already covers the class.

## Decision: Update only Experience Standard review checks

**Decision**: Update these files:

- `.highway/tools/tests/highway-ux-alignment.test.sh`
- `.highway/tools/tests/experience-standard-amendment.test.sh`
- `.highway/tools/tests/feature-092-contract.test.sh`, only the Experience Standard X1.7 assertion

Do not change skill `version: 4.0.0` assertions, skill `Why it matters:` assertions, constitution history assertions, or tests that only require preserved sentences such as the X2.3 observable. Do not register a new `[auto]` check. Do not reference the tests from the Experience Standard or from a skill.

**Rationale**: Those three files are the review checks that encode the superseded Experience Standard contract. Other `4.0.0` hits are skill versions, profile schema fixtures, or Skills Constitution history. Retargeting them would violate the deferred skill boundary. The new rules are agent-checkable, so the inventory test's `[auto]` scan does not need a new registered check.

**Alternatives considered**: Leaving the three tests unchanged was rejected because they would fail on the amended standard or, if the old tokens were kept beside the new ones, would accept both contracts. Disabling them was rejected because the 5.0.0 contract must be the passing baseline. Updating historical `specs/102-*` records was rejected because they are not live documentation.

## Decision: Prove the document contract, not a live Setup run

**Decision**: Treat the edited tests as static document-contract evidence. Run them, then `.highway/tools/tests/run-all.sh`, as the repository review. Do not claim they execute a guided conversation.

**Rationale**: This feature does not change skills. A live Setup run would still follow the old skill wording. The specification's passing baseline is the amended standard and its review checks.

**Alternatives considered**: A manual conversational fixture was rejected because it would either test unchanged skills or invent a runtime harness this amendment forbids.
