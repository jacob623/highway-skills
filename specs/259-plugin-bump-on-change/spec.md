# Feature Specification: Plugin Bump on Change

**Feature Branch**: `259-plugin-bump-on-change`

**Created**: 2026-11-21

**Status**: Draft

**Input**: User description: "create a new spec to ensure the regenerate and version bump always take place as you've recommended." Later revised: final Spec Kit phase after a green suite that excludes plugin generation checks; then bump, regenerate, and run plugin generation–specific tests; harness only when already applicable.

When a Spec Kit feature changes covered plugin-build inputs, it closes with this finish order:

1. Run the full quality suite **excluding** the fixed closed list of plugin generation–specific
   checks (always the version-bump guard and the plugin drift / generate-currency check; plus only
   other suite members explicitly listed as package-currency checks for this purpose).
2. That excluded suite exits cleanly. If the feature already requires harness verification, that
   harness run has also exited cleanly (this feature does not newly mandate harness).
3. Bump the single source plugin version to a strictly greater semver than the comparison baseline.
4. Regenerate the plugin package from current sources (so the package carries the new version).
5. Run that same closed list of plugin generation–specific checks; they exit cleanly.

Features that never touch covered inputs skip steps 3–5. Publish to the public plugin repository
stays a separate promote step and is out of scope. Mid-feature regenerates for local or harness use
remain allowed; only the closing sequence above is mandatory for covered-input features.

## Clarifications

### Session 2026-11-21

- Q: When the version-bump guard decides whether plugin-build inputs changed, should it compare the full working tree (including uncommitted edits) to the `main` merge-base, or only commits already on the branch? → A: Working tree + index vs merge-base (uncommitted skill edits can fail the suite)
- Q: How should the guard decide that the plugin version is “higher” than the baseline version? → A: Strict semver greater-than (major.minor.patch)
- Q: Which paths should count as plugin-build inputs that require a version bump when they change? → A: Skills tree + all plugin source inputs that feed regenerate (except version-only)
- Q: Besides contributor documentation, should this feature also update Spec Kit packaging expectations (so new feature plans/tasks that change skills call out bump then regenerate)? → A: Docs + Spec Kit constitution (Highway-owned `.specify/memory/constitution.md`; not Highway Skills Constitution; not upstream Spec Kit skills/templates)
- Q: Should bump happen mid-change as soon as inputs differ, or as the final Spec Kit phase after verification? → A: Final phase after verification; harness only if that feature already requires it
- Q: What is the exact finish order relative to the suite and plugin checks? → A: Full suite excluding plugin generation–specific checks → that suite green → bump version → regenerate → run plugin generation–specific checks (not regenerate-before-bump)
- Q: How should the set of “plugin generation–specific checks” (excluded before bump, required after regenerate) be defined? → A: Fixed closed list (version-bump + plugin drift/currency, plus only other explicitly listed package-currency checks)

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Finish order for covered-input Spec Kit features (Priority: P1)

A maintainer finishes implementing a Spec Kit feature that changed covered plugin-build inputs
(skills tree plus plugin source files that regeneration copies or renders). They run the full
quality suite with plugin generation–specific checks left out; that run exits cleanly. If the
feature already required harness, harness has also exited cleanly. They then bump the plugin source
version, regenerate the plugin package, and run the plugin generation–specific checks until those
exit cleanly. Features that never touch covered inputs skip the bump/regenerate/plugin-check steps.

**Why this priority**: Verification of feature behavior can go green without fighting version/drift
failures, while the closing steps still force release identity and package currency before the
feature is done.

**Independent Test**: Walk a covered-input feature through excluded-suite green, bump, regenerate,
plugin-check green; confirm version increased and package matches a fresh build. Confirm a
docs-only feature skips steps 3–5.

**Acceptance Scenarios**:

1. **Given** a Spec Kit feature whose work changed covered plugin-build inputs, **When** the
   pre-bump verification runs, **Then** it is the full quality suite with plugin generation–
   specific checks excluded, and that run exits cleanly before bump or regenerate for close.
2. **Given** that pre-bump suite has exited cleanly (and harness has exited cleanly when already
   required), **When** the final phase runs, **Then** it bumps the plugin source version to a
   strictly greater major.minor.patch than the comparison baseline, then regenerates the plugin
   package from current sources (bump before regenerate).
3. **Given** bump and regenerate have completed, **When** the plugin generation–specific checks
   run, **Then** they exit cleanly (version-bump guard and plugin drift/currency among them).
4. **Given** a Spec Kit feature that changed covered inputs but does not already require harness,
   **When** the finish order is followed, **Then** harness is not a prerequisite solely because of
   this bump rule.
5. **Given** a Spec Kit feature that did not change covered plugin-build inputs, **When** the
   feature completes, **Then** no plugin version bump, regenerate-for-close, or plugin
   generation–specific closing run is required by this rule.

---

### User Story 2 - Plugin generation–specific checks enforce bump and regenerate (Priority: P1)

Plugin generation–specific suite checks fail when covered inputs changed vs the comparison baseline
and the plugin source version is not a strictly greater semver, or when the committed plugin
package does not match a fresh build. Those checks are excluded from the pre-bump suite run and
required after bump+regenerate so a feature cannot close with a stale version or stale package.

