# Feature Specification: Agent Manifests

**Feature Branch**: `248-agent-manifests`

**Created**: 2026-11-14

**Status**: Draft

**Input**: User description: "create a new spec to implement Phase 6 in rollout-plan.md"

Phase 6 of `rollout-plan.md`: `highway-agent-plugin/` carries each supported agent's own manifest beside the Agent Plugins root `plugin.json`. Every manifest is generated from one source in `framework/plugin/`, so an agent can install Highway from its own format and no manifest drifts from the others. Today the plugin holds only the root `plugin.json`, which Copilot reads (spec 246). This spec writes the manifests for Claude Code, Codex, Cursor, Antigravity, and Gemini CLI. The driver phases (7 to 11) prove that each agent loads its own; this spec proves only that Copilot still installs Highway as before.

## Clarifications

### Session 2026-11-14

- Q: Which author does every manifest name? → A: Highway, with the URL `https://www.highway.systems`.
- Q: Does Highway ship a logo now? → A: Yes, a placeholder. It is replaced when the real logo exists.
- Q: Should `homepage` change from the GitHub repository to `https://www.highway.systems`, with `repository` staying on GitHub? → A: Yes (the pattern Cloudflare uses). `repository` stays `https://github.com/jacob623/highway-skills` until `rollout-plan.md` Phase 19 moves it to Highway's permanent public repository.
- Q: If planning cannot confirm an agent's manifest format from its published documentation, does this spec still write that manifest? → A: Yes. It is written from the best evidence: the agent's documentation or published schema, and the reviewed publishers' manifests. Each field's source is recorded in the research notes, and that agent's driver phase confirms or fixes it.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - One source renders every agent's manifest (Priority: P1)

A maintainer changes Highway's description, keywords, or version in one place, rebuilds the plugin, and every agent's manifest carries the change. Fields only one agent needs, such as Codex's listing text or Antigravity's suggested prompts, live in one listing file, and nowhere else.

**Why this priority**: The publishers reviewed for the rollout who keep each manifest by hand already disagree on descriptions, keywords, and authors. One source is the only way six manifests stay in step, and every driver phase installs from these files.

**Independent Test**: Build the plugin, then compare the shared fields of all six manifests with the source. Change one shared field in the source, rebuild, and confirm that field changed in all six manifests and nothing else changed.

**Acceptance Scenarios**:

1. **Given** the source in `framework/plugin/`, **When** the build runs, **Then** the plugin holds the root `plugin.json`, `.claude-plugin/plugin.json`, `.codex-plugin/plugin.json`, `.cursor-plugin/plugin.json`, `.antigravity-plugin/plugin.json`, and `gemini-extension.json`, beside `skills/`, `README.md`, and `LICENSE`.
2. **Given** the built manifests, **When** their shared fields (name, version, description, keywords, author, homepage, repository, license) are read, **Then** each field a manifest carries has the source's exact value.
3. **Given** a new version in `framework/plugin/plugin.json`, **When** the build runs, **Then** every manifest that carries a version shows it, and no other file changed.
4. **Given** the listing file, **When** the Codex, Cursor, and Antigravity manifests are read, **Then** each carries its agent's listing fields from that file, and no other manifest carries them.
5. **Given** unchanged sources, **When** the build runs twice, **Then** the second build changes no byte.

---

### User Story 2 - The suite stops a manifest from drifting (Priority: P1)

A maintainer who hand-edits a generated manifest, adds an unlisted file, or puts a shared field in the listing file is stopped by the bash suite, which names the file and the field.

**Why this priority**: A generated file that can be edited by hand drifts. Without these checks a driver phase could test against a manifest that no longer matches its source.

**Independent Test**: Run the checks on the committed plugin (they pass), then on copies seeded with each defect (each fails and names the defect).

**Acceptance Scenarios**:

1. **Given** a hand-edited manifest, **When** the drift check runs, **Then** it fails and names the manifest.
2. **Given** a manifest missing a field its format requires, **When** validation runs, **Then** it fails and names the manifest and the field.
3. **Given** a manifest whose shared field differs from the source, **When** validation runs, **Then** it fails and names the field.
4. **Given** a manifest whose skills path does not lead to the 16 skills, **When** validation runs, **Then** it fails and names the manifest.
5. **Given** a listing-file field that repeats a shared field, **When** validation runs, **Then** it fails and names the field.
6. **Given** a file in the plugin outside the closed list, **When** validation runs, **Then** it fails and names the file.

