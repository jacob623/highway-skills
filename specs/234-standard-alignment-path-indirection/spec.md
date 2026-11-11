# Feature Specification: Standard Alignment Path Indirection

**Feature Branch**: `feature/std-alignment-phase5`

**Created**: 2026-11-11

**Status**: Complete

**Input**: User description: "create a new spec for implementing phase 5 of standard-alignment.md". Phase 5 (Path Indirection) prepares for the Phase 6 move. First it retires the tests whose only purpose is regression checking, so none is converted only to be deleted. Then every bash test and framework script finds the skills, the framework, the tests, the governance files, and each template through one paths helper. The harness reads the same locations, and a check fails when a script builds a path to one of those locations without the helper. Nothing moves in this phase. Exit: no regression-only test remains, every dropped assertion is accounted for, no test or framework script names a skill, tool, governance, or template path except through the helper, and the full suite passes.

## Clarifications

### Session 2026-11-11

- Q: Should the paths helper give each template and governance document its own lookup, or only declare the folders they sit in? → A: Per-file lookup by name for each output template and each governance and knowledge document; folders for skills, tools, tests, fixtures, catalog, instructions, and agent trees.
- Q: Should this phase also remove the exact skill and template version checks from the other tests, or only the Experience Standard and constitution version checks already listed? → A: Remove every exact skill and template version check in the suite (34 tests, about 90 checks), and record each one as superseded.
- Q: Should the new check that every script finds paths through the helper become a rule in the development constitution, or stay a plain suite test? → A: Add a D2 rule, "a script MUST get repository locations from the paths helper", enforced by the new test and listed in the Enforcement Map, with a MINOR bump to 3.1.0.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Retire the regression-only tests (Priority: P1)

A maintainer preparing to convert the suite no longer carries tests that only guard finished changes or check old evidence files. Those tests are removed, or reduced to the checks that still cover current behavior. No test pins an exact version of a skill, template, or governance document, so a version bump never fails a test by itself. Every assertion that leaves is either kept in a remaining test or recorded as superseded, naming the behavior it covered.

**Why this priority**: The conversion in User Story 2 touches nearly every test. Retiring these first means none of them is converted and then deleted, and the conversion count is final before it starts.

**Independent Test**: Confirm the removed tests and their single-use fixtures are gone, read the record of dropped assertions, and run the full suite.

**Acceptance Scenarios**:

1. **Given** the suite after this change, **When** a maintainer lists the tests, **Then** `profile-yaml`, `path-integrity`, `feature-092-correspondence`, `profile-adaptive`, and `runtime-contract-hygiene` are gone, with the three fixture files only they read: the Feature 092 dependent-artifact inventory, the Feature 092 impact review, and the Feature 091 adaptive corpus.
2. **Given** the three Experience Standard tests (`experience-standard-amendment`, `feature-141-experience-standard-refactor`, `experience-standard-convergence`), **When** a maintainer reads what remains, **Then** each current check appears in exactly one test, and the protected-path check that can never fail is gone.
3. **Given** `profile-template-migration` and `constitution-experience-alignment`, **When** a maintainer reads them, **Then** neither checks that an obsolete template or removed text stays absent, and neither pins an exact version line. A test left with no assertion is removed.
4. **Given** the record of dropped assertions, **When** a reviewer compares it with the removed and reduced tests, **Then** every dropped assertion is listed as kept elsewhere, naming the test, or as superseded, naming the behavior it covered.
5. **Given** the Highway Skills Constitution, the Experience Standard, any skill, or any output template, **When** a maintainer changes its version, **Then** no bash test fails only because of the new version number. The validator's own version checks, a well-formed version and an Example that matches the frontmatter, still apply.
6. **Given** the 34 tests that check an exact skill or template version today, **When** a maintainer reads them after this change, **Then** none checks an exact version, and each removed check is listed in the dropped-assertion record as superseded.

---

### User Story 2 - Find every location through one paths helper (Priority: P1)

A maintainer who moves the skills, the framework, the tests, a governance file, or a template changes where that location is declared once, and every bash test and framework script follows. Today almost every test builds its own paths: 87 of the 88 tests derive a root themselves, 44 name the skills folder, 34 name the tools folder, and 31 name the templates folder.

**Why this priority**: Phase 6 moves the framework, the tests, and the skills. Without one declaration, that move edits every test by hand, and the test edits are mixed into the move.

**Independent Test**: Point the helper at a different location for one category in a disposable copy of the repository, run the affected tests against that copy, and confirm they follow the helper. Then run the full suite on the real tree.

**Acceptance Scenarios**:

