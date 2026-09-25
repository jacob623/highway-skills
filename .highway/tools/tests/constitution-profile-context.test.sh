#!/usr/bin/env bash
# Verifies synchronized Repository Context governance language.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
fail=0
for token in 'Repository Context' 'highway-identity.md' 'highway-vision.md' 'highway-platform-objectives.md'; do
	grep -Fq "$token" "$HIGHWAY_ROOT/governance/constitution.md" || { echo "FAIL: constitution missing $token"; fail=1; }
done
for token in 'behavioral guidance' 'strategic direction' 'evaluation criteria'; do
	grep -Fq "$token" "$HIGHWAY_ROOT/library/knowledge/highway-identity.md" || { echo "FAIL: identity knowledge missing $token"; fail=1; }
done
if grep -Fq '5. Repository governance artifacts' "$HIGHWAY_ROOT/library/knowledge/highway-identity.md"; then
	echo 'FAIL: governance artifacts must not be listed as a fifth Repository Context Document'
	fail=1
fi
if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: constitutional Profile context contract passes'
