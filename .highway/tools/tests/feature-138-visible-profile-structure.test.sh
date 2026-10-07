#!/usr/bin/env bash
# Verifies current visible Profile structure and source-generated correspondence.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document, generated-artifact

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
REPO_ROOT="$(cd "$HIGHWAY_ROOT/.." && pwd)"
TEMPLATE="$HIGHWAY_ROOT/library/templates/output/profile-record.md"
EMPTY="$SCRIPT_DIR/fixtures/profile-092/profile-record/empty.md"
PROFILE="$HIGHWAY_ROOT/skills/highway-profile/SKILL.md"
VALIDATE="$HIGHWAY_ROOT/tools/validate-profile.sh"
fail=0

require_text() {
	local file="$1" text="$2"
	if ! grep -Fq -- "$text" "$file"; then
		echo "FAIL: $file missing '$text'"
		fail=1
	fi
}

require_absent() {
	local file="$1" text="$2"
	if grep -Fq -- "$text" "$file"; then
		echo "FAIL: $file contains forbidden '$text'"
		fail=1
	fi
}

for text in \
	'Complete output skeleton for retained organizational Profile evidence.' \
	'version: 3.1.0' \
	'schema_version: 3.0.0' \
	'## Who We Are' \
	'## Where We'
	do
	require_text "$TEMPLATE" "$text"
done

if "$VALIDATE" "$TEMPLATE" >/dev/null 2>&1; then
	echo 'FAIL: skeleton template was accepted as a retained Profile'
	fail=1
fi
if ! "$VALIDATE" "$EMPTY" >/dev/null 2>&1; then
	echo 'FAIL: retained empty Profile fixture was rejected'
	fail=1
fi

for text in \
	'version: 9.0.0' \
	'The retained artifact is `.highway/library/knowledge/profile.md`.' \
	'### Domain model' \
	'### Domain completeness' \
	'#### Identity' \
	'#### Vision' \
	'#### Competitive Path' \
	'#### Guiding Principles' \
	'### Cross-domain reasoning' \
	'Acceptance authorizes the mutation but is not successful persistence.' \
	; do
	require_text "$PROFILE" "$text"
done

for forbidden in 'schema 2.0.0' 'obsolete YAML' '## Clarifications' '<br>' '## Who We Are'; do
	require_absent "$PROFILE" "$forbidden"
done

for generated in \
	.agents/skills/highway-profile/SKILL.md \
	.claude/skills/highway-profile/SKILL.md \
	.github/skills/highway-profile/SKILL.md \
	.cursor/skills/highway-profile/SKILL.md; do
	if [[ ! -f "$REPO_ROOT/$generated" ]] || ! cmp -s "$PROFILE" "$REPO_ROOT/$generated"; then
		echo "FAIL: generated Profile adapter is stale: $generated"
		fail=1
	fi
done

if [[ $fail -ne 0 ]]; then exit 1; fi
echo 'OK: Feature 138 visible Profile structure contract passes'