1. **Given** the paths helper, **When** a maintainer reads it, **Then** it declares, once each, the folders for the repository root, the skills, the framework tools and their shared helpers, the tests and their fixtures, the catalog, the always-on instructions, and each agent copy tree, and it declares each output template and each governance and knowledge document individually, by name.
2. **Given** any bash test or framework script, **When** it needs one of those locations, **Then** it gets it from the helper rather than combining a root with a folder or file name itself. A test that opens a specific template or governance document asks for that document by name.
3. **Given** a disposable copy in which one output template is moved to another folder and only its declaration in the helper is changed, **When** the tests that open that template run against the copy, **Then** they find it with no other edit.
4. **Given** a test that builds a disposable copy of the tree, **When** it needs a location inside that copy, **Then** it asks the helper for the location relative to the copy, so the copy follows the same declaration.
5. **Given** the distribution built from the repository, **When** its own validator runs with the development folders absent, **Then** the helper it ships with resolves every location the validator needs, and the packaged tree validates.
6. **Given** the helper's declaration of the skills location is changed in a disposable copy and the skills folder is moved to match, **When** the skill validator, the catalog generator, and a sample of tests run against the copy, **Then** they find the skills at the new location with no other edit.

---

### User Story 3 - The harness reads the same locations (Priority: P2)

A maintainer who runs the behavioral harness gets scenarios selected from the same locations the bash suite uses. The harness's path map and its helper scripts take the skills, templates, governance, and instructions locations from the paths helper, and the harness no longer names the skills folder itself when it lists changed skills.

**Why this priority**: The harness selects scenarios by path. If it keeps its own copy of the layout, Phase 6 breaks scenario selection silently.

**Independent Test**: Run the harness path-map test and the harness TypeScript tests, then change the skills location in a disposable copy as in User Story 2 and confirm the path map classifies a skill file at the new location.

**Acceptance Scenarios**:

1. **Given** the harness path map and its helper scripts, **When** a maintainer reads them, **Then** each takes the repository locations from the paths helper.
2. **Given** the harness's changed-skill listing, **When** it lists the skills changed since a reference, **Then** it uses the skills location supplied by the path map rather than a folder name of its own.
3. **Given** the harness selection list of shared files, **When** the path map reads it, **Then** every path it names still exists and still selects the same scenarios as before this change.

---

### User Story 4 - A check keeps paths going through the helper (Priority: P2)

A maintainer who adds a test or script that builds a path to a skill, tool, governance file, or template on its own sees the suite fail and name the file and line, so the indirection cannot erode before Phase 6. The obligation is a rule in the development constitution, so weakening the check needs the same recorded reason as any other constitutional check.

**Why this priority**: Without the check, a single new test written the old way breaks the Phase 6 move. The check is cheap once the conversion is done.

**Independent Test**: Add a disposable test that builds a skills path from a root variable, run the check, and confirm it fails and names that file and line. Remove it and confirm the check passes.

**Acceptance Scenarios**:

1. **Given** the converted suite, **When** the check runs, **Then** it passes.
2. **Given** a test or framework script that combines a root with a skills, tools, governance, library, catalog, instructions, or tests folder name, **When** the check runs, **Then** it fails and names the file and line.
3. **Given** the paths helper itself, **When** the check runs, **Then** it is the one file allowed to name those folders.
4. **Given** the check, **When** it is registered, **Then** it declares the artifact classes it covers and can be seeded to fail for each of them, like every other registered check.
5. **Given** the development constitution, **When** a maintainer reads Principle II, **Then** a new D2 rule requires scripts to get repository locations from the paths helper, the Enforcement Map names the new check as the test that decides it, the Toolchain Gate evaluates it, and the version is 3.1.0 with the amendment recorded.

---

### Edge Cases

