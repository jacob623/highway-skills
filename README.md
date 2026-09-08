# highway-skills

## Skill Authoring Framework

This repository hosts a portable, multi-agent skill-authoring framework. Skills are authored
once under `.highway/skills/<id>/SKILL.md` and distributed to each supported agent (GitHub
Copilot, Claude Code, Cursor) via generated adapters, so skill content never needs to be
duplicated or hand-adapted per agent.

- **Author a skill**: create `.highway/skills/<id>/SKILL.md` per [.highway/skills/_authoring-standard.md](.highway/skills/_authoring-standard.md).
- **Validate a skill**: `.highway/tools/validate-skill.sh .highway/skills/<id>`
- **Build the catalog**: `.highway/tools/generate-catalog.sh` writes `.highway/catalog/index.json`
  and `.highway/catalog/index.md`.
- **Generate agent adapters**: `.highway/tools/generate-agent-adapters.sh` writes
  `.github/skills/`, `.claude/skills/`, and `.cursor/rules/` from the skills under
  `.highway/skills/`.
- **Run the test suite**: `.highway/tools/tests/run-all.sh`

See [.highway/tools/README.md](.highway/tools/README.md) for full tool documentation (including
how to add a new agent) and [specs/001-multi-agent-skill-suite/quickstart.md](specs/001-multi-agent-skill-suite/quickstart.md)
for an end-to-end walkthrough.

## Governance

A skill is validated against written rules, each carrying a stable id, an Observable, and a tier
that says how it is decided. Two documents govern:

- **[.highway/governance/constitution.md](.highway/governance/constitution.md)** — the Highway
  Skills Constitution. The rules a skill is judged by, in the `P` namespace. Rule text lives here
  and nowhere else.
- **[.highway/skills/_authoring-standard.md](.highway/skills/_authoring-standard.md)** — the
  practical authoring guide. Cites rules by id rather than restating them, so the two cannot
  drift apart.

Run `.highway/tools/validate-skill.sh .highway/skills/<id>` to see which rules are checked
automatically, which were not verified for you, and which your skill failed.
