# Evidence: Add Codex as a Supported Agent

## Baseline (D3.1)

- Command: `.highway/tools/tests/run-all.sh`
- Date: 2026-09-29
- Summary: 62 passed, 0 failed
- Exit status: 0
- Elapsed: 224s
- Tree state: feature 098 outputs present. No Codex files yet.

## Foundational checks

- `.agents/skills/` did not exist before the Codex row was added.
- `AGENT_IDS`, `AGENT_TARGET_TEMPLATES`, and `AGENT_TRANSFORMS` were each one physical line (lines 17–19) before the `codex` row was added, and each remains one physical line after it.

Speckit sentinels, recorded before generation. Each hash matches `HEAD` after both publishers ran.

| Path | sha256 |
|---|---|
| `.cursor/skills/speckit-analyze/SKILL.md` | `7deb401f0e53be0264722db1c2d401b279ca64ad3fc886a186de39f7ffd5be42` |
| `.cursor/skills/speckit-checklist/SKILL.md` | `057a2bd2cc91184a6a0b3b2e0fcf6704d4ef55cc1c5939b40e1968431ee10061` |
| `.cursor/skills/speckit-clarify/SKILL.md` | `e1a1ddba9346721f41e7b8d0ad278b54d69399c0625db9d753756fd33e51a6e1` |
| `.cursor/skills/speckit-constitution/SKILL.md` | `442e1c84f9a9f2267700cf08157b2aff65e00abae687689f639ce8f62ff8b6f5` |
| `.cursor/skills/speckit-converge/SKILL.md` | `aca98c2c55ba124dbddc467642dc90c673f7657ff750b9a93d89916058dded0d` |
| `.cursor/skills/speckit-implement/SKILL.md` | `df979ca34543fbde2336626752ef72020aa68f4b38c2d108a2da4473113977db` |
| `.cursor/skills/speckit-plan/SKILL.md` | `3d13e010accc60766db3549a52f598e643f5f6c26570a475df418c7a74ba4cbb` |
| `.cursor/skills/speckit-specify/SKILL.md` | `d0b83970b14be40bd1dcd5d3c15f3186c37ebebbe4617dda7e8d487763b70f79` |
| `.cursor/skills/speckit-tasks/SKILL.md` | `24e873a5a7adb75e832b6100d6c9140b0a0df4b9650ba32b8102e37697332beb` |
| `.cursor/skills/speckit-taskstoissues/SKILL.md` | `225297f98e77807dd261ea5692ca0a5b286902d7c9b4855fc30b93f4283ce0a6` |
| `.github/skills/speckit-analyze/SKILL.md` | `0b5d1d053de3d181cd5c4d9c307a273abf67fd4be0023e67e0c8082d73baa35b` |
| `.github/skills/speckit-checklist/SKILL.md` | `057a2bd2cc91184a6a0b3b2e0fcf6704d4ef55cc1c5939b40e1968431ee10061` |
| `.github/skills/speckit-clarify/SKILL.md` | `e1a1ddba9346721f41e7b8d0ad278b54d69399c0625db9d753756fd33e51a6e1` |
| `.github/skills/speckit-constitution/SKILL.md` | `442e1c84f9a9f2267700cf08157b2aff65e00abae687689f639ce8f62ff8b6f5` |
| `.github/skills/speckit-converge/SKILL.md` | `f73713dcbd10aa7b252bfae1400a63a606f033fe9492b44f77a0cb1ab40ac090` |
| `.github/skills/speckit-implement/SKILL.md` | `df979ca34543fbde2336626752ef72020aa68f4b38c2d108a2da4473113977db` |
| `.github/skills/speckit-plan/SKILL.md` | `3d13e010accc60766db3549a52f598e643f5f6c26570a475df418c7a74ba4cbb` |
| `.github/skills/speckit-specify/SKILL.md` | `d0b83970b14be40bd1dcd5d3c15f3186c37ebebbe4617dda7e8d487763b70f79` |
| `.github/skills/speckit-tasks/SKILL.md` | `24e873a5a7adb75e832b6100d6c9140b0a0df4b9650ba32b8102e37697332beb` |
| `.github/skills/speckit-taskstoissues/SKILL.md` | `225297f98e77807dd261ea5692ca0a5b286902d7c9b4855fc30b93f4283ce0a6` |

