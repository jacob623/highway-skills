# Feature 040 Research

## Decision: Reuse Feature 039's coverage contract

**Rationale**: Feature 039 established `coverage.md` with the ordered columns `Requirement`, `Outcome`, and `Evidence`, plus the outcomes `satisfied`, `deferred`, and `historical`. Reusing that contract keeps the completion checker deterministic and prevents a second historical format.

**Alternatives considered**:
- Introduce a separate historical-record format: rejected because it would create another parser and weaken D7.4's single-schema guarantee.
- Preserve each feature's original evidence format: rejected because the older records have no common machine-checkable shape.

## Decision: Discover the full completed scope from feature directories

**Rationale**: The existing Feature 039 loop filters on `tasks.md`, which is appropriate for its post-021 scope but omits historical directories without that file. Feature 040 must enumerate the completed feature directories from 001 onward, explicitly exclude incomplete Feature 003, and retain the existing assertions for each in-scope record.

**Alternatives considered**:
- Keep the `tasks.md` requirement: rejected because it would silently omit the historical features this phase exists to cover.
- Hard-code the 18 feature names: rejected because an enumerated list would become stale and would not prove the declared scope.

## Decision: Keep `historical` bounded to Features 001-020

**Rationale**: Historical rows carry forward an old completion claim when neither a current satisfying artifact nor a demonstrated correction can be established. The bounded numeric rule is mechanically decidable and prevents new work from using `historical` as an escape hatch.

**Alternatives considered**:
- Permit `historical` for all features: rejected because it would conceal current completion defects.
- Convert every unverifiable row to `deferred`: rejected because that invents an owner and outstanding work.

## Decision: Use a semantic evidence review for row outcomes

**Rationale**: File existence alone cannot establish that an artifact satisfies a requirement. Current artifacts may be marked `satisfied` only after review; later corrections may be marked `deferred` with the correcting feature; remaining rows use `historical` with carried-forward completion provenance. The automated check validates structure and artifact existence, while the outcome judgment remains reviewable evidence.

**Alternatives considered**:
- Mark all shipped requirements `satisfied`: rejected because the feature explicitly identifies manufactured green rows as the primary failure mode.
- Let the green suite decide outcomes: rejected because test success does not prove historical requirement satisfaction.

## Decision: Extend the existing test rather than add a parallel checker

**Rationale**: `completion-coverage.test.sh` already owns the schema, row identity, evidence, duplicate, unknown, missing, artifact-existence, and out-of-range historical assertions. Widening its scope preserves one enforcement path and lets the existing fixture probes remain regression coverage.

**Alternatives considered**:
- Add a second historical coverage test: rejected because overlapping checks could disagree and would duplicate enforcement logic.
- Replace the existing assertions: rejected because Feature 040 must retain Feature 039's checks.

## Decision: No external contract artifact

**Rationale**: The repository exposes no API or service through this feature. The stable interfaces are internal Markdown and shell-test contracts, documented in `data-model.md` and `quickstart.md`.

**Alternatives considered**:
- Add a CLI contract: rejected because no new command or user-facing command schema is introduced.
