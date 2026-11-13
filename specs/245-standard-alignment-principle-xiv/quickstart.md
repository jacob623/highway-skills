# Quickstart: validating Principle XIV

Run from the repository root. The full suite and the generators need an unsandboxed shell (the
generators write under `.claude/`).

## 1. Every skill passes, with the cache off

```bash
for d in skills/*/; do bash framework/validate-skill.sh --no-cache "$PWD/${d%/}" | tail -1; done
```

Expected: 16 `OK:` lines. `CHECKED:` in each report lists P14.1 to P14.4.

## 2. Each seeded breach fails its rule

```bash
bash tests/rule-checks.test.sh
```

Expected: exit 0. The twelve boundary cases each fail exactly one Principle XIV rule (see
[contracts/rule-checks.md](contracts/rule-checks.md)).

## 3. The cache never replays another verdict

```bash
bash tests/validation-cache.test.sh
```

Expected: exit 0, including VC-12 to VC-15
([contracts/validation-cache.md](contracts/validation-cache.md)).

## 4. Constitution inventory

```bash
bash tests/constitution-inventory.test.sh && bash tests/constitution-experience-alignment.test.sh
grep -c '^| P[0-9]*\.[0-9]* ' framework/constitution.md    # 80
grep '^\*\*Version\*\*' framework/constitution.md          # 10.5.0
```

## 5. Generators change nothing

```bash
bash framework/generate-catalog.sh && bash framework/generate-agent-adapters.sh && git status --short
```

Expected: no file under `.github/`, `.cursor/`, `.claude/`, `.agents/`, or
`skills/highway-help/assets/` is modified.

## 6. Full suite

```bash
bash tests/run-all.sh
```

Expected: 86 of 86 pass; `tests/skill-flow-pattern.test.sh` no longer exists.
