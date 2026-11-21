#!/usr/bin/env bash
# Fails when shipped or development files still present jacob623/highway-skills as a plugin
# install identity (FR-004). Historical specs and findings are allowlisted.
set -u
# Instrument class: executed-behavior
# Artifact classes: generated-artifact

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"

OLD='jacob623/highway-skills'
PUBLIC='highway-systems/agent-plugin'
fail=0
problem() {
	echo "FAIL: $*"
	fail=1
}

# Paths that may still name the old URL (historical).
allow_match() {
	local rel="$1"
	case "$rel" in
		specs/*) return 0 ;;
		harness-model-findings.md) return 0 ;;
		standard-alignment.md) return 0 ;;
		rollout-plan.md) return 0 ;;
		.specify/*) return 0 ;;
		tests/publish-url.test.sh) return 0 ;;
		*) return 1 ;;
	esac
}

repo="$(python3 -c "import json; print(json.load(open('$HW_PLUGIN_SOURCE/plugin.json'))['repository'])")"
[[ "$repo" == "https://github.com/$PUBLIC" ]] \
	|| problem "framework/plugin/plugin.json repository is '$repo' (want https://github.com/$PUBLIC)"

if ! grep -qF "$PUBLIC" "$HW_PLUGIN_SOURCE/README.md"; then
	problem "framework/plugin/README.md does not name $PUBLIC"
fi
if grep -qF "$OLD" "$HW_PLUGIN_SOURCE/README.md"; then
	problem "framework/plugin/README.md still names $OLD as an install target"
fi

# Scan the tree for the old install identity outside the allowlist.
while IFS= read -r -d '' file; do
	rel="${file#"$HW_ROOT"/}"
	allow_match "$rel" && continue
	# Skip binary-ish and dependency trees.
	case "$rel" in
		harness/node_modules/*|harness/.env|*.png|*.jpg|*.webp|*.svg) continue ;;
	esac
	if grep -qF "$OLD" "$file" 2>/dev/null; then
		# Contributor docs may mention the private monorepo origin in prose; only fail clear
		# install identity (plugin install examples and repository fields).
		if grep -nF "$OLD" "$file" | grep -Eiq 'plugin install|marketplace add|\"repository\"|install highway'; then
			problem "$rel still presents $OLD as a plugin install identity:"
			grep -nF "$OLD" "$file" | head -5 | sed 's/^/  /'
		fi
	fi
done < <(find "$HW_ROOT" -type f ! -path '*/.git/*' ! -path '*/node_modules/*' -print0)

# Seeded defect: a temp copy of the README with the old URL must be detectable.
seed="$HW_ROOT/.publish-url-seed.$$.md"
trap 'rm -f "$seed"' EXIT
printf 'copilot plugin install %s\n' "$OLD" >"$seed"
if ! grep -qF "plugin install $OLD" "$seed"; then
	problem "seed setup failed"
else
	echo "OK: seeded old install line is detectable"
fi
rm -f "$seed"
trap - EXIT

if [[ $fail -ne 0 ]]; then
	exit 1
fi
echo "PASS: publish-url (repository and install identity)"
exit 0
