# Research: Publish and Public Install

Sources reviewed 2026-11-20: rollout-plan Phase 10, OpenAI plugin packaging docs
(`developers.openai.com/plugins/build/plugins`), existing `generate-agent-plugin.sh` /
`plugin-manifest.sh`, harness `installPlugin` + drivers, and prior marketplace notes in
`specs/248-agent-manifests/research.md`.

## R1. Public repository layout

- Decision: publish the **contents** of `highway-agent-plugin/` as the root of
  `highway-systems/agent-plugin` (already how the empty/public repo is set up). Marketplace
  entries use `source: "./"` (or equivalent local/`./` path relative to the marketplace root).
- Rationale: matches Agent Plugins single-plugin repos and Phase 10 wording; avoids `git-subdir`.
- Alternatives: nest under `highway-agent-plugin/` (rejected: every catalog needs a subdirectory
  source).

## R2. Publish mechanism

- Decision: add `framework/publish-agent-plugin.sh` that (1) runs a fresh plugin build, (2) clones
  or fetches the public remote into a temp worktree, (3) replaces the worktree tree with the build
  (preserving `.git`), (4) refuses on drift from fresh build, on `specs/` or `.specify/` path
  references in the staged tree, or on a simple secret scan (high-entropy / known key prefixes /
  `.env` content patterns), (5) commits, creates an annotated tag when publishing a version that
  does not yet have a tag (first publish: `v0.1.0` if absent), (6) pushes branch + tag. Credentials
  come from the environment / git credential helper for `highway-systems` (not stored in repo).
- Rationale: one maintainer command; works with separate HTTPS credentials already planned; no CI
  vendor lock-in in this spec.
- Alternatives: `git subtree split` (rejected: harder refusal gates and history noise); GitHub
  Actions-only publish (deferred: can wrap the same script later).

## R3. Version policy

- Decision: first publish may keep `0.1.0` and tag `v0.1.0`. Later publishes must bump
  `framework/plugin/plugin.json` `version` above the last published tag before the script will
  push; script compares source version to tags on the public remote.
- Rationale: clarification Session 2026-11-20.
- Alternatives: force bump on first publish (rejected by clarify).

## R4. Marketplace catalogs

- Decision: generate four catalogs into the plugin root as part of `generate-agent-plugin.sh`:
  - `.cursor-plugin/marketplace.json`
  - `.claude-plugin/marketplace.json`
  - `.agents/plugins/marketplace.json` (Codex / agents)
  - `.github/plugin/marketplace.json` (Copilot)
  Each lists plugin `highway` with local source `./` (or the host's equivalent local path form),
  installation policy `AVAILABLE`, and a category consistent with existing listing (`Developer
  Tools` where the format has category). Drift-checked like other generated manifests. Antigravity
  and Gemini: README only (install from repo URL).
- Rationale: Phase 10 / OpenAI marketplace docs; single-plugin repo pattern.
- Alternatives: hand-maintained catalogs (rejected: drift); one shared catalog format (rejected:
  hosts disagree on path and schema).

## R5. URL guard

- Decision: bash test `tests/publish-url.test.sh` (or extension of `agent-plugin.test.sh`) fails if
  any file outside an allowlist contains `jacob623/highway-skills` as an install identity.
  Allowlist: `specs/**`, `harness-model-findings.md`, and other historical paths named in the test.
  Private monorepo `origin` remotes and contributor docs that clearly describe adapters as
  internal are not install identity; the guard targets install command examples and `repository`
  fields in shipped/plugin/source manifests.
- Rationale: FR-004 without false-failing the private git remote documentation.
- Alternatives: ban the string everywhere (rejected: private origin and history).

## R6. Harness public plugin source

- Decision: add `--plugin-source local|public` (default `local`) and `--plugin-ref <tag|sha>`
  (required when `public`). When `public`, clone
  `https://github.com/highway-systems/agent-plugin` at that ref into a temp/cache directory and
  pass that directory as today's `PluginSource.dir` into existing drivers. Refuse to start a
  public run without `--plugin-ref`. Local build path unchanged.
- Rationale: clarification requires pin; all four drivers already install from a local path via
  `installPlugin`; cloning once reuses enforcement. Avoids depending on each agent's remote
  GitHub install UX in the harness.
- Alternatives: call each agent's "install from GitHub URL" API (rejected for this spec: uneven
  support and Copilot local-path deprecation already handled for local installs).

## R7. End-user vs contributor docs

- Decision: `framework/plugin/README.md` (and thus public README) gets per-agent install sections
  for Copilot, Cursor, Claude Code, Codex, Antigravity, Gemini using `highway-systems/agent-plugin`.
  Root / framework contributor docs may still mention adapters and distribution as internal.
- Rationale: clarification Session 2026-11-20.

## R8. Secret scan scope

- Decision: publish script runs a maintainer-local scan: deny `.env` files, private key PEM
  headers, and known token prefixes (`ghp_`, `sk-ant-`, `sk-`, `cursor_`, `AIza`) in staged file
  contents. No new Declared Toolchain binary required.
- Rationale: FR-007 without adding gitleaks to the constitution.
- Alternatives: mandate gitleaks (rejected: not declared; can add later).
