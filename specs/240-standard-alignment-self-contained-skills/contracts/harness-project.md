# Contract: harness test project

- `buildSkills(workRoot)` copies every `skills/<name>/` that holds a `SKILL.md` to
  `<workRoot>/base/<agent-skills>/<name>/`. `<agent-skills>` is
  `bash harness/bin/path-map.sh --location agent-skills` (`.github/skills`). It returns the base
  folder, or a `build-failed` failure with check `skills`.
- A scenario project is the base plus the fixture overlay. It holds no `.highway/` and nothing from
  `framework/`, `tests/`, or `harness/`.
- A chain snapshot excludes every path the base supplies.
- `harness/bin/fixture-check.sh` fails a fixture or snapshot holding `.github/skills`,
  `.cursor/skills`, `.claude/skills`, or `.agents/skills`, with the rule "fixtures hold project files
  only; the harness supplies the skills".
- `harness/bin/path-map.sh <file>` maps `skills/highway-help/assets/index.json` to highway-help, and
  has no `.highway` arm.
