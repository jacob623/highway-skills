---

description: "Task list template for feature implementation"
---

# Tasks: Skill Id Namespace Alignment

**Input**: Design documents from `/specs/009-skill-id-namespace-alignment/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md (all present)

**Tests**: No test tasks were explicitly requested as new automated coverage beyond what already
exists; however, this feature's change (a new, unconditionally-run `name`==id validation check)
would otherwise silently break several existing tests, so **fixing those existing tests is
mandatory, in-scope work**, not optional TDD scaffolding.

**Organization**: Tasks are grouped by user story (spec.md P1/P1/P2) to enable independent
implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies on incomplete tasks)
- **[Story]**: Which user story this task belongs to (US1, US2, US3)
- Every task names its exact file path

## Path Conventions

Single project. All paths are repository-root-relative. `.highway/` is the framework root
(distinct from the true repo root — specs/002-highway-folder-consolidation/research.md); agent
adapter targets (`.github/`, `.claude/`, `.cursor/`) live at the true repo root.

---

## Phase 1: Setup

**Purpose**: Establish a known-good baseline before any change.

- [X] T001 Run `.highway/tools/tests/run-all.sh` from repo root and confirm every test currently
      passes, so any later failure can be attributed to this feature's own changes.

**Checkpoint**: Baseline confirmed green.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: The one change every subsequent task depends on — nothing below this can start
until the canonical directory exists at its new path.

**⚠️ CRITICAL**: No user story work can begin until this phase is complete.

- [X] T002 Rename the canonical skill directory: `git mv .highway/skills/help
      .highway/skills/highway-help` (repo root). Per research.md R1.

**Checkpoint**: `.highway/skills/highway-help/SKILL.md` exists; `.highway/skills/help/` does not.

---

## Phase 3: User Story 1 - Canonical skill directory already carries the agent-facing name (Priority: P1)

**Goal**: Directory name, catalog `id`, and every generated adapter's target basename are the
same literal string (`highway-help`), with no separate namespace-prefix computation anywhere in
the generator.

**Independent Test**: Inspect `.highway/skills/`, resolve the catalog, and confirm the directory
name, catalog `id`, and every generated adapter path basename match, with the generator producing
that match by substitution alone (no injected prefix).

- [X] T003 [US1] In `.highway/tools/generate-agent-adapters.sh`, change `AGENT_TARGET_TEMPLATES`
      from `.github/skills/highway-%s/SKILL.md`, `.claude/skills/highway-%s/SKILL.md`,
      `.cursor/rules/highway-%s.mdc` to `.github/skills/%s/SKILL.md`, `.claude/skills/%s/SKILL.md`,
      `.cursor/rules/%s.mdc` (drop the injected `highway-` prefix). Per
      contracts/agent-adapter-contract.md and research.md R2.
- [X] T004 [US1] In `.highway/tools/generate-agent-adapters.sh`, remove the
      `AGENT_OLD_TARGET_TEMPLATES` array, the `check_stale_removable` and `remove_stale_target`
      functions, and every call site that references them (in the drift-check loop and the
      write loop). Per research.md R3.
- [X] T005 [US1] Update `.highway/tools/generate-agent-adapters.sh`'s header comment: replace the
      stale-artifact-refusal line in the exit-code doc, the `highway-<id>` path examples, and the
      `AGENT_OLD_TARGET_TEMPLATES` explanatory comment, to describe the new, non-prefixing
      templates and the retired stale-cleanup mechanism.
- [X] T006 [P] [US1] In `.highway/skills/_authoring-standard.md` line ~12, update the reference
      from `.highway/skills/help/` to `.highway/skills/highway-help/`.
- [X] T007 [US1] Run `.highway/tools/generate-catalog.sh` from repo root; confirm
      `.highway/catalog/index.json`/`index.md` show `"id": "highway-help"` and
      `"source_path": "skills/highway-help/SKILL.md"`.
- [X] T008 [US1] Run `.highway/tools/generate-agent-adapters.sh` from repo root; confirm
      `.github/skills/highway-help/SKILL.md`, `.claude/skills/highway-help/SKILL.md`,
      `.cursor/rules/highway-help.mdc` still exist at these exact paths (no file moved, none
      added or removed) with regenerated content.
- [X] T009 [P] [US1] Update `.highway/tools/tests/generate-agent-adapters.test.sh`: drop the
      injected `highway-` prefix from the `GH_TARGET`, `CLAUDE_TARGET`, and `CURSOR_TARGET`
      variables (now `.github/skills/$TMP_ID/SKILL.md` etc.); remove the `GH_OLD_TARGET`
      variable, the seeded stale-artifact block (mock manifest row + pre-existing dot-form
      file), and the corresponding removal assertion, since `AGENT_OLD_TARGET_TEMPLATES` no
      longer exists (research.md R3); update the header comment's `.highway/skills/help/`
      reference to `.highway/skills/highway-help/`.
- [X] T010 [P] [US1] Update `.highway/tools/tests/new-agent-extensibility.test.sh`: drop the
      injected `highway-` prefix from the cleanup paths for the three pre-existing agents
      (`.github/skills/highway-$TMP_ID` → `.github/skills/$TMP_ID`, same for `.claude/skills/`
      and `.cursor/rules/`).

**Checkpoint**: `.github/skills/highway-help/`, `.claude/skills/highway-help/`,
`.cursor/rules/highway-help.mdc` unchanged in location; `.highway/tools/tests/run-all.sh` still
passes (name-field content is not yet aligned — that is User Story 2 — but nothing added by this
story breaks on its own).

---

## Phase 4: User Story 2 - Frontmatter Name matches the directory-derived id exactly (Priority: P1)

**Goal**: `highway-help/SKILL.md`'s frontmatter `name` equals its directory id exactly, and
`validate-skill.sh` rejects any skill where that is not true.

**Independent Test**: Run the validator against every skill and confirm it fails any skill whose
frontmatter `name` does not exactly equal its directory-derived id, then confirm every
currently-registered skill passes.

- [X] T011 [US2] In `.highway/skills/highway-help/SKILL.md`, change frontmatter `name: Help` to
      `name: highway-help` and `metadata.version: 2.0.0` to `metadata.version: 3.0.0`. Per
      data-model.md and research.md R5 (MAJOR bump).
- [X] T012 [US2] In `.highway/skills/highway-help/SKILL.md`'s `## Inputs` section, update the
      wording describing the declared skill identifier so it no longer reads as a bare,
      abbreviated id (it is now the same string as the directory name and the agent invocation
      token).
