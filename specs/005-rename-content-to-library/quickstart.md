# Quickstart: Validating the Rename

Validation scenarios that prove this feature end-to-end. Each command is expected to run in
under 2 seconds (SC-performance budget carried over from feature 004).

## Prerequisites

- Working tree at repository root.
- `.highway/tools/tests/run-all.sh` passes before starting (baseline unaffected by this
  feature).

## 1. The old directory is gone, the new one exists with the same contents

```sh
test ! -e .highway/content && echo "old path absent: OK"
test -d .highway/library/templates && test -d .highway/library/knowledge && test -d .highway/library/governance && echo "new paths present: OK"
```

Expected: both echo lines print (FR-001, FR-002; SC-001).

## 2. The renamed validator resolves a library file

```sh
.highway/tools/validate-library.sh .highway/tools/tests/fixtures/library/governance/valid/policy.md
```

Expected: `OK: library 'governance/<name>' is valid (...)`, exit 0.

## 3. The `[LIBRARY-TYPE]` tag replaces `[CONTENT-TYPE]`

```sh
.highway/tools/validate-library.sh .highway/tools/tests/fixtures/library/invalid-orphan/orphan.md
```

Expected: `ERROR: [LIBRARY-TYPE] ...`, exit 1 (FR-008).

## 4. The renamed catalog generator writes the renamed artifacts

```sh
.highway/tools/generate-library-catalog.sh
cat .highway/catalog/library-index.json
```

Expected: `entries` contains one object per file under `.highway/library/`, each carrying
`library_type` (not `content_type`), `name`, `description`, `version`, `source_path`; no
`content-index.json` file exists anywhere under `.highway/catalog/` (FR-008; SC-004).

## 5. A dependency declared with the old `content/...` prefix fails

```sh
mkdir -p /tmp/quickstart-old-prefix
awk '/^metadata:/ { print; getline; print; print "  dependencies:"; print "    - path: content/knowledge/does-not-exist.md"; print "      version: 1.0.0"; next } { print }' \
  .highway/tools/tests/fixtures/valid-skill/SKILL.md > /tmp/quickstart-old-prefix/SKILL.md
.highway/tools/validate-skill.sh /tmp/quickstart-old-prefix 2>&1 | grep DEPENDENCY
rm -rf /tmp/quickstart-old-prefix
```

Expected: `ERROR: [DEPENDENCY] dependency 'content/knowledge/does-not-exist.md' does not exist`
— the old prefix is not silently translated, it just fails like any other missing path
(FR-004; SC-003).

## 6. A dependency declared with the new `library/...` prefix resolves

```sh
mkdir -p /tmp/quickstart-new-prefix
awk '/^metadata:/ { print; getline; print; print "  dependencies:"; print "    - path: library/knowledge/does-not-exist.md"; print "      version: 1.0.0"; next } { print }' \
  .highway/tools/tests/fixtures/valid-skill/SKILL.md > /tmp/quickstart-new-prefix/SKILL.md
.highway/tools/validate-skill.sh /tmp/quickstart-new-prefix 2>&1 | grep DEPENDENCY
rm -rf /tmp/quickstart-new-prefix
```

Expected: `ERROR: [DEPENDENCY] dependency 'library/knowledge/does-not-exist.md' does not exist`
— resolution is anchored at `.highway/library/`, not `.highway/content/` (FR-003; SC-003).

## 7. Zero residue of the old path in live files

```sh
grep -rln '\.highway/content' . \
  --exclude-dir=.git \
  --exclude-dir=specs 2>/dev/null | grep -v '^\./specs/00[1-4]' || echo "zero residue: OK"
```

Expected: `zero residue: OK` (SC-004). (Historical files under `specs/001-...` through
`specs/004-...` are excluded per FR-007 and are expected to still mention the old path.)

## 8. Full suite still passes

```sh
.highway/tools/tests/run-all.sh
```

Expected: every test passes, including the renamed `validate-library.test.sh` and
`generate-library-catalog.test.sh` (SC-002).
