# Research: Group Realized Capabilities

## R1. Where grouping sits

- Decision: Grouping, titling, and marking are steps 4, 5, and 6 of `current`, after capture and before the remaining steps.
- Rationale: `current` captures and marks today. Grouping between those two keeps one order: capture, group, title, mark.
- Alternatives considered: A new step. Rejected, since `current` is 115 words and the three steps fit.

## R2. Matching existing capabilities

- Decision: A grouped capability is marked new only when the implementation's Realized Capabilities do not already mean that automation.
- Rationale: The 3.2.2 step compared by list. A capability recorded under another title would be proposed again.
- Alternatives considered: Matching by title. Rejected by FR-003.

## R3. Pins and moved assertions

Pins that move:

- `highway-codify-config` 3.2.2 to 3.2.3: `codify-config-skill.test.sh`, `config-live-rules.test.sh`, `codify-file-layout.test.sh`, `configure-handoff.test.sh`, `platform-starting-point.test.sh`, `standard-starting-point.test.sh`, `entry-level.test.sh`

Moved assertions, all in `platform-starting-point.test.sh`:

- "4. For a platform, mark each captured capability that the implementation's Realized Capabilities do not list as a new realized capability." becomes step 6, with "do not already mean" and "Judge that by meaning." Reason: R2.
- "5. Do not propose a capability the documentation no longer describes." becomes step 7. Reason: R1 inserts steps 4 and 5.
- "7. Then go to the proposal named with this step." becomes step 9. Reason: R1.
