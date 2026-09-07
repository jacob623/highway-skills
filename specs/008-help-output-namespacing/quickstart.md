# Quickstart: Help Output Namespacing

Validation scenarios for this feature. Run from the repository root.

## Prerequisites

- Feature specs/007-highway-skill-namespace already implemented (dot-namespaced adapters exist:
  `.github/skills/highway.help/`, `.claude/skills/highway.help/`, `.cursor/rules/highway.help.mdc`).
- `.highway/tools/tests/run-all.sh` passes before starting (baseline check).

## Scenario 1: Generator produces hyphen-namespaced paths, removes dot-namespaced ones

```bash
.highway/tools/generate-agent-adapters.sh
```

Expected:
- Exit 0.
- `.github/skills/highway-help/SKILL.md`, `.claude/skills/highway-help/SKILL.md`,
  `.cursor/rules/highway-help.mdc` exist and are correct (byte-identical / mdc-transformed per
  [contracts/agent-adapter-contract.md](./contracts/agent-adapter-contract.md)).
- `.github/skills/highway.help/`, `.claude/skills/highway.help/`, `.cursor/rules/highway.help.mdc`
  (the dot-separated artifacts from specs/007) no longer exist.
- `.highway/tools/.adapter-manifest` has no row referencing a dot-separated path.

## Scenario 2: Idempotent second run

```bash
.highway/tools/generate-agent-adapters.sh
```

Expected: exit 0, identical output message set, zero diff against the artifacts from Scenario 1
(no stale-removal messages the second time — both cleanup steps are no-ops now).

## Scenario 3: Single-skill help output for `help`

Request help for the `help` skill (single-skill mode). Expected exactly six lines:

```text
Name: highway-help
Description: Prints registration details for one named skill, or a discovery listing of every registered skill when none is named.
Dependencies: none
Version: 2.0.0
Usage: Invoke as `/highway-help` for all skills, or `/highway-help <skill-id>` for one named skill's registration details.
Example: `/highway-help help`
```

Confirm: `Name:` reads `highway-help` (not `Help`, not `highway.help`); `Usage:` and `Example:`
reference `/highway-help`; `Example:`'s value is wrapped in inline code (backticks) with no other
text inside the span; `Version:` reads `2.0.0` (research.md R6's MAJOR bump).

## Scenario 4: All-skills listing

Request help with no skill identifier declared. Expected one block per catalog entry:

```text
Name: highway-help
Usage: Invoke as `/highway-help` for all skills, or `/highway-help <skill-id>` for one named skill's registration details.
Help: /highway-help help
```

Confirm: `Help:` reads `/highway-help help`, not `/help help`; running that exact string
reproduces Scenario 3's output.

## Scenario 5: Full regression suite

```bash
.highway/tools/tests/run-all.sh
```

Expected: exit 0, same pass count as the pre-feature baseline (all `.test.sh` files pass,
including `generate-agent-adapters.test.sh` and `new-agent-extensibility.test.sh` updated to
assert the hyphen form).

## Scenario 6: `validate-skill.sh` still passes for `help`

```bash
.highway/tools/validate-skill.sh .highway/skills/help
```

Expected: exit 0 — confirms the corrected `usage` text and `## Example` section still satisfy
every existing authoring-standard check.