- [X] T013 [US2] In `.highway/skills/highway-help/SKILL.md`'s `## Outputs` section, change the
      `Name:` computation description from "computed as `highway-<id>` from the resolved catalog
      `id`, never copied from frontmatter `name`" to "the resolved catalog `id`, read verbatim
      (already the full agent-facing identifier)". Per contracts/help-output-contract.md.
- [X] T014 [US2] In `.highway/skills/highway-help/SKILL.md`'s `## Verification` section, change
      "Request help for `help` itself" to "Request help for `highway-help` itself", keeping the
      expected `Name: highway-help` assertion.
- [X] T015 [US2] In `.highway/skills/highway-help/SKILL.md`'s `## Example` section, change the
      invocation from `` `/highway-help help` `` to `` `/highway-help highway-help` ``, in both
      the heading line and the rendered `Example:` line inside the fenced sample output block.
      Per spec.md FR-009.
- [X] T016 [P] [US2] Add `sv_validate_name(name, id)` to `.highway/tools/lib/schema-validate.sh`:
      returns 0 silently if `name` equals `id` exactly; otherwise prints
      `ERROR: [SCHEMA] frontmatter 'name' ('<name>') does not match directory-derived id '<id>'`
      and returns 1. Per contracts/skill-authoring-contract.md and research.md R4.
- [X] T017 [US2] In `.highway/tools/validate-skill.sh`, call
      `collect "$(sv_validate_name "$(fm_get "$skill_file" name || true)" "$id")"` alongside the
      other schema-level checks (depends on T016).
- [X] T018 [P] [US2] Update every existing fixture under `.highway/tools/tests/fixtures/`
      (`valid-skill`, `invalid-skill-long-description`, `invalid-skill-missing-example`,
      `invalid-skill-missing-usage`, `invalid-skill-missing-version`, `invalid_skill_bad_id`) so
      each `SKILL.md`'s frontmatter `name` equals its own directory name exactly (e.g.
      `name: valid-skill`, `name: invalid_skill_bad_id`), so the new check in T016/T017 does not
      add an unrelated second failure to any fixture that must produce exactly one.
