#!/usr/bin/env bash
# Verifies Feature 092 source/dependent inventory and generated correspondence evidence.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
INVENTORY="$SCRIPT_DIR/fixtures/profile-092/dependent-artifact-inventory.tsv"
IMPACT="$SCRIPT_DIR/fixtures/profile-092/impact-review.tsv"
fail=0
for file in "$INVENTORY" "$IMPACT"; do [[ -s "$file" ]] || { echo "FAIL: missing evidence file $file"; fail=1; }; done
for token in generate-agent-adapters.sh generate-catalog.sh generate-library-catalog.sh PASS; do
	grep -Fq "$token" "$INVENTORY" || { echo "FAIL: inventory missing $token"; fail=1; }
done
for file in "$HIGHWAY_ROOT/tools/.adapter-manifest" "$HIGHWAY_ROOT/tools/.distribution-manifest" "$HIGHWAY_ROOT/catalog/index.json" "$HIGHWAY_ROOT/catalog/library-index.json"; do
	[[ -f "$file" ]] || { echo "FAIL: generated dependent missing $file"; fail=1; }
done
if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: Feature 092 correspondence evidence passes'
