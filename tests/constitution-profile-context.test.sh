#!/usr/bin/env bash
# Verifies synchronized Repository Context governance language.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"
fail=0
for token in 'Repository Context' 'highway-identity.md' 'profile.md'; do
	grep -Fq "$token" "$(hw_doc constitution)" || { echo "FAIL: constitution missing $token"; fail=1; }
done
for token in '## Purpose' '## What Highway Is' '## User Experience'; do
	grep -Fq "$token" "$(hw_doc highway-identity)" || { echo "FAIL: identity knowledge missing $token"; fail=1; }
done
if grep -Fq '5. Repository governance artifacts' "$(hw_doc highway-identity)"; then
	echo 'FAIL: governance artifacts must not be listed as a fifth Repository Context Document'
	fail=1
fi
if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: constitutional Profile context contract passes'