**Why this priority**: Process alone is not enough; the closing checks must refuse an unfinished
release identity or package.

**Independent Test**: With covered inputs changed and version still equal to baseline, run the
version-bump guard and confirm failure; bump, regenerate, and confirm version and drift checks
pass. Confirm the pre-bump suite path can complete without those checks.

**Acceptance Scenarios**:

1. **Given** the working tree (including staged and unstaged edits) modifies covered plugin-build
   inputs relative to the comparison baseline, **When** the version-bump guard runs and the plugin
   version equals the baseline version, **Then** the guard fails and names that a version bump is
   required.
2. **Given** the working tree modifies covered inputs relative to the comparison baseline, **When**
   the plugin version is a strictly greater semantic version (major.minor.patch) than the baseline
   version, **Then** the version-bump guard passes for that condition.
3. **Given** the working tree does not modify covered plugin-build inputs relative to the
   comparison baseline, **When** the version-bump guard runs, **Then** it does not require a
   version bump.
4. **Given** the working tree changes only the plugin source version field relative to the
   comparison baseline, **When** the version-bump guard runs, **Then** it does not require a
   further bump solely because of that version-only edit.
5. **Given** plugin-build inputs (including a bumped version) that differ from the committed plugin
   package, **When** the plugin drift check runs, **Then** it fails until regeneration brings the
   package current.
6. **Given** a maintainer is in the pre-bump verification step, **When** they run the full suite
   with plugin generation–specific checks excluded, **Then** those excluded checks do not block
   that run from exiting cleanly.

---

### User Story 3 - Docs and Spec Kit constitution describe the finish order; promote stays separate (Priority: P2)

Highway-owned contributor documentation and the Spec Kit development constitution
(`.specify/memory/constitution.md`) state the finish order for covered-input Spec Kit features:
excluded full suite green → (harness green only if already required) → bump version → regenerate →
plugin generation–specific checks green. Public promote/publish remains separate. The Highway
Skills Constitution and upstream Spec Kit skills/templates stay out of scope.

**Why this priority**: Highway docs and the development constitution encode the ordered obligation
without changing Spec Kit product templates the project does not own.

**Independent Test**: Read contributor packaging/release guidance and the Spec Kit development
constitution and confirm that finish order, harness-only-when-already-required, and separate
promote/publish.

**Acceptance Scenarios**:

1. **Given** the Highway contributor documentation for building and releasing the plugin, **When** a
   maintainer follows it for a feature that changed covered inputs, **Then** it instructs the
   finish order above (exclude plugin generation checks from the first suite, then bump, then
   regenerate, then run those checks).
2. **Given** that same documentation, **When** a maintainer looks for public publish steps,
   **Then** promote/publish is presented as optional or separate from the bump-and-regenerate
   obligation.
3. **Given** the Spec Kit development constitution, **When** a maintainer reads packaging currency
   obligations, **Then** covered-input features require that finish order without newly mandating
   harness for every such feature, and without amending the Highway Skills Constitution or
   upstream Spec Kit skills/templates.

---

### Edge Cases

- Only whitespace or generated-tree noise with no real input change: guard must not falsely require
  a bump when covered inputs are unchanged relative to baseline.
- Version bumped but still not higher than baseline (e.g. same string rewritten, or a string that
  sorts later lexicographically but is not a greater semver): still fails when plugin checks run.
- Version that is not a valid major.minor.patch semver when a bump is required: guard fails.
- Version bumped without regenerating: version guard may pass; drift check must still fail until
  regenerate.
- Comparison baseline unavailable (shallow clone, missing main): guard fails safely with a clear
  reason rather than silently skipping.
- Uncommitted covered-input edits with an unbumped version: version-bump guard fails when it runs;
  they must not be part of the excluded pre-bump suite's required set.
- Changes only to development-only paths that do not feed the plugin build: no bump phase.
- Feature already requires harness: harness green is a prerequisite before bump for that feature
  only.
- Feature does not require harness: finish order proceeds after excluded-suite green alone.
- Mid-feature regenerate for local or harness use is allowed and does not replace the closing
  bump → regenerate → plugin-check sequence.
- Regenerating before bumping in the closing sequence is incorrect: the closing regenerate MUST
  follow the bump so the package carries the new version.
- Changes only to plugin package output without changing sources: drift check already owns this.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: For every Spec Kit feature that changes covered plugin-build inputs, the closing
  finish order MUST be: (1) full quality suite excluding plugin generation–specific checks exits
  cleanly; (2) harness exits cleanly only if that feature already requires harness; (3) bump
  plugin source version to a strictly greater major.minor.patch than the comparison baseline;
  (4) regenerate the plugin package from current sources; (5) plugin generation–specific checks
  exit cleanly.
- **FR-002**: The comparison baseline MUST be the merge-base with the repository's default
  integration branch (`main`). The version-bump guard MUST compare that baseline to the current
  working tree and index, not only to committed branch tips.
