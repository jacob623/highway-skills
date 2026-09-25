#!/usr/bin/env bash
# Verifies the interaction-wide X2.3 amendment and version record.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
fail=0
for token in '1.6.1 -> 2.0.0 (MAJOR)' 'Every user-visible response excludes Implementation details unless requested.' 'X2.7' 'X2.8' 'X2.9' 'X2.10'; do
	grep -Fq "$token" "$HIGHWAY_ROOT/governance/experience-standard.md" || { echo "FAIL: Experience Standard missing $token"; fail=1; }
done
if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: Experience Standard amendment passes'
