# Feature Specification: Publish and Public Install

**Feature Branch**: `257-publish-public-install`

**Created**: 2026-11-20

**Status**: Draft

**Input**: User description: "create a new spec for implement phase 10"

Rollout-plan Phase 10: make the public Highway plugin real and installable — permanent public
repository URL in every shipped place, publish the built plugin as the root of
`https://github.com/highway-systems/agent-plugin`, generated marketplace catalogs and public
install documentation, public-install verification on the agents that already have harness
drivers, then stop directing new users at any legacy non-plugin install path. Official directory
submissions stay Phase 11 (manual) and do not gate this feature. Retiring per-agent adapters and
the distribution generators stays Phase 9 and is out of scope here.

## Clarifications

### Session 2026-11-20

- Q: After a release, must the public-install smoke installs use a fixed published ref (release tag
  or exact commit), or is installing from the repository’s default branch tip enough to complete
  this feature? → A: Pin a release tag or exact commit that matches the build under test.
- Q: For the first successful publish in this feature, must the plugin version be bumped above
  today's `0.1.0`, or may the first publish ship `0.1.0` and only require a bump on later
  releases? → A: First publish may keep `0.1.0`; later releases must bump.
- Q: While Phase 9 has not yet removed adapters and the distribution, should development
  documentation still describe those paths for contributors, or should all install guidance for
  getting Highway onto an agent point only at the public plugin repository? → A: End-user install
  docs are public-plugin only; contributor docs may still mention adapters/distribution as
  internal build machinery until Phase 9.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Every shipped place names the permanent public repository (Priority: P1)

A maintainer updates the single source of the plugin's repository URL to
`https://github.com/highway-systems/agent-plugin`. After regeneration, every shipped manifest and
install document that tells a person where to get Highway names that URL. The private development
repository may keep its own origin on `jacob623/highway-skills`; only the plugin install and
publish identity change. A guard fails if any shipped or development file still presents
`jacob623/highway-skills` as the plugin install URL (historical specs and findings excepted).

**Why this priority**: Publishing with the old URL would ship false identity; install docs would
point people at the wrong place.

**Independent Test**: Change the source URL, regenerate, search the tree for the old install URL,
and confirm only allowed historical paths remain.

**Acceptance Scenarios**:

1. **Given** the plugin source identity, **When** it is read after this feature, **Then** its
   repository field is `https://github.com/highway-systems/agent-plugin` and its homepage remains
   `https://www.highway.systems`.
2. **Given** a fresh plugin build, **When** each shipped agent manifest is read, **Then** each
   carries that same repository URL where the format includes one.
3. **Given** the public-facing install documentation in the plugin package, **When** a person
   follows it, **Then** every install example names `highway-systems/agent-plugin` (or the full
   HTTPS URL), not `jacob623/highway-skills`.
4. **Given** the development tree after this feature, **When** the URL guard runs, **Then** it
   fails if any shipped or development file (outside historical specs and findings) still names
   `jacob623/highway-skills` as the plugin install URL.

---

### User Story 2 - One release publishes the plugin as the public repository root (Priority: P1)

A maintainer runs one release action. The public repository's root becomes exactly the contents of
a fresh plugin build (manifests, skills, license, README, assets, marketplace catalogs) — not a
nested `highway-agent-plugin/` folder. The push is one-way: the public repository is not edited by
hand. The release refuses to publish when the staged tree differs from a fresh build, when it
references private development paths such as `specs/` or `.specify/`, or when a secret scan finds
anything. Version lives in one source place and is carried into every generated manifest. The
first successful publish may ship the current `0.1.0`; every later release must bump that source
version before publish.

**Why this priority**: Without a trustworthy publish path, marketplaces and users cannot install
from the public repository.

**Independent Test**: Run a release against a clean build and confirm the public root matches the
local build byte for byte; then seed each refusal condition and confirm the release stops.

**Acceptance Scenarios**:

