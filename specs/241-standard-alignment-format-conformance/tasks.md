# Tasks: Standard Alignment Agent Skills Format Conformance

**Input**: Design documents from `specs/241-standard-alignment-format-conformance/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

**Tests**: Requested by the spec (US2, FR-010–FR-012, SC-002) and required by the development
constitution (D3.3, D3.6, D3.7, D3.9).

**Organization**: by user story. US1 and US2 share the validator, so the parser library and the
manifest come first.

## Format: `[ID] [P?] [Story] Description`

## Phase 1: Setup

- [X] T001 Confirm the baseline suite result in `/tmp/hw-baseline-241.log` (expect 85 passed); record the verdicts with `bash /tmp/hw238-verdicts.sh > /tmp/hw241-verdicts-before.txt` (D3.1)
- [X] T002 Confirm `python3 -c 'import yaml'` exits 0 on this machine, and record the Python and PyYAML versions in `research.md` R1

---

## Phase 2: Foundational (blocking)

- [X] T003 Create `framework/lib/yaml-frontmatter.sh` with `yf_parse <file>`. It extracts the block between the first two `---` lines, parses it with `python3 -c` (SafeLoader subclass, duplicate keys rejected, mapping required), and prints `scope<TAB>key<TAB>type<TAB>escaped-value` lines or one `ERROR: [SCHEMA]` line per [data-model.md](data-model.md). Add `yf_value <parsed> <scope> <key>` and `yf_type <parsed> <scope> <key>` helpers that read the parsed text without another process.
- [X] T004 Rewrite `framework/.frontmatter-contract` to the seven rows in research R4 (`name`, `description` length 1–1024, `license`, `compatibility` length 1–500, `allowed-tools`, `metadata.version`, `metadata.usage` length 1–500)
- [X] T005 Record the D3.4 fixture verdicts in `data-model.md` before wiring the new checks (already drafted; verify against T003's behavior on each fixture)

**Checkpoint**: the parser runs standalone on every skill and fixture.

---

## Phase 3: User Story 1 — Clients load every skill (P1) 🎯 MVP

**Goal**: every `SKILL.md` has only specification fields, parses as strict YAML with string
metadata, and carries `license: Apache-2.0`.

**Independent test**: quickstart §2. Every skill's top-level keys are
`name description license metadata`, and `yf_parse` succeeds on all 16.

- [X] T006 [US1] Rewrite each of the 16 `skills/*/SKILL.md` frontmatter blocks:
  - move `usage` under `metadata` as `usage`;
  - remove `compatibility`;
  - add `license: Apache-2.0` after `description`;
  - bump `metadata.version` per research R9.
- [X] T007 [US1] Update `framework/generate-catalog.sh`: read `usage` with `fm_get_nested … metadata usage`, and remove `dependencies_json` and the `dependencies` field
- [X] T008 [P] [US1] Move the 12 skill fixtures in `tests/fixtures/*/SKILL.md` to the new shape:
  - `usage` under `metadata`;
  - no `compatibility`;
  - add `license: Apache-2.0` and a "Use when" sentence;
  - keep each fixture's one defect.
  - Repurpose `invalid-skill-short-description` as an empty description.
  - Make `invalid-skill-long-description` exceed 1,024 characters.
  - Remove `invalid-skill-unrecognized-word` (with `rm` on its file and `rmdir`).
- [X] T009 [P] [US1] Update the inline seed skills in `tests/rule-checks.test.sh` and `tests/storage-contract.test.sh` to the new frontmatter shape

**Checkpoint**: frontmatter conforms; the validator is not yet updated.

---

## Phase 4: User Story 2 — The validator enforces the specification (P1)

**Goal**: `framework/validate-skill.sh` rejects every specification violation, with findings per
[contracts/validator-format-checks.md](contracts/validator-format-checks.md).

**Independent test**: `bash tests/agent-skills-format.test.sh` passes, and each seeded violation
fails.

- [X] T010 [US2] Write `tests/agent-skills-format.test.sh`:
  - declare `# Artifact classes: skill-source`;
  - support `--probe skill-source` and `--neutralise`;
  - check that every skill validates;
  - seed one violation per specification rule: unknown field, non-string metadata value, `name` over 64, uppercase or hyphen-edge name, name mismatch, empty or over-1,024 description, over-500 compatibility, YAML syntax error, duplicate key, non-mapping frontmatter, missing `metadata.usage`;
  - seed a description without "Use when";
  - check that the parser and line readers agree on every skill;
  - check that no invocation prefix appears outside `## Example`;
  - check that the retired files and functions are absent.
  - Run it and observe it failing before T011 to T015 (D3.6).
