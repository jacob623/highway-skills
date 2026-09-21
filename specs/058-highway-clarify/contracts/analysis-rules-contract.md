# Clarification Analysis Rules Contract

## Resolution Order

1. Validate exact uppercase identifier.
2. Resolve through declared artifact path, catalog, or identifier mapping in the declared precedence order.
3. Resolve the colocated clarification path from the source path and identifier.
4. Load explicit Clarification Profile, required structure declarations, unknown markers, ambiguity vocabulary, and contradiction rules.
5. Analyze categories in this exact order: `contradiction`, `missing_input`, `unknown_value`, `ambiguity`, `unresolved_assumption`.
6. Emit at most one finding for each evidence source; higher category priority wins.
7. Validate the complete record before any write.

## Category Rules

### contradiction

Emit only when an explicit rule matches fields and values from the source artifact, Clarification
Profile, or repository contradiction catalog. General knowledge, semantic similarity, architectural
preference, and model inference cannot create this category.

### missing_input

Emit only when a declared template, artifact contract, owning skill output, owning workflow
contract, required field, or required section identifies missing content. No declared requirement
means no missing-input finding.

### unknown_value

Emit for `unknown`, `UNKNOWN`, `Unknown`, or other explicitly declared markers. Absence is not an
unknown value.

### ambiguity

Use the default vocabulary: `modern`, `scalable`, `appropriate`, `reasonable`, `adequate`,
`sufficient`, `robust`, `flexible`, `user-friendly`, `efficient`, `best practice`, `future-proof`,
`enterprise-grade`, `simple`, `easy`, and `optimized`. An explicit profile may extend or replace
this vocabulary.

### unresolved_assumption

Emit when an assumption is explicitly declared as unresolved by the source artifact, owning
workflow contract, or Clarification Profile. Do not infer an assumption solely from missing text.

## Update and Conflict Rules

1. Read the artifact and record its integer revision.
2. Stage the requested finding response in memory.
3. Re-read the artifact revision immediately before writing.
4. Abort with `status: conflict` when expected and actual revisions differ.
5. Write the complete artifact and append history only when revisions match.
6. Increment revision by exactly one after a successful commit.
7. Never automatically merge competing responses, findings, history, statuses, or metadata.
8. Retry the caller operation no more than three times; after three conflicts, abort.

Identical artifact bytes and identical requests produce the same finding decisions, conflict
outcomes, and revision progression without timestamps, wall-clock time, filesystem ordering,
thread scheduling, agent choice, or randomness.
