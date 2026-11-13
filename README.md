# highway-skills

## Skill Authoring 


This repository hosts a portable, multi-agent skill-authoring framework. Skills are authored
once under `skills/<id>/SKILL.md` and distributed to each supported agent (GitHub
Copilot, Claude Code, Cursor) via generated adapters, so skill content never needs to be
duplicated or hand-adapted per agent.

- **Author a skill**: create `skills/<id>/SKILL.md` per [framework/authoring-standard.md](framework/authoring-standard.md). Its format follows the [Agent Skills specification](https://agentskills.io/specification): `name`, a `description` with a "Use when" sentence, `license: Apache-2.0`, and `metadata` with `version` and `usage`.
- **Create an architecture decision**: invoke `highway-adr` with one completed `DISC######` artifact; the workflow publishes an accepted ADR using its own `assets/adr-record.md` template and adds its row to the seeded `adrs/adrs.md`.
- **Seed the catalogs**: `highway-setup` writes every absent organization catalog, the findings file, and the storage record from `skills/highway-setup/assets/` at the start of each run. A skill that edits a seeded file stops and directs the person to `highway-setup` when it is absent.
- **Keep each skill self-contained**: a skill reads only its own folder. Its templates, references,
  and scripts sit beside its `SKILL.md` in `assets/`, `references/`, and `scripts/`, named by a
  relative path one level deep; `tests/self-contained-skills.test.sh` enforces it.
- **Validate a skill**: `framework/validate-skill.sh skills/<id>` checks the `SKILL.md` and every
  complete template and reference the skill bundles.
- **Build highway-help's index**: `framework/generate-catalog.sh` writes
  `skills/highway-help/assets/index.json`.
- **Generate agent adapters**: `framework/generate-agent-adapters.sh` writes
  `.github/skills/`, `.claude/skills/`, `.cursor/skills/`, and `.agents/skills/` from the skills under
  `skills/`.
  A skill's bundled files, such as `references/<name>.md`, are copied beside its `SKILL.md`.
- **Build the plugin**: `framework/generate-agent-plugin.sh` writes `highway-agent-plugin/`, an
  [Agent Plugins](https://agent-plugins.org) 1.0.0 plugin of every skill, from `skills/` and
  `framework/plugin/`. `framework/validate-plugin.sh highway-agent-plugin` checks it, and the
  behavioral harness installs it into each test agent's home.
- **Share Highway's guidance**: `skills/highway-experience/` holds Highway's identity, the
  Experience Standard, and the storage contract as references. Every other Highway skill opens its
  Procedure by activating it. Highway ships no always-on instruction file.
- **Configure Controls conversationally**: invoke `highway-controls setup` or `highway-controls configure`
  for adaptive Concern, Condition, and Obligation discovery; direct `highway-controls add` creates one Control.
- **Run the test suite**: `tests/run-all.sh`
- **Find a repository location in a script**: source the paths helper,
  `framework/lib/paths.sh`, and use its `HW_*` variables, `hw_template`, `hw_doc`, and
  `hw_seeded`.
  Tests source `tests/paths.sh`; harness scripts source `harness/bin/lib/paths.sh`.

Feature 094 full-suite validation allows up to 240 seconds for completion.

See [framework/README.md](framework/README.md) for full tool documentation (including
how to add a new agent) and [specs/001-multi-agent-skill-suite/quickstart.md](specs/001-multi-agent-skill-suite/quickstart.md)
for an end-to-end walkthrough.

## Governance

A skill is validated against written rules, each carrying a stable id, an Observable, and a tier
that says how it is decided. Two documents govern:

- **[framework/constitution.md](framework/constitution.md)** — the Highway
  Skills Constitution. The rules a skill is judged by, in the `P` namespace. Rule text lives here
  and nowhere else.
- **[framework/authoring-standard.md](framework/authoring-standard.md)** — the
  practical authoring guide. Cites rules by id rather than restating them, so the two cannot
  drift apart.

Run `framework/validate-skill.sh skills/<id>` to see which rules are checked
automatically, which were not verified for you, and which your skill failed.