---

### User Story 3 - Copilot still installs Highway from the root manifest (Priority: P2)

With six manifests in one folder, a maintainer's harness run still installs Highway into Copilot, named `highway`, with all 16 skills, from the root `plugin.json`. A Copilot smoke run proves it and leaves a run log in this spec's folder.

**Why this priority**: Copilot is the only agent the harness drives today. Copilot reads `.claude-plugin/` when a plugin has no root manifest, so adding that folder could change what Copilot installs. The run is the evidence it did not.

**Independent Test**: Run the Copilot smoke set and read the run log: every attempt's install line names `highway` with 16 skills.

**Acceptance Scenarios**:

1. **Given** the plugin with all six manifests, **When** a harness attempt installs it, **Then** Copilot reports the plugin `highway` with 16 skills, and the harness's install check passes unchanged.
2. **Given** the full suite and the harness tests have passed, **When** one Copilot smoke run completes, **Then** its run log is saved in this spec's folder, every attempt installed `highway` with 16 skills, and no failure kind appears that earlier runs did not have.
3. **Given** a smoke failure on skill behavior, **When** the findings are read, **Then** the failure is matched to a finding in `harness-model-findings.md`.

---

### User Story 4 - The manifest set is documented and governed (Priority: P3)

A maintainer reading `framework/README.md` learns where each shared and agent-only field lives, which manifests are generated, and how to change a field or the version. The development constitution's packaging rules name the manifest set.

**Why this priority**: The driver phases change the source when an agent rejects a field. They need to know where that field lives, and that the generated files are never edited.

**Independent Test**: Read `framework/README.md` and the constitution, and confirm each names the source, the listing file, and the six generated manifests.

**Acceptance Scenarios**:

1. **Given** `framework/README.md`, **When** a maintainer looks up a manifest field, **Then** the README says whether it comes from `plugin.json` or the listing file, and that generated manifests are never edited by hand.
2. **Given** the development constitution, **When** its packaging rules are read, **Then** they name the manifest set, and its version has a MINOR bump.

---

### Edge Cases

- A listing field only one agent needs, such as Codex's website, has the same value as a shared field, such as `homepage`. The generator renders it from the shared field, so the listing file never repeats a shared value.
- An agent's format has an optional field Highway has no value for, such as a privacy policy or terms of service link. The manifest leaves it out rather than carrying an empty or placeholder value.
- A skill is added to `skills/`. Every manifest's skills path still leads to the skills folder, so the new skill is reachable from every manifest with no manifest change, and the validator expects the new count.
- A later driver phase finds that its agent rejects a field. It changes the source and the generator, never the generated manifest.
- Copilot reads `.claude-plugin/plugin.json` when a plugin has no root `plugin.json`. The root manifest stays in the plugin, so Copilot must still read it. If the smoke run shows Copilot reading another manifest, the spec stops for the user to decide.
- The root `plugin.json` is still checked against Agent Plugins 1.0.0. Adding `keywords` and `author` must keep it valid.
- A manifest references the logo, but the file is missing or renamed. Validation fails and names the manifest and the path.
- The plugin is still excluded from the distribution. The new manifests do not reach the per-agent skill copies or the distribution.

## Requirements *(mandatory)*

### Functional Requirements

**Source**

- **FR-001**: `framework/plugin/plugin.json` MUST stay the only source of the shared fields: name, version, description, keywords, author, homepage, repository, and license. It MUST gain `keywords` and `author`. `homepage` MUST become `https://www.highway.systems`, and `repository` MUST stay `https://github.com/jacob623/highway-skills`.
- **FR-002**: A listing file in `framework/plugin/` MUST hold only the fields one agent needs, and no shared field:
  - Codex: the `interface` block's display name, short and long descriptions, category, capabilities, and default prompt;
  - Cursor: the logo;
  - Antigravity: display name, suggested prompts, and the logo.

  Cursor's plugin manifest has no display name or category, and Antigravity's published schema has no category (research R4 and R5, per FR-007a). Category for Cursor is a marketplace field, in Phase 14.
