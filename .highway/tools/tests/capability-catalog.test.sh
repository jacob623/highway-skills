#!/usr/bin/env bash
# Verifies the Feature 184 Capability Catalog contract.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document generated-artifact
# Seeded failure probe: --probe source-document exercises the probe contract; --neutralise restores it.

probe_class=""
neutralise=0
while [[ $# -gt 0 ]]; do
	case "$1" in
		--probe) probe_class="${2:-}"; shift 2 ;;
		--neutralise) neutralise=1; shift ;;
		*) echo "FAIL: unrecognized argument: $1" >&2; exit 2 ;;
	esac
done
DECLARED_CLASSES=" source-document generated-artifact "
if [[ -n "$probe_class" ]] && [[ "$DECLARED_CLASSES" != *" $probe_class "* ]]; then
	echo "FAIL: undeclared artifact class: $probe_class" >&2
	exit 2
fi
if [[ -n "$probe_class" ]]; then
	probe_root="$(mktemp -d "${TMPDIR:-/tmp}/capability-catalog.XXXXXX")"
	probe_path="$probe_root/probe.md"
	trap 'rm -rf "$probe_root"' EXIT
	if [[ "$neutralise" -eq 1 ]]; then
		printf '%s\n' 'capability catalog contract token' >"$probe_path"
	else
		printf '%s\n' 'missing required token' >"$probe_path"
	fi
	grep -Fq 'capability catalog contract token' "$probe_path"
	exit $?
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILL="$HIGHWAY_ROOT/skills/highway-implementation/SKILL.md"
RECORD_TEMPLATE="$HIGHWAY_ROOT/library/templates/output/implementation-record.md"
CATALOG_TEMPLATE="$HIGHWAY_ROOT/library/templates/output/implementation-catalog.md"
CAPABILITY_CATALOG_TEMPLATE="$HIGHWAY_ROOT/library/templates/output/capability-catalog.md"
fail=0

require_text() {
	local file="$1" text="$2"
	if [[ ! -f "$file" ]] || ! grep -Fq -- "$text" "$file"; then
		echo "FAIL: '$text' missing from $file"
		fail=1
	fi
}

for text in \
	"one or more Realized By" \
	"implementations/capabilities.md" \
	"CAP" \
	'Do not write a `CAP` record file.' \
	'Do not allocate from `Next ID`.'; do
	require_text "$SKILL" "$text"
done

require_text "$SKILL" ".highway/library/templates/output/capability-catalog.md"

for text in \
	"## Realized Capabilities" \
	"Title: <business-recognizable outcome>" \
	"Realized By:" \
	"Evidence:"; do
	require_text "$RECORD_TEMPLATE" "$text"
done

for text in \
	"# Capability Catalog" \
	"CAP plus eight hex digits" \
	"## Capability Index" \
	"| ID | Parent | Title | Realized By |" \
	'no `Next ID` field'; do
	require_text "$CAPABILITY_CATALOG_TEMPLATE" "$text"
done

fixture_root="$(mktemp -d "${TMPDIR:-/tmp}/capability-catalog-fixture.XXXXXX")"
trap 'rm -rf "$fixture_root"' EXIT
fixture="$fixture_root/capabilities.md"
cat >"$fixture" <<'EOF'
# Capability Catalog

Version: 1.0.0

Next ID: CAP000003

## Capability Index

| ID | Parent | Title | Realized By |
|----|--------|-------|-------------|
| CAP000001 | RI000001 | E-Commerce | Amazon; Shopify |
| CAP000002 | RI000002 | E-Commerce | Shopify |
EOF

# Multiple providers stay in one row, while the same title under another RI stays distinct.
grep -Fq '| CAP000001 | RI000001 | E-Commerce | Amazon; Shopify |' "$fixture" || fail=1
grep -Fq '| CAP000002 | RI000002 | E-Commerce | Shopify |' "$fixture" || fail=1

# Rows are ordered by parent, title, and identifier, and no standalone CAP record exists.
first_row="$(grep -n '| CAP' "$fixture" | sed -n '1p')"
second_row="$(grep -n '| CAP' "$fixture" | sed -n '2p')"
[[ "$first_row" < "$second_row" ]] || fail=1
! find "$fixture_root" -name 'CAP*.md' -print | grep -q . || fail=1

# Invalid row shapes are detectable before publication.
invalid="$fixture_root/invalid.md"
printf '%s\n' '| CAP000003 | | E-Commerce | Shopify |' >"$invalid"
if grep -Eq '^\| CAP[0-9]{6} \| \| ' "$invalid"; then
	:
else
	fail=1
fi

if (( fail != 0 )); then
	exit 1
fi
printf '%s\n' 'PASS: capability catalog contract'
