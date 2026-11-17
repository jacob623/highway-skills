# Contract: Harness checks (F23, F28)

## `shows:` (F23)

- Input: agent message text; list of expected strings from the scenario.
- Normalization (both sides): remove runs of `*`; remove `_` at word boundaries as today; remove `` ` `` characters; collapse whitespace; trim.
- Pass: every expected string’s normalized form is a substring of the normalized agent text.
- Fail: `check: shows` with expected text and actual “the agent did not show it”.
- Unit proof: agent text containing `` run `highway-codify-config`. `` passes `shows: … run highway-codify-config.`; different skill name still fails.

## `contains-any` (F28)

- Input: project files matching the path glob; argument string.
- Pass: at least one matching file’s content includes the argument when both are compared case-insensitively.
- Fail: same shape as today (`contains-any`, expected text in at least one file).
- `contains` remains case-sensitive.
- README: document that `contains-any` ignores case.
- Unit proof: file holds `Grow Repeat Customers`; expectation `repeat` passes.

## Non-goals

- No scenario file edits.
- No change to other assertions except as above.
