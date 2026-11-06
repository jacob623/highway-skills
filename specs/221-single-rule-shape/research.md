# Research: Single Rule Shape

## R1. Where the rule limits sit

- Decision: The word limit, the one-outcome split, the rewrite, and **Why it matters:** are `rule shape`, immediately after `standard rules` and immediately before `standard proposal`. `standard rules` step 3 follows it. Step 9 still returns to `standard proposal`.
- Rationale: `standard rules` is 194 words. The new instructions do not fit beside steps 4 through 9 and stay under 250.
- Alternatives considered: Putting the instructions in `standard rules` step 3. Rejected, because that step would pass 250 words.

## R2. What fifteen counts

- Decision: Fifteen counts suggestions the model writes from the documentation. Rules the person provides, including saved rules, do not count and are not left out. On an update the model may add at most fifteen further suggestions. The credentials rule is one suggestion. A storage way the documentation names is a second suggestion.
- Rationale: The person can keep as many rules as they want. The cap limits what the model adds.
- Alternatives considered: A cap of fifteen on the saved standard. Rejected by the clarification.

## R3. When a rule is rewritten

- Decision: A rule the person provides, or a saved rule, that lacks must, has more than eight words, or joins a second outcome with and, or, or a comma is rewritten before the proposal is presented. The opening consequence sentence states the rewrite. **Why it matters:** states the consequence of the rewritten rule and is not saved.
- Rationale: The proposal the person reads already conforms. The sentence before it is where a dropped suggestion is already named.
- Alternatives considered: Showing the person's wording until the next update, and stating the rewrite under **Why it matters:**. Rejected by the clarification.

## R4. Pins and moved assertions

Skill version `highway-codify-config` 3.2.3 to 3.2.4:

- `codify-config-skill.test.sh`
- `config-live-rules.test.sh`
- `codify-file-layout.test.sh`
- `configure-handoff.test.sh`
- `platform-starting-point.test.sh`
- `standard-starting-point.test.sh`
- `entry-level.test.sh`
- `group-realized-capabilities.test.sh`

Template version `coding-standard.md` 3.0.0 to 3.0.1:

- `config-live-rules.test.sh`
- `codify-file-layout.test.sh`

`codify-products.test.sh` and `codify-closing-guide.test.sh` pin a different catalog at 3.0.0. Those pins stay.

Moved assertions:

- `standard-starting-point.test.sh`: `standard rules` steps 1, 3, and 5 take the text in [contracts/rule-shape.md](contracts/rule-shape.md). Step 6 names fifteen suggestions and does not leave out a rule the person provided. The heading order gains `### rule shape` between `### standard rules` and `### standard proposal`. Reason: R1 and R2.
- `entry-level.test.sh`: `standard rules` steps 3 and 6 take that same text. Reason: R1 and R2.
- `config-live-rules.test.sh`: the skeleton line `one rule containing the word must; at most ten rules` becomes the skeleton line in the contract. Reason: R2. The pin `This file does not contain a Why it matters line.` stays.
- `config-live-rules.test.sh`: the skill pin `the word must` becomes `with must once`, from `rule shape` step 1. Reason: R1 replaced `standard rules` step 3, the only line with `the word must`. Found while implementing.
- `entry-level.test.sh`: the pin on `standard rules` step 3, `Write each rule with the word must, naming a condition and the required outcome.`, becomes `rule shape` step 1. Reason: R1.

Unchanged pins: `standard rules` steps 2, 4, 7, 8, and 9, including `9. Return to `standard proposal`. The remove sentence stays. `rule shape` is reached only from `standard rules`, so a remove that does not run `standard rules` does not run `rule shape`.

## R5. Word budget

- Decision: `standard rules` is 241 words after the step 1, 3, 5, and 6 replacements. `rule shape` is 144 words. `standard proposal` is 314 words today, and the rule block adds fewer than twenty.
- Rationale: The limits are 250, 250, and 400.
- Alternatives considered: A second new step for the rewrite. Rejected, because `rule shape` has room.