- **FR-003**: An agent field whose value is a shared value MUST be rendered from the shared field, and not repeated in the listing file: for Codex, the developer name comes from `author` and the website from `homepage`, so it is `https://www.highway.systems`.
- **FR-004**: An optional agent field with no real value, such as a privacy policy or terms of service link, MUST be left out. No manifest carries an empty or placeholder value.
- **FR-005**: The author MUST be `{ "name": "Highway", "url": "https://www.highway.systems" }`, in every manifest that carries an author. Codex's developer name is `Highway`.
- **FR-006**: Highway MUST ship a placeholder logo: one committed image file in `framework/plugin/assets/`, referenced from the listing file for each agent whose format shows a logo (Codex, Cursor, and Antigravity), and copied into the plugin byte for byte. It is a simple mark reading "Highway", in a format and size every one of those agents accepts. Replacing the file, under the same name, replaces the logo in every manifest with no other change.

**Generated manifests**

- **FR-007**: The build MUST write exactly these manifests, and nobody edits them:
  - `plugin.json`, Agent Plugins 1.0.0, read by Copilot, VS Code, and Kiro;
  - `.claude-plugin/plugin.json`, for Claude Code;
  - `.codex-plugin/plugin.json`, for Codex, naming `./skills/` and carrying the `interface` block;
  - `.cursor-plugin/plugin.json`, for Cursor, naming `./skills/`;
  - `.antigravity-plugin/plugin.json`, for Antigravity, naming its `$schema`;
  - `gemini-extension.json`, for Gemini CLI, with name, version, and description, and no context file.
- **FR-007a**: Each of the five agent manifests MUST be written even when its format cannot be confirmed from the agent's published documentation. Its fields then come from the best evidence available: the agent's published schema, and the manifests of the publishers reviewed for the rollout. The research notes MUST record, for each manifest field, where its name and form came from and whether the agent's documentation confirms it, so the driver phase knows what to recheck.
- **FR-008**: The plugin MUST NOT hold `.github/plugin/plugin.json`; Copilot reads the root manifest.
- **FR-009**: No manifest MUST declare hooks, MCP servers, rules, commands, agents, or an always-on instruction file.
- **FR-010**: Each manifest MUST carry the shared fields its format accepts, with the source's exact values, and the fields its format requires.
- **FR-011**: The build MUST stay reproducible: unchanged sources produce identical bytes, with a fixed field order and formatting in every manifest.
- **FR-012**: A release MUST change the version in one place, `framework/plugin/plugin.json`.

**Checks**

- **FR-013**: The drift check (`framework/generate-agent-plugin.sh --check`) MUST cover every manifest, so a hand edit fails and names the file.
- **FR-014**: `framework/validate-plugin.sh` MUST check each manifest:
  - its shared fields equal the source;
  - the fields its format requires are present;
  - its skills path, where it has one, leads to the plugin's skills folder and its 16 skills;
  - its logo path, where it has one, leads to the shipped logo;
  - no file outside the closed list of shipped files ships.
- **FR-015**: Validation MUST fail when the listing file holds a shared field, naming the field.
- **FR-016**: `tests/agent-plugin.test.sh` MUST check the shipped set, now including the manifests. New tests MUST cover two builds being byte-identical, a changed shared field reaching every manifest, a hand-edited manifest failing the drift check, a listing field that repeats a shared field failing validation, and an unlisted file failing. Each new test MUST be seen to fail first (Development Constitution D3.6), and each changed test MUST record its placement verdict before and after (D3.4).

**Copilot and the live check**

- **FR-017**: With all six manifests in the plugin, the harness MUST still install Highway into Copilot as `highway` with 16 skills, from the root `plugin.json`, with the harness's install check unchanged.
- **FR-018**: After the full suite and the harness tests pass, one `--agent copilot --smoke` run MUST complete without `--transcripts`, with its standard output saved to `specs/248-agent-manifests/harness/smoke.log` to be committed. No secret, token, or temporary path appears in it.
- **FR-019**: An install or load failure in the smoke run MUST block completion and MUST be fixed in this spec. A skill-behavior failure MUST be matched to a finding in `harness-model-findings.md`, adding a Runs line to an existing finding or opening a new one in the established format.

