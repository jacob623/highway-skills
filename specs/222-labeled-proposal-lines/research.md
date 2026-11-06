# Research: Labeled Proposal Lines

## R1. Line form

- Decision: The list item keeps the bold name and the description, or the bold title and Realized By. A blank line follows. Then `   **Recommendation:**` or `   **Evidence:**`, indented three spaces.
- Rationale: The When to use and When not to use shapes put **Why it matters:** this way. The same form reads the same in every proposal.
- Alternatives considered: Moving Realized By onto its own line too. Rejected, because the request names only Evidence.

## R2. Pins and moved assertions

Skill version `highway-codify-config` 3.2.4 to 3.2.5:

- `platform-starting-point.test.sh`
- `group-realized-capabilities.test.sh`
- `config-live-rules.test.sh`
- `codify-config-skill.test.sh`
- `standard-starting-point.test.sh`
- `entry-level.test.sh`
- `single-rule-shape.test.sh`
- `codify-file-layout.test.sh`
- `configure-handoff.test.sh`

Moved assertion:

- `platform-starting-point.test.sh` requires `1. **[Title]:** Realized By: [Platform]. Evidence: [What the current documentation describes.]` in `platform proposal`. It becomes `1. **[Title]:** Realized By: [Platform].` with the new test pinning the **Evidence:** line under it. Reason: R1 moves Evidence onto its own line.

No test pins the inline conflict line.

## R3. Word budget

- Decision: Each changed shape adds no words. The label gains bold markers, and the line break adds none. `platform proposal` is 327 words, `standard proposal` is 325, and `conflicts` is 223.
- Rationale: The limits are 400, 400, and 250.
- Alternatives considered: None needed.
