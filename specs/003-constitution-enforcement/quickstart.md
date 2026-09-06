# Quickstart: Mechanical Enforcement of the Constitution

Validation guide to run after implementation. Confirms the feature's success criteria hold.

## Prerequisites

- Constitution 2.0.1 or later in effect at `.specify/memory/constitution.md`.
- Implementation complete for Group A. Group B (rule P6.4) requires amendment 2.0.2; if that
  amendment has not landed, P6.4 is expected to appear under `UNCHECKED`.

## 1. The rule inventory is read from the constitution (FR-001, FR-002)

```bash
.highway/tools/validate-skill.sh .highway/tools/tests/fixtures/valid-skill | grep -E '^(CHECKED|FAILED|N/A|DEFERRED|UNCHECKED):'
```

**Expected outcome**: five group lines are printed. Every rule ID defined in the constitution
appears in exactly one group. Confirm the total matches the constitution:

```bash
grep -cE '^\| P[0-9]+\.[0-9]+ ' .specify/memory/constitution.md
```

The two counts are equal. If a rule ID is missing from the output, the inventory parse has
drifted from the constitution's table format.

## 2. Failures name the rule that was violated (FR-003, SC-002)

Create a skill that violates one rule and confirm the rule ID is reported.

```bash
mkdir -p /tmp/seed-skill
cat > /tmp/seed-skill/SKILL.md <<'EOF'
---
name: Seed Skill
description: "Fixture used to confirm that a violated rule is reported by its rule id."
compatibility: all
metadata:
  version: 1.0.0
---

## When to use
Use when confirming rule-level reporting. Use also when demonstrating a seeded violation.

## When not to use
Never use for real work.

## Inputs
None.

## Outputs
A confirmation message.

## Verification
Confirm the output names the violated rule.

## Error Handling
- If validation does not name a rule id, abort and report the failure.
EOF

.highway/tools/validate-skill.sh /tmp/seed-skill; echo "exit: $?"
```

**Expected outcome**: exits `1`. Output contains `ERROR: [P7.1]` because the `## Purpose`
section is absent. Repeat for each enforced rule by seeding the corresponding violation; every
one reports its own rule ID.

Clean up:

```bash
rm -rf /tmp/seed-skill
```

## 3. Every artifact in the repository conforms (SC-001)

```bash
for d in .highway/skills/*/ .highway/tools/tests/fixtures/valid-skill; do
  [ -f "$d/SKILL.md" ] && .highway/tools/validate-skill.sh "$d" >/dev/null || echo "FAILED: $d"
done
echo "done"
```

**Expected outcome**: no `FAILED:` lines. Fixtures that exist to demonstrate a failure are
excluded here and are covered by the test suite instead.

## 4. Deferred and unchecked rules never pass silently (FR-005, SC-006)

```bash
.highway/tools/validate-skill.sh .highway/tools/tests/fixtures/valid-skill | grep -E '^(DEFERRED|UNCHECKED):'
```

**Expected outcome**: both lines are present. `DEFERRED` lists the rules whose tier requires
judgment. No rule appears in both `CHECKED` and `DEFERRED`.

## 5. The full test suite passes (SC-003)

```bash
.highway/tools/tests/run-all.sh
```

**Expected outcome**: every test passes, including the rewritten fixture suites for catalog and
adapter generation.

## 6. No stale paths remain anywhere in the tooling directory (FR-013, SC-004)

```bash
grep -rn --exclude-dir=.git -E '(^|[^.])\b(tools|skills|catalog)/' .highway/ | grep -v '\.highway/'
```

**Expected outcome**: no matches. Unlike the earlier check, this covers every file beneath
`.highway/` rather than a fixed list of documents, so fixture prose is included.

## 7. The authoring standard restates no rule text (SC-005)

```bash
grep -c 'P[0-9]\.[0-9]' .highway/skills/_authoring-standard.md
```

**Expected outcome**: a non-zero count, confirming the checklist cites rule IDs. Then confirm no
rule text is duplicated:

```bash
grep -oE '^\| P[0-9]+\.[0-9]+ \| [^|]+' .specify/memory/constitution.md \
  | sed -E 's/^\| P[0-9]+\.[0-9]+ \| //' \
  | while read -r rule; do
      grep -qF "$rule" .highway/skills/_authoring-standard.md && echo "DUPLICATED: $rule"
    done
echo "done"
```

**Expected outcome**: no `DUPLICATED:` lines.

## 8. Validation is fast enough to use while authoring

```bash
time .highway/tools/validate-skill.sh .highway/tools/tests/fixtures/valid-skill >/dev/null
```

**Expected outcome**: completes in under 2 seconds on the reference platform.
