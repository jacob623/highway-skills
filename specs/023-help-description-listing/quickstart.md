# Quickstart: Help Description Listing

This guide validates Feature 023 after implementation. It does not prescribe implementation details.

## Prerequisites

- Run commands from the repository root.
- Use a Bash 3.2.57-compatible shell.
- Keep `.highway/catalog/index.json` generated from the source skills.

## 1. Validate the source skill

```sh
.highway/tools/validate-skill.sh .highway/skills/highway-help
```

Expected result: exit 0, with no authoring-contract errors.

## 2. Verify the source contract

Review `.highway/skills/highway-help/SKILL.md` and confirm:

- All-Skills mode declares `Name:`, `Description:`, and `Help: /highway-help <id>` in catalog order.
- All-Skills mode does not declare `Usage:`.
- Single-Skill mode still declares its six fields in order, including `Usage:`.
- Empty-catalog and unknown-identifier responses remain unchanged.

## 3. Regenerate derived artifacts

```sh
.highway/tools/generate-catalog.sh
.highway/tools/generate-agent-adapters.sh
```

Expected result: generated catalog and adapters correspond to the updated source skill without hand-edited generated files.

## 4. Run focused and full validation

```sh
.highway/tools/tests/validate-skill.test.sh
.highway/tools/tests/adapter-coverage.test.sh
.highway/tools/tests/run-all.sh
```

Expected result: focused checks and the complete suite exit 0; the full suite reports zero failures.

## 5. Manual response scenarios

- With a non-empty catalog, `/highway-help` returns one `Name:`/`Description:`/`Help:` block per entry and no All-Skills `Usage:` lines.
- `/highway-help highway-nfrs` returns the existing six-line named-skill response, including `Usage:`.
- An empty catalog returns `No skills are registered yet.`.
- An unknown identifier returns `ERROR: no skill registered with id '<declared-id>'` and no listing.