- [X] T019 [P] [US2] Add a new fixture `.highway/tools/tests/fixtures/invalid-skill-name-mismatch/`
      (copy the `valid-skill` fixture's shape) whose frontmatter `name` deliberately does not
      equal its directory name, to exercise the new check.
- [X] T020 [US2] In `.highway/tools/tests/validate-skill.test.sh`, add
      `assert_exit_nonzero_naming "$FIXTURES/invalid-skill-name-mismatch" "does not match
      directory-derived id"` and `assert_single_failure "$FIXTURES/invalid-skill-name-mismatch"
      "SCHEMA"` (depends on T017, T019).
- [X] T021 [P] [US2] In `.highway/tools/tests/generate-agent-adapters.test.sh`, immediately after
      `cp "$FIXTURES/valid-skill/SKILL.md" "$SKILL_SRC_DIR/SKILL.md"`, add a `sed` rewriting the
      copied file's `name:` line to `$TMP_ID`, so the temp fixture satisfies the new
      name-equals-id check (depends conceptually on T017; can be authored in parallel and
      verified once T017 lands).
- [X] T022 [P] [US2] Apply the same fix as T021 to
      `.highway/tools/tests/new-agent-extensibility.test.sh` (after its `cp` of the same
      fixture).
- [X] T023 [P] [US2] Apply the same fix as T021 to
      `.highway/tools/tests/generate-catalog.test.sh` (after its `cp` of the same fixture).
- [X] T024 [US2] Re-run `.highway/tools/generate-catalog.sh` and
      `.highway/tools/generate-agent-adapters.sh` from repo root (depends on T011-T017); confirm
      the catalog's `name`/`version` fields and all three generated adapters' frontmatter/`##
      Example` content reflect `highway-help`/`3.0.0`.

**Checkpoint**: `.highway/tools/validate-skill.sh .highway/skills/highway-help` exits 0;
temporarily reverting T011's `name` change reproduces the new, explicit validator error.

---

## Phase 5: User Story 3 - Convention is enforced for every future skill (Priority: P2)

**Goal**: The pairing (directory already namespaced; `name` matches the directory) is documented
as a required, validated rule for every future skill, not a one-time cleanup.

**Independent Test**: Author a new, otherwise-valid skill whose frontmatter `name` deliberately
does not match its directory name, and confirm the validator rejects it with an explicit,
actionable error before it can be registered (already provable via T020's fixture/assertion from
User Story 2 — this story's own task makes the written standard match that enforced behavior).

- [X] T025 [US3] In `.highway/skills/_authoring-standard.md`'s Required frontmatter table, rewrite
      the `name` field row from "Free-form display name. Never required to match the
      directory-derived id." to state `name` MUST match the directory-derived id exactly,
      validated by `sv_validate_name` (`[SCHEMA]`). Per contracts/skill-authoring-contract.md.

**Checkpoint**: `.highway/tools/tests/authoring-standard.test.sh` still passes (no new rule id
introduced, so its citation-count check is unaffected).

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Final consistency sweep and full validation.

- [X] T026 Update `.highway/tools/README.md`'s citation of
      `specs/008-help-output-namespacing/contracts/agent-adapter-contract.md` to
      `specs/009-skill-id-namespace-alignment/contracts/agent-adapter-contract.md`.
- [X] T027 Grep the repository (excluding frozen `specs/006-*`, `specs/007-*`, `specs/008-*`
      directories) for remaining `skills/help` (bare id), `/highway-help help` (old
      self-invocation), or `highway-%s` (old injected-prefix template) references in live
      documentation or tooling, and fix any found.
- [X] T028 Run `.highway/tools/tests/run-all.sh` from repo root; confirm all tests pass.
- [X] T029 Manually execute quickstart.md scenarios 1-8; confirm each matches its stated
      expected output.

**Checkpoint**: Feature complete; full regression green; quickstart scenarios verified.

---

## Dependencies

- Phase 1 (T001) has no dependencies.
- Phase 2 (T002) depends on T001 (baseline confirmed first) and blocks every later task (all
  reference the renamed path).
- Phase 3 (US1, T003-T010) depends on T002. T003 blocks T004 and T005 (same file, sequential
  edits). T007/T008 depend on T003-T005. T009/T010 are independent of T003-T008's runtime effects
  but logically follow them for verification.
- Phase 4 (US2, T011-T024) depends on Phase 3 being complete (regeneration in T024 should not
  overwrite adapters mid-way through an unfinished template change). T011-T015 are sequential
  (same file). T016 blocks T017. T018/T019 block T020. T017 blocks T020-T023 for meaningful
  verification (tasks may be authored in parallel but not verified as passing until T017 lands).
  T024 depends on T011-T017.
- Phase 5 (US3, T025) depends on T017 existing (the rule it documents must already be enforced) —
  can be authored any time after T017, independently of T018-T024.
- Phase 6 (Polish, T026-T029) depends on all prior phases.

## Parallel Execution Examples

- Within Phase 3: T006 (`_authoring-standard.md`) can run in parallel with T003-T005
  (`generate-agent-adapters.sh`) — different files. T009 and T010 can run in parallel with each
  other — different files.
- Within Phase 4: T016 (`schema-validate.sh`) can run in parallel with T011-T015
  (`highway-help/SKILL.md`) and with T018/T019 (fixtures) — all different files. T021, T022, T023
  can run in parallel with each other — different files.

## Implementation Strategy

**MVP scope**: User Story 1 (Phase 3) alone is a valid, independently deliverable increment — it
removes the structural ambiguity (directory/id/adapter-path alignment) without yet touching the
`name` field, and spec.md's own Independent Test for US1 does not require US2 to be done.
Recommended delivery order remains US1 → US2 → US3, matching priority order and the dependency
chain above (US2's validator change would otherwise start rejecting the still-mismatched `name`
value US1 leaves in place).
