# Feature Specification: Generated Artifact Correspondence

**Feature Branch**: `016-artifact-correspondence`

**Created**: 2026-09-08

**Status**: Draft

**Input**: User description: "I want the catalog and the generated agent adapters to stay true to the skills actually present in .highway/skills/, across adding, changing, and removing a skill, and I want that written as rules rather than left as tests somebody discovers by failing. Add three rules to the Highway Development Constitution at .specify/memory/constitution.md, under Principle IV, as a MINOR amendment taking it from 1.1.0 to 1.2.0. D4.5: every skill in the source MUST have its generated artifacts. D4.6: a generated artifact MUST NOT name a skill absent from the source. D4.7: a change to a generator's input MUST be followed by regeneration. Tag all three [auto] and give each a row in the Enforcement Map naming the test that decides it, per the definition feature 014 recorded. Enforce all three by extending the existing adapter-coverage.test.sh rather than adding a second mechanism that asserts an overlapping property, and write the checks over the set of skills present rather than over a list of the ones that exist today. Use highway-inquiry as the subject of the failure proofs, breaking each correspondence in turn and restoring it. Take care that a currency check does not leave regenerated files behind when it finishes. Decide separately whether the generators should prune what they no longer produce."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - A skill added to the source reaches the people who need it (Priority: P1)

A maintainer adds a directory under `.highway/skills/`. Today they must remember, unaided, to
regenerate the catalog, regenerate three agent adapters, and hand-add distribution manifest rows.
Nothing tells them if they forget. Feature 015 forgot the manifest rows, and packaging still
reported success while the new skill was silently absent from every distribution.

After this feature, omitting any of those steps fails the test suite with a message naming the
skill and the missing artifact.

**Why this priority**: This case has already occurred once, in the most recent feature. The defect
is not hypothetical and it grows with every skill added.

**Independent Test**: Add a skill directory without regenerating anything, confirm the suite fails
naming that skill, then complete the generation steps and confirm it passes.

**Acceptance Scenarios**:

1. **Given** a skill directory with no catalog entry, **When** the suite runs, **Then** it fails and names the skill and the missing catalog entry.
2. **Given** a skill with an adapter missing from one agent tree, **When** the suite runs, **Then** it fails and names the skill and the agent tree.
3. **Given** a skill whose adapters have no distribution manifest rows, **When** the suite runs, **Then** it fails and names the skill and the unclassified paths.
4. **Given** every skill fully generated, **When** the suite runs, **Then** it passes.

---

### User Story 2 - A removed skill leaves nothing behind (Priority: P1)

A maintainer deletes a skill directory. Neither generator prunes — verified 2026-09-08, the only
`rm` in either is of a temporary file. The deletion therefore leaves a catalog entry, three
orphaned adapter files, rows in the adapter manifest, and rows in the distribution manifest.
Because those distribution rows say `include`, **the orphaned adapters still ship**. A recipient
receives a skill with no source, listed by `highway-help`, that nobody can maintain or fix.

**Why this priority**: The most severe of the three cases, because its output reaches a user rather
than merely inconveniencing a maintainer.

**Independent Test**: Remove a skill directory without cleaning up, confirm the suite fails naming
each orphan, then restore the directory and confirm it passes.

**Acceptance Scenarios**:

1. **Given** a catalog entry naming a skill with no source directory, **When** the suite runs, **Then** it fails and names the entry.
2. **Given** an adapter file for a skill with no source directory, **When** the suite runs, **Then** it fails and names the file.
3. **Given** a distribution manifest row marked `include` for an adapter whose skill has no source, **When** the suite runs, **Then** it fails and names the row.
4. **Given** no orphan in any of those places, **When** the suite runs, **Then** it passes.

---

### User Story 3 - A changed skill does not report stale information (Priority: P2)

A maintainer edits a skill's description, usage, or version and does not regenerate. The catalog
keeps the old value, and `highway-help` answers confidently and wrongly — the failure mode that
produces no error message at all.

Verified 2026-09-08 that nothing catches this today. `D4.1`'s rule text is about hand-editing
rather than currency, and its Enforcement Map row names a test that asserts hand-edit refusal for
adapters and never regenerates the catalog. `generate-catalog.test.sh` runs the generator twice
against *unchanged* inputs, which is determinism rather than currency. Nothing regenerates from
current source and compares against what is committed.

**Why this priority**: Silent misinformation is worse than a visible gap, but unlike a removed
skill it does not ship a maintenance orphan, so it ranks below the two P1 cases.

**Independent Test**: Change a skill's description without regenerating, confirm the suite fails,
then regenerate and confirm it passes.

**Acceptance Scenarios**:

