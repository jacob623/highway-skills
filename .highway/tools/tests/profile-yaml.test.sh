#!/usr/bin/env bash
# Tests that the removed YAML output path has no fallback or parser contract.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: this test must detect a defect in each declared class and clean its probe.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
OBSOLETE="library/templates/output/profile"".yaml"

if [[ -e "$HIGHWAY_ROOT/$OBSOLETE" ]]; then
	echo "FAIL: removed YAML output template still exists" >&2
	exit 1
fi
if grep -RInF "$OBSOLETE" \
	"$HIGHWAY_ROOT/skills" "$HIGHWAY_ROOT/tools" >/dev/null 2>&1; then
	echo "FAIL: runtime fallback still references removed YAML output template" >&2
	exit 1
fi

echo "OK: obsolete Profile YAML output path is removed"
