# Feature 039 Research

## Decision: Enforce coverage from Feature 021 onward here, and hand Features 001-019 to Feature 040

**Rationale**: D7.2 says a completed feature must record requirement coverage without a feature-number boundary, so full history is the right end state. Reaching it in one change is not: Features 001-019 hold 309 requirements whose disposition mostly cannot be re-derived, and folding them in makes a single change spanning roughly forty spec directories, twelve test files and the constitution. Partial completion of a change that size is the exact defect this feature removes. Feature 020 is handled here because Feature 021 already identified which of its requirements are unsatisfied.

**Alternatives considered**:
- Enforce 001 onward in this feature: rejected on size and on the risk of a manufactured-green back-fill.
- Stop permanently at 021: rejected because it would leave Features 001-019 outside the record forever; Feature 040 completes the coverage.

## Decision: Add a third outcome, `historical`, bounded to Features 001-020

**Rationale**: With only `satisfied` and `deferred`, a pre-021 requirement has no honest disposition. `satisfied` invents evidence that cannot be produced; `deferred` asserts work is owed that is not, and requires an owner who does not exist. `historical` records that the claim is carried forward rather than re-litigated. Bounding it to Features 001-020 is mechanically checkable, so it cannot become an escape hatch for new work.

**Alternatives considered**:
- Force every unverifiable row to `deferred`: rejected because it fabricates outstanding work and an owner.
- Force every unverifiable row to `satisfied`: rejected because it fabricates evidence.

## Decision: Use `coverage.md` with `Requirement`, `Outcome`, and `Evidence`

**Rationale**: The existing parser already compares requirement identifiers and validates `satisfied`/`deferred` outcomes. Fixing the path and schema lets the check decide one contract instead of interpreting multiple historical formats.

**Alternatives considered**:
- Preserve each feature's existing column names: rejected because the parser cannot distinguish artifact paths from outcomes consistently.
- Accept multiple filenames or schemas: rejected because that would keep D7.2 ambiguous and allow silent omissions.

## Decision: Treat corrective relationships as evidence in the originating record

**Rationale**: A later feature can correct a completed feature without rewriting its substantive history. The originating record therefore records the requirement as deferred and names the superseding feature; the corrective feature retains its own coverage record.

**Alternatives considered**:
- Rewrite completed feature specifications: rejected by D5.1 and D5.2.
- Record corrections only in a separate global ledger: rejected because the requirement disposition belongs beside the originating feature's coverage claim.

## Decision: Prove automatic-check scope with seeded failure probes

**Rationale**: D3.7 must be mechanically meaningful. A declared in-scope artifact is copied or represented in a disposable fixture, a defect is seeded, and the check must exit non-zero before restoration.

**Alternatives considered**:
- Keep `PRE_ENABLE` informational output: rejected because it cannot fail a run.
- Add a new runtime dependency: rejected because the existing Bash and file-based harness is sufficient.

## Decision: Reconcile feature identity without rewriting completed substantive records

**Rationale**: Directory identity is a development-record invariant. Feature 036 can move to its declared branch name, while Feature 033's canonical choice is recorded and references are updated only where necessary.

**Alternatives considered**:
- Leave placeholder or mismatched names: rejected because they make records ambiguous and violate the new D5.5 rule.
- Rewrite completed feature content: rejected because the correction belongs in Feature 039 and the coverage exception is intentionally narrow.

The canonical identity choices are the declared branch names: Feature 033 is relocated to
`specs/033-highway-setup-orchestration/`, Feature 036 is relocated to
`specs/036-strengthen-035-evidence/`, and the bracket characters are removed from the Feature
Branch values in Features 001 and 005. These changes reconcile record identity without changing
the substantive content of the relocated directories.

## Pre-enable measurements

- D3.7: PASS. All 39 test files declare artifact classes and a seeded-failure probe declaration;
	the automatic-check map names existing tests, and the mapped tests pass their disposable probes.
- D3.8: PASS for the structural obligation. All 39 test files declare an instrument class, and
	static document-contract evidence remains explicitly separate from executed-behavior evidence.
	Semantic classification of individual historical requirements remains an agent review boundary.
