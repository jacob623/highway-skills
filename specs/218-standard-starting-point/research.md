# Research: Standard Starting Point

## R1. `standard rules`

- Decision: The rule-building paragraph and the structure-path paragraph in `standard proposal` become nine numbered steps in `standard rules`, after `standards`. Step 9 returns to `standard proposal`.
- Rationale: `standard proposal` is 400 words. The starting-point line needs room, and the paragraph is the last prose block in the standard path.
- Alternatives considered: Shortening sentences in place. Rejected, since the paragraph would stay prose.

## R2. Keeping existing pinned wording

- Decision: Where a pinned sentence already reads as a condition and an action, the numbered step keeps it as a substring. `platform written` and `standard write` step 3 gain `question` and `unknown` sentences beside their existing text, and keep "Otherwise, or after `decline`, go to `platforms`." and "Otherwise state the consequence of the accepted change in one sentence and go to `menu`."
- Rationale: The behavior those pins describe does not change.
- Alternatives considered: Sub-bullets per reply. Rejected, as they replace pinned lines without changing behavior.

## R3. Proposal close order

- Decision: Each proposal and `resolve` follow one pattern: numbered steps that build it, "Fill this proposal.", the shape, numbered steps that complete it, then "Emit this proposal, then the closing question and the cancel line."
- Rationale: "Emit this proposal." before the conflict assessment left the order open. Fill, complete, then emit states it.
- Alternatives considered: Keeping "Emit this proposal." as step 3. Rejected for that reason.

## R4. Named platform

- Decision: `platforms` step 1 applies the name bullets to a name Entry carried and emits no list. Step 2 reads and emits the list otherwise. An onboard `decline` emits the list and its question.
- Rationale: Entry carries the name. The name bullets already state the three outcomes.
- Alternatives considered: A new step for a named platform. Rejected, since the bullets already hold the rules.

## R5. Word-count range

- Decision: `config-live-rules.test.sh` ends each counted step at the next `### ` heading.
- Rationale: With `use entries` after `current`, the fixed end `### platform proposal` would count `use entries` as part of `current`. A next-heading end measures the step itself.
- Alternatives considered: Updating the fixed end headings. Rejected, as the next move would break them again.

## R6. Pins and moved assertions

Pins that move:

- `highway-codify-config` 3.2.0 to 3.2.1: `codify-config-skill.test.sh`, `config-live-rules.test.sh`, `codify-file-layout.test.sh`, `configure-handoff.test.sh`, `platform-starting-point.test.sh`

Moved assertions:

- `config-live-rules.test.sh` stops requiring "does not run `current`". Reason: `standard proposal` now states its remove as a numbered step with "Do not run `current`", matching `platform proposal`. It requires "Do not run `current`" instead.
- `config-live-rules.test.sh` word counts end at the next `### ` heading instead of fixed headings. Reason: R5.
- `platform-starting-point.test.sh` stops requiring "3. Emit this proposal." in `platform proposal`. Reason: R3 fills the shape first. It requires "3. Fill this proposal." and "6. Emit this proposal, then the closing question and the cancel line." instead.
- `platform-starting-point.test.sh` keeps "List each capability `current` marked new under New Realized Capabilities. With none, show `None`." as a substring of step 5.