**Unchanged**

- **FR-020**: No skill, template, fixture, or scenario MUST change. The per-agent skill copies and the distribution MUST build as before, and the distribution MUST NOT include the plugin or its manifests.
- **FR-021**: The plugin's `README.md` and `LICENSE` MUST stay as they are. Install instructions for each agent belong to the driver phases and Phase 14.

**Docs and governance**

- **FR-022**: `framework/README.md` MUST describe the source, the listing file, the generated manifests, which fields each draws from where, and how to change a shared field or the version.
- **FR-023**: The development constitution's packaging rules MUST name the manifest set, with a MINOR version bump.
- **FR-024**: When the work is done, `rollout-plan.md` MUST mark Phase 6 complete in its phase table, naming this spec's folder, and add a Status paragraph recording what was done beyond its items.

### Key Entities

- **Shared fields**: name, version, description, keywords, author, homepage, repository, and license, kept once in `framework/plugin/plugin.json`.
- **Listing file**: the fields one agent needs, keyed by agent, kept in `framework/plugin/`. It holds no shared field.
- **Manifest set**: the six generated manifests in `highway-agent-plugin/`, one per format, each drawing from the shared fields and its agent's listing entry.
- **Logo**: one placeholder image in `framework/plugin/assets/`, referenced by the Codex, Cursor, and Antigravity listing entries and shipped in the plugin.
- **Shipped set**: everything the plugin holds: the manifest set, `skills/`, `README.md`, `LICENSE`, and the logo. It is a closed list.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: The plugin holds the root manifest and five agent manifests, and each passes its checks. Every logo reference in a manifest leads to the shipped logo file.
- **SC-002**: Two consecutive builds with no source change differ in 0 bytes.
- **SC-003**: Changing one shared field in the source changes that field in every manifest that carries it, and changes no other byte in the plugin.
- **SC-004**: Each seeded defect fails the suite and names the file and the field: a hand-edited manifest, a missing required field, a shared field that differs from the source, a skills path that leads nowhere, a listing field that repeats a shared field, and an unlisted file. The unseeded plugin passes.
- **SC-005**: The full suite passes, with the new checks counted in it.
- **SC-006**: In the Copilot smoke run, every attempt installs `highway` with 16 skills, no new failure kind appears, and the committed run log is under 100 KB with no secret or temporary path.
- **SC-007**: The per-agent skill copies and the distribution are byte-identical to their builds before this spec.

## Assumptions

- Phase 5 (spec 247) is complete. The harness drives Copilot only and prints the run log a spec can commit.
- The plan confirms each format's required and accepted fields from the agent's published documentation where it can, and the allowed category values for Codex, Cursor, and Antigravity. Where it cannot, FR-007a applies. A field an agent turns out to reject is fixed by its driver phase in the source.
- The plan confirms the logo format and size each of Codex, Cursor, and Antigravity accepts, and picks one file that suits all three. The placeholder is committed as a source file, not drawn at build time, so the build stays reproducible.
- The version stays 0.1.0. A release, in a later phase, bumps it in one place.
- The keywords describe what Highway does, such as governance, architecture, ADR, traceability, and platform engineering. The plan settles the list.
- The listing text (display names, descriptions, prompts) is drafted in the plan from the plugin's README and `plugin.json` description, and reviewed with the user before it is written.
- Only Copilot is checked live. Claude Code, Codex, Cursor, Antigravity, and Gemini CLI loading their manifests is proved in Phases 7 to 11.
- Marketplace catalogs, official listings, and installing from the public repository are Phase 14. Moving `repository` to Highway's permanent public repository is Phase 19.
- Constraints carried from earlier work: do not commit unless asked; secrets and tokens are redacted; `rollout-plan.md` stays gitignored and excluded from the distribution; MINOR version bumps only; no backward compatibility; use `mv`, not `git mv`; templates are fixed.
