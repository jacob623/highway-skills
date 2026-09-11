# Feature Specification: Corrective Provenance Honesty

**Feature Branch**: `043-corrective-provenance-honesty`

**Created**: 2026-09-11

**Status**: Withdrawn — superseded by Feature 044 (spec-governance-removal), which removed `D7.5`
and `correction_check`, the rule and mechanism this feature was opened to correct. The defect this
spec named no longer has a subject.

**Input**: User description: "`D7.5` says a feature that corrects a defect in a completed feature must record that defect against the feature that shipped it, and its Observable says corrective coverage names the originating feature, the revised requirement, and the superseding feature. `correction_check` in `completion-coverage.test.sh` does not implement that. It requires the corrective feature's coverage record to contain at least one row whose Outcome is exactly `deferred` before it will look at provenance at all, and the word `deferred` appears nowhere in the rule or its Observable. The check is stricter than the rule it claims to decide, and the extra strictness is doing damage. Measured 2026-09-11: nine register rows declare a `Corrects` value, eight of them `complete`. Across those eight features, 96 requirement rows are recorded `deferred` and 0 are recorded `satisfied` — every requirement of every corrective feature, in features that shipped and are marked complete. The cheapest way to satisfy a check that demands a deferred row is to defer everything, and that is what the records did. It gets worse: `coverage_check` gates its artifact-existence assertion on `[[ \"$outcome\" == \"satisfied\" ]]`, so a deferred row's evidence is never checked to name a file that exists, and it only has to be non-empty. Measured across those same 96 rows: 0 contain a colon and 0 contain any file-ish token — not one names an artifact of any kind. The blanket deferral does not merely mislabel the outcome, it switches off the only assertion that would have tested the claim. Feature 042 then hit the same wall from the other side: it defers nothing, so when its register row is marked complete the suite fails with `corrective record has no deferred rows`, and its only escapes are to invent a false deferral or to leave the row `in-progress` forever, which is the same `-` placeholder dishonesty Feature 042 was opened to remove. Correct `correction_check` to decide the Observable as written. Do not remediate the 96 rows here and do not settle `D7.5`'s tier here — both are larger than this and both are owned by their own governance phases."

## Clarifications

### Session 2026-09-11

- Q: Where must corrective provenance appear for the check to find it? → A: Anywhere in the coverage record. The Observable says corrective coverage *names* three things; it does not say in which cell. Requiring an Evidence cell would re-invent the same over-strictness this feature exists to remove, and would force a feature that defers nothing to manufacture a row to hold the provenance.
- Q: Should this feature also require a `deferred` row's evidence to name an existing artifact, closing the bypass in `coverage_check`? → A: No. Enabling that against the tree fails all 96 rows immediately, and `D3.4` requires a new check to be evaluated against every existing record before it is enabled. The measurement is recorded here and the remediation is owned by Phase 16.
- Q: Should `D7.5` be retagged `[auto]` and added to the Enforcement Map as part of this? → A: No. That is Phase 15. This feature changes no rule text and no tier.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - The check decides the rule it claims to decide (Priority: P1)

As a Highway maintainer, I want `correction_check` to enforce `D7.5`'s Observable and nothing more,
so that a corrective feature is judged against the rule the constitution states rather than against
an obligation the check invented.

**Why this priority**: The invented obligation is not inert. It is the direct cause of the 96-row
blanket deferral measured on 2026-09-11, and it is currently blocking Feature 042 from being
recorded complete honestly. Every run of the suite that passes today passes partly because eight
coverage records were shaped to a requirement the constitution does not impose.

**Independent Test**: Present a corrective coverage record that names the originating feature, the
revised requirement and the superseding feature, with no row whose Outcome is `deferred`, and
confirm the check passes. Remove each of the three named elements in turn and confirm it fails and
says which element is missing.

**Acceptance Scenarios**:

1. **Given** a corrective feature whose coverage record carries all three provenance elements and
   no `deferred` row, **When** `correction_check` runs, **Then** it passes.
