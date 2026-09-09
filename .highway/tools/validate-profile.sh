#!/usr/bin/env bash
# Validates the structural contract of the pure-YAML profile without judging user-owned values.
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

if grep -Eq '^---[[:space:]]*$' "$profile_file"; then
	collect "ERROR: [FRONTMATTER] pure-YAML profile must not contain document delimiters"
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

required_sections="organization constraints strategic_directions preferences business_context architecture_principles approved_technologies prohibited_technologies operating_model vendor_strategy"
for section in $required_sections; do
	if ! grep -Eq "^${section}:[[:space:]]*" "$profile_file"; then
		collect "ERROR: [STRUCTURE] required section '$section' must be present as a mapping"
	fi
done

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
