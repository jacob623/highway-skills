#!/usr/bin/env bash
# highway-setup seeds every project catalog; every skill that edits one checks for it on entry and
# never creates it.
set -u
# Instrument class: static-document-contract
# Artifact classes: source-document, development-fixture
# Seeded failure probe: a skill copy with one changed byte in its setup message, a skill copy that
# creates a seeded folder when it is absent, a skeleton holding a placeholder, and a skeleton with
# a column removed each fail this check.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=paths.sh
source "$SCRIPT_DIR/paths.sh"
fail=0
TAB="$(printf '\t')"

INSTRUCTION='When any is absent, emit the message below exactly, stop, and write nothing.'
HEADLINE='**Oops... we need to setup your repository.**'
BODY='Highway needs to gather your organizational preferences and set up your repository. Run /highway-setup to get started.'

# `<skill>\t<files>`: the seeded files each skill confirms, in the order its check names them.
CHECKS="highway-request${TAB}requests/requests.md
highway-discovery${TAB}discoveries/discoveries.md
highway-adr${TAB}adrs/adrs.md architectures/architectures.md
highway-architecture${TAB}adrs/adrs.md architectures/architectures.md
highway-implementation${TAB}implementations/implementations.md implementations/capabilities.md library/coding-standards/codify-platforms.md
highway-onboarding${TAB}adrs/adrs.md architectures/architectures.md implementations/implementations.md implementations/capabilities.md library/coding-standards/codify-platforms.md
highway-codify${TAB}code/code.md code/integrations.md
highway-codify-config${TAB}library/coding-standards/codify-platforms.md library/coding-standards/coding-standards.md
highway-assessment${TAB}library/knowledge/assessment-findings.md"

seeded_paths="$(hw_seeded | cut -f2)"
seeded_assets="$(hw_seeded | cut -f1)"
seeded_folders="$(printf '%s\n' "$seeded_paths" | sed -E 's#/[^/]+$#/#' | sort -u)"

# The block an entry check must be: the check line, the instruction, and the message.
expected_block() {
	local files="$1" list="" f
	for f in $files; do
		list="${list:+$list, }\`$f\`"
	done
	printf 'Before the first question, confirm these seeded files exist: %s.\n%s\n\n%s\n\n%s\n' \
		"$list" "$INSTRUCTION" "$HEADLINE" "$BODY"
}

# The Procedure text before its first `### ` heading.
procedure_head() {
	awk '
		/^## Procedure[[:space:]]*$/ { on = 1; next }
		on && /^(## |### )/ { exit }
		on { print }
	' "$1"
}

# Prints one failure per line for a skill file against its check list.
check_entry() {
	local name="$1" file="$2" files="$3" head block
	head="$(procedure_head "$file")"
	block="$(expected_block "$files")"
	case "$head" in
	*"$block"*) ;;
	*) echo "$name: the entry check before the first step is not exactly the contract block for: $files" ;;
	esac
}

check_no_create() {
	local name="$1" file="$2" folder asset
	while IFS= read -r folder; do
		[[ -n "$folder" ]] || continue
		if grep -Eiq "creat(e|ing) \`$folder\` when it is absent" "$file"; then
			echo "$name: creates the seeded folder $folder when it is absent"
		fi
	done <<EOF
$seeded_folders
EOF
	while IFS= read -r asset; do
		[[ -n "$asset" ]] || continue
		if grep -Fq "templates/output/$asset" "$file"; then
			echo "$name: writes a seeded file from the retired template $asset"
		fi
	done <<EOF
$seeded_assets
EOF
	if grep -Eiq 'when the catalog is absent, create' "$file"; then
		echo "$name: creates a seeded catalog when it is absent"
	fi
}

outputs_section() {
	awk '
		/^## Outputs[[:space:]]*$/ { on = 1; next }
		on && /^## / { exit }
		on { print }
	' "$1"
}

report() {
	local out="$1"
	[[ -n "$out" ]] || return 0
	printf 'FAIL: %s\n' "$out" | sed '2,$s/^/FAIL: /'
	fail=1
}