- [X] T011 [US2] In `framework/lib/schema-validate.sh`:
  - replace `sv_validate_closed_key_set` and `sv_validate_duplicate_keys` with parser-based checks over `yf_parse` output;
  - add `sv_validate_string_types`, `sv_validate_agreement`, and `sv_validate_lengths` (`name` ≤ 64, `compatibility` 1–500);
  - make `sv_validate_usage` read `metadata.usage`;
  - remove `sv_validate_compatibility`'s enum logic, `_sv_parse_enum_constraint`, and `sv_validate_agent_exceptions`;
  - update `sv_validate_required_keys` to skip the keys with bespoke checks.
- [X] T012 [US2] In `framework/validate-skill.sh`:
  - source `yaml-frontmatter.sh`;
  - run `yf_parse` once, so a parse failure stops the frontmatter checks;
  - wire the new `sv_*` checks;
  - remove the lexicon, agent_exceptions, and dependency blocks and their `source` lines.
- [X] T013 [P] [US2] In `framework/lib/frontmatter.sh`, remove `fm_get_agent_exceptions` and `fm_get_dependencies`, and update the header and `fm_list_*` comments
- [X] T014 [P] [US2] Remove `framework/lib/dependency-check.sh` and `tests/dependency-check.test.sh`, with `rm` on each file
- [X] T015 [P] [US2] Update `framework/lib/frontmatter-contract.sh` comments, which list the `enum:` token. Keep the `enum:` token valid in `fc_validate_manifest`; no row uses it.
- [X] T016 [US2] Run every fixture and record its verdicts against `data-model.md`; update the fixture-driven tests (`tests/validate-skill*.test.sh`, `tests/frontmatter-contract*.test.sh`, and any test asserting the old messages) to the new findings, naming the superseded behavior (D3.5)

**Checkpoint**: the validator decides the specification; every skill passes.

---

## Phase 5: User Story 3 — Descriptions say when to use; the word list is retired (P2)

**Goal**: every description has "Use when" (P5.15, P5.16), the lexicon is gone, and highway-help
prints five lines.

**Independent test**: quickstart §2 and §5; `tests/help-output-single.test.sh`.

- [X] T017 [US3] Add P5.15 (`[auto]`) and P5.16 (`[agent-checkable]`) to Principle V of `framework/constitution.md`, and bump it 10.3.0 → 10.4.0 with a Sync Impact Report
- [X] T018 [US3] Add `rc_check_P5_15` to `framework/lib/rule-checks.sh`. Register it with `N4`, return 2 for files not named `SKILL.md`, and add P5.15 to the bundled and template exemption lists if `check_bundled` would otherwise judge templates by it.
- [X] T019 [US3] Rewrite the 16 descriptions in `skills/*/SKILL.md` to "<what it does>. Use when <condition from ## When to use>." (research R10)
- [X] T020 [US3] Retire the word list:
  - remove `framework/frontmatter-lexicon.txt`, `framework/lib/frontmatter-lexicon.sh`, and `tests/frontmatter-lexicon.test.sh`;
  - remove the `frontmatter-lexicon` case from `framework/lib/paths.sh`;
  - remove the lexicon path from the environment hash in `framework/lib/validation-cache.sh`;
  - remove the lexicon alternative from the pattern in `tests/path-construction.test.sh`.
- [X] T021 [US3] Update `skills/highway-help/SKILL.md`:
  - single-skill output is five lines without `Dependencies:`;
  - all-skills `Help: highway-help <id>`;
  - the Example shows the new version and usage.
  - Update `tests/help-output-single.test.sh` and `tests/help-output-all.test.sh`.

---

## Phase 6: User Story 4 — Invocation-neutral text (P2)

**Goal**: no `/`, `$`, or `highway:` prefix before a skill name outside `## Example`
([contracts/invocation-text.md](contracts/invocation-text.md)).

**Independent test**: `/tmp/hw241-scan.sh skills` prints nothing (quickstart §3).

