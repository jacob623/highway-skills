# Quickstart: Consolidate Skill Suite Support Files into `.highway/`

Validation guide to prove the relocation was performed correctly. Use this after implementation
to confirm the feature's success criteria hold.

## Prerequisites

- This repository, with the relocation implemented: `.highway/skills/`, `.highway/tools/`, and
  `.highway/catalog/` present; old top-level `skills/`, `tools/`, `catalog/` absent.

## 1. Confirm the repository root is decluttered (SC-001)

```bash
ls -1 .
```

**Expected outcome**: No top-level `skills/`, `tools/`, or `catalog/` entries. A single
`.highway/` entry exists alongside the unchanged `.github/`, `.claude/`, `.cursor/`,
`.specify/`, `specs/`, and root `README.md`.

```bash
ls -1 .highway
```

**Expected outcome**: `skills/`, `tools/`, and `catalog/` are present under `.highway/`.

## 2. Confirm the tooling still works end-to-end (SC-002, SC-003)

```bash
mkdir -p .highway/skills/sample-echo
cat > .highway/skills/sample-echo/SKILL.md <<'EOF'
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

.highway/tools/validate-skill.sh .highway/skills/sample-echo
.highway/tools/generate-catalog.sh
cat .highway/catalog/index.json
.highway/tools/generate-agent-adapters.sh
ls .github/skills/sample-echo/SKILL.md .claude/skills/sample-echo/SKILL.md .cursor/rules/sample-echo.mdc
diff -q .highway/skills/sample-echo/SKILL.md .github/skills/sample-echo/SKILL.md
diff -q .highway/skills/sample-echo/SKILL.md .claude/skills/sample-echo/SKILL.md
```

**Expected outcome**: Validation exits `0`. The catalog contains a `sample-echo` entry under
`.highway/catalog/`. All three adapter paths are created at their unchanged, original locations
(`.github/skills/`, `.claude/skills/`, `.cursor/rules/`), and the two identity-copy adapters are
byte-identical to the relocated source. This proves the dual-root resolution (research.md
Decision 1) works: the tooling reads from `.highway/` but still writes agent adapters to the true
repository root.

Clean up the fixture:

```bash
rm -rf .highway/skills/sample-echo .github/skills/sample-echo .claude/skills/sample-echo .cursor/rules/sample-echo.mdc
.highway/tools/generate-catalog.sh
```

## 3. Run the full test suite (SC-002)

```bash
.highway/tools/tests/run-all.sh
```

**Expected outcome**: Every test passes, with no changes to what each test asserts (only their
own location and internal path references changed).

## 4. Confirm `speckit-*` folders and spec-kit scaffolding are untouched

```bash
ls .github/skills/ | grep speckit
ls .specify specs
```

**Expected outcome**: All pre-existing `speckit-*` skill folders and the `.specify/`/`specs/`
directories are present and unaffected by this feature.

## 5. Confirm documentation has no stale references (SC-004)

```bash
grep -rn '](skills/\|](tools/\|](catalog/\|`skills/\|`tools/\|`catalog/' README.md .highway/tools/README.md .highway/catalog/README.md .highway/skills/_authoring-standard.md
```

**Expected outcome**: No matches (all references already point at `.highway/`-relative paths).