# 1. Every listed skill holds its exact check and no create step.
while IFS="$TAB" read -r skill files; do
	file="$HW_SKILLS/$skill/SKILL.md"
	if [[ ! -f "$file" ]]; then
		report "$skill: no SKILL.md"
		continue
	fi
	report "$(check_entry "$skill" "$file" "$files")"
	report "$(check_no_create "$skill" "$file")"
done <<EOF
$CHECKS
EOF

# 2. No other skill names a seeded file in its Outputs, except highway-setup, which seeds them.
listed="$(printf '%s\n' "$CHECKS" | cut -f1)"
for dir in "$HW_SKILLS"/*/; do
	skill="$(basename "$dir")"
	[[ -f "$dir/SKILL.md" ]] || continue
	[[ "$skill" == highway-setup ]] && continue
	printf '%s\n' "$listed" | grep -Fqx "$skill" && continue
	outputs="$(outputs_section "$dir/SKILL.md")"
	while IFS= read -r p; do
		[[ -n "$p" ]] || continue
		case "$outputs" in
		*"$p"*) report "$skill: names the seeded file $p in its Outputs" ;;
		esac
	done <<EOF
$seeded_paths
EOF
done

# 3. Every asset is present, and a catalog skeleton holds no placeholder and no data row.
skeleton_defects() {
	awk '
		/</ { print "holds a placeholder: " $0 }
		/^\|/ {
			if (sep) print "holds a data row: " $0
			if ($0 ~ /^\|[ \t:|-]+\|[ \t]*$/ && $0 ~ /-/) sep = 1
		}
	' "$1"
}
# A skeleton must match its reference copy byte for byte; edit both together to change one on purpose.
REFERENCES="$HW_FIXTURES/catalog-seeding/skeletons"
skeleton_drift() {
	local asset="$1" file="$2" ref="$REFERENCES/$1" lines
	if [[ ! -f "$ref" ]]; then
		echo "$asset: no reference copy"
		return
	fi
	if ! lines="$(diff "$ref" "$file")"; then
		echo "$asset: differs from its reference copy"
		printf '%s\n' "$lines" | grep -E '^[<>]'
	fi
}
while IFS="$TAB" read -r asset path; do
	a="$HW_SETUP/assets/$asset"
	if [[ ! -f "$a" ]]; then
		report "highway-setup: no asset $asset for $path"
		continue
	fi
	report "$(skeleton_defects "$a" | sed "s#^#$asset: #")"
	report "$(skeleton_drift "$asset" "$a")"
done <<EOF
$(hw_seeded)
EOF
if [[ "$(hw_seeded | grep -c .)" -ne 12 ]]; then
	report "hw_seeded lists $(hw_seeded | grep -c .) files, not 12"
fi
storage="$(hw_template storage)"
if ! grep -qx 'Mode: Local' "$storage"; then
	report "storage.md: does not say Mode: Local"
fi

# 4. The checks above can fail.
probe_dir="$(mktemp -d)"
trap 'rm -rf "$probe_dir"' EXIT
src="$HW_SKILLS/highway-request/SKILL.md"
sed 's/Oops\.\.\. we need/Oops... we needs/' "$src" >"$probe_dir/byte.md"
if [[ -z "$(check_entry probe "$probe_dir/byte.md" requests/requests.md)" ]]; then
	report "probe: a one-byte change to the setup message was not caught"
fi
{ cat "$src"; printf '\nCreate `requests/` when it is absent.\n'; } >"$probe_dir/create.md"
if [[ -z "$(check_no_create probe "$probe_dir/create.md")" ]]; then
	report "probe: a create-when-absent step was not caught"
fi
{ cat "$(hw_template request-catalog)"; printf '| <ID> | <Title> | <Status> |\n'; } >"$probe_dir/skeleton.md"
if [[ -z "$(skeleton_defects "$probe_dir/skeleton.md")" ]]; then
	report "probe: a skeleton placeholder row was not caught"
fi
sed -E 's/ Status \|$//; s/--------\|$//' "$(hw_template request-catalog)" >"$probe_dir/request-catalog.md"
if [[ -z "$(skeleton_drift request-catalog.md "$probe_dir/request-catalog.md")" ]]; then
	report "probe: a skeleton with its Status column removed was not caught"
fi

if [[ "$fail" -ne 0 ]]; then
	exit 1
fi
echo 'PASS: catalog seeding and entry checks'
