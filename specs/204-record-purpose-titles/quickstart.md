# Quickstart: Record Purpose Titles

## Prerequisites

Run from the repository root with Bash 3.2.57 or newer.

## 1. Baseline

```bash
bash .highway/tools/tests/run-all.sh
```

Expect `Summary: <n> passed, 0 failed` before any edit.

## 2. New test fails first

```bash
bash .highway/tools/tests/record-purpose-titles.test.sh
```

Before the skill edits, expect a FAIL naming the copied-title sentence or a missing rule from [contracts/record-titles.md](contracts/record-titles.md).

## 3. After the edits

```bash
bash .highway/tools/tests/record-purpose-titles.test.sh
bash .highway/tools/validate-skill.sh .highway/skills/highway-architecture
bash .highway/tools/validate-skill.sh .highway/skills/highway-implementation
bash .highway/tools/validate-skill.sh .highway/skills/highway-adr
bash .highway/tools/validate-skill.sh .highway/skills/highway-onboarding
bash .highway/tools/validate-library.sh .highway/library/templates/output/architecture-record.md
bash .highway/tools/validate-library.sh .highway/library/templates/output/implementation-record.md
```

Expect a pass from each.

## 4. Regenerate and run the suite

```bash
bash .highway/tools/generate-library-catalog.sh
bash .highway/tools/generate-catalog.sh
bash .highway/tools/generate-agent-adapters.sh
bash .highway/tools/tests/run-all.sh
```

Expect `0 failed`.

## 5. Manual scenarios

Use the worked examples in [data-model.md](data-model.md).

1. Accept "Adopt Notion for teacher scheduling". Run `/highway-architecture`. The proposal shows **Title:** Teacher scheduling.
2. Run `/highway-implementation` for that architecture. The proposal shows **Title:** Notion.
3. Create a second Notion implementation for a different architecture. The proposal shows **Title:** Notion for [that decision's purpose].
4. Edit the architecture title to "Notion scheduling". The product is left out and is said to belong on the implementation.
5. Open an existing record with an "Adopt …" title. Its title stays the same.
