# Contract: Harness Behavior

## F8: service errors

- `classifyError` returns `service-error` for text matching `/-32603|no response was returned/i`.
  It does this before the `unclassified` fallback, and every other pattern keeps its result.
- `retryServiceError(call, onRetry)` runs `call`. When it throws a `service-error`, it calls
  `onRetry(error)` once and runs `call` again. Any other error, or a second failure, is rethrown.
- The driver resends the same prompt through `retryServiceError`, logs `system: retrying turn
  after service error`, and clears the turn's messages before the resend.
- The runner returns `blocked` for a scenario when every failure of its last attempt has kind
  `service-error`. Otherwise it returns `fail`, as today.
- `LIKELY_CAUSE["service-error"]` names the Copilot service and says the turn was retried once.

## F11: experience activation

- `isExperienceSkillRead(path)` is true when the path ends in `highway-experience/SKILL.md`,
  with any folder before it.
- When the permission handler approves such a read and no output has been seen,
  `highway-experience` is added to the skills before output, once.
- `experienceInvariant` is unchanged.

## F13: `shows`

- `showsFailures` removes emphasis markers from both the agent text and the expected line, then
  compares with whitespace collapsed. Markers are runs of `*`, and runs of `_` at a word
  boundary. An underscore inside a word, such as `snake_case`, stays.
- The harness README `shows` row says emphasis is not compared, and that this supersedes the
  exact comparison (D3.5).