- [X] T022 [US4] Rewrite every slash mention outside `## Example` in `skills/*/SKILL.md`, `skills/*/references/*`, and `skills/*/assets/*` to `highway-<id>`. This includes the setup message "Run highway-setup to get started." and `metadata.usage` "Run highway-<id> …".
- [X] T023 [US4] Update the tests that pin the slash text (research R11):
  - `adr-span-progression`, `adr-record-completeness`, `codify-config-skill`, `codify-closing-guide`;
  - `catalog-seeding`, `codify-feature-wording`, `codify-file-layout`, `configure-handoff`;
  - `generate-catalog`, `help-output-all`, `highway-codify`, `storage-contract`, `propose-edit-lines`;
  - any others the suite reveals.
- [X] T024 [US4] Update `harness/scenarios/**` `shows:` lines (`request-setup-needed`) and the `covers:` hashes for reworded bullets, and update `harness/coverage/treatments.txt`

---

## Phase 7: User Story 5 — Documents defer to the specification (P3)

**Goal**: the documents name the Agent Skills specification as the authority on skill format,
and the Declared Toolchain lists the parser.

- [X] T025 [US5] Amend `.specify/memory/constitution.md` 3.4.0 → 3.5.0 (research R8):
  - add D3.9 with its Observable and an Enforcement Map row for `agent-skills-format.test.sh`;
  - add `python3` with PyYAML to the Declared Toolchain;
  - add the Governance authority paragraph;
  - add a Sync Impact Report explaining D2.4.
- [X] T026 [P] [US5] Update `framework/authoring-standard.md`'s required-frontmatter block and table to cite the Agent Skills specification and show the new shape; remove the lexicon and dependency sections
- [X] T027 [P] [US5] Update `framework/README.md` and `README.md`: remove the lexicon and dependency material, name `python3` with PyYAML as a prerequisite, and describe the new frontmatter
- [X] T028 [US5] Update `standard-alignment.md`: Phase 12 status note and table row, and the `license` step naming Apache-2.0

---

## Phase 8: Polish

- [X] T029 Regenerate with `bash framework/generate-catalog.sh && bash framework/generate-agent-adapters.sh`; run it twice and confirm the second run changes nothing
- [X] T030 Run `bash harness/bin/inventory.sh` (or the harness's coverage check) and fix every stale hash
- [X] T031 Run the full suite `bash tests/run-all.sh` (expect 84 passed), then, separately, the harness tests and `tsc`
- [X] T032 Compare `/tmp/hw238-verdicts.sh` output with `/tmp/hw241-verdicts-before.txt`. The only expected change is P5.15 added to CHECKED.
- [X] T033 Confirm `rollout-plan.md` is still gitignored and excluded in the distribution manifest; mark every task `[X]`

---

## Implementation Notes

- D3.1: the baseline suite passed 85 of 85 before the first edit, and the verdicts were recorded.
- D3.6: before the documentation tasks, `tests/agent-skills-format.test.sh` failed with
  `FAIL: retired function still referenced under framework/: dc_validate_dependencies`. Its
  seeded probe exited 1, and its neutralised probe exited 0.
- The first full run after the edits failed three tests, which pinned superseded behavior:
  - `authoring-standard`: documenting `metadata.dependencies`; it now requires every manifest
    field to be documented;
  - `constitution-experience-alignment`: a 74-rule count, now 76;
  - `validation-cache` VC-4: removing a top-level `usage:` line, now the nested `  usage:` line.
- Final: suite 84 of 84, harness 82 of 82, `tsc` clean, and two regenerations identical. The only
  verdict changes are P5.15 checked and P5.16 deferred on every skill, plus the fixture messages
  recorded in `data-model.md`.
- The new rules are P5.15 and P5.16, not P5.14 and P5.15: P5.14 is retired, and a retired ID is
  never reused.

## Dependencies & Execution Order

- Setup → Foundational → US1 → US2. US2's validator expects the new shape.
- US3 depends on US2, because P5.15 runs through the validator. US4 depends on US1, because `metadata.usage` text moves there.
- US5 can run after US2.
- Polish runs last.

## Parallel Opportunities

- T008 and T009 touch only test files.
- T013, T014, and T015 touch different framework files.
- T026 and T027 touch different docs.

## Implementation Strategy

US1 and US2 together are the MVP: every skill conforms, and the validator proves it. US3 and US4
finish the content changes; US5 finishes the documents.
