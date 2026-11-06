# Research: Entry Level

## R1. `entry level`

- Decision: The class rules are nine numbered steps in `entry level`, between `current` and `use entries`. `use entries` step 2 follows it on an add.
- Rationale: `use entries` is 219 words. The two example lists, the task list, the limit of four, and the source rule need about 180 more.
- Alternatives considered: Placing the steps after `use entries`. Rejected, since the spec places `entry level` immediately before the step that follows it.

## R2. Update path

- Decision: On an update, `use entries` starts from the saved entries, keeps each one, and rewrites only an entry over five words or one that joins two things.
- Rationale: A person may already have narrowed a list. Rebuilding from `entry level` would replace their entries with classes.
- Alternatives considered: Rebuilding on every update. Rejected by FR-002 and FR-004.

## R3. Consequence placement

- Decision: **Why it matters:** states the consequence of the entry. **Consequences:** leaves both proposal shapes. `standard rules` step 6 names a dropped rule in the opening consequence sentence. `standard proposal` step 6 opens a remove with the kept-file sentence.
- Rationale: Every item **Consequences:** held now has one place: an entry's consequence under that entry, a rewrite in that entry's sentence, and a proposal-wide fact in the opening sentence.
- Alternatives considered: Keeping **Consequences:** for the dropped rule and the remove. Rejected by FR-013.

## R4. Blank line in the shape

- Decision: Both shapes show `1. [Entry]`, a blank line, then `   **Why it matters:** [One sentence stating the consequence of this entry.]`. `use entries` step 9 names the label and does not describe the break.
- Rationale: Objectives and NFRs already use a blank line before **Why it matters:** in their review shape.
- Alternatives considered: Describing the break in `use entries`. Rejected by FR-007.

## R5. Pins and moved assertions

Pins that move:

- `highway-codify-config` 3.2.1 to 3.2.2: `codify-config-skill.test.sh`, `config-live-rules.test.sh`, `codify-file-layout.test.sh`, `configure-handoff.test.sh`, `platform-starting-point.test.sh`, `standard-starting-point.test.sh`

Moved assertions:

- `codify-config-skill.test.sh` stops requiring `**Consequences:**`. Reason: FR-013 removes that section. `entry-level.test.sh` rejects it.
- `platform-starting-point.test.sh` replaces `use entries` steps 2, 4, 7, and 9 with the 3.2.2 text. Reason: FR-002 through FR-004 and FR-007 replace those sentences.
- `platform-starting-point.test.sh` stops checking that **Why it matters:** is the line after `1. [Entry]`. Reason: R4 adds a blank line. `entry-level.test.sh` checks the new form in both shapes.
- `standard-starting-point.test.sh` replaces `standard rules` step 6 and `standard proposal` step 6 with the 3.2.2 text. Reason: R3 moves both to the opening consequence sentence.
- `standard-starting-point.test.sh` adds `### entry level` to its heading-order list, between `### current` and `### use entries`. Reason: R1 adds that step.
