# Research: Plugin Bump on Change

## R1. Closed list of plugin generation–specific checks

- **Decision**: Exactly two suite members: `tests/plugin-version-bump.test.sh` (new) and
  `tests/agent-plugin.test.sh` (existing; owns `generate-agent-plugin.sh --check` drift). Document
  that list in `framework/README.md` and `contracts/suite-plugin-gen-list.md`. No third member
  unless a later feature amends the closed list explicitly.
- **Rationale**: Spec requires a fixed closed list including version-bump and drift/currency;
  `agent-plugin.test.sh` already is the suite’s plugin drift/currency check. Splitting
  `--check` into a third file would duplicate coverage without benefit for MVP.
- **Alternatives**: Semantic “any failing for bump reasons” (rejected in clarify); thin
  `plugin-generate-currency.test.sh` plus keep full `agent-plugin.test.sh` always on (rejected:
  `--check` at the top of `agent-plugin.test.sh` still fails when package is stale, so exclusion
  must cover that file).

## R2. Suite exclude / only invocation

- **Decision**: Extend `tests/run-all.sh` with `--exclude-plugin-gen` (skip the closed list) and
  `--plugin-gen-only` (run only the closed list). Same closed list constant in one place in
  `run-all.sh`.
- **Rationale**: Matches finish order steps 1 and 5 without teaching maintainers ad-hoc env vars.
- **Alternatives**: Environment-only skip (less discoverable); manual “don’t run these files”
  (not enforceable).

## R3. Version-bump guard mechanics

- **Decision**: Bash test computes `git merge-base HEAD main` (or `origin/main` if local `main`
  missing — prefer `main` then `origin/main`). Diff covered paths in working tree + index vs that
  baseline using `git diff --name-only` with unstaged/staged and, for untracked covered files,
  `git ls-files --others`. Read baseline version via `git show <base>:framework/plugin/plugin.json`.
  Compare current `framework/plugin/plugin.json` version with Python3 strict `major.minor.patch`
  tuple greater-than. Version-only changes (no other covered path diffs after ignoring the version
  field) do not require a further bump — implement by: if the only covered-file change is
  `framework/plugin/plugin.json` and a content diff of that file with the version line normalized
  away is empty, treat as no bump required.
- **Rationale**: Matches clarify (working tree, semver, version-only exempt, fail closed).
- **Alternatives**: Commit-only diff (rejected); string inequality (rejected); remote public tag
  as baseline (deferred to publish pipeline).

## R4. Covered input paths

- **Decision**: Covered paths are `skills/` (entire tree of tracked/untracked files under it) and
  `framework/plugin/` (plugin source: `plugin.json`, `listing.json`, `README.md`, `LICENSE`,
  `assets/`). Do not include `highway-agent-plugin/` (generated output).
- **Rationale**: Spec FR-003; generator reads skills + `framework/plugin/`.
- **Alternatives**: Skills-only (rejected in clarify).

## R5. Spec Kit constitution amendment

- **Decision**: MINOR bump of `.specify/memory/constitution.md`: extend Correspondence / D4.7
  guidance (or add a sibling auto rule if the constitution’s pattern requires a new ID) stating
  that when covered plugin-build inputs change, feature close follows the finish order (excluded
  suite → bump → regenerate → plugin-gen checks), and the version-bump guard enforces greater
  semver. Do not amend `framework/constitution.md`.
- **Rationale**: FR-009; user ownership of Spec Kit development constitution only.
- **Alternatives**: Docs-only (rejected); Skills Constitution (rejected).

## R6. This feature’s own exit and version bump

- **Decision**: Feature 259 itself does not change covered plugin-build inputs (skills /
  `framework/plugin/` content except possibly docs under framework README outside plugin/). No
  plugin version bump or publish is required for 259’s own exit. If implement accidentally edits
  covered inputs, follow the finish order.
- **Rationale**: Spec assumes current tree already published; 259 is suite/docs/constitution.
- **Alternatives**: Always bump on 259 (unnecessary noise).
