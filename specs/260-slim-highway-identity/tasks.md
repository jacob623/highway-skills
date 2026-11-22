# Tasks: Slim Highway Identity

**Input**: Design documents from `specs/260-slim-highway-identity/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

## Phase 1: Setup

- [x] T001 Confirm locked slim substance in `specs/260-slim-highway-identity/spec.md` / `contracts/identity-slim.md`

---

## Phase 2: Foundational

- [x] T002 Note finish-order obligation: skills change requires plugin version bump + regenerate (feature 259)

---

## Phase 3: User Story 1 - Slim identity document (P1) 🎯 MVP

**Goal**: Replace long identity with locked slim wording at the same path

**Independent Test**: File matches locked substance; no “contextual intelligence” essay

- [x] T003 [US1] Replace `skills/highway-experience/references/highway-identity.md` with slim wording (`## What Highway is`, `## Knowledge chain`, `## Boundaries`)
- [x] T004 [US1] Update `tests/constitution-profile-context.test.sh` heading tokens to the new sections
- [x] T005 [US1] Bump `skills/highway-experience/SKILL.md` `metadata.version` to `1.5.0`; align Example if needed

**Checkpoint**: US1 identity file + tests updated

---

## Phase 4: User Story 2 - Direct invoke contract (P1)

**Goal**: Direct-invoke path still ≤5 sentences + highway-help

**Independent Test**: SKILL.md Invoked directly section unchanged in obligation

- [x] T006 [US2] Verify `skills/highway-experience/SKILL.md` direct-invoke and verification lines still require ≤5 sentences, `highway-help`, no gate/writes

**Checkpoint**: US2 intact

---

## Phase 5: User Story 3 - Activation coherence (P2)

**Goal**: Other skills still activate experience for identity

**Independent Test**: `bash tests/experience-activation.test.sh`

- [x] T007 [US3] Run `tests/experience-activation.test.sh` and fix any drift

**Checkpoint**: US3 green

---

## Phase 6: Polish / finish order

- [x] T008 Run `bash tests/run-all.sh --exclude-plugin-gen`
- [x] T009 Bump `framework/plugin/plugin.json` version (strictly greater than baseline)
- [x] T010 Regenerate catalog, adapters, and plugin (`generate-catalog.sh`, `generate-agent-adapters.sh`, `generate-agent-plugin.sh`)
- [x] T011 Run `bash tests/run-all.sh --plugin-gen-only`
- [x] T012 Walk `specs/260-slim-highway-identity/quickstart.md`

---

## Dependencies

T001 → T003 → T004/T005 → T006 → T007 → T008 → T009 → T010 → T011 → T012

## MVP

T001–T007