- **FR-003**: Plugin-build inputs covered by the version-bump guard and final-phase rule MUST be
  exactly: the shipped skill tree, plus every plugin source file that regeneration copies or
  renders into the package (shared plugin identity/source metadata, agent listing inputs, README,
  license, and assets). Changing only the version field, with no other covered-input differences vs
  the baseline, MUST NOT require a further bump.
- **FR-004**: Plugin generation–specific checks MUST be a fixed, documented closed list that
  always includes the version-bump guard and the plugin package drift / generate-currency check
  (committed package matches a fresh build), and MUST include only those plus any other suite
  members explicitly listed on that list as package-currency checks (no open-ended “whatever would
  fail”). The suite MUST support running the full suite with that closed list excluded for the
  pre-bump step, and MUST support running that same list after bump and regenerate.
- **FR-005**: Highway-owned contributor documentation for the plugin build/release path MUST state
  the finish order in FR-001 and that public promote/publish is separate.
- **FR-006**: This feature MUST NOT require publishing or promoting to the public plugin
  repository as part of ordinary skill changes or as a Spec Kit exit for unrelated features.
- **FR-007**: When the version-bump guard cannot establish the comparison baseline, it MUST fail
  closed with an actionable message (not pass by skipping).
- **FR-008**: When a version bump is required, the guard MUST compare versions as semantic versions
  with three numeric components (major.minor.patch) and MUST accept only a strictly greater
  version than the baseline. Invalid or non-semver version strings MUST fail when a bump is
  required.
- **FR-009**: The Spec Kit development constitution (`.specify/memory/constitution.md`) MUST
  encode the finish order in FR-001 for covered-input features. This feature MUST NOT amend the
  Highway Skills Constitution or upstream Spec Kit skills/templates.
- **FR-010**: The version-bump guard MUST fail when covered plugin-build inputs in the current
  working tree differ from the comparison baseline and the plugin source version is not a strictly
  greater semver than the baseline's version.
- **FR-011**: This feature MUST NOT newly require a harness run as a prerequisite to the bump
  phase. Harness green is a prerequisite only when the Spec Kit feature already requires harness
  verification for its own exit.
- **FR-012**: In the closing sequence, bump MUST precede regenerate so the regenerated package
  carries the new version.

### Key Entities

- **Plugin source version**: The single authoritative version string for the Highway agent plugin
  package (major.minor.patch semver); carried into generated manifests on regenerate.
- **Comparison baseline**: The merge-base commit with `main` used to detect input changes and the
  prior version string; compared against the current working tree and index.
- **Plugin package**: The committed regenerated plugin tree consumed locally and used as the
  publish payload when promoting.
- **Plugin-build inputs**: The shipped skill tree plus every plugin source file regeneration
  copies or renders into the package (identity/source metadata, listing inputs, README, license,
  assets); version-only edits are exempt from triggering a required bump.
- **Plugin generation–specific checks**: A fixed closed list of suite members that enforce
  version bump and plugin package currency; always includes the version-bump guard and
  drift/generate check; may name only other explicitly listed package-currency checks; excluded
  from the pre-bump suite run and required after bump+regenerate.
- **Finish order**: Excluded full suite green → (harness green if already required) → bump →
  regenerate → plugin generation–specific checks green.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In 100% of runs of the version-bump guard where covered inputs changed vs the
  comparison baseline and the plugin version was not increased, the guard fails.
- **SC-002**: In 100% of runs of the plugin drift/generate check where the committed plugin
  package does not match a fresh build, that check fails.
- **SC-003**: A maintainer can confirm the finish order (exclude plugin checks → suite green →
  bump → regenerate → plugin checks; harness only if already required; promote separate) from
  Highway contributor docs and the Spec Kit development constitution in under two minutes without
  reading historical specs or the Highway Skills Constitution.
- **SC-004**: A covered-input feature can complete the excluded full suite cleanly before bump,
  then after bump and regenerate pass the plugin generation–specific checks, without requiring a
  public publish or a new harness mandate.

## Assumptions

- The repository's default integration branch is `main` and is available as the merge-base parent
  for feature work.
- Semver component choice (patch vs minor vs major) remains a maintainer judgment; the guard only
  requires a strictly greater major.minor.patch than the baseline.
- Public promote/publish and any future pipeline remain owned by existing publish capability
  (Phase 10 / feature 257); this feature only makes the finish order mandatory before feature
  close when inputs changed.
- Adapter copies and other legacy delivery trees, if still present, are out of scope unless they
  are already required to stay in sync by existing suite rules; this feature focuses on plugin
  version and plugin package regenerate.
- Current tree already has a bumped published version from recent maintenance; this feature does
  not re-publish as part of its exit.
- Spec Kit development constitution in this repository is Highway-amendable project law; Spec Kit
  product skills/templates remain owned upstream and are not updated here. The Highway Skills
  Constitution remains skill-contract law and is not the home for plugin package bump rules.
- The suite runner (or documented invocation) can exclude the fixed closed list of plugin
  generation–specific tests for the pre-bump run; exact flags, filenames, and any additional
  listed package-currency members beyond the two required checks are planning details.
- A general “always run harness before every feature closes” rule is out of scope until harness is
  implemented as that gate elsewhere.
