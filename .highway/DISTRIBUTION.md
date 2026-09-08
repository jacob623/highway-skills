# Highway

A portable skill-authoring framework. Skills are authored once and distributed to each supported
agent — GitHub Copilot, Claude Code, and Cursor — through generated adapters, so skill content is
never duplicated or hand-adapted per agent.

## What you have

```text
.highway/
├── skills/        Skill sources, one directory per skill
├── library/       Shared reference material skills draw on
├── catalog/       The generated index of available skills
├── governance/    The rules every skill is validated against
└── tools/         Validators and generators
```

Agent adapters are generated into `.github/skills/`, `.claude/skills/`, and `.cursor/rules/` at the
root of your project.

## Using the skills you have

The skills in this distribution are already registered with your agents. Ask your agent to run one
by name, or ask it what Highway skills are available.

## Authoring your own skill

Create `.highway/skills/<id>/SKILL.md`, then check it and publish it to your agents:

```sh
.highway/tools/validate-skill.sh .highway/skills/<id>
.highway/tools/generate-catalog.sh
.highway/tools/generate-agent-adapters.sh
```

The validator reports one line per rule that failed, each naming the rule id that decided it. The
catalog generator refreshes the index; the adapter generator writes the per-agent copies. Run all
three after any change to a skill.

Both generators refuse to overwrite a file they did not produce, naming it rather than replacing
it. If you see that message, the file was hand-edited — move it aside if regenerating is safe.

## The rules a skill is validated against

Skills are governed by written rules, each with a stable id, an observable condition, and a tier
saying whether it is decided automatically, by an agent, or by a human reviewer.

- [.highway/governance/constitution.md](.highway/governance/constitution.md) — the rules
- [.highway/skills/_authoring-standard.md](.highway/skills/_authoring-standard.md) — how to satisfy
  them when writing a skill

Rule ids are stable. A retired id is never reused, so a citation stays meaningful.

## Requirements

Bash and standard command-line utilities, as shipped with macOS and Linux. Nothing to install, no
package manager, no runtime.
