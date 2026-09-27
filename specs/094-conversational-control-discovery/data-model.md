# Feature 094 Data Model

## Interaction state

### Discovery Evidence

- `concern`: transient area, risk, decision, or matter.
- `condition`: transient desired state or boundary when it can narrow the obligation.
- `obligation`: transient user-adopted requirement.
- `classification`: transient Control, NFR, or ambiguous routing decision.
- `user_override`: transient marker used only after advice when the user explicitly retains vague wording.

None of these fields is added to the retained Control record.

### Proposal

- `title`: staged user-facing title.
- `statement`: staged user-facing statement.
- `rationale`: staged explanation.
- `route`: normal Control-ready or explicit user-override.
- `decision`: accept, correct, replace, reject, cancel, or unresolved.

Proposal content is discarded on exit unless accepted and persisted.

### Collection state

- `mode`: setup/configure multi-Control collection or direct add one-Control creation.
- `continuation`: active, continue, finished, declined, aborted, or blocked.
- `created_control_ids`: cumulative immutable IDs allocated by verified new creations in this active interaction only.
- `resume_applicability`: always `New interaction` for conversational discovery.

Collection state is not restored by a new invocation.

## Repository state

### Durable Control Record

Existing fields remain authoritative: permanent `CTLXXXXXX` identifier, title, statement, rationale,
active status, and identifier-only `nfrs` relationship list.

### Control Catalog and Baseline

The existing catalog retains deterministic ordering, next identifier allocation, baseline version,
identifier immutability/non-reuse, and readiness ownership. Each accepted conversational Control is
one Add transaction and one existing Add MINOR increment.

### NFR Candidate-Generation State

For each verified new Control, the NFR owner receives deterministic candidates derived from the
normalized Control title and statement. The durable owner state distinguishes:

- zero candidates: existing Not Applicable path;
- candidates with none accepted: In Progress;
- accepted artifacts: Complete;
- malformed or unavailable generation: Blocked with a reason.

Candidate generation runs exactly once from the owner workflow perspective for each new Control. No
candidate is generated for reuse, update, rejected, failed, or pre-existing Controls.

## State transitions

1. `Missing readiness` -> `proposal` -> `verified Control` -> `candidate generation`.
2. `verified Control` -> `collection Continue` for setup/configure, or terminal Add result for direct add.
3. `collection Continue` -> another proposal, suggestions/help, or explicit `Finished`.
4. `collection Finished` -> fresh Controls readiness -> NFR review when candidate state permits.
5. candidate generation -> zero-candidate Not Applicable, In Progress, Complete, or Blocked.
6. any interrupted discovery -> new interaction from persisted repository state only.
7. write/verification failure -> prior verified repository state unchanged and no completion claim.
