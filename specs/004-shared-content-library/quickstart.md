# Quickstart: Validating the Shared Content Library

Validation scenarios that prove this feature end-to-end. Each command is expected to run in
under 2 seconds (SC-performance budget carried over from feature 003).

## Prerequisites

- Working tree at repository root.
- `.highway/tools/tests/run-all.sh` passes before starting (baseline unaffected by this
  feature).

## 1. Directories exist and are recognized

```sh
test -d .highway/content/templates
test -d .highway/content/knowledge
test -d .highway/content/governance
```

Expected: all three succeed (FR-001).

## 2. A valid shared file passes content validation

```sh
.highway/tools/validate-content.sh .highway/tools/tests/fixtures/content/governance/valid/policy.md
```

Expected: `OK: content 'governance/<name>' is valid (...)`, exit 0 (User Story 2, Scenario 3
analog for a conforming file).

## 3. A rule violation in governance/knowledge is caught by rule ID

```sh
.highway/tools/validate-content.sh .highway/tools/tests/fixtures/content/governance/invalid-bad-citation/policy.md
```

Expected: an `ERROR: [P3.5] ...` line and `FAILED: content '...' violates 1 rule(s)`, exit 1
(User Story 2, Scenario 1; SC-003).

## 4. A template's placeholder text does not misfire

```sh
.highway/tools/validate-content.sh .highway/tools/tests/fixtures/content/templates/valid/output-shape.md
```

The fixture's placeholder body intentionally contains the literal word "MUST" as illustrative
output text. Expected: exit 0, and the coverage summary's `N/A:` group contains
`P1.1=N2 P1.3=N2 P7.4=N2 P7.5=N2` (User Story 2, Scenario 4; SC-004; Decision 1).

## 5. A skill with a valid dependency resolves it

Dependency paths resolve anchored at the real `.highway/` root (FR-007), so this scenario
creates its target file and skill directory at run time rather than using a static fixture
(the same setup `tools/tests/dependency-check.test.sh` automates):

```sh
cat > .highway/content/knowledge/_quickstart-target.md <<'EOF'
---
name: Quickstart Dependency Target
description: "Temporary file for quickstart scenario 5-7; delete after running."
metadata:
  version: 1.0.0
---

## Purpose
Temporary quickstart fixture.
EOF
mkdir -p /tmp/quickstart-valid-dep
awk '/^metadata:/ { print; getline; print; print "  dependencies:"; print "    - path: content/knowledge/_quickstart-target.md"; print "      version: 1.0.0"; next } { print }' \
  .highway/tools/tests/fixtures/valid-skill/SKILL.md > /tmp/quickstart-valid-dep/SKILL.md
.highway/tools/validate-skill.sh /tmp/quickstart-valid-dep
```

Expected: exit 0, no `[DEPENDENCY]` findings (User Story 1, Scenario 1).

## 6. A missing dependency path fails, naming the path

```sh
mkdir -p /tmp/quickstart-missing-dep
awk '/^metadata:/ { print; getline; print; print "  dependencies:"; print "    - path: content/knowledge/does-not-exist.md"; print "      version: 1.0.0"; next } { print }' \
  .highway/tools/tests/fixtures/valid-skill/SKILL.md > /tmp/quickstart-missing-dep/SKILL.md
.highway/tools/validate-skill.sh /tmp/quickstart-missing-dep
```

Expected: `ERROR: [DEPENDENCY] dependency 'content/knowledge/does-not-exist.md' does not exist`,
exit 1 (User Story 1, Scenario 2; SC-002).

## 7. A version-pin mismatch fails, naming expected vs. actual

```sh
mkdir -p /tmp/quickstart-stale-dep
awk '/^metadata:/ { print; getline; print; print "  dependencies:"; print "    - path: content/knowledge/_quickstart-target.md"; print "      version: 0.9.0"; next } { print }' \
  .highway/tools/tests/fixtures/valid-skill/SKILL.md > /tmp/quickstart-stale-dep/SKILL.md
.highway/tools/validate-skill.sh /tmp/quickstart-stale-dep
```

Expected: `ERROR: [DEPENDENCY] dependency '_quickstart-target.md' pinned at
version 0.9.0, current version is 1.0.0` (path shown abbreviated here; the actual message names
the full `content/knowledge/_quickstart-target.md` path), exit 1 (SC-007).

## 8. Discovery listing includes every file, grouped by type

```sh
.highway/tools/generate-content-catalog.sh
cat .highway/catalog/content-index.json
```

Expected: `entries` contains one object per file under `.highway/content/`, each carrying
`content_type`, `name`, `description`, `version`, `source_path`; zero omissions (User Story 3;
SC-005).

## 9. Reference resolution is independent of working directory

```sh
cd /tmp && "$OLDPWD/.highway/tools/validate-skill.sh" /tmp/quickstart-valid-dep; cd "$OLDPWD"
rm -rf /tmp/quickstart-valid-dep /tmp/quickstart-missing-dep /tmp/quickstart-stale-dep
rm -f .highway/content/knowledge/_quickstart-target.md
```

Expected: identical result to step 5, run from repository root (FR-007; SC-006). The final two
lines also clean up every temp artifact created by steps 5-9.

## 10. Full suite still passes

```sh
.highway/tools/tests/run-all.sh
```

Expected: every test passes, including the new `validate-content.test.sh`,
`generate-content-catalog.test.sh`, and `dependency-check.test.sh`.
