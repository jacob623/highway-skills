# Feature 076 Quickstart

Run from the repository root:

```sh
.specify/scripts/bash/setup-plan.sh --json
.specify/scripts/bash/check-prerequisites.sh --json --paths-only
.highway/tools/tests/highway-adr.test.sh
.highway/tools/tests/output-template.test.sh
.highway/tools/tests/validate-skill.test.sh
.highway/tools/tests/adapter-coverage.test.sh
.highway/tools/tests/run-all.sh
```

Implementation sequence:

1. Edit `.highway/skills/highway-adr/SKILL.md` and the ADR output templates only.
2. Extend focused ADR and output-template fixtures for the contract and failure-path rules.
3. Regenerate `.highway/catalog/`, `.github/skills/`, `.claude/skills/`, and `.cursor/rules/` with the existing generators.
4. Run focused tests, adapter coverage, validators, then the full suite.
5. Confirm `git diff --check` and verify no generated artifact was hand-edited.

Expected implementation evidence:

- focused ADR/template tests pass;
- invalid fixtures fail before writes and preserve bytes;
- generated copies match canonical sources;
- full repository suite reports zero failures.
