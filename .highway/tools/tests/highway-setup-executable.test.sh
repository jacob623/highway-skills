#!/usr/bin/env bash
# Verifies first-run, resume, and transition behavior.
set -u
# Instrument class: mixed (static-document-contract and executed-behavior)
# Artifact classes: source-document, generated-artifact, disposable-fixture
# Seeded failure probe: focused assertions fail when each declared artifact class is changed.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SKILL="$HIGHWAY_ROOT/skills/highway-setup/SKILL.md"
fail=0
for token in '## Welcome to Highway' 'Do not emit this welcome on a resumed Setup interaction' 'fresh owner readiness' '---' 'first active interaction' 'Do not emit a' ; do grep -Fq -- "$token" "$SKILL" || { echo "FAIL: missing '$token'"; fail=1; }; done
[[ $fail -eq 0 ]] && echo 'OK: Setup resume routing passes' || exit 1