2. **Given** a corrective feature whose coverage record carries a `deferred` row with provenance,
   **When** `correction_check` runs, **Then** it still passes, so no existing record is invalidated.
3. **Given** a corrective coverage record naming no originating feature, **When** the check runs,
   **Then** it fails and names the missing element.
4. **Given** a corrective coverage record naming no superseding feature, **When** the check runs,
   **Then** it fails and names the missing element.
5. **Given** a corrective coverage record naming no revised requirement, **When** the check runs,
   **Then** it fails and names the missing element.
6. **Given** a feature with no `Corrects` value, **When** the check runs, **Then** it is not
   evaluated for provenance at all.

---

### User Story 2 - Feature 042 can be recorded complete without lying (Priority: P1)

As a Highway maintainer, I want a corrective feature that defers nothing to be able to hold an
honest coverage record and still satisfy `D7.5`, so that the register's `Corrects` column stays a
statement of fact rather than a cost to be avoided.

**Why this priority**: Feature 042 exists because a `-` was left in a column whose true value was
known. Measured 2026-09-11: flipping 042's register row to `complete` produces exactly one failure,
`FAIL: corrective record has no deferred rows`, against a record whose 27 rows are all `satisfied`
and every one of whose evidence paths `coverage_check` verified to exist. The record is the most
evidenced corrective record in the repository and it is the only one the check rejects.

**Independent Test**: Mark `042-probe-reachability-correction` `complete` in the completion register
and confirm the suite exits 0 without any row of its coverage record being changed to `deferred`.

**Acceptance Scenarios**:

1. **Given** Feature 042's register row is marked `complete`, **When** the suite runs, **Then** it
   exits 0.
2. **Given** that row is marked `complete`, **When** Feature 042's coverage record is read,
   **Then** no row has been changed from `satisfied` to `deferred` to achieve it.
3. **Given** Feature 042's coverage record, **When** it is read, **Then** it names Feature 041, the
   requirement of Feature 041 that was revised, and Feature 042 as the superseding feature, in a
   form the corrected check locates.

---

### User Story 3 - The deferral bypass is measured and recorded, not silently inherited (Priority: P2)

As a Highway maintainer, I want the evidence bypass that the blanket deferral exposed to be written
down with its measurement, so that the next feature to touch this area starts from a number rather
than rediscovering it.

**Why this priority**: The bypass is the reason the 96 rows cost nothing to write. `coverage_check`
asserts that a deferred row's evidence is non-empty and never that it is evidence. Leaving that
undocumented is how a defect survives three features in a row. Fixing it is out of scope; recording
it is not.

**Independent Test**: Read this feature's research record and confirm it states the measured counts
and the exact gating expression that produces the bypass.

**Acceptance Scenarios**:

1. **Given** this feature's research record, **When** it is read, **Then** it states that 96 of 96
   deferred rows across the eight complete corrective features contain no colon and no file-ish
   token, measured 2026-09-11.
2. **Given** that record, **When** it is read, **Then** it names the `satisfied`-gated condition in
   `coverage_check` as the mechanism and names Phase 16 as the owner of the remediation.
3. **Given** this feature's implementation, **When** it is reviewed, **Then** no assertion about
   deferred-row evidence was tightened, so no existing record is failed by this change.

---

### Edge Cases

- A corrective feature whose coverage record contains provenance for a *different* pair of features
  than its register row declares. The check reads the register's `Corrects` value; the provenance it
  finds must name that feature, not merely name some feature.
- A corrective feature correcting more than one feature. The register's `Corrects` column holds a
  single value today; this feature does not widen it, and a record naming additional originating
  features beyond the declared one is not an error.
- A feature whose register row is `in-progress` with a `Corrects` value. Feature 042 added the
  status filter that excludes it; this feature must not remove that filter.
- Provenance appearing in a row's Evidence cell versus in a dedicated section. Both are valid; the
  check reads the file.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: `correction_check` MUST NOT require a coverage record to contain a row whose Outcome
  is `deferred`.
- **FR-002**: `correction_check` MUST require the corrective feature's coverage record to name the
  originating feature, the revised requirement, and the superseding feature, matching `D7.5`'s
  Observable and adding no further obligation.
