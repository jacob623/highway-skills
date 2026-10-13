# Quickstart: Profile Structured Proposals

## Prerequisites

Run from the repository root on macOS or another environment with Bash 3.2-compatible shell tools.
The source Profile skill, generated adapters, and existing test tree must be present.

## Validate the source skill

```sh
bash .highway/tools/validate-skill.sh .highway/skills/highway-profile
```

Expected outcome: the Profile skill passes schema, governance, and Experience Standard validation.

## Run the focused contract test

```sh
bash .highway/tools/tests/feature-167-profile-structured-proposals.test.sh
```

Expected outcome: the test confirms Vision, Competitive Path, and Guiding Principles contribution
opportunities, proposal-first ordering, structured presentation, correction and fallback guidance,
provisional boundaries, preserved convergence behavior, and source-to-adapter equality.

## Regenerate adapters

```sh
bash .highway/tools/generate-agent-adapters.sh
```

Expected outcome: the Profile adapters under `.github/`, `.claude/`, `.cursor/`, and `.agents/` are
regenerated from the source without drift.

## Run the complete verification suite

```sh
bash .highway/tools/tests/run-all.sh
```

Expected outcome: every repository contract test passes, including the focused Feature 167 test.

## Review criteria

- Vision, Competitive Path, and Guiding Principles use structured starting points when accepted
  evidence supports responsible interpretations.
- Each starting point invites the person to add, correct, or remove substance and remains a Working
  Idea rather than an acceptance request.
- Focused questioning remains available when accepted evidence cannot support a responsible
  starting point.
- Existing convergence, acceptance, persistence, readiness, ownership, attribution, and retained
  artifact behavior remain unchanged.
- Generated Profile adapters remain equivalent to the source skill.