1. **Given** a skill whose description differs from its catalog entry, **When** the suite runs, **Then** it fails and names the skill and the stale field.
2. **Given** every generated artifact refreshed from current source, **When** the suite runs, **Then** it passes.
3. **Given** the currency check has run, **When** it finishes, **Then** it has left no regenerated file behind and the working tree is as it found it.

---

### User Story 4 - The obligation is readable, not only discoverable by failing (Priority: P2)

A contributor asks "must I regenerate after changing a skill's description?" and finds the answer
in the governing document rather than by pushing a change and watching the suite go red.

**Why this priority**: Feature 011 settled the general principle that a test without a written rule
leaves the constraint discoverable only by failure. This feature exists partly because that
principle was not applied here.

**Independent Test**: Read the Development Constitution and locate the three obligations and the
test that decides each.

**Acceptance Scenarios**:

1. **Given** the amended constitution, **When** a reader looks under Principle IV, **Then** D4.5, D4.6 and D4.7 are present with an Observable and a tier each.
2. **Given** the Enforcement Map, **When** a reader looks up any of the three, **Then** a row names the test that decides it.
3. **Given** the amendment, **When** a reader checks the Sync Impact Report, **Then** it is recorded as MINOR `1.1.0 → 1.2.0` with its reasoning.

---

### Edge Cases

Found by inspecting the repository on 2026-09-08. These are the cases most likely to make a naive
implementation either flaky or falsely green.

- **Fixture rows from the mock agent.** `.adapter-manifest` carries three rows under
  `.mock-agent-4/`, left by `new-agent-extensibility.test.sh`. No such directory exists on disk. A
  check asserting "every manifest row has a file" fails on these even though nothing is wrong.
- **Row ordering churn.** Regenerating after the suite has run reorders the mock rows within
  `.adapter-manifest`; a second run is stable. A naive byte-diff check therefore returns a
  different verdict depending on whether the suite ran first, and a check that fails for reasons
  unrelated to its rule is worse than no check.
- **The recorded generation timestamp.** `generate-catalog.sh` writes `generated_at`, so a plain
  "no diff" comparison fails on every run. D4.2 already carries this exception and D4.7 needs it.
- **Which trees count as agent trees.** Three agents are declared: `github-copilot`,
  `claude-code`, `cursor`. Mock trees are fixtures and must not be required to hold adapters.
- **Which generators count.** Four exist, including `generate-library-catalog.sh`. "Every
  generator" needs an explicit scope or the check silently covers fewer than it claims.
- **A zero-skills tree.** If the skills directory were empty, every "for each skill" assertion
  passes vacuously. The existing coverage test already guards this; the extended checks need the
  same guard.
- **A check that mutates the tree it checks.** Currency is tested by regenerating, which writes
  files. Left uncontrolled, this dirties the working tree on every suite run.

## Requirements *(mandatory)*

### Functional Requirements

#### The rules

- **FR-001**: The Development Constitution MUST state, as `D4.5`, that every skill in the source has its generated artifacts, observable as each directory under `.highway/skills/` having a catalog entry, an adapter in each declared agent tree, and a distribution manifest row for each adapter.
- **FR-002**: The Development Constitution MUST state, as `D4.6`, that a generated artifact does not name a skill absent from the source, observable as no catalog entry, adapter file, adapter manifest row, or distribution manifest row naming a skill with no directory under `.highway/skills/`.
- **FR-003**: The Development Constitution MUST state, as `D4.7`, that a change to a generator's input is followed by regeneration, observable as re-running every declared generator leaving no diff against the committed artifacts aside from a recorded generation timestamp.
- **FR-004**: All three rules MUST be tagged `[auto]`, and each MUST have an Enforcement Map row naming the test that decides it, per the definition feature 014 recorded.
- **FR-005**: The amendment MUST be recorded as MINOR, `1.1.0 → 1.2.0`, in the Sync Impact Report, with its reasoning.
- **FR-006**: `D4.7` MUST NOT restate `D4.1`. The two address different obligations — one prohibits editing the output, the other requires refreshing it after the input changes — and the non-restatement rules turn on rule text rather than on Observables, which these two necessarily share.

#### The enforcement

- **FR-007**: The checks MUST extend the existing `adapter-coverage.test.sh` rather than introduce a second mechanism asserting an overlapping property.
- **FR-008**: The checks MUST be written over the set of skills present at run time, never over an enumerated list of the skills that exist today, because an enumerated list is the defect being removed.
- **FR-009**: Each failure message MUST name the skill and the specific artifact at fault, so a reader learns what to fix without reading the test source.
- **FR-010**: The checks MUST declare explicitly which agent trees and which generators are in scope, rather than inferring the scope implicitly.
- **FR-011**: The checks MUST tolerate the mock-agent fixture rows in `.adapter-manifest` and MUST NOT depend on the ordering of manifest rows.
- **FR-012**: The currency check MUST leave the working tree exactly as it found it, whether it passes or fails.
- **FR-013**: The checks MUST fail rather than pass vacuously when no skill is present.
- **FR-014**: `D4.7` MUST be verified to pass against the committed artifacts before it is enabled. If it does not, the amendment is MAJOR rather than MINOR and the classification MUST be corrected.

