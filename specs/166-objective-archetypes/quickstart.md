# Quickstart: Objective Archetypes

## Prerequisites

Run from the repository root on macOS or another environment with Bash 3.2-compatible shell tools.
The source skill, generated adapters, and existing test tree must be present.

## Validate the source skill

```sh
bash .highway/tools/validate-skill.sh .highway/skills/highway-objectives
```

Expected outcome: the Objective skill passes schema, governance, and experience validation.

## Run the focused contract test

```sh
bash .highway/tools/tests/feature-166-objective-archetypes.test.sh
```

Expected outcome: the test confirms the Objective Archetypes section placement, all four families,
Profile-first recommendation guidance, coverage-gap boundaries, hidden internal terminology, the
existing recommendation and lifecycle limits, and source-to-adapter equality.

## Regenerate adapters

```sh
bash .highway/tools/generate-agent-adapters.sh
```

Expected outcome: the Objective adapters under `.github/`, `.claude/`, `.cursor/`, and `.agents/`
are regenerated from the source without drift.

## Run the complete verification suite

```sh
bash .highway/tools/tests/run-all.sh
```

Expected outcome: every repository contract test passes, including the focused Feature 166 test.

## Review criteria

- Profile-derived recommendations remain preferred when accepted Profile evidence supports them.
- Archetype-derived recommendations appear only for useful coverage gaps and are presented as one
  unified recommendation set.
- The person sees Objectives, not archetype families, recommendation sources, or coverage mechanics.
- No new Objective state, persisted artifact, schema, readiness requirement, or acceptance path exists.
- Generated adapters remain byte-identical to the source Objective skill.