1. **Given** a fresh plugin build, **When** the release completes, **Then** the public repository
   root matches that build byte for byte (plugin package at root, including marketplace catalogs
   this feature adds).
2. **Given** a staged tree that differs from a fresh build, **When** release is attempted, **Then**
   it fails and does not update the public repository.
3. **Given** a staged tree that references `specs/` or `.specify/`, **When** release is attempted,
   **Then** it fails and does not update the public repository.
4. **Given** a staged tree that fails the secret scan, **When** release is attempted, **Then** it
   fails and does not update the public repository.
5. **Given** the first successful publish with source version still `0.1.0`, **When** the public
   manifests are read, **Then** they show `0.1.0` from the single source field.
6. **Given** a later release after the first publish, **When** it completes, **Then** the source
   version was bumped above the previously published version and every generated manifest that
   carries version shows that new value.

---

### User Story 3 - Marketplace catalogs and install docs ship with the public plugin (Priority: P1)

The public package includes generated marketplace catalogs at the repository root so Cursor,
Claude, Codex/agents, and Copilot can add the marketplace with `source: "./"`. Antigravity and
Gemini need no catalog; their install docs say to install from the repository URL with their own
commands. The public README gives one install section per agent this feature claims, plus known
limits for modes that exist today. Catalogs are generated from the same source as other plugin
metadata and fail the drift check when hand-edited.

**Why this priority**: Catalogs and README are how people and agents discover and install Highway
from the public repository without waiting on official directory acceptance (Phase 11).

**Independent Test**: Inspect the built/public root for the catalogs and README sections; hand-edit
a catalog and confirm the drift check fails.

**Acceptance Scenarios**:

1. **Given** a fresh plugin build after this feature, **When** the root is listed, **Then** it
   holds marketplace catalogs for Cursor, Claude, Codex/agents, and Copilot, each listing Highway
   with source at the plugin root (`"./"`).
2. **Given** those catalogs, **When** the drift check runs on a hand edit, **Then** the check
   fails and names the file.
3. **Given** the public README, **When** a new user opens it, **Then** they find an install
   section for each of Copilot, Cursor, Claude Code, and Codex that uses the public repository,
   and Antigravity/Gemini sections that use the repository URL without requiring a catalog.
4. **Given** the public README, **When** known limits are read, **Then** they describe Local-mode
   storage limits that apply today and do not claim Remote or Chat support that is not yet
   shipped.

---

### User Story 4 - Maintainers verify install from the public repository (Priority: P2)

After a release, a maintainer can run the harness so each attempt installs Highway from the
published public repository instead of the local build, pinned to a release tag or exact commit
that matches the build under test (not the moving default-branch tip). Local-build install remains
the default for day-to-day development. For this feature's exit, a public-install smoke run passes
on each agent that already has a harness driver: Copilot, Cursor, Claude Code, and Codex.
Antigravity and Gemini join later when their drivers exist. Install or load failures block this
feature; skill-behavior failures are recorded as findings and do not block.

**Why this priority**: Proof that what users install matches what we ship.

**Independent Test**: Run one public-install smoke per shipped driver; confirm each attempt
installed from the public source and reported all skills; match any skill-behavior failure to a
finding.

**Acceptance Scenarios**:

1. **Given** the harness, **When** a maintainer selects public plugin source with a release tag or
   exact commit, **Then** each attempt installs from that pinned ref of
   `highway-systems/agent-plugin`, not from the local build folder or an unpinned default branch.
2. **Given** no public-source selection, **When** the harness runs, **Then** attempts still
   install from the local build as today.
3. **Given** a public-install smoke on Copilot, Cursor, Claude Code, and Codex after release,
   **When** each run ends, **Then** every attempt installed the plugin with all Highway skills
   from the pinned ref, and any install or load failure is fixed before this feature is complete.
4. **Given** a skill-behavior failure in those runs, **When** findings are reviewed, **Then** it
   is matched to an existing or new finding with a proposed resolution and does not by itself
   block completion.

