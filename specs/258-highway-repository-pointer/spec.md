# Feature Specification: Highway Repository Pointer

**Feature Branch**: `258-highway-repository-pointer`

**Created**: 2026-11-21

**Status**: Draft

**Input**: User description: "create a new spec to implement phase 15". Phase 15 in `rollout-plan.md`: people run Highway skills from a code or business project that is not the Highway knowledge repository by pointing at an existing Highway working tree and recording a portable git URL for teammates. `highway-experience` alone resolves an effective Highway knowledge root, runs a not-ready gate (setup or pointer), and owns pointer persistence so owning skills do not each reimplement that logic. Paths stay relative to the effective root. Local mode stays file tools. No Remote/Chat implementation, no Highway storage MCP, no new resolution skill. Leaves room for Phase 16 code targets by keeping pointer files knowledge-only.

## Clarifications

### Session 2026-11-21

- Q: When someone supplies a local folder path for Highway knowledge, must that folder already be a Highway knowledge root? → A: Yes — path must already be a Highway knowledge root (readable Profile or storage record); otherwise reject and ask again or offer setup in the open project.
- Q: After a successful bind during the not-ready gate, should the same skill invocation continue? → A: Yes — same invocation continues; experience returns ready; owning skill proceeds against the effective knowledge root.
- Q: If the person chooses set up Highway in this project from the not-ready gate, should experience stop or start setup? → A: Stop not-ready; tell the person to run `highway-setup` (no setup orchestration inside the current skill).
- Q: If the person already invoked `highway-setup` and chooses set up in this project from the gate? → A: Exception — when the activating skill is `highway-setup`, choosing setup continues setup on the open project.
- Q: Pointer path names vs self-contained-skills (no `.highway` outside code products)? → A: Use `hw-repository.md` and `hw-repository.local.md` at the open project root (not under `.highway/`).

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Experience resolves the Highway knowledge root before any other skill work (Priority: P1)

A person opens a product or business project and runs a Highway skill. Before that skill asks questions or writes records, Highway determines which working tree holds organizational knowledge. If a local pointer names a readable Highway checkout, work uses that tree. If the open project itself is already a Highway knowledge root, work uses the open project. Otherwise the person is not silently set up in the wrong tree.

**Why this priority**: Without a single resolved knowledge root, every other story either seeds the wrong project or cannot find Highway records.

**Independent Test**: Open a non-Highway project with a local pointer to a second tree that already has Highway knowledge. Run a skill that would read Profile or a catalog. Confirm reads and writes hit the pointed tree, not the open project.

**Acceptance Scenarios**:

