# Quickstart: Codify Closing Guide

## Prerequisites

Run from the repository root with Bash 3.2.57 or newer.

## 1. Baseline

```bash
bash .highway/tools/tests/run-all.sh
```

Expect `Summary: <n> passed, 0 failed` before any edit.

## 2. New test fails first

```bash
bash .highway/tools/tests/codify-closing-guide.test.sh
```

Before the skill edits, expect a FAIL naming a missing `## Setup Instructions` heading, the missing completion message, or the missing `### catalog` step.

## 3. After the edits

```bash
bash .highway/tools/tests/codify-closing-guide.test.sh
bash .highway/tools/tests/highway-codify.test.sh
bash .highway/tools/tests/codify-platform-catalog.test.sh
bash .highway/tools/validate-skill.sh .highway/skills/highway-codify
bash .highway/tools/validate-library.sh .highway/library/templates/output/codify-record.md
bash .highway/tools/validate-library.sh .highway/library/templates/output/codify-catalog.md
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

Use [contracts/completion-close.md](contracts/completion-close.md), [contracts/catalog-view.md](contracts/catalog-view.md), and the worked example in [data-model.md](data-model.md).

1. Finish every task of an automation. The README has `## Setup Instructions` then `## User Guide`. The close is the completion message with `code/[ID]/` and `code/[ID]/README.md`, and it says the automation was not run.
2. Stop an automation at a task. The close names that task and does not say the codify stage is complete.
3. Accept a seventh automation. Its row is the last row of `code/code.md`.
4. Run `/highway-codify catalog` with seven accepted automations. The five newest appear, newest first, followed by "2 more automations are not shown." Nothing is written.
5. Name an automation that is not shown. Its files path and README path appear.