- A test asserts that a document mentions a path, for example that highway-help's Inputs name the skill catalog file. That is a check on document text, not a path the test opens, so it stays a literal. It changes when the document changes.
- A test passes repository-relative paths as inputs to the harness path map and checks how each is classified. Those inputs are data under test, not locations the test opens, so they stay literal. Phase 6 updates them with the layout.
- A test fixture's content names a path, for example a Profile fixture or a scenario file. Fixture content is data, not path construction, and is out of scope for the check.
- A test builds a disposable copy of the tree by copying the whole framework folder. The copy keeps the current layout, and the test resolves locations inside it through the helper (User Story 2, scenario 3).
- A framework script ships in the distribution today. The helper ships with it and resolves locations relative to its own position, so it works in a tree that is not a repository and has no development folders.
- A removed regression test also covered something current. That check moves to a remaining test before the removal. Nothing is dropped silently.
- An Experience Standard check is duplicated across three tests. Exactly one copy is kept; the duplicates are recorded as consolidated, not superseded.
- A message printed by a test names a path, for example "catalog/index.json is stale". Output text is not path construction and stays as written.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The suite MUST NOT contain `profile-yaml.test.sh`, `path-integrity.test.sh`, `feature-092-correspondence.test.sh`, `profile-adaptive.test.sh`, or `runtime-contract-hygiene.test.sh`, nor the fixtures `profile-092/dependent-artifact-inventory.tsv`, `profile-092/impact-review.tsv`, and `profile-091/adaptive-corpus.md`. Any fixture document that lists those files MUST stop listing them.
- **FR-002**: `profile-template-migration.test.sh` and `constitution-experience-alignment.test.sh` MUST NOT check that an obsolete template or removed text stays absent, and MUST NOT pin an exact version line. A test left with no assertion MUST be removed.
- **FR-003**: The Experience Standard tests MUST keep each current check in exactly one test and MUST NOT contain the protected-path check. No bash test MUST check an exact version of a skill, an output template, the Highway Skills Constitution, or the Experience Standard. Checks that a version is well formed, or that two values in the same file agree, stay.
- **FR-004**: Every dropped assertion MUST be recorded as kept, naming the remaining test that holds it, or as superseded, naming the behavior it covered. The `FR-` and `Feature NNN` history scan of highway-profile and highway-setup is recorded as superseded; its `specs/` and `.specify/` scan is kept by `shipped-tree-independence.test.sh`.
- **FR-005**: The repository MUST have one paths helper. It MUST declare the folders for the repository root, the skills, the framework tools, the framework's shared helpers, the tests, the test fixtures, the catalog, the always-on instructions, and each agent copy tree. It MUST declare each output template and each governance and knowledge document individually, and return any of them by name, so a later phase can move one file by changing one declaration.
- **FR-006**: The helper MUST resolve every location relative to its own position, and MUST accept an alternate root so a caller can resolve the same locations inside a disposable copy of the tree.
- **FR-007**: Every bash test and every framework script MUST obtain each location in FR-005 from the helper.
- **FR-008**: The helper MUST run under the declared shell and toolchain, MUST NOT name a development-only location, and MUST ship with the framework scripts that use it, so the packaged tree validates with the development folders absent.
- **FR-009**: The harness path map and the harness helper scripts MUST take repository locations from the paths helper, and the harness's changed-skill listing MUST use the skills location the path map supplies.
- **FR-010**: A registered bash check MUST fail, naming the file and line, when a bash test, framework script, or harness helper script outside the paths helper combines a root with a folder name the helper declares. It MUST declare its artifact classes and fail when seeded for each.
- **FR-011**: Text a test checks inside a document, paths passed as data to the path map, fixture content, and printed messages MUST NOT be treated as path construction by the check.
- **FR-012**: No file, folder, skill, or generated artifact MUST move or change content beyond what FR-001 to FR-014 require. Regenerating every generator MUST leave no diff.
- **FR-013**: The tools README and the root README MUST describe the helper where they describe how scripts and tests find files, in the same change.
- **FR-014**: The development constitution MUST add a D2 rule, tier `[auto]`, requiring a bash test, framework script, or harness helper script to get repository locations from the paths helper. The Enforcement Map MUST name the check in FR-010 as its enforcing test, the Toolchain Gate MUST evaluate the new rule, and the amendment MUST be a MINOR bump from 3.0.0 to 3.1.0, recorded with its self-application review.
- **FR-015**: The full bash suite and the harness TypeScript tests MUST pass before the first edit and after the last.

### Key Entities

- **Paths helper**: the single declaration of where each repository location lives, resolved from the helper's own position or from an alternate root.
- **Location**: a named place the framework or the suite reads or writes. A folder location covers the root, skills, tools, shared helpers, tests, fixtures, catalog, instructions, or an agent copy tree. A file location covers one output template, or one governance or knowledge document, each looked up by name.
- **Regression-only test**: a test whose every assertion guards a finished change or checks a past feature's evidence file, rather than current behavior.
- **Dropped-assertion record**: the list of every assertion that leaves with a removed or reduced test, each marked kept (with the test that holds it), consolidated (with the one test that keeps the shared check), or superseded (with the behavior it covered).
- **Path construction check**: the registered check that keeps every location going through the helper, and the test that decides the new D2 rule in the development constitution.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 5 regression-only tests and 3 single-use fixture files are removed, and every dropped assertion appears in the dropped-assertion record: 100% accounted for.
- **SC-002**: 0 bash tests fail because the version number of a governance document, a skill, or an output template changed, and 0 of the about 90 exact version checks found today remain.
- **SC-003**: 0 bash tests, framework scripts, or harness helper scripts outside the paths helper combine a root with a declared folder name, as reported by the path construction check.
- **SC-004**: Changing one location in the paths helper, in a disposable copy with that folder or file moved to match, requires 0 edits to any other file for the skill validator, the catalog generator, and the converted tests that read that location. This holds for the skills folder and for one output template.
- **SC-005**: The full bash suite and the harness TypeScript tests pass, and the packaged distribution validates.
- **SC-006**: Every declared generator, run after the change, leaves 0 bytes of difference against the committed artifacts.

## Assumptions

- Phase 4 is complete (spec 233). The suite starts at 88 tests.
- Nothing moves in this phase. Phase 6 moves the framework, the tests, and the skills, and updates the helper's declarations.
- The helper ships while framework scripts ship. Phase 14 stops shipping the framework, and the helper goes with it.
- Checks on document text, path-map inputs, fixture content, and printed messages keep their literal paths. Phase 6 updates those that name a moved location.
- The harness TypeScript sources keep their own location for the harness folder; only the repository locations they need come from the path map.
- The record of dropped assertions lives in this feature's planning documents, as Phase 4's did.