---

### User Story 5 - New users install without a legacy installer path (Priority: P2)

Once the four agents above install cleanly from the public repository, end-user install
documentation (the public README and any guidance aimed at people getting Highway onto an agent)
points only at the public plugin repository — not a legacy executable, and not adapters or the
distribution as an install path. Contributor documentation in the private monorepo may still
describe adapters and the distribution as internal build machinery until Phase 9 removes them.
`highway-setup` in a project after a public install remains the way to prepare the repository.

**Why this priority**: Phase 10's exit is that a new user gets Highway from the public plugin
repository without an executable.

**Independent Test**: Review end-user install docs for those four agents; confirm only the public
plugin path is required. Confirm contributor docs may still mention adapters/distribution without
presenting them as the end-user install.

**Acceptance Scenarios**:

1. **Given** end-user install documentation for Copilot, Cursor, Claude Code, and Codex, **When**
   a new user follows it, **Then** the only required install path is the public plugin repository
   (or an agent's marketplace entry that points at it).
2. **Given** a project with the plugin installed from the public repository, **When** the user
   runs `highway-setup`, **Then** setup can prepare the project as it does today under Local mode.
3. **Given** this feature is complete, **When** end-user getting-started docs are read, **Then**
   they do not require a Highway executable or adapters/distribution as the install path for those
   four agents.
4. **Given** contributor documentation in the private monorepo, **When** Phase 9 has not run,
   **Then** it may still describe adapters and the distribution as internal build machinery.

---

### Edge Cases

- The public repository already holds an older manual copy. The first automated release replaces
  the root with a fresh build and records how history was reconciled.
- Auth for pushing to `highway-systems/agent-plugin` differs from the private monorepo's
  credentials; a release fails clearly when those credentials are missing or refused.
- A marketplace catalog format rejects a field. The generator source is fixed; generated files are
  not hand-edited.
- Public-install smoke MUST fail to start (or refuse the public source) when no release tag or
  exact commit is supplied; an unpinned default-branch tip is not enough for this feature's exit.
- Antigravity or Gemini public install is documented but not required for this feature's exit.
- Official directory submissions (Cursor Marketplace, Claude directory, and similar) are out of
  scope; failure or delay there does not block this feature.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The plugin's single source of repository identity MUST be
  `https://github.com/highway-systems/agent-plugin`, with homepage remaining
  `https://www.highway.systems`.
- **FR-002**: Regeneration MUST carry that repository URL into every shipped manifest that
  includes a repository field.
- **FR-003**: End-user install documentation (public README and any guidance for getting Highway
  onto an agent) MUST name `highway-systems/agent-plugin` (or its HTTPS URL), not
  `jacob623/highway-skills`, and MUST NOT present adapters or the distribution as the install path.
- **FR-004**: A check MUST fail when shipped or development files (excluding historical specs and
  findings) still present `jacob623/highway-skills` as the plugin install URL.
- **FR-005**: A release MUST publish the fresh plugin build as the public repository root (package
  contents at root, not nested under a `highway-agent-plugin/` directory).
- **FR-006**: A release MUST be one-way: maintainers MUST NOT rely on hand edits in the public
  repository as the source of truth.
- **FR-007**: A release MUST refuse to publish when the staged tree differs from a fresh build,
  references private development paths (`specs/`, `.specify/`), or fails a secret scan.
- **FR-008**: Plugin version MUST live in one source field; generated manifests MUST carry that
  version. The first successful publish MAY keep `0.1.0`. Every later release MUST bump the source
  version above the previously published version before publish.
- **FR-009**: The published package MUST include generated marketplace catalogs for Cursor,
  Claude, Codex/agents, and Copilot, each listing Highway with source at the plugin root.
- **FR-010**: Marketplace catalogs MUST be generated and drift-checked; hand edits MUST fail the
  check.
- **FR-011**: The public README MUST include an install section per agent this feature claims
  (Copilot, Cursor, Claude Code, Codex, plus Antigravity and Gemini via repository URL) and known
  limits that do not over-claim unshipped storage modes.
- **FR-012**: The harness MUST support installing from the public repository for verification,
  while keeping local-build install as the default.
- **FR-018**: Public-install verification for this feature's exit MUST pin a release tag or exact
  commit that matches the build under test; installing from an unpinned default-branch tip MUST
  NOT satisfy the exit.
- **FR-013**: This feature MUST complete public-install smoke on Copilot, Cursor, Claude Code, and
  Codex after a successful release, with install/load failures blocking completion.
- **FR-014**: Skill-behavior failures in those smokes MUST be recorded as findings with a proposed
  resolution and MUST NOT alone block completion.
- **FR-015**: After those four agents install cleanly from the public repository, end-user
  documentation MUST NOT require a Highway executable or other legacy non-plugin installer for
  them.
- **FR-016**: Official plugin-directory submissions MUST remain out of scope (Phase 11).
- **FR-017**: Removing per-agent adapter copies and distribution generators MUST remain out of
  scope (Phase 9).
- **FR-019**: Contributor documentation in the private monorepo MAY still describe adapters and
  the distribution as internal build machinery until Phase 9; that MUST NOT count as an end-user
  install path under FR-003 or FR-015.

### Key Entities

- **Public plugin repository**: `https://github.com/highway-systems/agent-plugin` — root is the
  installable plugin package.
- **Plugin build**: The local package whose contents are published as that root.
- **Marketplace catalog**: Generated listing file at the package root that points an agent at
  Highway with source `"./"`.
- **Public-install verification**: Harness runs that install from the published repository rather
  than the local build.
- **Legacy install path**: Any prior executable or non-plugin installer path that new users were
  told to use for the four agents above.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A search of shipped and development install identity finds zero remaining
  `jacob623/highway-skills` plugin-install references outside historical specs and findings.
- **SC-002**: After one release, the public repository root matches the local plugin build with no
  file differences.
- **SC-003**: A new user can install Highway on Copilot, Cursor, Claude Code, and Codex using only
  the public repository (or a marketplace entry that points at it), without an executable, in one
  documented pass per agent.
- **SC-004**: Public-install smoke on each of those four agents reports every attempt installing
  the full Highway skill set from a pinned public ref (release tag or exact commit).
- **SC-005**: A maintainer can still run day-to-day harness smokes from the local build without
  selecting the public source.
- **SC-006**: Hand-editing a generated marketplace catalog causes the project's drift check to
  fail before the next release.

## Assumptions

- The public repository `highway-systems/agent-plugin` already exists and is empty or holds only
  material safe to replace with the automated publish.
- Maintainers have separate credentials for `highway-systems` and will configure them outside this
  specification.
- Phase 9 (retire adapters and distribution) is not required to complete this feature; the private
  monorepo may still generate adapters. This feature only changes plugin identity, publish, public
  install docs/catalogs, verification, and retirement of the end-user legacy install path for the
  four agents with drivers today. Contributor docs may still document adapters/distribution as
  internal until Phase 9.
- Phase 11 official directory listings do not block this feature.
- Antigravity and Gemini drivers are not required for exit; their README install-via-URL sections
  are enough until those drivers exist.
- Storage modes Remote and Chat are not claimed as supported in public limits until those rollout
  phases ship.
- "Executable" means any legacy Highway installer or downloadable program path still advertised for
  getting skills onto an agent; if none remains in docs beyond the distribution/adapters story, FR-015
  is satisfied by documenting plugin-repo install only and removing any leftover executable
  instructions.
- Reconciling prior manual copies on the public repository is part of the first successful release,
  not a separate product feature.
- Today's plugin source version is `0.1.0` and has not been published through the automated path
  yet, so keeping `0.1.0` on the first publish is intentional.