## User Story 1

- `generate-agent-adapters.sh` exit 0. Agent id `codex`, target `.agents/skills/%s/SKILL.md`, transform `identity-copy`.
- 12 `cmp` matches between `.highway/skills/<id>/SKILL.md` and `.agents/skills/<id>/SKILL.md`: highway-objectives, highway-help, highway-controls, highway-inquiry, highway-nfrs, highway-profile, highway-relationships, highway-setup, highway-new, highway-discovery, highway-clarify, highway-adr.
- `speckit-*` paths under `.agents/skills/`: 0.
- Adapter manifest gained 12 `.agents/skills/` rows. The previous rows are unchanged as a sorted set.
- `generate-agent-adapters.test.sh` exit 0.
- `new-agent-extensibility.test.sh` exit 0.
- A second `generate-agent-adapters.sh` run left `.adapter-manifest` byte-identical.

## User Story 2

- `generate-instructions.sh` exit 0.
- `AGENTS.md` matches `.claude/CLAUDE.md` and `.github/copilot-instructions.md`.
- Heading `# Highway Agent Context` is line 1.
- Merged-file sha256: `7759c4bb8a9cb22ce2d19347247af526401ee377bef3a2872c0b5d8be4a20dd6`.
- Instruction-manifest row: `AGENTS.md`, id `highway-agent-context`, that hash.
- A second run left `AGENTS.md`, both other merged files, and `.instruction-manifest` byte-identical.
- `generate-instructions.test.sh` exit 0. It checks `AGENTS.md` against Claude for the live instruction, the two-instruction join (`# First`, blank line, `# Second`), and the empty set's single newline.

## User Story 3

| Test | Exit |
|---|---|
| `adapter-coverage.test.sh` | 0 |
| `instruction-coverage.test.sh` | 0 |
| `highway-new.test.sh` | 0 |
| `distribution-packaging.test.sh` | 0 |
| `shipped-tree-independence.test.sh` | 0 |

Distribution at `/var/folders/8c/l35mvmf55dn9fxmfqxg81ll40000gn/T/tmp.JKY5fQ2MYQ/dist`:

- `generate-distribution.sh` exit 0
- 120 paths included
- PASS: no distributed file references a development-only location
- PASS: 7 cross-references resolve within the distribution
- PASS: skill validator succeeded against 12 skills using only distribution contents
- `$D/.agents/skills/highway-help` present
- `$D/AGENTS.md` matches the repository `AGENTS.md`
- `speckit-*` paths in the distribution: 0

## User Story 4

- `.highway/tools/.frontmatter-contract` compatibility enum includes `codex`.
- `.highway/skills/_authoring-standard.md` compatibility list includes `codex`. `git diff --name-only -- .highway/skills` names only that file.
- Development constitution version 2.2.0, last amended 2026-09-29. Declared agent trees: `github-copilot`, `claude-code`, `cursor`, `codex`. Sync impact report lists the version line, the last-amended date, and that sentence. D4.5 and D4.6 rule text were left as they were.
- `README.md`, `.highway/tools/README.md`, and `.highway/DISTRIBUTION.md` name Codex, `.agents/skills/<id>/SKILL.md`, and `AGENTS.md`. `DISTRIBUTION.md` contains neither `specs/` nor `.specify/`.

## Suite after the last edit (D3.2)

- Command: `.highway/tools/tests/run-all.sh`
- Date: 2026-09-29
- Summary: 62 passed, 0 failed
- Exit status: 0
- Elapsed: 236s

## Quickstart

