#!/usr/bin/env bash
# Verifies shared output-template governance for Feature 022.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HIGHWAY_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
CONSTITUTION="$HIGHWAY_ROOT/governance/constitution.md"
EXPERIENCE="$HIGHWAY_ROOT/governance/experience-standard.md"
DEV_DIR=".spec""ify"
DEV_CONSTITUTION="$(cd "$HIGHWAY_ROOT/.." && pwd)/$DEV_DIR/memory/constitution.md"
RULE_CHECKS="$HIGHWAY_ROOT/tools/lib/rule-checks.sh"
NFR_SKILL="$HIGHWAY_ROOT/skills/highway-nfrs/SKILL.md"
CONTROL_SKILL="$HIGHWAY_ROOT/skills/highway-controls/SKILL.md"
NFR_TEMPLATE="$HIGHWAY_ROOT/library/templates/output/nfr-record.md"
CONTROL_TEMPLATE="$HIGHWAY_ROOT/library/templates/output/control-record.md"
PROFILE_SKILL="$HIGHWAY_ROOT/skills/highway-profile/SKILL.md"
PROFILE_TEMPLATE="$HIGHWAY_ROOT/library/templates/output/highway-profile.md"
VALIDATE_LIBRARY="$HIGHWAY_ROOT/tools/validate-library.sh"
VALIDATE_SKILL="$HIGHWAY_ROOT/tools/validate-skill.sh"

fail=0

require_text() {
	local file="$1" text="$2"
	if ! grep -Fq "$text" "$file"; then
		echo "FAIL: '$text' missing from $file"
		fail=1
	fi
}

require_file() {
	local file="$1"
	if [[ ! -f "$file" ]]; then
		echo "FAIL: expected file does not exist: $file"
		fail=1
	fi
}

# Governance rules and the P9.1 registered check must be present before validation is trusted.
require_text "$CONSTITUTION" "| P9.1 |"
require_text "$EXPERIENCE" "| X1.5 |"
require_text "$DEV_CONSTITUTION" "| D8.1 |"
require_text "$RULE_CHECKS" "P9.1"

# Both retained output types need complete shared skeletons.
require_file "$NFR_TEMPLATE"
require_file "$CONTROL_TEMPLATE"
require_file "$PROFILE_TEMPLATE"
if [[ -f "$NFR_TEMPLATE" ]]; then
	require_text "$NFR_TEMPLATE" "name: nfr-record"
	require_text "$NFR_TEMPLATE" "id: NFRXXXXXX"
	require_text "$NFR_TEMPLATE" "controls: []"
	require_text "$NFR_TEMPLATE" "status: active"
	require_text "$NFR_TEMPLATE" "## File Frontmatter"
	require_text "$NFR_TEMPLATE" "## Body"
	require_text "$NFR_TEMPLATE" "<user-provided statement>"
	require_text "$NFR_TEMPLATE" "<user-provided rationale>"
fi
if [[ -f "$CONTROL_TEMPLATE" ]]; then
	require_text "$CONTROL_TEMPLATE" "name: control-record"
	require_text "$CONTROL_TEMPLATE" "id: CTLXXXXXX"
	require_text "$CONTROL_TEMPLATE" "nfrs: []"
	require_text "$CONTROL_TEMPLATE" "status: active"
	require_text "$CONTROL_TEMPLATE" "## File Frontmatter"
	require_text "$CONTROL_TEMPLATE" "## Body"
	require_text "$CONTROL_TEMPLATE" "<user-provided statement>"
	require_text "$CONTROL_TEMPLATE" "<user-provided rationale>"
fi
if [[ -f "$PROFILE_TEMPLATE" ]]; then
	require_text "$PROFILE_TEMPLATE" "name: highway-profile"
	require_text "$PROFILE_TEMPLATE" "metadata:"
	require_text "$PROFILE_TEMPLATE" "constraints:"
	require_text "$PROFILE_TEMPLATE" "preferences:"
fi

# Each file-emitting skill must cite its complete skeleton.
require_text "$NFR_SKILL" ".highway/library/templates/output/nfr-record.md"
require_text "$CONTROL_SKILL" ".highway/library/templates/output/control-record.md"
require_text "$PROFILE_SKILL" ".highway/library/templates/output/highway-profile.md"
require_text "$NFR_SKILL" "version: 1.0.1"
require_text "$CONTROL_SKILL" "version: 1.0.1"

# The citation is the structure authority; these duplicated field/body declarations must be gone.
if grep -Eq 'with YAML frontmatter for `id`, `title`, `status`, and `controls: \[\]`' "$NFR_SKILL"; then
	echo "FAIL: highway-nfrs still duplicates the output frontmatter contract"
	fail=1
fi
if grep -Eq 'carrying frontmatter with `id`,[[:space:]]*$' "$CONTROL_SKILL"; then
	echo "FAIL: highway-controls still duplicates the output frontmatter contract"
	fail=1
fi

# Library and skill validators must accept the migrated source artifacts.
if [[ -f "$NFR_TEMPLATE" ]]; then
	if ! "$VALIDATE_LIBRARY" "$NFR_TEMPLATE" >/dev/null 2>&1; then
		echo "FAIL: NFR output template does not pass validate-library.sh"
		fail=1
	fi
fi
if [[ -f "$CONTROL_TEMPLATE" ]]; then
	if ! "$VALIDATE_LIBRARY" "$CONTROL_TEMPLATE" >/dev/null 2>&1; then
		echo "FAIL: Control output template does not pass validate-library.sh"
		fail=1
	fi
fi
if ! "$VALIDATE_SKILL" "$HIGHWAY_ROOT/skills/highway-nfrs" >/dev/null 2>&1; then
	echo "FAIL: highway-nfrs does not pass validate-skill.sh"
	fail=1
fi
if ! "$VALIDATE_SKILL" "$HIGHWAY_ROOT/skills/highway-controls" >/dev/null 2>&1; then
	echo "FAIL: highway-controls does not pass validate-skill.sh"
	fail=1
fi

# The two current skills are the complete set of citing skills for this feature.
citing_count="$(grep -RIl 'library/templates/output/' "$HIGHWAY_ROOT/skills" --include='SKILL.md' | wc -l | tr -d ' ')"
if [[ "$citing_count" != "3" ]]; then
	echo "FAIL: expected 3 output-template citing skills, found $citing_count"
	fail=1
fi
for citing_skill in "$NFR_SKILL" "$CONTROL_SKILL" "$PROFILE_SKILL"; do
	if ! grep -Fq "library/templates/output/" "$citing_skill"; then
		echo "FAIL: dependent review omitted citing skill $citing_skill"
		fail=1
	fi
done

exit "$fail"
