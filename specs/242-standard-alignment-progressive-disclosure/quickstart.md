# Quickstart: Validating Progressive Disclosure

Run from the repository root. Run neither the suite nor the harness while the other is running.

## Prerequisites

- Bash 3.2 or later, and the Declared Toolchain.
- For live runs: Node 24 (`/Applications/Cursor.app/Contents/Resources/app/resources/helpers/node`
  works), `harness/node_modules`, and a Copilot token in `harness/.env`
  (`COPILOT_GITHUB_TOKEN=` or `GITHUB_TOKEN=`).

## 1. Pre-change smoke run (gate)

```bash
node harness/src/cli.ts --smoke --transcripts specs/242-standard-alignment-progressive-disclosure/harness/pre-smoke
```

Expected: exit 0, with every smoke scenario (one per skill) passing. Otherwise stop ([live-harness-evidence](contracts/live-harness-evidence.md)).

Recorded: run `20261112-162017Z-smoke-49ab958` passed 6 of 16 on unchanged skills. It is the
baseline, and its failures are in `harness-model-findings.md`.

## 2. Boundaries

```bash
bash tests/skill-flow-pattern.test.sh
bash tests/skill-flow-pattern.test.sh --probe source-document
bash tests/skill-flow-pattern.test.sh --probe source-document --neutralise
```

Expected:
- before the split, the verdicts in [data-model.md](data-model.md#validation-baseline-d34);
- after the split, `PASS`;
- the probe reports each seeded boundary;
- the neutralised run passes.

## 3. Validator

```bash
for d in skills/*/; do framework/validate-skill.sh "$d/SKILL.md" >/dev/null || echo "FAIL $d"; done
bash tests/validate-skill.test.sh
```

Expected: no `FAIL`, and the flow-kind cases pass ([validator-flow-kind](contracts/validator-flow-kind.md)).

## 4. Sizes

```bash
for f in skills/*/SKILL.md skills/*/references/*.md; do printf '%s %s %s\n' "$(wc -l <"$f")" "$(wc -c <"$f")" "$f"; done | sort -n
```

Expected: the router `SKILL.md` and every flow file show ≤ 500 lines and ≤ 20,000 characters.
highway-experience's references are not flow files.

## 5. Inventory

```bash
harness/bin/inventory.sh highway-codify | cut -f2 | sort | uniq -c
```

Expected: the same step, verification, and error counts as before the split. Every `covers:` hash
in `harness/scenarios/` still resolves (`bash tests/harness-coverage.test.sh`, or the suite).

## 6. Regenerate and suite

```bash
framework/generate-catalog.sh && framework/generate-agent-adapters.sh
framework/generate-catalog.sh && framework/generate-agent-adapters.sh   # second run: no change
bash tests/run-all.sh
```

Expected: the second run changes nothing (`git status` is the same), and the suite passes.

## 7. Post-change live runs

```bash
node harness/src/cli.ts --smoke --transcripts specs/242-standard-alignment-progressive-disclosure/harness/post-smoke
node harness/src/cli.ts --changed-since main
```

Expected: no worse than the baseline, scenario by scenario
([live-harness-evidence](contracts/live-harness-evidence.md#no-worse-than-the-baseline)), and no
transcript contains the token value.
