# Quickstart: validating Phase 7

Run from the repository root. The bash suite and the harness tests must not run at the same time.

## 1. Layout

```bash
find skills/highway-experience -type f | sort
ls .highway                       # catalog and library only
ls AGENTS.md .claude/CLAUDE.md .github/copilot-instructions.md .cursor/rules 2>&1   # all absent
```

Expected:

- four files under `skills/highway-experience`: `SKILL.md` and the three references;
- `.highway` without `governance/` or `instructions/`;
- each always-on path reported as missing.

## 2. Moved content

```bash
git show HEAD:.highway/governance/experience-standard.md | diff - skills/highway-experience/references/experience-standard.md
git show HEAD:.highway/library/knowledge/highway-identity.md | diff - skills/highway-experience/references/highway-identity.md
```

Expected: no output.

## 3. Activation and old paths

```bash
bash tests/experience-activation.test.sh
grep -rn '\.highway/governance\|knowledge/highway-identity' skills/ || echo none
```

Expected: PASS, and `none`.

## 4. Validator verdicts

Compare the `--no-cache` verdict of every skill and fixture with the baseline recorded before the
move ([research.md](research.md) R9). Only version lines differ.

## 5. Generated artifacts

```bash
framework/generate-catalog.sh && framework/generate-agent-adapters.sh && git status --short .highway/catalog .github .claude .cursor .agents framework/.adapter-manifest
```

Expected: after the first regeneration is committed to the working tree, a second run changes nothing.

## 6. Distribution

```bash
d="$(mktemp -d)/dist" && framework/generate-distribution.sh "$d" && find "$d" -path '*highway-experience*' -type f | sort
```

Expected:

- `.highway/skills/highway-experience/` and each agent tree hold all four files;
- no `AGENTS.md`, `CLAUDE.md`, `copilot-instructions.md`, `.cursor/rules/`, `.highway/governance/`,
  or `.highway/instructions/`.

## 7. Suites

```bash
bash tests/run-all.sh
cd harness && /Applications/Cursor.app/Contents/Resources/app/resources/helpers/node --test "test/*.test.ts"
bash harness/bin/path-map.sh skills/highway-experience/references/storage-contract.md
```

Expected:

- the bash suite reports 81 passed, 0 failed;
- every harness test passes;
- the path map prints `smoke smoke`.
