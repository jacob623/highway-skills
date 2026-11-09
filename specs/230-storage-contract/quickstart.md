# Quickstart: Storage Contract

Run from the repository root.

## 1. The storage contract

Open `.highway/governance/storage.md`. Expect one Operations table with four rows (read a file, check a file exists, list a folder, write a group of files together), a Local entry in each, and `not supported yet` in every Remote and Chat entry.

## 2. The rule fails a seeded violation

```bash
bash .highway/tools/tests/storage-contract.test.sh
```

Expect `PASS: every skill reaches the repository only through the storage contract`. The test seeds one skill per violation kind (script, `git`, absolute path, file time) and expects `ERROR: [P2.6]` for each, and seeds a slash command, a URL, `.gitignore`, a fenced pipeline, and "Emit no timestamp" and expects each to pass.

## 3. Every shipped skill passes

```bash
for d in .highway/skills/highway-*/; do bash .highway/tools/validate-skill.sh "$d" | tail -n 1; done
```

Expect `OK:` for every skill.

## 4. Codify numbers from the Features table

Read `### write` in `.highway/skills/highway-codify/SKILL.md`. Expect the number to come from the last ID in the Features table of `code/<folder>/.highway/metadata.md`, and the sentence "Do not list `code/<folder>/.highway/features/`." Read `.highway/library/templates/output/codify-metadata.md` and expect the `| ID | Folder | Title | Summary |` header.

## 5. Agents see the pointer

```bash
grep -F 'storage.md' AGENTS.md .claude/CLAUDE.md .github/copilot-instructions.md .cursor/rules/highway-agent-context.mdc
```

Expect one match per file.

## 6. Full suite

```bash
bash .highway/tools/tests/run-all.sh
```

Expect `0 failed`.
