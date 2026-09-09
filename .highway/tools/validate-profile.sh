#!/usr/bin/env bash
# Validates the structural contract of .highway/profile.yaml without judging user-owned values.
set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=tools/lib/profile.sh
source "$SCRIPT_DIR/lib/profile.sh"

if [[ $# -ne 1 ]]; then
	echo "ERROR: [SCHEMA] usage: .highway/tools/validate-profile.sh <profile-file>" >&2
	exit 1
fi

profile_file="$1"
if [[ ! -f "$profile_file" ]]; then
	echo "ERROR: [SCHEMA] no profile found at '$profile_file'" >&2
	exit 1
fi

errors=""
collect() {
	local message="$1"
	errors="${errors}${message}"$'\n'
}

first_line="$(head -n 1 "$profile_file")"
if [[ "$first_line" != "---" ]]; then
	collect "ERROR: [FRONTMATTER] profile must begin with YAML frontmatter"
fi

delimiters="$(grep -c '^---[[:space:]]*$' "$profile_file" 2>/dev/null | tr -d ' ')"
if [[ "$delimiters" -lt 2 ]]; then
	collect "ERROR: [FRONTMATTER] profile must have opening and closing delimiters"
fi

if [[ "$delimiters" -ge 2 ]]; then
	if [[ -n "$(profile_body "$profile_file" | sed '/^[[:space:]]*$/d')" ]]; then
		collect "ERROR: [FRONTMATTER] profile content must remain inside the frontmatter document"
	fi
fi

keys="$(profile_top_level_keys "$profile_file")"
first_key="$(printf '%s\n' "$keys" | sed '/^[[:space:]]*$/d' | head -n 1)"
if [[ "$first_key" != "metadata" ]]; then
	collect "ERROR: [STRUCTURE] metadata must be the first top-level section"
fi

if [[ -z "$(profile_metadata_field "$profile_file" version)" ]]; then
	collect "ERROR: [METADATA] metadata.version is required"
else
	version="$(profile_metadata_field "$profile_file" version | sed -e "s/^['\"]//;s/['\"]$//")"
	if ! printf '%s' "$version" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$'; then
		collect "ERROR: [METADATA] metadata.version must be a semantic version"
	fi
fi

if [[ -z "$(profile_metadata_field "$profile_file" description)" ]]; then
	collect "ERROR: [METADATA] metadata.description is required"
fi

duplicates="$(printf '%s\n' "$keys" | sed '/^[[:space:]]*$/d' | sort | uniq -d)"
if [[ -n "$duplicates" ]]; then
	collect "ERROR: [STRUCTURE] duplicate top-level section(s): $(printf '%s' "$duplicates" | tr '\n' ' ' | sed 's/[[:space:]]*$//')"
fi

previous=0
while IFS= read -r key; do
	[[ -z "$key" ]] && continue
	rank="$(profile_key_rank "$key")"
	if [[ "$rank" -eq 0 ]]; then
		collect "ERROR: [STRUCTURE] unsupported top-level section '$key'"
	elif [[ "$rank" -lt "$previous" ]]; then
		collect "ERROR: [STRUCTURE] top-level section '$key' is out of order"
	else
		previous="$rank"
	fi
done <<< "$keys"

empty_sections="$(profile_frontmatter "$profile_file" | awk '
	function report() {
		if (section != "" && optional[section] && content == 0) print section
	}
	BEGIN {
		optional["constraints"] = 1
		optional["strategic_directions"] = 1
		optional["preferences"] = 1
		optional["business_context"] = 1
		optional["architecture_principles"] = 1
		optional["approved_technologies"] = 1
		optional["prohibited_technologies"] = 1
		optional["operating_model"] = 1
		optional["vendor_strategy"] = 1
	}
	{
		if ($0 ~ /^[^[:space:]#][^:]*:/) {
			report()
			section = $0
			sub(/:.*/, "", section)
			content = 0
			next
		}
		if (section != "" && $0 !~ /^[[:space:]]*$/ && $0 !~ /^[[:space:]]*#/) content = 1
	}
	END { report() }
')"
if [[ -n "$empty_sections" ]]; then
	collect "ERROR: [STRUCTURE] empty optional section(s) must be omitted: $(printf '%s' "$empty_sections" | tr '\n' ' ' | sed 's/[[:space:]]*$//')"
fi

generated_keys="$(printf '%s\n' "$keys" | grep -E '^(timestamp|generated_at|random_id|random_identifier)$' || true)"
if [[ -n "$generated_keys" ]]; then
	collect "ERROR: [DETERMINISM] generated-value section(s) are not permitted: $(printf '%s' "$generated_keys" | tr '\n' ' ' | sed 's/[[:space:]]*$//')"
fi

if [[ -n "$errors" ]]; then
	printf '%s' "$errors" >&2
	echo "FAILED: profile '$profile_file' is structurally invalid" >&2
	exit 1
fi

echo "OK: profile '$profile_file' is structurally valid"
