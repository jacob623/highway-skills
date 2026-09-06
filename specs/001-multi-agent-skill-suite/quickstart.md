# Quickstart: Multi-Agent Skill Suite

Validation guide for the skill-authoring framework delivered by this feature. Use this to prove
the framework works end-to-end before or after implementation.

## Prerequisites

- A POSIX shell environment (macOS/Linux, or CI) with `bash`, `awk`, `grep` available.
- This repository checked out with `tools/`, `skills/`, and `catalog/` present (created by this
  feature's implementation tasks).

## 1. Author a sample skill

```bash
mkdir -p skills/sample-echo
cat > skills/sample-echo/SKILL.md <<'EOF'
---
name: sample-echo
description: "Example skill used only to validate the authoring framework end-to-end."
compatibility: all
metadata:
  version: 1.0.0
---

## When to use
Use this skill only to validate the multi-agent skill suite's tooling.

## When not to use
Do not use for real tasks; this is a framework validation fixture.

## Inputs
None.

## Outputs
A confirmation message.

## Verification
Confirm the message "sample-echo validated" is produced.

## Error Handling
If any step fails, abort and report the failing step; do not retry silently.
EOF
```

**Expected outcome**: `skills/sample-echo/SKILL.md` exists and conforms to
[contracts/skill-frontmatter.schema.json](./contracts/skill-frontmatter.schema.json).

## 2. Validate the skill

```bash
tools/validate-skill.sh skills/sample-echo
```

**Expected outcome**: Exit code `0` and a success message. Introducing a deliberate error (e.g.,
deleting the `metadata.version` field) MUST make this command fail with a non-zero exit code and
a message naming the missing field (see [data-model.md](./data-model.md) failure handling).

## 3. Generate the catalog

```bash
tools/generate-catalog.sh
cat catalog/index.json
```

**Expected outcome**: `catalog/index.json` contains an entry for `sample-echo` matching
[contracts/catalog.schema.json](./contracts/catalog.schema.json), and `catalog/index.md` lists it
human-readably. Re-running the command with no source changes MUST produce a byte-identical
`catalog/index.json` (aside from `generated_at`).

## 4. Generate per-agent adapters

```bash
tools/generate-agent-adapters.sh
ls .github/skills/sample-echo/SKILL.md .claude/skills/sample-echo/SKILL.md .cursor/rules/sample-echo.mdc
```

**Expected outcome**: All three paths exist. `.github/skills/sample-echo/SKILL.md` and
`.claude/skills/sample-echo/SKILL.md` are byte-identical to `skills/sample-echo/SKILL.md`.
`.cursor/rules/sample-echo.mdc` follows the transform in
[contracts/agent-adapter-contract.md](./contracts/agent-adapter-contract.md). Existing
`.github/skills/speckit-*` folders are untouched.

## 5. Confirm cross-agent portability (SC-001)

Invoke the sample skill from at least 2 of the 3 supported agents (GitHub Copilot, Claude Code,
Cursor) and confirm both produce the "sample-echo validated" outcome without any edit to
`skills/sample-echo/SKILL.md`.

## 6. Add a new agent without editing existing skills (SC-002)

Add a new `agent_id` entry to `tools/generate-agent-adapters.sh` (per
[contracts/agent-adapter-contract.md](./contracts/agent-adapter-contract.md)) and re-run it.
**Expected outcome**: the new agent's adapter is generated; `skills/sample-echo/SKILL.md` is not
modified.

## 7. Clean up the fixture

```bash
rm -rf skills/sample-echo .github/skills/sample-echo .claude/skills/sample-echo .cursor/rules/sample-echo.mdc
tools/generate-catalog.sh
```

**Expected outcome**: `catalog/index.json` no longer references `sample-echo`.