#### The proof

- **FR-015**: Each of five correspondences MUST be broken for `highway-inquiry` in turn and then restored — its catalog entry, an adapter, an adapter manifest row, a distribution manifest row, and its description changed without regeneration — confirming the check fails each time and passes again once restored.
- **FR-016**: Every skill present MUST be confirmed conformant at the end, naming `highway-help` and `highway-inquiry` explicitly.
- **FR-017**: The new checks MUST be evaluated against every existing fixture before being enabled, per `D3.4`.

#### Pruning

- **FR-018**: The generators MUST NOT delete an output whose source is gone. Removing an orphan stays a deliberate manual step.
- **FR-019**: The check MUST report every orphan it finds precisely enough to be acted on — naming each file or manifest row — so that the manual step is mechanical rather than investigative.

**Decided 2026-09-08: detect only, do not prune.** The asymmetry settles it. Failing to prune is
visible, non-destructive, and fixable at leisure; an over-eager delete is silent and may not be
recoverable. Skill removal is also rare, so the manual step is paid seldom while the risk of a
deleting generator would be carried on every run. Automatic pruning was considered and rejected;
it can be revisited if removals ever become routine, at which point a flag-guarded variant would
be the shape to reach for.

### Key Entities

- **Skill source**: a directory under `.highway/skills/`. The single authority on which skills exist.
- **Catalog**: generated index of skills; the source `highway-help` answers from.
- **Agent adapter**: a per-skill file copied into each declared agent tree.
- **Adapter manifest**: records each generated adapter with a hash, enabling drift refusal.
- **Distribution manifest**: classifies every repository path as shipped or development-only. Rows are hand-maintained, so no generator keeps them current.
- **Correspondence**: the property that the generated artifacts name exactly the skills present in the source, with current content.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: All five ways a skill can fall out of correspondence are detected by the test suite; today none of the five is.
- **SC-002**: Each of the five detections has been observed failing and then passing again after restoration, so no check is assumed to work on the evidence of passing alone.
- **SC-003**: A reader can find each of the three obligations, and the test that decides it, by reading the governing document rather than by causing a failure.
- **SC-004**: Running the suite twice in a row produces identical results and leaves no file modified, so the currency check is repeatable and non-destructive.
- **SC-005**: Adding a skill in future requires no update to any enumerated list for the checks to cover it.
- **SC-006**: No orphaned adapter can reach a distribution.
- **SC-007**: The full suite passes, with every skill present confirmed conformant by name.

## Assumptions

- **Declared agent trees are the three real ones** — `github-copilot`, `claude-code`, `cursor`. Mock trees created by tests are fixtures and are not required to hold adapters.
- **"Every generator" in D4.7 means the catalog, library catalog, and agent adapter generators.** The distribution generator is excluded: it produces a tree outside the repository rather than a committed artifact, so "no diff against the committed artifacts" does not apply to it.
- **The distribution manifest stays hand-maintained.** It is not generated, so D4.5 and D4.6 reach it as a correspondence obligation rather than a regeneration one.
- **`D4.7` passes today.** Verified 2026-09-08 by regenerating the catalog and diffing against the committed copy ignoring `generated_at`: no difference. To be re-verified before enabling, since the MINOR classification depends on it.
- **Both existing skills conform today**, so `highway-inquiry` is available as the subject of the failure proofs.
- **The rules are Layer 0.** They constrain generated artifacts of the build, which the routing test places in the Development Constitution with `D` ids.

## Dependencies

- The Gate is cleared: a second skill exists. With one skill this defect was unobservable, because the manifest's per-skill rows looked like a complete list rather than an enumeration waiting to fall behind.
- Feature 014's definition of `[auto]` for a Layer 0 rule, and the Enforcement Map it introduced.
- Feature 015's `adapter-coverage.test.sh`, which this feature extends.

## Out of Scope

- **Teaching any generator to delete.** Settled by FR-018: orphans are reported, not removed.
- Changing how `highway-help` reads the catalog.
- Adding a fourth agent tree.
- Making `generate-catalog.sh` preserve `generated_at` when nothing else changes. A reasonable future improvement, but D4.2 already carries the timestamp exception and D4.7 inherits it.
- Any correspondence obligation for library content, which is not per-skill.