1. **Given** an open project that is not a Highway knowledge root and a local pointer to a directory that is already a Highway knowledge root, **When** any Highway skill that activates experience runs, **Then** the effective knowledge root for that run is the pointed checkout, and storage paths are interpreted relative to that root.
2. **Given** an open project that already is a Highway knowledge root and no local pointer, **When** a Highway skill runs, **Then** the effective knowledge root is the open project (today's behavior).
3. **Given** an open project with neither a usable local pointer nor Highway knowledge markers, **When** a Highway skill runs, **Then** experience stops before the owning skill writes Highway catalogs into the open project.
4. **Given** a resolved effective knowledge root, **When** the mode record is read, **Then** it is read under that root (`library/knowledge/storage.md`), not under an unrelated open project.

---

### User Story 2 - One shared gate: set up here or point at an existing Highway project (Priority: P1)

A person runs a Highway skill in a project that is not ready for Highway work and has no usable pointer. Instead of only being told to run setup, they are offered either to run `highway-setup` in this project or to provide a folder path and/or git repository URL for an existing Highway knowledge project. The same wording comes from experience for every skill, not from each skill's private stop message.

**Why this priority**: This is the user-visible fix for multi-project use and removes duplicated per-skill setup-only stops.

**Independent Test**: From a clean non-Highway project, invoke two different owning skills (for example request and onboarding). Confirm both surface the same dual offer via experience and neither emits the old setup-only stop on its own.

**Acceptance Scenarios**:

1. **Given** no effective Highway knowledge root can be established, **When** experience runs the not-ready gate, **Then** the person is offered either `highway-setup` in this project or providing a folder path and/or git URL for an existing Highway knowledge project.
2. **Given** the person chooses setup from the gate while running a skill other than `highway-setup`, **When** experience handles that choice, **Then** experience returns not-ready, names `highway-setup` as the next action, does not orchestrate setup inside the current skill, and the current skill writes nothing.
3. **Given** the person invoked `highway-setup` and chooses setup in this project from the not-ready gate, **When** experience handles that choice, **Then** experience returns ready with the open project as the effective knowledge root for this setup run, and setup continues in the same invocation (seeds or revises this tree).
4. **Given** every owning skill that previously embedded its own "run highway-setup" stop, **When** those skills are reviewed after this change, **Then** none re-offers setup-or-pointer or the old setup-only gate; each stops writing when experience returned not-ready.
5. **Given** experience owns the gate copy, **When** the gate message is changed in its single shared asset, **Then** no owning skill must be edited to keep the wording consistent.
6. **Given** the person successfully binds a valid Highway knowledge path during the not-ready gate (with or without persisting pointers), **When** experience finishes that bind, **Then** the same skill invocation continues: experience returns ready and the owning skill proceeds against the effective knowledge root (no mandatory re-run).

---

### User Story 3 - Persist a portable URL and a personal local path (Priority: P1)

A person provides a path and optionally a git URL for their existing Highway knowledge project. Experience asks whether to store references in the open project. The git URL can be saved as a committed pointer teammates share. The folder path can be saved as a personal local pointer and listed in `.gitignore` so absolute paths are not committed. Later runs in that open project reuse the local path without asking again while it remains readable.

**Why this priority**: Persistence is what makes multi-project use stick across sessions and teammates without committing machine-specific paths.

**Independent Test**: From a non-Highway open project, complete the gate with a path and URL, accept persistence and gitignore. Confirm the two pointer files and ignore entry. Re-run a skill and confirm no re-prompt while the path is readable.

**Acceptance Scenarios**:

1. **Given** the person provides a folder path that is already a Highway knowledge root and accepts storing it, **When** experience persists the local pointer, **Then** the open project gains `hw-repository.local.md` naming that path, and `hw-repository.local.md` is listed in `.gitignore` when the person accepts the ignore update (creating or appending as needed when they agree).
2. **Given** the person provides a git repository URL and accepts storing it for the team, **When** experience persists the committed pointer, **Then** the open project gains `hw-repository.md` naming that URL, and the file is intended to be committed (not gitignored by this feature).
3. **Given** a valid local pointer already present, **When** a later skill run activates experience, **Then** experience does not re-ask for the path while that path remains a readable directory.
4. **Given** the person provides only a git URL (no local path), **When** experience handles persistence, **Then** it may write the committed URL pointer, does not invent a clone, and does not treat the URL as a Local working tree for reads and writes.
5. **Given** only a committed URL pointer exists (no usable local path) and the open project is not itself a Highway knowledge root, **When** a skill runs, **Then** experience stops with guidance to open or clone that repository and set a local path pointer (or use Remote/Chat when those modes exist later), and does not write Highway catalogs into the open project as if it were the knowledge root.

---

### User Story 4 - Pointer files are knowledge-only and leave room for external code targets (Priority: P2)

Maintainers and later phases can tell Highway knowledge pointers apart from future product-code locations. The files `hw-repository.md` and `hw-repository.local.md` always mean where Highway knowledge lives. Product or codify code repositories are not stored in those files.

**Why this priority**: Protects Phase 16 and avoids overloading the only pointer namespace.

**Independent Test**: Read the storage contract and experience procedure after the change and confirm knowledge-only naming and an explicit non-use for product code locations.

**Acceptance Scenarios**:

1. **Given** the storage contract after this feature, **When** pointer files are described, **Then** they are defined only as the Highway knowledge repository identity and local checkout path.
2. **Given** those pointer file names, **When** a later external code-target feature is planned, **Then** it can introduce separate committed and local artifacts without redefining `hw-repository.md` or `hw-repository.local.md`.

---

### User Story 5 - Absent pointers keep today's single-tree behavior (Priority: P2)

A person who only ever works inside their Highway knowledge repository sees no new required ceremony. With no pointer files, the open project remains the knowledge root when it already has Highway knowledge, and the suite and day-to-day Local flows still pass.

**Why this priority**: Must not break the default single-repo path while adding multi-project support.

**Independent Test**: Run the full automated suite with no pointer files in fixtures that already model a Highway root; confirm pass. Manually run a skill inside an existing Highway knowledge project with no `.highway/repository*` files and confirm work proceeds without the dual gate.

**Acceptance Scenarios**:

1. **Given** an open Highway knowledge root and no pointer files, **When** skills run, **Then** behavior matches pre-change Local use of the open project as the repository root.
2. **Given** the automated suite after this feature, **When** it runs with fixtures that do not use pointers, **Then** the suite passes.

---

### Edge Cases

- Local pointer path missing, not a readable directory, or readable but not a Highway knowledge root (no Profile or storage record): experience rejects that path, does not use it as the effective root, does not fall back to treating the open non-Highway project as the knowledge root, and asks again or offers setup in the open project.
- Person declines to persist pointers after providing a valid knowledge-root path for this run: the run may use that path as the ephemeral effective root for this invocation once accepted; no pointer files are written.
- Person provides a path but declines gitignore: local pointer is not written unless ignore handling is accepted, so machine paths are not left unignored by default (safer default).
- Committed URL pointer present and local pointer present: local path wins for Local effective root; URL remains the shared identity for teammates and later Remote/Chat.
- Open project is a Highway knowledge root **and** a local pointer exists: local pointer wins (explicit override).
- Slash-command invocations and git URLs in messages are not treated as storage-operation absolute paths.
- Direct invocation of `highway-experience` for a summary of Highway: still does not start the repository gate workflow beyond what its direct-invocation procedure already allows (no new setup tour).
- `highway-setup` invoked directly in a non-Highway open project: experience may show the dual gate (so the person can bind an existing knowledge root instead). Choosing setup here continues setup with effective root = open project. Choosing a valid path bind continues setup against that knowledge root (revise / continue setup there).
- Choosing setup here always uses the open project as effective root for that setup run, even if a local pointer file also exists (explicit “set up this project” override for the setup-here choice only).
- No backward compatibility obligation: prior per-skill setup-only messages and pre-pointer layouts need not be preserved or migrated.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: `highway-experience`, when activated by another Highway skill, MUST resolve one effective Highway knowledge root before the mode check and before any other repository operation that skill would perform.
- **FR-002**: The storage contract MUST define effective Highway knowledge root, the resolution order in FR-003, the two pointer files, commit vs gitignore rules, and that "outside the repository root" means outside the effective knowledge root.
- **FR-003**: Resolution MUST follow this order: (1) usable local pointer path in the open project → that directory; (2) else open project is a Highway knowledge root → open project; (3) else committed URL only → not-ready guidance without Local writes to the open project as knowledge; (4) else dual gate (setup or path/URL).
- **FR-004**: A Highway knowledge root MUST be recognized when the candidate tree has a readable `library/knowledge/profile.md` or a readable `library/knowledge/storage.md` (either is sufficient).
- **FR-004a**: A local pointer path (from file or from the gate) is usable ONLY when it resolves to a readable directory that is already a Highway knowledge root per FR-004. A path that fails that check MUST be rejected: it MUST NOT become the effective root, and experience MUST ask again or offer setup in the open project.
- **FR-005**: Pointer files MUST live in the open project (invocation tree): committed `hw-repository.md` with a `repository:` git URL; local `hw-repository.local.md` with a `path:` value. Relative `path` values MUST be resolved relative to the open project root. Absolute paths are allowed only as the local pointer's `path` configuration value that sets the effective root, not as skill-authored storage-operation arguments. Experience MUST NOT persist a local pointer for a path that fails FR-004a.
- **FR-006**: `highway-experience` MUST own the not-ready gate, pointer persistence, and `.gitignore` updates for the local pointer. No new skill whose only job is repository resolution or that gate may be added.
- **FR-007**: The dual gate MUST offer `highway-setup` in the open project **or** a folder path and/or git URL for an existing Highway knowledge project, using one shared gate asset under experience so copy cannot drift across owning skills.
- **FR-007a**: After a successful bind of a valid knowledge-root path during the gate (whether or not pointers were persisted), experience MUST return ready in the **same** skill invocation so the owning skill proceeds against the effective knowledge root. Experience MUST NOT require a re-run solely because a bind just succeeded.
- **FR-007b**: When the person chooses setup in this project from the dual gate and the activating skill is **not** `highway-setup`, experience MUST return not-ready, name `highway-setup` as the next action, and MUST NOT run or delegate `highway-setup` inside the activating skill.
- **FR-007c**: When the activating skill **is** `highway-setup` and the person chooses setup in this project from the dual gate, experience MUST return ready with the **open project** as the effective knowledge root for that setup run (setup-here override), and setup MUST continue in the same invocation. `highway-setup` MAY still show the dual gate so the person can bind an existing knowledge root instead of seeding the open project.
- **FR-008**: When the person accepts storing a local path, experience MUST write `hw-repository.local.md` and MUST ensure `hw-repository.local.md` is listed in `.gitignore` (append or create with person acceptance). When the person declines gitignore, experience MUST NOT write the local pointer file.
- **FR-009**: When the person accepts storing a git URL for the team, experience MUST write `hw-repository.md` and MUST NOT add that file to `.gitignore` as part of this feature.
- **FR-010**: When only a committed URL is available and Local cannot use a working tree at that URL, experience MUST NOT clone, MUST NOT treat the URL as a Local root, and MUST stop with guidance to open or clone and set a local path (naming later Remote/Chat as future options without implementing them).
- **FR-011**: Owning skills that today emit their own setup-only stop MUST remove that duplicated gate. After activating experience, if experience returned not-ready, the owning skill MUST write nothing and end. Domain catalog checks MAY remain only when they assume a ready knowledge root and do not re-offer setup-or-pointer.
- **FR-012**: Local storage operations MUST read and write the effective knowledge root's working tree; the person still handles git there. This feature MUST NOT add a Highway storage MCP or fill Remote/Chat columns beyond documenting URL-only Local limits.
- **FR-013**: `hw-repository.md` and `hw-repository.local.md` MUST be documented as Highway knowledge pointers only, not as locations for product/code repositories (reserved for a later external codify phase).
- **FR-014**: With no pointer files and an open Highway knowledge root, behavior MUST remain Local cwd-as-root for knowledge storage.
- **FR-015**: Automated tests MUST cover resolution order, pointer schemas, gitignore expectation for the local pointer, URL-only stop without wrong-tree writes, path pointer directing storage to the pointed tree, removal of duplicated setup-only gates from owning skills, and suite pass without pointers. Harness fixtures MUST cover: non-Highway open project + local pointer to a knowledge fixture; no pointer → dual gate and no silent seed; committed URL only → stop guidance.

### Key Entities

- **Highway knowledge root**: The working tree that holds organizational Highway records (Profile, catalogs, requests, and related knowledge). Distinct from an arbitrary open product or business project.
- **Open project**: The working tree where the person invoked the skill (cwd / workspace root for that invocation).
- **Committed repository pointer**: `hw-repository.md` in the open project; portable git URL of the org Highway knowledge repository; shared via version control.
- **Local repository pointer**: `hw-repository.local.md` in the open project; personal filesystem path to a knowledge checkout; gitignored.
- **Not-ready gate**: Experience-owned interaction offering setup in the open project or pointer inputs when no usable knowledge root exists.
- **Effective knowledge root**: The directory chosen for the run by the resolution order; all Highway storage-contract paths are relative to it.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: In a non-Highway open project with a valid local pointer, a person can complete a knowledge-reading Highway skill using records from the pointed tree on the first attempt without running setup in the open project.
- **SC-002**: 100% of owning skills that previously showed a private setup-only stop no longer show that private stop; the dual gate appears only through experience when not ready.
- **SC-003**: A teammate cloning an open project that contains only the committed URL pointer is guided to supply a local path rather than having Highway catalogs written into that open project as a false knowledge root.
- **SC-004**: People who only use a single Highway knowledge repository (no pointer files) can complete the same skill flows as before without being forced through the dual gate.
- **SC-005**: Automated suite and required harness fixture cases for this feature pass before the feature is marked done.

## Assumptions

- Phase 15 in `rollout-plan.md` is the authoritative scope for this feature; Remote (Phase 1), Chat (Phase 3), and external codify code targets (Phase 16) are out of scope except for documented coordination and naming reservations.
- The product is still in development; this feature has no backward-compatibility or migration requirement for prior gate copy or layouts.
- "Ready" for leaving the experience gate means a usable effective knowledge root was resolved (local path or cwd knowledge root). Domain skills may still stop later for missing domain catalogs under that root without re-opening the setup-or-pointer gate.
- Either `library/knowledge/profile.md` or `library/knowledge/storage.md` is enough to recognize a Highway knowledge root; both absent means not a knowledge root for resolution step (2).
- Declining gitignore declines writing the local pointer file (prefer not committing machine paths by accident).
- Ephemeral use of a path provided in the gate for the current run is allowed when the person accepts a valid knowledge-root path for this run even if they decline persistence; persistence is optional; the owning skill still continues in the same invocation (FR-007a).
- Exact gate prose follows the Experience Standard (one consequential question, clear next action) and will be pinned in a single experience asset during planning/implementation.
- Plugin regeneration / adapter copies follow existing packaging rules when skills change; no new agent-specific settings mechanism is introduced.
- Harness coverage for this feature uses existing driver(s) as available; full multi-agent Remote/Chat matrices are not required here.
