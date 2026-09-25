#!/usr/bin/env bash
# Verifies production runtime paths contain durable contracts, not development-history identifiers.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
fail=0
FR_TOKEN='FR-'"[0-9]+"
FEATURE_TOKEN='Feature '"[0-9]+"
SPECS_TOKEN='spec'"s/"
SPECIFY_TOKEN='.'"specify/"
runtime_paths=("$HIGHWAY_ROOT/skills/highway-profile" "$HIGHWAY_ROOT/skills/highway-setup" "$HIGHWAY_ROOT/library/templates/output/profile-record.md")
for path in "${runtime_paths[@]}"; do
	if grep -RInE "$FR_TOKEN|$FEATURE_TOKEN|$SPECS_TOKEN|$SPECIFY_TOKEN|[0-9]{3}-[a-z0-9-]+/(plan|tasks|spec)\.md" "$path" >/dev/null 2>&1; then
		echo "FAIL: development-history identifier in $path"; fail=1
	fi
done
for skill in highway-profile highway-setup; do
	if ! grep -Eq '^  version: [0-9]+\.[0-9]+\.[0-9]+$' "$HIGHWAY_ROOT/skills/$skill/SKILL.md"; then
		echo "FAIL: malformed metadata.version in $skill"; fail=1
	fi
done
if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: runtime contract hygiene passes'
