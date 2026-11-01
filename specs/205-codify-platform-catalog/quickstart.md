# Quickstart: Codify Platform Catalog

## Prerequisites

Run from the repository root with Bash 3.2.57 or newer.

## 1. Baseline

```bash
bash .highway/tools/tests/run-all.sh
```

Expect `Summary: <n> passed, 0 failed` before any edit.

## 2. New test fails first

```bash
bash .highway/tools/tests/codify-platform-catalog.test.sh
```

Before the skill edits, expect a FAIL naming a missing inclusion sentence, a missing `configure` step, or the old provider rule in [contracts/provider-diagram.md](contracts/provider-diagram.md).

## 3. After the edits

```bash
bash .highway/tools/tests/codify-platform-catalog.test.sh
bash .highway/tools/validate-skill.sh .highway/skills/highway-implementation
bash .highway/tools/validate-skill.sh .highway/skills/highway-codify
bash .highway/tools/validate-skill.sh .highway/skills/highway-onboarding
bash .highway/tools/validate-library.sh .highway/library/templates/output/codify-platforms.md
bash .highway/tools/validate-library.sh .highway/library/templates/output/codify-record.md
bash .highway/tools/validate-library.sh .highway/library/templates/output/codify-tasks.md
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

1. Accept an implementation of Cursor that starts work as an agent. The catalog gains one Cursor row, and the message names `/highway-codify configure`.
2. Accept Shopify. The catalog is unchanged and that message is absent.
3. Run `/highway-codify configure`, remove Cursor, and add a pipeline. Cursor is gone. The pipeline remains as a system the person added. No automation is written.
4. Propose a Shopify automation while Cursor is included. Every task's Provider is Cursor. The diagram shows Cursor performing each action. It does not refuse Cursor because the Shopify records omit it.
5. Open the Cursor implementation without accepting it. The catalog stays as it was.
