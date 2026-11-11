# Quickstart: Standard Alignment Relocation

Run from the repository root. Run the bash suite outside the sandbox.

## 1. Full suite and harness tests

```bash
bash tests/run-all.sh
(cd harness && node --test "test/*.test.ts")
```

Expected: every test passes.

## 2. The layout

```bash
ls skills; ls -a framework; ls tests | head; ls -a .highway
test ! -e .highway/tools && test ! -e .highway/skills && echo gone
```

Expected: 15 skill folders and nothing else in `skills/`; `framework/` per
[the data model](data-model.md); `.highway/` holds `catalog`, `governance`, `instructions`, and
`library`; `gone`.

## 3. No `SKILL.md` changed

```bash
git diff --stat -M HEAD -- .highway/skills skills | tail -1
```

Expected: renames only, 0 insertions and 0 deletions.

## 4. Regeneration and leftovers

```bash
bash framework/generate-agent-adapters.sh && bash framework/generate-catalog.sh && bash framework/generate-instructions.sh
git status --porcelain .claude .cursor .github .agents .highway/catalog AGENTS.md
grep -c 'mock-agent-4' framework/.adapter-manifest; ls -d .*/skills/test-* 2>/dev/null
```

Expected: only the leftover deletions appear in status; `0`; no folder listed.

## 5. The distribution

```bash
bash tests/distribution-packaging.test.sh
d=$(mktemp -d)/dist; bash framework/generate-distribution.sh "$d" && ls -a "$d" "$d/.highway" && ls "$d/.highway/skills" | wc -l
```

Expected: pass; `README.md` at the root, no `framework/` or `tests/`, `.highway/skills/` with 15
skills.

## 6. Old locations are gone from live files

```bash
rg -n '\.highway/(tools|skills/_authoring|governance/constitution|library/knowledge/frontmatter-lexicon)|\.highway/DISTRIBUTION' framework tests harness README.md governance-plan.md .specify/memory
```

Expected: no match outside historical Sync Impact Reports.

## 7. The harness and the check

```bash
bash harness/bin/path-map.sh --location framework
bash harness/bin/path-map.sh skills/highway-adr/SKILL.md framework/validate-skill.sh tests/run-all.sh
bash tests/path-construction.test.sh
```

Expected: `framework`; a skill selection, then two `none` lines; pass.