| Step | Result |
|---|---|
| 1. Codex skills match | `generate-agent-adapters.sh` exit 0. 12 `cmp` lines. Zero `speckit-*` under `.agents/skills/`. Second run left the adapter manifest byte-identical. |
| 2. Repository guidance | `generate-instructions.sh` exit 0. `AGENTS.md` matches both merged files. Heading present. Second run left `AGENTS.md` and `.instruction-manifest` byte-identical. |
| 3. Hand edit refused | In a temporary copy, appending a line to `.agents/skills/highway-help/SKILL.md` made `generate-agent-adapters.sh` exit 1, named that path, and left the line. Appending a line to `AGENTS.md` made `generate-instructions.sh` exit 1, named `AGENTS.md`, and left the line. |
| 4. Existing skills and speckit | The only diff under `.highway/skills/` is `_authoring-standard.md`. All 20 speckit `SKILL.md` hashes match `HEAD`. |
| 5. Tests | The seven quickstart tests each exited 0 (see User Stories 1–3). |
| 6. Distribution | Exit 0, Codex skill directory shipped, `AGENTS.md` shipped, zero `speckit-*` paths, three existing verifications passed. |
| 7. Seen in Codex | Left for a person. A Cursor session that also shows `AGENTS.md` is an observation and does not fail this feature. |

## Completion report

Stated separately from the suite result above.

| ID | Result | Evidence |
|---|---|---|
| FR-001 | Met | Agent id `codex` is the fourth row in `generate-agent-adapters.sh`, beside `github-copilot`, `claude-code`, and `cursor`. |
| FR-002 | Met | 12 `.agents/skills/<id>/SKILL.md` files, each `cmp`-identical to the canonical skill. |
| FR-003 | Met | No `SKILL.md` under `.highway/skills/` changed. Zero `speckit-*` paths were created under `.agents/skills/`, and all 20 existing speckit hashes match `HEAD`. The authoring standard's compatibility list is the only skills-tree edit, and it is the change T020 requires. |
| FR-004 | Met | `AGENTS.md` is byte-identical to `.claude/CLAUDE.md` and `.github/copilot-instructions.md` and contains `# Highway Agent Context`. |
| FR-005 | Met | Second skill publish and second instruction publish produced 0 byte differences. |
| FR-006 | Met | Hand-edited Codex skill and hand-edited `AGENTS.md` were each refused, named, and left in place. Publishers still have no delete path. |
| FR-007 | Met | Distribution includes the 12 `.agents/skills/highway-<id>` directories and `AGENTS.md`, excludes the rest of `.agents`, contains 0 `speckit-*` paths, and passed its three verifications. |
| FR-008 | Met | `codex` is in the frontmatter enum and the authoring-standard list. Existing skills stay `compatibility: all` and were published to Codex. |
| FR-009 | Met | Constitution 2.1.0 → 2.2.0 (MINOR). Declared agent trees include `codex`. The Codex copies exist in this same change. |
| FR-010 | Met | `README.md`, `.highway/tools/README.md`, and `.highway/DISTRIBUTION.md` name Codex and both repository locations. |
| FR-011 | Met | No path under a home directory was written or added to the distribution. |
| SC-001 | Met | 12 of 12 Highway skills are present for Codex and match the canonical files. |
| SC-002 | Met | 0 `SKILL.md` files under `.highway/skills/` changed. |
| SC-003 | Met | `AGENTS.md` matches both merged files and contains Highway Agent Context. |
| SC-004 | Met | Second publish produced 0 byte differences in the Codex skill files and in `AGENTS.md`. |
| SC-005 | Met | Distribution contains the Codex skills and `AGENTS.md`, 0 `speckit-*` paths, and passed its existing verifications. |
| SC-006 | Met | Suite exit 0 before the first edit (62 passed) and after the last edit (62 passed). |
| SC-007 | Open | A person still needs to open the repository in Codex and confirm Highway Agent Context loads from `AGENTS.md` and the Highway skills appear as Codex skills. |
