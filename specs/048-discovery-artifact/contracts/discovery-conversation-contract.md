# Discovery Conversation Contract

## Invocation

The agent must request or receive one explicit source identifier in the form `REQ` followed by exactly six digits. It must not select a Request implicitly from recency, filename order, or a batch listing.

## Resolution Response

Before analysis, the agent must resolve the identifier to exactly one Request and verify that its completion state is `Complete`. If the identifier is missing, malformed, ambiguous, nonexistent, non-unique, or incomplete, the agent reports the actionable problem and aborts without allocating an identifier or writing output.

## Analysis Response

For a valid source, the agent performs the deterministic rule order in [discovery-analysis-contract.md](discovery-analysis-contract.md). It may report progress, but it must not request discretionary analysis text or accept requester-authored replacements for rule-generated sections.

## Completion Response

On success, the agent reports the created `DISCXXXXXX` identifier, the Request identifier, the record path, and the catalog path. It reports relationship candidates as advisory observations only.

## Failure Response

On validation, privacy, allocation, or write failure, the agent reports the actionable failure, confirms that no partial Discovery or catalog update was written, and preserves existing output bytes. Allocation conflicts may be retried no more than three times.
