# Tasks: Publish and Public Install

**Input**: Design documents from `specs/257-publish-public-install/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Bash suite cases and harness unit tests are required by the packaging / harness
patterns in this repo (URL guard, catalog drift, publish refusals, CLI switches).

**Organization**: By user story (US1–US5) after setup and foundation.

## Phase 1: Setup

**Purpose**: Baseline and harness log location for this spec

- [x] T001 Record D3.1 baseline: note current `tests/run-all.sh` and `npm --prefix harness test` status in the implementation notes (or agent transcript); do not change product code yet
- [x] T002 [P] Ensure `specs/257-publish-public-install/harness/` exists for committed public-smoke logs and is covered by existing harness log gitignore rules used by prior driver specs

---

## Phase 2: Foundational

**Purpose**: Shared helpers and generator hooks every story needs

- [x] T003 Extend `framework/generate-agent-plugin.sh` (and `framework/lib/plugin-manifest.sh` if needed) so a build can emit marketplace catalog files listed in `contracts/marketplace-catalogs.md` without breaking existing manifest render
- [x] T004 [P] Document catalog + publish entry points in `framework/README.md` (contributor-facing; adapters may still be mentioned as internal)

**Checkpoint**: Generator can grow catalogs; docs name the new scripts once they exist

---

## Phase 3: User Story 1 - Permanent public repository URL (P1) 🎯 MVP

**Goal**: `repository` is `https://github.com/highway-systems/agent-plugin` everywhere shipped; URL guard fails on old install identity

**Independent Test**: Regenerate plugin; grep manifests/README; run URL guard test

- [x] T005 [US1] Set `repository` to `https://github.com/highway-systems/agent-plugin` in `framework/plugin/plugin.json` (keep homepage)
- [x] T006 [US1] Update end-user install examples in `framework/plugin/README.md` to `highway-systems/agent-plugin`
- [x] T007 [US1] Add `tests/publish-url.test.sh` implementing the URL guard allowlist from `data-model.md` / research R5; wire it into `tests/run-all.sh` if required by suite conventions
- [x] T008 [US1] Run `framework/generate-agent-plugin.sh` so `highway-agent-plugin/` carries the new URL; fix any leftover install examples in development docs that are end-user facing (not contributor adapter docs)
- [x] T009 [US1] Observe URL guard fail on a seeded old URL, then pass on the clean tree (D3.6)

**Checkpoint**: US1 done — old install URL cannot ship unnoticed

---

## Phase 4: User Story 3 - Marketplace catalogs and install docs (P1)

**Goal**: Four catalogs in the plugin root; README install sections; drift check

**Independent Test**: Fresh build lists four catalog paths; hand-edit fails `--check`

- [x] T010 [US3] Implement catalog JSON generation for `.cursor-plugin/marketplace.json`, `.claude-plugin/marketplace.json`, `.agents/plugins/marketplace.json`, and `.github/plugin/marketplace.json` per `contracts/marketplace-catalogs.md`
- [x] T011 [US3] Extend `tests/agent-plugin.test.sh` (or sibling) for catalog presence and drift
- [x] T012 [US3] Expand `framework/plugin/README.md` with install sections for Copilot, Cursor, Claude Code, Codex, Antigravity, and Gemini; Local-mode limits only; regenerate plugin README into `highway-agent-plugin/`

**Checkpoint**: US3 done — catalogs + public README install story

---

## Phase 5: User Story 2 - One-way publish (P1)

**Goal**: `framework/publish-agent-plugin.sh` publishes build as public root with gates

**Independent Test**: `--dry-run` passes on clean build; seeded defects refuse

- [x] T013 [US2] Implement `framework/publish-agent-plugin.sh` per `contracts/publish.md` (build, replace public checkout root, secret scan, version/tag rules, `--dry-run`)
- [x] T014 [US2] Add bash tests for publish refusal paths (drift, forbidden path refs, secret pattern, missing version bump on second release) using temp fixtures — no real push required in unit tests
- [x] T015 [US2] With `highway-systems` credentials available, run a real `framework/publish-agent-plugin.sh` (first publish may keep `0.1.0` / tag `v0.1.0`) and confirm public root matches the local build

**Checkpoint**: US2 done — public repo has the plugin at root

---

## Phase 6: User Story 4 - Harness public-install verification (P2)

**Goal**: `--plugin-source public --plugin-ref` clones pinned ref and smokes four agents

**Independent Test**: CLI rejects public without ref; four public smokes install all skills

- [x] T016 [US4] Add `--plugin-source` and `--plugin-ref` to `harness/src/cli.ts` / help / switch tests per `contracts/harness-plugin-source.md`
- [x] T017 [US4] Resolve public plugin in `harness/src/project.ts` (or sibling): clone `highway-systems/agent-plugin` at ref into a disposable dir; pass as `PluginSource`
- [x] T018 [US4] Update `harness/README.md` for the new switches
- [x] T019 [US4] Run `npm --prefix harness test` and `npm --prefix harness run typecheck`
- [x] T020 [US4] Run public `--smoke` for `copilot`, `cursor`, `claude`, and `codex` with `--plugin-ref` set to the published tag/SHA; save redacted logs under `specs/257-publish-public-install/harness/`; fix install/load failures; record skill-behavior failures in `harness-model-findings.md`

**Checkpoint**: US4 done — pinned public install proven on four drivers

---

## Phase 7: User Story 5 - End-user path without legacy installer (P2)

**Goal**: End-user docs require only the public plugin; no executable; contributor adapter notes OK

**Independent Test**: Review README + getting-started; no legacy installer required

- [x] T021 [US5] Audit and fix any remaining end-user install docs that advertise an executable or adapter/distribution install path for Copilot/Cursor/Claude/Codex
- [x] T022 [US5] Confirm contributor docs still may mention adapters/distribution as internal (no need to delete Phase 9 work)

**Checkpoint**: US5 done — end-user install story matches clarification A

---

## Phase 8: Polish

- [x] T023 [P] Update `rollout-plan.md` Phase 10 status notes if the file is being maintained in-session (gitignored OK)
- [x] T024 Run full `tests/run-all.sh` (D3.2) and confirm URL guard + plugin checks pass
- [x] T025 [P] Walk `specs/257-publish-public-install/quickstart.md` and fix any drift between docs and commands
- [x] T026 Constitution MINOR bump only if a new declared generator or harness obligation requires it; otherwise skip

---

## Dependencies & Execution Order

- Phase 1 → Phase 2 → US1 (Phase 3) → US3 (Phase 4) → US2 (Phase 5) → US4 (Phase 6) → US5 (Phase 7) → Polish
- US3 catalogs should land before US2 publish so the first public tree includes catalogs
- US4 requires US2 real publish (or an already-pushed ref)

### Parallel opportunities

- T002 parallel with T001
- T004 after T003 starts
- T023 / T025 in polish

### MVP

T001–T009 (URL + guard + regenerate) delivers the identity fix without publishing.

### Implementation strategy

Ship US1 → US3 → publish (US2) → harness public smokes (US4) → doc audit (US5) → suite.