- **FR-003**: The originating feature the check requires MUST be the one the completion register's
  `Corrects` column declares for that feature, not any feature.
- **FR-004**: `correction_check` MUST locate provenance anywhere in the coverage record, rather than
  only within a row of a particular Outcome.
- **FR-005**: The check MUST report which of the three elements is missing, rather than reporting
  only that the record is non-conforming.
- **FR-006**: Every one of the eight `complete` corrective features measured on 2026-09-11 MUST
  continue to pass the corrected check, so this change invalidates no existing record.
- **FR-007**: The corrected check MUST be evaluated against all nine register rows declaring a
  `Corrects` value before it is enabled, and each verdict recorded, per `D3.4`.
- **FR-008**: `completion-coverage.test.sh` MUST self-test the corrected check by seeding each of
  the three missing-element defects into a temporary coverage record and requiring the check to
  report each, following the `self_test_register` pattern already in that file.
- **FR-009**: The self-test MUST assert the reported message, not only the return code, so the
  three failures are distinguished from one another.
- **FR-010**: The status filter Feature 042 added, which scopes the corrective set to register rows
  recorded `complete`, MUST be retained unchanged.
- **FR-011**: Feature 042's coverage record MUST be brought into conformance with the corrected
  check without changing any row's Outcome from `satisfied`.
- **FR-012**: Feature 042's register row MUST be marked `complete` once it conforms, and the suite
  MUST exit 0 with that row complete.
- **FR-013**: This feature MUST NOT tighten any assertion about a deferred row's evidence.
- **FR-014**: This feature MUST NOT amend `.specify/memory/constitution.md`: no rule text, no
  Observable, no tier, and no Enforcement Map row.
- **FR-015**: This feature MUST NOT edit the coverage record of any of the eight complete corrective
  features.
- **FR-016**: The measured state of the 96 deferred rows MUST be recorded in this feature's research
  record, naming Phase 16 as the owner of the remediation.
- **FR-017**: `.highway/tools/tests/run-all.sh` MUST exit 0 after the final edit.

### Key Entities

- **Corrective feature**: a feature whose completion register row carries a `Corrects` value other
  than `-`. Nine exist as of 2026-09-11; eight are `complete`.
- **Provenance**: the three elements `D7.5`'s Observable names — originating feature, revised
  requirement, superseding feature — appearing in a corrective feature's coverage record.
- **The deferral bypass**: `coverage_check`'s artifact-existence assertion, gated on an Outcome of
  `satisfied`, which a `deferred` row never reaches. Measured but not closed by this feature.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A corrective coverage record with zero `deferred` rows and complete provenance passes
  the check.
- **SC-002**: Each of the three provenance elements, removed in turn from a seeded record, produces
  a distinct reported failure.
- **SC-003**: All eight complete corrective features pass the corrected check, verified by running
  it against each rather than by reasoning about it.
- **SC-004**: With Feature 042's register row marked `complete`, `run-all.sh` exits 0.
- **SC-005**: Feature 042's coverage record still shows 27 rows, all `satisfied`, after this feature
  completes.
- **SC-006**: The count of `deferred` rows across the eight complete corrective features is
  unchanged at 96 by this feature, because this feature remediates none of them.
- **SC-007**: `.specify/memory/constitution.md` is byte-identical before and after.

## Assumptions

- `D7.5`'s Observable is taken as the authority on what the check must decide. If the intended rule
  is genuinely stricter than the Observable states, the correct repair is an amendment, which
  Phase 15 owns — not an implementation that quietly exceeds the text.
- The 96 blanket-deferred rows are assumed to misstate their features' outcomes, on the grounds that
  those features are recorded `complete` and a record asserting that every requirement was deferred
  contradicts that status. This feature does not establish what the true outcomes are; Phase 16
  does, per feature, on evidence.
- `coverage.md` remains editable in a completed spec directory under `D5.1`'s recorded exception,
  so Phase 16's remediation is procedurally possible without further amendment.
