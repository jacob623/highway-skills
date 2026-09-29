# Research: Final Governance Amendment

## 1. Which files change

**Decision**: Edit the Skills Constitution, the Experience Standard, `.highway/skills/_authoring-standard.md`, and the three tests that still require the superseded sentences or the removed Experience Standard history.

**Rationale**: The 2026-09-29 clarification puts the two governance documents and the tests and live citations of the old rules in this change. Skill domain workflows stay out. The only live citation that still requires a split is the authoring standard. The tests that pin the old Decision Context sentence, the numbered recommendation sentence, or Experience Standard history are `highway-ux-alignment.test.sh`, `experience-standard-amendment.test.sh`, and `constitution-inventory.test.sh`.

**Alternatives considered**: Governance files only, which would leave the suite failing and the authoring standard teaching a split. Including Profile, Objectives, Controls, Non-Functional Requirements, and Setup rewrites, which the specification keeps for a later change.

## 2. The size rule

**Decision**: Redefine P7.6 in place. Leave P7.3, P7.4, and P7.5 unchanged. Classify the constitution amendment as major, 4.1.0 to 5.0.0. Ratified stays 2026-09-06. Last amended stays 2026-09-29. Prepend a sync report and keep every older constitution report.

**Rationale**: The versioning policy classifies redefining a governance rule as major. The limits themselves do not change, so P7.4 and P7.5 are not redefined. P7.3 remains the rule that forbids restating an outside requirement. A new principle is not needed and would change precedence.

**Alternatives considered**: A new rule beside the split rule, which would leave the split obligation in force. Treating the remedy change as minor, which contradicts the versioning policy.

## 3. Decision Context and recommendations

**Decision**: Redefine X2.9 and X2.25 in place. Keep X2.16 through X2.22 and X2.27 through X2.31. Add one non-normative recommendation illustration that shows grounding, choices, a selection path, and a user-authored alternative, and that says the sketch is not a required layout. Classify the Experience Standard amendment as major, 3.0.0 to 4.0.0. Ratified stays 2026-09-08. Last amended stays 2026-09-29.

**Rationale**: Unlabeled Decision Context can pass today and must fail after the label is required, so the change strengthens an obligation. Replacing the numbered-list requirement redefines X2.25. Either classification is major. The five-choice cap and selection-as-acceptance already live in neighboring rules, so they stay put.

**Alternatives considered**: A new recommendation rule while leaving the numbered-list rule in place. That would keep the layout requirement. Putting the label only in an example, which would leave unlabeled context able to pass.

## 4. History

**Decision**: Replace the Experience Standard opening comment with only the 4.0.0 sync report. Keep every Skills Constitution sync report, including `4.0.0 → 4.1.0 (MINOR)`, `3.0.1 → 4.0.0 (MAJOR)`, `2.6.0 → 3.0.0 (MAJOR)`, and the Principle XI bump rationale.

**Rationale**: The specification removes accumulated Experience Standard narratives from the runtime document and leaves repository history as their source. The same instruction keeps constitution history. Tests that require the removed Experience Standard strings are updated and comment the superseded behavior. They do not keep those strings in the runtime document in order to stay green.

**Alternatives considered**: Leaving the Experience Standard reports so existing greps keep passing. Deleting constitution history to match the Experience Standard. Both contradict the specification.

## 5. Citations and checks that stay out

**Decision**: Paraphrase the authoring citation so it tells the author to reduce the skill until both limits hold, and still cite P7.4, P7.5, and P7.6. Do not paste the new P7.6 sentence into that file. Do not edit `SKILL.md` files. Do not edit `control-derived-nfr.test.sh` or `objective-management.test.sh`. Do not retarget a check, edit the parser, edit a generator, or regenerate adapters.

**Rationale**: The authoring-standard test rejects a copied constitution sentence of 25 characters or more. The new P7.6 sentence is longer than that. Domain skills already contain their own recommendation and Decision Context wording; this feature does not rewrite those workflows. `highway-objectives` already contains `**Why it matters:**`, so the existing skill assertion that searches for `Why it matters:` still matches and is not a requirement to keep the old X2.9 sentence. P7.6 has no registered check, so it stays `[agent-checkable]`.

**Alternatives considered**: Copying the new rule into the authoring standard. Updating domain skills so every `Why it matters:` line is rewritten to the bold label. Both pull skill workflow text into this feature.
